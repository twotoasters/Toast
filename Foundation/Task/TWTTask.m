//
//  TWTTask.m
//  Task
//
//  Created by Prachi Gauriar on 10/11/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TWTTask.h"

#import "TWTTask+Private.h"
#import "TWTTaskGraph.h"


#pragma mark Constants and Functions

NSString *const TWTTaskErrorDomain = @"TWTTaskErrorDomain";

/*!
 @abstract Returns a string representation of the specified task state.
 @param state The task state.
 @result A string describing the specified task state. If the task state is unknown, returns nil.
 */
static inline NSString *const TWTTaskStateDescription(TWTTaskState state)
{
    switch (state) {
        case TWTTaskStatePending:
            return @"pending";
        case TWTTaskStateReady:
            return @"ready";
        case TWTTaskStateExecuting:
            return @"executing";
        case TWTTaskStateCancelled:
            return @"cancelled";
        case TWTTaskStateFinished:
            return @"finished";
        case TWTTaskStateFailed:
            return @"failed";
        default:
            return nil;
    }
}


#pragma mark -

@interface TWTTask ()

@property (nonatomic, weak, readwrite) TWTTaskGraph *graph;

@property (nonatomic, strong, readwrite) NSDate *finishDate;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, strong, readwrite) id result;

/*!
 @abstract A lock to control changes to task state.
 @discussion This lock is only used within -transitionFromStateInSet:toState:andExecuteBlock:.
 */
@property (nonatomic, strong, readonly) NSLock *stateLock;

/*!
 @abstract If the receiver’s state is in the specified set of from-states, transitions to the specified
     to-state and executes the block.
 @param validFromStates The set of states from which the receiver can transition.
 @param toState The state to which the receiver will transition.
 @param block A block of code to execute after the state transition is completed successfully.
 */
- (void)transitionFromStateInSet:(NSSet *)validFromStates toState:(TWTTaskState)toState andExecuteBlock:(void (^)(void))block;

/*!
 @abstract If the receiver’s state is the specified from-state, transitions to the specified to-state 
     and executes the block.
 @param fromState The state from which the receiver can transition.
 @param toState The state to which the receiver will transition.
 @param block A block of code to execute after the state transition is completed successfully.
 */
- (void)transitionFromState:(TWTTaskState)fromState toState:(TWTTaskState)toState andExecuteBlock:(void (^)(void))block;

/*!
 @abstract Returns whether all the receiver’s prerequisite tasks have finished successfully.
 @result Whether all the receiver’s prerequisite tasks have finished successfully.
 */
- (BOOL)allPrerequisiteTasksFinished;

/*!
 @abstract If all the receiver’s prerequisite tasks have finished successfully, transitions from 
     pending to ready and starts the task.
 */
- (void)startIfReady;

@end


#pragma mark -

@implementation TWTTask

- (instancetype)init
{
    return [self initWithName:nil];
}


- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        if (!name) {
            name = [[NSString alloc] initWithFormat:@"TWTTask %p", self];
        }

        _name = [name copy];
        _state = TWTTaskStateReady;
        _stateLock = [[NSLock alloc] init];
    }

    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p name = %@; state = %@>", self.class, self, self.name, TWTTaskStateDescription(self.state)];
}


- (NSString *)debugDescription
{
    return [self recursiveDescriptionWithDepth:0];
}


- (NSString *)prefixedDescriptionWithDepth:(NSUInteger)depth
{
    static NSString *const kPrefix = @"   | ";

    NSMutableString *prefixString = [[NSMutableString alloc] initWithCapacity:depth * kPrefix.length];
    for (NSUInteger i = 0; i < depth; ++i) {
        [prefixString appendString:kPrefix];
    }

    return [prefixString stringByAppendingString:[self description]];
}


- (NSString *)recursiveDescriptionWithDepth:(NSUInteger)depth
{
    NSMutableArray *descriptions = [[NSMutableArray alloc] initWithObjects:[self prefixedDescriptionWithDepth:depth], nil];

    for (TWTTask *task in self.dependentTasks) {
        [descriptions addObject:[task recursiveDescriptionWithDepth:depth + 1]];
    }

    return [descriptions componentsJoinedByString:@"\n"];
}


- (NSSet *)prerequisiteTasks
{
    return [self.graph prerequisiteTasksForTask:self];
}


- (NSSet *)dependentTasks
{
    return [self.graph dependentTasksForTask:self];
}


#pragma mark - States

+ (BOOL)automaticallyNotifiesObserversOfState
{
    // This avoids a deadlock condition in -transitionFromStateInSet:toState:andExecuteBlock: in
    // which the stateLock is locked, but KVO observers are notified of the change before the lock
    // can be unlocked. This is a problem when, e.g., upon task failure, a KVO observer is notified
    // on the same thread as the aforementioned method. If the KVO observer immediately sends the
    // task -retry, that message will result in -transitionFromStateInSet:toState:andExecuteBlock:
    // being invoked again before the stateLock from the original invocation can be unlocked, thus
    // resulting in deadlock.
    return NO;
}


+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key
{
    static NSSet *stateKeys = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stateKeys = [NSSet setWithObjects:@"ready", @"executing", @"cancelled", @"finished", @"failed", nil];
    });

    return [stateKeys containsObject:key] ? [NSSet setWithObject:@"state"] : [super keyPathsForValuesAffectingValueForKey:key];
}


- (BOOL)isReady
{
    return self.state == TWTTaskStateReady;
}


- (BOOL)isExecuting
{
    return self.state == TWTTaskStateExecuting;
}


- (BOOL)isCancelled
{
    return self.state == TWTTaskStateCancelled;
}


- (BOOL)isFinished
{
    return self.state == TWTTaskStateFinished;
}


- (BOOL)isFailed
{
    return self.state == TWTTaskStateFailed;
}


- (void)transitionFromStateInSet:(NSSet *)validFromStates toState:(TWTTaskState)toState andExecuteBlock:(void (^)(void))block
{
    NSParameterAssert(validFromStates);

    // State transitions:
    //     Pending -> Ready: All of task’s prerequisite tasks are finished (-startIfReady)
    //     Pending -> Cancelled: Task is cancelled (-cancel)
    //
    //     Ready -> Pending: Task is added to a graph with at least one prerequisite task (-didAddPrerequisiteTask)
    //     Ready -> Executing: Task starts (-start)
    //     Ready -> Cancelled: Task is cancelled (-cancel)
    //
    //     Executing -> Cancelled: Task is cancelled (-cancel)
    //     Executing -> Finished: Task finishes (-finishWithResult:)
    //     Executing -> Failed: Task fails (-failWithError:)
    //
    //     Cancelled -> Pending: Task is retried (-retry)
    //     Cancelled -> Finished: Task is cancelled while executing but finishes anyway (-finishWithResult:)
    //     Cancelled -> Failed: Task is cancelled while executing but fails anyway (-failWithError:)
    //
    //     Finished -> (none): Finished is a terminal state
    //
    //     Failed -> Pending: Task is retried (-retry)

    // Get the state lock. If the current state is not in the set of valid from-states, just unlock
    // and return.
    [self.stateLock lock];
    if (![validFromStates containsObject:@(self.state)]) {
        [self.stateLock unlock];
        return;
    }

    // Otherwise, if the from-state and the to-state differ, change the state. Do not use the
    // built-in accessor, as that will trigger KVO notifications, which we do not want. See the
    // explanatory comments in +automaticallyNotifiesObserversOfState.
    TWTTaskState fromState = self.state;
    if (fromState != toState) {
        [self willChangeValueForKey:@"state"];
        _state = toState;
    }

    // Only after we have unlocked the state lock should we mark the state as changed
    [self.stateLock unlock];
    if (fromState != toState) {
        [self didChangeValueForKey:@"state"];
    }

    // Only once all KVO notifications have fired should we execute the block
    if (block) {
        block();
    }
}


- (void)transitionFromState:(TWTTaskState)fromState toState:(TWTTaskState)toState andExecuteBlock:(void (^)(void))block
{
    [self transitionFromStateInSet:[NSSet setWithObject:@(fromState)] toState:toState andExecuteBlock:block];
}


- (void)didAddPrerequisiteTask
{
    [self transitionFromState:TWTTaskStateReady toState:TWTTaskStatePending andExecuteBlock:nil];
}


#pragma mark - Execution

- (void)main
{
    [self finishWithResult:nil];
}


- (void)start
{
    NSAssert(self.graph, @"Tasks must be in a graph before they can be started");

    // Because the operation queue is asynchronous, we need to be sure to do the state transition
    // after the operation starts executing. The alternative of adding the operation inside of the
    // state transition’s block could lead to a weird situation in which -main is invoked, but the
    // task has already been marked cancelled. This shouldn’t be an issue, since -main should be
    // checking if the task is cancelled and exiting as soon as possible, but that’s not always
    // possible. Doing the check inside the operation’s block before invoking -main avoids that.
    [self.graph.operationQueue addOperationWithBlock:^{
        [self transitionFromState:TWTTaskStateReady toState:TWTTaskStateExecuting andExecuteBlock:^{
            [self main];
        }];
    }];
}


- (BOOL)allPrerequisiteTasksFinished
{
    for (TWTTask *task in self.prerequisiteTasks) {
        if (!task.isFinished) {
            return NO;
        }
    }

    return YES;
}


- (void)startIfReady
{
    if ([self allPrerequisiteTasksFinished]) {
        [self transitionFromState:TWTTaskStatePending toState:TWTTaskStateReady andExecuteBlock:^{
            [self start];
        }];
    }
}


- (void)cancel
{
    static NSSet *fromStates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fromStates = [[NSSet alloc] initWithObjects:@(TWTTaskStatePending), @(TWTTaskStateReady), @(TWTTaskStateExecuting), nil];
    });

    [self transitionFromStateInSet:fromStates toState:TWTTaskStateCancelled andExecuteBlock:nil];
    [self.dependentTasks makeObjectsPerformSelector:@selector(cancel)];
}


- (void)retry
{
    static NSSet *fromStates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fromStates = [[NSSet alloc] initWithObjects:@(TWTTaskStatePending), @(TWTTaskStateReady), @(TWTTaskStateCancelled), @(TWTTaskStateFailed), nil];
    });

    [self transitionFromStateInSet:fromStates toState:TWTTaskStatePending andExecuteBlock:^{
        self.finishDate = nil;
        self.result = nil;
        self.error = nil;
        [self startIfReady];
    }];

    [self.dependentTasks makeObjectsPerformSelector:@selector(retry)];
}


- (void)finishWithResult:(id)result
{
    static NSSet *fromStates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fromStates = [[NSSet alloc] initWithObjects:@(TWTTaskStateExecuting), @(TWTTaskStateCancelled), nil];
    });

    [self transitionFromStateInSet:fromStates toState:TWTTaskStateFinished andExecuteBlock:^{
        self.finishDate = [NSDate date];
        self.result = result;

        if ([self.delegate respondsToSelector:@selector(task:didFinishWithResult:)]) {
            [self.delegate task:self didFinishWithResult:result];
        }

        [self.dependentTasks makeObjectsPerformSelector:@selector(startIfReady)];
    }];
}


- (void)failWithError:(NSError *)error
{
    static NSSet *fromStates = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fromStates = [[NSSet alloc] initWithObjects:@(TWTTaskStateExecuting), @(TWTTaskStateCancelled), nil];
    });

    [self transitionFromStateInSet:fromStates toState:TWTTaskStateFailed andExecuteBlock:^{
        self.finishDate = [NSDate date];
        self.error = error;

        if ([self.delegate respondsToSelector:@selector(task:didFailWithError:)]) {
            [self.delegate task:self didFailWithError:error];
        }
    }];
}

@end

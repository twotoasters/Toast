//
//  TWTTask.h
//  Toast
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

#import <Foundation/Foundation.h>


#pragma mark Constants

/*!
 @abstract TWTTaskState enumerates the various states that a TWTTask can be in.
 */
typedef NS_ENUM(NSUInteger, TWTTaskState) {
    /*! State indicating that the task’s prerequisites have not yet finished successfully. */
    TWTTaskStatePending,

    /*! 
     State indicating that the task’s prerequisites have finished successfully and that the task is
     ready to execute. 
     */
    TWTTaskStateReady,

    /*! State indicating that the task is executing. */
    TWTTaskStateExecuting,

    /*! State indicating that the task was cancelled. */
    TWTTaskStateCancelled,

    /*! State indicating that the task finished successfully. */
    TWTTaskStateFinished,

    /*! State indicating that the task failed. */
    TWTTaskStateFailed
};


#pragma mark - Tasks

@class TWTTaskGraph;
@protocol TWTTaskDelegate;

/*!
 TWTTask objects model units of work that can finish successfully or fail. While similar to
 NSOperations, the additional concepts of success and failure enable a greater range of behavior 
 when executing a series of related tasks.

 For tasks to be useful, they must be added to a task graph — a TWTTaskGraph object. Task graphs
 provide an execution context for tasks and keep track of prerequisite and dependent relationships
 between them. While tasks can be started directly (using -start), they are more typically started
 by sending their graph the -start message, which begins executing all tasks in the graph that have
 no prerequisite tasks. When all of a task’s prerequisite tasks have finished successfully, the task
 will automatically be enqueued for execution. A task cannot be executed until all of its
 prerequisite tasks have completed successfully. If a task fails, it can be retried using the -retry
 message. See the TWTTaskGraph documentation for more information on running tasks.
 
 To make a task perform useful work, you must subclass TWTTask and override -main. Your implementation
 should execute any operations necessary to complete your task, and invoke either -finishWithResult: or
 -failWithError: when complete. TWTTask has two subclasses, TWTBlockTask and TWTSelectorTask, which
 can generally be used as an alternative to subclassing TWTTask yourself. See their respective class
 documentation for more information.
 
 Every TWTTask has an optional delegate that can be informed when a task succeeds or fails. See the
 documentation for TWTTaskDelegate for more information.
 */
@interface TWTTask : NSObject

/*! 
 @abstract The task’s name. 
 @discussion The default value of this property is “TWTTask «id»”, where «id» is the memory address
     of the task. 
 */
@property (nonatomic, copy) NSString *name;

/*! The task’s delegate. */
@property (nonatomic, weak) id<TWTTaskDelegate> delegate;

/*! 
 @abstract The task’s graph. 
 @discussion This property is set when the task is added to a graph. Once a task has been added to a
     graph, it may not be added (or moved) to another graph.
 */
@property (nonatomic, weak, readonly) TWTTaskGraph *graph;

/*!
 @abstract The task’s prerequisite tasks.
 @discussion A task’s prerequisite tasks can only be set when the task is added to a graph via
     -[TWTTaskGraph addTask:prerequisiteTasks:] or -[TWTTaskGraph addTask:prerequisites:]. Until
     then, this property is nil.
     
     This property is not key-value observable.
 */
@property (nonatomic, copy, readonly) NSSet *prerequisiteTasks;

/*!
 @abstract The task’s dependent tasks.
 @discussion A task’s dependent tasks can only be affected when a dependent task is added to a
     graph via -[TWTTaskGraph addTask:prerequisiteTasks:] or -[TWTTaskGraph addTask:prerequisites:].
     If the task is not in a task graph, this property is nil.

     This property is not key-value observable.
 */
@property (nonatomic, copy, readonly) NSSet *dependentTasks;

/*!
 @abstract The task’s state.
 @discussion When a task is created, this property is initialized to TWTTaskStateReady. The value
     changes automatically in response to the state of the task’s graph and its execution state.
 */
@property (nonatomic, assign, readonly) TWTTaskState state;

/*!
 @abstract Whether the task is ready to execute.
 @discussion A task is ready to execute if all of its prerequisite tasks have finished successfully.
 */
@property (nonatomic, assign, readonly, getter=isReady) BOOL ready;

/*! Whether the task is executing. */
@property (nonatomic, assign, readonly, getter=isExecuting) BOOL executing;

/*!
 @abstract Whether the task has been cancelled.
 @discussion Subclasses should periodically check this property during the execution of the -main
     method and quit executing if it is set to YES.
 */
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;

/*! Whether the task finished successfully. */
@property (nonatomic, assign, readonly, getter=isFinished) BOOL finished;

/*! Whether the task failed. */
@property (nonatomic, assign, readonly, getter=isFailed) BOOL failed;

/*!
 @abstract The date at which the task either finished successfully or failed. 
 @discussion This is nil until the task receives either -finishWithResult: or -failWithError:.
 */
@property (nonatomic, strong, readonly) NSDate *finishDate;

/*!
 @abstract The result of the task finishing successfully. 
 @discussion This is nil until the task receives -finishWithResult:, after which it is the value
     of that message’s result parameter.
 */
@property (nonatomic, strong, readonly) id result;

/*!
 @abstract The error that caused the task to fail. 
 @discussion This is nil until the task receives -failWithError:, after which it is the value of
     that message’s error parameter.
 */
@property (nonatomic, strong, readonly) NSError *error;

/*!
 @abstract Initializes a newly created TWTTask instance with the specified name.
 @discussion The task will have an initial state of TWTTaskStateReady and no prerequisite or 
     dependent tasks.
     
     This is the class’s designated initializer.
 @param name The name of the task. If nil, the instance’s name will be set to “TWTTask «id»”, where
     «id» is the memory address of the task.
 @result A newly initialized TWTTask instance with the specified name.
 */
- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

/*!
 @abstract Performs the task’s work.
 @discussion The default implementation of this method simply invokes -finishWithResult: with a nil
     parameter. You should override this method to perform any work necessary to complete your task. 
     In your implementation, do not invoke super. When your work is complete, it is imperative that 
     the receiver be sent either -finishWithResult: or -failWithError:. Failing to do so will 
     prevent dependent tasks from executing.
     
     Subclass implementations of this method should periodically check whether the task has been 
     marked as cancelled and, if so, stop executing at the earliest possible moment.
 */
- (void)main;

/*!
 @abstract Executes the task’s -main method if the task is in the ready state.
 @discussion More accurately, the receiver will enqueue an operation on its graph’s operation queue
     that executes the task’s -main method if and only if the task is ready when the operation is 
     executed. 
     
     Subclasses should not override this method.
 */
- (void)start;

/*!
 @abstract Sets the task’s state to cancelled if it is pending, ready, or executing. 
 @discussion Regardless of the receiver’s state, sends the -cancel message to all of the
     receiver’s dependent tasks.
 
     Note that this only marks the task as cancelled. It is up individual subclasses of TWTTask to
     stop executing when a task is marked as cancelled. See the documentation of -main for more
     information.
     
     Subclasses should not override this method.
 */
- (void)cancel;

/*!
 @abstract Sets the task’s state to pending if it is pending, ready, cancelled or failed, and
     starts the task if its prerequisite tasks have all finished successfully.
 @discussion Regardless of the receiver’s state, sends the -retry message to all of the receiver’s
     dependent tasks.

     Subclasses should not override this method.
 */
- (void)retry;

/*!
 @abstract Sets the task’s state to finished and updates its result and finishDate properties.
 @discussion Subclasses should ensure that this message is sent to the task when the task’s work
     finishes successfully.
 
     If the receiver’s delegate implements -task:didFinishWithResult:, it is sent that message
     after the task’s state is updated.
 @param result An object that represents the result of performing the task’s work. May be nil.
 */
- (void)finishWithResult:(id)result;

/*!
 @abstract Sets the task’s state to failed and updates its error and finishDate properties.
 @discussion Subclasses should ensure that this message is sent to the task when the task’s work
     fails. 

     If the receiver’s delegate implements -task:didFinishWithResult:, it is sent that message
     after the task’s state is updated.
 @param error An error containing the reason for why the task failed. May be nil, though this is
     discouraged.
 */
- (void)failWithError:(NSError *)error;

@end


#pragma mark -

/*!
 TWTBlockTasks perform a task’s work by executing a block. Together with TWTSelectorTask, this 
 obviates the need to subclass TWTTask in most circumstances. 
 */
@interface TWTBlockTask : TWTTask

/*! 
 @abstract The block that performs the task’s work.
 @discussion May not be nil. This block takes the place of a TWTTask’s -main method. As such, the
     block must invoke -finishWithResult: or -failWithError: on the supplied task parameter upon
     success and failure, respectively. Failing to do so will prevent dependent tasks from executing.
     
     This block should also periodically check whether the task has been marked as cancelled and, if
     so, stop executing at the earliest possible moment.
 */
@property (nonatomic, copy, readonly) void (^block)(TWTTask *task);

/*!
 @abstract Initializes a newly created TWTBlockTask instance with the specified block.
 @discussion A default name will be given to the task as specified by TWTTask’s -initWithName:.
 @param block The block that performs the task’s work. May not be nil.
 @result A newly initialized TWTBlockTask instance with the specified block.
 */
- (instancetype)initWithBlock:(void (^)(TWTTask *task))block;

/*!
 @abstract Initializes a newly created TWTBlockTask instance with the specified name and block.
 @discussion This is the class’s designated initializer.
 @param name The name of the task. If nil, a default name will be given to the task as specified by
     TWTTask’s -initWithName:.
 @param block The block that performs the task’s work. May not be nil.
 @result A newly initialized TWTBlockTask instance with the specified name and block.
 */
- (instancetype)initWithName:(NSString *)name block:(void (^)(TWTTask *task))block NS_DESIGNATED_INITIALIZER;

@end


#pragma mark -

/*!
 TWTSelectorTasks perform a task’s work by sending a message to an object. Together with
 TWTBlockTask, this obviates the need to subclass TWTTask in most circumstances. 
 */
@interface TWTSelectorTask : TWTTask

/*!
 @abstract The receiver of the task’s message-send. 
 @discussion May not be nil.
 */
@property (nonatomic, strong, readonly) id target;

/*!
 @abstract The selector that the task’s target performs in order to do the task’s work. 
 @discussion May not be NULL. This selector must take a single parameter of type TWTTask *. 
 
     The method corresponding to this selector takes the place of a TWTTask’s -main method. As such,
     the method must invoke -finishWithResult: or -failWithError: on the supplied task parameter
     upon success and failure, respectively. Failing to do so will prevent dependent tasks from
     executing.
     
     The method should also periodically check whether the task has been marked as cancelled and, if
     so, stop executing at the earliest possible moment.
 */
@property (nonatomic, assign, readonly) SEL selector;

/*!
 @abstract Initializes a newly created TWTSelectorTask instance with the specified target and
     selector.
 @discussion A default name will be given to the task as specified by TWTTask’s -initWithName:.
 @param target The receiver of the task’s message-send. May not be nil.
 @param selector The selector that the task’s target performs in order to do the task’s work. 
     May not be NULL.
 @result A newly initialized TWTSelectorTask instance with the specified target and action.
 */
- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

/*!
 @abstract Initializes a newly created TWTSelectorTask instance with the specified name, target, and
     selector.
 @discussion This is the class’s designated initializer.
 @param name The name of the task. If nil, a default name will be given to the task as specified by
     TWTTask’s -initWithName:.
 @param target The receiver of the task’s message-send. May not be nil.
 @param selector The selector that the task’s target performs in order to do the task’s work. 
     May not be NULL.
 @result A newly initialized TWTSelectorTask instance with the specified name, target, and action.
 */
- (instancetype)initWithName:(NSString *)name target:(id)target selector:(SEL)selector NS_DESIGNATED_INITIALIZER;

@end


#pragma mark - Task Delegate Protocol

/*!
 The TWTTaskDelegate protocol defines an interface via which an task’s delegate can perform 
 specialized actions when the task finishes successfully or fails.
 */
@protocol TWTTaskDelegate <NSObject>

@optional

/*!
 @abstract Sent to the delegate when the specified task finishes successfully.
 @param task The task that finished.
 @param result An object that represents the result of performing the task’s work. May be nil.
 */
- (void)task:(TWTTask *)task didFinishWithResult:(id)result;

/*!
 @abstract Sent to the delegate when the specified task fails.
 @param task The task that failed.
 @param error An error containing the reason for why the task failed. May be nil. 
 */
- (void)task:(TWTTask *)task didFailWithError:(NSError *)error;

@end


#pragma mark - Task Graph

/*!
 Instances of TWTTaskGraph, or simply task graphs, provide execution contexts for tasks and keep
 track of prerequisite and dependent relationships between them. Tasks cannot be executed without
 first being added to a graph. Once a task is added to a graph, it cannot be placed in another
 graph.

 Every task graph has an operation queue on which its tasks -main methods are enqueued.

 Task graphs also have the ability to be started, canceled, or retried, which simply sends the
 appropriate message to those tasks in the graph that have no prerequisites. At that point, the
 messages will propagate throughout the graph.
 */
@interface TWTTaskGraph : NSObject

/*!
 @abstract The task graph’s name.
 @discussion The default value of this property is “TWTTaskGraph «id»”, where «id» is the memory
     address of the task graph.
 */
@property (nonatomic, copy) NSString *name;

/*!
 @abstract The task graph’s operation queue.
 @discussion If no operation queue is provided upon initialization, a queue will be created for the
     task graph with the default quality of service and maximum concurrent operations count. Its name
     will be of the form “com.twotoasters.TWTTaskGraph.«name»”, where «name» is the name of the task
     graph.
 */
@property (nonatomic, strong, readonly) NSOperationQueue *operationQueue;

/*! The task graph’s current set of tasks. */
@property (nonatomic, copy, readonly) NSSet *allTasks;

/*!
 @abstract Initializes a newly created TWTTaskGraph instance with the specified name.
 @discussion A new operation queue will be created for the task graph with the default quality of
     service and maximum concurrent operations count. The queue’s name will be of the form
     “com.twotoasters.TWTTaskGraph.«name»”, where «name» is the name of the task graph.
 @param name The name of the task graph. If nil, the instance’s name will be set to 
     “TWTTaskGraph «id»”, where «id» is the memory address of the task.
 @result A newly initialized TWTTaskGraph instance with the specified name.
 */
- (instancetype)initWithName:(NSString *)name;

/*!
 @abstract Initializes a newly created TWTTaskGraph instance with the specified operation queue.
 @discussion The task graph will have a name of “TWTTaskGraph «id»”, where «id» is the memory
     address of the task graph.
 @param operationQueue The operation queue the graph’s tasks will use to execute their -main
     methods. If nil, a new operation queue will be created for the task graph with the default
     quality of service and maximum concurrent operations count. The queue’s name will be of the
     form “com.twotoasters.TWTTaskGraph.«name»”, where «name» is the name of the task graph.
 @result A newly initialized TWTTaskGraph instance with the specified operation queue.
 */
- (instancetype)initWithOperationQueue:(NSOperationQueue *)operationQueue;

/*!
 @abstract Initializes a newly created TWTTaskGraph instance with the specified name and operation
     queue.
 @discussion This is the class’s designated initializer.
 @param name The name of the task graph. If nil, the instance’s name will be set to 
     “TWTTaskGraph «id»”, where «id» is the memory address of the task.
 @param operationQueue The operation queue the graph’s tasks will use to execute their -main
     methods. If nil, a new operation queue will be created for the task graph with the default
     quality of service and maximum concurrent operations count. The queue’s name will be of the
     form “com.twotoasters.TWTTaskGraph.«name»”, where «name» is the name of the task graph.
 @result A newly initialized TWTTaskGraph instance with the specified name and operation queue.
 */
- (instancetype)initWithName:(NSString *)name operationQueue:(NSOperationQueue *)operationQueue NS_DESIGNATED_INITIALIZER;

/*!
 @abstract Adds the specified task to the task graph with the specified set of prerequisite tasks.
 @discussion The task’s graph property is set to the receiver, and its prerequisite tasks are set 
     to the ones specified. Furthermore, the task is added to each of the prerequisite tasks’ sets
     of dependent tasks. If the task has any prerequisites, its state is set to pending.
 
     This is not a thread-safe operation. This method should only execute on one thread at a time.
 @param task The task to add. May not be nil. May not be a member of any other task graph.
 @param prerequisiteTasks The task’s prerequisite tasks. If nil, the task will have no prerequisite
     tasks. Otherwise, each task in the set must have already been added to the receiver.
 */
- (void)addTask:(TWTTask *)task prerequisiteTasks:(NSSet *)prerequisiteTasks;

/*!
 @abstract Adds the specified task to the task graph with the specified list of prerequisite tasks.
 @discussion The task’s graph property is set to the receiver, and its prerequisite tasks are set 
     to the ones specified. Furthermore, the task is added to each of the prerequisite tasks’ sets
     of dependent tasks. If the task has any prerequisites, its state is set to pending.

     This is not a thread-safe operation. This method should only execute on one thread at a time.
 @param task The task to add. May not be nil. May not be a member of any other task graph.
 @param prerequisiteTask1, ... The task’s prerequisite tasks as a nil-terminated list. Each task in
     the set must have already been added to the receiver.
 */
- (void)addTask:(TWTTask *)task prerequisites:(TWTTask *)prerequisiteTask1, ... NS_REQUIRES_NIL_TERMINATION;

/*!
 @abstract Sends -start to every prerequisite-less task in the receiver. 
 @discussion This serves to begin execution of the tasks in the receiver. After the initial set of 
     tasks finish successfully, they will automatically invoke -start on their dependent tasks and
     so on until all tasks have finished successfully.
 */
- (void)start;

/*!
 @abstract Sends -cancel to every prerequisite-less task in the receiver. 
 @discussion This serves to mark all the tasks in the receiver as cancelled. The initial set of 
     tasks will propagate the cancellation to their dependent tasks and so on until all tasks that
     can be cancelled will be.
 */
- (void)cancel;

/*!
 @abstract Sends -retry to every prerequisite-less task in the receiver. 
 @discussion This serves to retry all the tasks in the receiver that have failed. The initial set of 
     tasks will propagate the retry to their dependent tasks and so on until all tasks that
     can be retried will be.
 */
- (void)retry;

/*!
 @abstract Returns whether the receiver has any unfinished tasks.
 @discussion This is not key-value observable.
 @result Whether the receiver has any unfinished tasks.
 */
- (BOOL)hasUnfinishedTasks;

/*!
 @abstract Returns whether the receiver has any failed tasks.
 @discussion This is not key-value observable.
 @result Whether the receiver has any failed tasks.
 */
- (BOOL)hasFailedTasks;

@end

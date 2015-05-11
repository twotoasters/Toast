//
//  TWTAsynchronousOperation.m
//  Toast
//
//  Created by Duncan Lewis on 6/12/14.
//  Copyright (c) 2015 Ticketmaster.
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

#import "TWTAsynchronousOperation.h"

typedef NS_ENUM(NSUInteger, TWTOperationState) {
    TWTOperationStateReady,
    TWTOperationStateExecuting,
    TWTOperationStateFinished
};

static NSString * TWTKeyFromOperationState(TWTOperationState state) {
    switch (state) {
        case TWTOperationStateReady:
            return @"isReady";
        case TWTOperationStateExecuting:
            return @"isExecuting";
        case TWTOperationStateFinished:
            return @"isFinished";
    }
}

@interface TWTAsynchronousOperation ()

@property (nonatomic, assign) TWTOperationState state;
@property (nonatomic, copy) TWTAsynchronousOperationBlock operationBlock;

@end

@implementation TWTAsynchronousOperation

#pragma mark - NSOperation

- (void)start
{
    self.state = TWTOperationStateExecuting;
    
    if (self.operationBlock) {
        self.operationBlock(self);
    } else {
        [self finishOperationExecution];
    }
}

- (void)finishOperationExecution
{
    self.operationBlock = nil;
    self.state = TWTOperationStateFinished;
}

- (BOOL)isReady
{
    return self.state == TWTOperationStateReady && [super isReady];
}

- (BOOL)isExecuting
{
    return self.state == TWTOperationStateExecuting;
}

- (BOOL)isFinished
{
    return self.state == TWTOperationStateFinished;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (void)setState:(TWTOperationState)state
{
    NSString *oldStateKey = TWTKeyFromOperationState(self.state);
    NSString *newStateKey = TWTKeyFromOperationState(state);
    
    [self willChangeValueForKey:oldStateKey];
    [self willChangeValueForKey:newStateKey];
    _state = state;
    [self didChangeValueForKey:oldStateKey];
    [self didChangeValueForKey:newStateKey];
}

#pragma mark - Init

- (id)initWithOperationBlock:(TWTAsynchronousOperationBlock)operationBlock
{
    self = [super init];
    if (self) {
        _operationBlock = [operationBlock copy];
        _state = TWTOperationStateReady;
    }
    return self;
}

@end

//
//  TWTCompositeAsynchronousTask.m
//  Toast
//
//  Created by Kevin Conner on 7/31/14.
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

#import "TWTCompositeAsynchronousTask.h"

@interface TWTCompositeAsynchronousTask ()

@property (nonatomic, copy) TWTCompositeAsynchronousTaskCompletion completion;
@property (nonatomic, assign) NSInteger lockCount;

@end

@implementation TWTCompositeAsynchronousTask

#pragma mark - Helpers

- (void)retainLock
{
    self.lockCount++;
}

- (void)releaseLock
{
    NSAssert(0 < self.lockCount, @"More tasks were finished than started.");

    self.lockCount--;

    if (self.lockCount == 0) {
        if (self.completion) {
            self.completion(self.context);

            // If for some reason the completion block retained this object, break the cycle.
            self.completion = nil;
        }
    }
}

#pragma mark - Init/dealloc

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lockCount = 1;
    }
    return self;
}

#pragma mark - Public interface

- (void)startTaskWithBlock:(TWTCompositeAsynchronousTaskBlock)task
{
    NSAssert(0 < self.lockCount, @"Tried to start a task after all tasks had completed.");

    if (task) {
        [self retainLock];
        task(self);
    }
}

- (void)taskDidFinish
{
    [self releaseLock];
}

- (void)runToCompletion:(TWTCompositeAsynchronousTaskCompletion)completion
{
    NSParameterAssert(completion);

    self.completion = completion;

    [self releaseLock];
}

@end

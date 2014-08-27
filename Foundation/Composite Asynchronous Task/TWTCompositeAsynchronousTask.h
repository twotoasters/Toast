//
//  TWTCompositeAsynchronousTask.h
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

#import <Foundation/Foundation.h>

@class TWTCompositeAsynchronousTask;

typedef void(^TWTCompositeAsynchronousTaskBlock)(TWTCompositeAsynchronousTask *supertask);
typedef void(^TWTCompositeAsynchronousTaskCompletion)(id context);

// This object is a single-threaded asynchronous task with a completion block.
// Its work is done by multiple asynchronous child tasks.
// So, it is a way to wait for many asynchronous tasks to complete, and then act.

// Use this object only from one thread.
// Use the context object, __block locals, or block-captured references to pass data from tasks to the completion block.

// 1. Create this object.
// 2. Start each task.
//    Tasks should call -taskDidFinish when done.
//    Tasks' asynchronous completion blocks will need to retain this object, so you don't need to otherwise.
// 3. After all tasks are started, call -runToCompletion:.
//    When all tasks complete, the completion block will fire.

@interface TWTCompositeAsynchronousTask : NSObject

@property (nonatomic, strong) id context;

- (instancetype)init;

// The task block will be run immediately.
// It should eventually cause -taskDidFinish to be called on the same thread.
- (void)startTaskWithBlock:(TWTCompositeAsynchronousTaskBlock)task;

// Each task should call this when it completes.
- (void)taskDidFinish;

// Call this when you have started every task.
// completion will be called after each started task calls -taskDidFinish.
- (void)runToCompletion:(TWTCompositeAsynchronousTaskCompletion)completion;

@end

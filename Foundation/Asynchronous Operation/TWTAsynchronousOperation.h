//
//  TWTAsynchronousOperation.h
//  Toast
//
//  Created by Duncan Lewis on 6/12/14.
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

@class TWTAsynchronousOperation;

typedef void (^TWTAsynchronousOperationBlock)(TWTAsynchronousOperation *operation);

@interface TWTAsynchronousOperation : NSOperation

/**
 @abstract Initializes an operation given an operation block to execute.
 
 @param operationBlock The block the operation will execute. See `-[TWTAsynchronousOperation setOperationBlock]` below
 for more details.
 
 @discussion When run, the asynchronous operation executes the developer-provided block, which may perform
 asynchronous tasks. It is the responsibility of the block to invoke 
 `-[TWTAsynchronousOperation finishOperationExecution]` to finish the execution of the operation, usually when the 
 asynchronous task in the block has completed.
 
 It is also recommended (as an optimization) that the block periodically check the
 `-[TWTAsynchronousOperation isCancelled]` flag, and properly abort the execution of its asynchronous task, followed
 by an invocation of `-[TWTAsynchronousOperation finishOperationExecution]` to mark the operation is finished.
 */
- (id)initWithOperationBlock:(TWTAsynchronousOperationBlock)operationBlock;

/**
 @abstract Set the block to be executed by the operation.
 
 @param operationBlock The block the operation will execute.
 
 @discussion The block takes the operation as an argument, so that it may complete the operation's execution by 
 invoking `-[TWTAsynchronousOperation finishOperationExecution]`. The block should make no assumptions about its 
 execution environment.
 */
- (void)setOperationBlock:(TWTAsynchronousOperationBlock)operationBlock;

/**
 @abstract Tells the operation that it has ended execution and should enter the finished state.
 
 @discussion The developer submitted block should invoke this method to tell the operation that the block's 
 asynchronous tasks have been completed, and it may leave the executing state and enter the finished state. The 
 operation will never leave the executing state on its on, and failure by the developer submitted block to invoke this
 method will result in indefinite execution of this operation.
 */
- (void)finishOperationExecution;

@end

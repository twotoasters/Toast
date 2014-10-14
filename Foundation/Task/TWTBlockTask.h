//
//  TWTBlockTask.h
//  Toast
//
//  Created by Prachi Gauriar on 10/14/2014.
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


/*!
 TWTBlockTasks perform a task’s work by executing a block. Together with TWTSelectorTask and 
 TWTExternalConditionTask, this obviates the need to subclass TWTTask in most circumstances.
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

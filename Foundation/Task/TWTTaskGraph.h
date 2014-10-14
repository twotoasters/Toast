//
//  TWTTaskGraph.h
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

#import <Foundation/Foundation.h>


@class TWTTask;

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
 @abstract Returns the set of prerequisite tasks for the specified task.
 @param task The task.
 @result The set of prerequisite tasks for the specified task. Returns nil if the task is not in the
     receiver.
 */
- (NSSet *)prerequisiteTasksForTask:(TWTTask *)task;

/*!
 @abstract Returns the set of dependent tasks for the specified task.
 @param task The task.
 @result The set of dependent tasks for the specified task. Returns nil if the task is not in the
     receiver.
 */
- (NSSet *)dependentTasksForTask:(TWTTask *)task;

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

//
//  TWTConcurrentAccessor.h
//  Toast
//
//  Created by Duncan Lewis on 11/24/15.
//  Copyright © 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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

@import Foundation;


NS_ASSUME_NONNULL_BEGIN

/*!
 TWTConcurrentAccessor instances provide a convenient wrapper for safely accessing an object from multiple threads.
 Internally, it uses the Dispatch Barrier API to allow for multiple simultaneous readers while allowing only a single
 writer. Thankfully, this complexity is hidden behind a simple interface.

 TWTConcurrentAccessors are appropriate to use whenever an object can be safely read from multiple threads simultaneously,
 but should only be written to from one thread at a time, and even then only when no reads are occurring. For example,
 you might use a TWTConcurrentAccessor to manage a mutable dictionary that needs to be updated from multiple threads:

     NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init]; 
     TWTConcurrentAccessor<NSMutableDictionary *> *accessor = [[TWTConcurrentAccessor alloc] initWithObject:dictionary];

 To perform reads, you can use the ‑performRead: and ‑performReadAndReturn: methods.
    
     NSString *name = [accessor performReadAndReturn:^(NSMutableDictionary *dictionary) {
         return dictionary[@"name"];
     }];
 
 If you need to read multiple values in one ‑performRead: or would prefer to read primitive types, you must use block
 variables.
 
     __block NSString *name = nil;
     __block NSUInteger age = 0;
     [accessor performRead:^(NSMutableDictionary *dictionary) {
         name = dictionary[@"name"];
         age = [dictionary[@"age"] unsignedIntegerValue];
     }];
 
 Reads are inherently synchronous, and you can safely read from several threads at once. Writes, on the other hand,
 are inherently asynchronous, and the implementation of TWTConcurrentAccessor prevents a write from occurring at the
 same time as another read or write.
 
     NSString *newName = [name stringByAppendingString:@" modified"];
     [accessor performWrite:^(NSMutableDictionary *dictionary) {
         dictionary[@"name"] = newName;
     }];

 If you want to wait for a write to complete before moving on to subsequent lines, you can do so using 
 ‑performWriteAndWait:.
 */
@interface TWTConcurrentAccessor<ObjectType> : NSObject

/*! Do not use this method. Use ‑initWithObject: instead. */
- (instancetype)init NS_UNAVAILABLE;

/*!
 @abstract Initializes a newly created TWTConcurrentAccessor instance that controls concurrent access to the specified
     object.
 @param object The object that the instance will control concurrent access to.
 @result An initialized TWTConcurrentAccessor instance with the specified object.
 */
- (instancetype)initWithObject:(ObjectType)object;

/*!
 @abstract Safely and synchronously executes the read block while preventing write blocks from executing concurrently.
 @discussion This method can be used to safely and efficiently read data from the instance’s object. To maintain object
     consistency, the instance’s object should not be mutated inside this block. For example, if the instance’s object
     is a mutable array, its count and objects can be retrieved inside the block, but objects cannot be added to or
     removed from it.
     
     This method is typically used to retrieve multiple pieces of data from the instance’s object at once. Because this
     API is block-based, you must use block variables to read the values outside the block. If you need to read only one
     value, you should use ‑performReadAndReturn: instead.
 @param readBlock The block to execute to perform one or more read operations on the instance’s object. The instance’s
     object is passed to this block as a parameter.
 */
- (void)performRead:(void (^)(ObjectType object))readBlock;

/*!
 @abstract Safely and synchronously executes the read block and returns a value while preventing write blocks from
     executing concurrently.
 @discussion This method can be used to safely and efficiently read data from the instance’s object. To maintain object
     consistency, the instance’s object should not be mutated inside this block. For example, if the instance’s object
     is a mutable array, its count and objects can be retrieved inside the block, but objects cannot be added or removed
     to it.
     
     This method should be used whenever you only need to read a single value from a block. Doing so removes the need
     to declare block variables. Non-object values must be returned in object wrappers, e.g., NSNumber or NSValue.
 @param readBlock The block to execute to perform a read operation on the instance’s object. The instance’s object is
     passed to this block as a parameter.
 */
- (id)performReadAndReturn:(_Nullable id (^)(ObjectType object))readBlock;

/*!
 @abstract Safely and asynchronously executes the write block while preventing any other read or write blocks from 
     executing concurrently.
 @discussion Because write-block execution blocks access to the instance’s object, care should be taken to do as little
     in the write block as possible. For example, if an object needs to be stored in a mutable array, the object should
     already be constructed outside the block and simply added to the array in the block.
     
     The write block is executed asynchronously. For synchronous write block execution, use ‑performWriteAndWait:. 
     Use of this method is preferred whenever possible.
 @param writeBlock The block to execute to perform one or more write operations on the instance’s object. The instance’s 
     object is passed to this block as a parameter.
 */
- (void)performWrite:(void (^)(ObjectType object))writeBlock;

/*!
 @abstract Safely and synchronously executes the write block while preventing any other read or write blocks from 
     executing concurrently.
 @discussion Because write-block execution blocks access to the instance’s object, care should be taken to do as little
     in the write block as possible. For example, if an object needs to be stored in a mutable array, the object should
     already be constructed outside the block and simply added to the array in the block.
     
     The write block is executed synchronously. For asynchronous write block execution, use ‑performWrite:. That method
     should be used whenever possible.
 @param writeBlock The block to execute to perform one or more write operations on the instance’s object. The instance’s 
     object is passed to this block as a parameter.
 */
- (void)performWriteAndWait:(void (^)(ObjectType object))writeBlock;

@end

NS_ASSUME_NONNULL_END

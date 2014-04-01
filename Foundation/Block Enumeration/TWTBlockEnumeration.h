//
//  TWTBlockEnumeration.h
//  Toast
//
//  Created by Prachi Gauriar on 1/21/2014.
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

#pragma mark Block Types

/*!
 @abstract Type for blocks that, when given an element of block enumerating object, returns an object.
 @discussion This block type is used for Collect operations.
 @param element The element being enumerated.
 @result An object.
 */
typedef id (^TWTBlockEnumerationCollectBlock)(id element);

/*!
 @abstract Type for blocks that, when given an element of block enumerating object, returns a boolean.
 @discussion This block type is used for Detect, Select, and Reject operations.
 @param element The element being enumerated.
 @result A boolean value.
 */
typedef BOOL (^TWTBlockEnumerationPredicateBlock)(id element);

/*!
 @abstract Type for blocks that, when given a total and an element of block enumerating object, return an
     object with the element (or some value derived from it) injected into the total.
 @discussion This block type is used for Inject operations.
 @param memo Accumulator that is the result of the previous inject operation.
 @param element The element being enumerated.
 @result A new object representing the element's value injected into the total.
 */
typedef id (^TWTBlockEnumerationInjectBlock)(id memo, id element);


#pragma mark - Block Enumeration Operation Categories for Foundation Collections

@interface NSArray (TWTBlockEnumeration)

/*!
 @abstract Return a newly created array that is the result of performing the given block on each
    element in the original array.
 @discussion Given an array of [1, 2, 3] and a block that returns the square of the element, this 
    method will return [1, 4, 9]. If the result of the block is nil, that element in the resulting
    array will be an instance of NSNull.
 @param block The block to invoke against each element of the array.
 @result A new array of the results of invoking the block on each element of the original array.
 */
- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;

/*!
 @abstract Passes each entry in the array to the block and returns the first item that returns YES.
 @param block Predicate block to apply to each item in the array.
 @result The first item in the array that returns YES. If no item returns YES, this will return nil.
 */
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the array and a memo to the provided block starting with an initial
    object.
 @discussion Similar to a "reduce" operation. For each iteration through the array, the memo value
    passed to each element is the result of the previous iteration. For the first iteration, the 
    initial object is passed as the memo. For example, given an array of [1, 2, 3], a block that 
    returns (memo + element), and an initial value of 0 the returned value will be the result of
    (0 + 1) then (1 + 2) then (3 + 3) or 6.
 @param initialObject The initial object to pass as a memo to the first iteration of the array.
 @param block An inject block that is performed on each element of the array.
 @result The final returned value from the last iteration of the array.
 */
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;

/*!
 @abstract Passes each item in the array to the block and returns a new array with the items that 
    returned YES from the block removed.
 @param block Predicate block to test items in the array.
 @result A new array with the items that were not rejected.
 */
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the array to the block and returns a new array with the only items 
    that returned YES.
 @param block Predicate block to test items in the array.
 @result A new array with the items that return YES from the block.
 */
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSDictionary (TWTBlockEnumeration)

/*!
 @abstract Return a newly created dictionary that is the result of performing the given block on each
    element in the original dictionary.
 @discussion Given an dictionary with values of [1, 2, 3] and a block that returns the square of the 
    element, this method will return [1, 4, 9]. If the result of the block is nil, that element in 
    the resulting dictionary will be an instance of NSNull.
 @param block The block to invoke against each element of the dictionary. The value passed to the block
    is the key of the element in the original dictionary.
 @result A new dictionary of the results of invoking the block on each element of the original
    dictionary.
 */
- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;

/*!
 @abstract Passes each entry in the dictionary to the block and returns the first item that returns YES.
 @param block Predicate block to apply to each item in the dictionary. The key of the elemnt in the
    dictionary is passed to the block.
 @result The first item in the dictionary that returns YES. If no item returns YES, this will return nil.
 */
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the dictionary and a memo to the provided block starting with an initial
    object.
 @discussion Similar to a "reduce" operation. For each iteration through the dictionary, the memo value
    passed to each element is the result of the previous iteration. For the first iteration, the 
    initial object is passed as the memo. For example, given an dictionary of [1, 2, 3], a block that
    returns (memo + element), and an initial value of 0 the returned value will be the result of
    (0 + 1) then (1 + 2) then (3 + 3) or 6.
 @param initialObject The initial object to pass as a memo to the first iteration of the dictionary.
 @param block An inject block that is performed on each element of the dictionary. The element passed
    to the block is the key of the element in the dictionary.
 @result The final returned value from the last iteration of the dictionary.
 */
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;

/*!
 @abstract Passes each item in the dictionary to the block and returns a new dictionary with the items that
    returned YES from the block removed.
 @param block Predicate block to test items in the array. The element provided is the key to the original
    dictionary.
 @result A new dictionary with the items that were not rejected.
 */
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the dictionary to the block and returns a new dictionary with the only items
    that returned YES.
 @param block Predicate block to test items in the dictionary. The element provided is the key to the original
    dictionary.
 @result A new dictionary with the items that return YES from the block.
 */
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSEnumerator (TWTBlockEnumeration)

/*!
 @abstract Return a newly created array that is the result of performing the given block on each
    element in the original enumerator.
 @discussion Given an collection of [1, 2, 3] and a block that returns the square of the element, this
    method will return [1, 4, 9]. If the result of the block is nil, that element in the resulting
    collection will be an instance of NSNull.
 @param block The block to invoke against each element of the collection.
 @result A new array of the results of invoking the block on each element of the original
    collection.
 */
- (NSArray *)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;

/*!
 @abstract Passes each entry in the enumerator to the block and returns the first item that returns YES.
 @param block Predicate block to apply to each item in the collection.
 @result The first item in the collection that returns YES. If no item returns YES, this will return nil.
 */
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the collection and a memo to the provided block starting with an initial
    object.
 @discussion Similar to a "reduce" operation. For each iteration through the collection, the memo value
    passed to each element is the result of the previous iteration. For the first iteration, the 
    initial object is passed as the memo. For example, given an collection of [1, 2, 3], a block that
    returns (memo + element), and an initial value of 0 the returned value will be the result of
    (0 + 1) then (1 + 2) then (3 + 3) or 6.
 @param initialObject The initial object to pass as a memo to the first iteration of the collection.
 @param block An inject block that is performed on each element of the collection.
 @result The final returned value from the last iteration of the collection.
 */
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;

/*!
 @abstract Passes each item in the collection to the block and returns a new array with the items that
    returned YES from the block removed.
 @param block Predicate block to test items in the collection.
 @result A new array with the items that were not rejected.
 */
- (NSArray *)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the collection to the block and returns a new array with the only items
    that returned YES.
 @param block Predicate block to test items in the collection.
 @result A new array with the items that return YES from the block.
 */
- (NSArray *)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSOrderedSet (TWTBlockEnumeration)

/*!
 @abstract Return a newly created ordered set that is the result of performing the given block on each
    element in the original ordered set.
 @discussion Given an collection of [1, 2, 3] and a block that returns the square of the element, this
    method will return [1, 4, 9]. If the result of the block is nil, that element in the resulting
    collection will be an instance of NSNull.
 @param block The block to invoke against each element of the collection.
 @result A new ordered set of the results of invoking the block on each element of the original
    collection.
 */
- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;

/*!
 @abstract Passes each entry in the ordered set to the block and returns the first item that returns YES.
 @param block Predicate block to apply to each item in the ordered set.
 @result The first item in the ordered set that returns YES. If no item returns YES, this will return nil.
 */
- (instancetype)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the ordered set and a memo to the provided block starting with an initial
    object.
 @discussion Similar to a "reduce" operation. For each iteration through the collection, the memo value
    passed to each element is the result of the previous iteration. For the first iteration, the 
    initial object is passed as the memo. For example, given an collection of [1, 2, 3], a block that
    returns (memo + element), and an initial value of 0 the returned value will be the result of
    (0 + 1) then (1 + 2) then (3 + 3) or 6.
 @param initialObject The initial object to pass as a memo to the first iteration of the collection.
 @param block An inject block that is performed on each element of the set.
 @result The final returned value from the last iteration of the set.
 */
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;

/*!
 @abstract Passes each item in the ordered set to the block and returns a new ordered set with the
    items that returned YES from the block removed.
 @param block Predicate block to test items in the ordered set.
 @result A new ordered set with the items that were not rejected.
 */
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the ordered set to the block and returns a new ordered set with the only items
    that returned YES.
 @param block Predicate block to test items in the ordered set.
 @result A new ordered set with the items that return YES from the block.
 */
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark 

@interface NSSet (TWTBlockEnumeration)

/*!
 @abstract Return a newly created set that is the result of performing the given block on each
    element in the original set.
 @discussion Given an collection of [1, 2, 3] and a block that returns the square of the element, this
    method will return [1, 4, 9]. If the result of the block is nil, that element in the resulting
    collection will be an instance of NSNull.
 @param block The block to invoke against each element of the set.
 @result A new set of the results of invoking the block on each element of the original set.
 */
- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;

/*!
 @abstract Passes each entry in the set to the block and returns the first item that returns YES.
 @param block Predicate block to apply to each item in the set.
 @result The first item in the set that returns YES. If no item returns YES, this will return nil.
 */
- (instancetype)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the set and a memo to the provided block starting with an initial
    object.
 @discussion Similar to a "reduce" operation. For each iteration through the set, the memo value
    passed to each element is the result of the previous iteration. For the first iteration, the 
    initial object is passed as the memo. For example, given an collection of [1, 2, 3], a block that
    returns (memo + element), and an initial value of 0 the returned value will be the result of
    (0 + 1) then (1 + 2) then (3 + 3) or 6.
 @param initialObject The initial object to pass as a memo to the first iteration of the collection.
 @param block An inject block that is performed on each element of the set.
 @result The final returned value from the last iteration of the set.
 */
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;

/*!
 @abstract Passes each item in the set to the block and returns a new set with the
    items that returned YES from the block removed.
 @param block Predicate block to test items in the set.
 @result A new set with the items that were not rejected.
 */
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

/*!
 @abstract Passes each item in the set to the block and returns a new set with the only items
    that returned YES.
 @param block Predicate block to test items in the set.
 @result A new set with the items that return YES from the block.
 */
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end

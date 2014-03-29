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
 @param element The element being enumerated.
 @result A new object representing the element's value injected into the total.
 */
typedef id (^TWTBlockEnumerationInjectBlock)(id total, id element);


#pragma mark - Block Enumeration Operation Categories for Foundation Collections

@interface NSArray (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSDictionary (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSEnumerator (TWTBlockEnumeration)

- (NSArray *)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;
- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
- (NSArray *)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (NSArray *)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark

@interface NSOrderedSet (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;
- (instancetype)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark 

@interface NSSet (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block;
- (instancetype)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block;
- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block;

@end

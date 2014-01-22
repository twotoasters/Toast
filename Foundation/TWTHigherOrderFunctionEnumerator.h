//
//  TWTHigherOrderFunctionEnumerator.h
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

typedef id (^TWTCollectionBlock)(id element);
typedef BOOL (^TWTBooleanBlock)(id element);
typedef id (^TWTInjectionBlock)(id total, id element);
typedef void (^TWTObjectAdditionBlock)(id collection, id enumeratedElement, id objectToAdd);


@protocol TWTHigherOrderFunctionEnumerable <NSObject>

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock;
+ (Class)twt_enumerationResultsCollectionClass;
- (id <NSFastEnumeration>)twt_fastEnumerator;

@end


@interface TWTHigherOrderFunctionEnumerator : NSObject

+ (id)collectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTCollectionBlock)block;
+ (id)detectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block;
+ (id)injectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable initialObject:(id)initialObject block:(TWTInjectionBlock)block;
+ (id)rejectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block;
+ (id)selectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block;

@end


@interface NSArray (TWTHigherOrderFunctionEnumerableConvenience) <TWTHigherOrderFunctionEnumerable>

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;

@end


@interface NSDictionary (TWTHigherOrderFunctionEnumerableConvenience) <TWTHigherOrderFunctionEnumerable>

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;

@end


@interface NSEnumerator (TWTHigherOrderFunctionEnumerableConvenience) <TWTHigherOrderFunctionEnumerable>

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;

@end


@interface NSOrderedSet (TWTHigherOrderFunctionEnumerableConvenience) <TWTHigherOrderFunctionEnumerable>

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;

@end


@interface NSSet (TWTHigherOrderFunctionEnumerableConvenience) <TWTHigherOrderFunctionEnumerable>

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;

@end

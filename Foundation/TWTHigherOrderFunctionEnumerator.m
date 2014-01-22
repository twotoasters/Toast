//
//  TWTHigherOrderFunctionEnumerator.m
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

#import "TWTHigherOrderFunctionEnumerator.h"

@implementation TWTHigherOrderFunctionEnumerator

+ (id)collectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTCollectionBlock)block
{
    id collection = [[[[enumerable class] twt_enumerationResultsCollectionClass] alloc] init];
    TWTObjectAdditionBlock objectAdditionBlock = [[enumerable class] twt_objectAdditionBlock];

    for (id element in [enumerable twt_fastEnumerator]) {
        objectAdditionBlock(collection, element, block(element));
    }

    return collection;
}


+ (id)detectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block
{
    for (id element in [enumerable twt_fastEnumerator]) {
        if (block(element)) {
            return element;
        }
    }

    return nil;
}


+ (id)injectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable initialObject:(id)initialObject block:(TWTInjectionBlock)block
{
    id total = initialObject;
    for (id element in [enumerable twt_fastEnumerator]) {
        total = block(total, element);
    }

    return total;
}


+ (id)rejectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block
{
    return [self selectWithEnumerable:enumerable block:^BOOL(id element) {
        return !block(element);
    }];
}


+ (id)selectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)enumerable block:(TWTBooleanBlock)block
{
    id collection = [[[[enumerable class] twt_enumerationResultsCollectionClass] alloc] init];
    TWTObjectAdditionBlock objectAdditionBlock = [[enumerable class] twt_objectAdditionBlock];

    for (id element in [enumerable twt_fastEnumerator]) {
        if (block(element)) {
            objectAdditionBlock(collection, element, element);
        }
    }

    return collection;
}

@end


#pragma mark - Convenience Methods

@implementation NSObject (TWTHigherOrderFunctionEnumerableConvenience)

- (id)twt_collectWithBlock:(TWTCollectionBlock)block
{
    return [TWTHigherOrderFunctionEnumerator collectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)self block:block];
}


- (id)twt_detectWithBlock:(TWTBooleanBlock)block
{
    return [TWTHigherOrderFunctionEnumerator detectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block
{
    return [TWTHigherOrderFunctionEnumerator injectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)self initialObject:initialObject block:block];
}


- (id)twt_rejectWithBlock:(TWTBooleanBlock)block
{
    return [TWTHigherOrderFunctionEnumerator rejectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)self block:block];
}


- (id)twt_selectWithBlock:(TWTBooleanBlock)block
{
    return [TWTHigherOrderFunctionEnumerator selectWithEnumerable:(id <TWTHigherOrderFunctionEnumerable>)self block:block];
}

@end


#pragma mark - Arrays

@implementation NSArray (TWTHigherOrderFunctionEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (Class)twt_enumerationResultsCollectionClass;
{
    return [NSMutableArray class];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Dictionaries

@implementation NSDictionary (TWTHigherOrderFunctionEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection setObject:newObject forKey:enumeratedObject];
    };
}


+ (Class)twt_enumerationResultsCollectionClass;
{
    return [NSMutableDictionary class];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Enumerators

@implementation NSEnumerator (TWTHigherOrderFunctionEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (Class)twt_enumerationResultsCollectionClass;
{
    return [NSMutableArray class];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Ordered Sets

@implementation NSOrderedSet (TWTHigherOrderFunctionEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (Class)twt_enumerationResultsCollectionClass;
{
    return [NSMutableOrderedSet class];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Sets

@implementation NSSet (TWTHigherOrderFunctionEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (Class)twt_enumerationResultsCollectionClass;
{
    return [NSMutableSet class];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end

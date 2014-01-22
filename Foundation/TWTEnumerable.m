//
//  TWTEnumerable.m
//  Enumerable
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

#import "TWTEnumerable.h"

#pragma mark Base Implementation

@implementation NSObject (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return nil;
}


+ (id)twt_collectionForReturningObjects
{
    return nil;
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return nil;
}


- (id)twt_collectWithBlock:(TWTCollectionBlock)block
{
    id collection = [[self class] twt_collectionForReturningObjects];
    TWTObjectAdditionBlock objectAdditionBlock = [[self class] twt_objectAdditionBlock];

    for (id object in [self twt_fastEnumerator]) {
        id result = block(object);
        objectAdditionBlock(collection, object, result);
    }
    
    return collection;
}


- (id)twt_detectWithBlock:(TWTBooleanBlock)block
{
    for (id object in [self twt_fastEnumerator]) {
        if (block(object)) {
            return object;
        }
    }
    
    return nil;
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block
{
    id total = initialObject;
    for (id object in [self twt_fastEnumerator]) {
        total = block(total, object);
    }
    
    return total;
}


- (id)twt_rejectWithBlock:(TWTBooleanBlock)block
{
    return [self twt_selectWithBlock:^BOOL(id object) {
        return !block(object);
    }];
}


- (id)twt_selectWithBlock:(TWTBooleanBlock)block
{
    id collection = [[self class] twt_collectionForReturningObjects];
    TWTObjectAdditionBlock objectAdditionBlock = [[self class] twt_objectAdditionBlock];

    for (id object in [self twt_fastEnumerator]) {
        if (block(object)) {
            objectAdditionBlock(collection, object, object);
        }
    }
    
    return collection;
}

@end


#pragma mark - Arrays

@implementation NSArray (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (id)twt_collectionForReturningObjects
{
    return [NSMutableArray array];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Dictionaries

@implementation NSDictionary (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection setObject:newObject forKey:enumeratedObject];
    };
}


+ (id)twt_collectionForReturningObjects
{
    return [NSMutableDictionary dictionary];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Enumerators

@implementation NSEnumerator (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (id)twt_collectionForReturningObjects
{
    return [NSMutableArray array];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Ordered Sets

@implementation NSOrderedSet (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (id)twt_collectionForReturningObjects
{
    return [NSMutableOrderedSet orderedSet];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end


#pragma mark - Sets

@implementation NSSet (TWTEnumerable)

+ (TWTObjectAdditionBlock)twt_objectAdditionBlock
{
    return ^(id collection, id enumeratedObject, id newObject) {
        [collection addObject:newObject];
    };
}


+ (id)twt_collectionForReturningObjects
{
    return [NSMutableSet set];
}


- (id <NSFastEnumeration>)twt_fastEnumerator
{
    return self;
}

@end

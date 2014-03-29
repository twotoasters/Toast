//
//  TWTBlockEnumeration.m
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

#import "TWTBlockEnumeration.h"

#pragma mark TWTBlockEnumerator

/*!
 TWTBlockEnumerator does all the work of performing block enumerations for the Foundation collection classes.
 It assumes that it is collecting for array-like objects that respond to -addObject: or dictionary-like objects
 that respond to -objectForKey: and -setObject:forKey:.
 */
@interface TWTBlockEnumerator : NSObject

+ (id)performCollectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationCollectBlock)block;
+ (id)performDetectOnObject:(id <NSFastEnumeration>)object block:(TWTBlockEnumerationPredicateBlock)block;
+ (id)performInjectOnObject:(id <NSFastEnumeration>)object initialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
+ (id)performRejectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationPredicateBlock)block;
+ (id)performSelectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationPredicateBlock)block;

@end


#pragma mark -

@implementation TWTBlockEnumerator

+ (id)performCollectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationCollectBlock)block;
{
    NSParameterAssert(object);
    NSParameterAssert(collectionClass);
    NSParameterAssert(block);

    id collection = [[collectionClass alloc] init];

    BOOL respondsToSetObjectForKey = [collection respondsToSelector:@selector(setObject:forKey:)];
    for (id element in object) {
        id result = block(element);
        if (!result) {
            result = [NSNull null];
        }
        
        if (respondsToSetObjectForKey) {
            [collection setObject:result forKey:element];
        } else {
            [collection addObject:result];
        }
    }

    return collection;
}


+ (id)performDetectOnObject:(id <NSFastEnumeration>)object block:(TWTBlockEnumerationPredicateBlock)block;
{
    NSParameterAssert(object);
    NSParameterAssert(block);

    for (id element in object) {
        if (block(element)) {
            return element;
        }
    }

    return nil;
}


+ (id)performInjectOnObject:(id <NSFastEnumeration>)object initialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block;
{
    NSParameterAssert(object);
    NSParameterAssert(block);

    id total = initialObject;
    for (id element in object) {
        total = block(total, element);
    }

    return total;
}


+ (id)performRejectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationPredicateBlock)block;
{
    return [self performSelectOnObject:object resultsCollectionClass:collectionClass block:^BOOL(id element) {
        return !block(element);
    }];
}


+ (id)performSelectOnObject:(id <NSFastEnumeration>)object resultsCollectionClass:(Class)collectionClass block:(TWTBlockEnumerationPredicateBlock)block;
{
    NSParameterAssert(object);
    NSParameterAssert(collectionClass);
    NSParameterAssert(block);

    id collection = [[collectionClass alloc] init];
    
    BOOL respondsToSetObjectForKey = [collection respondsToSelector:@selector(setObject:forKey:)];
    for (id element in object) {
        if (respondsToSetObjectForKey) {
            [collection setObject:[(id)object objectForKey:element] forKey:element];
        } else {
            [collection addObject:element];
        }
    }

    return collection;
}

@end


#pragma mark - Arrays

@implementation NSArray (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block
{
    return [TWTBlockEnumerator performCollectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}


- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performDetectOnObject:self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block
{
    return [TWTBlockEnumerator performInjectOnObject:self initialObject:initialObject block:block];
}


- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performRejectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}


- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performSelectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}

@end


#pragma mark - Dictionaries

@implementation NSDictionary (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block
{
    return [TWTBlockEnumerator performCollectOnObject:self resultsCollectionClass:[NSMutableDictionary class] block:block];
}


- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performDetectOnObject:self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block
{
    return [TWTBlockEnumerator performInjectOnObject:self initialObject:initialObject block:block];
}


- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performRejectOnObject:self resultsCollectionClass:[NSMutableDictionary class] block:block];
}


- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performSelectOnObject:self resultsCollectionClass:[NSMutableDictionary class] block:block];
}

@end


#pragma mark - Enumerators

@implementation NSEnumerator (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block
{
    return [TWTBlockEnumerator performCollectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}


- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performDetectOnObject:self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block
{
    return [TWTBlockEnumerator performInjectOnObject:self initialObject:initialObject block:block];
}


- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performRejectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}


- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performSelectOnObject:self resultsCollectionClass:[NSMutableArray class] block:block];
}

@end


#pragma mark - Ordered Sets

@implementation NSOrderedSet (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block
{
    return [TWTBlockEnumerator performCollectOnObject:self resultsCollectionClass:[NSMutableOrderedSet class] block:block];
}


- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performDetectOnObject:self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block
{
    return [TWTBlockEnumerator performInjectOnObject:self initialObject:initialObject block:block];
}


- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performRejectOnObject:self resultsCollectionClass:[NSMutableOrderedSet class] block:block];
}


- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performSelectOnObject:self resultsCollectionClass:[NSMutableOrderedSet class] block:block];
}

@end


#pragma mark - Sets

@implementation NSSet (TWTBlockEnumeration)

- (instancetype)twt_collectWithBlock:(TWTBlockEnumerationCollectBlock)block
{
    return [TWTBlockEnumerator performCollectOnObject:self resultsCollectionClass:[NSMutableSet class] block:block];
}


- (id)twt_detectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performDetectOnObject:self block:block];
}


- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTBlockEnumerationInjectBlock)block
{
    return [TWTBlockEnumerator performInjectOnObject:self initialObject:initialObject block:block];
}


- (instancetype)twt_rejectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performRejectOnObject:self resultsCollectionClass:[NSMutableSet class] block:block];
}


- (instancetype)twt_selectWithBlock:(TWTBlockEnumerationPredicateBlock)block
{
    return [TWTBlockEnumerator performSelectOnObject:self resultsCollectionClass:[NSMutableSet class] block:block];
}

@end

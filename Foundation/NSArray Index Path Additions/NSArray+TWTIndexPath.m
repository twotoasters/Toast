//
//  NSArray+TWTIndexPath.m
//  Toast
//
//  Created by Andrew Hershberger on 3/9/14.
//  Copyright (c) 2015 Ticketmaster. All rights reserved.
//
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

#import "NSArray+TWTIndexPath.h"


@implementation NSArray (TWTIndexPath)

- (id)twt_objectAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.length == 0) {
        return nil;
    }

    id object = self;
    NSUInteger length = indexPath.length;

    for (NSUInteger position=0; position<length; position++) {
        object = [object objectAtIndex:[indexPath indexAtPosition:position]];
    }

    return object;
}


- (NSIndexPath *)twt_indexPathOfObject:(id)object
{
    NSUInteger index = [self indexOfObject:object];

    if (index != NSNotFound) {
        return [NSIndexPath indexPathWithIndex:index];
    }

    __block NSIndexPath *indexPath = nil;

    [self enumerateObjectsUsingBlock:^(id arrayElement, NSUInteger idx, BOOL *stop) {
        if (![arrayElement isKindOfClass:[NSArray class]]) {
            return;
        }

        NSIndexPath *arrayElementIndexPath = [arrayElement twt_indexPathOfObject:object];
        if (!arrayElementIndexPath) {
            return;
        }

        NSUInteger length = arrayElementIndexPath.length + 1;
        NSUInteger *indexes = malloc(length * sizeof(NSUInteger));
        if (!indexes) {
            *stop = YES;
            return;
        }

        *indexes = idx;
        [arrayElementIndexPath getIndexes:indexes+1];

        indexPath = [NSIndexPath indexPathWithIndexes:indexes length:length];

        free(indexes);

        *stop = YES;
    }];

    return indexPath;
}

@end

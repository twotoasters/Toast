//
//  NSArrayTWTIndexPathTests.m
//  Toast
//
//  Created by Andrew Hershberger on 3/27/14.
//  Copyright (c) 2015 Ticketmaster All rights reserved.
//

#import "TWTRandomizedTestCase.h"

#import <URLMock/UMKTestUtilities.h>

#import "NSArray+TWTIndexPath.h"


static const NSUInteger kIterationCount = 512;


NSArray *TWTRandomArray(NSUInteger maxNestingDepth, NSUInteger maxElementCountPerCollection)
{
    NSUInteger count = maxElementCountPerCollection ? random() % maxElementCountPerCollection + 1 : 0;

    NSArray *array = UMKGeneratedArrayWithElementCount(count, ^id(NSUInteger index) {
        return maxNestingDepth && UMKRandomBoolean() ? TWTRandomArray(maxNestingDepth - 1, maxElementCountPerCollection) : UMKRandomUnsignedNumber();
    });

    return array;
}


@interface NSArrayTWTIndexPathTests : TWTRandomizedTestCase
@end


@implementation NSArrayTWTIndexPathTests

- (void)testIndexPathOfObjectNotFound
{
    NSArray *testArray = @[];
    NSIndexPath *indexPath = [testArray twt_indexPathOfObject:@0];
    XCTAssertNil(indexPath, @"indexPath was non-nil for object not contained in test array.");
}


- (void)testIndexPathOfReceiver
{
    NSArray *testArray = @[];
    NSIndexPath *indexPath = [testArray twt_indexPathOfObject:testArray];
    XCTAssertNil(indexPath, @"indexPath was non-nil for the test array itself.");
}


- (void)testIndexPathOfObject
{
    for (NSUInteger i=0; i<kIterationCount; i++) {
        NSUInteger maxDepth = 5;
        NSArray *testArray = TWTRandomArray(maxDepth, 10);

        id object = testArray;
        NSIndexPath *expectedIndexPath = [[NSIndexPath alloc] init];

        while ([object isKindOfClass:[NSArray class]]) {
            NSNumber *index = UMKRandomUnsignedNumberInRange(NSMakeRange(0, ((NSArray *)object).count));
            object = [object objectAtIndex:[index unsignedIntegerValue]];
            expectedIndexPath = [expectedIndexPath indexPathByAddingIndex:[index unsignedIntegerValue]];
        }

        NSIndexPath *indexPath = [testArray twt_indexPathOfObject:object];

        XCTAssertEqualObjects(indexPath, expectedIndexPath, @"index paths do not match. expected: %@ actual: %@", expectedIndexPath, indexPath);
    }
}


- (void)testObjectAtIndexPathPassingNil
{
    NSArray *testArray = @[];
    id object = [testArray twt_objectAtIndexPath:nil];
    XCTAssertNil(object, @"object was non-nil for nil index path.");
}


- (void)testObjectAtIndexPathInvalidIndexPath
{
    NSArray *testArray = @[];
    XCTAssertThrows([testArray twt_objectAtIndexPath:[NSIndexPath indexPathWithIndex:0]], @"twt_objectAtIndexPath did not throw for invalid index path.");
}


- (void)testObjectAtIndexPathNotAnArray
{
    NSArray *testArray = @[ @1 ];
    XCTAssertThrows([testArray twt_objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]], @"twt_objectAtIndexPath did not throw for invalid index path.");
}


- (void)testObjectAtIndexPath
{
    for (NSUInteger i=0; i<kIterationCount; i++) {
        NSUInteger maxDepth = 5;
        NSArray *testArray = TWTRandomArray(maxDepth, 10);

        id expectedObject = testArray;
        NSIndexPath *indexPath = [[NSIndexPath alloc] init];

        while ([expectedObject isKindOfClass:[NSArray class]]) {
            NSNumber *index = UMKRandomUnsignedNumberInRange(NSMakeRange(0, ((NSArray *)expectedObject).count));
            expectedObject = [expectedObject objectAtIndex:[index unsignedIntegerValue]];
            indexPath = [indexPath indexPathByAddingIndex:[index unsignedIntegerValue]];
        }

        id object = [testArray twt_objectAtIndexPath:indexPath];

        XCTAssertEqualObjects(object, expectedObject, @"objects do not match. expected: %@ actual: %@", expectedObject, object);
    }
}

@end

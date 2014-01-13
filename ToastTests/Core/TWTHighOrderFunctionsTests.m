//
//  TWTHighOrderFunctionsTests.m
//  Toast
//
//  Created by Josh Johnson on 1/12/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TWTHighOrderFunctions.h"

@interface TWTHighOrderFunctionsTests : XCTestCase

@end

@implementation TWTHighOrderFunctionsTests

- (void)testTWTSimpleMapMappedArray
{
    NSString *testString = @"Test";
    NSArray *originalArray = @[ @"One", @"Two", @"Three" ];
    NSString *expectedItem = [testString stringByAppendingString:originalArray[ 0 ]];
    
    NSArray *mappedArray = TWTSimpleMap(originalArray, ^id(NSString *item, BOOL *stop) {
        return [testString stringByAppendingString:item];
    });
    
    XCTAssertEqualObjects(mappedArray[ 0 ], expectedItem, @"Item was not mapped as expected");
}

@end

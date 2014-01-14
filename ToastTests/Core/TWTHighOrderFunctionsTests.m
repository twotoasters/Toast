//
//  TWTHighOrderFunctionsTests.m
//  Toast
//
//  Created by Josh Johnson on 1/12/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
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

#import <XCTest/XCTest.h>
#import <UMKTestUtilities.h>
#import "TWTHighOrderFunctions.h"
#import "TWTRandomizedTestCase.h"

@interface TWTHighOrderFunctionsTests : TWTRandomizedTestCase

@end

@implementation TWTHighOrderFunctionsTests

- (NSArray *)randomArrayWithGeneratorBlock:(id (^)(void))generatorBlock
{
    NSParameterAssert(generatorBlock);
    
    NSUInteger count = random() % 1024;
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger i = 0; i < count; ++i) {
        [array addObject:generatorBlock()];
    }
    
    return array;
}

- (void)testTWTSimpleMapMappedArray
{
    NSArray *randomStrings = [self randomArrayWithGeneratorBlock:^id{
        return UMKRandomUnicodeString();
    }];
    
    NSMutableArray *randomNumbers = [[NSMutableArray alloc] initWithCapacity:randomStrings.count];
    NSArray *mappedArray = TWTSimpleMap(randomStrings, ^id(id item) {
        NSNumber *randomNumber = @(random());
        [randomNumbers addObject:randomNumber];
        return [item length] > 30 ? [NSString stringWithFormat:@"%@%@", item, randomNumber] : nil;
    });
    
    XCTAssertNotNil(mappedArray, @"Returned array is nil");
    XCTAssertEqual(mappedArray.count, randomStrings.count, @"Returned array is the wrong size");
    
    NSUInteger count = mappedArray.count;
    for (NSUInteger i = 0; i < count; ++i) {
        id actualValue = mappedArray[i];
        id randomString = randomStrings[i];
        id expectedValue = [randomString length] > 30 ? [NSString stringWithFormat:@"%@%@", randomString, randomNumbers[i]] : [NSNull null];
        XCTAssertEqualObjects(expectedValue, mappedArray[i], @"Mapped value (%@) is incorrect for index %ld", actualValue, (unsigned long)i);
    }
}

@end

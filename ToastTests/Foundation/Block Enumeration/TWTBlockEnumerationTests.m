//
//  TWTBlockEnumerationTests
//  Toast
//
//  Created by Josh Johnson on 3/29/14.
//  Copyright (c) 2014 Two Toasters.
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

#import "TWTRandomizedTestCase.h"

#import <URLMock/UMKTestUtilities.h>

#import "TWTBlockEnumeration.h"

@interface TWTBlockEnumerationTests : TWTRandomizedTestCase

@end

@implementation TWTBlockEnumerationTests

#pragma mark - Helpers

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

- (NSArray *)randomNumberArray
{
    return [self randomArrayWithGeneratorBlock:^id{
        return UMKRandomUnsignedNumber();
    }];
}


#pragma mark - NSArray Tests

- (void)testNSArrayBlockEnumerationCollect
{
    NSArray *randomStrings = [self randomArrayWithGeneratorBlock:^id{
        return UMKRandomUnicodeString();
    }];
    
    NSMutableArray *randomNumbers = [[NSMutableArray alloc] initWithCapacity:randomStrings.count];
    NSArray *mappedArray = [randomStrings twt_collectWithBlock:^id(id element) {
        NSNumber *randomNumber = @(random());
        [randomNumbers addObject:randomNumber];
        
        return [element length] > 30 ? [NSString stringWithFormat:@"%@%@", element, randomNumber] : nil;
    }];
    
    XCTAssertNotNil(mappedArray, @"Returned array is nil");
    XCTAssertEqual(mappedArray.count, randomStrings.count, @"Returned array is the wrong size.");
    
    NSUInteger count = mappedArray.count;
    for (NSUInteger i = 0; i < count; ++i) {
        id actualValue = mappedArray[ i ];
        id randomString = randomStrings[ i ];
        id expectedValue = [randomString length] > 30 ? [NSString stringWithFormat:@"%@%@", randomString, randomNumbers[ i ]] : [NSNull null];
        
        XCTAssertEqualObjects(expectedValue, mappedArray[ i ], @"Mapped value (%@) is incorrect for index %ld", actualValue, (unsigned long)i);
    }
}


- (void)testNSArrayBlockEnumerationInject
{
    NSArray *randomNumbers = [self randomNumberArray];
    NSNumber *initialNumber = @(random());
    NSNumber *actualNumberValue = [randomNumbers twt_injectWithInitialObject:initialNumber block:^id(id total, id element) {
        return @([total integerValue] + [element integerValue]);
    }];
    
    XCTAssertNotNil(actualNumberValue, @"Returned number value is nil");
    
    long expectedValue = initialNumber.integerValue;
    for (NSNumber *number in randomNumbers) {
        expectedValue += number.integerValue;
    }
    
    XCTAssertEqual(actualNumberValue.integerValue, expectedValue, @"Injected value (%@) does not match expected value %ld", actualNumberValue, expectedValue);
}


- (void)testNSArrayBlockEnumerationDetect
{
    NSArray *randomNumbers = [self randomNumberArray];
    NSUInteger randomIndex = [UMKRandomUnsignedNumberInRange(NSMakeRange(0, randomNumbers.count)) unsignedIntegerValue];
    NSNumber *expectedElement = [randomNumbers objectAtIndex:randomIndex];
    
    NSNumber *actualElement = [randomNumbers twt_detectWithBlock:^BOOL(id element) {
        return [element isEqualToNumber:expectedElement];
    }];
    
    XCTAssertNotNil(actualElement, @"Detected number value is nil");
    XCTAssertEqualObjects(expectedElement, actualElement, @"Detected value (%@) does not match expected value (%@)", actualElement, expectedElement);
}


- (void)testNSArrayBlockEnumerationReject
{
    NSArray *randomNumbers = [self randomNumberArray];
    NSNumber *randomMaximumNumber = UMKRandomUnsignedNumber();
    
    NSArray *actualValues = [randomNumbers twt_rejectWithBlock:^BOOL(id element) {
        return [element compare:randomMaximumNumber] == NSOrderedDescending;
    }];
    
    XCTAssertNotNil(actualValues, @"Rejected value is nil");
    
    for (NSNumber *number in actualValues) {
        NSComparisonResult comparisonResult = [number compare:randomMaximumNumber];
        
        XCTAssertTrue(comparisonResult == NSOrderedAscending || comparisonResult == NSOrderedSame, @"Rejected array did not reject number (%@) greater than maximum (%@)", number, randomMaximumNumber);
    }
}


- (void)testNSArrayBlockEnumerationSelect
{
    NSArray *randomNumbers = [self randomNumberArray];
    NSUInteger randomIndex = [UMKRandomUnsignedNumberInRange(NSMakeRange(0, randomNumbers.count)) unsignedIntegerValue];
    NSNumber *expectedElement = [randomNumbers objectAtIndex:randomIndex];
    
    NSArray *actualValues = [randomNumbers twt_selectWithBlock:^BOOL(id element) {
        return [element isEqualToNumber:expectedElement];
    }];
    
    XCTAssertNotNil(actualValues, @"Rejected value is nil");
    
    for (NSNumber *number in actualValues) {
        NSComparisonResult comparisonResult = [number compare:expectedElement];
        
        XCTAssertTrue(comparisonResult == NSOrderedSame, @"Selected array selected number (%@) that is not equal to the expected number (%@)", number, expectedElement);
    }
}


@end

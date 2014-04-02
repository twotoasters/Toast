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

- (NSUInteger)randomCount
{
    return (random() % 1024) + 1;
}

- (NSArray *)randomStringArray
{
    NSSet *stringSet = UMKGeneratedSetWithElementCount([self randomCount], ^id{
        return UMKRandomUnicodeString();
    });
    return stringSet.allObjects;
}


- (NSArray *)randomNumberArray
{
    return UMKGeneratedArrayWithElementCount([self randomCount], ^id(NSUInteger index) {
        return UMKRandomUnsignedNumber();
    });
}


- (NSDictionary *)randomStringDictionary
{
    return UMKRandomDictionaryOfStringsWithElementCount([self randomCount]);
}

- (NSDictionary *)randomNumberDictionary
{
    return UMKGeneratedDictionaryWithElementCount([self randomCount], ^id{
        return UMKRandomAlphanumericString();
    }, ^id(id key) {
        return UMKRandomUnsignedNumber();
    });
}


- (NSArray *)collectionClasses
{
    return @[ [NSArray class], [NSSet class], [NSOrderedSet class] ];
}


#pragma mark - Key Value Collection Tests

- (void)testDictionaryBlockEnumerationCollect
{
    NSDictionary *randomNumberDictionary = [self randomStringDictionary];
    NSMutableDictionary *expectedDictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary *mappedDictionary = [randomNumberDictionary twt_collectWithBlock:^id(id element) {
        NSString *existingValue = [randomNumberDictionary objectForKey:element];
        NSString *mappedString = [existingValue stringByAppendingString:UMKRandomUnicodeString()];
        
        [expectedDictionary setObject:mappedString forKey:element];
        return mappedString;
    }];
    
    XCTAssertNotNil(mappedDictionary, @"Returned dictionary is nil");
    XCTAssertEqual(mappedDictionary.count, expectedDictionary.count, @"Returned dictionary does not match the size of the expected dictionary");
    XCTAssertEqualObjects(mappedDictionary, expectedDictionary, @"Returned dictionary does not match the expected dictionary");
}


- (void)testDictionaryBlockEnumerationInject
{
    NSDictionary *randomNumberDictionary = [self randomNumberDictionary];
    
    NSNumber *initialNumber = @(random());
    NSNumber *actualNumberValue = [randomNumberDictionary twt_injectWithInitialObject:initialNumber block:^id(id total, id element) {
        NSNumber *number = [randomNumberDictionary objectForKey:element];
        return @([total integerValue] + [number integerValue]);
    }];
    
    XCTAssertNotNil(actualNumberValue, @"Returned number value is nil");
    
    long expectedValue = initialNumber.integerValue;
    for (NSString *key in randomNumberDictionary) {
        NSNumber *number = [randomNumberDictionary objectForKey:key];
        expectedValue += number.integerValue;
    }
    
    XCTAssertEqual(actualNumberValue.integerValue, expectedValue, @"Injected value (%@) does not match expected value %ld", actualNumberValue, expectedValue);
}


- (void)testDictionaryBlockEnumerationDetect
{
    NSDictionary *randomNumbers = [self randomNumberDictionary];
    NSString *randomKey = [randomNumbers.allKeys objectAtIndex:random() % randomNumbers.count];
    NSNumber *expectedNumber = [randomNumbers objectForKey:randomKey];
    
    NSNumber *actualNumber = [randomNumbers twt_detectWithBlock:^BOOL(id element) {
        NSNumber *number = [randomNumbers objectForKey:element];
        return [number isEqualToNumber:expectedNumber];
    }];
    
    XCTAssertNotNil(actualNumber, @"Detected number value is nil");
    XCTAssertEqualObjects(expectedNumber, actualNumber, @"Detected value (%@) does not match expected value (%@)", actualNumber, expectedNumber);
}


- (void)testDictionaryBlockEnumerationReject
{
    NSDictionary *randomNumbers = [self randomNumberDictionary];
    NSNumber *randomMaximumNumber = UMKRandomUnsignedNumber();
    
    NSDictionary *actualValues = [randomNumbers twt_rejectWithBlock:^BOOL(id element) {
        NSNumber *number = [randomNumbers objectForKey:element];
        return [number compare:randomMaximumNumber] == NSOrderedDescending;
    }];
    
    XCTAssertNotNil(actualValues, @"Rejected dictionary is nil");
    
    for (NSString *key in actualValues) {
        NSNumber *number = [randomNumbers objectForKey:key];
        NSComparisonResult comparisonResult = [number compare:randomMaximumNumber];
        
        XCTAssertTrue(comparisonResult == NSOrderedAscending || comparisonResult == NSOrderedSame, @"Rejected array did not reject number (%@) greater than maximum (%@)", number, randomMaximumNumber);
    }
    
}


- (void)testDictionaryBlockEnumerationSelect
{
    NSDictionary *randomNumbers = [self randomNumberDictionary];
    NSString *randomKey = [randomNumbers.allKeys objectAtIndex:random() % randomNumbers.count];
    NSNumber *expectedNumber = [randomNumbers objectForKey:randomKey];
    
    NSDictionary *actualValues = [randomNumbers twt_selectWithBlock:^BOOL(id element) {
        NSNumber *number = [randomNumbers objectForKey:element];
        return [number isEqualToNumber:expectedNumber];
    }];
    
    XCTAssertNotNil(actualValues, @"Selected dictionary is nil");
    
    for (NSString *key in actualValues) {
        NSNumber *number = [randomNumbers objectForKey:key];
        NSComparisonResult comparisonResult = [number compare:expectedNumber];
        
        XCTAssertTrue(comparisonResult == NSOrderedSame, @"Selected array selected number (%@) that is not equal to the expected number (%@)", number, expectedNumber);
    }
}


#pragma mark - Collection Tests

- (void)testCollectionBlockEnumerationCollect
{
    for (Class class in [self collectionClasses]) {
        id randomCollection = [[class alloc] initWithArray:[self randomStringArray]];
        id expectedCollection = [[[class alloc] init] mutableCopy];
                                
        id mappedCollection = [randomCollection twt_collectWithBlock:^id(id element) {
            NSString *mappedString = [NSString stringWithFormat:@"%@%@", element, UMKRandomUnicodeString()];
            [expectedCollection addObject:mappedString];
            return mappedString;
        }];
        
        XCTAssertNotNil(mappedCollection, @"Returned collection is nil");
        XCTAssertEqual([randomCollection count], [mappedCollection count], @"Returned collection does not match size of original collection");
        XCTAssertEqualObjects(mappedCollection, expectedCollection, @"Mapped collection does not match the expected collection");
    }
}


- (void)testCollectionBlockEnumerationInject
{
    for (Class class in [self collectionClasses]) {
        id randomCollection = [[class alloc] initWithArray:[self randomNumberArray]];
        
        NSNumber *initialNumber = @(random());
        NSNumber *actualNumberValue = [randomCollection twt_injectWithInitialObject:initialNumber block:^id(id total, id element) {
            return @([total integerValue] + [element integerValue]);
        }];
        
        XCTAssertNotNil(actualNumberValue, @"Returned number value is nil");
        
        long expectedValue = initialNumber.integerValue;
        for (NSNumber *number in randomCollection) {
            expectedValue += number.integerValue;
        }
        
        XCTAssertEqual(actualNumberValue.integerValue, expectedValue, @"Injected value (%@) does not match expected value %ld", actualNumberValue, expectedValue);
    }
}


- (void)testCollectionBlockEnumerationDetect
{
    for (Class class in [self collectionClasses]) {
        NSArray *randomNumbers = [self randomNumberArray];
        NSNumber *expectedElement = [randomNumbers objectAtIndex:random() % randomNumbers.count];
        
        id randomCollection = [[class alloc] initWithArray:randomNumbers];
        NSNumber *actualElement = [randomCollection twt_detectWithBlock:^BOOL(id element) {
            return [element isEqualToNumber:expectedElement];
        }];
        
        XCTAssertNotNil(actualElement, @"Detected number value is nil");
        XCTAssertEqualObjects(expectedElement, actualElement, @"Detected value (%@) does not match expected value (%@)", actualElement, expectedElement);
    }
}


- (void)testCollectionBlockEnumerationReject
{
    for (Class class in [self collectionClasses]) {
        id randomCollection = [[class alloc] initWithArray:[self randomNumberArray]];
        NSNumber *randomMaximumNumber = UMKRandomUnsignedNumber();
        
        NSArray *actualValues = [randomCollection twt_rejectWithBlock:^BOOL(id element) {
            return [element compare:randomMaximumNumber] == NSOrderedDescending;
        }];
        
        XCTAssertNotNil(actualValues, @"Rejected array is nil");
        
        for (NSNumber *number in actualValues) {
            NSComparisonResult comparisonResult = [number compare:randomMaximumNumber];
            
            XCTAssertTrue(comparisonResult == NSOrderedAscending || comparisonResult == NSOrderedSame, @"Rejected array did not reject number (%@) greater than maximum (%@)", number, randomMaximumNumber);
        }
    }
}


- (void)testCollectionBlockEnumerationSelect
{
    for (Class class in [self collectionClasses]) {
        NSArray *randomNumbers = [self randomNumberArray];
        NSNumber *expectedElement = [randomNumbers objectAtIndex:random() % randomNumbers.count];
        
        id randomCollection = [[class alloc] initWithArray:randomNumbers];
        NSArray *actualValues = [randomCollection twt_selectWithBlock:^BOOL(id element) {
            return [element isEqualToNumber:expectedElement];
        }];
        
        XCTAssertNotNil(actualValues, @"Selected array is nil");
        
        for (NSNumber *number in actualValues) {
            NSComparisonResult comparisonResult = [number compare:expectedElement];
            
            XCTAssertTrue(comparisonResult == NSOrderedSame, @"Selected array selected number (%@) that is not equal to the expected number (%@)", number, expectedElement);
        }
    }
}


@end

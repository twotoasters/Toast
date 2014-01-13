//
//  TWTColorHelpersTests.m
//  Toast
//
//  Created by Josh Johnson on 1/13/14.
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
#import "UIColor+TWTColorHelpers.h"

@interface UIColorTWTColorHelpersTests : XCTestCase

@end

@implementation UIColorTWTColorHelpersTests

- (void)testTWTColorFromInteger
{
    UIColor *expected = [UIColor redColor];
    UIColor *testColor = [UIColor twt_colorWithHex:0xFF0000 alpha:1.0];
    
    XCTAssertEqualObjects(testColor, expected, @"Color created with integer hex was not created properly");
}

- (void)testTWTColorFromStringWithPound
{
    UIColor *expected = [UIColor redColor];
    UIColor *testColor = [UIColor twt_colorWithHexString:@"#FF0000" alpha:1.0];
    
    XCTAssertEqualObjects(testColor, expected, @"Color created from string (#FFFFFF) was not created properly");
}

- (void)testTWTColorFromStringWithoutPound
{
    UIColor *expected = [UIColor redColor];
    UIColor *testColor = [UIColor twt_colorWithHexString:@"FF0000" alpha:1.0];
    
    XCTAssertEqualObjects(testColor, expected, @"Color created from string (FFFFFF) was not created properly");
}

- (void)testTWTColorFromInvalidString
{
    UIColor *notExpected = [UIColor redColor];
    UIColor *testColor = [UIColor twt_colorWithHexString:@"RED IN THE LITTLE CODES" alpha:1.0];
    
    XCTAssertNotEqualObjects(notExpected, testColor, @"The color somehow magically matched the color expected.");
}

@end

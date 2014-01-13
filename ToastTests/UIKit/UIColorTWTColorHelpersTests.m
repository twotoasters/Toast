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


- (void)testTWTColorFromInvalidString
{
    UIColor *notExpected = [UIColor redColor];
    UIColor *testColor = [UIColor twt_colorWithHexString:@"RED IN THE LITTLE CODES" alpha:1.0];
    
    XCTAssertNotEqualObjects(notExpected, testColor, @"The color somehow magically matched the color expected.");
}


- (void)testTWTColorFromString
{
    for (NSUInteger i = 0; i < 65536; ++i) {
        BOOL includeOctothorpe = arc4random_uniform(2);
        unsigned int red = arc4random_uniform(255);
        unsigned int green = arc4random_uniform(255);
        unsigned int blue = arc4random_uniform(255);
        CGFloat alpha = (CGFloat)drand48();
        BOOL upperCase = arc4random_uniform(2);

        NSString *colorString = [NSString stringWithFormat:@"%@%02x%02x%02x", includeOctothorpe ? @"#" : @"", red, green, blue];
        if (upperCase) {
            colorString = colorString.uppercaseString;
        }

        UIColor *expectedColor = [UIColor colorWithRed:(CGFloat)red / 255.0 green:(CGFloat)green / 255.0 blue:(CGFloat)blue / 255.0 alpha:alpha];

        XCTAssertEqualObjects(expectedColor, [UIColor twt_colorWithHexString:colorString alpha:alpha], @"Wrong color for string (%@)", colorString);
    }
}

@end

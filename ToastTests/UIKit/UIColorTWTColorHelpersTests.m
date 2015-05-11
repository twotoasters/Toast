//
//  TWTColorHelpersTests.m
//  Toast
//
//  Created by Josh Johnson on 1/13/14.
//  Copyright (c) 2015 Ticketmaster
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
#import "TWTRandomizedTestCase.h"
#import "UIColor+TWTColorHelpers.h"

static NSUInteger kTWTIterationCount = 65536;

@interface UIColorTWTColorHelpersTests : TWTRandomizedTestCase

@end


@implementation UIColorTWTColorHelpersTests

- (UIColor *)getRandomColorWithRed:(unsigned *)redOut green:(unsigned *)greenOut blue:(unsigned *)blueOut alpha:(CGFloat *)alphaOut
{
    unsigned red = random() % 255;
    unsigned green = random() % 255;
    unsigned blue = random() % 255;
    CGFloat alpha = (CGFloat)drand48();

    if (redOut) { *redOut = red; }
    if (greenOut) { *greenOut = green; }
    if (blueOut) { *blueOut = blue; }
    if (alphaOut) { *alphaOut = alpha; }

    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}


- (void)testTWTColorFromInteger
{
    for (NSUInteger i = 0; i < kTWTIterationCount; ++i) {
        unsigned red, green, blue;
        CGFloat alpha;
        UIColor *expectedColor = [self getRandomColorWithRed:&red green:&green blue:&blue alpha:&alpha];

        uint32_t integerValue = (red << 16) + (green << 8) + blue;
        UIColor *actualColor = [UIColor twt_colorWithHex:integerValue alpha:alpha];

        XCTAssertEqualObjects(actualColor, expectedColor, @"Color created with integer hex (0x%x) was not created properly", integerValue);
    }

    // Edge cases (each component is either 0x00 or 0xFF)
    for (NSUInteger i = 0; i < 8; ++i) {
        unsigned red = ((i & 4) != 0) ? 0xff0000 : 0;
        unsigned green = ((i & 2) != 0) ? 0x00ff00 : 0;
        unsigned blue = ((i & 1) != 0) ? 0x0000ff : 0;

        uint32_t integerValue = red + green + blue;
        UIColor *expectedColor = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
        UIColor *actualColor = [UIColor twt_colorWithHex:integerValue alpha:1.0];

        XCTAssertEqualObjects(actualColor, expectedColor, @"Color created with integer hex (0x%x) was not created properly", integerValue);
    }
}


- (void)testTWTColorFromInvalidString
{
    XCTAssertThrowsSpecificNamed([UIColor twt_colorWithHexString:@"GREEN IN THE LITTLE CODES" alpha:1.0], NSException,
                                NSInternalInconsistencyException, @"A color was created with an invalid string.");
}


- (void)testTWTColorFromString
{
    for (NSUInteger i = 0; i < kTWTIterationCount; ++i) {
        unsigned red, green, blue;
        CGFloat alpha;
        UIColor *expectedColor = [self getRandomColorWithRed:&red green:&green blue:&blue alpha:&alpha];

        NSString *lowercaseColorString = [NSString stringWithFormat:@"%02x%02x%02x", red, green, blue];
        XCTAssertEqualObjects(expectedColor, [UIColor twt_colorWithHexString:lowercaseColorString alpha:alpha],
                              @"Wrong color for string (%@)", lowercaseColorString);

        NSString *lowercaseColorStringWithOctothorpe = [@"#" stringByAppendingString:lowercaseColorString];
        XCTAssertEqualObjects(expectedColor, [UIColor twt_colorWithHexString:lowercaseColorStringWithOctothorpe alpha:alpha],
                              @"Wrong color for string (%@)", lowercaseColorStringWithOctothorpe);

        NSString *uppercaseColorString = lowercaseColorString.uppercaseString;
        XCTAssertEqualObjects(expectedColor, [UIColor twt_colorWithHexString:uppercaseColorString alpha:alpha],
                              @"Wrong color for string (%@)", lowercaseColorString);

        NSString *uppercaseColorStringWithOctothorpe = lowercaseColorStringWithOctothorpe.uppercaseString;
        XCTAssertEqualObjects(expectedColor, [UIColor twt_colorWithHexString:uppercaseColorStringWithOctothorpe alpha:alpha],
                              @"Wrong color for string (%@)", uppercaseColorStringWithOctothorpe);
    }
}

@end

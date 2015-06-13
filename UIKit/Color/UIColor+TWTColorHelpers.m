//
//  UIColor+TWTColorHelpers.m
//  Toast
//
//  Created by Kevin Conner on 1/13/2014.
//  Copyright (c) 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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

#import "UIColor+TWTColorHelpers.h"

@implementation UIColor (TWTColorHelpers)

+ (UIColor *)twt_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha
{
    CGFloat red   = (CGFloat) ((hex & 0xff0000) >> 16) / 255.0f;
    CGFloat green = (CGFloat) ((hex & 0x00ff00) >> 8)  / 255.0f;
    CGFloat blue  = (CGFloat)  (hex & 0x0000ff)        / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)twt_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^#?[0-9a-f]{6}$" options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    NSArray *matches = [regex matchesInString:hexString options:NSMatchingAnchored range:NSMakeRange(0, hexString.length)];
    BOOL hexStringValid = (0 < matches.count);

    NSAssert(hexStringValid, @"Tried to parse a hex color that was invalid: %@ (must be of the form #ffffff or ffffff)", hexString);

    UIColor *color = nil;
    if (hexStringValid) {
        NSScanner *scanner = [NSScanner scannerWithString:hexString];
        scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:@"#"];
        unsigned int hex;
        [scanner scanHexInt:&hex];
        color = [UIColor twt_colorWithHex:hex alpha:alpha];
    }
    
    return color;
}

@end

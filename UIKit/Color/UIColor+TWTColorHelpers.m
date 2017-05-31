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


NSString *const kTWTColorHelpersErrorDomain = @"TWTColorHelpersErrorDomain";


@implementation UIColor (TWTColorHelpers)

+ (UIColor *)twt_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha
{
    CGFloat red   = (CGFloat) ((hex & 0xff0000) >> 16) / 255.0f;
    CGFloat green = (CGFloat) ((hex & 0x00ff00) >> 8)  / 255.0f;
    CGFloat blue  = (CGFloat)  (hex & 0x0000ff)        / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)twt_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha error:(NSError * __autoreleasing *)outError
{
    NSString *normalizedHexString = [self twt_normalizedHexStringWithHexString:hexString];
    UIColor *color = nil;
    if (!normalizedHexString) {
        if (outError) {
            // TODO(Andrew): is there a strings table in Toast? If not, set one up.
            NSString *localizedDescription = [NSString stringWithFormat:@"%@ is not a valid hex string. Hex strings must be in the format #FFFFFF, #FFF, FFFFFF, or FFF.", hexString];
            *outError = [NSError errorWithDomain:kTWTColorHelpersErrorDomain
                                            code:TWTColorHelpersErrorInvalidHexString
                                        userInfo:@{ NSLocalizedDescriptionKey : localizedDescription }];
        }
        return nil;
    }

    NSScanner *scanner = [NSScanner scannerWithString:normalizedHexString];
    unsigned int hex;
    [scanner scanHexInt:&hex];
    color = [UIColor twt_colorWithHex:hex alpha:alpha];

    return color;
}


+ (NSString *)twt_normalizedHexStringWithHexString:(NSString *)hexString
{
    static NSRegularExpression *regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"^#?([0-9a-f]{1,2}?)([0-9a-f]{1,2}?)([0-9a-f]{1,2}?)$" options:NSRegularExpressionCaseInsensitive error:NULL];
    });

    NSArray *matches = [regex matchesInString:hexString options:NSMatchingAnchored range:NSMakeRange(0, hexString.length)];
    NSTextCheckingResult *textCheckingResult = [matches firstObject];

    if (textCheckingResult.numberOfRanges != 4) {
        return nil;
    }

    NSArray *componentStrings = @[ [hexString substringWithRange:[textCheckingResult rangeAtIndex:1]],
                                   [hexString substringWithRange:[textCheckingResult rangeAtIndex:2]],
                                   [hexString substringWithRange:[textCheckingResult rangeAtIndex:3]] ];
    NSMutableString *normalizedHexString = [[NSMutableString alloc] init];
    for (NSString *componentString in componentStrings) {
        // Append twice if the component was only of length 1
        if (componentString.length == 1) {
            [normalizedHexString appendString:componentString];
        }
        [normalizedHexString appendString:componentString];
    }

    return normalizedHexString;
}


- (NSString *)twt_hexadecimalString
{
    CGFloat red = 0, blue = 0, green = 0;

    if (![self getRed:&red green:&green blue:&blue alpha:nil]) {
        return nil;
    }

    return [NSString stringWithFormat:@"#%02lx%02lx%02lx", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255)];
}

@end

//
//  UIColor+TWTColorHelpers.h
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

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, TWTColorHelpersError) {
    TWTColorHelpersErrorInvalidHexString
};


extern NSString *const kTWTColorHelpersErrorDomain;


@interface UIColor (TWTColorHelpers)

/**
 @abstract Create a UIColor with a Hex value.  
 @param hex An integer hex value to used to create a value.
 @param alpha A CGFloat value to control the alpha of the color.
 @result A new instance of a UIColor
 */
+ (UIColor *)twt_colorWithHex:(uint32_t)hex alpha:(CGFloat)alpha;

/**
 @abstract Create a UIColor with a Hex String.
 @param hexString A hex string conforming to #FFFFFF, #FFF, FFFFFF, or FFF defining the color to build.
 @param alpha A CGFloat value to control the alpha of the color.
 @result A new instance of a UIColor
 */
+ (UIColor *)twt_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha error:(NSError * __autoreleasing *)outError;

/*!
 @abstract Returns a hexidecimal string representation of the receiver, or nil if the color cannot be converted to RGB components.
 @discussion Format of the result begins with a # character and uses lower case letters (e.g., "#ff0000")
 */
- (NSString *)twt_hexadecimalString;

@end

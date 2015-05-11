//
//  TWTTextStyle.h
//  Toast
//
//  Created by Kevin Conner on 7/29/14.
//  Copyright (c) 2015 Ticketmaster All rights reserved.
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

@interface TWTTextStyle : NSObject

@property (nonatomic, readonly, strong) UIFont *font;
@property (nonatomic, readonly, strong) UIColor *color;
@property (nonatomic, readonly, strong) UIColor *highlightColor;
@property (nonatomic, readonly, strong) UIColor *disabledColor;

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color highlightColor:(UIColor *)highlightColor disabledColor:(UIColor *)disabledColor;
- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color;

- (NSDictionary *)textAttributes;
- (NSDictionary *)highlightedTextAttributes;
- (NSDictionary *)disabledTextAttributes;

- (void)styleLabel:(UILabel *)label;
- (void)styleTextField:(UITextField *)textField;
- (void)styleTextView:(UITextView *)textView;
- (void)styleButton:(UIButton *)button;
- (void)styleBarButtonItem:(UIBarButtonItem *)item;

@end

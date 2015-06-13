//
//  TWTTextStyle.m
//  Toast
//
//  Created by Kevin Conner on 7/29/14.
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

#import "TWTTextStyle.h"

@implementation TWTTextStyle

#pragma mark - Helpers

- (NSDictionary *)textAttributesWithColor:(UIColor *)color
{
    return @{ NSFontAttributeName: self.font,
              NSForegroundColorAttributeName: color };
}

#pragma mark - Init/dealloc

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color highlightColor:(UIColor *)highlightColor disabledColor:(UIColor *)disabledColor
{
    NSParameterAssert(font);
    NSParameterAssert(color);
    
    self = [super init];
    if (self) {
        _font = font;
        _color = color;
        _highlightColor = highlightColor ?: color;
        _disabledColor = disabledColor ?: color;
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font color:(UIColor *)color
{
    return [self initWithFont:font color:color highlightColor:nil disabledColor:nil];
}

#pragma mark - Public interface

- (NSDictionary *)textAttributes
{
    return [self textAttributesWithColor:self.color];
}

- (NSDictionary *)highlightedTextAttributes
{
    return [self textAttributesWithColor:self.highlightColor];
}

- (NSDictionary *)disabledTextAttributes
{
    return [self textAttributesWithColor:self.disabledColor];
}

#pragma mark -

- (void)styleLabel:(UILabel *)label
{
    label.font = self.font;
    label.textColor = self.color;
}

- (void)styleTextField:(UITextField *)textField
{
    textField.font = self.font;
    textField.textColor = self.color;
}

- (void)styleTextView:(UITextView *)textView
{
    textView.font = self.font;
    textView.textColor = self.color;
}

- (void)styleButton:(UIButton *)button
{
    button.titleLabel.font = self.font;
    [button setTitleColor:self.color forState:UIControlStateNormal];
    [button setTitleColor:self.highlightColor forState:UIControlStateHighlighted];
    [button setTitleColor:self.disabledColor forState:UIControlStateDisabled];
}

- (void)styleBarButtonItem:(UIBarButtonItem *)item
{
    [item setTitleTextAttributes:self.textAttributes forState:UIControlStateNormal];
    [item setTitleTextAttributes:self.disabledTextAttributes forState:UIControlStateDisabled];
    // Don't set highlighted attributes; automatic fade effect looks better
}

@end

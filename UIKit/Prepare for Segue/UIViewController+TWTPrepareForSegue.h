//
//  UIViewController+TWTPrepareForSegue.h
//  Toast
//
//  Created by Prachi Gauriar on 5/22/14.
//  Copyright (c) 2014 Two Toasters, LLC.
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

@interface UIViewController (TWTPrepareForSegue)

/*!
 @abstract Invokes twt_prepareFor«Identifier»Segue:sender: on self, where «Identifier» is the capitalized
     form of the segue’s identifier.
 @discussion UIViewController subclasses typically invoke this method from -prepareForSegue:sender:.
 @param segue The segue to prepare for. If the segue is nil or has a nil identifier, this method returns 
    immediately.
 @param sender The sender that started the segue.
 */
- (void)twt_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end

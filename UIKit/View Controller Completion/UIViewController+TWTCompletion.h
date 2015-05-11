//
//  UIViewController+TWTCompletion.h
//  Toast
//
//  Created by Andrew Hershberger on 5/22/14.
//  Copyright (c) 2015 Ticketmaster. All rights reserved.
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


@interface UIViewController (TWTCompletion)

/*!
 Presented view controllers need a way to signal to their presenter when they are done. twt_completion
 facilitates this pattern. The presenter sets the twt_completion block and then when the presented view
 controller is done, it calls twt_finish or twt_cancel. This property is set to nil just before the block is
 invoked to break any strong reference cycles.
 */
@property (nonatomic, copy) void(^twt_completion)(BOOL finished);

- (IBAction)twt_finish;

- (IBAction)twt_cancel;

@end

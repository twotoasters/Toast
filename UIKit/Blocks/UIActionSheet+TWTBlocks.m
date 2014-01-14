//
//  UIActionSheet+TWTBlocks.m
//  Toast
//
//  Based on SXYActionSheet, created by Jeremy Ellison on 2/9/12.
//  Created by Andrew Hershberger on 6 February 2013
//  Copyright (c) 2013 Two Toasters, LLC.
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

#import "UIActionSheet+TWTBlocks.h"
#import <objc/runtime.h>

static char kTapHandlerKey;

@implementation UIActionSheet (TWTBlocks)

- (void)twt_setTapHandler:(TWTActionSheetBlock)tapHandler
{
    self.delegate = tapHandler ? self : nil;

    objc_setAssociatedObject(self, &kTapHandlerKey, tapHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TWTActionSheetBlock)twt_tapHandler
{
    return objc_getAssociatedObject(self, &kTapHandlerKey);
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    TWTActionSheetBlock tapHandler = self.twt_tapHandler;
    if (tapHandler) {
        tapHandler(self, buttonIndex);
    }
    self.twt_tapHandler = nil;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.twt_tapHandler = nil;
}

@end

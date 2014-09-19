//
//  UIButton+TWTBlocks.m
//  Toast
//
//  Created by Duncan Lewis on 8/1/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "UIButton+TWTBlocks.h"
#import <objc/runtime.h>

static char kTapHandlerKey;

@implementation UIButton (TWTBlocks)

- (TWTButtonTapBlock)twt_tapHandler
{
    return objc_getAssociatedObject(self, &kTapHandlerKey);
}

- (void)twt_setTapHandler:(TWTButtonTapBlock)twt_tapHandler
{
    // remove old tap handler
    if (self.twt_tapHandler) {
        [self removeTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    objc_setAssociatedObject(self, &kTapHandlerKey, twt_tapHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    if (twt_tapHandler) {
        [self addTarget:self action:@selector(buttonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buttonWasTapped:(id)sender
{
    if (self.twt_tapHandler) {
        self.twt_tapHandler(sender);
    }
}

@end

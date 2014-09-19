//
//  UIButton+TWTBlocks.h
//  Toast
//
//  Created by Duncan Lewis on 8/1/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TWTButtonTapBlock)(UIButton *button);

@interface UIButton (TWTBlocks)

@property (nonatomic, copy, setter = twt_setTapHandler:) TWTButtonTapBlock twt_tapHandler;

@end

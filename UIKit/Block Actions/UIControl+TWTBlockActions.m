//
//  UIControl+TWTBlockActions.m
//  Toast
//
//  Created by Prachi Gauriar on 10/23/2014.
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

#import "UIControl+TWTBlockActions.h"

#import <objc/runtime.h>


@interface TWTBlockAction : NSObject

@property (nonatomic, assign, readonly) UIControlEvents controlEvents;
@property (nonatomic, copy, readonly) void (^block)(id sender, UIEvent *event);

- (instancetype)initWithControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender, UIEvent *event))block NS_DESIGNATED_INITIALIZER;
- (void)addActionToControl:(UIControl *)control;
- (void)removeActionFromControl:(UIControl *)control;

@end


#pragma mark -

@implementation TWTBlockAction

- (instancetype)init
{
    return [self initWithControlEvents:0 block:nil];
}


- (instancetype)initWithControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender, UIEvent *event))block
{
    NSParameterAssert(block);

    if (self = [super init]) {
        _controlEvents = controlEvents;
        _block = [block copy];
    }

    return self;
}


- (void)addActionToControl:(UIControl *)control
{
    [control addTarget:self action:@selector(performActionWithSender:event:) forControlEvents:self.controlEvents];
}


- (void)removeActionFromControl:(UIControl *)control
{
    [control removeTarget:self action:@selector(performActionWithSender:event:) forControlEvents:self.controlEvents];
}


- (void)performActionWithSender:(id)sender event:(UIEvent *)event
{
    self.block(sender, event);
}

@end


#pragma mark -

@implementation UIControl (TWTBlocks)

- (NSMutableSet *)twt_blockActions
{
    NSMutableSet *blockActions = objc_getAssociatedObject(self, _cmd);
    if (!blockActions) {
        blockActions = [[NSMutableSet alloc] init];
        objc_setAssociatedObject(self, _cmd, blockActions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return blockActions;
}


- (id)twt_addBlockActionForControlEvents:(UIControlEvents)controlEvents block:(void (^)(id sender, UIEvent *event))block
{
    TWTBlockAction *blockAction = [[TWTBlockAction alloc] initWithControlEvents:controlEvents block:block];
    [blockAction addActionToControl:self];
    [[self twt_blockActions] addObject:blockAction];
    return blockAction;
}


- (void)twt_removeBlockAction:(id)blockAction
{
    [blockAction removeActionFromControl:self];
    [[self twt_blockActions] removeObject:blockAction];
}

@end

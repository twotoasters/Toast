//
//  TWTNibBackedView.m
//  Toast
//
//  Created by Prachi Gauriar on 10/22/2014.
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

#import "TWTNibBackedView.h"


@implementation TWTNibBackedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self instantiateObjectsInBackingNib];
    }

    return self;
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self instantiateObjectsInBackingNib];
    }

    return self;
}


- (void)instantiateObjectsInBackingNib
{
    [[[self class] nib] instantiateWithOwner:self options:nil];

    NSAssert(self.contentView, @"contentView outlet was not set in nib");
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.contentView];
    [self didInstantiateObjectsInBackingNib];
}


- (void)didInstantiateObjectsInBackingNib
{
}


+ (UINib *)nib
{
    return [UINib nibWithNibName:[self nibName] bundle:[self nibBundle]];
}


+ (NSString *)nibName
{
    return NSStringFromClass(self);
}


+ (NSBundle *)nibBundle
{
    return [NSBundle bundleForClass:[self class]];
}

@end

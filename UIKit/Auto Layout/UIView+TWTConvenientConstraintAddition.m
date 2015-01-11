//
//  UIView+TWTConvenientConstraintAddition.m
//  Toast
//
//  Created by Prachi Gauriar on 12/12/2013.
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

#import "UIView+TWTConvenientConstraintAddition.h"

@implementation UIView (TWTConvenientConstraintAddition)

- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings views:(NSDictionary *)views
{
    return [self twt_addConstraintsWithVisualFormatStrings:formatStrings options:0 metrics:nil views:views];
}


- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    return [self twt_addConstraintsWithVisualFormatStrings:formatStrings options:0 metrics:metrics views:views];
}


- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings options:(NSLayoutFormatOptions)options
                                          metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    NSMutableArray *constraints = [[NSMutableArray alloc] init];
    
    for (NSString *formatString in formatStrings) {
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:formatString options:options metrics:metrics views:views]];
    }
    
    [self addConstraints:constraints];
    return [constraints copy];
}


- (NSLayoutConstraint *)twt_addHeightConstraintWithConstant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];

    [self addConstraint:constraint];

    return constraint;
}


- (NSLayoutConstraint *)twt_addWidthConstraintWithConstant:(CGFloat)constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];

    [self addConstraint:constraint];

    return constraint;
}

- (NSLayoutConstraint *)twt_addVerticalCenteringConstraintWithView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    [self addConstraint:constraint];
    
    return constraint;

}

- (NSLayoutConstraint *)twt_addHorizontalCenteringConstraintWithView:(UIView *)view
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    [self addConstraint:constraint];
    
    return constraint;
}

@end

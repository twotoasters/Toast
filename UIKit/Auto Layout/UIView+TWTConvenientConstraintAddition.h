//
//  UIView+TWTConvenientConstraintAddition.h
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

#import <UIKit/UIKit.h>

/*!
 The TWTConvenientConstraintAddition category of UIView adds methods for adding constraints for several
 visual format strings with a single message send.
 */
@interface UIView (TWTConvenientConstraintAddition)

/*!
 @abstract Adds constraints to the reciever for the specified visual format strings and views.
 @discussion Constraints are generated with no special layout format options or metrics.
 @param formatStrings An array of visual format strings for which to generate constraints.
 @param views A dictionary of views that appear in the visual format strings. The keys must be the string
     values used in the visual format strings, and the values must be the view objects.
 @result The constraints that were added.
 */
- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings views:(NSDictionary *)views;

/*!
 @abstract Adds constraints to the reciever for the specified visual format strings, metrics, and views.
 @discussion Constraints are generated with no special layout format options.
 @param formatStrings An array of visual format strings for which to generate constraints.
 @param metrics A dictionary of constants that appear in the visual format strings. The keys must be the
     string values used in the visual format strings, and the values must be NSNumber objects.
 @param views A dictionary of views that appear in the visual format strings. The keys must be the string
     values used in the visual format strings, and the values must be the view objects.
 @result The constraints that were added.
 */
- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/*!
 @abstract Adds constraints to the reciever for the specified visual format strings, options, metrics, and views.
 @param formatStrings An array of visual format strings for which to generate constraints.
 @param options Options describing the attribute and the direction of layout for all objects in each visual format
     string.
 @param metrics A dictionary of constants that appear in the visual format strings. The keys must be the
     string values used in the visual format strings, and the values must be NSNumber objects.
 @param views A dictionary of views that appear in the visual format strings. The keys must be the string
     values used in the visual format strings, and the values must be the view objects.
 @result The constraints that were added.
 */
- (NSArray *)twt_addConstraintsWithVisualFormatStrings:(NSArray *)formatStrings options:(NSLayoutFormatOptions)options
                                               metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/*!
 @abstract Adds a height constraint to the reciever for the specified constant.
 @param constant A CGFloat specifying the value of the height
 @result The constraint that was added.
 */
- (NSLayoutConstraint *)twt_addHeightConstraintWithConstant:(CGFloat)constant;

/*!
 @abstract Adds a width constraint to the reciever for the specified constant.
 @param constant A CGFloat specifying the value of the width
 @result The constraint that was added.
 */
- (NSLayoutConstraint *)twt_addWidthConstraintWithConstant:(CGFloat)constant;

/*!
 @abstract Adds a vertical centering constraint to the reciever for the specified view.
 @param view The UIView to be vertically centered.
 @result The constraint that was added.
 */
- (NSLayoutConstraint *)twt_addVerticalCenteringConstraintWithView:(UIView *)view;

/*!
 @abstract Adds a horizontal centering constraint to the reciever for the specified view.
 @param view The UIView to be horizontally centered.
 @result The constraint that was added.
 */
- (NSLayoutConstraint *)twt_addHorizontalCenteringConstraintWithView:(UIView *)view;

@end

//
//  UIView+TWTSnapshotImage.h
//  Toast
//
//  Created by Prachi Gauriar on 3/11/2014.
//  Copyright (c) 2015 Ticketmaster.
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
 The TWTSnapshotImage category of UIView provides a convenient method for getting a snapshot image of a view’s hiearachy.
 */
@interface UIView (TWTSnapshotImage)

/*!
 @abstract Renders and returns a snapshot image of the receiver’s view hiearachy with the specified background color.
 @param backgroundColor The background color to draw under the view’s non-opaque regions. If nil, no background
     color is drawn.
 @param afterUpdates Whether the snapshot should be rendered after recent changes have been incorporated. Specify 
     the value NO if you want to render a snapshot in the view hierarchy’s current state, which might not include
     recent changes.
 @result A snapshot image of the receiver and its subviews.
 */
- (UIImage *)twt_snapshotImageWithBackgroundColor:(UIColor *)backgroundColor afterScreenUpdates:(BOOL)afterUpdates;

@end

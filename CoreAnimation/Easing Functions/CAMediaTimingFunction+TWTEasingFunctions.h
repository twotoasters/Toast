//
//  CAMediaTimingFunction+TWTEasingFunctions.h
//  Toast
//
//  Created by Prachi Gauriar on 11/24/2014.
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

#import <QuartzCore/QuartzCore.h>


/*!
 The TWTEasingFunctions category of CAMediaTimingFunctions adds numerous convenience factory methods
 for creating common easing timing functions.
 
 For more information about these timing functions, visit http://easings.net
 */
@interface CAMediaTimingFunction (TWTEasingFunctions)

/*!
 @abstract Returns the sine ease-in timing function.
 @discussion The timing function uses control points (0.47, 0) and (0.745, 0.715).
 @result The sine ease-in timing function.
 */
+ (instancetype)twt_sineEaseInFunction;

/*!
 @abstract Returns the sine ease-out timing function.
 @discussion The timing function uses control points (0.39, 0.575) and (0.565, 1).
 @result The sine ease-out timing function.
 */
+ (instancetype)twt_sineEaseOutFunction;

/*!
 @abstract Returns the sine ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.445, 0.05) and (0.55, 0.95).
 @result The sine ease-in/ease-out timing function.
 */
+ (instancetype)twt_sineEaseInOutFunction;

/*!
 @abstract Returns the quadratic ease-in timing function.
 @discussion The timing function uses control points (0.55, 0.085) and (0.68, 0.53).
 @result The quadratic ease-in timing function.
 */
+ (instancetype)twt_quadraticEaseInFunction;

/*!
 @abstract Returns the quadratic ease-out timing function.
 @discussion The timing function uses control points (0.25, 0.46) and (0.45, 0.94).
 @result The quadratic ease-out timing function.
 */
+ (instancetype)twt_quadraticEaseOutFunction;

/*!
 @abstract Returns the quadratic ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.455, 0.03) and (0.515, 0.955).
 @result The quadratic ease-in/ease-out timing function.
 */
+ (instancetype)twt_quadraticEaseInOutFunction;

/*!
 @abstract Returns the cubic ease-in timing function.
 @discussion The timing function uses control points (0.55, 0.055) and (0.675, 0.19).
 @result The cubic ease-in timing function.
 */
+ (instancetype)twt_cubicEaseInFunction;

/*!
 @abstract Returns the cubic ease-out timing function.
 @discussion The timing function uses control points (0.215, 0.61) and (0.355, 1).
 @result The cubic ease-out timing function.
 */
+ (instancetype)twt_cubicEaseOutFunction;

/*!
 @abstract Returns the cubic ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.645, 0.045) and (0.355, 1).
 @result The cubic ease-in/ease-out timing function.
 */
+ (instancetype)twt_cubicEaseInOutFunction;

/*!
 @abstract Returns the quartic ease-in timing function.
 @discussion The timing function uses control points (0.895, 0.03) and (0.685, 0.22).
 @result The quartic ease-in timing function.
 */
+ (instancetype)twt_quarticEaseInFunction;

/*!
 @abstract Returns the quartic ease-out timing function.
 @discussion The timing function uses control points (0.165, 0.84) and (0.44, 1).
 @result The quartic ease-out timing function.
 */
+ (instancetype)twt_quarticEaseOutFunction;

/*!
 @abstract Returns the quartic ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.77, 0) and (0.175, 1).
 @result The quartic ease-in/ease-out timing function.
 */
+ (instancetype)twt_quarticEaseInOutFunction;

/*!
 @abstract Returns the quintic ease-in timing function.
 @discussion The timing function uses control points (0.755, 0.05) and (0.855, 0.06).
 @result The quintic ease-in timing function.
 */
+ (instancetype)twt_quinticEaseInFunction;

/*!
 @abstract Returns the quintic ease-out timing function.
 @discussion The timing function uses control points (0.23, 1) and (0.32, 1).
 @result The quintic ease-out timing function.
 */
+ (instancetype)twt_quinticEaseOutFunction;

/*!
 @abstract Returns the quintic ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.86, 0) and (0.07, 1).
 @result The quintic ease-in/ease-out timing function.
 */
+ (instancetype)twt_quinticEaseInOutFunction;

/*!
 @abstract Returns the exponential ease-in timing function.
 @discussion The timing function uses control points (0.95, 0.05) and (0.795, 0.035).
 @result The exponential ease-in timing function.
 */
+ (instancetype)twt_exponentialEaseInFunction;

/*!
 @abstract Returns the exponential ease-out timing function.
 @discussion The timing function uses control points (0.19, 1) and (0.22, 1).
 @result The exponential ease-out timing function.
 */
+ (instancetype)twt_exponentialEaseOutFunction;

/*!
 @abstract Returns the exponential ease-in/ease-out timing function.
 @discussion The timing function uses control points (1, 0) and (0, 1).
 @result The exponential ease-in/ease-out timing function.
 */
+ (instancetype)twt_exponentialEaseInOutFunction;

/*!
 @abstract Returns the circular ease-in timing function.
 @discussion The timing function uses control points (0.6, 0.04) and (0.98, 0.335).
 @result The circular ease-in timing function.
 */
+ (instancetype)twt_circularEaseInFunction;

/*!
 @abstract Returns the circular ease-out timing function.
 @discussion The timing function uses control points (0.075, 0.82) and (0.165, 1).
 @result The circular ease-out timing function.
 */
+ (instancetype)twt_circularEaseOutFunction;

/*!
 @abstract Returns the circular ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.785, 0.135) and (0.15, 0.86).
 @result The circular ease-in/ease-out timing function.
 */
+ (instancetype)twt_circularEaseInOutFunction;

/*!
 @abstract Returns the back ease-in timing function.
 @discussion The timing function uses control points (0.6, -0.28) and (0.735, 0.045).
 @result The back ease-in timing function.
 */
+ (instancetype)twt_backEaseInFunction;

/*!
 @abstract Returns the back ease-out timing function.
 @discussion The timing function uses control points (0.175, 0.885) and (0.32, 1.275).
 @result The back ease-out timing function.
 */
+ (instancetype)twt_backEaseOutFunction;

/*!
 @abstract Returns the back ease-in/ease-out timing function.
 @discussion The timing function uses control points (0.68, -0.55) and (0.265, 1.55).
 @result The back ease-in/ease-out timing function.
 */
+ (instancetype)twt_backEaseInOutFunction;

@end

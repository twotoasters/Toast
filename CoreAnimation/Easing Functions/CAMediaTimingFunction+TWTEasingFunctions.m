//
//  CAMediaTimingFunction+TWTEasingFunctions.m
//  Toast
//
//  Created by Prachi Gauriar on 11/24/2014.
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

#import "CAMediaTimingFunction+TWTEasingFunctions.h"


#define TWTMediaTimingFunctionMethodWithControlPoints(name, c1x, c1y, c2x, c2y)  \
+ (instancetype)twt_##name##Function                                             \
{                                                                                \
    static CAMediaTimingFunction *function = nil;                                \
    static dispatch_once_t onceToken;                                            \
    dispatch_once(&onceToken, ^{                                                 \
        function = [[self alloc] initWithControlPoints:c1x :c1y :c2x :c2y];      \
    });                                                                          \
    return function;                                                             \
}


@implementation CAMediaTimingFunction (TWTEasingFunctions)

TWTMediaTimingFunctionMethodWithControlPoints(sineEaseIn, 0.47, 0, 0.745, 0.715);
TWTMediaTimingFunctionMethodWithControlPoints(sineEaseOut, 0.39, 0.575, 0.565, 1);
TWTMediaTimingFunctionMethodWithControlPoints(sineEaseInOut, 0.445, 0.05, 0.55, 0.95);

TWTMediaTimingFunctionMethodWithControlPoints(quadraticEaseIn, 0.55, 0.085, 0.68, 0.53);
TWTMediaTimingFunctionMethodWithControlPoints(quadraticEaseOut, 0.25, 0.46, 0.45, 0.94);
TWTMediaTimingFunctionMethodWithControlPoints(quadraticEaseInOut, 0.455, 0.03, 0.515, 0.955);

TWTMediaTimingFunctionMethodWithControlPoints(cubicEaseIn, 0.55, 0.055, 0.675, 0.19);
TWTMediaTimingFunctionMethodWithControlPoints(cubicEaseOut, 0.215, 0.61, 0.355, 1);
TWTMediaTimingFunctionMethodWithControlPoints(cubicEaseInOut, 0.645, 0.045, 0.355, 1);

TWTMediaTimingFunctionMethodWithControlPoints(quarticEaseIn, 0.895, 0.03, 0.685, 0.22);
TWTMediaTimingFunctionMethodWithControlPoints(quarticEaseOut, 0.165, 0.84, 0.44, 1);
TWTMediaTimingFunctionMethodWithControlPoints(quarticEaseInOut, 0.77, 0, 0.175, 1);

TWTMediaTimingFunctionMethodWithControlPoints(quinticEaseIn, 0.755, 0.05, 0.855, 0.06);
TWTMediaTimingFunctionMethodWithControlPoints(quinticEaseOut, 0.23, 1, 0.32, 1);
TWTMediaTimingFunctionMethodWithControlPoints(quinticEaseInOut, 0.86, 0, 0.07, 1);

TWTMediaTimingFunctionMethodWithControlPoints(exponentialEaseIn, 0.95, 0.05, 0.795, 0.035);
TWTMediaTimingFunctionMethodWithControlPoints(exponentialEaseOut, 0.19, 1, 0.22, 1);
TWTMediaTimingFunctionMethodWithControlPoints(exponentialEaseInOut, 1, 0, 0, 1);

TWTMediaTimingFunctionMethodWithControlPoints(circularEaseIn, 0.6, 0.04, 0.98, 0.335);
TWTMediaTimingFunctionMethodWithControlPoints(circularEaseOut, 0.075, 0.82, 0.165, 1);
TWTMediaTimingFunctionMethodWithControlPoints(circularEaseInOut, 0.785, 0.135, 0.15, 0.86);

TWTMediaTimingFunctionMethodWithControlPoints(backEaseIn, 0.6, -0.28, 0.735, 0.045);
TWTMediaTimingFunctionMethodWithControlPoints(backEaseOut, 0.175, 0.885, 0.32, 1.275);
TWTMediaTimingFunctionMethodWithControlPoints(backEaseInOut, 0.68, -0.55, 0.265, 1.55);

@end

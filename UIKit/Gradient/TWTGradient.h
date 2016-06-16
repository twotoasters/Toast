//
//  TWTGradient.h
//
//  Created by Prachi Gauriar on 11/17/2015.
//  Copyright © 2015 Ticketmaster Entertainment, Inc. All rights reserved.
//

@import UIKit;

@class TWTGradientColor;


NS_ASSUME_NONNULL_BEGIN

/*!
 TWTGradient models the concept of a color gradient. Each gradient contains a set of gradient colors, each of which
 contains a color and the location in the gradient where the color should appear. Once a gradient object has been
 created, it can be used to render linear or radial gradients to an image.
 */
@interface TWTGradient : NSObject <NSCopying, NSSecureCoding>

/*! The instance’s gradient colors. */
@property (nonatomic, copy, readonly) NSArray<TWTGradientColor *> *gradientColors;

/*! A CGGradient configured with the instance’s colors and locations. */
@property (nonatomic, assign, readonly) CGGradientRef CGGradient;

/*! Do not use this method; use ‑initWithGradientColors: instead. */
- (instancetype)init NS_UNAVAILABLE;

/*!
 @abstract Initializes a newly created TWTGradient instance with the specified gradient colors.
 @param gradientColors An array of gradient colors. Behavior is undefined if there are two colors in this array with the
     same location. If there is no color at location 0.0 and 1.0, the colors in the array closest to those values are
     used for 0.0 and 1.0. May not be nil or empty.
 @result A newly initialized TWTGradient instance.
 */
- (instancetype)initWithGradientColors:(NSArray<TWTGradientColor *> *)gradientColors NS_DESIGNATED_INITIALIZER;

/*!
 @abstract Generates and returns an image of a linear gradient using the instance’s gradient colors.
 @discussion The start point and end point parameters must be in the image’s coordinate space. The origin is in the
     upper-left of the image with x-coordinates increasing from left-to-right and y-coordinates increasing from
     top-to-bottom.
 @param size The size of the image in points. The scale of the image is the same as that of main screen.
 @param startPoint The coordinate that defines the starting point of the gradient in the new image’s coordinate space.
     The gradient color displayed at this location is the one whose location is 0.0.
 @param endPoint The coordinate that defines the ending point of the gradient in the new image’s coordinate space.
     The gradient color displayed at this location is the one whose location is 1.0.
 @result An image containing a linear gradient using the instance’s gradient colors.
 */
- (UIImage *)linearGradientImageWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

/*!
 @abstract Generates and returns an image of a radial gradient using the instance’s gradient colors.
 @discussion The center point and radius must be in the image’s coordinate space. The origin is in the
     upper-left of the image with x-coordinates increasing from left-to-right and y-coordinates increasing from
     top-to-bottom.
 @param size The size of the image in points. The scale of the image is the same as that of main screen.
 @param center The coordinate that defines the center point of the gradient in the new image’s coordinate space.
      The gradient color displayed at this location is the one whose location is 0.0.
 @param radius The radius of the radial gradient in points. The gradient color displayed at this distance from
     the center is the one whose location is 1.0.
 @result An image containing a radial gradient using the instance’s gradient colors.
 */
- (UIImage *)radialGradientImageWithSize:(CGSize)size center:(CGPoint)center radius:(CGFloat)radius;

@end


/*! 
 TWTGradientColor models a color in a color gradient. Each gradient color instance has a color and location.
 */
@interface TWTGradientColor : NSObject <NSCopying, NSSecureCoding>

/*! The instance’s color. */
@property (nonatomic, strong, readonly) UIColor *color;

/*! The instance’s location, which is a value between 0.0 and 1.0, inclusive. */
@property (nonatomic, assign, readonly) CGFloat location;

/*! Do not use this method; use ‑initWithColor:location: instead. */
- (instancetype)init NS_UNAVAILABLE;

/*!
 @abstract Initializes a newly created TWTGradientColor instance with the specified color and location.
 @param color The new instance’s color. May not be nil.
 @param location The new instance’s location. Values of this parameter are pinned to be between 0.0 and 1.0, inclusive.
 @result A newly initialized TWTGradientColor instance.
 */
- (instancetype)initWithColor:(UIColor *)color location:(CGFloat)location NS_DESIGNATED_INITIALIZER;

/*!
 @abstract Convenience initializer that initializes a new gradient color with a hexadecimal RGB value.
 @discussion The color is assumed to have an alpha component of 1.0.
 @param hex The new instance’s color as a hexadecimal RGB value in 0xRRGGBB format.
 @param location The new instance’s location. Values of this parameter are pinned to be between 0.0 and 1.0, inclusive.
 @result A newly created TWTGradientColor instance with the specified color and location.
 */
- (instancetype)initWithHexadecimalRGB:(NSUInteger)hex location:(CGFloat)location;

@end

NS_ASSUME_NONNULL_END

//
//  TWTGradient.m
//
//  Created by Prachi Gauriar on 11/17/2015.
//  Copyright © 2015 Ticketmaster Entertainment, Inc. All rights reserved.
//

#import "TWTGradient.h"


#pragma mark Gradient

@implementation TWTGradient

- (instancetype)initWithGradientColors:(NSArray<TWTGradientColor *> *)gradientColors
{
    NSParameterAssert(gradientColors.count > 0);

    self = [super init];
    if (self) {
        _gradientColors = [gradientColors copy];

        // Precalculate our gradient
        CFMutableArrayRef colors = CFArrayCreateMutable(NULL, gradientColors.count, NULL);
        CGFloat locations[gradientColors.count];

        NSUInteger i = 0;
        for (TWTGradientColor *gradientColor in gradientColors) {
            CFArrayAppendValue(colors, gradientColor.color.CGColor);
            locations[i++] = gradientColor.location;
        }

        _CGGradient = CGGradientCreateWithColors(NULL, colors, locations);
        CFRelease(colors);
    }

    return self;
}


- (void)dealloc
{
    if (_CGGradient) {
        CFRelease(_CGGradient);
    }
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: gradientColors=%@>", self.class, self, self.gradientColors];
}


- (NSUInteger)hash
{
    return self.gradientColors.hash;
}


- (BOOL)isEqual:(id)object
{
    typeof(self) other = object;
    return [object isKindOfClass:self.class] && [other.gradientColors isEqualToArray:self.gradientColors];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSArray<TWTGradientColor *> *gradientColors = [decoder decodeObjectOfClass:[NSArray class] forKey:NSStringFromSelector(@selector(gradientColors))];
    return [self initWithGradientColors:gradientColors];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.gradientColors forKey:NSStringFromSelector(@selector(gradientColors))];
}


#pragma mark - Gradient Image Generation

- (UIImage *)drawImageWithSize:(CGSize)size block:(void (^ _Nonnull)(CGContextRef _Nonnull))block
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    block(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)linearGradientImageWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    return [self drawImageWithSize:size block:^(CGContextRef _Nonnull context) {
        CGContextDrawLinearGradient(context, self.CGGradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }];
}


- (UIImage *)radialGradientImageWithSize:(CGSize)size center:(CGPoint)center radius:(CGFloat)radius
{
    return [self drawImageWithSize:size block:^(CGContextRef _Nonnull context) {
        CGContextDrawRadialGradient(context, self.CGGradient, center, 0, center, radius, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    }];
}

@end


#pragma mark - Gradient Color

@implementation TWTGradientColor

- (instancetype)initWithColor:(UIColor *)color location:(CGFloat)location
{
    NSParameterAssert(color);

    self = [super init];
    if (self) {
        _color = color;
        _location = MIN(MAX(0.0, location), 1.0);
    }

    return self;
}


- (instancetype)initWithHexadecimalRGB:(NSUInteger)hex location:(CGFloat)location
{
    CGFloat red = (CGFloat)((hex & 0xff0000) >> 16) / 255.0;
    CGFloat green = (CGFloat)((hex & 0x00ff00) >> 8) / 255.0;
    CGFloat blue = (CGFloat)(hex & 0x0000ff) / 255.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    return [self initWithColor:color location:location];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: color=%@ location=%.3f>", self.class, self, self.color, self.location];
}


- (NSUInteger)hash
{
    return self.color.hash ^ (NSUInteger)(NSUIntegerMax * self.location);
}


- (BOOL)isEqual:(id)object
{
    typeof(self) other = object;
    return [object isKindOfClass:self.class] && other.location == self.location && [other.color isEqual:self.color];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    UIColor *color = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(color))];
    CGFloat location = (CGFloat)[decoder decodeDoubleForKey:NSStringFromSelector(@selector(location))];
    return [self initWithColor:color location:location];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.color forKey:NSStringFromSelector(@selector(color))];
    [encoder encodeDouble:(double)self.location forKey:NSStringFromSelector(@selector(location))];
}

@end

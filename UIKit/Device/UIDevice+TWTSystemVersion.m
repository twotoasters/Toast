//
//  UIDevice+TWTSystemVersion.m
//
//  Created by Prachi Gauriar on 12/3/2013.
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

#import "UIDevice+TWTSystemVersion.h"
#import <objc/runtime.h>

@implementation UIDevice (TWTSystemVersion)

- (void)twt_updateSystemVersionNumbers
{
    NSArray *components = [[self systemVersion] componentsSeparatedByString:@"."];
    
    NSUInteger componentCount = [components count];
    NSInteger major = componentCount > 0 ? [[components objectAtIndex:0] integerValue] : 0;
    NSInteger minor = componentCount > 1 ? [[components objectAtIndex:1] integerValue] : 0;
    NSInteger release = componentCount > 2 ? [[components objectAtIndex:2] integerValue] : 0;
    
    objc_setAssociatedObject(self, @selector(twt_systemMajorVersion), @(major), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(twt_systemMinorVersion), @(minor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(twt_systemReleaseVersion), @(release), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSInteger)twt_versionNumberForSelector:(SEL)selector
{
    NSNumber *version = objc_getAssociatedObject(self, selector);
    if (!version) {
        [self twt_updateSystemVersionNumbers];
        version = objc_getAssociatedObject(self, selector);
    }
    
    return [version integerValue];
}


- (NSInteger)twt_systemMajorVersion
{
    return [self twt_versionNumberForSelector:_cmd];
}


- (NSInteger)twt_systemMinorVersion
{
    return [self twt_versionNumberForSelector:_cmd];
}


- (NSInteger)twt_systemReleaseVersion
{
    return [self twt_versionNumberForSelector:_cmd];
}


- (NSComparisonResult)twt_compareSystemVersionToMajor:(NSInteger)major minor:(NSInteger)minor release:(NSInteger)release
{
    NSInteger selfMajor = [self twt_systemMajorVersion];
    if (selfMajor != major) {
        return selfMajor < major ? NSOrderedAscending : NSOrderedDescending;
    }
    
    NSInteger selfMinor = [self twt_systemMinorVersion];
    if (selfMinor != minor) {
        return selfMinor < minor ? NSOrderedAscending : NSOrderedDescending;
    }
    
    NSInteger selfRelease = [self twt_systemReleaseVersion];
    if (selfRelease != release) {
        return selfRelease < release ? NSOrderedAscending : NSOrderedDescending;
    }
    
    return NSOrderedSame;
}

@end
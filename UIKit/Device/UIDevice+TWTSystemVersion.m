//
//  UIDevice+TWTSystemVersion.m
//  Toast
//
//  Created by Prachi Gauriar on 12/3/2013.
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

#import "UIDevice+TWTSystemVersion.h"

@import ObjectiveC.runtime;


@interface TWTDeviceSystemVersion : NSObject

@property (nonatomic, assign, readonly) NSInteger majorNumber;
@property (nonatomic, assign, readonly) NSInteger minorNumber;
@property (nonatomic, assign, readonly) NSInteger releaseNumber;

- (instancetype)initWithVersionString:(NSString *)versionString;

@end


@implementation TWTDeviceSystemVersion

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithVersionString:(NSString *)versionString
{
    NSParameterAssert(versionString);
    self = [super init];
    if (self) {
        NSArray *components = [versionString componentsSeparatedByString:@"."];
        NSUInteger componentCount = components.count;
        _majorNumber = componentCount > 0 ? [components[0] integerValue] : 0;
        _minorNumber = componentCount > 1 ? [components[1] integerValue] : 0;
        _releaseNumber = componentCount > 2 ? [components[2] integerValue] : 0;
    }

    return self;
}

@end


#pragma mark -

@implementation UIDevice (TWTSystemVersion)

- (TWTDeviceSystemVersion *)twt_deviceSystemVersion
{
    TWTDeviceSystemVersion *systemVersion = objc_getAssociatedObject(self, _cmd);
    if (!systemVersion) {
        systemVersion = [[TWTDeviceSystemVersion alloc] initWithVersionString:[self systemVersion]];
        objc_setAssociatedObject(self, _cmd, systemVersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return systemVersion;
}


- (NSInteger)twt_systemMajorVersion
{
    return self.twt_deviceSystemVersion.majorNumber;
}


- (NSInteger)twt_systemMinorVersion
{
    return self.twt_deviceSystemVersion.minorNumber;
}


- (NSInteger)twt_systemReleaseVersion
{
    return self.twt_deviceSystemVersion.releaseNumber;
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

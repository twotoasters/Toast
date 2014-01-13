//
//  UIDevice+TWTSystemVersion.h
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

#import <UIKit/UIKit.h>

@interface UIDevice (TWTSystemVersion)

- (NSInteger)twt_systemMajorVersion;
- (NSInteger)twt_systemMinorVersion;
- (NSInteger)twt_systemReleaseVersion;

- (NSComparisonResult)twt_compareSystemVersionToMajor:(NSInteger)major minor:(NSInteger)minor release:(NSInteger)release;

@end

#define TWT_SYSTEM_VERSION_LESS_THAN(MAJOR, MINOR, RELEASE)                 ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] < NSOrderedSame)
#define TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(MAJOR, MINOR, RELEASE)     ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] <= NSOrderedSame)
#define TWT_SYSTEM_VERSION_NOT_EQUAL_TO(MAJOR, MINOR, RELEASE)              ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] != NSOrderedSame)
#define TWT_SYSTEM_VERSION_EQUAL_TO(MAJOR, MINOR, RELEASE)                  ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] == NSOrderedSame)
#define TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(MAJOR, MINOR, RELEASE)  ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] >= NSOrderedSame)
#define TWT_SYSTEM_VERSION_GREATER_THAN(MAJOR, MINOR, RELEASE)              ([[UIDevice currentDevice] twt_compareSystemVersionToMajor:(MAJOR) minor:(MINOR) release:(RELEASE)] > NSOrderedSame)

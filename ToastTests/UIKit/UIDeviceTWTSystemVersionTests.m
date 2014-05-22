//
//  UIDeviceTWTSystemVersionTests.m
//  Toast
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

#import <XCTest/XCTest.h>
#import "UIDevice+TWTSystemVersion.h"

@interface UIDeviceTWTSystemVersionTests : XCTestCase
@end


@implementation UIDeviceTWTSystemVersionTests

- (NSArray *)systemVersionComponents
{
    return [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."];
}


- (void)testTWTSystemMajorVersion
{
    NSInteger majorVersion = [[UIDevice currentDevice] twt_systemMajorVersion];
    NSArray *systemVersionComponents = [self systemVersionComponents];
    
    if ([systemVersionComponents count] > 0) {
        XCTAssertEqual(majorVersion, [systemVersionComponents[0] integerValue], @"Incorrect major version");
    } else {
        XCTAssertEqual(majorVersion, 0, @"Major version is not 0 when not present");
    }
}


- (void)testTWTSystemMinorVersion
{
    NSInteger minorVersion = [[UIDevice currentDevice] twt_systemMinorVersion];
    NSArray *systemVersionComponents = [self systemVersionComponents];
    
    if ([systemVersionComponents count] > 1) {
        XCTAssertEqual(minorVersion, [systemVersionComponents[1] integerValue], @"Incorrect minor version");
    } else {
        XCTAssertEqual(minorVersion, 0, @"Minor version is not 0 when not present");
    }
}


- (void)testTWTSystemReleaseVersion
{
    NSInteger releaseVersion = [[UIDevice currentDevice] twt_systemReleaseVersion];
    NSArray *systemVersionComponents = [self systemVersionComponents];
    
    if ([systemVersionComponents count] > 2) {
        XCTAssertEqual(releaseVersion, [systemVersionComponents[2] integerValue], @"Incorrect release version");
    } else {
        XCTAssertEqual(releaseVersion, 0, @"Release version is not 0 when not present");
    }
}


- (void)testCompareSystemVersionToMajorMinorRelease
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSInteger major = [device twt_systemMajorVersion];
    NSInteger minor = [device twt_systemMinorVersion];
    NSInteger release = [device twt_systemReleaseVersion];
    
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major minor:minor release:release], NSOrderedSame,
                   @"Incorrect result when when versions are same");
    
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major - 1 minor:minor release:release], NSOrderedDescending,
                   @"Incorrect result when major version is less");
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major + 1 minor:minor release:release], NSOrderedAscending,
                   @"Incorrect result when when major version is greater");
    
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major minor:minor - 1 release:release], NSOrderedDescending,
                   @"Incorrect result when minor version is less");
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major minor:minor + 1 release:release], NSOrderedAscending,
                   @"Incorrect result when when minor version is greater");
    
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major minor:minor release:release - 1], NSOrderedDescending,
                   @"Incorrect result when release version is less");
    XCTAssertEqual([device twt_compareSystemVersionToMajor:major minor:minor release:release + 1], NSOrderedAscending,
                   @"Incorrect result when when release version is greater");
}


- (void)testTWTSystemVersionLessThan
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_LESS_THAN(major, minor, release);
    XCTAssertFalse(result, @"LESS_THAN returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_LESS_THAN(major - 1, minor, release);
    XCTAssertFalse(result, @"LESS_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN(major, minor - 1, release);
    XCTAssertFalse(result, @"LESS_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN(major, minor, release - 1);
    XCTAssertFalse(result, @"LESS_THAN returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_LESS_THAN(major + 1, minor, release);
    XCTAssertTrue(result, @"LESS_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN(major, minor + 1, release);
    XCTAssertTrue(result, @"LESS_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN(major, minor, release + 1);
    XCTAssertTrue(result, @"LESS_THAN returns incorrect result");
}


- (void)testTWTSystemVersionLessThanOrEqualTo
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major, minor, release);
    XCTAssertTrue(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major - 1, minor, release);
    XCTAssertFalse(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major, minor - 1, release);
    XCTAssertFalse(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major, minor, release - 1);
    XCTAssertFalse(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major + 1, minor, release);
    XCTAssertTrue(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major, minor + 1, release);
    XCTAssertTrue(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(major, minor, release + 1);
    XCTAssertTrue(result, @"LESS_THAN_OR_EQUAL_TO returns incorrect result");
}


- (void)testTWTSystemVersionNotEqualTo
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major, minor, release);
    XCTAssertFalse(result, @"NOT_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major - 1, minor, release);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major, minor - 1, release);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major, minor, release - 1);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major + 1, minor, release);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major, minor + 1, release);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_NOT_EQUAL_TO(major, minor, release + 1);
    XCTAssertTrue(result, @"NOT_EQUAL_TO returns incorrect result");
}


- (void)testTWTSystemVersionEqualTo
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_EQUAL_TO(major, minor, release);
    XCTAssertTrue(result, @"EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major - 1, minor, release);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major, minor - 1, release);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major, minor, release - 1);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major + 1, minor, release);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major, minor + 1, release);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_EQUAL_TO(major, minor, release + 1);
    XCTAssertFalse(result, @"EQUAL_TO returns incorrect result");
}


- (void)testTWTSystemVersionGreaterThanOrEqualTo
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major, minor, release);
    XCTAssertTrue(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major - 1, minor, release);
    XCTAssertTrue(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major, minor - 1, release);
    XCTAssertTrue(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major, minor, release - 1);
    XCTAssertTrue(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major + 1, minor, release);
    XCTAssertFalse(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major, minor + 1, release);
    XCTAssertFalse(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(major, minor, release + 1);
    XCTAssertFalse(result, @"GREATER_THAN_OR_EQUAL_TO returns incorrect result");
}


- (void)testTWTSystemVersionGreaterThan
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSUInteger major = [device twt_systemMajorVersion];
    NSUInteger minor = [device twt_systemMinorVersion];
    NSUInteger release = [device twt_systemReleaseVersion];
    
    BOOL result = TWT_SYSTEM_VERSION_GREATER_THAN(major, minor, release);
    XCTAssertFalse(result, @"GREATER_THAN returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major - 1, minor, release);
    XCTAssertTrue(result, @"GREATER_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major, minor - 1, release);
    XCTAssertTrue(result, @"GREATER_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major, minor, release - 1);
    XCTAssertTrue(result, @"GREATER_THAN returns incorrect result");
    
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major + 1, minor, release);
    XCTAssertFalse(result, @"GREATER_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major, minor + 1, release);
    XCTAssertFalse(result, @"GREATER_THAN returns incorrect result");
    result = TWT_SYSTEM_VERSION_GREATER_THAN(major, minor, release + 1);
    XCTAssertFalse(result, @"GREATER_THAN returns incorrect result");
}

@end

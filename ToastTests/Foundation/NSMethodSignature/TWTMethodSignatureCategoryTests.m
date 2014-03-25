//
//  TWTMethodSignatureCategoryTests.m
//  Toast
//
//  Created by Josh Johnson on 3/24/2014.
//  Copyright (c) 2014 Two Toasters.
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
#import "NSMethodSignature+TWTToast.h"

@interface TWTMethodSignatureCategoryTests : XCTestCase
@end

@implementation TWTMethodSignatureCategoryTests

#pragma mark - Tests

- (void)testMethodsWithDifferentArgumentsAndDifferentReturnTypes
{
    NSMethodSignature *noReturnMethodSignature = [self methodSignatureForSelector:@selector(model_methodWithNoArgumentsVoidReturn)];
    NSMethodSignature *objectReturnMethodSignature = [self methodSignatureForSelector:@selector(model_methodWithNoArgumentsObjectReturn)];
    XCTAssertFalse([noReturnMethodSignature twt_isEqualToMethodSignature:objectReturnMethodSignature], @"Method signatures have different return types, this should not be equal");
    
    NSMethodSignature *methodSignatureWithArgs = [self methodSignatureForSelector:@selector(model_methodWithObjectReturnAndObject:)];
    XCTAssertFalse([noReturnMethodSignature twt_isEqualToMethodSignature:methodSignatureWithArgs], @"Method signatures have different return types and arguments, this should not be equal");
}


- (void)testMethodsWithMatchingArgumentsAndReturnTypes
{
    NSMethodSignature *methodSignature = [self methodSignatureForSelector:@selector(model_methodWithNoArgumentsVoidReturn)];
    NSMethodSignature *alternateMethodSignature = [self methodSignatureForSelector:@selector(model_alternateMethodWithNoArgumentsVoidReturn)];
    XCTAssertTrue([methodSignature twt_isEqualToMethodSignature:alternateMethodSignature], @"Method Signatures are equal and should matech");
    
    NSMethodSignature *methodSignatureWithArguments = [self methodSignatureForSelector:@selector(model_methodWithVoidReturnAndObject:)];
    NSMethodSignature *alternateMethodSignatureWithArguments = [self methodSignatureForSelector:@selector(model_alternateMethodWithVoidReturnAndObject:)];
    XCTAssertTrue([methodSignatureWithArguments twt_isEqualToMethodSignature:alternateMethodSignatureWithArguments], @"Method Signatures are equal and should matech");
}


#pragma mark - Sample Methods

- (void)model_methodWithNoArgumentsVoidReturn
{
    // empty implementation
}


- (void)model_alternateMethodWithNoArgumentsVoidReturn
{
    // empty implementation
}

- (id)model_methodWithNoArgumentsObjectReturn
{
    // empty implementation
    return nil;
}


- (void)model_methodWithVoidReturnAndObject:(id)object
{
    // empty implementation
}


- (void)model_alternateMethodWithVoidReturnAndObject:(id)object
{
    // empty implementation
}


- (id)model_methodWithObjectReturnAndObject:(id)object
{
    // empty implementation
    return nil;
}


@end

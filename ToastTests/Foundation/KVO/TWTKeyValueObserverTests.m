//
//  TWTKeyValueObserverTests.m
//  Toast
//
//  Created by Josh Johnson on 3/23/2014.
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
#import <URLMock/UMKTestUtilities.h>
#import "TWTRandomizedTestCase.h"
#import "TWTKeyValueObserver.h"

@interface TWTSampleObservableObject : NSObject
@property (nonatomic, copy) NSString *targetValue;
@property (nonatomic, copy) NSString *sampleProperty;
@end

@implementation TWTSampleObservableObject
@end

@interface TWTKeyValueObserverTests : TWTRandomizedTestCase

@end

@implementation TWTKeyValueObserverTests

#pragma mark - Helpers

- (void)performTestWithAction:(SEL)action
{
    TWTSampleObservableObject *object = [[TWTSampleObservableObject alloc] init];
    object.targetValue = UMKRandomUnicodeString();
    object.sampleProperty = UMKRandomUnicodeString();
    
    __unused TWTKeyValueObserver *testObserver = [TWTKeyValueObserver observerWithObject:object keyPath:NSStringFromSelector(@selector(sampleProperty)) target:self action:action];
    
    object.sampleProperty = object.targetValue;
}


- (void)performSelectorTestWithAction:(SEL)action
{
    TWTSampleObservableObject *object = [[TWTSampleObservableObject alloc] init];
    XCTAssertThrows([TWTKeyValueObserver observerWithObject:object keyPath:NSStringFromSelector(@selector(sampleProperty)) target:self action:action], @"Should throw for invalid method signature");
}

#pragma mark - Tests

- (void)testObserverWithBlockBasedChange
{
    NSString *oldValue = UMKRandomUnicodeString();
    NSString *newValue = UMKRandomUnicodeString();
    
    TWTSampleObservableObject *object = [[TWTSampleObservableObject alloc] init];
    object.sampleProperty = oldValue;
    
    __unused TWTKeyValueObserver *testObserver = [TWTKeyValueObserver observerWithObject:object keyPath:NSStringFromSelector(@selector(sampleProperty)) changeBlock:^(id changingObject, NSDictionary *changeDictionary) {
        XCTAssertEqual(changingObject, object, @"Observed Objects are not the same");
        XCTAssertNotNil(changeDictionary, @"Change dictionary should be presented");
        XCTAssertEqual(newValue, changeDictionary[ NSKeyValueChangeNewKey ], @"Change Dictionary values are not equal");
    }];
    
    object.sampleProperty = newValue;
}


- (void)testObserverWithMethodBasedChange_zeroArgumentForm
{
    [self performTestWithAction:@selector(objectChanged)];
}


- (void)testObserverWithMethodBasedChange_oneArgumentForm
{
    [self performTestWithAction:@selector(objectChanged:)];
}


- (void)testObserverWithMethodBasedChange_twoArgumentForm
{
    [self performTestWithAction:@selector(objectChanged:changes:)];
}


- (void)testObserverWithInvalidMethodSignature
{
    [self performSelectorTestWithAction:@selector(badMethodWithValueArgument:)];
}


- (void)testObserverWithInvalidMethodSignature_BadReturnType
{
    [self performSelectorTestWithAction:@selector(badMethodWithValueReturnType)];
}


#pragma mark - Observer Actions

- (float)badMethodWithValueReturnType
{
    // no need to do anything, should throw exception
    return 0.0;
}

- (void)badMethodWithValueArgument:(float)someValue
{
    // no need to do anything, should throw exception
}


- (void)objectChanged
{
    XCTAssertTrue(YES, @"Nothing to verify, must be called.");
}


- (void)objectChanged:(TWTSampleObservableObject *)object
{
    XCTAssertEqual([object class], [TWTSampleObservableObject class], @"Observed Objects are not the same");
}


- (void)objectChanged:(TWTSampleObservableObject *)object changes:(NSDictionary *)changes
{
    XCTAssertEqual([object class], [TWTSampleObservableObject class], @"Observed Objects are not the same");
    XCTAssertEqual(object.targetValue, changes[ NSKeyValueChangeNewKey ], @"Change Dictionary values are not equal");
}


@end

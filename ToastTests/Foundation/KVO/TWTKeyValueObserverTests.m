//
//  TWTKeyValueObserverTests.m
//  Toast
//
//  Created by Josh Johnson on 3/23/2014.
//  Copyright (c) 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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


@interface TWTDeallocationTestObject : NSObject
- (void)samplePropertyDidChange;
@property (nonatomic, copy) void(^samplePropertyDidChangeBlock)(void);
@property (nonatomic, copy) void(^deallocationBlock)(void);
@end

@implementation TWTDeallocationTestObject

- (void)samplePropertyDidChange
{
    void(^samplePropertyDidChangeBlock)(void) = self.samplePropertyDidChangeBlock;
    if (samplePropertyDidChangeBlock) {
        samplePropertyDidChangeBlock();
    }
}

- (void)dealloc
{
    if (_deallocationBlock) {
        _deallocationBlock();
    }
}

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
    
    __unused TWTKeyValueObserver *testObserver = [TWTKeyValueObserver observerWithObject:object
                                                                                 keyPath:NSStringFromSelector(@selector(sampleProperty))
                                                                                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                                                  target:self
                                                                                  action:action];
    
    object.sampleProperty = object.targetValue;
}


- (void)performSelectorTestWithAction:(SEL)action
{
    TWTSampleObservableObject *object = [[TWTSampleObservableObject alloc] init];
    XCTAssertThrows([TWTKeyValueObserver observerWithObject:object keyPath:NSStringFromSelector(@selector(sampleProperty))
                                                    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                                     target:self
                                                     action:action], @"Should throw for invalid method signature");
}

#pragma mark - Tests

- (void)testObserverWithBlockBasedChange
{
    NSString *oldValue = UMKRandomUnicodeString();
    NSString *newValue = UMKRandomUnicodeString();
    
    TWTSampleObservableObject *object = [[TWTSampleObservableObject alloc] init];
    object.sampleProperty = oldValue;
    
    __unused TWTKeyValueObserver *testObserver = [TWTKeyValueObserver observerWithObject:object keyPath:NSStringFromSelector(@selector(sampleProperty)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew changeBlock:^(id observedObject, NSDictionary *changeDictionary) {
        XCTAssertEqual(observedObject, object, @"Observed Objects are not the same");
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


- (void)testObserverCreationWithInit
{
    XCTAssertThrows([[TWTKeyValueObserver alloc] init], @"Should not allow accessing with init. Use custom initializers instead");
}


/*! This test makes sure the target of a `TWTKeyValueObserver` does not get deallocated while the action
 method is in progress. This behavior was possible with a previous implementation.
 */
- (void)testTargetRetaining
{
    // The test starts by creating a sample target object that calls a `deallocationBlock` when it gets
    // deallocated. The block is configured to set `targetDeallocated` to `YES` when `target` is deallocated.
    // Later, the flag will be checked to ensure that the target has not been deallocated.

    __block BOOL targetDeallocated = NO;
    __block TWTDeallocationTestObject *target = [[TWTDeallocationTestObject alloc] init];
    target.deallocationBlock = ^{
        targetDeallocated = YES;
    };

    // `target` will invoke this block when its `-samplePropertyDidChange` action method is called. This block
    // sets the strong reference to `target` to `nil`, which could cause `target` to get deallocated if
    // `TWTKeyValueObserver` fails to keep a strong reference to it while the action method is invoked. The
    // `targetDeallocated` flag is checked inside the block after `target` is set to `nil` to see whether
    // `target` was deallocated. The expected behavior is that `target` has not yet been deallocated.

    target.samplePropertyDidChangeBlock = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        target = nil;
        XCTAssertFalse(targetDeallocated, @"target deallocated while action method is in progress");
#pragma clang diagnostic pop
    };

    // Now that the target is configured, a sample observable object is set up along with a
    // `TWTKeyValueObserver` that observes `sampleProperty` on `observableObject` and messages `target` when
    // the property's value changes.

    TWTSampleObservableObject *observableObject = [[TWTSampleObservableObject alloc] init];
    
    __unused TWTKeyValueObserver *observer = [TWTKeyValueObserver observerWithObject:observableObject
                                                                             keyPath:NSStringFromSelector(@selector(sampleProperty))
                                                                             options:NSKeyValueObservingOptionNew
                                                                              target:target
                                                                              action:@selector(samplePropertyDidChange)];
    observableObject.sampleProperty = UMKRandomUnicodeString();
    [observer stopObserving];

    // At this point, `target` should have been deallocated. Checking this helps to ensure that the invocation
    // of the action method by the `TWTKeyValueObserver` was the last strong reference to `target`. Otherwise,
    // `target` may have survived for some unrelated reason.

    XCTAssertTrue(targetDeallocated, @"target not deallocated");
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

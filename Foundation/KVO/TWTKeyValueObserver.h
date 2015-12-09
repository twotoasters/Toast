//
//  TWTKeyValueObserver.h
//  Toast
//
//  Created by Josh Johnson on 3/12/14.
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

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^TWTKeyValueObserverChangeBlock)(id _Nullable observedObject, NSDictionary * _Nullable changeDictionary);

/*!
 @abstract An opaque observer object that manages KVO against a single object
 @discussion Generally, observers automatically begin observing their objects at initialization and stop observing
     them upon deallocation. This presents problems under ARC if the observer's object is the same as the one that
     will retain the observer. In this case, you should manually stop observing changes (using -stopObserving) 
     before -dealloc is called on the observer's owner. Failure to do so could result in runtime warnings from the
     KVO system.
 */
@interface TWTKeyValueObserver : NSObject

@property (nonatomic, weak, readonly, nullable) id object;
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, assign, getter = isObserving, readonly) BOOL observing;

/*! 
 @abstract Create and return an observer object that can be stored and released as needed.
 @discussion This will automatically start observing the specified object.
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param changeBlock A block to invoke when the observation occurs
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                           options:(NSKeyValueObservingOptions)options
                       changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock;

/*! 
 @abstract Create and return an observer object that can be stored and released as needed
 @discussion This will automatically start observing the specified object.
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param target An object to notify of changes.
 @param action A selector to call on the target object to notify of changes. 
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                           options:(NSKeyValueObservingOptions)options
                            target:(id)target
                            action:(SEL)action;

/*! 
 @abstract Create and return an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param startObserving Specify whether this should start the observer on creation
 @param changeBlock A block to invoke when the observation occurs
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                           options:(NSKeyValueObservingOptions)options
                    startObserving:(BOOL)startObserving
                       changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock;

/*! 
 @abstract Create and return an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param startObserving Specify whether this should start the observer on creation
 @param target An object to notify of changes.
 @param action A selector to call on the target object to notify of changes. 
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                           options:(NSKeyValueObservingOptions)options
                    startObserving:(BOOL)startObserving
                            target:(id)target
                            action:(SEL)action;

/*! 
 @abstract Create an observer object that can be stored and released as needed
 @discussion This will automatically start observing the specified object.
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param changeBlock A block to invoke when the observation occurs
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                   changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock;

/*! 
 @abstract Create an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param target An object to notify of changes.
 @param action A selector to call on the target object to notify of changes. 
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                        target:(id)target
                        action:(SEL)action;

/*! 
 @abstract Create an observer object that can be stored and released as needed
 @discussion This will automatically start observing the specified object.
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param startObserving Specify whether this should start the observer on creation
 @param changeBlock A block to invoke when the observation occurs
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                startObserving:(BOOL)startObserving
                   changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock;

/*! 
 @abstract Create an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param options Options to use for observations
 @param startObserving Specify whether this should start the observer on creation
 @param target An object to notify of changes.
 @param action A selector to call on the target object to notify of changes. 
 */
- (instancetype)initWithObject:(id)object
                       keyPath:(NSString *)keyPath
                       options:(NSKeyValueObservingOptions)options
                startObserving:(BOOL)startObserving
                        target:(id)target
                        action:(SEL)action;

/*!
 @abstract Start observing the object if it isn't already observing.
 */
- (void)startObserving;

/*!
 @abstract Stop observing the object if it is already observing.
 */
- (void)stopObserving;

@end

NS_ASSUME_NONNULL_END

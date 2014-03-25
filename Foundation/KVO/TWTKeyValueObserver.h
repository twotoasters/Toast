//
//  TWTKeyValueObserver.h
//  Toast
//
//  Created by Josh Johnson on 3/12/14.
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

#import <Foundation/Foundation.h>

typedef void(^TWTKeyValueObserverChangeBlock)(id changingObject, NSDictionary *changeDictionary);

@interface TWTKeyValueObserver : NSObject

/*! 
 @abstract Create and return an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param changeBlock A block to invoke when the observation occurs
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                       changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock;

/*! 
 @abstract Create and return an observer object that can be stored and released as needed
 @param object The object to observe
 @param keyPath The keyPath to observe on the object
 @param target An object to notify of changes.
 @param action A selector to call on the target object to notify of changes. 
 */
+ (instancetype)observerWithObject:(id)object
                           keyPath:(NSString *)keyPath
                            target:(id)target
                            action:(SEL)action;

@end

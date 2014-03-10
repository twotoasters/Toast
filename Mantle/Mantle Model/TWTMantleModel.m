//
//  TWTMantleModel.m
//  Toast
//
//  Created by Prachi Gauriar on 3/8/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
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

#import "TWTMantleModel.h"

@import ObjectiveC.runtime;

static void *TWTMantleModelCachedPropertyKeysKey = &TWTMantleModelCachedPropertyKeysKey;


@implementation TWTMantleModel

+ (NSSet *)excludedPropertyKeys
{
    return [NSSet set];
}


+ (NSSet *)propertyKeys
{
    NSSet *propertyKeys = objc_getAssociatedObject(self, TWTMantleModelCachedPropertyKeysKey);
    if (!propertyKeys) {
        NSMutableSet *keys = [[super propertyKeys] mutableCopy];
        [keys minusSet:[self excludedPropertyKeys]];
        propertyKeys = [keys copy];
        objc_setAssociatedObject(self, TWTMantleModelCachedPropertyKeysKey, propertyKeys, OBJC_ASSOCIATION_RETAIN);
    }

    return propertyKeys;
}

@end

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

@implementation TWTMantleModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary error:(NSError **)error
{
    self = [self init];
    if (self) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];

            if ([value isEqual:[NSNull null]]) {
                value = nil;
            }

            [self setValue:value forKey:key];
        }
    }

    return self;
}


+ (NSSet *)excludedPropertyKeys
{
    return [NSSet set];
}


+ (NSSet *)propertyKeys
{
    NSSet *propertyKeys = objc_getAssociatedObject(self, _cmd);
    if (!propertyKeys) {
        NSMutableSet *keys = [[super propertyKeys] mutableCopy];
        [keys minusSet:[self excludedPropertyKeys]];
        propertyKeys = [keys copy];
        objc_setAssociatedObject(self, _cmd, propertyKeys, OBJC_ASSOCIATION_RETAIN);
    }

    return propertyKeys;
}

@end

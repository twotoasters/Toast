//
//  TWTSelectiveJSONAdapter.h
//  Toast
//
//  Created by Prachi Gauriar on 3/11/2014.
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

#import <Mantle/Mantle.h>

/*!
 Selective JSON adapters enable serializing only a subset of a model object’s properties into JSON.
 */
@interface TWTSelectiveJSONAdapter : MTLJSONAdapter

/*! The property keys the instance serializes. */
@property (nonatomic, copy, readonly) NSSet *propertyKeys;

/*!
 @abstract Initializes a selective JSON adapter instance with the specified model and property keys.
 @param model The model object that will be serialized.
 @param propertyKeys The property keys the instance serializes.
 @result A selective JSON adapter initialized with the specified model and property keys.
 */
- (instancetype)initWithModel:(MTLModel<MTLJSONSerializing> *)model propertyKeys:(NSSet *)propertyKeys;

/*!
 @abstract Returns a JSON dictionary representation of the specified property keys of the specified model object.
 @param propertyKeys The property keys whose values should be serialized into JSON.
 @param model The model object to serialize.
 @result A JSON dictionary representation of the specified property keys of the specified model object.
 */
+ (NSDictionary *)JSONDictionaryWithPropertyKeys:(NSSet *)propertyKeys fromModel:(MTLModel<MTLJSONSerializing> *)model;

@end

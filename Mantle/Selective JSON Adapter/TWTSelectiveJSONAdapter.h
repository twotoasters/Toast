//
//  TWTSelectiveJSONAdapter.h
//  Toast
//
//  Created by Prachi Gauriar on 3/11/2014.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
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

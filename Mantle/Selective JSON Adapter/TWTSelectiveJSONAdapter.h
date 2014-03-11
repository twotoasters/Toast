//
//  TWTSelectiveJSONAdapter.h
//  Toast
//
//  Created by Prachi Gauriar on 3/11/2014.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TWTSelectiveJSONAdapter : MTLJSONAdapter

@property (nonatomic, copy, readonly) NSSet *propertyKeys;

- (instancetype)initWithModel:(MTLModel<MTLJSONSerializing> *)model propertyKeys:(NSSet *)propertyKeys;

+ (NSDictionary *)JSONDictionaryWithPropertyKeys:(NSSet *)propertyKeys fromModel:(MTLModel<MTLJSONSerializing> *)model;

@end

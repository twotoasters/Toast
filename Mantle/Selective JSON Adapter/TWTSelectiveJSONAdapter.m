//
//  TWTSelectiveJSONAdapter.m
//  Toast
//
//  Created by Prachi Gauriar on 3/11/2014.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTSelectiveJSONAdapter.h"

@implementation TWTSelectiveJSONAdapter

- (instancetype)initWithModel:(MTLModel<MTLJSONSerializing> *)model propertyKeys:(NSSet *)propertyKeys
{
    self = [super initWithModel:model];
    if (self) {
        _propertyKeys = [propertyKeys copy];
    }

    return self;
}


+ (NSDictionary *)JSONDictionaryWithPropertyKeys:(NSSet *)propertyKeys fromModel:(MTLModel<MTLJSONSerializing> *)model
{
    TWTSelectiveJSONAdapter *adapter = [[self alloc] initWithModel:model propertyKeys:propertyKeys];
    return adapter.JSONDictionary;
}


- (NSString *)JSONKeyPathForPropertyKey:(NSString *)key
{
    return [self.propertyKeys containsObject:key] ? [super JSONKeyPathForPropertyKey:key] : nil;
}

@end

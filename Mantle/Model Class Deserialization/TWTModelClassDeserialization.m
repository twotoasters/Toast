//
//  TWTModelClassDeserialization.m
//  Toast
//
//  Created by Andrew Hershberger on 6/4/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTModelClassDeserialization.h"

#import <Mantle/Mantle.h>

#import "TWTBlockEnumeration.h"


NSString *const kTWTModelClassDeserializationErrorDomain = @"TWTModelClassDeserializationErrorDomain";
NSString *const kTWTModelClassDeserializationErrorUnexpectedObjectKey = @"TWTModelClassDeserializationErrorUnexpectedObjectKey";
NSString *const kTWTModelClassDeserializationErrorUnderlyingErrorsKey = @"TWTModelClassDeserializationErrorUnderlyingErrorsKey";


@implementation NSObject (TWTModelClassDeserialization)

- (id)twt_modelOfClass:(Class)class error:(NSError *__autoreleasing *)error
{
    if (error) {
        *error = [NSError errorWithDomain:kTWTModelClassDeserializationErrorDomain
                                     code:TWTModelClassDeserializationErrorUnexpectedObject
                                 userInfo:@{ kTWTModelClassDeserializationErrorUnexpectedObjectKey : self }];
    }
    return nil;
}

@end


@implementation NSArray (TWTModelClassDeserialization)

- (id)twt_modelOfClass:(Class)class error:(NSError *__autoreleasing *)error
{
    NSMutableArray *underlyingErrors = [[NSMutableArray alloc] init];
    NSArray *result = [self twt_collectWithBlock:^(id item) {
        NSError *underlyingError = nil;
        id modelObject = [item twt_modelOfClass:class error:&underlyingError];
        if (!modelObject && underlyingError) {
            [underlyingErrors addObject:underlyingError];
        }
        return modelObject;
    }];

    if (underlyingErrors.count) {
        result = nil;
        if (error) {
            *error = [NSError errorWithDomain:kTWTModelClassDeserializationErrorDomain
                                         code:TWTModelClassDeserializationErrorArrayElementsError
                                     userInfo:@{ kTWTModelClassDeserializationErrorUnderlyingErrorsKey : [underlyingErrors copy] }];
        }
    }

    return result;
}

@end


@implementation NSDictionary (TWTModelClassDeserialization)

- (id)twt_modelOfClass:(Class)modelClass error:(NSError *__autoreleasing *)error
{
    NSError *underlyingError = nil;
    id modelObject = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:self error:&underlyingError];

    if (!modelObject && error) {

        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];

        if (underlyingError) {
            userInfo[NSUnderlyingErrorKey] = underlyingError;
        }

        *error = [NSError errorWithDomain:kTWTModelClassDeserializationErrorDomain
                                     code:TWTModelClassDeserializationErrorModelObjectCreation
                                 userInfo:userInfo];
    }

    return modelObject;
}

@end

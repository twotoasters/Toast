//
//  TWTModelClassDeserialization.h
//  Toast
//
//  Created by Andrew Hershberger on 6/4/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

@import Foundation;


extern NSString *const kTWTModelClassDeserializationErrorDomain;

typedef NS_ENUM(NSInteger, TWTModelClassDeserializationError) {
    TWTModelClassDeserializationErrorModelObjectCreation,
    TWTModelClassDeserializationErrorUnexpectedObject,
    TWTModelClassDeserializationErrorArrayElementsError
};

extern NSString *const kTWTModelClassDeserializationErrorUnexpectedObjectKey;

extern NSString *const kTWTModelClassDeserializationErrorUnderlyingErrorsKey;


/*!
 This protocol is conformed to by the three classes below: NSObject, NSArray, and NSDictionary.
 */
@protocol TWTModelClassDeserialization <NSObject>

- (id)twt_modelOfClass:(Class)modelClass error:(NSError *__autoreleasing *)error;

@end


/*!
 This base implementation of the TWTModelClassDeserialization protocol always returns an error
 */
@interface NSObject (TWTModelClassDeserialization) <TWTModelClassDeserialization>
@end


/*!
 NSArray's implementation returns the array that results by mapping each element in self to a result object by
 calling -twt_modelOfClass:error:. If any errors are encountered, it returns nil.
 */
@interface NSArray (TWTModelClassDeserialization) <TWTModelClassDeserialization>
@end


/*!
 NSDictionary's implementation uses MTLJSONAdapter to create a single instance of modelClass given self
 */
@interface NSDictionary (TWTModelClassDeserialization) <TWTModelClassDeserialization>
@end

//
//  TWTLocationController.h
//  Toast
//
//  Created by Steve Foster on 2/3/15.
//  Copyright (c) 2015 Two Toasters, LLC. All rights reserved.
//

@import Foundation;

@class CLLocation;


typedef NS_ENUM(NSInteger, TWTLocationControllerStatus) {
    TWTLocationControllerAuthorizationStatusNotDetermined = 0,
    TWTLocationControllerAuthorizationStatusRestricted,
    TWTLocationControllerAuthorizationStatusDenied,
    TWTLocationControllerAuthorizationStatusAuthorizedAlways,
    TWTLocationControllerAuthorizationStatusAuthorizedWhenInUse,
    TWTLocationControllerErrorPermissionRequired,
    TWTLocationControllerErrorPermissionDenied,
    TWTLocationControllerErrorPermissionRestricted,
    TWTLocationControllerErrorUpdateFailed,
    TWTLocationControllerErrorUpdateTimedOut
};

extern NSString *const kTWTLocationControllerErrorDomain;


typedef void(^TWTLocationControllerCompletion) (CLLocation *location, NSError *error);


@interface TWTLocationController : NSObject

@property (nonatomic, copy) TWTLocationControllerCompletion locationCompletion;

+ (instancetype)sharedInstance;

- (void)fetchCurrentLocationWithCompletion:(TWTLocationControllerCompletion)completion;

@end

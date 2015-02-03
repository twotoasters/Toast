//
//  TWTLocationController.m
//  Toast
//
//  Created by Steve Foster on 2/3/15.
//  Copyright (c) 2015 Two Toasters, LLC. All rights reserved.
//

#import "TWTLocationController.h"

@import CoreLocation;

static NSTimeInterval const kLocationTimeoutInterval = 60;
NSString *const kLocationControllerErrorDomain = @"locationcontroller";


@interface TWTLocationController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *requestBlocks;

@end

@implementation TWTLocationController

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static TWTLocationController *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TWTLocationController alloc] init];
    });
    return sharedInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    return self;
}


#pragma mark - Fetch Location

- (void)fetchCurrentLocationWithCompletion:(TWTLocationControllerCompletion)completion
{
    self.locationCompletion = completion;

    self.requestBlocks = [[NSMutableArray alloc] init];
    [self.requestBlocks addObject:completion];

    [self updateLocationForAuthorizationStatus:[CLLocationManager authorizationStatus]];
}


#pragma mark - Validate Location

- (BOOL)validateLocation:(CLLocation *)location accuracy:(CLLocationAccuracy)accuracy
{
    NSTimeInterval locationTimestampAgeInSeconds = [[NSDate date] timeIntervalSinceDate:location.timestamp];
    return (locationTimestampAgeInSeconds < kLocationTimeoutInterval && location.horizontalAccuracy <= accuracy && location.horizontalAccuracy >= 0);
}


#pragma mark - Location Request Timeout

- (void)locationUpdateTimedOut:(NSTimer *)timer
{
    if ([self validateLocation:self.location accuracy:kCLLocationAccuracyThreeKilometers]) {
        [self processCompletionBlocksWithLocation:self.location error:nil];
        [self stopUpdatingLocation];
    }
    else {
        NSLog(@"location timed out.");
        [self failWithErrorCode:TWTLocationControllerErrorUpdateTimedOut underlyingError:nil];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    [self updateLocationForAuthorizationStatus:status];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.location = [locations lastObject];

    if ([self validateLocation:self.location accuracy:manager.desiredAccuracy]) {
        [self processCompletionBlocksWithLocation:self.location error:nil];
        [self stopUpdatingLocation];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // TODO (foster): What to pass here as an error code.
    [self failWithErrorCode:error.code underlyingError:error];
}


#pragma mark - Helpers

- (void)updateLocationForAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch ([CLLocationManager authorizationStatus]) {

        case kCLAuthorizationStatusNotDetermined: {
            [self failWithErrorCode:TWTLocationControllerAuthorizationStatusNotDetermined underlyingError:nil];
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager requestAlwaysAuthorization];
            break;
        }

        case kCLAuthorizationStatusRestricted: {
            [self failWithErrorCode:TWTLocationControllerAuthorizationStatusRestricted underlyingError:nil];
            break;
        }

        case kCLAuthorizationStatusDenied: {
            [self failWithErrorCode:TWTLocationControllerErrorPermissionDenied underlyingError:nil];
            break;
        }

        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {

            if ([self validateLocation:self.location accuracy:self.locationManager.desiredAccuracy]) {
                [self processCompletionBlocksWithLocation:self.location error:nil];
            }
            else {
                [self startUpdatingLocation];
            }
            break;
        }
    }
}


- (void)failWithErrorCode:(TWTLocationControllerStatus)code underlyingError:(NSError *)underlyingError
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    if (underlyingError) {
        userInfo[NSUnderlyingErrorKey] = underlyingError;
    }

    NSError *error = [NSError errorWithDomain:kLocationControllerErrorDomain code:code userInfo:userInfo];
    [self processCompletionBlocksWithLocation:nil error:error];
}


- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}


- (void)stopUpdatingLocation
{
    [self.locationManager stopUpdatingLocation];
}


- (void)processCompletionBlocksWithLocation:(CLLocation *)location error:(NSError *)error
{
    NSArray *requestBlocks = [self.requestBlocks copy];
    [self.requestBlocks removeAllObjects];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        for (TWTLocationControllerCompletion completion in requestBlocks) {
            completion(self.location, error);
        }
    }];
}

@end;



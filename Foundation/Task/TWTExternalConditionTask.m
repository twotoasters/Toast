//
//  TWTExternalConditionTask.m
//  Toast
//
//  Created by Prachi Gauriar on 10/14/2014.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTExternalConditionTask.h"


@interface TWTExternalConditionTask ()

@property (nonatomic, readwrite, assign, getter = isFulfilled) BOOL fulfilled;
@property (nonatomic, strong) id fulfillmentResult;

@end


#pragma mark -

@implementation TWTExternalConditionTask

- (void)main
{
    if (self.isFulfilled) {
        [self finishWithResult:self.fulfillmentResult];
    } else {
        [self failWithError:[NSError errorWithDomain:TWTTaskErrorDomain code:TWTTaskErrorCodeExternalConditionNotFulfilled userInfo:nil]];
    }
}


- (void)fulfillWithResult:(id)result
{
    if (self.isFinished) {
        return;
    }

    self.fulfillmentResult = result;
    self.fulfilled = YES;
    [self retry];
}

@end

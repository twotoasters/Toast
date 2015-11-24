//
//  TWTConcurrentAccessor.m
//  Toast
//
//  Created by Duncan Lewis on 11/24/15.
//  Copyright © 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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

#import "TWTConcurrentAccessor.h"


@interface TWTConcurrentAccessor ()

@property (nonatomic, strong, readonly) id object;
@property (nonatomic, strong, readonly) dispatch_queue_t queue;

@end


@implementation TWTConcurrentAccessor

- (instancetype)initWithObject:(id)object
{
    NSParameterAssert(object);
    self = [super init];
    if (self) {
        _object = object;
        
        NSString *queueName = [NSString stringWithFormat:@"%@.%p", self.class, self];
        _queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}


- (NSString *)description
{
    NSString *objectDescription = [self performReadAndReturn:^id _Nullable(id  _Nonnull object) {
        return [self.object description];
    }];

    return [NSString stringWithFormat:@"<%@: %p queue=%s object=%@>", self.class, self, dispatch_queue_get_label(self.queue), objectDescription];
}


- (void)performRead:(void (^)(id))readBlock
{
    NSParameterAssert(readBlock);
    
    dispatch_sync(self.queue, ^{
        readBlock(self.object);
    });
}


- (id)performReadAndReturn:(id (^)(id))readBlock
{
    NSParameterAssert(readBlock);
    
    __block id returnValue;
    dispatch_sync(self.queue, ^{
        returnValue = readBlock(self.object);
    });
    
    return returnValue;
}


- (void)performWrite:(void (^)(id))writeBlock
{
    NSParameterAssert(writeBlock);
    
    dispatch_barrier_async(self.queue, ^{
        writeBlock(self.object);
    });
}


- (void)performWriteAndWait:(void (^)(id))writeBlock
{
    NSParameterAssert(writeBlock);
    
    dispatch_barrier_sync(self.queue, ^{
        writeBlock(self.object);
    });
}

@end

//
//  TWTKeyValueObserver.m
//  Toast
//
//  Created by Josh Johnson on 3/12/14.
//  Copyright (c) 2014 Two Toasters.
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

#import "TWTKeyValueObserver.h"
#import "NSMethodSignature+TWTToast.h"

@interface TWTKeyValueObserver ()

@property (nonatomic, weak) id object;
@property (nonatomic, copy) NSString *keyPath;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) TWTKeyValueObserverChangeBlock changeBlock;

@end

@implementation TWTKeyValueObserver

#pragma mark - TWTKeyValueObserver

+ (instancetype)observerWithObject:(id)object keyPath:(NSString *)keyPath changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock
{
    return [[self alloc] initWithObject:object keyPath:keyPath changeBlock:changeBlock];
}


+ (instancetype)observerWithObject:(id)object keyPath:(NSString *)keyPath target:(id)target action:(SEL)action
{
    return [[self alloc] initWithObject:object keyPath:keyPath target:target action:action];
}


- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath changeBlock:(TWTKeyValueObserverChangeBlock)changeBlock
{
    self = [super init];
    if (self) {
        self.object = object;
        self.keyPath = keyPath;
        self.changeBlock = changeBlock;
        
        [object addObserver:self
                 forKeyPath:keyPath
                    options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
                    context:(__bridge void *)self];
    }
    return self;
}


- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (instancetype)initWithObject:(id)object keyPath:(NSString *)keyPath target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        self.object = object;
        self.keyPath = keyPath;
        self.target = target;
        self.action = action;
        
        if (![self target:target hasValidSignatureForSelector:action]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Action Method must conform to -(void)object:(id)object changeDictionary:(NSDictionary *)changeDictionary;"
                                         userInfo:nil];
            return nil;
        }
        
        [object addObserver:self
                 forKeyPath:keyPath
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:(__bridge void *)self];
    }
    return self;
}


- (void)dealloc
{
    [_object removeObserver:self forKeyPath:_keyPath context:(__bridge void *)self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge void *)self) {
        if (self.changeBlock) {
            self.changeBlock(object, change);
        }
        else if ([self.target respondsToSelector:self.action]) {
            NSMethodSignature *methodSignature = [self.target methodSignatureForSelector:self.action];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
            invocation.target = self.target;
            invocation.selector = self.action;
            
            if (methodSignature.numberOfArguments > 2) {
                // add object argument to at index 2
                [invocation setArgument:&object atIndex:2];
            }
            
            if (methodSignature.numberOfArguments > 3) {
                // add change dictionary at index 3
                [invocation setArgument:&change atIndex:3];
            }
            
            [invocation invoke];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Model Method Signatures for verifying action

- (void)model_objectChanged
{
    // Empty Implementation, method is only used for verifying action method signature
}


- (void)model_objectChanged:(id)object
{
    // Empty Implementation, method is only used for verifying action method signature
}


- (void)model_objectChanged:(id)object changeDictionary:(NSDictionary *)changeDictionary
{
    // Empty Implementation, method is only used for verifying action method signature
}


#pragma mark - Validation

- (BOOL)target:(id)target hasValidSignatureForSelector:(SEL)action;
{
    if (self.action == NULL) {
        return NO;
    }
    
    NSMethodSignature *actionMethodSignature = [self.target methodSignatureForSelector:self.action];
    NSArray *validMethodSignatures = @[ [self methodSignatureForSelector:@selector(model_objectChanged)],
                                        [self methodSignatureForSelector:@selector(model_objectChanged:)],
                                        [self methodSignatureForSelector:@selector(model_objectChanged:changeDictionary:)] ];
    
    return [self methodSignature:actionMethodSignature matchesMethodSignatures:validMethodSignatures];
}


- (BOOL)methodSignature:(NSMethodSignature *)methodSignature matchesMethodSignatures:(NSArray *)methodSignatures
{
    BOOL validMethodSignature = NO;
    
    for (NSMethodSignature *modelMethodSignature in methodSignatures) {
        if ([methodSignature twt_isEqualToMethodSignature:modelMethodSignature]) {
            validMethodSignature = YES;
            break;
        }
    }
    
    return validMethodSignature;
}


@end

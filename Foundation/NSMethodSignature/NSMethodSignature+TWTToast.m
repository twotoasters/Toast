//
//  NSMethodSignature+TWTToast.m
//  Toast
//
//  Created by Josh Johnson on 3/23/2014.
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

#import "NSMethodSignature+TWTToast.h"

@implementation NSMethodSignature (TWTToast)

- (BOOL)twt_isEqualToMethodSignature:(NSMethodSignature *)methodSignature
{
    BOOL signatureIsEqual = NO;
    
    if (self.numberOfArguments == methodSignature.numberOfArguments) {
        signatureIsEqual = YES;
        
        // check arguments for matching types
        for (NSUInteger argumentIndex = 0; argumentIndex < methodSignature.numberOfArguments; argumentIndex++) {
            const char *modelArgumentType = [methodSignature getArgumentTypeAtIndex:argumentIndex];
            const char *actionArgumentType = [self getArgumentTypeAtIndex:argumentIndex];
            
            if (strcmp(modelArgumentType, actionArgumentType) != 0) {
                signatureIsEqual = NO;
                break;
            }
        }
        
        // check return type for matching types
        if (strcmp(self.methodReturnType, methodSignature.methodReturnType) != 0) {
            signatureIsEqual = NO;
        }
    }
    
    return signatureIsEqual;
}


@end

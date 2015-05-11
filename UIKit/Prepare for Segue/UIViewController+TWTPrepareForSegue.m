//
//  UIViewController+TWTPrepareForSegue.m
//  Toast
//
//  Created by Prachi Gauriar on 5/22/14.
//  Copyright (c) 2015 Ticketmaster. All rights reserved.
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

#import "UIViewController+TWTPrepareForSegue.h"

@implementation UIViewController (TWTPrepareForSegue)

- (void)twt_prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    if (!identifier) {
        return;
    }

    NSString *capitalizedIdentifier = nil;
    if (identifier.length < 2) {
        capitalizedIdentifier = [identifier uppercaseString];
    } else {
        capitalizedIdentifier = [[[identifier substringToIndex:1] uppercaseString] stringByAppendingString:[identifier substringFromIndex:1]];
    }

    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"twt_prepareFor%@Segue:sender:", capitalizedIdentifier]);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:segue withObject:sender];
    }
#pragma clang diagnostic pop
}

@end

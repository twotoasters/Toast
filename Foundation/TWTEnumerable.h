//
//  TWTEnumerable.h
//  Enumerable
//
//  Created by Prachi Gauriar on 1/21/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
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

#import <Foundation/Foundation.h>

typedef id (^TWTCollectionBlock)(id object);
typedef BOOL (^TWTBooleanBlock)(id object);
typedef id (^TWTInjectionBlock)(id total, id object);


@interface NSArray (TWTEnumerable)

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;

@end


@interface NSDictionary (TWTEnumerable)

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;

@end


@interface NSOrderedSet (TWTEnumerable)

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;

@end


@interface NSSet (TWTEnumerable)

- (id)twt_collectWithBlock:(TWTCollectionBlock)block;
- (id)twt_detectWithBlock:(TWTBooleanBlock)block;
- (id)twt_rejectWithBlock:(TWTBooleanBlock)block;
- (id)twt_selectWithBlock:(TWTBooleanBlock)block;
- (id)twt_injectWithInitialObject:(id)initialObject block:(TWTInjectionBlock)block;

@end


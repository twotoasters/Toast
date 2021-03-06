//
//  TWTTreeNode.h
//  Toast
//
//  Created by Kevin Conner on 7/29/14.
//  Copyright (c) 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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


NS_ASSUME_NONNULL_BEGIN

@interface TWTTreeNode : NSObject

@property (nonatomic, strong, nullable) id item;
@property (nonatomic, assign, getter = isExpanded) BOOL expanded;
@property (nonatomic, copy, null_resettable) NSArray<TWTTreeNode *> *children;

@property (nonatomic, readonly, weak) TWTTreeNode *parent;
@property (nonatomic, readonly, strong, nullable) NSIndexPath *indexPath;

- (NSUInteger)depth;
- (instancetype)nodeAtIndexPath:(NSIndexPath * _Nullable)indexPath; // Use from the root node.
- (BOOL)hasAncestor:(TWTTreeNode * _Nullable)ancestor;

@end

NS_ASSUME_NONNULL_END

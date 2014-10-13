//
//  TWTTreeNode.m
//  Toast
//
//  Created by Kevin Conner on 7/29/14.
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

#import "TWTTreeNode.h"

@interface TWTTreeNode ()

@property (nonatomic, readwrite, weak) TWTTreeNode *parent;
@property (nonatomic, readwrite, strong) NSIndexPath *indexPath;

@end

@implementation TWTTreeNode

#pragma mark - Helpers

- (void)invalidateIndexPath
{
    self.indexPath = nil;
}

- (void)setParent:(TWTTreeNode *)parent
{
    if (_parent != parent) {
        _parent = parent;
        [self invalidateIndexPath];
        [self.children makeObjectsPerformSelector:@selector(invalidateIndexPath)];
    }
}

#pragma mark - Public interface

- (void)setChildren:(NSArray *)children
{
    for (TWTTreeNode *child in _children) {
        child.parent = nil;
    }
    
    _children = [children copy];
    
    for (TWTTreeNode *child in _children) {
        child.parent = self;
    }
}

- (NSIndexPath *)indexPath
{
    if (!_indexPath) {
        TWTTreeNode *parent = self.parent;
        if (parent) {
            NSUInteger index = [parent.children indexOfObject:self];
            _indexPath = [parent.indexPath indexPathByAddingIndex:index];
        }
        else {
            _indexPath = [NSIndexPath new];
        }
    }
    return _indexPath;
}

- (NSUInteger)depth
{
    return [self.indexPath length];
}

- (instancetype)nodeAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTreeNode *node = self;
    for (NSUInteger position = 0; position < indexPath.length; position++) {
        node = node.children[ [indexPath indexAtPosition:position] ];
    }
    return node;
}

- (BOOL)hasAncestor:(TWTTreeNode *)ancestor
{
    TWTTreeNode *parent = self;
    while (parent != nil) {
        if (parent == ancestor) {
            return YES;
        }
        parent = parent.parent;
    }
    return NO;
}

@end

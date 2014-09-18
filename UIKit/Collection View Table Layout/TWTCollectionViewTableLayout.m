//
//  TWTCollectionViewTableLayout.m
//  Toast
//
//  Created by Andrew Hershberger on 9/16/14.
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

#import "TWTCollectionViewTableLayout.h"


@interface TWTCollectionViewTableLayout ()

@property (nonatomic, copy) NSArray *itemFrames;
@property (nonatomic, assign) BOOL itemsHaveVariableHeights;

@end


@implementation TWTCollectionViewTableLayout

- (void)prepareLayout
{
    NSUInteger numberOfSections = self.collectionView.numberOfSections;
    self.itemsHaveVariableHeights = [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:heightForItemAtIndexPath:)];
    NSMutableArray *itemFrames = [[NSMutableArray alloc] initWithCapacity:numberOfSections];

    CGFloat y = 0;

    CGFloat (^heightForItem)(NSUInteger section, NSUInteger item);
    if (self.itemsHaveVariableHeights) {
        heightForItem = ^(NSUInteger section, NSUInteger item) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            return [(id<TWTCollectionViewDelegateTableLayout>)self.collectionView.delegate collectionView:self.collectionView
                                                                                                   layout:self
                                                                                 heightForItemAtIndexPath:indexPath];
        };
    }
    else {
        CGFloat itemHeight = self.itemHeight;
        heightForItem = ^(NSUInteger section, NSUInteger item) {
            return itemHeight;
        };
    }

    for (NSUInteger sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++) {
        NSUInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:sectionIndex];
        NSMutableArray *itemFramesInSection = [[NSMutableArray alloc] initWithCapacity:numberOfItemsInSection];

        for (NSUInteger itemIndex = 0; itemIndex < numberOfItemsInSection; itemIndex++) {

            CGRect itemFrame = CGRectMake(0, y, CGRectGetWidth(self.collectionView.bounds), heightForItem(sectionIndex, itemIndex));
            NSValue *itemFrameValue = [NSValue valueWithCGRect:itemFrame];
            [itemFramesInSection addObject:itemFrameValue];

            y = CGRectGetMaxY(itemFrame);
        }

        [itemFrames addObject:[itemFramesInSection copy]];
    }

    self.itemFrames = itemFrames;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSIndexPath *indexPath = [self indexPathForFirstCellInRect:rect];

    if (!indexPath) {
        return @[];
    }

    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];

    NSRange sectionRange = NSMakeRange(indexPath.section, self.itemFrames.count - indexPath.section);
    NSIndexSet *sectionIndexes = [NSIndexSet indexSetWithIndexesInRange:sectionRange];

    __block NSUInteger startingItem = indexPath.item;

    [self.itemFrames enumerateObjectsAtIndexes:sectionIndexes options:0 usingBlock:^(NSArray *itemsFramesInSection, NSUInteger sectionIdx, BOOL *sectionStop) {

        NSRange itemRange = NSMakeRange(startingItem, itemsFramesInSection.count - startingItem);
        NSIndexSet *itemIndexes = [NSIndexSet indexSetWithIndexesInRange:itemRange];
        [itemsFramesInSection enumerateObjectsAtIndexes:itemIndexes options:0 usingBlock:^(NSValue *itemFrameValue, NSUInteger itemIdx, BOOL *itemStop) {
            CGRect itemFrame = [itemFrameValue CGRectValue];

            if (CGRectIntersectsRect(itemFrame, rect)) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:itemIdx inSection:sectionIdx];
                [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            }
            else {
                *itemStop = YES;
                *sectionStop = YES;
            }
        }];

        startingItem = 0;
    }];

    return layoutAttributes;
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    layoutAttributes.frame = [self frameForItemAtIndexPath:indexPath];
    return layoutAttributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return CGRectGetWidth(self.collectionView.bounds) != CGRectGetWidth(newBounds);
}


- (CGSize)collectionViewContentSize
{
    for (NSArray *itemFramesInSection in self.itemFrames.reverseObjectEnumerator) {
        for (NSValue *itemFrameValue in itemFramesInSection.reverseObjectEnumerator) {
            CGRect itemFrame = [itemFrameValue CGRectValue];
            return CGSizeMake(CGRectGetMaxX(itemFrame), CGRectGetMaxY(itemFrame));
        }
    }
    return CGSizeZero;
}


#pragma mark - Property Accessors

- (void)setItemHeight:(CGFloat)itemHeight
{
    _itemHeight = itemHeight;
    [self invalidateLayout];
}


#pragma mark - Helpers

- (CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSValue *itemFrameValue = self.itemFrames[indexPath.section][indexPath.row];
    return CGRectInset([itemFrameValue CGRectValue], 1, 1);
}


- (NSIndexPath *)indexPathForFirstCellInRect:(CGRect)rect
{
    if (self.itemFrames.count == 0) {
        return nil;
    }

    __block NSUInteger startingSection;
    __block NSUInteger startingItem;

    if (self.itemsHaveVariableHeights) {
        NSValue *rectValue = [NSValue valueWithCGRect:rect];
        startingSection = [self.itemFrames indexOfObject:rectValue inSortedRange:NSMakeRange(0, self.itemFrames.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id obj1, id obj2) {

            NSArray *itemFramesInSection;
            NSComparisonResult result1;
            NSComparisonResult result2;
            if (obj1 == rectValue) {
                itemFramesInSection = obj2;
                result1 = NSOrderedAscending;
                result2 = NSOrderedDescending;
            }
            else {
                itemFramesInSection = obj1;
                result1 = NSOrderedDescending;
                result2 = NSOrderedAscending;
            }

            CGRect firstItemFrame = [[itemFramesInSection firstObject] CGRectValue];
            CGRect lastItemFrame = [[itemFramesInSection lastObject] CGRectValue];

            if (CGRectGetMinY(rect) < CGRectGetMinY(firstItemFrame)) {
                return result1;
            }
            else if (CGRectGetMinY(rect) > CGRectGetMaxY(lastItemFrame)) {
                return result2;
            }
            else {
                return NSOrderedSame;
            }
        }];

        if (startingSection == NSNotFound) {
            startingSection = 0;
            startingItem = 0;
        }
        else {
            NSArray *itemFramesInSection = self.itemFrames[startingSection];
            startingItem = [itemFramesInSection indexOfObject:rectValue inSortedRange:NSMakeRange(0, itemFramesInSection.count) options:NSBinarySearchingFirstEqual usingComparator:^NSComparisonResult(id obj1, id obj2) {

                NSValue *itemFrameValue;
                NSComparisonResult result1;
                NSComparisonResult result2;
                if (obj1 == rectValue) {
                    itemFrameValue = obj2;
                    result1 = NSOrderedAscending;
                    result2 = NSOrderedDescending;
                }
                else {
                    itemFrameValue = obj1;
                    result1 = NSOrderedDescending;
                    result2 = NSOrderedAscending;
                }

                CGRect itemFrame = [itemFrameValue CGRectValue];

                if (CGRectGetMinY(rect) < CGRectGetMinY(itemFrame)) {
                    return result1;
                }
                else if (CGRectGetMinY(rect) > CGRectGetMaxY(itemFrame)) {
                    return result2;
                }
                else {
                    return NSOrderedSame;
                }
            }];
        }
    }
    else {
        __block NSUInteger index = fmax(0, floor(CGRectGetMinY(rect) / self.itemHeight));

        [self.itemFrames enumerateObjectsUsingBlock:^(NSArray *itemFramesInSection, NSUInteger idx, BOOL *stop) {
            if (index < itemFramesInSection.count) {
                startingSection = idx;
                startingItem = index;
                *stop = YES;
            }
            else {
                index -= itemFramesInSection.count;
            }
        }];
    }

    return [NSIndexPath indexPathForItem:startingItem inSection:startingSection];
}

@end

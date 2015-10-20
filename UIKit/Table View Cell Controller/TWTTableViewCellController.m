//
//  TWTTableViewCellController.m
//  Toast
//
//  Created by Prachi Gauriar on 11/18/2014.
//  Copyright (c) 2014-2015 Ticketmaster Entertainment, Inc. All rights reserved.
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

#import "TWTTableViewCellController.h"

#import "NSException+TWTSubclassResponsibility.h"


@interface TWTTableViewCellController ()

@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UITableViewCell *cell;
@property (nonatomic, strong, readwrite) NSIndexPath *indexPath;

@end


@implementation TWTTableViewCellController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cellSeparatorInset = [[UITableView appearance] separatorInset];
        _cellLayoutMargins = [[UITableViewCell appearance] layoutMargins];
    }

    return self;
}


- (NSString *)cellReuseIdentifier
{
    @throw [NSException twt_subclassResponsibilityExceptionWithReceiver:self selector:_cmd];
    return nil;
}


- (UINib *)cellNib
{
    return nil;
}


- (Class)cellClass
{
    return nil;
}


- (void)beginDisplayingCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView
{
    self.tableView = tableView;
    self.cell = cell;
}


- (BOOL)shouldAutomaticallyRegisterWithTableView
{
    return YES;
}


- (void)configureCell:(UITableViewCell *)cell
{
    cell.separatorInset = self.cellSeparatorInset;
    cell.layoutMargins = self.cellLayoutMargins;
}


- (void)endDisplayingCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView
{
    self.tableView = nil;
    self.cell = nil;
}


- (CGFloat)cellHeightForWidth:(CGFloat)width
{
    @throw [NSException twt_subclassResponsibilityExceptionWithReceiver:self selector:_cmd];
    return 0.0;
}


- (BOOL)becomeFirstResponder
{
    if ([self.delegate respondsToSelector:@selector(cellControllerDidBecomeFirstResponder:)]) {
        [self.delegate cellControllerDidBecomeFirstResponder:self];
    }

    return YES;
}


- (BOOL)resignFirstResponder
{
    if ([self.delegate respondsToSelector:@selector(cellControllerDidResignFirstResponder:)]) {
        [self.delegate cellControllerDidResignFirstResponder:self];
    }

    return YES;
}

@end

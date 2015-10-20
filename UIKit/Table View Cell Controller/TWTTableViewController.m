//
//  TWTTableViewController.m
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

#import "TWTTableViewController.h"

#import "TWTBlockEnumeration.h"


@implementation TWTTableViewController

@synthesize sectionControllers = _sectionControllers;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSAssert(self.tableView, @"tableView is not initialized");
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    
    NSAssert(self.sectionControllers, @"sectionControllers is not initialized");

    TWTTableViewCellController *previousCellController = nil;
    for (TWTTableViewSectionController *sectionController in self.sectionControllers) {
        for (TWTTableViewCellController *cellController in sectionController.cellControllers) {
            cellController.delegate = self;
            previousCellController.nextCellController = cellController;
            previousCellController = cellController;
        }
    }

    [self registerTableViewCells];

    self.automaticallyAdjustsTableViewInsetsOnKeyboardFrameChange = YES;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)setAutomaticallyAdjustsTableViewInsetsOnKeyboardFrameChange:(BOOL)adjusts
{
    if (_automaticallyAdjustsTableViewInsetsOnKeyboardFrameChange != adjusts) {
        _automaticallyAdjustsTableViewInsetsOnKeyboardFrameChange = adjusts;
        if (adjusts) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillChangeFrame:)
                                                         name:UIKeyboardWillChangeFrameNotification
                                                       object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
        }
    }
}


- (NSArray *)sectionControllers
{
    if (!_sectionControllers) {
        [self loadSectionControllers];
    }

    return _sectionControllers;
}


- (void)setSectionControllers:(NSArray *)sectionControllers
{
    // TODO: the below is a temporary measure to address tableview insert/delete issues with cell controllers
    // clean up old section controllers, since they might not be properly de-configured in cellDidEndDisplaying
    
    // de-configure only the removed ones
    NSMutableSet *removedCellControllers = [NSMutableSet set];
    for (TWTTableViewSectionController *sectionController in _sectionControllers) {
        [removedCellControllers addObjectsFromArray:sectionController.cellControllers];
    }
    NSMutableSet *newCellControllers = [NSMutableSet set];
    for (TWTTableViewSectionController *sectionController in sectionControllers) {
        [newCellControllers addObjectsFromArray:sectionController.cellControllers];
    }
    [removedCellControllers minusSet:newCellControllers];
    
    for (TWTTableViewCellController *cellController in removedCellControllers) {
        [cellController endDisplayingCell:nil inTableView:nil];
    }
    
    _sectionControllers = [sectionControllers copy];
}

- (void)loadSectionControllers
{
}


- (void)registerTableViewCells
{
    NSMutableDictionary *registeredReuseIdentifiers = [[NSMutableDictionary alloc] init];
    
    for (TWTTableViewSectionController *sectionController in self.sectionControllers) {
        for (TWTTableViewCellController *controller in sectionController.cellControllers) {
            if ([controller shouldAutomaticallyRegisterWithTableView]) {
                Class controllerClass = controller.class;
                NSString *reuseIdentifier = controller.cellReuseIdentifier;
                NSAssert(reuseIdentifier, @"Reuse identifier for %@ is nil", controllerClass);
                
                
                Class registeredClass = [registeredReuseIdentifiers objectForKey:reuseIdentifier];
                if (registeredClass) {
                    NSAssert(registeredClass == controllerClass,
                             @"Multiple cell controller classes (%@ and %@) register reuse identifier \"%@\"",
                             registeredClass, controllerClass, reuseIdentifier);
                    continue;
                }
                
                registeredReuseIdentifiers[reuseIdentifier] = controllerClass;
                
                if (controller.cellNib) {
                    [self.tableView registerNib:controller.cellNib forCellReuseIdentifier:reuseIdentifier];
                } else if (controller.cellClass) {
                    [self.tableView registerClass:controller.cellClass forCellReuseIdentifier:reuseIdentifier];
                } else {
                    NSAssert(NO, @"Nil cell nib and cell class for cell controller class %@", controllerClass);
                }

            }
        }
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } completion:nil];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    if (!self.isViewLoaded || !self.view.window) {
        return;
    }

    CGRect keyboardFrameEndInScreenCoordinates = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrameInWindowCoordinates = [self.view.window convertRect:keyboardFrameEndInScreenCoordinates fromWindow:nil];
    CGRect keyboardFrameInViewCoordinates = [self.view convertRect:keyboardFrameInWindowCoordinates fromView:self.view.window];
    CGRect keyboardFrameOnScreen = CGRectIntersection(self.view.bounds, keyboardFrameInViewCoordinates);

    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom = keyboardFrameOnScreen.size.height;
    self.tableView.contentInset = contentInset;

    UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = keyboardFrameOnScreen.size.height;
    self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
}


#pragma mark - Table View

- (TWTTableViewCellController *)cellControllerForIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.sectionControllers.count) {
        TWTTableViewSectionController *sectionController = self.sectionControllers[indexPath.section];
        if (indexPath.row < sectionController.cellControllers.count) {
            return sectionController.cellControllers[indexPath.row];
        }
    }

    return nil;
}


- (NSIndexPath *)indexPathForCellController:(TWTTableViewCellController *)cellController
{
    __block NSIndexPath *indexPath = nil;

    [self.sectionControllers enumerateObjectsUsingBlock:^(TWTTableViewSectionController *sectionController, NSUInteger idx, BOOL *stop) {
        NSInteger row = [sectionController.cellControllers indexOfObjectIdenticalTo:cellController];

        if (row != NSNotFound) {
            NSInteger section = idx;
            indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            *stop = YES;
        }
    }];

    return indexPath;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionControllers.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section >= self.sectionControllers.count) {
        return 0;
    }

    TWTTableViewSectionController *sectionController = self.sectionControllers[section];
    return sectionController.cellControllers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellController.cellReuseIdentifier forIndexPath:indexPath];
    [cellController configureCell:cell];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    [cellController beginDisplayingCell:cell inTableView:tableView];
}


- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    if (cellController.cell == cell) {
        [cellController endDisplayingCell:cell inTableView:tableView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    return [cellController cellHeightForWidth:CGRectGetWidth(tableView.bounds)];
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    return cellController.target && cellController.action;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    return cellController.target && cellController.action ? indexPath : nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSMethodSignature *noArgumentSignature = nil;
    static NSMethodSignature *senderSignature = nil;
    static NSMethodSignature *senderIndexPathSignature = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        noArgumentSignature = [self methodSignatureForSelector:@selector(selectTableViewCellNoArgumentSelector)];
        senderSignature = [self methodSignatureForSelector:@selector(selectTableViewCellSenderSelector:)];
        senderIndexPathSignature = [self methodSignatureForSelector:@selector(selectTableViewCellSender:indexPathSelector:)];
    });

    TWTTableViewCellController *cellController = [self cellControllerForIndexPath:indexPath];
    if (cellController.target && cellController.action) {
        NSMethodSignature *signature = [cellController.target methodSignatureForSelector:cellController.action];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([signature isEqual:noArgumentSignature]) {
            [cellController.target performSelector:cellController.action];
        } else if ([signature isEqual:senderSignature]) {
            [cellController.target performSelector:cellController.action withObject:cellController];
        } else if ([signature isEqual:senderIndexPathSignature]) {
            [cellController.target performSelector:cellController.action withObject:cellController withObject:indexPath];
        } else {
            NSAssert(NO, @"selector (%@) is not a valid action signature", NSStringFromSelector(cellController.action));
        }
#pragma clang diagnostic pop
    }
}


- (void)selectTableViewCellNoArgumentSelector
{
    // Intentionally empty. Used for determining which version of perform selector we should use in
    // ‑tableView:didSelectRowAtIndexPath:.
}


- (void)selectTableViewCellSenderSelector:(id)sender
{
    // Intentionally empty. Used for determining which version of perform selector we should use in
    // ‑tableView:didSelectRowAtIndexPath:.
}


- (void)selectTableViewCellSender:(id)sender indexPathSelector:(NSIndexPath *)indexPath
{
    // Intentionally empty. Used for determining which version of perform selector we should use in
    // ‑tableView:didSelectRowAtIndexPath:.
}


#pragma mark - Table View Cell Controller Delegate

- (void)cellControllerRequiresReload:(TWTTableViewCellController *)cellController
{
    [self.tableView reloadRowsAtIndexPaths:@[ [self indexPathForCellController:cellController] ]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)cellControllerRequiresAnimatedHeightChange:(TWTTableViewCellController *)cellController
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    } completion:nil];
}

@end

//
//  TWTTableViewController.h
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

@import UIKit;

#import "TWTTableViewCellController.h"
#import "TWTTableViewSectionController.h"


/*!
 TWTTableViewController is an abstract class that aims to simplify populating a table view by using table view
 cell controllers. Subclasses need only set the tableView the cellControllers properties and the table should
 essentially populate itself. Generally speaking, the table view will be set using Interface Builder.
 Subclasses should override -loadSectionControllers to set sectionControllers property. All members of
 sectionControllers are assumed to be instances of TWTTableViewSectionController or a subclass thereof. Beyond
 that, the base implementation of TWTTableViewController will register nibs and classes for the appropriate
 cell reuse identifiers; implement table view data source and delegate methods; and implement table view cell
 controller delegate methods.
 
 TWTTableViewControllers use their table view cell controllers’ target and action properties to automatically 
 enable cell highlighting and selection. When a cell is selected, its action is method is sent to its target.
 The signature of its action method must match one of the following method signatures:
 
     - (void)action;
     - (void)actionWithSender:(TWTTableViewCellController *)sender;
     - (void)actionWithSender:(TWTTableViewCellController *)sender atIndexPath:(NSIndexPath *)indexPath;
 
 The names can obviously differ, but the return and argument types must be the same.
 */
@interface TWTTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, TWTTableViewCellControllerDelegate>

/*!
 @abstract Whether the view controller automatically adjusts table view scroll and content insets 
     when the keyboard frame changes.
 @discussion NO by default.
 */
@property (nonatomic, assign) BOOL automaticallyAdjustsTableViewInsetsOnKeyboardFrameChange;

/*!
 @abstract An array of section controllers that define the content of the table view.
 @discussion This array must be set in -loadSectionControllers, which is automatically invoked in -viewDidLoad.
     Failure to do so will result in an assertion.
 */
@property (nonatomic, copy) NSArray *sectionControllers;

/*!
 @abstract The recevier’s table view.
 @discussion This property must be set by the time -viewDidLoad is invoked. Failure to do will result
     in an assertion.
 */
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/*!
 @abstract Initializes the receiver’s cellControllers property.
 @discussion The default implementation does nothing. Subclasses must override this method and set the property
     to a non-nil array. Failure to do so will result in an assertion during -viewDidLoad.
 */
- (void)loadSectionControllers;

@end

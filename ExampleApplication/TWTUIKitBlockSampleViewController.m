//
//  TWTUIKitBlockSampleViewController.m
//  Toast
//
//  Created by Josh Johnson on 1/13/14.
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

#import "TWTUIKitBlockSampleViewController.h"
#import "UIActionSheet+TWTBlocks.h"
#import "UIAlertView+TWTBlocks.h"

@interface TWTUIKitBlockSampleViewController ()

@end

@implementation TWTUIKitBlockSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Block-based Action and Alert";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CGSize buttonSize = (CGSize) { 320.0, 44.0 };
    
    UIButton *actionSheetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    actionSheetButton.frame = (CGRect) { { 0.0, 100.0 }, buttonSize };
    [actionSheetButton setTitle:@"Show Action Sheet" forState:UIControlStateNormal];
    [actionSheetButton addTarget:self action:@selector(actionSheetButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionSheetButton];

    UIButton *alertViewButton = [UIButton buttonWithType:UIButtonTypeSystem];
    alertViewButton.frame = (CGRect) { { 0.0, 200.0 }, buttonSize };
    [alertViewButton setTitle:@"Show Alert View" forState:UIControlStateNormal];
    [alertViewButton addTarget:self action:@selector(alertViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertViewButton];

}

- (void)actionSheetButtonAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sample Action Sheet"
                                                             delegate:nil
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Button 1", nil];
    actionSheet.twt_tapHandler = ^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Action Sheet Tapped at index %ld", (long)buttonIndex] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [alertView show];
    };
    [actionSheet showInView:self.view];
}

- (void)alertViewButtonAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sample Alert View"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Done"
                                              otherButtonTitles:@"Button 1", nil];
    alertView.twt_tapHandler = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        UIAlertView *resultingAlertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Action Sheet Tapped at index %ld", (long)buttonIndex] delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
        [resultingAlertView show];
    };
    [alertView show];   
}

@end

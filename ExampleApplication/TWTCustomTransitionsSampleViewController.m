//
//  TWTCustomTransitionsSampleViewController.m
//  Toast
//
//  Created by Andrew Hershberger on 3/4/14.
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

#import "TWTCustomTransitionsSampleViewController.h"

#import "TWTNavigationControllerDelegate.h"
#import "TWTSimpleAnimationController.h"


static NSString *const kCellIdentifier = @"AnimationOptionCell";


@interface TWTCustomTransitionsSampleViewController ()
@property (nonatomic, copy) NSArray *optionNamesBySection;
@property (nonatomic) UIViewAnimationOptions selectedOptions;
@end


@implementation TWTCustomTransitionsSampleViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = NSLocalizedString(@"Configure a custom transition", nil);
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Push", nil)
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(pushButtonTapped)];

#define AnimationOptionName(anOption) (^{ UIViewAnimationOption##anOption; return @ #anOption; }())
        _optionNamesBySection = @[ @[ AnimationOptionName(LayoutSubviews),
                                      AnimationOptionName(AllowUserInteraction),
                                      AnimationOptionName(BeginFromCurrentState),
                                      AnimationOptionName(Repeat),
                                      AnimationOptionName(Autoreverse),
                                      AnimationOptionName(OverrideInheritedDuration),
                                      AnimationOptionName(OverrideInheritedCurve),
                                      AnimationOptionName(AllowAnimatedContent),
                                      AnimationOptionName(ShowHideTransitionViews),
                                      AnimationOptionName(OverrideInheritedOptions) ],

                                   @[ AnimationOptionName(CurveEaseInOut),
                                      AnimationOptionName(CurveEaseIn),
                                      AnimationOptionName(CurveEaseOut),
                                      AnimationOptionName(CurveLinear) ],

                                   @[ AnimationOptionName(TransitionNone),
                                      AnimationOptionName(TransitionFlipFromLeft),
                                      AnimationOptionName(TransitionFlipFromRight),
                                      AnimationOptionName(TransitionCurlUp),
                                      AnimationOptionName(TransitionCurlDown),
                                      AnimationOptionName(TransitionCrossDissolve),
                                      AnimationOptionName(TransitionFlipFromTop),
                                      AnimationOptionName(TransitionFlipFromBottom) ] ];
#undef AnimationOptionName
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
}


#pragma mark Actions

- (void)pushButtonTapped
{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view.backgroundColor = [UIColor whiteColor];
    TWTSimpleAnimationController *animationController = [[TWTSimpleAnimationController alloc] init];
    animationController.options = self.selectedOptions;
    animationController.duration = 0.5;
    viewController.twt_pushAnimationController = animationController;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.optionNamesBySection.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.optionNamesBySection[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Basic Options", nil);
        case 1:
            return NSLocalizedString(@"Curves", nil);
        case 2:
            return NSLocalizedString(@"Transitions", nil);
        default:
            return nil;
    }
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:cell indexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewAnimationOptions option = [self optionForIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            self.selectedOptions = self.selectedOptions ^ option;
            break;
        case 1:
        case 2:
            self.selectedOptions = self.selectedOptions & ~[self maskForSection:indexPath.section];
            self.selectedOptions = self.selectedOptions | option;
            break;
        default:
            break;
    }

    for (NSInteger row = 0; row < [tableView numberOfRowsInSection:indexPath.section]; row++) {
        NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:cellIndexPath];
        [self configureCell:cell indexPath:cellIndexPath];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark Helpers

- (void)configureCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.optionNamesBySection[indexPath.section][indexPath.row];
    UIViewAnimationOptions option = [self optionForIndexPath:indexPath];

    switch (indexPath.section) {
        case 0:
        {
            cell.accessoryType = ((self.selectedOptions & option) == option) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
        case 1:
        case 2:
        {
            UIViewAnimationOptions mask = [self maskForSection:indexPath.section];
            cell.accessoryType = ((self.selectedOptions & mask) == option) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }
        default:
            break;
    }
}


- (UIViewAnimationOptions)optionForIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: return 1 << indexPath.row;
        case 1: return ((NSUInteger)indexPath.row) << 16;
        case 2: return ((NSUInteger)indexPath.row) << 20;
        default: return 0;
    }
}


- (UIViewAnimationOptions)maskForSection:(NSUInteger)section
{
    switch (section) {
        case 0: return 0xFFFF;
        case 1: return 0xF << 16;
        case 2: return 0xF << 20;
        default: return 0;
    }
}

@end

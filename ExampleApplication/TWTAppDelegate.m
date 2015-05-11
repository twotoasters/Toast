//
//  TWTAppDelegate.m
//  Toast
//
//  Created by Josh Johnson on 1/12/14.
//  Copyright (c) 2015 Ticketmaster.
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

#import "TWTAppDelegate.h"

#import "TWTNavigationControllerDelegate.h"
#import "TWTSampleViewController.h"


@interface TWTAppDelegate ()

@property (nonatomic, strong) TWTNavigationControllerDelegate *navigationControllerDelegate;

@end


@implementation TWTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TWTSampleViewController *viewController = [[TWTSampleViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.navigationControllerDelegate = [[TWTNavigationControllerDelegate alloc] init];
    navigationController.delegate = self.navigationControllerDelegate;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

@end

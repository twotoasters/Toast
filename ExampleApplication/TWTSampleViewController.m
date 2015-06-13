//
//  TWTSampleViewController.m
//  Toast
//
//  Created by Josh Johnson on 1/12/14.
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

#import "TWTSampleViewController.h"

NSString * const kToastSampleFileName = @"ToastExamples";
NSString * const kToastSampleKeyTitle = @"Title";
NSString * const kToastSampleKeyViewController = @"ViewController";

static NSString *twt_cellIdentifier = @"com.ticketmaster.toast.sampleCell";

@interface TWTSampleViewController ()

@property (nonatomic, strong) NSArray *examples;

@end

@implementation TWTSampleViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Toast Examples";
    
    NSString *toastSamplesURLString = [[NSBundle mainBundle] pathForResource:kToastSampleFileName ofType:@"plist"];
    self.examples = [NSArray arrayWithContentsOfFile:toastSamplesURLString];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:twt_cellIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twt_cellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.text = self.examples[ indexPath.row ][ kToastSampleKeyTitle ];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = self.examples[ indexPath.row ][ kToastSampleKeyViewController ];
    Class class = NSClassFromString(className);
    
    if (class != Nil) { 
        UIViewController *viewController = (UIViewController *)[[class alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

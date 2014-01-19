//
//  TWTUIKitFormattedEntryTextFieldSampleViewController.m
//  Toast
//
//  Created by Duncan Lewis on 1/15/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
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


#import "TWTUIKitFormattedEntryTextFieldSampleViewController.h"

#import "TWTFormattedTextField.h"
#import "TWTTemplatedTextEntryFormatter.h"

@interface TWTUIKitFormattedEntryTextFieldSampleViewController ()

@end

@implementation TWTUIKitFormattedEntryTextFieldSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    TWTTemplatedTextEntryFormatter *formatter = [[TWTTemplatedTextEntryFormatter alloc] initWithTextEntryTemplate:@"(___) ___-____" templateCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"()- "] entryCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]];
    
    UILabel *phoneEntryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneEntryLabel.backgroundColor = [UIColor clearColor];
    phoneEntryLabel.opaque = NO;
    phoneEntryLabel.text = NSLocalizedString(@"Phone Number Entry", nil);
    phoneEntryLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:phoneEntryLabel];
    
    TWTFormattedTextField *phoneNumberEntryTextField = [[TWTFormattedTextField alloc] initWithFrame:CGRectZero];
    phoneNumberEntryTextField.font = [UIFont systemFontOfSize:12.0f];
    phoneNumberEntryTextField.formatter = formatter;
    [self.view addSubview:phoneNumberEntryTextField];
    
    UILabel *filledPhoneEntryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    filledPhoneEntryLabel.backgroundColor = [UIColor clearColor];
    filledPhoneEntryLabel.opaque = NO;
    filledPhoneEntryLabel.text = NSLocalizedString(@"Programatically Formatted Field", nil);
    filledPhoneEntryLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:filledPhoneEntryLabel];
    
    TWTFormattedTextField *filledPhoneNumberEntryTextField = [[TWTFormattedTextField alloc] initWithFrame:CGRectZero];
    filledPhoneNumberEntryTextField.formatter = formatter;
    filledPhoneNumberEntryTextField.font = [UIFont systemFontOfSize:12.0f];
    filledPhoneNumberEntryTextField.text = @"1234567890";
    [self.view addSubview:filledPhoneNumberEntryTextField];
    
    // layout
    {
        id topGuide = self.topLayoutGuide;
        NSDictionary *metrics = @{ };
        NSDictionary *views = NSDictionaryOfVariableBindings(phoneEntryLabel, phoneNumberEntryTextField, filledPhoneEntryLabel, filledPhoneNumberEntryTextField, topGuide);
        
        for (UIView *view in [views allValues]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [phoneEntryLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [phoneEntryLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [filledPhoneEntryLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [filledPhoneEntryLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [phoneNumberEntryTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [filledPhoneNumberEntryTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-(20)-[phoneNumberEntryTextField]-(20)-[filledPhoneNumberEntryTextField]" options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[phoneEntryLabel]-10-[phoneNumberEntryTextField]-10-|" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[filledPhoneEntryLabel]-10-[filledPhoneNumberEntryTextField]-10-|" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views]];
    }
}

@end

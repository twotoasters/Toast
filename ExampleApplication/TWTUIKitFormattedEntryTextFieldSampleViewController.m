//
//  TWTUIKitFormattedEntryTextFieldSampleViewController.m
//  Toast
//
//  Created by Duncan Lewis on 1/15/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import "TWTUIKitFormattedEntryTextFieldSampleViewController.h"

#import "TWTFormattedTextField.h"

@interface TWTUIKitFormattedEntryTextFieldSampleViewController ()

@end

@implementation TWTUIKitFormattedEntryTextFieldSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *phoneEntryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    phoneEntryLabel.backgroundColor = [UIColor clearColor];
    phoneEntryLabel.opaque = NO;
    phoneEntryLabel.text = NSLocalizedString(@"Phone Number Entry", nil);
    phoneEntryLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:phoneEntryLabel];
    
    TWTFormattedTextField *phoneNumberEntryTextField = [[TWTFormattedTextField alloc] initWithFormatType:TWTFormattedTextFieldTypePhoneNumber];
    phoneNumberEntryTextField.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:phoneNumberEntryTextField];
    
    UILabel *filledPhoneEntryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    filledPhoneEntryLabel.backgroundColor = [UIColor clearColor];
    filledPhoneEntryLabel.opaque = NO;
    filledPhoneEntryLabel.text = NSLocalizedString(@"Phone Number Entry", nil);
    filledPhoneEntryLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:filledPhoneEntryLabel];
    
    TWTFormattedTextField *filledPhoneNumberEntryTextField = [[TWTFormattedTextField alloc] initWithFormatType:TWTFormattedTextFieldTypePhoneNumber];
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

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
    
    TWTFormattedTextField *phoneEntryTextField = [[TWTFormattedTextField alloc] initWithFormatType:TWTFormattedTextFieldTypePhoneNumber];
    phoneEntryTextField.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:phoneEntryTextField];
    
    // layout
    {
        id topGuide = self.topLayoutGuide;
        NSDictionary *metrics = @{ };
        NSDictionary *views = NSDictionaryOfVariableBindings(phoneEntryLabel, phoneEntryTextField, topGuide);
        
        for (UIView *view in [views allValues]) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
        
        [phoneEntryLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [phoneEntryLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        
        [phoneEntryTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-(20)-[phoneEntryTextField]" options:0 metrics:metrics views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[phoneEntryLabel]-10-[phoneEntryTextField]-10-|" options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views]];
    }
}

@end

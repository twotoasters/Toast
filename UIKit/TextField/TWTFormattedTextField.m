//
//  TWTFormattedTextField.m
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

#import "TWTFormattedTextField.h"

// formatters
#import "TWTTemplatedTextEntryFormatter.h"

NSRange TWTNSRangeFromUITextRangeForTextField(UITextRange *textRange, UITextField *textField)
{
    NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textRange.start];
    NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textRange.end];
    NSRange range = NSMakeRange(startOffset, endOffset - startOffset);
    return range;
}

UITextRange * TWTUITextRangeFromNSRangeForTextField(NSRange range, UITextField *textField)
{
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textField textRangeFromPosition:start toPosition:end];
    return textRange;
}

#pragma mark - TWTFormattedTextFieldDelegateInternal

// note that this class exists because a UITextField subclass cannot be it's own delegate: http://www.cocoabuilder.com/archive/cocoa/241465-iphone-why-can-a-uitextfield-be-its-own-delegate.html#241505
@interface TWTFormattedTextFieldDelegateInternal : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> proxyDelegate;
@property (nonatomic, strong) NSFormatter *formatter;

@end

@implementation TWTFormattedTextFieldDelegateInternal

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // todo: decide where to place the cursor base on current text
    NSRange newSelectionRange;
    NSString *partialStringPlaceholder = [textField.text copy];
    
    [self.formatter isPartialStringValid:&partialStringPlaceholder proposedSelectedRange:&newSelectionRange originalString:textField.text originalSelectedRange:TWTNSRangeFromUITextRangeForTextField(textField.selectedTextRange, textField) errorDescription:nil];
    
    textField.text = partialStringPlaceholder;
    [textField setSelectedTextRange:TWTUITextRangeFromNSRangeForTextField(newSelectionRange, textField)];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // todo: if invalid, update with invalid color
    BOOL isValid = [self.formatter isPartialStringValid:textField.text newEditingString:NULL errorDescription:NULL];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *partialString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSRange proposedRange;
    
    BOOL isValid = [self.formatter isPartialStringValid:&partialString proposedSelectedRange:&proposedRange originalString:textField.text originalSelectedRange:range errorDescription:nil];
    
    if (isValid) {
        textField.text = [partialString copy];
    }
    
    [textField setSelectedTextRange:TWTUITextRangeFromNSRangeForTextField(proposedRange, textField)];
    
    // always return no so that we are driving the text input
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // todo: instead of clearing, return to default text for format
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

@end


#pragma mark - TWTFormattedTextField


@interface TWTFormattedTextField() <UITextFieldDelegate>

@property (nonatomic, strong) TWTFormattedTextFieldDelegateInternal *internalDelegate;
@property (nonatomic, strong) NSMutableString *internalCharacterBuffer;

@end

@implementation TWTFormattedTextField

#pragma mark - Formatter Type

- (void)configureTextFieldForFormatType:(TWTFormattedTextFieldType)type
{
    NSFormatter *formatter = nil;
    
    switch (type) {
            
        case TWTFormattedTextFieldTypePhoneNumber:
        {
            // TODO: refactor into a class!
            formatter = [[TWTTemplatedTextEntryFormatter alloc] initWithTextEntryTemplate:@"(***) ***-****" templateCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"() -"] entryCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"1234567890"]];
        }
            break;
            
        default:
            break;
    }
    
    _internalDelegate.formatter = formatter;
}

#pragma mark - Setters

// When a developer wants to assign the delegate of this textfield,
// keep the internal delegate as the primary delegate and route
// the developer's delegate to the proxy delegate
- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    [super setDelegate:_internalDelegate];
    
    _internalDelegate.proxyDelegate = delegate;
}

- (void)setCustomFormatter:(NSFormatter *)customFormatter
{
    if (self.type == TWTFormattedTextFieldTypeCustom) {
        self.internalDelegate.formatter = customFormatter;
    }
}

#pragma mark - Initializers

- (void)commonInitWithType:(TWTFormattedTextFieldType)type
{
    // set up delegates
    _internalDelegate = [[TWTFormattedTextFieldDelegateInternal alloc] init];
    self.delegate = _internalDelegate;
    
    _internalCharacterBuffer = [[NSMutableString alloc] init];
 
    _type = type;
    [self configureTextFieldForFormatType:_type];
}

- (id)initWithFormatType:(TWTFormattedTextFieldType)type
{
    self = [self initWithFrame:CGRectZero];
    if (self) {
        [self commonInitWithType:type];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithType:TWTFormattedTextFieldTypePhoneNumber];
    }
    return self;
}

@end

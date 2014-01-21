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
    return NSMakeRange(startOffset, endOffset - startOffset);
}

UITextRange * TWTUITextRangeFromNSRangeForTextField(NSRange range, UITextField *textField)
{
    UITextPosition *beginning = textField.beginningOfDocument;
    UITextPosition *start = [textField positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textField positionFromPosition:start offset:range.length];
    return [textField textRangeFromPosition:start toPosition:end];
}

#pragma mark - TWTFormattedTextFieldDelegateInternal

// note that this class exists because a UITextField subclass cannot be it's own delegate: http://www.cocoabuilder.com/archive/cocoa/241465-iphone-why-can-a-uitextfield-be-its-own-delegate.html#241505
@interface TWTFormattedTextFieldDelegateInternal : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) id<UITextFieldDelegate> proxyDelegate;

@end

@implementation TWTFormattedTextFieldDelegateInternal

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([self.proxyDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [self.proxyDelegate textFieldShouldBeginEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // reset current text value to get correct cursor position
    textField.text = [textField.text copy];
    
    if ([self.proxyDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.proxyDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([self.proxyDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [self.proxyDelegate textFieldShouldEndEditing:textField];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // todo: if invalid, update with invalid color/marking?

    if ([self.proxyDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.proxyDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL delegateShouldChange = YES;
    if ([self.proxyDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        delegateShouldChange = [self.proxyDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    
    UITextRange *textRange = TWTUITextRangeFromNSRangeForTextField(range, textField);
    if (delegateShouldChange) {
        [textField replaceRange:textRange withText:string];
    }
    
    // always return `no` so that we are driving the text input
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // by default, should clear. use the proxy delegate's value if it specifies
    BOOL delegateShouldClear = YES;
    
    if ([self.proxyDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        delegateShouldClear = [self.proxyDelegate textFieldShouldClear:textField];
    }
    
    if (delegateShouldClear) {
        [textField setText:@""];
    }
    
    // always return `no` so that we are driving the text input
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.proxyDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [self.proxyDelegate textFieldShouldReturn:textField];
    }
    
    return YES;
}

@end


#pragma mark - TWTFormattedTextField


@interface TWTFormattedTextField() <UITextFieldDelegate>

@property (nonatomic, strong) TWTFormattedTextFieldDelegateInternal *internalDelegate;

@end

@implementation TWTFormattedTextField

#pragma mark - UITextInput

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{
    NSRange textRange = TWTNSRangeFromUITextRangeForTextField(range, self);
    NSRange proposedRange = NSMakeRange(NSNotFound, -1);
    
    NSString *partialString = [self.text stringByReplacingCharactersInRange:textRange withString:text];

    BOOL isValid = YES;
    if (self.formatter) {
        isValid = [self.formatter isPartialStringValid:&partialString proposedSelectedRange:&proposedRange originalString:self.text originalSelectedRange:textRange errorDescription:nil];
    }

    if (isValid) {
        [super setText:[partialString copy]];
    }

    if (proposedRange.location != NSNotFound) {
        [self setSelectedTextRange:TWTUITextRangeFromNSRangeForTextField(proposedRange, self)];
    }
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    NSRange rangeOfString = NSMakeRange(0, self.text.length);
    [self replaceRange:TWTUITextRangeFromNSRangeForTextField(rangeOfString, self) withText:text];
}

// When a developer wants to assign the delegate of this textfield,
// keep the internal delegate as the primary delegate and route
// the developer's delegate to the proxy delegate
- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    _internalDelegate.proxyDelegate = delegate;
}

- (id<UITextFieldDelegate>)delegate
{
    return _internalDelegate.proxyDelegate;
}

#pragma mark - Initializers

- (void)commonInit
{
    // during init, we set the textfield delegate to the internal delegate and then never touch it again
    // the setDelegate: method will be overwritten to set the proxyDelegate property of the internal delegate
    _internalDelegate = [[TWTFormattedTextFieldDelegateInternal alloc] init];
    [super setDelegate:_internalDelegate];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

@end

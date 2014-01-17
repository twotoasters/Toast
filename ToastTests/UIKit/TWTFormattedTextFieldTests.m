//
//  TWTFormattedTextFieldTests.m
//  Toast
//
//  Created by Duncan Lewis on 1/17/14.
//  Copyright (c) 2014 Two Toasters, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TWTFormattedTextField.h"
#import "TWTRandomizedTestCase.h"

@interface TWTTestFormatter : NSFormatter

- (NSString *)expectedFormattedStringForInputString:(NSString *)string;

@end

@implementation TWTTestFormatter

- (NSString *)expectedFormattedStringForInputString:(NSString *)string
{
    // simple format #%@#, no new #'s allowed
    NSString *format = @"#%@#";
    
    // parse out #'s
    NSString *model = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    return [NSString stringWithFormat:format, model];
}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString *__autoreleasing *)error
{
    if (partialStringPtr) {
        NSString *newString = [self expectedFormattedStringForInputString:(*partialStringPtr)];
        *partialStringPtr = newString;
        return YES;
    }
    return NO;
}

@end

@interface TWTFormattedTextFieldTests : TWTRandomizedTestCase

@property (nonatomic, strong) TWTFormattedTextField *textField;
@property (nonatomic, strong) TWTTestFormatter *formatter;

@end

@implementation TWTFormattedTextFieldTests

+ (void)setUp
{
    [super setUp];
}

- (void)setUp
{
    [super setUp];
    
    self.textField = [[TWTFormattedTextField alloc] initWithFrame:CGRectZero];
    self.formatter = [[TWTTestFormatter alloc] init];
    self.textField.customFormatter = self.formatter;
}

- (void)testTWTFormattedTextFieldWithSingleInputCharacter
{
    NSString *inputString = @"e"; // todo: randomize
    UITextPosition *start = [self.textField positionFromPosition:self.textField.beginningOfDocument offset:0];
    UITextPosition *end = [self.textField positionFromPosition:self.textField.beginningOfDocument offset:1];
    UITextRange *range = [self.textField textRangeFromPosition:start toPosition:end];
    
    [self.textField replaceRange:range withText:inputString];
    
    XCTAssertEqualObjects(self.textField.text, [self.formatter expectedFormattedStringForInputString:inputString], @"TextField did not contain expected input string");
}

@end

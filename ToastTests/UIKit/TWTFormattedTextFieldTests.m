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

static NSString * const alphabetCharacters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY";
static NSString * const numberCharacters = @"0123456789";

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
    self.textField.formatter = self.formatter;
}

- (NSString *)randomAlphabetSingleCharacterString
{
    return [alphabetCharacters substringWithRange:NSMakeRange(random() % (alphabetCharacters.length - 1), 1)];
}

- (void)testTWTFormattedTextFieldWithSingleInputCharacter
{
    NSString *inputString = [self randomAlphabetSingleCharacterString];
    
    [self.textField replaceRange:TWTUITextRangeFromNSRangeForTextField(NSMakeRange(0, 1), self.textField) withText:inputString];
    
    XCTAssertEqualObjects(self.textField.text, [self.formatter expectedFormattedStringForInputString:inputString], @"TextField did not contain expected input string");
}

// TODO: this test is failing because the UITextRange generation methods are returning nil. This behavior isn't seen outside of the test environment, investigate.
- (void)testTWTFormattedTextFieldWithMultipleInputCharacters
{
    NSString *input1 = [self randomAlphabetSingleCharacterString];
    NSString *input2 = [self randomAlphabetSingleCharacterString];
    
    [self.textField replaceRange:TWTUITextRangeFromNSRangeForTextField(NSMakeRange(0, 1), self.textField) withText:input1];
    [self.textField replaceRange:TWTUITextRangeFromNSRangeForTextField(NSMakeRange(1, 1), self.textField) withText:input2];
    
    XCTAssertEqualObjects(self.textField.text, [self.formatter expectedFormattedStringForInputString:[input1 stringByAppendingString:input2]], @"TextField did not contain expected input string");
}

@end

//
//  TWTTemplatedTextEntryFormatter.m
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

#import "TWTTemplatedTextEntryFormatter.h"

@interface TWTTemplatedTextEntryFormatter()

@property (nonatomic, strong) NSString *template;
@property (nonatomic, strong) NSCharacterSet *templateCharacterSet;
@property (nonatomic, strong) NSCharacterSet *entryCharacterSet;

@end

@implementation TWTTemplatedTextEntryFormatter

#pragma mark - NSDateFormatter methods

- (NSString *)stringForObjectValue:(id)obj
{
    return nil;
}

- (NSString *)editingStringForObjectValue:(id)obj
{
    return nil;
}

- (BOOL)isPartialStringValid:(NSString *)partialString
            newEditingString:(NSString *__autoreleasing *)newString
            errorDescription:(NSString *__autoreleasing *)error
{
    // todo: implement
    return YES;
}

- (BOOL)isPartialStringValid:(NSString *__autoreleasing *)partialStringPtr
       proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
              originalString:(NSString *)origString
       originalSelectedRange:(NSRange)origSelRange
            errorDescription:(NSString *__autoreleasing *)error
{
    NSString *partialString = [(*partialStringPtr) copy];
    
    // reduce "model" from entry characters
    NSString *modelString = [partialString copy];
    NSString *previousModelString = [origString copy];

    NSArray *filteredComponents = [partialString componentsSeparatedByCharactersInSet:[self.entryCharacterSet invertedSet]];
    modelString = [filteredComponents componentsJoinedByString:@""];
    
    NSArray *separatedComponents = [partialString componentsSeparatedByCharactersInSet:self.entryCharacterSet];
    for (NSString *component in separatedComponents) {
        modelString = [modelString stringByReplacingOccurrencesOfString:component withString:@""];
    }
    
    NSArray *previousSeparatedComponents = [previousModelString componentsSeparatedByCharactersInSet:self.entryCharacterSet];
    for (NSString *component in previousSeparatedComponents) {
        previousModelString = [previousModelString stringByReplacingOccurrencesOfString:component withString:@""];
    }
    
    // detect deletion of non-model character, and treat it as a model character deletion
    if (partialString.length < origString.length
        && modelString.length >= previousModelString.length
        && modelString.length > 0) {
        // delete from the model string
        modelString = [modelString substringToIndex:modelString.length - 1];
    }
    
    NSLog(@"New model string: %@", modelString);
    
    // put model string into back into template
    NSMutableString *modelBuffer = [modelString mutableCopy];
    NSMutableString *mutableTemplate = [self.template mutableCopy];
    NSRange proposedSelectionRange = NSMakeRange(NSNotFound, 0);
    
    // iterate over each character in the template and either 1) skip template chars, 2) fill in with model chars, or 3) fill in with empty strings (for placeholder strings)
    for (int i = 0; i < self.template.length; i++) {
        
        if (![self.templateCharacterSet characterIsMember:[mutableTemplate characterAtIndex:i]]) {
            
            NSRange templateCharacterRange = NSMakeRange(i, 1); // the current index being replaced in the template
            
            // if there are characters in the model buffer to add to the template, add them
            if (modelBuffer.length > 0) {
                NSRange nextModelCharacterRange = NSMakeRange(0, 1); // the character at the beginning of the model buffer
                
                NSString *characterToAdd = [modelBuffer substringWithRange:nextModelCharacterRange];
                [modelBuffer deleteCharactersInRange:nextModelCharacterRange];
                
                [mutableTemplate replaceCharactersInRange:templateCharacterRange withString:characterToAdd];
            }
            
            // else:
            // 1) assign the proposed selection range if one hasn't been set, as this is the first non-template and non-model character
            // 2) replace the non-template filler with a space ' '
            // TODO: make this optional
            else
            {
                if (proposedSelectionRange.location == NSNotFound) {
                    proposedSelectionRange = NSMakeRange(i, 0);
                }
                
                [mutableTemplate replaceCharactersInRange:templateCharacterRange withString:@" "];
            }
        }
    }
    
    // pass up the new template as the string
    if (partialStringPtr) {
        *partialStringPtr = [mutableTemplate copy];
    }
    
    // pass up the proposed selection range. If the proposed selection range wasn't found,
    // move the pointer ahead by the # of new model characters added
    if (proposedSelRangePtr) {
        
        if (proposedSelectionRange.location == NSNotFound) {
            proposedSelectionRange = NSMakeRange(mutableTemplate.length, 0);
        }
        *proposedSelRangePtr = proposedSelectionRange;
    }
    
    return YES;
}

#pragma mark - Initializers

- (id)initWithTextEntryTemplate:(NSString *)textEntryTemplate templateCharacterSet:(NSCharacterSet *)templateCharacterSet entryCharacterSet:(NSCharacterSet *)entryCharacterSet
{
    self = [super init];
    if (self) {
        _template = textEntryTemplate;
        _templateCharacterSet = templateCharacterSet;
        _entryCharacterSet = entryCharacterSet;
    }
    return self;
}

@end

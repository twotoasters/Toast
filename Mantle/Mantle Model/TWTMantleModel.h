//
//  TWTMantleModel.h
//  Toast
//
//  Created by Prachi Gauriar on 3/8/2014.
//  Copyright (c) 2014 Two Toasters, LLC.
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

#import <Mantle/Mantle.h>

@interface TWTMantleModel : MTLModel

/*!
 @abstract Returns a set of property keys that should be excluded from Mantle operations on the receiver’s 
     instances.
 @discussion Subclasses should override this method to return any keys that should not be automatically
     encoded/decoded or included in calculations of -hash, -isEqual:, or -description. The default 
     implementation returns the empty set.

     One important use of this method is to handle inverse relationships. Mantle can’t detect circular 
     references, and thus its default implementations of -description, -hash, and -isEqual: will recurse
     infinitely unless inverse relationships are excluded. By implementing this method and returning keys
     for the inverse relationships, the aforementioned methods will just work.
 
     Subclasses should take care that their implementation of this method adds their excluded property keys
     to those of their superclass’s. A typical implementation looks like:
 
         return [[super excludedPropertyKeys] setByAddingObjectsFromArray:@[ o1, o2, …, oN ]];
 @result A set of property keys that should be excluded from Mantle operations on the receiver’s instances.
 */
+ (NSSet *)excludedPropertyKeys;

@end

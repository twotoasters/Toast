//
//  NSArray+TWTIndexPath.h
//  Toast
//
//  Created by Andrew Hershberger on 3/9/14.
//  Copyright (c) 2015 Ticketmaster
//
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

#import <Foundation/Foundation.h>


@interface NSArray (TWTIndexPath)

/*!
 @abstract returns the object at the specified index path or nil if no such index path exists
 @param indexPath the index path used to look up the object. All intermediate objects must be also arrays.
 @return the object found at the index path or nil if the index path is nil or has 0 length
 */
- (id)twt_objectAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @abstract finds the first occurrence of object by performing a breadth-first search and returns the corresponding index path
 @param object the object to find
 @return the index path of the first occurrence of object or nil if the object can't be found
 */
- (NSIndexPath *)twt_indexPathOfObject:(id)object;

@end

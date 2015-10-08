//
//  TWTDateRange.h
//  Toast
//
//  Created by Duncan Lewis on 3/23/2015.
//  Copyright (c) 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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


/*!
 TWTDateRanges model ranges of dates. They are useful for determining whether a date falls between
 two other dates. Date ranges are closed; that is, they include both their start and end dates.
 */
@interface TWTDateRange : NSObject <NSCopying, NSSecureCoding>

/*!
 @abstract The first date in the date range. 
 @discussion By default, this is equivalent to +[NSDate distantPast]. It cannot be nil.
 */
@property (nonatomic, strong, readonly) NSDate *startDate;

/*!
 @abstract The last date in the date range.
 @discussion By default, this is equivalent to +[NSDate distantFuture]. It cannot be nil and is always
     on or after startDate.
 */
@property (nonatomic, strong, readonly) NSDate *endDate;


/*!
 @abstract Initializes a newly created date range with the specified start and end dates.
 @discussion This is the class’s designated initializer.
 @param startDate The first date in the date range. If nil, [NSDate distantPast] is used.
 @param endDate The last date in the date range. If nil, [NSDate distantFuture] is used. Raises an assertion if
     this date is before the start date.
 @result An initialized date range instance with the specified start and end dates.
 */
- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate NS_DESIGNATED_INITIALIZER;


/*!
 @abstract Returns whether the specified date is between the receiver’s start and end dates.
 @discussion Because date ranges are closed, the specified date is contained in the receiver unless it is strictly
     before the receiver’s start date or strictly after its end date.
 @param date The date to test.
 @result Whether the specified date is between the receiver’s start and end dates. Returns NO if the date parameter is 
     nil.
 */
- (BOOL)containsDate:(NSDate *)date;


/*!
 @abstract Returns whether the specified date range lies completely within the receiver’s start and end dates.
 @discussion The date range is contained within the receiver if its start date is on or after the receiver’s start date 
     and its end date is on or before the receiver’s end date.
 @param date The date range to test.
 @result Whether the specified date range lies completely within between the receiver’s start and end dates. Returns NO
     if the date range parameter is nil.
 */
- (BOOL)containsDateRange:(TWTDateRange *)dateRange;


/*!
 @abstract Returns the intersection of the specified date range and the receiver, or nil if the intersection is empty.
 @discussion The intersection of two date ranges is the range of dates common to both. Its start date is the later of the
     two date ranges’ start dates; its end date is the earlier of their end dates.
 @param date The date range with which to find the intersection.
 @result The intersection of the specified date range and the receiver, or nil if the intersection is empty.
 */
- (TWTDateRange *)intersectionWithDateRange:(TWTDateRange *)dateRange;

@end

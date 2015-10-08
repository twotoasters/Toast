//
//  TWTDateRangeTests.m
//  Toast
//
//  Created by Prachi Gauriar on 10/8/2015.
//  Copyright © 2015 Ticketmaster Entertainment, Inc. All rights reserved.
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

#import "TWTRandomizedTestCase.h"

#import <URLMock/UMKTestUtilities.h>

#import "TWTDateRange.h"


@interface TWTDateRangeTests : TWTRandomizedTestCase

// Between 1–100 seconds since now
@property (nonatomic, strong) NSDate *startDate;

// Between 1–100 seconds after start date
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSTimeInterval startToEndTimeInterval;

@end


@implementation TWTDateRangeTests

- (void)setUp
{
    [super setUp];
    self.startDate = [NSDate dateWithTimeIntervalSinceNow:-(random() % 100 + 1)];
    self.endDate = [NSDate dateWithTimeInterval:(random() % 100 + 1) sinceDate:self.startDate];
    self.startToEndTimeInterval = [self.endDate timeIntervalSinceDate:self.startDate];
}


- (void)testInit
{
    // No parameters
    TWTDateRange *dateRange = [[TWTDateRange alloc] init];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, [NSDate distantPast], @"start date is not distant past");
    XCTAssertEqualObjects(dateRange.endDate, [NSDate distantFuture], @"end date is not distant future");


    // nil start and end dates
    dateRange = [[TWTDateRange alloc] initWithStartDate:nil endDate:nil];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, [NSDate distantPast], @"start date is not distant past");
    XCTAssertEqualObjects(dateRange.endDate, [NSDate distantFuture], @"end date is not distant future");

    // non-nil start date, nil end date
    dateRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:nil];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, self.startDate, @"start date is not set correctly");
    XCTAssertEqualObjects(dateRange.endDate, [NSDate distantFuture], @"end date is not distant future");

    // nil start date, non-nil end date
    dateRange = [[TWTDateRange alloc] initWithStartDate:nil endDate:self.endDate];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, [NSDate distantPast], @"start date is not distant past");
    XCTAssertEqualObjects(dateRange.endDate, self.endDate, @"end date is not set correctly");

    // non-nil start and end dates
    dateRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, self.startDate, @"start date is not set correctly");
    XCTAssertEqualObjects(dateRange.endDate, self.endDate, @"end date is not set correctly");

    // equal non-nil start and end dates
    dateRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.startDate];
    XCTAssertNotNil(dateRange, @"returns nil date range");
    XCTAssertEqualObjects(dateRange.startDate, self.startDate, @"start date is not set correctly");
    XCTAssertEqualObjects(dateRange.endDate, self.startDate, @"end date is not set correctly");

    // end date before start date
    XCTAssertThrows([[TWTDateRange alloc] initWithStartDate:self.endDate endDate:self.startDate], @"does not raise assertion");
}


- (void)testCopy
{
    TWTDateRange *range = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];
    TWTDateRange *copy = [range copy];

    XCTAssertNotNil(copy, @"returns nil copy");
    XCTAssertEqualObjects(range, copy, @"date range and copy are not equal");
    XCTAssertEqualObjects(range.startDate, copy.startDate, @"date range and copy have unequal start dates");
    XCTAssertEqualObjects(range.endDate, copy.endDate, @"date range and copy have unequal end dates");
}


- (void)testHashAndIsEqual
{
    TWTDateRange *equalRange1 = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];
    TWTDateRange *equalRange2 = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];
    TWTDateRange *unequalRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.startDate];

    XCTAssertEqual(equalRange1.hash, equalRange2.hash, @"hashes are different for equal objects");
    XCTAssertEqualObjects(equalRange1, equalRange2, @"equal objects are not equal");

    XCTAssertNotEqualObjects(equalRange1, unequalRange, @"unequal objects are equal");
}


- (void)testNSCoding
{
    TWTDateRange *range = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];

    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:range];
    XCTAssertNotNil(encodedData, @"archived date range is non-nil");

    TWTDateRange *decodedRange = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];
    XCTAssertNotNil(decodedRange, @"returns nil decoded date range");
    XCTAssertEqualObjects(range, decodedRange, @"date range and decoded date range are not equal");
    XCTAssertEqualObjects(range.startDate, decodedRange.startDate, @"date range and decoded date range have unequal start dates");
    XCTAssertEqualObjects(range.endDate, decodedRange.endDate, @"date range and decoded date range have unequal end dates");
}


- (void)testContainsDate
{
    TWTDateRange *range = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];

    XCTAssertFalse([range containsDate:nil], @"date range contains nil date");

    XCTAssertTrue([range containsDate:range.startDate], @"date range does not contain its own start date");
    XCTAssertTrue([range containsDate:[range.startDate dateByAddingTimeInterval:self.startToEndTimeInterval / 2]],
                  @"date range does not contain date strictly between its own start and end dates");
    XCTAssertTrue([range containsDate:range.endDate], @"date range does not contain its own end date");

    XCTAssertFalse([range containsDate:[range.startDate dateByAddingTimeInterval:-0.5]], @"date range contains date strictly before its own start date");
    XCTAssertFalse([range containsDate:[range.endDate dateByAddingTimeInterval:0.5]], @"date range contains date strictly after its own end date");
}


- (void)testContainsDateRange
{
    TWTDateRange *range = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];

    XCTAssertFalse([range containsDateRange:nil], @"date range contains nil date range");
    XCTAssertTrue([range containsDateRange:range], @"date range does not contain itself");

    TWTDateRange *containedRange = [[TWTDateRange alloc] initWithStartDate:[self.startDate dateByAddingTimeInterval:0.25]
                                                                   endDate:[self.endDate dateByAddingTimeInterval:-0.25]];
    XCTAssertTrue([range containsDateRange:containedRange], @"date range does not contain a range strictly smaller than it");

    TWTDateRange *uncontainedRange = [[TWTDateRange alloc] initWithStartDate:[self.startDate dateByAddingTimeInterval:-0.25] endDate:self.endDate];
    XCTAssertFalse([range containsDateRange:uncontainedRange], @"date range contains a range that has an earlier start date than it");

    uncontainedRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:[self.endDate dateByAddingTimeInterval:0.25]];
    XCTAssertFalse([range containsDateRange:uncontainedRange], @"date range contains a range that has an later end date than it");

    uncontainedRange = [[TWTDateRange alloc] initWithStartDate:[self.startDate dateByAddingTimeInterval:-0.25]
                                                       endDate:[self.endDate dateByAddingTimeInterval:0.25]];
    XCTAssertFalse([range containsDateRange:uncontainedRange], @"date range contains a range that has an earlier start date and a later end date than it");
}


- (void)testIntersectionWithDateRange
{
    TWTDateRange *range = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];

    // nil range
    XCTAssertNil([range intersectionWithDateRange:nil], @"range ∩ nil returns non-nil date range");

    // equal ranges
    XCTAssertEqualObjects([range intersectionWithDateRange:range], range, @"range ∩ range is not equal to the range");

    // range intersect contained range
    TWTDateRange *containedRange = [[TWTDateRange alloc] initWithStartDate:[self.startDate dateByAddingTimeInterval:0.25]
                                                                   endDate:[self.endDate dateByAddingTimeInterval:-0.25]];
    XCTAssertEqualObjects([range intersectionWithDateRange:containedRange], containedRange,
                          @"range ∩ contained range does not equal contained range");

    // contained range intersect range
    XCTAssertEqualObjects([containedRange intersectionWithDateRange:range], containedRange,
                          @"contained range ∩ range does not equal contained range");

    // intersection with range with earlier start date
    TWTDateRange *uncontainedRange = [[TWTDateRange alloc] initWithStartDate:[self.startDate dateByAddingTimeInterval:-0.25] endDate:self.endDate];
    TWTDateRange *intersection = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:self.endDate];
    XCTAssertEqualObjects([range intersectionWithDateRange:uncontainedRange], intersection,
                          @"incorrect intersection with uncontained date range (earlier start date)");

    // intersection with range with later end date
    uncontainedRange = [[TWTDateRange alloc] initWithStartDate:self.startDate endDate:[self.endDate dateByAddingTimeInterval:0.25]];
    XCTAssertEqualObjects([range intersectionWithDateRange:uncontainedRange], intersection,
                          @"incorrect intersection with uncontained date range (later end date)");
}

@end

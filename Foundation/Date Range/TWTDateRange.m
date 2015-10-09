//
//  TWTDateRange.m
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

#import "TWTDateRange.h"


@implementation TWTDateRange

- (instancetype)init
{
    return [self initWithStartDate:nil endDate:nil];
}


- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate
{
    self = [super init];
    if (self) {
        _startDate = startDate ? startDate : [NSDate distantPast];
        _endDate = endDate ? endDate : [NSDate distantFuture];
        NSAssert([startDate compare:endDate] <= NSOrderedSame, @"The start date must not occur after the end date");
    }

    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %p: startDate=%@; endDate=%@ >", self.class, self, self.startDate, self.endDate];
}


- (NSUInteger)hash
{
    return self.startDate.hash ^ self.endDate.hash;
}


- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:self.class]) {
        return NO;
    }

    typeof(self) other = object;
    return [self.startDate isEqualToDate:other.startDate] && [self.endDate isEqualToDate:other.endDate];
}


#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}


#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding
{
    return YES;
}


- (instancetype)initWithCoder:(NSCoder *)decoder
{
    NSDate *startDate = [decoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(startDate))];
    NSDate *endDate = [decoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(endDate))];
    return [self initWithStartDate:startDate endDate:endDate];
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.startDate forKey:NSStringFromSelector(@selector(startDate))];
    [encoder encodeObject:self.endDate forKey:NSStringFromSelector(@selector(endDate))];
}


#pragma mark - Containment and Intersection

- (BOOL)containsDate:(NSDate *)date
{
    return date && [date compare:self.startDate] >= NSOrderedSame && [date compare:self.endDate] <= NSOrderedSame;
}


- (BOOL)containsDateRange:(TWTDateRange *)dateRange
{
    return dateRange && [self.startDate compare:dateRange.startDate] <= NSOrderedSame && [self.endDate compare:dateRange.endDate] >= NSOrderedSame;
}


- (TWTDateRange *)intersectionWithDateRange:(TWTDateRange *)dateRange
{
    // If the intersection is empty, return nil
    if (!dateRange || [dateRange.startDate compare:self.endDate] > NSOrderedSame || [dateRange.endDate compare:self.startDate] < NSOrderedSame) {
        return nil;
    }
    
    return [[TWTDateRange alloc] initWithStartDate:[dateRange.startDate laterDate:self.startDate]
                                           endDate:[dateRange.endDate earlierDate:self.endDate]];
}

@end

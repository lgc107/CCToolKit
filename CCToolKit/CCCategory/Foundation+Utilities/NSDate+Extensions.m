//
//  NSDate+Extensions.m
//  CCToolKit
//
//  Created by Harry_L on 2018/6/2.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Format)
+ (NSDate *)cc_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)cc_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone Locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    
    return [self dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    
    NSDate *nsDate = nil;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    components.year   = year;
    components.month  = month;
    components.day    = day;
    components.hour   = hour;
    components.minute = minute;
    components.second = second;
    
    nsDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return nsDate;
}

- (NSString *)cc_stringWithFormat:(NSString *)format{
   return  [self cc_stringWithFormat:format timeZone:nil locale:nil];
}

- (NSString *)cc_stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (timeZone) [formatter setTimeZone:timeZone];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

@end

@implementation NSDate (Property)

- (NSInteger)era{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitEra fromDate:self] era];
}

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month{
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}
- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)nanosecond {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}



- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)dayOfYear{
   return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
  
    NSUInteger year = self.year;
   
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate date].day == self.day;
}

- (BOOL)isTomorrow{
    NSDate *tomorrow = [[NSDate date] cc_dateByAddingDays:1];
    return [self cc_isSameDay:tomorrow];
}

- (BOOL)isYesterday{
    NSDate *added = [self cc_dateByAddingDays:1];
    return [added isToday];
}

// 周末
- (BOOL)isWeekend{
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSRange weekdayRange            = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components    = [calendar components:NSCalendarUnitWeekday
                                                  fromDate:self];
    NSUInteger weekdayOfSomeDate    = [components weekday];
    
    BOOL result = NO;
    
    if (weekdayOfSomeDate == weekdayRange.location || weekdayOfSomeDate == weekdayRange.length)
        result = YES;
    
    return result;
}
@end


@implementation NSDate (Utilities)


+ (BOOL)cc_isLeapYear:(NSInteger)year{
    return ((year % 400 == 0) ||( (year %100 != 0) && (year % 4 == 0)));
}

+ (BOOL)cc_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate{
    if ((date.era == compareDate.era) && (date.year == compareDate.year) && (date.month == compareDate.month) && (date.day == compareDate.day)) {
        return true;
    }
    return false;
}

- (BOOL)cc_isSameDay:(NSDate *)date{
    return [NSDate cc_isSameDay:self asDate:date];
}

- (BOOL)cc_isBetweenFromHour:(NSInteger)hour toHour:(NSInteger)otherHour{
    if (self.hour >= hour && self.hour <= otherHour) {
        return true;
    }
    return false;
}

- (BOOL)cc_isBetweenFromDate:(NSDate *)date toDate:(NSDate *)otherDate{
    if ([self earlierDate:otherDate] && [self laterDate:date]) {
        return true;
    }
    return false;
}

- (BOOL)cc_isInThisWeek{
    NSDate *nowDate = [NSDate date];
    if (self.weekday == 1 && self.year == nowDate.year && self.weekOfYear == nowDate.year + 1) {
        return true;
    }
    else if (self.year == nowDate.year && self.weekOfYear == nowDate.year) {
        return true;
    }
    return false;
}

- (NSInteger)cc_daysInMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return days.length;
}

- (NSInteger)cc_daysInYear{
    if (self.isLeapYear) {
        return 366;
    }
    return 365;
}

- (NSArray<NSDate *> *)cc_getWeekAllDays{
    NSInteger firstDiff = 0;
    NSInteger lastDiff = 0;
    if (self.weekday == 1) {
        firstDiff = -6;
        lastDiff = 0;
    }
    else{
        firstDiff = 2 - self.weekday;
        lastDiff = 8 - self.weekday;
    }
    NSMutableArray *weekAllDays = [NSMutableArray array];
    for (NSInteger i = firstDiff; i <= lastDiff; i++) {
        NSDate *date = [self cc_dateByAddingDays:i];
        [weekAllDays addObject:date];
    }
    return weekAllDays;
}

- (NSInteger)cc_daysToToday
{
    NSTimeInterval late=[self timeIntervalSince1970]*1;
    NSDate* date = [NSDate date];
    NSString *nowDateString = [date cc_stringWithFormat:@"YYYY-MM-dd"];
    NSDate *todayDate = [NSDate cc_dateWithString:nowDateString format:@"YYYY-MM-dd"];
    NSTimeInterval now=[todayDate timeIntervalSince1970]*1;
    NSTimeInterval cha=now-late;
    
    NSString * timeString = [NSString stringWithFormat:@"%f", cha/86400];
    timeString = [timeString substringToIndex:timeString.length-7];
    return [timeString integerValue];
    
}

@end


@implementation NSDate (Modify)

- (NSDate *)cc_dateByAddingYears:(NSInteger)years{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)cc_dateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}
- (NSDate *)cc_dateByAddingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cc_dateByAddingDays:(NSInteger)days{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)cc_dateByAddingHours:(NSInteger)hours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)cc_dateByAddingMinutes:(NSInteger)minutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)cc_dateByAddingSeconds:(NSInteger)seconds{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

@end

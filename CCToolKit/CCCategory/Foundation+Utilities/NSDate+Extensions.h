//
//  NSDate+Extensions.h
//  CCToolKit
//
//  Created by Harry_L on 2018/6/2.
//  Copyright © 2018年 Harry_L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Format)


/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (NSDate *)cc_dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 @param timeZone   The time zone, can be nil.
 @param locale     The locale, can be nil.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (NSDate *)cc_dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone Locale:(NSLocale *)locale;

/**
 return an NSDate With Special year、month and day. (current calendar).

 */
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
/**
 return an NSDate With Special year、month、hour、minute、second  (current calendar)

 */
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format   String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)cc_stringWithFormat:(NSString *)format;

/**
 Returns a formatted string representing this date.
 see http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns
 for format description.
 
 @param format    String representing the desired date format.
 e.g. @"yyyy-MM-dd HH:mm:ss"
 
 @param timeZone  Desired time zone.
 
 @param locale    Desired locale.
 
 @return NSString representing the formatted date string.
 */
- (nullable NSString *)cc_stringWithFormat:(NSString *)format
                               timeZone:(nullable NSTimeZone *)timeZone
                                 locale:(nullable NSLocale *)locale;
@end

@interface NSDate (Property)


#pragma mark - Component Properties
///=============================================================================
/// @name Component Properties
///=============================================================================

@property (nonatomic, readonly) NSInteger era;
/**
 Year component
 */
@property (nonatomic, readonly) NSInteger year;

/**
 Month component (1~12)
 */
@property (nonatomic, readonly) NSInteger month;

/**
  Day component (1~31)
 */
@property (nonatomic, readonly) NSInteger day;

/**
 Hour component (0~23)
 */
@property (nonatomic, readonly) NSInteger hour;

/**
 Minute component (0~59)
 */
@property (nonatomic, readonly) NSInteger minute;

/**
 Second component (0~59)
 */
@property (nonatomic, readonly) NSInteger second;

/**
 Nanosecond component
 */
@property (nonatomic, readonly) NSInteger nanosecond;

/**
 Weekday component (1~7, first day is based on user setting)
 */
@property (nonatomic, readonly) NSInteger weekday;

/**
 WeekdayOrdinal component
 */
@property (nonatomic, readonly) NSInteger weekdayOrdinal;

/**
 WeekOfMonth component (1~5)
 */
@property (nonatomic, readonly) NSInteger weekOfMonth;

/**
 WeekOfYear component (1~53)
 */
@property (nonatomic, readonly) NSInteger weekOfYear;

/**
 dayOfYear component (1~365 or 1~366)
 */
@property (nonatomic, readonly) NSInteger dayOfYear;
/**
 YearForWeekOfYear component
 */
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;

/**
 Quarter component
 */
@property (nonatomic, readonly) NSInteger quarter;

/**
 Weather the month is leap month
 */
@property (nonatomic, readonly) BOOL isLeapMonth;

/**
 Weather the year is leap year
 */
@property (nonatomic, readonly) BOOL isLeapYear;

/**
 Weather date is today (based on current locale)
 */
@property (nonatomic, readonly) BOOL isToday;

/**
 < Weather date is tomorrow (based on current locale)
 
 */
@property (nonatomic, readonly) BOOL isTomorrow;

/**
 < Weather date is yesterday (based on current locale)
 */
@property (nonatomic, readonly) BOOL isYesterday;
/**
  Weather date is weekend (based on current locale)
 */
@property (nonatomic, readonly) BOOL isWeekend;

@end

#pragma mark - TimeAgo


#pragma mark - Utiliteis
@interface NSDate (Utilities)

/**
 Weather the year is leap year
 */
+ (BOOL)cc_isLeapYear:(NSInteger)year;
/**
 *  Returns whether two dates fall on the same day.
 *
 *  @param date NSDate - First date to compare
 *  @param compareDate NSDate - Second date to compare
 *  @return BOOL - YES if both paramter dates fall on the same day, NO otherwise
 */
+ (BOOL)cc_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate;
/**
 *  Returns whether two dates fall on the same day.
 *
 *  @param date NSDate - Date to compare with sender
 *  @return BOOL - YES if both paramter dates fall on the same day, NO otherwise
 */
- (BOOL)cc_isSameDay:(NSDate *)date;

/**
 whether the receiver is in [hour,otherHour]. eg.[0,13], [13,21]. OtherHour > hour.
 */
- (BOOL)cc_isBetweenFromHour:(NSInteger)hour toHour:(NSInteger)otherHour;
/**
 whether the receiver is eariler than otherDate and later than date.
 */
- (BOOL)cc_isBetweenFromDate:(NSDate *)date toDate:(NSDate *)otherDate;

/**
  whether the receiver is in this week.
 */
- (BOOL)cc_isInThisWeek;
/**
 *  Returns how many days are in the month of the receiver.
 *
 *  @return NSInteger
 */
- (NSInteger)cc_daysInMonth;
/**
 *  Returns how many days are in the year of the receiver.
 *
 *  @return NSInteger
 */
- (NSInteger)cc_daysInYear;
/**
 *  Returns all days In receiver's  week.
 *
 *  @return NSInteger
 */
- (NSArray <NSDate *> *)cc_getWeekAllDays;

- (NSInteger)cc_daysToToday;

@end


@interface NSDate (Modify)
#pragma mark - Date By Adding
/**
 *  Returns a date representing the receivers date shifted later by the provided number of years.
 *
 *  @param years NSInteger - Number of years to add
 *
 *  @return NSDate - Date modified by the number of desired years
 */
- (NSDate *)cc_dateByAddingYears:(NSInteger)years;

/**
 *  Returns a date representing the receivers date shifted later by the provided number of months.
 *
 *  @param months NSInteger - Number of months to add
 *
 *  @return NSDate - Date modified by the number of desired months
 */
- (NSDate *)cc_dateByAddingMonths:(NSInteger)months;

/**
 *  Returns a date representing the receivers date shifted later by the provided number of weeks.
 *
 *  @param weeks NSInteger - Number of weeks to add
 *
 *  @return NSDate - Date modified by the number of desired weeks
 */
- (NSDate *)cc_dateByAddingWeeks:(NSInteger)weeks;
/**
 *  Returns a date representing the receivers date shifted later by the provided number of days.
 *
 *  @param days NSInteger - Number of days to add
 *
 *  @return NSDate - Date modified by the number of desired days
 */
- (NSDate *)cc_dateByAddingDays:(NSInteger)days;

/**
 *  Returns a date representing the receivers date shifted later by the provided number of hours.
 *
 *  @param hours NSInteger - Number of hours to add
 *
 *  @return NSDate - Date modified by the number of desired hours
 */
- (NSDate *)cc_dateByAddingHours:(NSInteger)hours;
/**
 *  Returns a date representing the receivers date shifted later by the provided number of minutes.
 *
 *  @param minutes NSInteger - Number of minutes to add
 *
 *  @return NSDate - Date modified by the number of desired minutes
 */
- (NSDate *)cc_dateByAddingMinutes:(NSInteger)minutes;

/**
 *  Returns a date representing the receivers date shifted later by the provided number of seconds.
 *
 *  @param seconds NSInteger - Number of seconds to add
 *
 *  @return NSDate - Date modified by the number of desired seconds
 */
- (NSDate *)cc_dateByAddingSeconds:(NSInteger)seconds;
@end


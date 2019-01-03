//
//  NSDate+common.h
//  EnergyManager
//
//  Created by joker on 2018/3/21.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#define D_MINUTE      60
#define D_HOUR        3600
#define D_DAY         86400
#define D_WEEK        604800
#define D_YEAR        31556926
@interface NSDate(common)
//date 转 NSString
+(NSString *)getCurrentTime;
+(NSString *)gerCurrentDetailTime;
+(NSString *)getTimeWithDate:(NSDate*)date;
+(NSString *)getTimeWithFormater:(NSString *)formater;
+(NSString *)getTimeWithDate:(NSDate *)date Formater:(NSString *)formater;

+(NSString *)changeTimeFormatWithTime:(NSString *)time;
+(NSString *)changeTimeFormatWithTime:(NSString *)time Formater:(NSString *)formater;

+(NSString *)getLastMonthTime;
+(NSString *)getLastMonthTimeWithTime:(NSString *)time;
+(NSString *)getLastMonthTimeWithInterval:(int)interval;
+(NSString *)getLastMonthTimeWithTime:(NSString *)time Interval:(int)interval;

-(NSString *)stringWithFormat:(NSString *)format;
-(NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

//NSString 转 date
+(NSDate *)getTimeWithTime:(NSString *)time Formater:(NSString *)formater;
-(NSDate *)dateWithFormatter:(NSString *)formatter;

// Relative dates from the current date
+(NSDate *)dateTomorrow;
+(NSDate *)dateYesterday;
+(NSDate *)dateWithDaysFromNow:(NSInteger)days;
+(NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+(NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
+(NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
+(NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
+(NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;
+(NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;
+(NSCalendar *)currentCalendar;


-(NSString *)defaultDescription;
-(NSString *)timeIntervalDescription;//距离当前的时间间隔描述
-(NSString *)minuteDescription;/*精确到分钟的日期描述*/
-(NSString *)formattedTime;
-(NSString *)formattedDateDescription;//格式化日期描述
-(NSString *)formattedMonthDateDescription;
-(double)timeIntervalSince1970InMilliSecond;
+(NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond;
+(NSString *)formattedTimeFromTimeInterval:(long long)time;


// Comparing dates
-(BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
-(BOOL)isToday;
-(BOOL)isTomorrow;
-(BOOL)isYesterday;
-(BOOL)isSameWeekAsDate:(NSDate *)aDate;
-(BOOL)isThisWeek;
-(BOOL)isNextWeek;
-(BOOL)isLastWeek;
-(BOOL)isSameMonthAsDate:(NSDate *)aDate;
-(BOOL)isThisMonth;
-(BOOL)isSameYearAsDate:(NSDate *)aDate;
-(BOOL)isThisYear;
-(BOOL)isNextYear;
-(BOOL)isLastYear;
-(BOOL)isEarlierThanDate:(NSDate *)aDate;
-(BOOL)isLaterThanDate:(NSDate *)aDate;
-(BOOL)isInFuture;
-(BOOL)isInPast;
// Date roles
-(BOOL)isTypicallyWorkday;
-(BOOL)isTypicallyWeekend;


// Adjusting dates
-(NSDate *)dateByAddingYears:(NSInteger)dYears;
-(NSDate *)dateBySubtractingYears:(NSInteger)dYears;
-(NSDate *)dateByAddingMonths:(NSInteger)dMonths;
-(NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;
-(NSDate *)dateByAddingDays:(NSInteger)dDays;
-(NSDate *)dateBySubtractingDays:(NSInteger)dDays;
-(NSDate *)dateByAddingHours:(NSInteger)dHours;
-(NSDate *)dateBySubtractingHours:(NSInteger)dHours;
-(NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
-(NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;
-(NSDate *)dateAtStartOfDay;
-(NSDate *)dateAtEndOfDay;

// Retrieving intervals
-(NSInteger)minutesAfterDate:(NSDate *)aDate;
-(NSInteger)minutesBeforeDate:(NSDate *)aDate;
-(NSInteger)hoursAfterDate:(NSDate *)aDate;
-(NSInteger)hoursBeforeDate:(NSDate *)aDate;
-(NSInteger)daysAfterDate:(NSDate *)aDate;
-(NSInteger)daysBeforeDate:(NSDate *)aDate;
-(NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;
// Decomposing dates
@property(readonly)NSInteger nearestHour;
@property(readonly)NSInteger hour;
@property(readonly)NSInteger minute;
@property(readonly)NSInteger seconds;
@property(readonly)NSInteger day;
@property(readonly)NSInteger month;
@property(readonly)NSInteger week;
@property(readonly)NSInteger weekday;
@property(readonly)NSInteger nthWeekday;
@property(readonly)NSInteger year;

@property(nonatomic,readonly)NSString *shortString;
@property(nonatomic,readonly)NSString *shortDateString;
@property(nonatomic,readonly)NSString *shortTimeString;
@property(nonatomic,readonly)NSString *mediumString;
@property(nonatomic,readonly)NSString *mediumDateString;
@property(nonatomic,readonly)NSString *mediumTimeString;
@property(nonatomic,readonly)NSString *longString;
@property(nonatomic,readonly)NSString *longDateString;
@property(nonatomic,readonly)NSString *longTimeString;

@end

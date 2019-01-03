//
//  NSDate+common.m
//  EnergyManager
//
//  Created by joker on 2018/3/21.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "NSDate+common.h"
#import <UIKit/UIKit.h>
#import "NSDateFormatter+common.h"

#define MESSAGE_IOS8_OR_LATER ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#ifndef DATE_COMPONENTS
#define DATE_COMPONENTS NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal
#endif

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (common)
+ (NSCalendar *)currentCalendar{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

#pragma mark convert NSString
+ (NSString *)getCurrentTime{
    return [self getTimeWithDate:[NSDate date] Formater:@"YYYYMMdd"];
}
+ (NSString *)gerCurrentDetailTime{
    return [self getTimeWithDate:[NSDate date] Formater:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)getTimeWithDate:(NSDate*)date{
    return [self getTimeWithDate:date Formater:@"YYYYMMdd"];
}
+ (NSString *)getTimeWithFormater:(NSString *)formater{
    return [self getTimeWithDate:[NSDate date] Formater:formater];
}
+ (NSString *)getTimeWithDate:(NSDate *)date Formater:(NSString *)formater{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formater];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

+(NSString *)changeTimeFormatWithTime:(NSString *)time{
    return [self changeTimeFormatWithTime:time Formater:@"YYYYMMdd"];
}
+(NSString *)changeTimeFormatWithTime:(NSString *)time Formater:(NSString *)formater{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formater];
    NSDate * nowDate = [self getTimeWithTime:time Formater:@"YYYYMMdd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:nowDate];
    return currentDateStr;
}

+ (NSString *)getLastMonthTime{
    return [self getLastMonthTimeWithTime:[self getCurrentTime] Interval:-30];
}
+ (NSString *)getLastMonthTimeWithTime:(NSString *)time{
    return [self getLastMonthTimeWithTime:time Interval:-30];
}
+ (NSString *)getLastMonthTimeWithInterval:(int)interval{
    return [self getLastMonthTimeWithTime:[self getCurrentTime] Interval:interval];
}
+ (NSString *)getLastMonthTimeWithTime:(NSString *)time Interval:(int)interval{
    return [NSDate getTimeWithDate:[[self getTimeWithTime:time Formater:@"YYYYMMdd"] dateByAddingDays:interval]];
}


-(NSString *)stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}
-(NSString *)stringWithDateStyle: (NSDateFormatterStyle)dateStyle timeStyle: (NSDateFormatterStyle)timeStyle{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    return [formatter stringFromDate:self];
}

#pragma mark convert NSDate
+ (NSDate *)getTimeWithTime:(NSString *)time Formater:(NSString *)formater{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formater];
    NSDate *dateTime = [formatter dateFromString:time];
    return dateTime;
}
-(NSDate *)dateWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

#pragma mark day
+ (NSDate *)dateTomorrow{
    return [NSDate dateWithDaysFromNow:1];
}
+ (NSDate *)dateYesterday{
    return [NSDate dateWithDaysBeforeNow:1];
}
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days{
    return [[NSDate date] dateByAddingDays:days];
}
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days{
    return [[NSDate date] dateBySubtractingDays:days];
}
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}

-(NSString *)defaultDescription{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}

-(NSString *)timeIntervalDescription{
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60){
        return @"1分钟内";
    } else if (timeInterval < 3600){
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / 60];
    } else if (timeInterval < 86400){
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / 3600];
    } else if (timeInterval < 2592000){
        return [NSString stringWithFormat:@"%.f天前", timeInterval / 86400];
    } else if (timeInterval < 31536000){
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月d日"];
        return [dateFormatter stringFromDate:self];
    } else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / 31536000];
    }
}

-(NSString *)minuteDescription{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    if ([theDay isEqualToString:currentDay]){
        [dateFormatter setDateFormat:@"ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400){
        [dateFormatter setDateFormat:@"ah:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 7){
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

-(NSString *)formattedTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [formatter setTimeZone:gmt];
    NSString * dateNow = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:[[dateNow substringWithRange:NSMakeRange(6,2)] intValue]];
    [components setMonth:[[dateNow substringWithRange:NSMakeRange(4,2)] intValue]];
    [components setYear:[[dateNow substringWithRange:NSMakeRange(0,4)] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:components];
    NSInteger hour = [self hoursAfterDate:date];
    NSDateFormatter *dateFormatter = nil;
    NSString *ret = @"";
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    if (!hasAMPM){
        if (hour <= 24 && hour >= 0){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
        }else if (hour < 0 && hour >= -24){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
        }else {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }else {
        if (hour >= 0 && hour <= 6){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"凌晨hh:mm"];
        }else if (hour > 6 && hour <=11 ){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
        }else if (hour > 11 && hour <= 17){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
        }else if (hour > 17 && hour <= 24){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"晚上hh:mm"];
        }else if (hour < 0 && hour >= -24){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
        }else  {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
        }
    }
    ret = [dateFormatter stringFromDate:self];
    return ret;
}

-(NSString *)formattedDateDescription{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < 60){
        return @"1分钟内";
    } else if (timeInterval < 3600){
        return [NSString stringWithFormat:@"%ld分钟前",(long)timeInterval / 60];
    } else if (timeInterval < 21600){
        return [NSString stringWithFormat:@"%ld小时前",(long)timeInterval / 3600];
    } else if ([theDay isEqualToString:currentDay]){
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400){
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

-(NSString *)formattedMonthDateDescription{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter stringFromDate:self];
}

-(double)timeIntervalSince1970InMilliSecond {
    double ret;
    ret = [self timeIntervalSince1970] * 1000;
    return ret;
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(double)timeIntervalInMilliSecond {
    NSDate *ret = nil;
    double timeInterval = timeIntervalInMilliSecond;
    if(timeIntervalInMilliSecond > 140000000000){
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    ret = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return ret;
}

+ (NSString *)formattedTimeFromTimeInterval:(long long)time{
    return [[NSDate dateWithTimeIntervalInMilliSecondSince1970:time] formattedTime];
}



-(BOOL)isToday{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}
-(BOOL)isTomorrow{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}
-(BOOL)isYesterday{
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}
-(BOOL)isSameWeekAsDate: (NSDate *)aDate{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    if (components1.weekOfYear != components2.weekOfYear)return NO;
    return (fabs([self timeIntervalSinceDate:aDate])< D_WEEK);
}
-(BOOL)isThisWeek{
    return [self isSameWeekAsDate:[NSDate date]];
}
-(BOOL)isNextWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
-(BOOL)isLastWeek{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}
-(BOOL)isThisMonth{
    return [self isSameMonthAsDate:[NSDate date]];
}
-(BOOL)isSameMonthAsDate: (NSDate *)aDate{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month)&&
            (components1.year == components2.year));
}
-(BOOL)isThisYear{
    return [self isSameYearAsDate:[NSDate date]];
}
-(BOOL)isSameYearAsDate: (NSDate *)aDate{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}
-(BOOL)isNextYear{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year + 1));
}
-(BOOL)isLastYear{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    return (components1.year == (components2.year - 1));
}

-(BOOL)isEqualToDateIgnoringTime: (NSDate *)aDate{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year)&&
            (components1.month == components2.month)&&
            (components1.day == components2.day));
}
-(BOOL)isEarlierThanDate: (NSDate *)aDate{
    return ([self compare:aDate] == NSOrderedAscending);
}
-(BOOL)isLaterThanDate: (NSDate *)aDate{
    return ([self compare:aDate] == NSOrderedDescending);
}

-(BOOL)isInFuture{
    return ([self isLaterThanDate:[NSDate date]]);
}
-(BOOL)isInPast{
    return ([self isEarlierThanDate:[NSDate date]]);
}


-(BOOL)isTypicallyWeekend{
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1)||
        (components.weekday == 7))
        return YES;
    return NO;
}

-(BOOL)isTypicallyWorkday{
    return ![self isTypicallyWeekend];
}


#pragma mark
-(NSDate *)dateByAddingYears: (NSInteger)dYears{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
-(NSDate *)dateBySubtractingYears: (NSInteger)dYears{
    return [self dateByAddingYears:-dYears];
}
-(NSDate *)dateByAddingMonths: (NSInteger)dMonths{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}
-(NSDate *)dateBySubtractingMonths: (NSInteger)dMonths{
    return [self dateByAddingMonths:-dMonths];
}
-(NSDate *)dateByAddingDays: (NSInteger)dDays{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *)dateBySubtractingDays: (NSInteger)dDays{
    return [self dateByAddingDays: (dDays * -1)];
}
-(NSDate *)dateByAddingHours: (NSInteger)dHours{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *)dateBySubtractingHours: (NSInteger)dHours{
    return [self dateByAddingHours: (dHours * -1)];
}
-(NSDate *)dateByAddingMinutes: (NSInteger)dMinutes{
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}
-(NSDate *)dateBySubtractingMinutes: (NSInteger)dMinutes{
    return [self dateByAddingMinutes: (dMinutes * -1)];
}
-(NSDate *)dateAtStartOfDay{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [CURRENT_CALENDAR dateFromComponents:components];
}
-(NSDate *)dateAtEndOfDay{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}


-(NSDateComponents *)componentsWithOffsetFromDate: (NSDate *)aDate{
    NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
    return dTime;
}


#pragma mark Retrieving Intervals
-(NSInteger)minutesAfterDate: (NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_MINUTE);
}

-(NSInteger)minutesBeforeDate: (NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}

-(NSInteger)hoursAfterDate: (NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_HOUR);
}

-(NSInteger)hoursBeforeDate: (NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

-(NSInteger)daysAfterDate: (NSDate *)aDate{
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_DAY);
}

-(NSInteger)daysBeforeDate: (NSDate *)aDate{
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

-(NSInteger)distanceInDaysToDate:(NSDate *)anotherDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}


#pragma mark Decomposing Dates
-(NSInteger)nearestHour{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [CURRENT_CALENDAR components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

-(NSInteger)week{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekOfYear;
}

-(NSInteger)weekday{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekday;
}

-(NSInteger)nthWeekday{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.weekdayOrdinal;
}

-(NSInteger)year{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.year;
}
-(NSInteger)month{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.month;
}
-(NSInteger)day{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.day;
}
-(NSInteger)hour{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.hour;
}

-(NSInteger)minute{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.minute;
}

-(NSInteger)seconds{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    return components.second;
}

#pragma mark - String Properties
-(NSString *)shortString{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

-(NSString *)shortTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

-(NSString *)shortDateString{
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

-(NSString *)mediumString{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

-(NSString *)mediumTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

-(NSString *)mediumDateString{
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

-(NSString *)longString{
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

-(NSString *)longTimeString{
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

-(NSString *)longDateString{
    return [self stringWithDateStyle:NSDateFormatterLongStyle  timeStyle:NSDateFormatterNoStyle];
}
@end

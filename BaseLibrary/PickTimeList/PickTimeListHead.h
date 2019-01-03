//
//  PickTimeListHead.h
//  BaseLibrary
//
//  Created by joker on 2018/11/22.
//  Copyright © 2018 joker. All rights reserved.
//

#ifndef PickTimeListHead_h
#define PickTimeListHead_h
typedef NS_ENUM(NSInteger,DateStyle){
    DateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    DateStyleShowMonthDayHourMinute,//月日时分
    DateStyleShowYearMonthDay,//年月日
    DateStyleShowYearMonth,//年月
    DateStyleShowMonthDay,//月日
    DateStyleShowHourMinute//时分
};
typedef NS_ENUM(NSInteger, DateType) {
    DayDateType = 0,
    MonthDateType,
    YearDateType,
};
#endif /* PickTimeListHead_h */

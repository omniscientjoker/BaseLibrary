//
//  NSDateFormatter+common.m
//  EnergyManager
//
//  Created by joker on 2018/3/21.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "NSDateFormatter+common.h"

@implementation NSDateFormatter (common)
+ (id)dateFormatter{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[self alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}
@end

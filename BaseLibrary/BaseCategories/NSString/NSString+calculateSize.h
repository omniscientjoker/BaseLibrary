//
//  NSString+calculateSize.h
//  EnergyManager
//
//  Created by joker on 2018/3/20.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (calculateSize)

#pragma mark - calcu
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
- (CGRect)stringWidthRectWithSize:(CGSize)size font:(UIFont *)font;
#pragma mark - commom
- (BOOL)isContainedChinese;
- (NSString *)md5;
- (NSString *)MD5;
- (id)parseToArrayOrNSDictionary;

- (NSDictionary *)JSONSDictionary;

- (NSDate *)dateFromStringFormat:(NSString *)format;
- (NSDate *)dateFromSecondString;
- (NSDate *)dateFromFullString;
- (NSDate *)dateFromShortString;

- (NSString *)validLength;

- (NSString *)ossDateFormat;

- (NSString *)trim;//去除两端空格
- (NSString *)trimAllSpace;//去除所有空格
- (NSString *)whiteSpceText;//每四个加一个空格
- (NSString *)nameText;
- (BOOL)isIncludeSpecialCharact;//验证字符串是否包含特殊字符

#pragma mark - httpStr
- (NSString *)jm_stringByAppendingUrlPathComponent:(NSString *)str;
@end

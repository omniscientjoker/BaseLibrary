//
//  NSString+calculateSize.m
//  EnergyManager
//
//  Created by joker on 2018/3/20.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "NSString+calculateSize.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>

#define phoneRegex  @"[0-9]{3}-[0-9]{8}|[0-9]{4}-[0-9]{7}"
#define emailRegex  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
//#define urlRegex    @"((http|ftp|https)://)?(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
#define urlRegex    @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

#define nameRegex    @"[A-Z0-9a-z]{4,10}"
#define addressRegx  @"[A-Z0-9a-z]+_[A_Z0-9a-z]"
#define imageRegx    @""
@implementation NSString (calculateSize)
#pragma mark - calcu
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    if ([self length] > 0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        expectedLabelSize = [self boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:attributes context:nil].size;
    }
    
    return expectedLabelSize;
}
- (CGRect)stringWidthRectWithSize:(CGSize)size font:(UIFont *)font{
    NSDictionary * attributes = @{NSFontAttributeName: font};
    
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
}
#pragma mark - commom
- (BOOL)isContainedChinese{
    NSUInteger length = self.length;
    for (int i=0; i<length; ++i){
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3){
            return YES;
        }
    }
    return NO;
}

- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return  [output uppercaseString];
}

-(NSString *)MD5{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return  digest;
}

- (id)parseToArrayOrNSDictionary{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        return nil;
    }
}


- (NSDictionary *)JSONSDictionary{
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (NSDate *)dateFromStringFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:format];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromSecondString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromFullString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSDate *)dateFromShortString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date= [dateFormatter dateFromString:self];
    return date;
}

- (NSString *)validLength{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)ossDateFormat{
    NSArray *aArray = [self componentsSeparatedByString:@"/"];
    return aArray[1];
}

//数据验证部分
- (NSString *)trim{
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)trimAllSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)whiteSpceText{
    NSInteger index = self.length / 4;
    if (self.length % 4 == 0) {
        index--;
    }
    NSMutableString *whiteSpceText = [self mutableCopy];
    for(int i = 1 ; i <= index ; i++){
        [whiteSpceText insertString:@" " atIndex: i * 5 - 1];
    }
    return whiteSpceText;
}

- (NSString *)nameText{
    if (self.length < 1) {
        return @"";
    }else{
        return [self stringByReplacingOccurrencesOfString:[self substringToIndex:1] withString:@"*"];
    }
}

-(BOOL)isIncludeSpecialCharact{
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound){
        return NO;
    }
    return YES;
}

#pragma mark url-str
#pragma mark - httpStr
- (NSString *)jm_stringByAppendingUrlPathComponent:(NSString *)str{
    return [[[self stringByAppendingPathComponent:str] stringByReplacingOccurrencesOfString:@"http://" withString:@"http:/"] stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
}
@end

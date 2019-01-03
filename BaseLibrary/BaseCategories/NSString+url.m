//
//  NSString+url.m
//  BasicFramework
//
//  Created by joker on 2018/11/26.
//  Copyright © 2018 joker. All rights reserved.
//

#import "NSString+url.h"

@implementation NSString (url)
#pragma mark - httpStr
- (NSString *)jm_stringByAppendingUrlPathComponent:(NSString *)str{
    return [[[self stringByAppendingPathComponent:str] stringByReplacingOccurrencesOfString:@"http://" withString:@"http:/"] stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
}

- (NSString *)jm_imageURLString{
    return [kOSSIMAGEBASEFILEURL jm_stringByAppendingUrlPathComponent:self];
}

- (NSString *)jm_increaseString{
    NSInteger num = self.integerValue;
    return [NSString stringWithFormat:@"%ld",(long)(num + 1)];
}

- (NSString *)jm_displayMoneyAndUnit{
    return [NSString stringWithFormat:@"%@元",[self jm_displayMoney]];
}

- (NSString *)jm_displayMoney{
    return [NSString stringWithFormat:@"%.2f",self.floatValue];
}
@end

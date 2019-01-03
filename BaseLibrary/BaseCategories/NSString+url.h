//
//  NSString+url.h
//  BasicFramework
//
//  Created by joker on 2018/11/26.
//  Copyright © 2018 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (url)
#pragma mark - httpStr
- (NSString *)jm_stringByAppendingUrlPathComponent:(NSString *)str;
- (NSString *)jm_imageURLString;
- (NSString *)jm_increaseString;
- (NSString *)jm_displayMoneyAndUnit;
- (NSString *)jm_displayMoney;
@end

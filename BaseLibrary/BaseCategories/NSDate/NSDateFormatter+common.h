//
//  NSDateFormatter+common.h
//  EnergyManager
//
//  Created by joker on 2018/3/21.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (common)
+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;
+ (id)defaultDateFormatter;
@end

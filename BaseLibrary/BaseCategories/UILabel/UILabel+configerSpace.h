//
//  UILabel+configerSpace.h
//  EnergyManager
//
//  Created by joker on 2018/3/29.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (configerSpace)

+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end

//
//  PickTimeList.h
//  EnergyManager
//
//  Created by joker on 2018/5/24.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickTimeListHead.h"

@class PickTimeList;
@protocol PickTimeListDelegate <NSObject>
@optional
-(void)List:(PickTimeList *)list TitlehasSelectedDate:(NSString *)date;
@end

@interface PickTimeList : UIView
@property (weak, nonatomic) id<PickTimeListDelegate> delegate;
@property (assign, nonatomic) DateType  selectedDateType;
@property (assign, nonatomic) BOOL      haveBorderLine;
@property (assign, nonatomic) BOOL      isExclusive;
@property (strong, nonatomic) UIColor  *highlightColor;
@property (strong, nonatomic) UIColor  *textshowColor;
@property (strong, nonatomic) UIFont   *textshowFont;
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)color textFont:(UIFont *)font;
- (void)reloadTitleDataWithStr:(NSString *)str;
- (void)setPickTimeViewDateType:(DateStyle)type;
- (void)ListTitleLabHasCancelTouch;
@end

@interface CALayer (ListTitleLabAnimation)
- (void)addAnimation:(CAAnimation *)anim andValue:(NSValue *)value KeyPath:(NSString *)keyPath;
@end

//
//  DatePickerView.h
//  Environment_IOS
//
//  Created by joker on 2018/8/2.
//  Copyright © 2018 JM. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "PickTimeListHead.h"

@class DatePickerView;
@protocol DatePickerViewDelegate <NSObject>
- (void)DatePickerViewCancelSelected;
@end

@interface DatePickerView : UIView
@property(nonatomic,weak)id <DatePickerViewDelegate>delegate;
@property (nonatomic,strong)UIColor *doneButtonColor;
@property (nonatomic,strong)UIColor *dateLabelColor;
@property (nonatomic,strong)UIColor *datePickerColor;
@property (nonatomic,retain)NSDate  *maxLimitDate;
@property (nonatomic,retain)NSDate  *minLimitDate;
@property (nonatomic,retain)UIColor *yearLabelColor;
@property (nonatomic,assign)BOOL     hideBackgroundYearLabel;
-(instancetype)initWithFrame:(CGRect)frame DateStyle:(DateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock;
-(instancetype)initWithFrame:(CGRect)frame DateStyle:(DateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock;
-(void)show;
-(void)dismiss;
@end

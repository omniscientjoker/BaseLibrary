//
//  DatePickerView.m
//  Environment_IOS
//
//  Created by joker on 2018/8/2.
//  Copyright © 2018 JM. All rights reserved.
//

#import "DatePickerView.h"
#import "BaseColorMacro.h"
#import "BaseUtilsMacro.h"
#import "NSDate+common.h"
#define kPickerSize self.datePicker.frame.size
#define MAXYEAR 2018
#define MINYEAR 2000

typedef void(^doneBlock)(NSDate *);
@interface DatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    NSDate *_startDate;
}
@property (nonatomic,strong)UIPickerView *datePicker;
@property (nonatomic,retain)NSDate       *scrollToDate;//滚到指定日期
@property (nonatomic,strong)doneBlock     doneBlock;
@property (nonatomic,assign)DateStyle     datePickerStyle;
@property (nonatomic,strong)UIView       *buttomView;
@property (nonatomic,strong)UILabel      *showYearView;
@property (nonatomic,strong)UIButton     *doneBtn;
@end

@implementation DatePickerView
-(instancetype)initWithFrame:(CGRect)frame DateStyle:(DateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        [self setdefultdatePickerStyle];
        [self setupUI];
        [self defaultConfig];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame DateStyle:(DateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock{
    self = [super initWithFrame:frame];
    if (self) {
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        [self setdefultdatePickerStyle];
        [self setupUI];
        [self defaultConfig];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

-(void)setdefultdatePickerStyle{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
        case DateStyleShowMonthDayHourMinute:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
        case DateStyleShowYearMonthDay:
            _dateFormatter = @"yyyy-MM-dd";
            break;
        case DateStyleShowYearMonth:
            _dateFormatter = @"yyyy-MM";
            break;
        case DateStyleShowMonthDay:
            _dateFormatter = @"yyyy-MM-dd";
            break;
        case DateStyleShowHourMinute:
            _dateFormatter = @"HH:mm";
            break;
        default:
            _dateFormatter = @"yyyy-MM-dd HH:mm";
            break;
    }
}
-(void)defaultConfig {
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    for (NSInteger i=MINYEAR; i<=MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"2000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

#pragma mark UI
-(void)setupUI {
    self.backgroundColor = PNPureClear;
    self.doneButtonColor = PNDeepOrange;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    [self addSubview:self.buttomView];
    [self.buttomView addSubview:self.showYearView];
    [self.buttomView addSubview:self.doneBtn];
    [self.showYearView addSubview:self.datePicker];
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
}

-(UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREENHEIGHT, SCREENWIDTH-20, 270)];
        _buttomView.layer.cornerRadius = 10;
        _buttomView.layer.masksToBounds = YES;
    }
    return _buttomView;
}
-(UILabel *)showYearView{
    if (!_showYearView) {
        _showYearView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH-20, 216)];
        _showYearView.backgroundColor = PNWhite;
        _showYearView.font = [UIFont systemFontOfSize:110.0f];
        _showYearView.numberOfLines = 1;
        _showYearView.textColor = PNGrey;
        _showYearView.userInteractionEnabled = YES;
        _showYearView.textAlignment = NSTextAlignmentCenter;
    }
    return _showYearView;
}
-(UIButton *)doneBtn{
    if (!_doneBtn) {
        _doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneBtn.frame = CGRectMake(0, 216, SCREENWIDTH-20, 44);
        [_doneBtn setBackgroundColor:self.doneButtonColor];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_doneBtn setTintColor:PNWhite];
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneBtn;
}
-(UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] initWithFrame:self.showYearView.bounds];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}


#pragma mark private date
-(void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    if (!_dateLabelColor) {
        _dateLabelColor =  PNDeepOrange;
    }
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+18+kPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.showYearView.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  _dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.showYearView addSubview:label];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case DateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
        case DateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
        case DateStyleShowYearMonth:
            [self addLabelWithName:@[@"年",@"月"]];
            return 2;
        case DateStyleShowMonthDay:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
        case DateStyleShowHourMinute:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
            break;
        case DateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            break;
        case DateStyleShowYearMonth:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            break;
        case DateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
            break;
        case DateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            break;
        case DateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    customLabel.text = title;
    if (!_datePickerColor) {
        _datePickerColor = [UIColor blackColor];
    }
    customLabel.textColor = _datePickerColor;
    return customLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:{
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
        case DateStyleShowYearMonthDay:{
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
        case DateStyleShowYearMonth:{
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
        }
            break;
        case DateStyleShowMonthDayHourMinute:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
        case DateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
        case DateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
        default:
            break;
    }
    [pickerView reloadAllComponents];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"] dateWithFormatter:_dateFormatter];
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    _startDate = self.scrollToDate;
}




#pragma mark - Action
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}

- (void)doneAction:(UIButton *)btn {
    _startDate = [self.scrollToDate dateWithFormatter:_dateFormatter];
    self.doneBlock(_startDate);
    [self dismiss];
}

-(void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:.3 animations:^{
        self.buttomView.frame = CGRectMake(10, SCREENHEIGHT-270, SCREENWIDTH-20, 270);
        self.backgroundColor = [PNPureClear colorWithAlphaComponent:0.4];
    }];
}

-(void)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.buttomView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 0);
        self.backgroundColor = PNPureClear;
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(DatePickerViewCancelSelected)]) {
            [self.delegate DatePickerViewCancelSelected];
        }
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}


#pragma mark TimePickerTool
-(void)yearChange:(NSInteger)row {
    monthIndex = row%12;
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    self.showYearView.text = _yearArray[yearIndex];
    preRow = row;
}

- (void)getNowDate:(NSDate *)date animated:(BOOL)animated{
    if (!date) {
        date = [NSDate date];
    }
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-MINYEAR;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    NSArray *indexArray;
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonth)
        indexArray = @[@(yearIndex),@(monthIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == DateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == DateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    self.showYearView.text = _yearArray[yearIndex];
    [self.datePicker reloadAllComponents];
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == DateStyleShowMonthDayHourMinute || self.datePickerStyle == DateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
        if (!self.tintColor) {
            
        }
        
    }
}

-(NSArray *)getNumberOfRowsInComponent {
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case DateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case DateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
        case DateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case DateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
}

#pragma mark - getter / setter
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}
-(void)setDateLabelColor:(UIColor *)dateLabelColor {
    _dateLabelColor = dateLabelColor;
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = subView;
            label.textColor = _dateLabelColor;
        }
    }
}
- (NSMutableArray *)setArray:(id)mutableArray{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}
-(void)setYearLabelColor:(UIColor *)yearLabelColor {
    self.showYearView.textColor = yearLabelColor;
}
- (void)setdayArray:(NSInteger)num{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}
-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}
-(void)setDoneButtonColor:(UIColor *)doneButtonColor {
    _doneButtonColor = doneButtonColor;
    self.doneBtn.backgroundColor = doneButtonColor;
}
-(void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    _showYearView.textColor = [UIColor clearColor];
}
@end

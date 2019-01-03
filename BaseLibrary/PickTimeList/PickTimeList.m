//
//  PickTimeList.m
//  EnergyManager
//
//  Created by joker on 2018/5/24.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "PickTimeList.h"
#import <QuartzCore/QuartzCore.h>
#import "DatePickerView.h"
#import "BaseColorMacro.h"
#import "BaseUtilsMacro.h"
#import "NSDate+common.h"


@interface PickTimeList()<DatePickerViewDelegate>{
    DateStyle  selectedDateStyle;
}
@property(nonatomic,strong) DatePickerView  *datePicker;
@end
@implementation PickTimeList{
    BOOL _isShow;
    NSMutableArray  *_indicatorsArray;
    CAShapeLayer    *_indicatorLayer;
    CATextLayer     *_textLayer;
    NSString        *_titileStr;
}
#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefult];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)color textFont:(UIFont *)font{
    self = [super initWithFrame:frame];
    if (self) {
        self.textshowFont = font;
        self.textshowColor = color;
        [self setDefult];
    }
    return self;
}
#pragma mark defult
- (void)setDefult{
    [self setPickTimeViewDateType:DateStyleShowYearMonthDay];
    _indicatorsArray = [[NSMutableArray alloc] init];
    _isShow = NO;
    _isExclusive = NO;
    _haveBorderLine = YES;
    _highlightColor = PNLightGrey;
    if (!_textshowFont) {
        _textshowFont = [UIFont systemFontOfSize:12.0f];
    }
    if (!_textshowColor) {
        _textshowColor = PNBlack;
    }
    [self setUpUI];
}
- (void)setUpUI {
    [[self layer] setBorderWidth:0.7];
    [[self layer] setBorderColor:[[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0] CGColor]];
    
    _indicatorLayer = [self createIndicatorWithColor:_textshowColor
                                         andPosition:CGPointMake(self.frame.size.width-16, self.frame.size.height/2.0)];
    [self.layer addSublayer:_indicatorLayer];
    
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    CGPoint position;
    NSDictionary *attr = @{NSFontAttributeName :self.textshowFont};
    CGSize labelSize = [@"2017-07-23" sizeWithAttributes:attr];
    position = CGPointMake(labelSize.width/2, self.frame.size.height/2.0);
    _textLayer = [self createTextLayerWithText:@"energy" color:_textshowColor withPosition:position];
    [self.layer addSublayer:_textLayer];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _indicatorLayer.fillColor = _textshowColor.CGColor;
    if (!_haveBorderLine) {
        [self.layer setBorderWidth:0.0];
    }
}

#pragma mark - Action
- (void)tapped:(UIGestureRecognizer *)gr {
    if (_isShow == NO) {
        [self.datePicker show];
        [self animateIndicator:_indicatorLayer isforward:YES withCompletion:^{
            self->_isShow = YES;
        }];
    }else{
        [self.datePicker dismiss];
        _datePicker = nil;
        [self animateIndicator:_indicatorLayer isforward:NO withCompletion:^{
            self->_isShow = NO;
        }];
    }
}
-(void)ListTitleLabHasCancelTouch{
    [self animateIndicator:_indicatorLayer isforward:NO withCompletion:^{
        self->_isShow = NO;
    }];
}
- (void)reloadTitleDataWithStr:(NSString *)str{
    _titileStr = [NSDate changeTimeFormatWithTime:str];
    [_textLayer setString:_titileStr];
    [self animateTextLayer:_textLayer isShow:YES completion:^{
    }];
}
#pragma mark - Layer Drawing
- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    return layer;
}

#pragma mark - Animation
- (void)animateIndicator:(CAShapeLayer *)ind isforward:(BOOL)isForward withCompletion:(void(^)(void))completion {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    animation.values = isForward ? @[@0, @(M_PI)] : @[@(M_PI), @0];
    if (!animation.removedOnCompletion) {
        [ind addAnimation:animation forKey:animation.keyPath];
    }
    else {
        [ind addAnimation:animation andValue:animation.values.lastObject KeyPath:animation.keyPath];
    }
    [CATransaction commit];
    completion();
}
- (void)animateTextLayer:(CATextLayer *)textLayer isShow:(BOOL)isShow completion:(void(^)(void))completion {
    CGSize size = [self p_calculateTitleSizeWithText:textLayer.string Font:_textshowFont];
    CGFloat sizeWidth = (size.width < (self.frame.size.width-10)) ? size.width : self.frame.size.width-10;
    [textLayer setBounds:CGRectMake(0, 0, sizeWidth, size.height)];
    completion();
}

#pragma mark - Private
- (CGSize)p_calculateTitleSizeWithText:(NSString *)text Font:(UIFont *)font {
    NSDictionary *dic = @{NSFontAttributeName : font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}
- (CATextLayer *)createTextLayerWithText:(NSString *)text color:(UIColor *)color withPosition:(CGPoint)point {
    CGSize size = [self p_calculateTitleSizeWithText:text Font:_textshowFont];
    CATextLayer *layer = [[CATextLayer alloc] init];
    CGFloat sizeWidth = (size.width < (self.frame.size.width - 10)) ? size.width : self.frame.size.width - 10;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = text;
    CFStringRef fontName = (__bridge CFStringRef)_textshowFont.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    layer.font = fontRef;
    layer.fontSize = _textshowFont.pointSize;
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.position = point;
    return layer;
}
-(CALayer *)creatImagelayerWithImg:(UIImage *)img Point:(CGPoint)point{
    CALayer * imageLayer = [CALayer  layer];
    imageLayer.frame = CGRectMake(15, 10, 30, 30);
    imageLayer.contents = (__bridge id)(img.CGImage);
    return imageLayer;
}

#pragma picktimeVIew
-(DatePickerView *)datePicker{
    if (!_datePicker) {
        NSDate *scrollToDate = [NSDate getTimeWithTime:_titileStr Formater:@"yyyy-MM-dd"];
        _datePicker = [[DatePickerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) DateStyle:DateStyleShowYearMonthDay scrollToDate:scrollToDate CompleteBlock:^(NSDate *selectDate) {
            [self ListTitleLabHasCancelTouch];
            [self reloadTitleDataWithStr:[NSDate getTimeWithDate:selectDate]];
            if ([self.delegate respondsToSelector:@selector(List:TitlehasSelectedDate:)]) {
                [self.delegate List:self TitlehasSelectedDate:[NSDate getTimeWithDate:selectDate]];
            }
        }];
        _datePicker.delegate       = self;
        _datePicker.maxLimitDate   = [NSDate date];
        _datePicker.dateLabelColor = COMMON_COLOR;
        _datePicker.datePickerColor = [UIColor blackColor];
        _datePicker.doneButtonColor = COMMON_COLOR;
    }
    return _datePicker;
}
-(void)DatePickerViewCancelSelected{
    [self ListTitleLabHasCancelTouch];
    _datePicker = nil;
}
- (void)setPickTimeViewDateType:(DateStyle)type{
    selectedDateStyle = type;
}
@end

#pragma mark - CALayer Category
@implementation CALayer (ListTitleLabAnimation)
- (void)addAnimation:(CAAnimation *)animation andValue:(NSValue *)value KeyPath:(NSString *)keyPath {
    [self addAnimation:animation forKey:keyPath];
    [self setValue:value forKeyPath:keyPath];
}
@end

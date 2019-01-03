//
//  GuideVIew.m
//  EnergyManager
//
//  Created by joker on 2018/12/3.
//  Copyright © 2018 JM. All rights reserved.
//

#import "GuideView.h"
#import "GuideButton.h"
#import "BaseUtilsMacro.h"

@interface GuideView ()
@property(nonatomic,assign)BOOL               isRoute;
@property(nonatomic,strong)GuideModel       * model;
@property(nonatomic,strong)UIImage          * image;
@property(nonatomic,strong)UIImageView      * imageView;
@property(nonatomic,strong)GuideButton      * guideButton;
@property(nonatomic,strong)UIButton         * skipButton;
@property(nonatomic,strong)dispatch_source_t  timer;
@end

@implementation GuideView
-(instancetype)initWithModel:(GuideModel *)data Image:(UIImage *)image{
    self = [super init];
    if (self) {
        self.model = data;
        self.image = image;
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addSubview:self.imageView];
    [self addSubview:self.guideButton];
    [self setGuideTime:5.0f];
    [self addSubview:self.skipButton];
    [self.guideButton startAnimationDuration:5.0f];
}

#pragma mark ui init
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView)];
        [_imageView addGestureRecognizer:ImageTap];
    }
    return _imageView;
}
-(GuideButton *)guideButton{
    if (!_guideButton) {
        _guideButton = [[GuideButton alloc]initWithFrame:CGRectMake(self.bounds.size.width- 60, 30, 30, 30)];
        _guideButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_guideButton addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_guideButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        JMWeakSelfDefine;
        _guideButton.Block = ^{
            [weakSelf dismiss];
        };
    }
    return _guideButton;
}
-(UIButton *)skipButton{
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _skipButton.frame = CGRectMake(SCREENWIDTH-90, SCREENHEIGHT-140, 60, 30);
        _skipButton.layer.cornerRadius = 4.0f;
        _skipButton.layer.borderWidth  = 1.4f;
        _skipButton.layer.borderColor  = [UIColor whiteColor].CGColor;
        [_skipButton setTintColor:[UIColor whiteColor]];
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        _skipButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_skipButton addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
-(void)setGuideTime:(CGFloat)time{
    __block NSInteger timeOut = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut <= 0) {
            dispatch_source_cancel(self->_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        } else {
            int allTime = (int)time + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%ds", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.guideButton setTitle:timeStr forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

//program mark btn
-(void)ButtonClick{
    [self dismiss];
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
}
- (void)tapImageView{
    [self dismiss];
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    if (self.model.clickType == GuideClick_Web) {
        self.returnValueBlock(GuideClick_Web,nil,self.model.clickUrl);
    }else{
        self.returnValueBlock(self.model.clickType,self.model.routeParameters,nil);
    }
}
-(void)dismiss{
    self.guideButton.hidden = YES;
    self.skipButton.hidden  = YES;
    self.transform = CGAffineTransformMakeScale(1, 1);
    self.imageView.alpha = 1;
    [UIView animateWithDuration:0.7 animations:^{
        self.imageView.alpha = 0.05;
        self.imageView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end

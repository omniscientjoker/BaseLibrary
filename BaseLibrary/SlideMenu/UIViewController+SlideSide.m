//
//  UIViewController+SlideSide.m
//  BasicFramework
//
//  Created by joker on 2018/11/22.
//  Copyright © 2018 joker. All rights reserved.
//

#import "UIViewController+SlideSide.h"
#import<objc/runtime.h>
@implementation UIViewController (SlideSide)
-(void)initSlideWithDirection:(SlideDirection)direction{
    self.direction = direction;
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.216 alpha:0.50];
    self.maskView.alpha = 0;
    self.maskView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    CGRect frame = self.view.frame;
    frame.origin.x = self.direction == SlideFromLeft ? -CGRectGetWidth(self.view.frame) : CGRectGetWidth([UIScreen mainScreen].bounds);
    self.view.frame = frame;
    [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    
    //手势
    UIPanGestureRecognizer *pan_mask = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    [self.maskView addGestureRecognizer:pan_mask];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanEvent:)];
    [self.view addGestureRecognizer:pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.maskView addGestureRecognizer:tap];
}

#pragma mark -- set & get Property
-(BOOL)isOpen{
    return  [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setIsOpen:(BOOL)isOpen{
    objc_setAssociatedObject(self, @selector(isOpen), @(isOpen), OBJC_ASSOCIATION_ASSIGN);
}

-(SlideDirection)direction{
    return  [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setDirection:(SlideDirection)direction{
    objc_setAssociatedObject(self,  @selector(direction), @(direction), OBJC_ASSOCIATION_ASSIGN);
}

-(SlideDirection)currentPanDirection{
    return  [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setCurrentPanDirection:(SlideDirection)currentPanDirection{
    objc_setAssociatedObject(self,  @selector(currentPanDirection), @(currentPanDirection), OBJC_ASSOCIATION_ASSIGN);
}

-(UIView *)maskView{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setMaskView:(UIView *)maskView{
    objc_setAssociatedObject(self, @selector(maskView), maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark -- 拖动隐藏
-(void)didPanEvent:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:self.view];
    if(translation.x != 0){
        self.currentPanDirection = translation.x > 0 ? SlideFromRight : SlideFromLeft;
    }
    
    [recognizer setTranslation:CGPointZero inView:self.view];
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (self.direction == SlideFromLeft) {
                if (translation.x >= 0 ){
                    CGFloat tempX = CGRectGetMinX(self.view.frame) + translation.x;
                    if (tempX<0) {
                        
                        self.view.frame = CGRectMake(tempX, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                    }
                }else{
                    CGFloat tempX = CGRectGetMinX(self.view.frame) + translation.x;
                    self.view.frame = CGRectMake(tempX, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                }
            }else{
                if (translation.x >= 0 ){
                    CGFloat tempX = CGRectGetMinX(self.view.frame) + translation.x;
                    self.view.frame = CGRectMake(tempX, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                }else{
                    CGFloat tempX = CGRectGetMinX(self.view.frame) + translation.x;
                    if(tempX > (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(self.view.frame))){
                        self.view.frame = CGRectMake(tempX, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
                    }
                }
            }
            
            break;
        }
        case UIGestureRecognizerStateEnded:{
            if(self.direction == SlideFromLeft && self.currentPanDirection == SlideFromRight){
                [self show];
            }else if(self.direction == SlideFromRight && self.currentPanDirection == SlideFromLeft){
                [self show];
            }else{
                [self hide];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        default:
            break;
    }
}

#pragma mark  hide & show
- (void)hide{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
        self.view.frame = CGRectOffset(self.view.frame, self.direction == SlideFromLeft ? -CGRectGetWidth(self.view.frame) : CGRectGetWidth(self.view.frame), 0) ;
        self.maskView.alpha = 0;
    }completion:^(BOOL finished) {
        self.isOpen = NO;
        self.maskView.hidden = YES;
        [self.view removeFromSuperview];
    }];
}

- (void)show{
    self.maskView.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
        self.view.frame = CGRectMake(self.direction == SlideFromLeft ? 0 : CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.maskView.alpha = 0.5;
    } completion:^(BOOL finished) {
        self.isOpen = YES;
    }];
}
@end

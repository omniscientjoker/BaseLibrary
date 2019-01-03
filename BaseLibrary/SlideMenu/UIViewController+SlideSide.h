//
//  UIViewController+SlideSide.h
//  BasicFramework
//
//  Created by joker on 2018/11/22.
//  Copyright © 2018 joker. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SlideDirection) {
    SlideFromLeft,
    SlideFromRight
};

@interface UIViewController (SlideSide)<UIGestureRecognizerDelegate>
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,assign) SlideDirection direction;
@property(nonatomic, assign) SlideDirection currentPanDirection;
-(void)show;
-(void)hide;
-(void)initSlideWithDirection:(SlideDirection)direction;
@end

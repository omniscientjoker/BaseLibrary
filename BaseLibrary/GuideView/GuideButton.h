//
//  GuideButton.h
//  EnergyManager
//
//  Created by joker on 2018/12/4.
//  Copyright © 2018 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GuideButton : UIButton
@property (nonatomic ,strong) UIColor   *trackColor;
@property (nonatomic ,strong) UIColor   *processColor;
@property (nonatomic ,strong) UIColor   *fillColor;
@property (nonatomic ,assign) CGFloat   lineWidth;
@property (nonatomic ,assign) CGFloat   animationtime;
@property (nonatomic ,copy) void(^Block)(void);
-(instancetype)initWithFrame:(CGRect)frame;
- (void)startAnimationDuration:(CGFloat)duration;
@end

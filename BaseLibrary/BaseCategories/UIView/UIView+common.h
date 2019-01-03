//
//  UIView+common.h
//  EnergyManager
//
//  Created by joker on 2018/3/22.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (common)
@property(nonatomic,readwrite) CGFloat x,y;
@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat bottom;

@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;

@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

@property (nonatomic,assign)CGFloat centerx;
@property (nonatomic,assign)CGFloat centery;

@property(nonatomic,readonly) CGFloat screenViewX;
@property(nonatomic,readonly) CGFloat screenViewY;
@property(nonatomic,readonly) CGRect screenFrame;

@property(nonatomic) CGPoint origin;
@property(nonatomic) CGSize size;
-(UIViewController *)viewController;
-(void)removeAllSubviews;
-(void)removeAllGestureRecognizer;

-(void)rounded:(CGFloat)cornerRadius;

/**  设置圆角和边框  */
-(void)rounded:(CGFloat)cornerRadius width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**  设置边框  */
-(void)border:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**   给哪几个角设置圆角  */
-(void)round:(CGFloat)cornerRadius RectCorners:(UIRectCorner)rectCorner;

/**  设置阴影  */
-(void)setShadow:(UIColor *)color;
-(void)shadow:(UIColor *)shadowColor opacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;


-(void)setBorderCornerRadius:(CGFloat)cornerRadius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

+ (CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font;
@end

@interface UIView(ViewHiarachy)
@property (nonatomic,readonly)UIViewController *viewController;
- (void)removeAllSubviews;
@end

@interface UIView (gesture)
- (void)addTapAction:(SEL)tapAction target:(id)target;
@end

@interface UIView (sepLine)
+(UIView*) sepLineWithRect:(CGRect)rect;
+(UIView*) twoLayerSepLineWithRect:(CGRect)rect;
@end

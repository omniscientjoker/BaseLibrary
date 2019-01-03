//
//  GesturesTentacle.m
//  Environment_IOS
//
//  Created by joker on 2018/9/5.
//  Copyright © 2018 JM. All rights reserved.
//

#import "GesturesTentacle.h"
#import "BaseColorMacro.h"
#import "BaseUtilsMacro.h"
#define cols 3 //总列数
#define linColor 0xffc8ad //线条颜色
#define linWidth 8 //线条宽度
@interface GesturesTentacle ()
@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, assign) CGPoint         currentPoint;
@end

@implementation GesturesTentacle
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSUInteger count = self.subviews.count;
    CGFloat x = 0,y = 0,w = 0,h = 0;
    if (SCREENWIDTH == 320) {
        w = 50;
        h = 50;
    }else {
        w = 58;
        h = 58;
    }
    
    CGFloat margin = (self.bounds.size.width - cols * w) / (cols + 1);//间距
    CGFloat col = 0;
    CGFloat row = 0;
    for (int i = 0; i < count; i++) {
        col = i%cols;
        row = i/cols;
        x = margin + (w+margin)*col;
        y = margin + (w+margin)*row;
        if (SCREENHEIGHT == 480) {
            y = (w+margin)*row;
        }else {
            y = margin +(w+margin)*row;
        }
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.selectedBtns.count == 0) return;
    UIBezierPath *path = [UIBezierPath bezierPath];
    NSUInteger count = self.selectedBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.selectedBtns[i];
        if (i == 0) {
            [path moveToPoint:btn.center];
        }else {
            [path addLineToPoint:btn.center];
        }
    }
    [path addLineToPoint:_currentPoint ];
    [UIColorFromRGB(linColor) set];
    path.lineJoinStyle = kCGLineJoinRound;
    path.lineWidth = linWidth;
    [path stroke];
}

#pragma mark - private
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.selectedBtns = [NSMutableArray array];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateSelected];
        btn.tag = 1000+i;
        [self addSubview:btn];
    }
}

#pragma mark - action pan
- (void)pan:(UIPanGestureRecognizer *)pan {
    _currentPoint = [pan locationInView:self];
    [self setNeedsDisplay];
    for (UIButton *button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES;
            [self.selectedBtns addObject:button];
        }
    }
    [self layoutIfNeeded];
    if (pan.state == UIGestureRecognizerStateEnded) {
        NSMutableString *gesturePwd = [NSMutableString string];
        for (UIButton *button in self.selectedBtns) {
            [gesturePwd appendFormat:@"%ld",button.tag-1000];
            button.selected = NO;
        }
        [self.selectedBtns removeAllObjects];
        !self.drawRectFinishedBlock?:self.drawRectFinishedBlock(gesturePwd);
    }
}
@end

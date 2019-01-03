//
//  GesturesPreviewView.m
//  Environment_IOS
//
//  Created by joker on 2018/9/5.
//  Copyright © 2018 JM. All rights reserved.
//

#import "GesturesPreviewView.h"
#define BTN_H 9
#define BTN_W 9
#define gesture_normal   @"gesture_indicator_normal"
#define gesture_selected @"gesture_indicator_selected"
@interface GesturesPreviewView()
@property (nonatomic, strong) NSMutableArray *buttons;
@end

@implementation GesturesPreviewView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
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
    int cols = 3;
    CGFloat x = 0,y = 0;
    CGFloat margin = (self.bounds.size.width - cols * BTN_W) / (cols + 1);
    CGFloat col = 0;
    CGFloat row = 0;
    for (int i = 0; i < count; i++) {
        col = i%cols;
        row = i/cols;
        x = margin + (BTN_W+margin)*col;
        y = margin + (BTN_W+margin)*row;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, BTN_W, BTN_H);
    }
}

- (void)setup{
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:gesture_normal] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:gesture_selected] forState:UIControlStateSelected];
        [self addSubview:btn];
        [self.buttons addObject:btn];
    }
}

- (void)setGesturesPassword:(NSString *)gesturesPassword{
    for (UIButton *button in self.buttons) {
        button.selected = NO;
    }
    for (int i = 0; i < gesturesPassword.length; i++) {
        NSInteger index = [gesturesPassword substringWithRange:NSMakeRange(i, 1)].integerValue;
        [self.buttons[index] setSelected:YES];
    }
}

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons ;
}
@end

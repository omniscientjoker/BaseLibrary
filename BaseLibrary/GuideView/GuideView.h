//
//  GuideVIew.h
//  EnergyManager
//
//  Created by joker on 2018/12/3.
//  Copyright © 2018 JM. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GuideModel.h"
typedef void(^ClickButton)(GuideClickType type,NSDictionary *parameters,NSString *url);
@interface GuideView : UIView
@property(nonatomic,assign)BOOL  iscanClick;
@property(nonatomic, copy) ClickButton returnValueBlock;
-(instancetype)initWithModel:(GuideModel *)data Image:(UIImage *)image;
@end

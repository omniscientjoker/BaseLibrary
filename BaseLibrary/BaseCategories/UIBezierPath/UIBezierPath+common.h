//
//  UIBezierPath+common.h
//  Environment_IOS
//
//  Created by joker on 2018/7/30.
//  Copyright © 2018 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (common)
- (UIBezierPath *)smoothedPathWithGranularity:(NSInteger)granularity;
@end

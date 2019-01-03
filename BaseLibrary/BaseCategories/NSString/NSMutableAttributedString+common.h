//
//  NSMutableAttributedString+common.h
//  EnergyManager
//
//  Created by joker on 2018/4/10.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (common)
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;
- (CGSize)getStringRectwidth:(CGFloat)width height:(CGFloat)height;
- (NSMutableAttributedString *)convertAttributeUrl;
- (NSArray *)regexWithUrl;
@end

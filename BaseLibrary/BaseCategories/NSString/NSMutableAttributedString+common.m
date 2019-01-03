//
//  NSMutableAttributedString+common.m
//  EnergyManager
//
//  Created by joker on 2018/4/10.
//  Copyright © 2018年 JM. All rights reserved.
//

#import "NSMutableAttributedString+common.h"
#import <Foundation/Foundation.h>
#define replaceRegex  @"[0-9]{3}-[0-9]{8}|[0-9]{4}-[0-9]{7}|[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}|((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"

@implementation NSMutableAttributedString (common)
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine;
    CGRect rect = [self boundingRectWithSize:size options:options context:nil];
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self regexWithChinese]) {
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    return CGSizeMake(size.width ,rect.size.height+20);
}

- (CGSize)getStringRectwidth:(CGFloat)width height:(CGFloat)height{
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSRange range = NSMakeRange(0, atrString.length);
    NSDictionary* dic = [atrString attributesAtIndex:0 effectiveRange:&range];
    NSMutableParagraphStyle *paragraphStyle = dic[NSParagraphStyleAttributeName];
    if (!paragraphStyle || nil == paragraphStyle) {
        paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 0.0;
        paragraphStyle.headIndent = 0;
        paragraphStyle.tailIndent = 0;
        paragraphStyle.lineHeightMultiple = 0;
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.paragraphSpacing = 0;
        paragraphStyle.paragraphSpacingBefore = 0;
        [atrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    }
    
    UIFont *font = dic[NSFontAttributeName];
    if (!font || nil == font) {
        font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
        [atrString addAttribute:NSFontAttributeName value:font range:range];
    }

    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [attDic setObject:font forKey:NSFontAttributeName];
    [attDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    CGSize strSize = [[self string] boundingRectWithSize:CGSizeMake(width, height)
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:attDic
                                                    context:nil].size;
    return CGSizeMake(strSize.width, strSize.height);
}

-(BOOL)regexWithChinese{
    NSString * regexstr = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:regexstr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regularEx matchesInString:self.string options:0 range:NSMakeRange(0, [self length])];
    if (matches.count>0) {
        return YES;
    }
    return NO;
}

-(NSMutableAttributedString *)convertAttributeUrl{
    NSArray * array = [self regexWithUrl];
    for (NSTextCheckingResult *match in array) {
        NSRange range = [match rangeAtIndex:0];
        [self addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
        NSURL  *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",[self.string substringWithRange:range]]];
        [self addAttribute:NSLinkAttributeName
                     value:url
                     range:range];
    }
    return self;
}

-(NSArray *)regexWithUrl{
    NSString * regexstr = replaceRegex;
    NSRegularExpression *regularEx = [NSRegularExpression regularExpressionWithPattern:regexstr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * matches = [regularEx matchesInString:self.string options:0 range:NSMakeRange(0, [self length])];
    return matches;
}
@end

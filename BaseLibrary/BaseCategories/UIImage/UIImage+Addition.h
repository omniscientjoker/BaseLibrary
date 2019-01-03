//
//  UIImage+Addition.h
//  EnergyManager
//
//  Created by joker on 2018/4/9.
//  Copyright © 2018年 JM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
//获取图片
+ (UIImage *)imageName:(NSString *)name;
//生成纯色图片
+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
//图片缩放
- (UIImage *)imageByScalingToSize:(CGSize)targetSize fitScale:(BOOL)fitScal;
//修改图片大小
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

//压缩图片
+ (NSData *)compressToSize:(long)targetSize image:(UIImage *)image;
+ (NSData *)compressToSize:(long)targetSize sourceSize:(long)sourceSize image:(UIImage *)image;

//获取页面截图
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIImage *)imageFromView:(UIView *)view inset:(UIEdgeInsets)inset;

//蒙层
- (UIImage *)imgWithBlur;
- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;
- (UIImage *)imgBluredWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;
@end

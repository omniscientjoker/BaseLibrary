//
//  GuideModel.h
//  EnergyManager
//
//  Created by joker on 2018/12/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,GuideClickType) {
    GuideClick_Web    = 0,
    GuideClick_List   = 1,
    GuideClick_Detail = 2
};

@interface GuideModel : NSObject
@property(nonatomic,assign)BOOL           isCanClick;
@property(nonatomic,assign)GuideClickType clickType;
@property(nonatomic,strong)NSString      *guideImageAddress;
@property(nonatomic,strong)NSString      *clickRoute;
@property(nonatomic,strong)NSString      *clickUrl;
@property(nonatomic,strong)NSDictionary  *routeParameters;
-(void)convertModelFromDic:(NSDictionary *)dic;
@end

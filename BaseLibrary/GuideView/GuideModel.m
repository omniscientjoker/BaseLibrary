//
//  GuideModel.m
//  EnergyManager
//
//  Created by joker on 2018/12/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import "GuideModel.h"
@implementation GuideModel
-(void)convertModelFromDic:(NSDictionary *)dic{
    self.isCanClick = [dic objectForKey:@"isCanClick"];
    if (self.isCanClick) {
        int num = [[dic objectForKey:@"clickType"] intValue];
        switch (num) {
            case 0:
                self.clickType = GuideClick_Web;
                self.clickUrl  = [dic objectForKey:@"url"];
                break;
            case 1:
                self.clickType = GuideClick_Detail;
                self.clickRoute = [dic objectForKey:@"route"];
                self.routeParameters  = [dic objectForKey:@"routeParameters"];
                break;
            case 2:
                self.clickType = GuideClick_List;
                self.clickRoute = [dic objectForKey:@"route"];
                self.routeParameters  = [dic objectForKey:@"routeParameters"];
                break;
            default:
                break;
        }
    }
    self.guideImageAddress = [dic objectForKey:@"guideImageAddress"];
}
@end

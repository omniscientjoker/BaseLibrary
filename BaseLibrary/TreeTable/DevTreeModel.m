//
//  DevTreeModel.m
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import "DevTreeModel.h"
@implementation DevTreeModel
+ (DevTreeModel *)getAllChildItemsWithDic:(NSDictionary *)dic{
    DevTreeModel * model = [self convertModelFromDic:dic itemLevel:0];
    [self addItem:dic toChildItems:model.childItems itemLevel:model.level+1];
    return model;
}
+ (void)addItem:(NSDictionary *)item toChildItems:(NSMutableArray *)childItems itemLevel:(NSInteger)level{
    NSArray  * dicArr = [item objectForKey:@"children"];
    for (NSDictionary *childItem in dicArr) {
        DevTreeModel * model = [self convertModelFromDic:childItem itemLevel:level];
        [childItems addObject:model];
        NSArray * childrendicArr = [childItem objectForKey:@"children"];
        if (childrendicArr.count>0) {
            [self addItem:childItem toChildItems:model.childItems itemLevel:model.level+1];
        }
    }
}
+(DevTreeModel *)convertModelFromDic:(NSDictionary *)dic itemLevel:(NSInteger)level{
    DevTreeModel * model = [[DevTreeModel alloc] init];
    model.name = [dic objectForKey:@"text"];
    if ([[dic objectForKey:@"EXPAND_TYPE"] intValue] == 1) {
        model.isCanCheck = NO;
    }else{
        model.isCanCheck = YES;
    }
    model.isExpand   = YES;
    model.level      = level;
    model.checkState = DevTreeItemDefault;
    model.uid        = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"tdata"] intValue]];
    model.parentId   = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"tfatherdata"] intValue]];
    model.type       = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sub_data_type"]];
    model.childItems = [[NSMutableArray alloc] init];
    return model;
}
@end

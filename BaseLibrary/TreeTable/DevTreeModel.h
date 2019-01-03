//
//  DevTreeModel.h
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, DevTreeItemCheckState) {
    DevTreeItemDefault,
    DevTreeItemChecked
};
@interface DevTreeModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isCanCheck;
@property (nonatomic, assign) BOOL isExpand;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) DevTreeItemCheckState  checkState;
@property (nonatomic, strong) NSMutableArray<DevTreeModel *> *childItems;
+ (DevTreeModel *)getAllChildItemsWithDic:(NSDictionary *)dic;
@end

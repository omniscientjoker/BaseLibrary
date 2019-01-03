//
//  DevTreeManager.h
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DevTreeModel;
@interface DevTreeManager : NSObject
@property (nonatomic, strong) NSMutableArray<DevTreeModel *> *showItems;
- (instancetype)initWithItems:(DevTreeModel *)items;
- (void)changeCheckStateWithModel:(DevTreeModel *)model isCheck:(BOOL)isCheck;
- (void)checkItem:(DevTreeModel *)item;
- (NSInteger)expandItem:(DevTreeModel *)item;
- (NSInteger)expandItem:(DevTreeModel *)item isExpand:(BOOL)isExpand;
- (NSArray *)getAllChildItemsWithItem:(DevTreeModel *)item;
@end

//
//  DevTreeManager.m
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import "DevTreeManager.h"
#import "DevTreeModel.h"
@interface DevTreeManager ()
@property (nonatomic, strong) NSMutableArray <DevTreeModel *>*topItems;
@end

@implementation DevTreeManager

- (instancetype)initWithItems:(DevTreeModel *)items{
    self = [super init];
    if (self) {
        self.topItems = [NSMutableArray arrayWithObject:items];
        self.showItems = [[NSMutableArray alloc] init];
        for (DevTreeModel *item in self.topItems) {
            [self addItem:item toShowItems:self.showItems];
        }
    }
    return self;
}

#pragma mark - check Item
- (void)changeCheckStateWithModel:(DevTreeModel *)model isCheck:(BOOL)isCheck{
    if (isCheck) {
        model.checkState = DevTreeItemChecked;
    }else{
        model.checkState = DevTreeItemDefault;
    }
}
- (void)checkItem:(DevTreeModel *)item{
    [self checkItem:item isCheck:!(item.checkState == DevTreeItemChecked)];
}

- (void)checkItem:(DevTreeModel *)item isCheck:(BOOL)isCheck{
    if (item.checkState == DevTreeItemChecked && isCheck) return;
    if (item.checkState == DevTreeItemDefault && !isCheck) return;
}

#pragma mark - Expand Item
- (NSInteger)expandItem:(DevTreeModel *)item {
    return [self expandItem:item isExpand:!item.isExpand];
}

- (NSInteger)expandItem:(DevTreeModel *)item isExpand:(BOOL)isExpand {
    NSMutableArray *tmpArray = [NSMutableArray array];
    if (isExpand) {
        for (DevTreeModel *tmpItem in item.childItems) {
            [tmpArray addObject:tmpItem];
        }
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.showItems indexOfObject:item] + 1, tmpArray.count)];
        [self.showItems insertObjects:tmpArray atIndexes:indexSet];
        item.isExpand = isExpand;
    }else {
        NSArray * arr = [self getAllChildItemsWithItem:item];
        [tmpArray addObjectsFromArray:arr];
        [self.showItems removeObjectsInArray:tmpArray];
    }
    return tmpArray.count;
}

#pragma mark - Other
- (void)addItem:(DevTreeModel *)item toShowItems:(NSMutableArray *)showItems {
    [showItems addObject:item];
    for (DevTreeModel *childItem in item.childItems) {
        [self addItem:childItem toShowItems:showItems];
        
    }
}
- (NSArray *)getAllExpandChildItemWithItem:(DevTreeModel *)item{
    NSMutableArray *childItems = [NSMutableArray array];
    [self addItem:item toChildItems:childItems];
    return childItems;
}
- (NSArray *)getAllChildItemsWithItem:(DevTreeModel *)item {
    NSMutableArray *childItems = [NSMutableArray array];
    if (item.isExpand == YES) {
        [self addItem:item toChildItems:childItems];
    }
    return childItems;
}
- (void)addItem:(DevTreeModel *)item toChildItems:(NSMutableArray *)childItems {
    for (DevTreeModel *childItem in item.childItems) {
        [childItems addObject:childItem];
        if (childItem.isExpand == YES) {
            [self addItem:childItem toChildItems:childItems];
        }
    }
    item.isExpand = NO;
}
@end

//
//  DevTreeView.m
//  Environment_IOS
//
//  Created by joker on 2018/8/2.
//  Copyright © 2018 JM. All rights reserved.
//

#import "DevTreeView.h"
#import "BaseColorMacro.h"
#import "BaseUtilsMacro.h"
#import "UIView+common.h"
#import "DevTreeModel.h"
#import "DevTreeManager.h"
#import "DevTreeTableCell.h"
@interface DevTreeView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)DevTreeManager  *manager;
@property(nonatomic, strong)UITableView     *tableView;
@property(nonatomic, strong)DevTreeModel    *treeModel;
@property(nonatomic, strong)DevTreeModel    *lastSelectedModel;
@end
@implementation DevTreeView
-(instancetype)initWithFrame:(CGRect)frame Model:(DevTreeModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        self.treeModel = model;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapGesture];
    [self setDefultData];
}

-(void)setDefultData{
    if (!self.levelColorArray) {
        self.levelColorArray = [NSArray arrayWithObjects:PNWhite,PNGrey,PNWhite,PNGrey,PNWhite, nil];
    }
    self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
}

#pragma showView&dissmissView
-(void)showView{
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:CGRectMake(40, 120, self.width-80, self.height-240)];
        self.backgroundColor = [PNDeepGrey colorWithAlphaComponent:0.6];
    } completion:nil];
}

-(void)dissmissView{
    [UIView animateWithDuration:0.3 animations:^{
        [self.tableView setFrame:CGRectMake(self.width/2, self.height/2, 0, 0)];
        self.backgroundColor = [PNGrey colorWithAlphaComponent:0];
    } completion:^(BOOL finished){
        if (finished) {
            [self.tableView removeFromSuperview];
            [self removeFromSuperview];
        }
    }];
}

#pragma mark manager
-(DevTreeManager *)manager{
    if (!_manager) {
        _manager = [[DevTreeManager alloc] initWithItems:self.treeModel];
    }
    return _manager;
}

#pragma mark backView
- (void)tapped:(UIGestureRecognizer *)gr {
    [self dissmissView];
}
#pragma mark init
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.width/2, self.height/2, 0, 0) style:UITableViewStylePlain];
        _tableView.contentSize = [self.tableView sizeThatFits:CGSizeMake(CGRectGetWidth(self.tableView.bounds), CGFLOAT_MAX)];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        _tableView.estimatedRowHeight = 52;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorColor = [UIColor blackColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView setBackgroundColor:PNGrey];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.manager.showItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DevTreeModel *item = self.manager.showItems[indexPath.row];
    DevTreeTableCell *cell = [DevTreeTableCell cellWithTableView:tableView andTreeItem:item];
    if ((item.level < self.levelColorArray.count)) {
        cell.backgroundColor = self.levelColorArray[item.level];
    } else {
        cell.backgroundColor = self.normalBackgroundColor;
    }
    JMWeakSelfDefine;
    cell.checkButtonClickBlock = ^(DevTreeModel *item, BOOL checkde) {
        if (!IsNilOrNull(weakSelf.lastSelectedModel)) {
            [weakSelf.manager changeCheckStateWithModel:weakSelf.lastSelectedModel isCheck:NO];
        }
        if (checkde == YES) {
            if ([weakSelf.classDelegate respondsToSelector:@selector(tableView:checkItem:)]) {
                [weakSelf.classDelegate tableView:weakSelf.tableView checkItem:item];
            }
            weakSelf.lastSelectedModel = item;
            [weakSelf.manager changeCheckStateWithModel:item isCheck:YES];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DevTreeModel *item = self.manager.showItems[indexPath.row];
    [self tableView:tableView didSelectItem:item isExpand:!item.isExpand];
}

- (void)tableView:(UITableView *)tableView didSelectItem:(DevTreeModel *)item isExpand:(BOOL)isExpand {
    NSMutableArray *updateIndexPaths = [NSMutableArray array];
    NSMutableArray *editIndexPaths   = [NSMutableArray array];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.manager.showItems indexOfObject:item] inSection:0];
    [updateIndexPaths addObject:indexPath];
    
    NSInteger updateNum = [self.manager expandItem:item];
    NSArray *tmp = [self getUpdateIndexPathsWithCurrentIndexPath:indexPath andUpdateNum:updateNum];
    [editIndexPaths addObjectsFromArray:tmp];
    if (isExpand) {
        [tableView insertRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:editIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    for (NSIndexPath *indexPath in updateIndexPaths) {
        DevTreeTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell updateItem];
    }
}

- (NSArray <NSIndexPath *>*)getUpdateIndexPathsWithCurrentIndexPath:(NSIndexPath *)indexPath andUpdateNum:(NSInteger)updateNum {
    NSMutableArray *tmpIndexPaths = [NSMutableArray arrayWithCapacity:updateNum];
    for (int i = 0; i < updateNum; i++) {
        NSIndexPath *tmp = [NSIndexPath indexPathForRow:(indexPath.row + 1 + i) inSection:indexPath.section];
        [tmpIndexPaths addObject:tmp];
    }
    return tmpIndexPaths;
}

@end

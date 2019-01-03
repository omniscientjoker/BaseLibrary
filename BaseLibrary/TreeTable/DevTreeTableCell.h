//
//  DevTreeTableCell.h
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DevTreeTableCell;
@class DevTreeModel;
@interface DevTreeTableCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView andTreeItem:(DevTreeModel *)item;
- (void)updateItem;
@property (nonatomic, copy)   void (^checkButtonClickBlock)(DevTreeModel *item, BOOL checked);
@end

//
//  DevTreeView.h
//  Environment_IOS
//
//  Created by joker on 2018/8/2.
//  Copyright © 2018 JM. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DevTreeModel;
@protocol DevTreeViewClassDelegate <NSObject>
- (void)tableView:(UITableView *)tableView checkItem:(DevTreeModel *)items;
@end

@interface DevTreeView : UIView
@property (nonatomic, weak)   id<DevTreeViewClassDelegate> classDelegate;
@property (nonatomic, strong) DevTreeModel       *checkModel;
@property (nonatomic, strong) NSArray <UIColor *>*levelColorArray;
@property (nonatomic, strong) UIColor *normalBackgroundColor;
-(instancetype)initWithFrame:(CGRect)frame Model:(DevTreeModel *)model;
-(void)showView;
-(void)dissmissView;
@end

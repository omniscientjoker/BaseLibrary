//
//  DevTreeTableCell.m
//  Environment_IOS
//
//  Created by joker on 2018/8/1.
//  Copyright © 2018 JM. All rights reserved.
//

#import "DevTreeTableCell.h"
#import "DevTreeModel.h"
#import "BaseUtilsMacro.h"

@interface DevTreeTableCell ()
@property (nonatomic, strong) DevTreeModel *treeItem;
@property (nonatomic, strong) UIButton     *checkButton;
@property (nonatomic, assign)  BOOL         hasChildren;
@end

@implementation DevTreeTableCell
#pragma mark - Init

+ (instancetype)cellWithTableView:(UITableView *)tableView andTreeItem:(DevTreeModel *)item {
    static NSString *ID = @"DevTreeTableViewCell";
    DevTreeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DevTreeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.treeItem = item;
    if (IsNilOrNull(cell.treeItem.childItems) || cell.treeItem.childItems.count == 0) {
        cell.hasChildren = NO;
    }else{
        cell.hasChildren = YES;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font   = [UIFont systemFontOfSize:14];
        self.indentationWidth = 15;
        self.selectionStyle   = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat minX = 15 + self.indentationLevel * self.indentationWidth;
    if (self.hasChildren) {
        CGRect imageViewFrame = self.imageView.frame;
        imageViewFrame.origin.x = minX;
        self.imageView.frame = imageViewFrame;
        if (self.imageView.image == nil) {
            self.imageView.image  = [UIImage imageNamed:@"arrow"];
            [self refreshArrow];
        }
    }else{
        self.imageView.image = nil;
    }
    CGRect textLabelFrame = self.textLabel.frame;
    if (self.hasChildren) {
        textLabelFrame.origin.x = minX + self.imageView.bounds.size.width + 2;
    }else{
        textLabelFrame.origin.x = minX ;
    }
    self.textLabel.frame = textLabelFrame;
}


#pragma mark - Setter
- (void)setTreeItem:(DevTreeModel *)treeItem {
    _treeItem = treeItem;
    if (IsNilOrNull(_treeItem.childItems) || _treeItem.childItems.count == 0) {
        self.hasChildren = NO;
    }else{
        self.hasChildren = YES;
    }
    self.indentationLevel = treeItem.level;
    self.textLabel.text   = treeItem.name;
    
    if (treeItem.isCanCheck) {
        self.accessoryView = self.checkButton;
        if (treeItem.checkState == DevTreeItemChecked) {
            [self.checkButton setSelected:YES];
        }else{
            [self.checkButton setSelected:NO];
        }
    }else{
        self.accessoryView = nil;
    }
    if (self.hasChildren) {
        self.imageView.image  = [UIImage imageNamed:@"arrow"];
        [self refreshArrow];
    }else{
        self.imageView.image  = nil;
    }
}



#pragma mark - Lazy Load
- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkButton addTarget:self action:@selector(checkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_checkButton setImage:[UIImage imageNamed:@"checkbox-uncheck"] forState:UIControlStateNormal];
        [_checkButton setImage:[UIImage imageNamed:@"checkbox-checked"] forState:UIControlStateSelected];
        _checkButton.adjustsImageWhenHighlighted = NO;
        _checkButton.frame = CGRectMake(0, 0, self.contentView.bounds.size.height, self.contentView.bounds.size.height);
        CGFloat aEdgeInset = (_checkButton.frame.size.height - _checkButton.imageView.image.size.height) / 2;
        _checkButton.contentEdgeInsets = UIEdgeInsetsMake(aEdgeInset, aEdgeInset, aEdgeInset, aEdgeInset);
    }
    return _checkButton;
}

#pragma mark - Public Method
- (void)updateItem {
    [UIView animateWithDuration:0.25 animations:^{
        [self refreshArrow];
    }];
}
- (void)refreshArrow {
    if (self.treeItem.isExpand) {
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    } else {
        self.imageView.transform = CGAffineTransformMakeRotation(0);
    }
}
- (void)checkButtonClick:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
    if (sender.selected == YES) {
        if (self.checkButtonClickBlock) {
            self.checkButtonClickBlock(self.treeItem, YES);
        }
    }else{
        if (self.checkButtonClickBlock) {
            self.checkButtonClickBlock(self.treeItem, NO);
        }
    }
    sender.selected = NO;
}
@end

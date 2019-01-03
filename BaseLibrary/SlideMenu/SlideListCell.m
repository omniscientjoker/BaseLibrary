//
//  SlideListCell.m
//  BasicFramework
//
//  Created by joker on 2018/11/22.
//  Copyright © 2018 joker. All rights reserved.
//

#import "SlideListCell.h"
@interface SlideListCell()
@property (strong, nonatomic)  UIImageView *iconImageView;
@property (strong, nonatomic)  UILabel     *itemNameLabel;
@end

@implementation SlideListCell
-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self commitInit];
    }
    return  self;
}
-(void) commitInit{
    self.backgroundColor = [UIColor clearColor];
}

-(void)setCellWithData:(NSDictionary *)dic{
    [self.iconImageView setImage:[UIImage imageNamed:[dic objectForKey:@"icon"]]];
    [self.itemNameLabel setText:[dic objectForKey:@"title"]];
    
    [self.contentView addSubview:self.iconImageView];
    
    [self.contentView addSubview:self.itemNameLabel];
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        CGPoint center = CGPointMake(24, self.center.y);
        [_iconImageView setCenter:center];
        _iconImageView.layer.cornerRadius = 2.f;
    }
    return _iconImageView;
}
-(UILabel *)itemNameLabel{
    if (!_itemNameLabel) {
        _itemNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-48, 20)];
        CGPoint center = CGPointMake(self.center.x+43, self.center.y);
        [_itemNameLabel setCenter:center];
        _itemNameLabel.backgroundColor = [UIColor clearColor];
        _itemNameLabel.font = [UIFont systemFontOfSize:17.f];
        _itemNameLabel.textColor = [UIColor lightTextColor];
        _itemNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _itemNameLabel;
}
@end

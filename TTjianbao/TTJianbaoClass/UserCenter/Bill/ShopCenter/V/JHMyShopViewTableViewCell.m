//
//  JHMyShopViewTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyShopViewTableViewCell.h"

@implementation JHMyShopViewTableViewCell

-(void)addSelfSubViews
{

    _iconView = [UIImageView new];
    [self.contentView addSubview:_iconView];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    _descLabel = [UILabel jh_labelWithFont:13 textColor:[UIColor blackColor] addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(5.f);
        make.centerY.equalTo(self.iconView);
    }];
    
    UIImageView *pushIcon = [UIImageView new];
    pushIcon.image = [UIImage imageNamed:@"icon_shop_bill_push_gray"];
    [self.contentView addSubview:pushIcon];
    [pushIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.f);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 10));
    }];
    
}

+(CGFloat)cellHeight
{
    return 48.f;
}


@end

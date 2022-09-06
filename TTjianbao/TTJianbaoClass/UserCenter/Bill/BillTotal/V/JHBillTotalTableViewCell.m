//
//  JHBillTotalTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillTotalTableViewCell.h"

@implementation JHBillTotalTableViewCell

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithFont:13 textColor:UIColor.blackColor addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15.0);
        make.centerY.equalTo(self.contentView);
    }];
    
    _iconButton = [UIButton jh_buttonWithImage:@"icon_shop_bill_tip" target:self action:@selector(tipAction) addToSuperView:self.contentView];
    [_iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30.0, 30.0));
    }];
    
    _moneyLabel = [UILabel jh_labelWithBoldFont:13 textColor:UIColor.blackColor addToSuperView:self.contentView];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15.0);
        make.centerY.equalTo(self.contentView);
    }];
}

-(void)tipAction
{
    if(_tipActionBlock)
    {
        _tipActionBlock();
    }
}
+(NSString *)cellIdentifier
{
    return NSStringFromClass([JHBillTotalTableViewCell class]);
}

+(CGFloat)cellHeight
{
    return 48.f;
}

@end

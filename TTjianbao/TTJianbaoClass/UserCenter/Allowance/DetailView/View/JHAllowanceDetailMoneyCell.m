//
//  JHAllowanceDetailMoneyCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllowanceDetailMoneyCell.h"

@implementation JHAllowanceDetailMoneyCell

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithText:@"订单时间" font:15 textColor:UIColor.blackColor textAlignment:1 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(31.f);
    }];
    
    _moneyLabel = [UILabel jh_labelWithText:@"+300.00" font:30 textColor:RGB(252, 66, 0) textAlignment:1 addToSuperView:self.contentView];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
}


+(CGFloat)cellHeight
{
    return 116.f;
}

@end

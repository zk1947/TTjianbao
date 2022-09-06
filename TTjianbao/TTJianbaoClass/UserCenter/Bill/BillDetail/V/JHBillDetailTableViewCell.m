//
//  JHBillDetailTableViewCell.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailTableViewCell.h"

@interface JHBillDetailTableViewCell ()
@end

@implementation JHBillDetailTableViewCell

-(void)addSelfSubViews {
    self.contentView .backgroundColor = HEXCOLOR(0xf8f8f8);
    UIView * backView = [[UIView alloc]init];
    backView .backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 8;
    backView.clipsToBounds = YES;
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    _titleLabel = [UILabel jh_labelWithText:@"结算" font:14 textColor:UIColor.blackColor textAlignment:0 addToSuperView:backView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backView).offset(15);
        make.right.equalTo(backView).offset(-155.f);
    }];
    
    _moneyLabel = [UILabel jh_labelWithText:@"￥1222.00" font:14 textColor:UIColor.blackColor textAlignment:0 addToSuperView:backView];
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel);
        make.right.equalTo(backView).offset(-15);
    }];
    
    _timeLabel = [UILabel jh_labelWithText:@"2019-12-16" font:12 textColor:RGB(153, 153, 153) textAlignment:0 addToSuperView:backView];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5.f);
        make.right.equalTo(self.moneyLabel);
    }];
    
    _descLabel = [UILabel jh_labelWithText:@" " font:12 textColor:RGB(153, 153, 153) textAlignment:0 addToSuperView:backView];
    _descLabel.numberOfLines = 0;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel);
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(backView).offset(-155.f);
        make.height.mas_greaterThanOrEqualTo(17.f);
    }];
    
    _remarkLabel = [UILabel jh_labelWithText:@"备注：" font:12 textColor:RGB(153, 153, 153) textAlignment:0 addToSuperView:backView];
    _remarkLabel.numberOfLines = 0;
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(3.f);
        make.left.equalTo(self.descLabel.mas_left);
        make.right.equalTo(backView).offset(-155.f);
        make.height.mas_equalTo(0);
        make.bottom.equalTo(backView).offset(-15.f);
    }];

    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setImage:[UIImage imageNamed:@"zijin_cell_zhankai"] forState:UIControlStateNormal];
    [_moreBtn setImage:[UIImage imageNamed:@"zijin_cell_shouqi"] forState:UIControlStateSelected];
    [_moreBtn addTarget:self action:@selector(lookMore:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.hidden = YES;
    [backView addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.remarkLabel).offset(5.f);
        make.right.equalTo(self.contentView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
}


- (void)lookMore:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.buttonBlock) {
        self.buttonBlock(sender.selected);
    }
}

@end

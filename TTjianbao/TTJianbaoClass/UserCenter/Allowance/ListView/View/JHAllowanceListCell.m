//
//  JHAllowanceListCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllowanceListCell.h"

@interface JHAllowanceListCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *timeLabel;

//@property (nonatomic, strong) UIImageView *statusView;

@end

@implementation JHAllowanceListCell

-(void)addSelfSubViews
{
    _titleLabel = [UILabel jh_labelWithBoldText:@"结算" font:14 textColor:UIColor.blackColor textAlignment:0 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-125.f);
    }];
    
    _moneyLabel = [UILabel jh_labelWithText:@"￥1222.00" font:24 textColor:UIColor.blackColor textAlignment:0 addToSuperView:self.contentView];
    _moneyLabel.font = JHDINBoldFont(24);
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-7);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    _timeLabel = [UILabel jh_labelWithText:@"2019-12-16" font:10 textColor:RGB(153, 153, 153) textAlignment:0 addToSuperView:self.contentView];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-9);
    }];
    
///设计新样式
//    _statusView = [UIImageView jh_imageViewWithImage:@"my_allowance_ststus" addToSuperview:self.contentView];
//    [_statusView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(29, 34));
//        make.right.top.equalTo(self.contentView);
//    }];
}

- (void)setModel:(JHAllowanceListModel *)model{
    _model = model;
    _titleLabel.text = _model.name;
    _timeLabel.text = _model.isGetMoney ? [NSString stringWithFormat:@"有效期至%@",_model.expiredDate] : _model.describe;
    _moneyLabel.text = [NSString stringWithFormat:@"%@ %@",_model.changeType,_model.changeAmount];
    _moneyLabel.textColor = _model.isGetMoney ? HEXCOLOR(0xFF4200) : RGB153153153;
    
    ///设计新样式
//    _statusView.hidden = !_model.isExpired;
//    [_moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) { make.centerY.equalTo(self.contentView).offset(self.model.isExpired ? 0 : -10);
//    }];
}

@end

//
//  JHC2CProductDetailPaiMaiInfoTopView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailPaiMaiInfoTopView.h"

@interface JHC2CProductDetailPaiMaiInfoTopView()

@property(nonatomic, strong) UIImageView * backView;

/// ￥符号
@property(nonatomic, strong) UILabel * moneyLbl;


@end

@implementation JHC2CProductDetailPaiMaiInfoTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.moneyLbl];
    [self.backView addSubview:self.statusLbl];
    [self.backView addSubview:self.moneyValueLbl];
    [self.backView addSubview:self.postMoneyLbl];
    [self.backView addSubview:self.endTimeTextLbl];

    [self.backView addSubview:self.hourDianImageView];
    [self.backView addSubview:self.secondDianImageView];
    [self.backView addSubview:self.timeHourLbl];
    [self.backView addSubview:self.timeMiniLbl];
    [self.backView addSubview:self.timeSecLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(25);
        make.left.equalTo(@0).offset(12);
    }];
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLbl).offset(-2);
        make.left.equalTo(self.statusLbl.mas_right).offset(4);
    }];
    [self.moneyValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(12);
        make.left.equalTo(self.moneyLbl.mas_right);
    }];
    [self.postMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusLbl).offset(-3);
        make.left.equalTo(self.moneyValueLbl.mas_right).offset(4);
    }];
    [self.endTimeTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(7);
        make.right.equalTo(@0).offset(-25);
    }];
    [self.timeHourLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(30);
        make.right.equalTo(@0).offset(-74);
    }];
    [self.hourDianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeHourLbl);
        make.left.equalTo(self.timeHourLbl.mas_right).offset(3);
    }];
    [self.timeMiniLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeHourLbl);
        make.left.equalTo(self.hourDianImageView.mas_right).offset(3);
    }];
    [self.secondDianImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeHourLbl);
        make.left.equalTo(self.timeMiniLbl.mas_right).offset(3);
    }];
    [self.timeSecLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeHourLbl);
        make.left.equalTo(self.secondDianImageView.mas_right).offset(3);
    }];
}

- (UIImageView *)backView{
    if (!_backView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_bg_paimai"];
        _backView = view;
    }
    return _backView;
}

- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(15);
        label.text = @"￥";
        label.textColor = HEXCOLOR(0xffffff);
        _moneyLbl = label;
    }
    return _moneyLbl;
}

- (UILabel *)statusLbl{
    if (!_statusLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.text = @"起拍价";
        label.textColor = HEXCOLOR(0xffffff);
        _statusLbl = label;
    }
    return _statusLbl;
}

- (UILabel *)moneyValueLbl{
    if (!_moneyValueLbl) {
        UILabel *label = [UILabel new];
        label.font = [UI getDINBoldFont:30];
        label.text = @"0";
        label.textColor = HEXCOLOR(0xffffff);
        _moneyValueLbl = label;
    }
    return _moneyValueLbl;

}

- (YYLabel *)postMoneyLbl{
    if (!_postMoneyLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(10);
        label.textContainerInset = UIEdgeInsetsMake(1, 6, 1, 6);
        label.backgroundColor = HEXCOLOR(0xFAECD2);
        label.layer.cornerRadius = 2;
        label.text = @"包邮";
        label.textColor = HEXCOLOR(0x67411A);
        _postMoneyLbl = label;
    }
    return _postMoneyLbl;
}

- (UILabel *)endTimeTextLbl{
    if (!_endTimeTextLbl) {
        UILabel *label = [UILabel new];
        label.hidden = true;
        label.font = JHFont(12);
        label.text = @"距拍卖结束";
        label.textColor = HEXCOLOR(0xffffff);
        _endTimeTextLbl = label;
    }
    return _endTimeTextLbl;
}


- (UIImageView *)hourDianImageView{
    if (!_hourDianImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_dian"];
        view.hidden = true;
        _hourDianImageView = view;
        _hourDianImageView.hidden = true;
    }
    return _hourDianImageView;
}
- (UIImageView *)secondDianImageView{
    if (!_secondDianImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_dian"];
        _secondDianImageView = view;
        _secondDianImageView.hidden = true;
    }
    return _secondDianImageView;
}

- (YYLabel *)timeHourLbl{
    if (!_timeHourLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHMediumFont(12);
        label.textContainerInset = UIEdgeInsetsMake(0.5, 3, 0.5, 3);
        label.backgroundColor = HEXCOLOR(0xffffff);
        label.layer.cornerRadius = 2;
        label.text = @"00";
        label.textColor = HEXCOLOR(0xF94520);
        label.hidden = true;
        _timeHourLbl = label;
    }
    return _timeHourLbl;
}
- (YYLabel *)timeMiniLbl{
    if (!_timeMiniLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHMediumFont(12);
        label.textContainerInset = UIEdgeInsetsMake(0.5, 3, 0.5, 3);
        label.backgroundColor = HEXCOLOR(0xffffff);
        label.layer.cornerRadius = 2;
        label.text = @"00";
        label.textColor = HEXCOLOR(0xF94520);
        label.hidden = true;
        _timeMiniLbl = label;
    }
    return _timeMiniLbl;
}
- (YYLabel *)timeSecLbl{
    if (!_timeSecLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHMediumFont(12);
        label.textContainerInset = UIEdgeInsetsMake(0.5, 3, 0.5, 3);
        label.backgroundColor = HEXCOLOR(0xffffff);
        label.layer.cornerRadius = 2;
        label.text = @"00";
        label.textColor = HEXCOLOR(0xF94520);
        label.hidden = true;
        _timeSecLbl = label;
    }
    return _timeSecLbl;
}


@end

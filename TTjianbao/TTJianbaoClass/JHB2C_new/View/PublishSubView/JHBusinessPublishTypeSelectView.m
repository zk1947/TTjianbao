//
//  JHBusinessPublishTypeSelectView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishTypeSelectView.h"

@interface JHBusinessPublishTypeSelectView ()

@property (nonatomic,strong) UILabel * titleLbl;
@property (nonatomic,strong) UIButton * nowPubBtn;//立即发布
@property (nonatomic,strong) UIButton * handPubBtn;//手动发布
@end

@implementation JHBusinessPublishTypeSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}
- (void)setItems{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLbl];
    [self addSubview:self.nowPubBtn];
    [self addSubview:self.handPubBtn];
}
- (void)layoutItems{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).offset(12);
    }];
    [self.nowPubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLbl);
            make.left.mas_equalTo(self.titleLbl.mas_right).offset(30);
    }];
    [self.handPubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleLbl);
            make.left.mas_equalTo(self.nowPubBtn.mas_right).offset(50);
    }];
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"商品发布";
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UIButton *)nowPubBtn{
    //icon_user_auth_select_sel
//    icon_user_auth_select_nor
    if (!_nowPubBtn) {
        _nowPubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nowPubBtn setTitle:@"立即上架" forState:UIControlStateNormal];
        _nowPubBtn.titleLabel.font = JHFont(12);
        [_nowPubBtn setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];
        [_nowPubBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_nowPubBtn addTarget:self action:@selector(startRemindBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_nowPubBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        _nowPubBtn.selected = YES;
    }
    return _nowPubBtn;
}
- (UIButton *)handPubBtn{
    if (!_handPubBtn) {
        _handPubBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handPubBtn setTitle:@"下架待售" forState:UIControlStateNormal];
        _handPubBtn.titleLabel.font = JHFont(12);
        [_handPubBtn setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
        [_handPubBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_handPubBtn addTarget:self action:@selector(startRemindBtnClickAction2:) forControlEvents:UIControlEventTouchUpInside];
        [_handPubBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
        _handPubBtn.selected = YES;
    }
    return _handPubBtn;
}
- (void)startRemindBtnClickAction:(UIButton *)sender{
  
    [self.handPubBtn setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
//    [self.nowPubBtn setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    
    [sender setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];
    self.publishModle.productStatus = 0;
    //0-上架（立即上架） 1-下架（下架待售）  2违规禁售  3预告中(指定时间上架)  4已售出  5流拍  6交易取消 （3，5，6是拍卖商品特有的状态）【必须】",
}
- (void)startRemindBtnClickAction2:(UIButton *)sender{
    [self.nowPubBtn setImage:[UIImage imageNamed:@"icon_user_auth_select_nor"] forState:UIControlStateNormal];
    [sender setImage:[UIImage imageNamed:@"icon_user_auth_select_sel"] forState:UIControlStateNormal];
    self.publishModle.productStatus = 1;
}

- (void)resetNetData{
    if (self.publishModle.productStatus == 1) {
        [self startRemindBtnClickAction2:self.handPubBtn];
    }else{
        [self startRemindBtnClickAction:self.nowPubBtn];
    }
}
@end

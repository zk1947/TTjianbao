//
//  JHChatOrderView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderView.h"

@interface JHChatOrderView()
@property (nonatomic, strong) UIImageView *goodsIcon;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
/// 商品金额
@property (nonatomic, strong) UILabel *priceLabel;
/// ¥
@property (nonatomic, strong) UILabel *priceTLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *sendButton;
@end

@implementation JHChatOrderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

- (void)didClickSend : (UIButton *)sender {
    if (self.sendHandler == nil) return;
    self.sendHandler(self.orderInfo);
    [self removeFromSuperview];
}
- (void)didClickClose : (UIButton *)sender {
    [self removeFromSuperview];
}
- (void)setupData {
    if (self.orderInfo == nil) return;
    [self.goodsIcon jh_setImageWithUrl:self.orderInfo.iconUrl placeHolder:@""];
    self.goodsTitleLabel.text = self.orderInfo.title;
    self.priceLabel.text = self.orderInfo.price;
}
#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:self.goodsIcon];
    [self addSubview:self.goodsTitleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.priceLabel];
    [self addSubview:self.priceTLabel];
    [self addSubview:self.sendButton];
}
- (void)layoutViews {
    [self jh_cornerRadius:8];
    
    [self.goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(self.goodsIcon.mas_height);
    }];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(2);
        make.left.mas_equalTo(self.goodsIcon.mas_right).offset(8);
        make.right.mas_equalTo(self.closeButton.mas_left).offset(-6);
    }];
    [self.priceTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(self.goodsTitleLabel);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceTLabel);
        make.left.mas_equalTo(self.priceTLabel.mas_right).offset(1);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(-6);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.right.mas_equalTo(0);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-8);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(64, 28));
    }];
}
#pragma mark - LAZY
- (void)setOrderInfo:(JHChatOrderInfoModel *)orderInfo {
    _orderInfo = orderInfo;
    [self setupData];
}
- (UIImageView *)goodsIcon {
    if (!_goodsIcon) {
        _goodsIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsIcon.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
        _goodsIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_goodsIcon jh_cornerRadius:5];
    }
    return _goodsIcon;
}
- (UILabel *)goodsTitleLabel {
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTitleLabel.numberOfLines = 1;
        _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
        _goodsTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsTitleLabel;
}
- (UILabel *)priceTLabel {
    if (!_priceTLabel) {
        _priceTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceTLabel.text = @"¥";
        _priceTLabel.textColor = HEXCOLOR(0xf23730);
        _priceTLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _priceTLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceTLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0xf23730);
        _priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"IM_warning_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton jh_cornerRadius:8];
        _sendButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_sendButton setTitle:@"发送订单" forState:UIControlStateNormal];
        [_sendButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_sendButton addTarget:self action:@selector(didClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
@end

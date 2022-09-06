//
//  JHMarketRefundTypeView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketRefundTypeView.h"
#import "UIView+JHGradient.h"
@interface JHMarketRefundTypeView()
/** 背景框*/
@property (nonatomic, strong) UIView *backView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 关闭按钮*/
@property (nonatomic, strong) UIButton *closeButton;
/** 仅退款*/
@property (nonatomic, strong) UILabel *refundLabel;
/** 仅退款des*/
@property (nonatomic, strong) UILabel *refundDesLabel;
/** 选择框*/
@property (nonatomic, strong) UIButton *refundButton;
/** 退货退款*/
@property (nonatomic, strong) UILabel *returnGoodsLabel;
/** 退货退款des*/
@property (nonatomic, strong) UILabel *returnGoodsDesLabel;
/** 选择框*/
@property (nonatomic, strong) UIButton *returnButton;
/** 确定*/
@property (nonatomic, strong) UIButton *ensureButton;
@end

@implementation JHMarketRefundTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
        [self configUI];
    }
    return self;
}

- (void)buttonClickAction:(UIButton *)sender {
    NSString *str;
    NSInteger typeIndex = 0;
    if (self.refundButton.isSelected) {
        str = self.refundLabel.text;
        typeIndex = 1;
    }
    if (self.returnButton.isSelected) {
        str = self.returnGoodsLabel.text;
        typeIndex = 2;
    }
    if (self.selectCompleteBlock) {
        self.selectCompleteBlock(str, typeIndex);
    }
    [self close];
}

- (void)selectButtonClickAction:(UIButton *)sender {
    if (sender.tag == 100) {
        self.refundButton.selected = YES;
        self.returnButton.selected = NO;
    } else {
        self.refundButton.selected = NO;
        self.returnButton.selected = YES;
    }
}

- (void)close {
    [self removeFromSuperview];
}

- (void)configUI {
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.closeButton];
    [self.backView addSubview:self.refundLabel];
    [self.backView addSubview:self.refundDesLabel];
    [self.backView addSubview:self.refundButton];
    [self.backView addSubview:self.returnGoodsLabel];
    [self.backView addSubview:self.returnGoodsDesLabel];
    [self.backView addSubview:self.returnButton];
    [self.backView addSubview:self.ensureButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(ScreenW, 314));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(13);
        make.centerX.mas_equalTo(self.backView);
        make.height.mas_equalTo(24);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-10);
        make.centerY.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    
    [self.refundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(28);
        make.left.mas_equalTo(self.backView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.refundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-15);
        make.centerY.mas_equalTo(self.refundLabel).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.returnGoodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundDesLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(self.backView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.returnGoodsDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.returnGoodsLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(-15);
        make.centerY.mas_equalTo(self.returnGoodsLabel).offset(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.returnGoodsDesLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(351, 50));
    }];
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc]init];
        [_closeButton setImage:[UIImage imageNamed:@"c2c_class_alert_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:17];
        _titleLabel.text = @"请选择退款类型";
    }
    return _titleLabel;
}

- (UILabel *)refundLabel {
    if (_refundLabel == nil) {
        _refundLabel = [[UILabel alloc] init];
        _refundLabel.textColor = HEXCOLOR(0x333333);
        _refundLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
        _refundLabel.text = @"仅退款";
    }
    return _refundLabel;
}

- (UILabel *)refundDesLabel {
    if (_refundDesLabel == nil) {
        _refundDesLabel = [[UILabel alloc] init];
        _refundDesLabel.textColor = HEXCOLOR(0x333333);
        _refundDesLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _refundDesLabel.text = @"没收到货,需要退款";
    }
    return _refundDesLabel;
}

- (UIButton *)refundButton {
    if (_refundButton == nil) {
        _refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refundButton setImage:[UIImage imageNamed:@"recycle_piublish_price_normal"] forState:UIControlStateNormal];
        [_refundButton setImage:[UIImage imageNamed:@"recycle_piublish_price_selected"] forState:UIControlStateSelected];
        _refundButton.adjustsImageWhenHighlighted = NO;
        _refundButton.tag = 100;
        [_refundButton addTarget:self action:@selector(selectButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _refundButton;
}

- (UILabel *)returnGoodsLabel {
    if (_returnGoodsLabel == nil) {
        _returnGoodsLabel = [[UILabel alloc] init];
        _returnGoodsLabel.textColor = HEXCOLOR(0x333333);
        _returnGoodsLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
        _returnGoodsLabel.text = @"退货退款";
    }
    return _returnGoodsLabel;
}

- (UILabel *)returnGoodsDesLabel {
    if (_returnGoodsDesLabel == nil) {
        _returnGoodsDesLabel = [[UILabel alloc] init];
        _returnGoodsDesLabel.textColor = HEXCOLOR(0x333333);
        _returnGoodsDesLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _returnGoodsDesLabel.text = @"已收到货,需要退还收到的货物再退款";
    }
    return _returnGoodsDesLabel;
}

- (UIButton *)returnButton {
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton setImage:[UIImage imageNamed:@"recycle_piublish_price_normal"] forState:UIControlStateNormal];
        [_returnButton setImage:[UIImage imageNamed:@"recycle_piublish_price_selected"] forState:UIControlStateSelected];
        _returnButton.adjustsImageWhenHighlighted = NO;
        _returnButton.tag = 200;
        [_returnButton addTarget:self action:@selector(selectButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

- (UIButton *)ensureButton {
    if (_ensureButton == nil) {
        _ensureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ensureButton setTitle:@"确定" forState:UIControlStateNormal];
        _ensureButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_ensureButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _ensureButton.backgroundColor = HEXCOLOR(0xfcec9d);
        _ensureButton.layer.cornerRadius = 25;
        _ensureButton.clipsToBounds = YES;
        [_ensureButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_ensureButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

@end

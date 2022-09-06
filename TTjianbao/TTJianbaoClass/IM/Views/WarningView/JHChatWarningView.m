//
//  JHChatAlertView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatWarningView.h"
@interface JHChatWarningView()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@end
@implementation JHChatWarningView
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

- (void)didClickClose : (UIButton *)sender {
    if (self.closedHandler) {
        self.closedHandler();
    }
    [self removeFromSuperview];
}

- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xfffaf2);
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-6);
        make.right.mas_equalTo(self.closeButton.mas_left).offset(-8);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0xff6a00);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"温馨提示：为了保护您的信息及财产安全，请勿透露手机号、微信、银行卡等个人信息，且勿进行扫码、点链接等形式进行支付！";
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"IM_warning_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
@end

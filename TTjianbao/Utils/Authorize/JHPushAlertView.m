//
//  JHPushAlertView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPushAlertView.h"
#import "UIView+JHGradient.h"
@interface JHPushAlertView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) UILabel *bgTitleLabel;
@property (nonatomic, strong) UILabel *bgDateLabel;
@end
@implementation JHPushAlertView

+ (void)showWithTitle : (NSString *)title subTitle : (NSString *)subTitle desc : (NSString *)desc handler : (CompleteHandler)handler{
    JHPushAlertView *alert = [[JHPushAlertView alloc] initWithFrame:CGRectZero];
    alert.titleText = title;
    alert.subTitleText = subTitle;
    alert.descText = desc;
    alert.completeHandler = handler;
    [alert show];
}
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutViews];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.completeButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfee100), HEXCOLOR(0xffc242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}
#pragma mark - 点击事件
// 完成
- (void)didClickComplete : (UIButton *)sender {
    if (self.completeHandler) {
        self.completeHandler();
    }
}
// 关闭
- (void)didClickClose : (UIButton *)sender {
    [self removeFromSuperview];
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLORA(0x000000, 0.5);
    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
}
- (void)layoutViews {
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.completeButton];
    
    [self.contentView addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.icon];
    [self.bgImageView addSubview:self.bgTitleLabel];
    [self.bgImageView addSubview:self.bgDateLabel];
    [self.bgImageView addSubview:self.descLabel];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.center.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(25);
        make.left.mas_equalTo(18);
        make.right.mas_equalTo(-18);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.mas_equalTo(9);
        make.size.mas_equalTo(CGSizeMake(20, 19));
    }];
    [self.bgTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.left.mas_equalTo(self.icon.mas_right).offset(5);
    }];
    [self.bgDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.right.mas_equalTo(-9);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.icon.mas_bottom).offset(14);
        make.bottom.mas_equalTo(-14);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgImageView.mas_bottom).offset(25);
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
}
#pragma mark - LAZY
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}
- (void)setSubTitleText:(NSString *)subTitleText{
    _subTitleText = subTitleText;
    self.subTitleLabel.text = subTitleText;
}
- (void)setDescText:(NSString *)descText {
    _descText = descText;
    self.descLabel.text = descText;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView jh_cornerRadius:8];
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _contentView;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.image = [UIImage imageNamed:@"alert_push_bg"];
    }
    return _bgImageView;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"alert_push_logo_icon"];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}
- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLabel.textColor = HEXCOLOR(0x333333);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _subTitleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.numberOfLines = 1;
        _descLabel.textColor = HEXCOLOR(0x000000);
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.font = [UIFont fontWithName:kFontNormal size:12.6];
    }
    return _descLabel;
}
- (UILabel *)bgTitleLabel {
    if (!_bgTitleLabel) {
        _bgTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bgTitleLabel.text = @"天天鉴宝";
        _bgTitleLabel.textColor = HEXCOLOR(0x000000);
        _bgTitleLabel.textAlignment = NSTextAlignmentLeft;
        _bgTitleLabel.font = [UIFont fontWithName:kFontBoldDIN size:12.6];
    }
    return _bgTitleLabel;
}
- (UILabel *)bgDateLabel {
    if (!_bgDateLabel) {
        _bgDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bgDateLabel.text = @"现在";
        _bgDateLabel.textColor = HEXCOLOR(0x223455);
        _bgDateLabel.textAlignment = NSTextAlignmentLeft;
        _bgDateLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _bgDateLabel;
}
- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton jh_cornerRadius:20];
        [_completeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _completeButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_completeButton setTitle:@"立即开启" forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:15];
        [_completeButton addTarget:self action:@selector(didClickComplete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal ];
        _closeButton.contentMode=UIViewContentModeScaleAspectFit;
        _closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
@end

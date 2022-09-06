//
//  JHHonnerCerDetailNavView.m
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailNavView.h"

@interface JHHonnerCerDetailNavView ()
@property (nonatomic, strong) UIButton                       *backButton;
@property (nonatomic, strong) UILabel                        *titleLabel;
@property (nonatomic, strong) UIButton                       *deleteButton;
@property (nonatomic, strong) UIButton                       *shareButton;
@property (nonatomic,   copy) honnerCerNavButtonClickBlock    hcBtnBlock;
@end

@implementation JHHonnerCerDetailNavView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIView *backView                       = [[UIView alloc] init];
    [self addSubview:backView];
    CGFloat statusBarHeight                = UI.statusBarHeight;
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.left.right.bottom.equalTo(self);
    }];

    /// 返回按钮
    self.backButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_black"] forState:UIControlStateNormal];
    [backView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.centerY.equalTo(backView.mas_centerY).offset(3.f);
        make.width.mas_equalTo(30.f);
        make.height.mas_equalTo(37.f);
    }];

    /// 分享按钮
    self.shareButton                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton setImage:[UIImage imageNamed:@"navi_icon_share_black"] forState:UIControlStateNormal];
    [backView addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.mas_equalTo(20.f);
    }];
    
    /// 删除按钮
    self.deleteButton                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton setImage:[UIImage imageNamed:@"customize_cer_delete"] forState:UIControlStateNormal];
    [backView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareButton.mas_left).offset(-20.f);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.mas_equalTo(20.f);
    }];

    /// 标题
    self.titleLabel                        = [[UILabel alloc] init];
    self.titleLabel.textColor              = HEXCOLOR(0x333333);
    self.titleLabel.textAlignment          = NSTextAlignmentCenter;
    self.titleLabel.font                   = [UIFont fontWithName:kFontNormal size:18.f];
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    [self addSubview:bottomLineView];
    bottomLineView.backgroundColor = HEXCOLOR(0xF5F6FA);//RGB(238, 238, 238);
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1.0);
    }];
}

- (void)setIsAnchor:(BOOL)isAnchor {
    self.deleteButton.hidden = !isAnchor;
}

/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.hcBtnBlock) {
        self.hcBtnBlock(JHHonnerCerDetailButtonStyle_Back);
    }
}

/// 点击分享
- (void)shareButtonAction:(UIButton *)sender {
    if (self.hcBtnBlock) {
        self.hcBtnBlock(JHHonnerCerDetailButtonStyle_Share);
    }
}

/// 点击删除
- (void)deleteButtonAction:(UIButton *)sender {
    if (self.hcBtnBlock) {
        self.hcBtnBlock(JHHonnerCerDetailButtonStyle_Delete);
    }
}

- (void)honnerCerNavViewBtnAction:(honnerCerNavButtonClickBlock)clickBlock {
    self.hcBtnBlock = clickBlock;
}

/// TODO: data
- (void)reloadHCInfoName:(NSString *)name {
    self.titleLabel.text = name;
}

@end

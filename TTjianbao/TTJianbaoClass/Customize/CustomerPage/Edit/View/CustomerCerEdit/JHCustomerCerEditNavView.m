//
//  JHCustomerCerEditNavView.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerEditNavView.h"

@interface JHCustomerCerEditNavView ()
@property (nonatomic, strong) UIButton                         *backButton;
@property (nonatomic, strong) UILabel                          *titleLabel;
@property (nonatomic, strong) UIButton                         *saveButton;
@property (nonatomic,   copy) honnerCerEditNavButtonClickBlock  hcBtnBlock;
@end

@implementation JHCustomerCerEditNavView

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

    /// 保存/发布按钮
    self.saveButton                       = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    self.saveButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15.f];
    [self.saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15.f);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.mas_equalTo(40.f);
        make.height.mas_equalTo(21.f);
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
    
    /// 分割线
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = HEXCOLOR(0xF5F6FA).CGColor;
    lineLayer.frame = CGRectMake(0, [self navViewHeight]-1.f, ScreenW, 1.f);
    [self.layer addSublayer:lineLayer];
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 60.f;
    return navHeight;
}

/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.hcBtnBlock) {
        self.hcBtnBlock(JHHonnerCerEditButtonStyle_Back);
    }
}

/// 点击保存/发布
- (void)saveButtonAction:(UIButton *)sender {
    if (self.hcBtnBlock) {
        self.hcBtnBlock(JHHonnerCerEditButtonStyle_Save);
    }
}

- (void)honnerCerEditNavViewBtnAction:(honnerCerEditNavButtonClickBlock)clickBlock {
    self.hcBtnBlock = clickBlock;
}

/// TODO: data
- (void)reloadHCInfoName:(NSString *)name btnName:(NSString *)btnName {
    self.titleLabel.text = name;
    [self.saveButton setTitle:btnName forState:UIControlStateNormal];
}

@end

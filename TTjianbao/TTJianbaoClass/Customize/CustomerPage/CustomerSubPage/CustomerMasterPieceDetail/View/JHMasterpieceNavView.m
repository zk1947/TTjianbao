//
//  JHMasterpieceNavView.m
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMasterpieceNavView.h"

@interface JHMasterpieceNavView ()
@property (nonatomic, strong) UIButton                       *backButton;
@property (nonatomic, strong) UIImageView                    *iconImageView;
@property (nonatomic, strong) UILabel                        *titleLabel;
@property (nonatomic, strong) UILabel                        *subTitleLabel;
@property (nonatomic, strong) UIButton                       *shareButton;
@property (nonatomic, strong) UIButton                       *deleteButton;
@property (nonatomic,   copy) masterpieceNavButtonClickBlock  mpBtnBlock;
@end

@implementation JHMasterpieceNavView

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

    /// 头像
    self.iconImageView                     = [[UIImageView alloc] init];
    self.iconImageView.layer.cornerRadius  = 15.f;
    self.iconImageView.layer.masksToBounds = YES;
    [backView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backButton.mas_left).offset(29.f);
        make.centerY.equalTo(self.backButton.mas_centerY);
        make.width.height.mas_equalTo(30.f);
    }];

    /// 标题
    self.titleLabel                        = [[UILabel alloc] init];
    self.titleLabel.textColor              = HEXCOLOR(0x333333);
    self.titleLabel.textAlignment          = NSTextAlignmentLeft;
    self.titleLabel.font                   = [UIFont fontWithName:kFontNormal size:13.f];
    [backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(7.f);
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.shareButton.mas_left).offset(-100.f);
        make.height.mas_equalTo(18.f);
    }];


    /// 副标题
    self.subTitleLabel                     = [[UILabel alloc] init];
    self.subTitleLabel.textColor           = HEXCOLOR(0x999999);;
    self.subTitleLabel.textAlignment       = NSTextAlignmentLeft;
    self.subTitleLabel.font                = [UIFont fontWithName:kFontNormal size:10.f];
    [backView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1.f);
        make.right.equalTo(self.shareButton.mas_left).offset(-100.f);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
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
}

- (void)setIsAnchor:(BOOL )isAnchor {
    self.deleteButton.hidden = !isAnchor;
}

/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.mpBtnBlock) {
        self.mpBtnBlock(JHMasterpieceNavViewButtonStyle_Back);
    }
}

/// 点击分享
- (void)shareButtonAction:(UIButton *)sender {
    if (self.mpBtnBlock) {
        self.mpBtnBlock(JHMasterpieceNavViewButtonStyle_Share);
    }
}

/// 点击删除
- (void)deleteButtonAction:(UIButton *)sender {
    if (self.mpBtnBlock) {
        self.mpBtnBlock(JHMasterpieceNavViewButtonStyle_Delete);
    }
}

- (void)masterpieceNavViewBtnAction:(masterpieceNavButtonClickBlock)clickBlock {
    self.mpBtnBlock = clickBlock;
}

- (void)reloadMPMessage:(UIImage *)image name:(NSString *)name subName:(NSString *)subName {
    self.iconImageView.image = image;
    self.titleLabel.text     = name;
    self.subTitleLabel.text  = subName;
}

@end

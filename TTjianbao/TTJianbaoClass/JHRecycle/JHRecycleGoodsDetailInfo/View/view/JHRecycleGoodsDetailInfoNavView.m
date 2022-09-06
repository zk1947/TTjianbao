//
//  JHRecycleGoodsDetailInfoNavView.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailInfoNavView.h"

@interface JHRecycleGoodsDetailInfoNavView ()
@property (nonatomic, strong) UIView   *backView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel  *nameLabel;
@end

@implementation JHRecycleGoodsDetailInfoNavView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backView                       = [[UIView alloc] init];
    _backView.userInteractionEnabled = YES;
    [self addSubview:_backView];
    CGFloat statusBarHeight         = UI.statusBarHeight;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(statusBarHeight);
        make.left.right.bottom.equalTo(self);
    }];

    /// 返回按钮
    self.backButton                        = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_white_shadow"] forState:UIControlStateNormal];
    [_backView addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.centerY.equalTo(self.backView.mas_centerY).offset(3.f);
        make.width.mas_equalTo(30.f);
        make.height.mas_equalTo(37.f);
    }];
    
    /// 名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont fontWithName:kFontBoldPingFang size:18.f];
    [_backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
}


/// 点击返回
- (void)backButtonAction:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)changeNavBackBlack:(BOOL)isChange {
    if (!isChange) {
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_black"] forState:UIControlStateNormal];
    } else {
        [self.backButton setImage:[UIImage imageNamed:@"navi_icon_back_white_shadow"] forState:UIControlStateNormal];
    }
}

- (void)setTitleLabelAlpha:(CGFloat)alpha {
    self.nameLabel.alpha = alpha;
}

- (void)setNavViewTitle:(NSString *)str {
    self.nameLabel.text = str;
}

@end



//
//  JHMallHomeLoginTipsView.m
//  TTjianbao
//
//  Created by user on 2021/1/16.
//  Copyright © 2021 blox. All rights reserved.
//

#import "JHMallHomeLoginTipsView.h"

@interface JHMallHomeLoginTipsView ()
@end

@implementation JHMallHomeLoginTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLORA(0x000000, 0.72f);
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"common_app_icon"];
    iconImageView.layer.cornerRadius  = 4.f;
    iconImageView.layer.masksToBounds = YES;
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(12.f);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(36.f, 36.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = HEXCOLOR(0xFFFFFF);
    titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
    titleLabel.text = @"欢迎来到天天鉴宝";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5.f);
        make.top.equalTo(iconImageView.mas_top);
        make.height.mas_equalTo(20.f);
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = HEXCOLORA(0xFFFFFF,0.85f);
    subTitleLabel.font = [UIFont fontWithName:kFontNormal size:12.f];
    NSDictionary *dict = @{NSForegroundColorAttributeName: HEXCOLORA(0xffffff, 0.85f)};
    NSDictionary *dicts = @{NSForegroundColorAttributeName: HEXCOLOR(0xff6d0b)};
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"登录即领取" attributes:dict];
    NSAttributedString *title1 = [[NSAttributedString alloc] initWithString:@"1888元" attributes:dicts];
    NSAttributedString *title2 = [[NSAttributedString alloc] initWithString:@"新人大礼包" attributes:dict];
    [title appendAttributedString:title1];
    [title appendAttributedString:title2];
    subTitleLabel.attributedText = title;
    
    [self addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5.f);
        make.bottom.equalTo(iconImageView.mas_bottom);
        make.height.mas_equalTo(16.f);
    }];
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"马上登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14.f];
    [loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.backgroundColor = HEXCOLOR(0xFFD70F);
    loginBtn.layer.cornerRadius  = 4.f;
    loginBtn.layer.masksToBounds = YES;
    [self addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12.f);
        make.width.mas_equalTo(77.f);
        make.height.mas_equalTo(31.f);
    }];
}

- (void)loginBtnAction:(UIButton *)sender {
    [JHGrowingIO trackEventId:@"dlyd_click"];
    [JHGrowingIO trackEventId:@"enter_live_in" from:@"1"];
    IS_LOGIN;
}

@end

//
//  JHOnlineLivingStatusView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineLivingStatusView.h"

@interface JHOnlineLivingStatusView ()

@property (nonatomic, strong) YYAnimatedImageView *livingImageView;
@property (nonatomic, strong) UILabel *livingLabel;
@property (nonatomic, strong) UIView *watchView;
@property (nonatomic, strong) UILabel *watchCountLabel;

@end

@implementation JHOnlineLivingStatusView

- (void)configWatchCount:(NSString *)watchCount {
    if ([watchCount isNotBlank]) {
        _watchCountLabel.text = [NSString stringWithFormat:@"%@热度", watchCount];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 3.f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *livingView = [[UIView alloc] init];
    livingView.backgroundColor = HEXCOLOR(0xFFD70F);
    
    YYAnimatedImageView *iconImageView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"mall_home_bannar_living.webp"]];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _livingImageView = iconImageView;
    
    UILabel *livingLabel = [[UILabel alloc] init];
    livingLabel.backgroundColor = HEXCOLOR(0xFFD70F);
    livingLabel.font = [UIFont fontWithName:kFontNormal size:10.];
    livingLabel.textColor = kColor333;
    livingLabel.text = @"直播";
    _livingLabel = livingLabel;
    
    UIView *watchView = [[UIView alloc] init];
    watchView.backgroundColor = HEXCOLORA(0xFFFFFF, .15);
    _watchView = watchView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"0热度";
    label.font = [UIFont fontWithName:kFontNormal size:10.];
    label.textColor = kColorFFF;
    _watchCountLabel = label;
    
    [self addSubview:livingView];
    [livingView addSubview:_livingImageView];
    [livingView addSubview:_livingLabel];
    [self addSubview:_watchView];
    [_watchView addSubview:_watchCountLabel];

    
    [livingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(40.5);
    }];
    
    [_livingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(livingView);
        make.width.mas_equalTo(self.mas_height);
    }];
    
    [_livingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livingImageView.mas_right);
        make.centerY.equalTo(self.livingImageView);
        make.height.equalTo(self.livingImageView);
        make.right.equalTo(livingView).offset(-4.);
    }];

    [_watchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(livingView.mas_right);
        make.centerY.equalTo(livingView);
        make.height.equalTo(livingView);
        make.right.equalTo(self);
    }];

    [_watchCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.watchView).offset(3);
        make.right.equalTo(self.watchView).offset(-3);
        make.height.equalTo(self.watchView);
        make.centerY.equalTo(self.watchView);
    }];
}







@end

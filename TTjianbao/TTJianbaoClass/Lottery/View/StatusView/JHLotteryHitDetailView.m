//
//  JHLotteryHitDetailView.m
//  TTjianbao
//
//  Created by lihui on 2020/8/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryHitDetailView.h"
#import "JHLotteryActivityDetailModel.h"

@interface JHLotteryHitDetailView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation JHLotteryHitDetailView


- (void)setIcon:(NSString *)icon Title:(NSString *)title Detail:(NSString *)detail Desc:(NSString *)desc {
    _iconImageView.image = [UIImage imageNamed:icon];
    _titleLabel.text = title ? : @"";
    _detailLabel.text = detail;
    _descriptionLabel.text = desc;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = APP_BACKGROUND_COLOR;
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        [self configViews];
    }
    return self;
}

- (void)configViews {
    UIImageView *icon = [UIImageView jh_imageViewWithImage:@"lottery_address" addToSuperview:self];
    _iconImageView = icon;
    
    UILabel *titleLabel = [UILabel jh_labelWithBoldFont:15 textColor:RGB515151 addToSuperView:self];
    _titleLabel = titleLabel;
    titleLabel.text = @"";

    UILabel *detailLabel = [UILabel jh_labelWithFont:13 textColor:RGB153153153 addToSuperView:self];
    _detailLabel = detailLabel;
    detailLabel.text = @"";
    
    UILabel *descLabel = [UILabel jh_labelWithFont:13 textColor:RGB153153153 addToSuperView:self];
    descLabel.text = @"未知";
    descLabel.adjustsFontSizeToFitWidth = YES;
    _descriptionLabel = descLabel;
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];

    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon);
        make.left.equalTo(icon.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(icon.mas_bottom).offset(10);
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
        make.left.equalTo(detailLabel);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self).offset(-10);
    }];
}


@end

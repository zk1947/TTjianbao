//
//  JHStoreDetailPriceHotView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailPriceHotView.h"

static const CGFloat CountdownSpace = 3;

@interface JHStoreDetailPriceHotView()

@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation JHStoreDetailPriceHotView
#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions

#pragma mark - Private Functions
#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = [UIColor colorWithHexString:@"FDF0C8"];
    [self addSubview:self.bgImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.countdownView];
}

- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.right.equalTo(self).offset(-PriceRightDetailWidth);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.top.equalTo(self).offset(PriceTitleTopSpace);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-CountdownSpace);
        make.left.equalTo(self.bgImageView.mas_right).offset(2);
        make.right.equalTo(self).offset(2);
    }];
    [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(CountdownSpace);
        make.centerX.equalTo(self.detailLabel.mas_centerX);
    }];
}

#pragma mark - Lazy
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"专场价";
        _titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.text = @"距专场结束";
        _detailLabel.font = [UIFont boldSystemFontOfSize:12];
        _detailLabel.textColor = [UIColor colorWithHexString:@"9B541F"];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"newStore_price_bg"]];
    }
    return _bgImageView;
}
- (JHStoreDetailCountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[JHStoreDetailCountdownView alloc]initWithFrame:CGRectZero];
    }
    return _countdownView;
}
@end

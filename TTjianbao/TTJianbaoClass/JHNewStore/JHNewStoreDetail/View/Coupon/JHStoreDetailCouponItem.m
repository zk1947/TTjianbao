//
//  JHStoreDetailCouponItem.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponItem.h"

@interface JHStoreDetailCouponItem()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHStoreDetailCouponItem
#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
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
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText) takeUntil:self.rac_prepareForReuseSignal];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.bgImageView];
    [self.bgImageView addSubview:self.titleLabel];
}
- (void) layoutViews {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView).insets(UIEdgeInsetsMake(4, TitleLeftSpace, 4, TitleLeftSpace));
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailCouponItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newStore_coupon_item_bg"]];
    }
    return _bgImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:TitleTextFontSize];
        _titleLabel.textColor = [UIColor colorWithHexString:@"FF9900"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end

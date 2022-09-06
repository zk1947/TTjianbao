//
//  JHStoreDetailShopItem.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopItem.h"

@interface JHStoreDetailShopItem()
@property (nonatomic, strong) YYAnimatedImageView *goodsImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation JHStoreDetailShopItem
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
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText) takeUntil: self.rac_prepareForReuseSignal];
    RAC(self.priceLabel, attributedText) = [RACObserve(self.viewModel, priceText) takeUntil: self.rac_prepareForReuseSignal];
    @weakify(self)
    [[RACObserve(self.viewModel, iconUrl)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.goodsImageView jh_setImageWithUrl:x placeHolder:@"newStore_detail_shopProduct_Placeholder"];
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.goodsImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.priceLabel];
}
- (void) layoutViews {
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(self.goodsImageView.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(shopItemTitleTop);
        make.left.right.equalTo(self);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.height.mas_equalTo(shopItemPriceHeight);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailShopItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (YYAnimatedImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        [_goodsImageView jh_cornerRadius:4];
        _goodsImageView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _goodsImageView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textAlignment = NSTextAlignmentJustified;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = BLACK_COLOR;
    }
    return _titleLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.numberOfLines = 1;
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [UIColor colorWithHexString:@"F23730"];
        _priceLabel.adjustsFontSizeToFitWidth = true;
    }
    return _priceLabel;
}
@end

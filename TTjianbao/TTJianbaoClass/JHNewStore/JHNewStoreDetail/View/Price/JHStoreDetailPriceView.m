//
//  JHStoreDetailPriceView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailPriceView.h"
@interface JHStoreDetailPriceView()

@property (nonatomic, strong) UIStackView *priceStackView;

@end

@implementation JHStoreDetailPriceView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self bindData];
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
    @weakify(self)
    
    [RACObserve(self.priceLabel, attributedText) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSAttributedString *att = (NSAttributedString*)x;
        self.priceLabel.hidden = att.length <= 0;
        if (x != nil && att.length > 0) {
            [self hidePriceAndSale];
        }
    }];
    [RACObserve(self.saleLabel, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *att = (NSString*)x;
        self.saleLabel.hidden = att.length <= 0;
        if (x != nil && att.length > 0) {
            [self hidePriceAndSale];
        }
    }];
}
- (void)hidePriceAndSale {
    
    CGFloat salePriceWidth = self.salePriceLabel.attributedText.size.width + 4 + LeftSpace;
    CGFloat priceWidth = self.priceLabel.attributedText.size.width + 4;
    CGFloat saleWidth = [self.saleLabel.text sizeForFont:[UIFont systemFontOfSize:10] size:CGSizeMake(ScreenW, 20) mode:NSLineBreakByClipping].width + 4;
    
    CGFloat priceMaxWidth = ScreenW - PriceRightDetailWidth - 10;
    self.priceLabel.hidden = false;
    self.saleLabel.hidden = false;
    
    if (salePriceWidth > priceMaxWidth || salePriceWidth + priceWidth > priceMaxWidth) {
        self.priceLabel.hidden = true;
        self.saleLabel.hidden = true;
    }
    if (salePriceWidth + priceWidth + saleWidth > priceMaxWidth) {
        self.saleLabel.hidden = true;
    }
    
//    if (self.salePriceLabel.attributedText.length >= 9) {
//        self.priceLabel.hidden = true;
//        self.saleLabel.hidden = true;
//    }
}
#pragma mark - setupUI
- (void) setupUI {
    [self addSubview:self.priceStackView];
}

- (void) layoutViews {
    [self.priceStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - Lazy

- (UILabel *)salePriceLabel {
    if (!_salePriceLabel) {
        _salePriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _salePriceLabel.font = [UIFont boldSystemFontOfSize:30];
        _salePriceLabel.textColor = UIColor.whiteColor;
        _salePriceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _salePriceLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:16];
        _priceLabel.textColor = [UIColor colorWithHexString:@"FFFFFF" alpha:0.7];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}
- (UILabel *)saleLabel {
    if (!_saleLabel) {
        _saleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_saleLabel jh_cornerRadius:2];
        _saleLabel.font = [UIFont systemFontOfSize:10];
        _saleLabel.textColor = [UIColor colorWithHexString:@"67411A"];
        _saleLabel.backgroundColor = [UIColor colorWithHexString:@"FAECD2"];
    }
    return _saleLabel;
}
- (UIStackView *)priceStackView {
    if (!_priceStackView) {
        _priceStackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.salePriceLabel, self.priceLabel, self.saleLabel]];
        _priceStackView.spacing = 4;
        _priceStackView.alignment = UIStackViewAlignmentLastBaseline;
        _priceStackView.distribution = UIStackViewDistributionEqualSpacing;
    }
    return _priceStackView;
}
@end

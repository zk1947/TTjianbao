//
//  JHShopHeaderView.m
//  
//
//  Created by apple on 2019/11/25.
//

#import "JHShopHeaderView.h"
#import "JHSellerInfo.h"

@interface JHShopHeaderView ()

@property (nonatomic, strong) UIButton *shopNameButton;

@end

@implementation JHShopHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setSellerInfo:(JHSellerInfo *)sellerInfo {
    _sellerInfo = sellerInfo;
    if (!_sellerInfo) {
        return;
    }
    [_shopNameButton setTitle:_sellerInfo.name forState:UIControlStateNormal];
}

- (void)initSubviews {
    _shopNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopNameButton setTitle:@"--" forState:UIControlStateNormal];
    [_shopNameButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _shopNameButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [_shopNameButton setImage:[UIImage imageNamed:@"icon_shop_img"] forState:UIControlStateNormal];
    _shopNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _shopNameButton.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    _shopNameButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_shopNameButton];
    [_shopNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@44);
    }];
}

- (void)changeHeaderViewTop:(CGFloat)headerHeight depency:(UIView *)depencyView {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(depencyView.mas_bottom).offset(headerHeight);
    }];
}

@end

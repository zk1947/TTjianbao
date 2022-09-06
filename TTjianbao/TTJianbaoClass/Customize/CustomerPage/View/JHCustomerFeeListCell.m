//
//  JHCustomerFeeListCell.m
//  TTjianbao
//
//  Created by lihui on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerFeeListCell.h"
#import "UIImageView+JHWebImage.h"
#import "JHLiveRoomModel.h"
#import "TTjianbaoMarcoUI.h"

@interface JHCustomerFeeListCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceSectionLabel;

@end

@implementation JHCustomerFeeListCell

- (void)setFeeInfo:(JHCustomerFeesInfo *)feeInfo {
    if (!feeInfo) return;
    _feeInfo = feeInfo;
    
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_feeInfo.img] placeholder:kDefaultCoverImage];
    _nameLabel.text = [_feeInfo.name isNotBlank] ? _feeInfo.name : @"暂无名称";
    _priceSectionLabel.text = [NSString stringWithFormat:@"￥%@-%@", _feeInfo.minPrice, _feeInfo.maxPrice];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    UIImageView *iconImage = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
    iconImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconImage];
    iconImage.layer.cornerRadius = 8.f;
    iconImage.layer.masksToBounds = YES;
    iconImage.clipsToBounds = YES;
    _iconImageView = iconImage;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"暂无名称";
    nameLabel.font = [UIFont fontWithName:kFontNormal size:13.];
    nameLabel.textColor = kColor333;
    [self.contentView addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"￥0-0";
    priceLabel.font = [UIFont fontWithName:kFontNormal size:11.];
    priceLabel.textColor = kColor666;
    [self.contentView addSubview:priceLabel];
    _priceSectionLabel = priceLabel;
    
    [self makeLayouts];
}

- (void)makeLayouts {
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(self.contentView.mas_height);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_priceSectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.iconImageView);
    }];
}
@end

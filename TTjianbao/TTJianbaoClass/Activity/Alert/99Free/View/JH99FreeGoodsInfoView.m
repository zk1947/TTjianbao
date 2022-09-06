//
//  JH99FreeGoodsInfoView.m
//  TTjianbao
//
//  Created by lihui on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JH99FreeGoodsInfoView.h"
#import "JHGoodsInfoMode.h"
#import "TTjianbao.h"

@interface JH99FreeGoodsInfoView ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *goodsInfoView;
@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UILabel *priceTagLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) JHGoodsInfoMode *goodsInfo;

@end

@implementation JH99FreeGoodsInfoView

- (void)setPropertys {
    self.layer.cornerRadius = 4.f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [HEXCOLOR(0xBDBFC2) CGColor];
    self.layer.borderWidth = .5f;
}

- (instancetype)initWithFrame:(CGRect)frame GoodsInfo:(JHGoodsInfoMode *)goodsInfo {
    self = [super initWithFrame:frame];
    if (self) {
        _goodsInfo = goodsInfo;
        [self setPropertys];
        [self initViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setPropertys];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *goodImageView = [[UIImageView alloc] init];
    goodImageView.contentMode = UIViewContentModeScaleAspectFill;
    _goodsImageView = goodImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"入门级-建盏";
    nameLabel.font = [UIFont fontWithName:kFontMedium size:10];
    nameLabel.textColor = kColorFFF;
    _nameLabel = nameLabel;
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = kColorFFF;
    _goodsInfoView = infoView;
    
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.text = @"特购价";
    tagLabel.font = [UIFont fontWithName:kFontNormal size:8.f];
    tagLabel.backgroundColor = HEXCOLOR(0xFF4200);
    tagLabel.textAlignment = NSTextAlignmentCenter;
    tagLabel.textColor = kColorFFF;
    tagLabel.layer.cornerRadius = 2.f;
    tagLabel.layer.masksToBounds = YES;
    _tagLabel = tagLabel;
    
    UILabel *priceTagLabel = [[UILabel alloc] init];
    priceTagLabel.text = @"￥";
    priceTagLabel.font = [UIFont fontWithName:kFontBoldDIN size:9.f];
    priceTagLabel.textColor = HEXCOLOR(0xFF4200);
    _priceTagLabel = priceTagLabel;

    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"0";
    priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:15.f];
    priceLabel.textColor = HEXCOLOR(0xFF4200);
    _priceLabel = priceLabel;
    
    [self addSubview:goodImageView];
    [goodImageView addSubview:nameLabel];
    [self addSubview:infoView];
    [_goodsInfoView addSubview:tagLabel];
    [_goodsInfoView addSubview:priceTagLabel];
    [self addSubview:priceLabel];

    [self makeLayouts];
    
    [_goodsImageView jhSetImageWithURL:[NSURL URLWithString:_goodsInfo.coverImage.url] placeholder:kDefaultCoverImage];
    _nameLabel.text = [_goodsInfo.name isNotBlank] ? _goodsInfo.name : @"";
    _priceLabel.text = [_goodsInfo.market_price isNotBlank] ? _goodsInfo.market_price : @"0";
}

- (void)makeLayouts {
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self);
        make.height.mas_equalTo(self.mas_width);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodsImageView).offset(5);
        make.bottom.trailing.equalTo(self.goodsImageView).offset(-5);
    }];
    
    [_goodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.goodsImageView.mas_bottom);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodsInfoView).offset(10);
        make.centerY.equalTo(self.goodsInfoView);
        make.size.mas_equalTo(CGSizeMake(28, 11));
    }];
    
     [_priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagLabel.mas_right).offset(5);
        make.bottom.equalTo(self.tagLabel).offset(1);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTagLabel.mas_right);
        make.centerY.equalTo(self.goodsInfoView);
//        make.right.equalTo(self.goodsInfoView).offset(-5).priority(225);
    }];
}








@end

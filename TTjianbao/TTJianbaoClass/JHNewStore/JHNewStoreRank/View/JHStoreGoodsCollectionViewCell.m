//
//  JHStoreGoodsCollectionViewCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreGoodsCollectionViewCell.h"
#import "JHStoreRankListModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+CornerRadius.h"
#import "UIView+JHGradient.h"
#import "NSString+AttributedString.h"

@interface JHStoreGoodsCollectionViewCell()
/** 图片*/
@property (nonatomic, strong) UIImageView *goodsImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 专场*/
@property (nonatomic, strong) UILabel *markLabel;

@end

@implementation JHStoreGoodsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHStoreRankProductModel *)model {
    _model = model;
    self.nameLabel.text = model.productName;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.coverImage.url] placeholderImage:[UIImage imageNamed:@"newStore_fenlei_hoderimage"]];
    
    if (model.existShow) {
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"¥ ", @"color":HEXCOLOR(0xf23730), @"font":[UIFont fontWithName:kFontNormal size:11]};
        itemsArray[1] = @{@"string":model.showPrice, @"color":HEXCOLOR(0xf23730), @"font":[UIFont fontWithName:kFontBoldDIN size:16]};
        self.priceLabel.attributedText = [NSString mergeStrings:itemsArray];
        self.markLabel.hidden = NO;
        if (model.showType == 0) {
            self.markLabel.text = @"新人价";
        } else {
            self.markLabel.text = @"专场价";
        }
    } else {
        NSMutableArray *itemsArray = [NSMutableArray array];
        itemsArray[0] = @{@"string":@"¥ ", @"color":HEXCOLOR(0xf23730), @"font":[UIFont fontWithName:kFontNormal size:11]};
        itemsArray[1] = @{@"string":model.price, @"color":HEXCOLOR(0xf23730), @"font":[UIFont fontWithName:kFontBoldDIN size:16]};
        self.priceLabel.attributedText = [NSString mergeStrings:itemsArray];
        self.markLabel.hidden = YES;
    }
}

- (void)configUI {
    [self addSubview:self.goodsImageView];
    [self.goodsImageView addSubview:self.markLabel];
    [self addSubview:self.nameLabel];
    [self addSubview:self.priceLabel];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_width);
    }];
    
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.goodsImageView);
        make.bottom.mas_equalTo(self.goodsImageView);
        make.width.mas_equalTo(36);
        make.height.mas_equalTo(14);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self.goodsImageView.mas_bottom).offset(6);
    }];

    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
    }];
}

- (UIImageView *)goodsImageView {
    if (_goodsImageView == nil) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.image = kDefaultCoverImage;
        _goodsImageView.layer.cornerRadius = 4.f;
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UILabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.text = @"";
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _markLabel.textColor = HEXCOLOR(0xffffff);
        [_markLabel jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xff6e00), HEXCOLOR(0xff0400)] locations:nil startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5)];
        [_markLabel yd_setCornerRadius:2 corners:UIRectCornerTopRight];
        _markLabel.hidden = YES;
    }
    return _markLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x222222);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _nameLabel.text = @"";
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0xf23730);
        _priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
        _priceLabel.text = @"¥";
    }
    return _priceLabel;
}

@end

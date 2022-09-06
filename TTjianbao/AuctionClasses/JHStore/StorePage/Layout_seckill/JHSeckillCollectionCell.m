//
//  JHSeckillCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillCollectionCell.h"
#import <UIColor+YYAdd.h>
#import "UIImageView+JHWebImage.h"
#import "JHGoodsInfoMode.h"
#import "TTjianbao.h"

@interface JHSeckillCollectionCell ()

@property (nonatomic, strong) UIImageView *goodImageView;       ///商品封面
//@property (nonatomic, strong) UIImageView *coverImageView;      ///封面 已结缘 已下架
@property (nonatomic, strong) UILabel *symbolLabel;             //符号
@property (nonatomic, strong) UILabel *titleLabel;              ///标题
@property (nonatomic, strong) UILabel *discountLabel;           ///折扣

@end

@implementation JHSeckillCollectionCell

+ (CGFloat)cellHeight {
    return 107;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setGoodsInfo:(JHGoodsInfoMode *)goodsInfo {
    if (!goodsInfo) return;
    _goodsInfo = goodsInfo;
    
    [_goodImageView jhSetImageWithURL:[NSURL URLWithString:_goodsInfo.coverImage.url?:@""] placeholder:[UIImage imageNamed:@""]];
    _titleLabel.text = _goodsInfo.market_price;
    _discountLabel.text = _goodsInfo.discount;
    
    /**
    if ([_goodsInfo.status intValue] == 3) {
        _coverImageView.hidden = NO;
        _coverImageView.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_off_shelf"];
    }
    else if ([_goodsInfo.status intValue] == 4) {
        _coverImageView.hidden = NO;
        _coverImageView.image = [UIImage imageNamed:@"goods_collect_list_icon_goods_sell_out"];
    }
    else {
        _coverImageView.hidden = YES;
    }
    */
    
    CGFloat discountWidth = ceilf([_goodsInfo.discount getWidthWithFont:_discountLabel.font
                                           constrainedToSize:CGSizeMake(100, 9)]);
    [_discountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(discountWidth + 5);
    }];
}

- (void)initViews {
    
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
        _goodImageView.image = [UIImage imageNamed:@""];
        _goodImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_goodImageView];
    }
    
    /**
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@""];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_coverImageView];
        _coverImageView.hidden = YES;
    }
     */
    
    if (!_symbolLabel) {
        _symbolLabel = [[UILabel alloc] init];
        _symbolLabel.text = @"￥";
        _symbolLabel.font = [UIFont fontWithName:kFontBoldDIN size:11];
        _symbolLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:_symbolLabel];
    }
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"0";
        _titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:13];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self.contentView addSubview:_titleLabel];
    }

    if (!_discountLabel) {
        _discountLabel = [[UILabel alloc] init];
        _discountLabel.text = @"0折";
        _discountLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _discountLabel.textColor = [UIColor colorWithHexString:@"FF4200"];
        _discountLabel.textAlignment = NSTextAlignmentCenter;
        _discountLabel.layer.borderColor = [UIColor colorWithHexString:@"FF4200"].CGColor;
        _discountLabel.layer.borderWidth = .5f;
        _discountLabel.layer.cornerRadius = 2.f;
        [self.contentView addSubview:_discountLabel];
    }
    
    [_discountLabel layoutIfNeeded];
    [self makeLayouts];
}

#pragma mark -
- (void)makeLayouts {
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(77, 77));
    }];
    
    /**
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.goodImageView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
     */
    
    [_symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.goodImageView.mas_bottom).offset(7);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.symbolLabel.mas_right);
        make.bottom.equalTo(self.symbolLabel);
    }];
    
    [_discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).offset(3);
        make.width.mas_equalTo(32);
    }];
}




@end

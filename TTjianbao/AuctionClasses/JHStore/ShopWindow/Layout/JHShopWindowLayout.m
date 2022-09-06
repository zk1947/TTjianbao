//
//  JHShopWindowLayout.m
//  TTjianbao
//
//  Created by apple on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopWindowLayout.h"
#import "TTjianbaoHeader.h"

#define kGoodsCellMaxWidth  ((ScreenW - 25)*0.5 - 25)
#define kGoodsCellMinWidth  30

@implementation JHShopWindowLayout

- (instancetype)initWithModel:(JHGoodsInfoMode *)model {
    self = [super init];
    if (self) {
        _goodsInfo = model;
        [self makeLayout];
    }
    return self;
}

- (void)makeLayout {
    CGFloat allHeight = 0;
    _imageWidth = (ScreenWidth-25)*0.5;
    CGFloat scale = (float)_goodsInfo.coverImage.width/_goodsInfo.coverImage.height;
    scale = [[NSString stringWithFormat:@"%.2f", scale] floatValue];
    if (scale >= 1) {
        _imageHeight = _imageWidth;
    }
    else if (scale < 0.75) {
        _imageHeight = _imageWidth*4/3;
    }
    else {
        _imageHeight = _imageWidth/scale;
    }
    
    allHeight += _imageHeight;
    
    _titleHeight = [_goodsInfo.name getHeightWithFont:[UIFont fontWithName:kFontMedium size:13] constrainedToSize:CGSizeMake(_imageWidth - 10, 18)];
    
    allHeight += _titleHeight;

    _descHeight = [_goodsInfo.desc getHeightWithFont:[UIFont fontWithName:kFontNormal size:12] constrainedToSize:CGSizeMake(_imageWidth - 10, MAXFLOAT)];
    _descHeight = _descHeight > 34 ? 34 : _descHeight;
    
    allHeight += _descHeight;

    _curPriceWidth = [_goodsInfo.market_price getWidthWithFont:[UIFont fontWithName:kFontBoldDIN size:15] constrainedToSize:CGSizeMake(MAXFLOAT, 16)]+5;
    _oriPriceWidth = [_goodsInfo.flash_sale_tag getWidthWithFont:[UIFont fontWithName:kFontNormal size:10] constrainedToSize:CGSizeMake(MAXFLOAT, 14)]+10;
    _discountWidth = [_goodsInfo.discount getWidthWithFont:[UIFont fontWithName:kFontNormal size:10] constrainedToSize:CGSizeMake(MAXFLOAT, 14)];
    ///标签的宽度计算
    _tagWidth = [self caculateTagWidth:_goodsInfo.tag_name];
        
    _imgTitleSpace = 10;
    _titleDescSpace = 7;
    _descPriceSpace = 7;
    _space = 10;
    allHeight += 16;
    
    allHeight += _imgTitleSpace +_titleDescSpace + _descPriceSpace + _space;
    
    _cellHeight = allHeight;
}

///计算标签的宽度
- (CGFloat)caculateTagWidth:(NSString *)str {
    CGFloat strWidth = [str getWidthWithFont:[UIFont fontWithName:kFontNormal size:11] constrainedToSize:CGSizeMake(MAXFLOAT, 23)];
    if (strWidth > kGoodsCellMaxWidth) {
        return kGoodsCellMaxWidth;
    }
    if (strWidth < kGoodsCellMinWidth) {
        return kGoodsCellMinWidth;
    }
    return strWidth + 8;
}

@end

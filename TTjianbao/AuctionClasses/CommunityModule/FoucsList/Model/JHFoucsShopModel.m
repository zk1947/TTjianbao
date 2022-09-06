//
//  JHFoucsShopModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFoucsShopModel.h"


#pragma mark - 店铺推荐商品详情
@implementation JHFoucsShopProductInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"coverImage" : [ProductImageInfo class],
    };
}
//- (void)setPrice:(NSString *)price {
//    double d            = [price doubleValue];
//    NSString *dStr      = [NSString stringWithFormat:@"%f", d];
//    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//    _price = [dn stringValue];
//}
//- (void)setShowPrice:(NSString *)showPrice {
//    double d            = [showPrice doubleValue];
//    NSString *dStr      = [NSString stringWithFormat:@"%f", d];
//    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//    _showPrice = [dn stringValue];
//}

- (void)setProductName:(NSString *)productName {
    _productName = productName;
    NSDictionary *attrs = @{NSFontAttributeName :[UIFont fontWithName:kFontMedium size:12]};
    CGSize maxSize = CGSizeMake((ScreenW - 40)/3, MAXFLOAT);
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    // 计算文字占据的宽高
    CGSize size = [_productName boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    _titleHeight = size.height < 34 ? size.height : 34;
}

- (CGFloat)height {
    return (ScreenW - 40)/3 + _titleHeight+7+8;
}

//- (long long)countDownTime {
//    return self.offline_at - self.server_at;
//}
@end




@interface JHFoucsShopInfo ()

@property (nonatomic, assign) CGFloat maxHeight;

@end


@implementation JHFoucsShopInfo


- (instancetype)init {
    self = [super init];
    if (self) {
        _maxHeight = 0;
    }
    return self;
}

- (void)setGoodsArray:(NSArray<JHFoucsShopProductInfo *> *)goodsArray {
    _goodsArray = goodsArray;
    for (JHFoucsShopProductInfo *model in _goodsArray) {
        if (model.titleHeight > _maxHeight) {
            _maxHeight = model.titleHeight;
        }
    }
    CGFloat itemWidth = (ScreenW - 40) / 3;
    _cellheight = _maxHeight + itemWidth + 55 + 25;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"goodsArray" : @"productList",
        @"sellerId" : @"id",
    };
}

/* 实现该方法，说明数组中存储的模型数据类型 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"goodsArray" : [JHFoucsShopProductInfo class]
    };
}


- (void)setShopLogoImg:(NSString *)shopLogoImg {
    _shopLogoImg = [shopLogoImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setShopBgImg:(NSString *)shopBgImg {
    _shopBgImg = [shopBgImg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end

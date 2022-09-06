//
//  JHLastSaleGoodsModel.m
//  TTjianbao
//  
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLastSaleGoodsModel.h"

@implementation JHLastSaleGoodsModel

- (NSString*)dealPrice
{
    if (_dealPrice) {
        double d = [_dealPrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _dealPrice = [dn stringValue];
    }
    return _dealPrice;
}

- (NSString*)salePrice
{
    if (_salePrice) {
        double d = [_salePrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _salePrice = [dn stringValue];
    }
    return _salePrice;
}

- (NSString*)purchasePrice
{
    if (_purchasePrice) {
        double d = [_purchasePrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _purchasePrice = [dn stringValue];
    }
    return _purchasePrice;
}

@end

@implementation JHLastSaleGoodsRespModel

+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"data" : [JHLastSaleGoodsModel class]
             };
}

@end

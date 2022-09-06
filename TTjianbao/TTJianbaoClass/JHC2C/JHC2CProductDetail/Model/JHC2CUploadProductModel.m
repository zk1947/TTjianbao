//
//  JHC2CUploadProductModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadProductModel.h"

@implementation JHC2CUploadProductModel

- (NSDictionary *)changePar{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    dic[@"firstCategoryId"] = self.firstCategoryId;
    dic[@"secondCategoryId"] = self.secondCategoryId;
    dic[@"thirdCategoryId"] = self.thirdCategoryId;

    dic[@"productDesc"] = self.productDesc;
    dic[@"productType"] = [NSNumber numberWithInteger:self.productType];
    dic[@"identify"] = [NSNumber numberWithInteger:self.identify];
    dic[@"auction"] = self.auctionDic;
    dic[@"price"] = self.priceDic;
    dic[@"mainImageUrl"] = self.mainImageUrlArr;
    dic[@"detailImages"] = self.detailImagesArr;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    [self.attrsDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"attrId"] = key;
        dic[@"attrValue"] = obj;
        [arr addObject:dic];
    }];
    dic[@"attrs"] = arr;

    if (self.productId > 0) {
        dic[@"productId"] = @(self.productId);
    }
    
    return dic;
}
@end

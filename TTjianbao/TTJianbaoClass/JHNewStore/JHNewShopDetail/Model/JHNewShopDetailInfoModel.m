//
//  JHNewShopDetailInfoModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailInfoModel.h"

@implementation JHNewShopDetailCouponListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"couponId" : @"id"};
}
@end

@implementation JHNewShopDetailShareInfoModel

@end

@implementation JHNewShopBusinessCategory
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cateId" : @"id"};
}

@end

@implementation JHNewShopDetailInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"shopId" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"couponList" : @"JHNewShopDetailCouponListModel",
        @"backCateResponses" : [JHNewShopBusinessCategory class]
    };
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues {
    ///假如未认证就变更
    if(_authStatus <= 0) {
        _sellerType = 0;
    }
}
@end

//
//  JHStoreDetailModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailModel.h"

@implementation JHProductAuctionFlowModel

@end
#pragma mark - 图片详情
@implementation ProductImageInfo

@end
#pragma mark - 商品规格详情
@implementation ProductSpecInfo 
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

#pragma mark - 分享详情
@implementation ProductShareInfo

@end

#pragma mark - 店铺推荐商品详情
@implementation ShopProductInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"coverImage" : [ProductImageInfo class],
    };
}
@end

#pragma mark - 店铺详情
@implementation ProductShopInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"shopProductList" : [ShopProductInfo class],
    };
}
- (void)setOrderGrades:(NSString *)orderGrades {
    double d            = [orderGrades doubleValue] * 100;
    NSString *dStr      = [NSString stringWithFormat:@"%.2f", d] ;
//    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//    NSDecimalNumberHandler *handler = [[NSDecimalNumberHandler alloc]
//                                       initWithRoundingMode:NSRoundPlain
//                                       scale:2
//                                       raiseOnExactness:false
//                                       raiseOnOverflow:false
//                                       raiseOnUnderflow:false
//                                       raiseOnDivideByZero:false];
//    NSDecimalNumber *newdn = [dn decimalNumberByRoundingAccordingToBehavior:handler];
    _orderGrades = dStr; // [newdn stringValue];
}

- (void)addFollowNum {
    int d = [self.followNum intValue] + 1;
    self.followNum = [NSString stringWithFormat:@"%d", d];
}
- (void)minusFollowNum {
    int d = [self.followNum intValue] - 1;
    self.followNum = [NSString stringWithFormat:@"%d", d];
}
@end

#pragma mark - 专场详情
@implementation ProductSpecialShowInfo
- (void)setShowDiscount:(NSString *)showDiscount {
    double d            = [showDiscount doubleValue];
    NSString *dStr      = [NSString stringWithFormat:@"%f", d] ;
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    _showDiscount = [dn stringValue];
}

- (void)addRemindCount {
    int d = [self.showRemindCount intValue] + 1;
    self.showRemindCount = [NSString stringWithFormat:@"%d", d];
}
@end

@implementation JHStoreDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productAttrList" : [ProductSpecInfo class],
        @"detailImages" : [ProductImageInfo class],
//        @"detailImageMiddleUrl" : [ProductImageInfo class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"shopInfo" : @"productDetailShopResponse",
             @"specialShowInfo" : @"productDetailShowResponse",
            };
}
@end


@implementation JHStoreCommentModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"datas" : [JHAudienceCommentMode class],
    };
}
@end


@implementation JHProductIntrductModel

@end


@implementation JHB2CAuctionRefershModel

@end



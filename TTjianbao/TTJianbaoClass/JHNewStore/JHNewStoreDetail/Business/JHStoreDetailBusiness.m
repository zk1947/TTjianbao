//
//  JHStoreDetailBusiness.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailBusiness.h"
#import "NSObject+YYModel.h"
@implementation JHStoreDetailBusiness


/// 获取商品详情信息
/// productId : 商品ID
+ (void)getStoreDetailInfoWithProductId : (NSString *)productId
                            successBlock:(detailInfoBlock) success
                            failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"productId" : productId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/detail");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        JHStoreDetailModel *model = [JHStoreDetailModel mj_objectWithKeyValues:dic];
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 获取订单快照信息
/// orderd : 订单ID
+ (void)getStoreSnapShootWithOrderId : (NSString *)orderId
                            successBlock:(snapShootDetailInfoBlock) success
                            failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"orderId" : orderId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/detailSnapshot");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        JHStoreSnapShootDetailModel *model = [JHStoreSnapShootDetailModel mj_objectWithKeyValues:dic];
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 收藏商品
/// productId : 商品ID
+ (void)followProduct : (NSString *)productId
          successBlock:(succeedBlock) success
          failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"productId" : productId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/follow");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 取消收藏商品
/// productId : 商品ID
+ (void)followCancelProduct : (NSString *)productId
                successBlock:(succeedBlock) success
                failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"productId" : productId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/followCancel");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 店铺关注、取关
/// couponId : 优惠券ID
/// type : 关注类型: 1关注 0取关
+ (void)shopFollowWithShopId : (NSString *)shopId
                        type : (NSString *) type
                successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"shopId" : shopId,
                          @"type" : type};
    
    NSString *url = FILE_BASE_STRING(@"/auth/mall/shop/follow");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 开售提醒
/// productId : 商品ID
+ (void)salesRemindWithProductId : (NSString *)productId
                successBlock:(succeedBlock) success
                     failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"productId" : productId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/show/product/salesReminder");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 获取优惠券列表
/// sellerId : 商家ID
+ (void)couponlistWithSellerId : (NSString *)sellerId
                successBlock:(couponInfoBlock) success
                    failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"sellerId" : sellerId};
    NSString *url = FILE_BASE_STRING(@"/api/mall/coupon/shopVoucher");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        NSArray *list = [JHStoreDetailCouponModel mj_objectArrayWithKeyValuesArray:dic];
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 领取优惠券
/// couponId : 优惠券ID
+ (void)receiveCouponWithID : (NSString *)couponId
                successBlock:(couponReceiveInfoBlock) success
             failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"id" : couponId};
    NSString *url = FILE_BASE_STRING(@"/auth/mall/coupon/receiveCouponById");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        JHStoreDetailReceiveCouponModel *model = [JHStoreDetailReceiveCouponModel mj_objectWithKeyValues:dic];
        
        success(model);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil ) { return; }
        failure(respondObject);
    }];
}


+ (void)requestCommentListWithSellerID:(NSString*)sellerId  completion:(void (^)(NSError * _Nullable error, JHStoreCommentModel* _Nullable model))completion{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/list?sellerCustomerId=%@&pageNo=0&pageSize=5&tagCode=all"), sellerId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHStoreCommentModel *model = [JHStoreCommentModel mj_objectWithKeyValues:respondObject.data];
        completion(nil, model);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(error, nil);
    }];
}


+ (void)requestTagsWithSellerID:(NSString*)sellerId  completion:(void (^)(NSError * _Nullable error, NSArray<CommentTagMode *>* _Nullable arr))completion{
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderComment/countByTag?sellerCustomerId=%@"), sellerId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *arr =  [CommentTagMode  mj_objectArrayWithKeyValuesArray:respondObject.data];
        completion(nil, arr);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(error, nil);
    }];
}



+ (void)requestSameShopGoodProduct:(NSString *)productID shopId:(NSString *)shopId completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"shopId"] = shopId;
    par[@"productId"] = productID;
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/search/sameShopGoodProduct") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *arr =  [JHNewStoreHomeGoodsProductListModel  mj_objectArrayWithKeyValuesArray:respondObject.data];
        completion(nil, arr);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];


}

+ (void)requestRecommendProductGoodProduct:(NSString *)productID page:(NSInteger)page completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    User *user = UserInfoRequestManager.sharedInstance.user;
    par[@"customerId"] = user.customerId;
    par[@"productId"] = productID;
    par[@"pageSize"] = @20;
    par[@"pageNo"] = @(page);

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/search/forYouRecommendProduct") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *arr =  [JHNewStoreHomeGoodsProductListModel  mj_objectArrayWithKeyValuesArray:respondObject.data];
        completion(nil, arr);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];


}


+ (void)requestQueryAttrDecsContentByAttrId:(NSString*)attrId  completion:(void (^)(NSError * _Nullable error, JHProductIntrductModel* _Nullable model))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"id"] = attrId;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/attr/queryAttrDecsContentByAttrId") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHProductIntrductModel *model =  [JHProductIntrductModel  mj_objectWithKeyValues:respondObject.data];
        completion(nil, model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}



+ (void)requestDelComment:(NSString *)commentID completion:(void (^)(NSError * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"id"] = commentID;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderComment/auth/delete") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];

}

+ (void)requestProductDetailPaiMai:(NSString *)auctionSn completion:(void (^)(NSError * _Nullable, JHB2CAuctionRefershModel * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"auctionSn"] = auctionSn;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/b2c/auction/refresh") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHB2CAuctionRefershModel *model = [JHB2CAuctionRefershModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}



+ (void)requestB2CSetPriceProductSn:(NSString *)productSn andPrice:(NSString*)price isDelegate:(BOOL)delegate completion:(void (^)(NSError * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productSn"] = productSn;
    par[@"agent"] = delegate ? @"1" : @"0";
    par[@"price"] = price;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/auction") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHStoreDetailViewController_auctionRefershData" object:nil userInfo:@{@"fromRefresh": @NO}];
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}


+ (void)requestB2CCancleSetPriceProductSn:(NSString *)productSn completion:(void (^)(NSError * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productSn"] = productSn;

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/auction/cancel") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            [NSNotificationCenter.defaultCenter postNotificationName:@"JHStoreDetailViewController_auctionRefershData" object:nil userInfo:@{@"fromRefresh": @NO}];
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}

@end

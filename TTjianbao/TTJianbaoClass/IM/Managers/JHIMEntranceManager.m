//
//  JHIMEntranceManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIMEntranceManager.h"
#import "JHChatBusiness.h"

@implementation JHIMEntranceManager
#pragma mark - Public
/// 调起客服
/// userId : 对方用户ID - customerId
/// sourceType : 来源
+ (void)pushSessionWithUserId : (NSString *)userId
                   sourceType : (JHIMSourceType)sourceType{
    
    [JHIMEntranceManager getServeceWithUserId:userId
                                      account:nil
                                   sourceType:sourceType
                                    goodsInfo:nil
                                    orderInfo:nil
                                  isPlatform : true];
}
/// 调起客服
/// account : 对方accid
/// sourceType : 来源
+ (void)pushSessionWithAccount : (NSString *)account
                    sourceType : (JHIMSourceType)sourceType{
    
    [JHIMEntranceManager getServeceWithUserId:nil
                                      account:account
                                   sourceType:sourceType
                                    goodsInfo:nil
                                    orderInfo:nil
                                  isPlatform : true];
}
/// 调起客服
/// userId : 对方用户ID - customerId
/// goodsInfo : 商品信息
+ (void)pushSessionWithUserId : (NSString *)userId
                   sourceType : (JHIMSourceType)sourceType
                    goodsInfo : (JHChatGoodsInfoModel *)goodsInfo{
    
    [JHIMEntranceManager getServeceWithUserId:userId
                                      account:nil
                                   sourceType:sourceType
                                    goodsInfo:goodsInfo
                                    orderInfo:nil
                                  isPlatform : true];
}
/// 调起客服
/// userId : 对方用户ID - customerId
/// orderInfo : 订单信息
+ (void)pushSessionWithUserId : (NSString *)userId
                    orderInfo : (JHChatOrderInfoModel *)orderInfo{
    
    [JHIMEntranceManager getServeceWithUserId:userId
                                      account:nil
                                   sourceType:JHIMSourceTypeC2COrderDetail
                                    goodsInfo:nil
                                    orderInfo:orderInfo
                                  isPlatform :true];
}
/// 调起客服
/// userId : 对方用户ID - customerId
/// orderInfo : 订单信息
/// isBusiness : 对方是否为商家
+ (void)pushSessionOrderWithUserId : (NSString *)userId
                         orderInfo : (JHOrderDetailMode *)orderInfo{
    
    [JHChatBusiness getServeceWithUserId : userId successBlock:^(RequestModel * _Nullable respondObject) {
        NSUInteger code = [respondObject.data integerValue];
        if (code == 1) {
            
            JHChatOrderInfoModel *model = [JHIMEntranceManager getChatOrderInfoWith:orderInfo];
            if (![JHIMEntranceManager canSendOrder:orderInfo]) {
                model = nil;
            }
            
            [JHIMEntranceManager pushSessionWithUserId:userId
                                               account:nil
                                            sourceType:JHIMSourceTypeOrderDetail
                                             goodsInfo:nil
                                             orderInfo:model];
        }else {
            if (orderInfo) {
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:orderInfo];
            }else {
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] anchorId:userId];
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {

    }];
}
+ (BOOL)canSendOrder : (JHOrderDetailMode *)orderInfo{
    NSString *category = orderInfo.orderCategory;
    NSArray *categorys = @[@"restoreIntentionOrder",
                           @"restoreProcessingGoods",
                           @"restoreZeroOrder",
                           @"resaleOrder",
                           @"resaleIntentionOrder",
                           @"appraisalOrder",
                           @"recycleOrder"];
    
    return ![categorys containsObject:category];
}
#pragma mark - Private

+ (void)getServeceWithUserId : (NSString *)userId
                     account : (NSString *)account
                  sourceType : (JHIMSourceType)sourceType
                   goodsInfo : (JHChatGoodsInfoModel *)goodsInfo
                   orderInfo : (JHChatOrderInfoModel *)orderInfo
                  isPlatform : (BOOL) isPlatform{
    
    if (sourceType == JHIMSourceTypeSessionCenter ||
        sourceType == JHIMSourceTypeC2CGoodsDetail ||
        sourceType == JHIMSourceTypeC2COrderDetail) {
        
        [JHIMEntranceManager pushSessionWithUserId:userId
                                           account:account
                                        sourceType:sourceType
                                         goodsInfo:goodsInfo
                                         orderInfo:orderInfo];
        return;
    }
    
    [JHChatBusiness getServeceWithUserId : userId successBlock:^(RequestModel * _Nullable respondObject) {
        NSUInteger code = [respondObject.data integerValue];
        if (code == 1) {
            [JHIMEntranceManager pushSessionWithUserId:userId
                                               account:account
                                            sourceType:sourceType
                                             goodsInfo:goodsInfo
                                             orderInfo:orderInfo];
        }else {
            if (isPlatform && sourceType != JHIMSourceTypeLive) {
                [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
            }else {
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] anchorId:userId];
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {

    }];
}
/// 跳转客服
/// userId :用户ID
/// account : 用户AccID
/// sourceType : 来源
/// goodsInfo : 商品信息
/// orderInfo : 订单信息
/// isBusiness : 是否是商家
+ (void)pushSessionWithUserId : (NSString *)userId
                      account : (NSString *)account
                   sourceType : (JHIMSourceType)sourceType
                    goodsInfo : (JHChatGoodsInfoModel *)goodsInfo
                    orderInfo : (JHChatOrderInfoModel *)orderInfo{
    
    UIViewController *current = [JHIMEntranceManager getCurrentVC];
    if (![JHIMEntranceManager isLogin:current]) return;
    
    JHSessionViewController * session = [[JHSessionViewController alloc] init];
    if (userId.length > 0) {
        session.userId = userId;
    }else {
        session.receiveAccount = account;
    }
    
    if (goodsInfo) {
        session.goodsInfo = goodsInfo;
    }
    if (orderInfo) {
        session.orderInfo = orderInfo;
    }
    session.sourceType = sourceType;
    
    [current.navigationController pushViewController:session animated: true];
}
+ (UIViewController *)getCurrentVC {
    return [JHRootController currentViewController] ?: UIApplication.sharedApplication.keyWindow.rootViewController;
}

+ (BOOL)isLogin : (UIViewController *)vc {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:vc complete:^(BOOL result) {
        }];
        return false;
    }
    return true;
}
+ (JHChatOrderInfoModel *)getChatOrderInfoWith : (JHOrderDetailMode *)orderInfo {
    JHChatOrderInfoModel *model = [[JHChatOrderInfoModel alloc] init];

    model.title = orderInfo.goodsTitle;
    model.price = orderInfo.orderPrice;
    model.orderDate = orderInfo.orderCreateTime;
    model.orderId = orderInfo.orderId;
    model.orderCode = orderInfo.orderCode;
    
    if (orderInfo.goodsImgs.count > 0) {
        model.iconUrl = orderInfo.goodsImgs[0].medium;
    }else {
        model.iconUrl = orderInfo.goodsUrl;
    }
    
    model.orderLoadingCategory = @"normal";
    model.orderStatus = orderInfo.orderStatus;
    model.customerId = orderInfo.buyerCustomerId;
    model.sellerCustomerId = orderInfo.sellerCustomerId;
    
    model.orderStatusDescBuyer = [orderInfo orderStatusExt:orderInfo.orderStatus isBuyer:true];;
    model.orderStatusDescSeller = [orderInfo orderStatusExt:orderInfo.orderStatus isBuyer:false];;

    return model;
}
@end

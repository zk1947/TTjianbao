//
//  JHStoreDetailFunctionViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品功能区ViewModel

#import <Foundation/Foundation.h>
#import "UIColor+ColorChange.h"
#import "JHStoreDetailModel.h"

typedef NS_ENUM(NSUInteger, PurchaseState) {
    /// 立即购买
    PurchaseStateBuy = 1,
    /// 开售提醒
    PurchaseStateSalesRemind,
    /// 已设置提醒
    PurchaseStateSalesReminded,
    /// 已下架
    PurchaseStateOff,
    /// 已抢光
    PurchaseStateSoldout,
    /// 不可立即购买
    PurchaseStateCantBuy,
    
    ///拍卖 已结束 流拍
    PurchaseStateFinish,
    ///拍卖   已成交
    PurchaseStateFinish_Soldout,
    ///拍卖    拍卖中 无状态或未领先
    PurchaseStateAuction_Selling,
    ///拍卖   拍卖中 领先
    PurchaseStateAuction_Selling_LingXian,

};

typedef NS_ENUM(NSUInteger, JHStoreDetailFunctionView_Type) {
    JHStoreDetailFunctionView_Type_Normal = 0,
    JHStoreDetailFunctionView_Type_Auction,
    JHStoreDetailFunctionView_Type_RushPurchase,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailFunctionViewModel : NSObject

@property (nonatomic, assign) PurchaseState purchaseStatus;
/// 购买按钮背景色
@property (nonatomic, strong) RACReplaySubject<RACTuple *> *buyBackgroundColor;
/// 收藏按钮图片 0 未收藏 1已收藏
@property (nonatomic, assign) BOOL collectState;
/// 店铺事件
@property (nonatomic, strong) RACSubject *shopAction;
/// 客服事件
@property (nonatomic, strong) RACSubject *serviceAction;
/// 收藏事件
@property (nonatomic, strong) RACSubject *collectAction;
/// 购买事件
@property (nonatomic, strong) RACSubject *buyAction;
/// 设置代理
@property (nonatomic, strong) RACSubject *agentSetAction;
/// 立即出价
@property (nonatomic, strong) RACSubject *buyPriceAction;
/// 券后价格
@property(nonatomic, copy) NSString * discountPrice;

/// 拍卖信息
@property(nonatomic, strong) JHProductAuctionFlowModel * detailAuModel;

/// 拍卖信息
@property(nonatomic, strong) JHB2CAuctionRefershModel * auModel;

/// type
@property(nonatomic) JHStoreDetailFunctionView_Type  functionView_type;

@end

NS_ASSUME_NONNULL_END

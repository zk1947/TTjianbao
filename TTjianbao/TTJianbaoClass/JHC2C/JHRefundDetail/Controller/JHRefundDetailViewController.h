//
//  JHRefundDetailViewController.h
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  查看退款详情

#import <UIKit/UIKit.h>
#import "JHChatOrderInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundDetailViewController : JHBaseViewController
///订单编号
@property (nonatomic, copy) NSString *orderId;
/// 订单编号
@property (nonatomic, copy) NSString *orderCode;
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
///订单状态code
@property (nonatomic, copy) NSString *orderStatusCode;
///用户标记 1：买家 2：卖家
@property (nonatomic, assign) NSInteger customerFlag;
///监听成功回调刷新
@property (nonatomic, strong) RACSubject *needRefreshSubject;

/// 对方ID -accId customerId  二者传其一即可
@property (nonatomic, copy) NSString *receiveaAccount;
/// 用户ID - customerId
@property (nonatomic, copy) NSString *userId;
/// 订单信息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;


@end

NS_ASSUME_NONNULL_END

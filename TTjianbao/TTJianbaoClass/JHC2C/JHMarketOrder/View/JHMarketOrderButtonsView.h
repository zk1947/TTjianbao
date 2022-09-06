//
//  JHMarketOrderButtonsView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHMarketOrderModel.h"

typedef enum : NSUInteger {
    MarketOrderButtonTagDelete = 100,          //删除
    MarketOrderButtonTagContactBuyer,          //联系卖家
    MarketOrderButtonTagContactSeller,         //联系买家
    MarketOrderButtonTagClose,                 //交易关闭
    MarketOrderButtonTagCancel,                //取消订单
    MarketOrderButtonTagRefund,                //申请退款
    MarketOrderButtonTagChangePrice,           //修改价格
    MarketOrderButtonTagPay,                   //立即支付
    MarketOrderButtonTagRefundDetail,          //查看退款详情
    MarketOrderButtonTagDispatch,              //去发货
    MarketOrderButtonTagLogistics,             //查看物流
    MarketOrderButtonTagRemindDispatch,        //提醒收货
    MarketOrderButtonTagRemindRecieve,         //提醒发货
    MarketOrderButtonTagReceived,              //确认收货
    MarketOrderButtonTagComment,               //我要评价
    MarketOrderButtonTagAddExp,               //填写物流订单
    MarketOrderButtonTagPlatform,               //平台接入结果
} MarketOrderButtonTag;

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderButtonsView : BaseView
/** 按钮展示模型*/
//@property (nonatomic, strong) JHRecycleButtonsModel *buttonModel;
/** 订单id*/
@property (nonatomic, copy) NSString *orderId;
/** 通知上层刷新数据*/
@property (nonatomic, copy) void(^reloadDataBlock)(BOOL iSdelete);
// 订单详情的model
@property (nonatomic, strong) JHMarketOrderModel *orderModel;
// 是否是买家
@property (nonatomic, assign) BOOL isBuyer;
/** 点击了支付按钮*/
@property (nonatomic, copy) void(^payButtonClick)(void);
@end

NS_ASSUME_NONNULL_END

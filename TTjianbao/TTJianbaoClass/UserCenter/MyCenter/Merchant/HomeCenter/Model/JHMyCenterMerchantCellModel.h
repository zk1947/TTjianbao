//
//  JHMyCenterMerchantCellModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMyCenterMerchantContentView.h"

typedef NS_ENUM(NSInteger, JHMyCenterMerchantCellType)
{
    /// 签约
    JHMyCenterMerchantCellTypeUnionSign = 0,
    /// 订单
    JHMyCenterMerchantCellTypeOrder = 1,
    ///资金管理
    JHMyCenterMerchantCellTypeMoney,
    /// 订单
    JHMyCenterMerchantCellTypeCustomize,
    /// 原石回血
    JHMyCenterMerchantCellTypeResale,
    ///回收
    JHMyCenterMerchantCellTypeRecyle,
    /// 店铺工具
    JHMyCenterMerchantCellTypeShop,
    ///开通新服务
    JHMyCenterMerchantCellTypeOpenNewService,
    ///没有开通直播的空白页面
    JHMyCenterMerchantCellTypeLivingBlank,
};

typedef NS_ENUM(NSInteger, JHMyCenterMerchantPushType)
{
    /// 订单系列
    /// 待付款
    JHMyCenterMerchantPushTypeOrderWillPay = 1,
    /// 待发货
    JHMyCenterMerchantPushTypeOrderWillSendGoods = 2,
    /// 已发货
    JHMyCenterMerchantPushTypeOrderDidSentGoods = 3,
    /// 售后
    JHMyCenterMerchantPushTypeOrderAfterSale = 4,
    
    /// 原石回血系列
    /// 待上架
    JHMyCenterMerchantPushTypeReSaleWillSale = 5,
    /// 最近出售
    JHMyCenterMerchantPushTypeReSaleDidSale = 6,
    /// 寄售
    JHMyCenterMerchantPushTypeReSaleSendSale = 7,
    /// 零钱
    JHMyCenterMerchantPushTypeReSaleWallet = 8,
    /// 寄回
    JHMyCenterMerchantPushTypeReSaleReturn = 9,
    /// 原石订单
    JHMyCenterMerchantPushTypeReSaleOrder = 10,
    
    ///回收相关
    ///待付款
    JHMyCenterMerchantPushTypeRecyleWillPay = 11,
    ///待发货
    JHMyCenterMerchantPushTypeRecyleWillSend = 12,
    ///待收货
    JHMyCenterMerchantPushTypeRecyleDidSend = 13,
    ///待确认价格
    JHMyCenterMerchantPushTypeRecyleWillConfirmPrice = 14,
    ///仲裁查看
    JHMyCenterMerchantPushTypeRecyleArbitration = 15,
    
    /// 店铺工具
    ///商学院
    JHMyCenterMerchantPushTypeMerchantCollege = 16,
    /// 评价管理
    JHMyCenterMerchantPushTypeShopOrderComment = 17,
    /// 订单导出
    JHMyCenterMerchantPushTypeShopOrderOut = 18,
    /// 代金券管理
    JHMyCenterMerchantPushTypeShopCoupon = 19,
    /// 问题单
    JHMyCenterMerchantPushTypeShopOrderQuestion = 20,
    /// 心愿单
    JHMyCenterMerchantPushTypeShopOrderWish = 21,
    /// 禁言
    JHMyCenterMerchantPushTypeShopMute = 22,
    /// 直播回放记录
    JHMyCenterMerchantPushTypeShopRePlay = 23,
    /// 培训直播
    JHMyCenterMerchantPushTypeShopTrain = 24,
    /// 助理管理
    JHMyCenterMerchantPushTypeShopAssistant = 25,
    ///会话设置
    JHMyCenterMerchantPushTypeChatSetting = 26,
    ///粉丝团设置
    JHMyCenteBusinessFansSettingManager = 27,

    /// 资金管理
    JHMyCenterMerchantPushTypeMoneyManger = 28,
    
    /// 定制待接单
    JHMyCenterMerchantPushTypeCustomizeOrderWillAccept = 29,
    
    /// 定制待付款
    JHMyCenterMerchantPushTypeCustomizeOrderWillPay = 30,
    
    /// 定制方案中
    JHMyCenterMerchantPushTypeCustomizeOrderPlanning = 31,
    
    /// 定制制作中
    JHMyCenterMerchantPushTypeCustomizeOrderMaking = 32,
    /// 定制待发货
    JHMyCenterMerchantPushTypeCustomizeOrderWillSend = 33,
    /// 回收池
    JHMyCenterMerchantPushTypeRecyclingPool = 34,
    /// 商家资质信息
    JHMyCenterMerchantPushTypeUserAuth = 35,
    
    /// 店铺数据
    JHMyCenterMerchantPushTypeShopLastDayData = 36,
    /// 客服管理
    JHMyCenterMerchantPushTypeShopServiceData = 37,
    /// 我的参拍
    JHMyCenterMerchantPushTypeCompeteDayData = 38,
    
    /// 商品管理
    JHMyCenterMerchantPushTypeGoodsManageDayData = 39,

    ///活动报名入口
    JHMyCenteBusinessActivityEntryManager = 40,
    
    ///福带
    JHMyCenteBusinessActivityFuDai = 41,

};

NS_ASSUME_NONNULL_BEGIN
@class JHMyCenterMerchantCellButtonModel;
@interface JHMyCenterMerchantCellModel : NSObject
@property (nonatomic, assign) JHMyCenterMerchantCellType cellType;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;
@end

@interface JHMyCenterMerchantCellButtonModel : NSObject

@property (nonatomic, assign) NSInteger messageCount;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) JHMyCenterMerchantPushType cellType;
///记录是直播还是商城
@property (nonatomic, assign) JHMyCenterContentType contentType;

/// 跳转
- (void)pushViewController;

/// 跳转 社区商家认证
+ (void)pushSocialAuthViewController;

+ (JHMyCenterMerchantCellButtonModel *)creatWithMessageCount:(NSInteger)messageCount icon:(NSString *)icon title:(NSString *)title type:(JHMyCenterMerchantPushType)type;
+ (JHMyCenterMerchantCellButtonModel *)creatWithMessageCount:(NSInteger)messageCount icon:(NSString *)icon title:(NSString *)title type:(JHMyCenterMerchantPushType)type contentType:(JHMyCenterContentType)contentType;
@end

NS_ASSUME_NONNULL_END

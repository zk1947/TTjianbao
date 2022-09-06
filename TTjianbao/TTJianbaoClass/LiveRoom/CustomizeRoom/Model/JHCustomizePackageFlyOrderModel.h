//
//  JHCustomizePackageFlyOrderModel.h
//  TTjianbao
//
//  Created by user on 2021/1/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 创建 常规+定制 套餐
@class JHCreateCustomizeFeeListModel;
@interface JHCreateCustomizeNormalRequestModel : NSObject
@property (nonatomic,   copy) NSString *addressId;       /// 收货地址id，和以前一样
@property (nonatomic,   copy) NSString *anchorId;        /// 主播id，和以前一样
@property (nonatomic,   copy) NSString *channelCategory; /// 直播间品类，和以前一样

@property (nonatomic,   copy) NSString *goodsImg;        /// 常规订单--商品图片
@property (nonatomic,   copy) NSString *orderCategory;   /// 常规订单--订单分类
@property (nonatomic,   copy) NSString *orderCreateTime; /// 订单创建时间，和以前一样
@property (nonatomic,   copy) NSString *orderPrice;      /// 常规订单--订单价格
@property (nonatomic,   copy) NSString *orderType;       /// 常规订单--订单类型
/// 新增
@property (strong, nonatomic) NSString *anewGoodsCateId; /// 新飞单类别id

@property (nonatomic,   copy) NSString *customizeGoodsImg;         /// 定制订单--商品图片
@property (nonatomic,   copy) NSString *customizeOrderPrice;       /// 定制订单--订单价格
@property (nonatomic,   copy) NSString *customizeOrderType;        /// 定制订单--订单类型
@property (nonatomic,   copy) NSString *customizeType;             /// 定制订单--定制类型
@property (nonatomic,   copy) NSString *goodsCateId;               /// 定制订单--商品类别
@property (nonatomic,   copy) NSString *personalCustomizeCategory; /// 定制订单--定制订单分类

@property (nonatomic,   copy) NSString *sm_deviceId;               /// 数美deviceId
@property (nonatomic,   copy) NSString *viewerId;                  /// 用户ID，和以前一样
@property (nonatomic,   copy) NSString *processingDes;             /// 加工描述;
@property (nonatomic, strong) NSArray<JHCreateCustomizeFeeListModel *>*customizeFeeList; /// 定制类别列表
@end

@interface JHCreateCustomizeFeeListModel :NSObject
@property (nonatomic,   copy) NSString *count; ///   和以前一样
@property (nonatomic,   copy) NSString *customizeFeeId; ///   和以前一样
@property (nonatomic,   copy) NSString *customizeFeeName; ///    和以前一样
@end



/// 商家端查看用户可定制订单
@interface JHCheckCustomizeOrderListModel : NSObject
@property (nonatomic,   copy) NSString *orderId;          /// 订单id
@property (nonatomic,   copy) NSString *orderCode;        /// 订单号
@property (nonatomic,   copy) NSString *orderStatus;      /// 订单状态
@property (nonatomic,   copy) NSString *originOrderPrice; /// 订单原价
@property (nonatomic,   copy) NSString *goodsTitle;       /// 商品标题
@property (nonatomic,   copy) NSString *goodsUrl;         /// 商品图片
@property (nonatomic,   copy) NSString *orderCreateTime;  /// 下单时间
@property (nonatomic,   copy) NSString *materialSource;   /// 自有or已购(1:自有；2已购)
@property (nonatomic, assign) NSInteger connectFlag;      /// 是否连麦中(0:否；1:正向连麦，2:反向连麦)(用于判断背景)
@property (nonatomic, assign) NSInteger connectCount;     /// 连麦数量(大于0就代表连过麦)
@property (nonatomic, assign) NSInteger buttonFlag;       /// 用于判断按钮是否高亮，是否可点击

@property (nonatomic,   copy) NSString *orderCategory;    /// 常规订单--订单分类
@property (nonatomic,   copy) NSString *goodsCateId;      /// 定制订单--商品类别
@property (nonatomic,   copy) NSString *goodsCateIdName;  /// 定制订单--类别中文名称

@end


NS_ASSUME_NONNULL_END

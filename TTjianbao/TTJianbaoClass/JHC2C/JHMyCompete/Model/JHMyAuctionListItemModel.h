//
//  JHMyAuctionListItemModel.h
//  TTjianbao
//
//  Created by zk on 2021/9/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyAuctionListItemModel : NSObject
//商品id
@property (nonatomic, assign) long productId;
//店铺id
@property (nonatomic, assign) long shopId;
//封面地址
//@property (nonatomic,   copy) NSString *coverUrl;
//视频地址
@property (nonatomic,   copy) NSString *videoUrl;
//商品名称
@property (nonatomic,   copy) NSString *productName;
//商品标签列表
@property (nonatomic, strong) NSArray<NSString *> *productTagList;
//商品售卖状态 0-在售 1-下架 2-已抢光 13可预约  14已成交  15已结束
@property (nonatomic, assign) NSInteger productSellStatus;
//商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单
@property (nonatomic,   copy) NSString *productSellStatusDesc;
//是否存在专场
@property (nonatomic, assign) BOOL existShow;
//专场id
@property (nonatomic, assign) long showId;
//专场名称
@property (nonatomic,   copy) NSString *showName;
/**
 * 专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀
 */
@property (nonatomic, assign) NSInteger showType;
//专场地址
@property (nonatomic,   copy) NSString *showUrl;
//孤品状态 0-非孤品 1-孤品
@property (nonatomic, assign) NSInteger uniqueStatus;
/// 瀑布流图片
@property (nonatomic, strong) JHNewStoreHomeGoodsImageInfoModel *coverImage;
//商品售价
@property (nonatomic,   copy) NSString *price;
//专场价格
@property (nonatomic,   copy) NSString *showPrice;
//商品售价
@property (nonatomic,   copy) NSString *jhPrice;
//专场价格
@property (nonatomic,   copy) NSString *jhShowPrice;

@property (nonatomic, assign) CGFloat   itemHeight;

/// 新增
/// 是否直发 0否1是
@property (nonatomic, assign) NSInteger directDelivery;
/// 用户名
@property (nonatomic,   copy) NSString *name;
/// 用户图像
@property (nonatomic,   copy) NSString *img;
/// 鉴定报告结果 0 真 1 仿品 2 存疑 3 现代工艺品
@property (nonatomic,   copy) NSString *appraisalReportResult;
/// 想要人数
@property (nonatomic, assign) NSInteger wantCount;
/// 拍卖状态（0 待拍 1竞拍中 2 已结束）
@property (nonatomic, assign) NSInteger auctionStatus;
/// 拍卖是否出价 0未出价 1已出价
@property (nonatomic, assign) NSInteger auctionPriceStatus;
/// 拍卖是否出价 1 即将截拍
@property (nonatomic, assign) NSInteger auctionEndStatus;
/// 出价次数
@property (nonatomic,   copy) NSString *num;
/// 出价次数
@property (nonatomic,   copy) NSString *priceNumber;
/// 是否需要运费 0否 1是
@property (nonatomic, assign) NSInteger needFreight;
/// 商品类型 0一口价 1拍卖
@property (nonatomic, assign) NSInteger productType;
/// 拍卖倒计时
@property (nonatomic, assign) NSInteger auctionDeadTime;
/// 立即付款是否显示
@property (nonatomic, assign) BOOL immediatePaymentHidden;

/// 距拍卖结束时间
@property (nonatomic, copy) NSString *auctionDeadline;
/// 距订单支付结束时间
@property (nonatomic, copy) NSString *orderDeadline;
/// 拍卖状态（0 待拍 1竞拍中 2 已结束）
@property (nonatomic, assign) NSInteger productAuctionStatus;

@property (nonatomic, copy) NSString *payExpireTime;
/// 订单状态  1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定
@property (nonatomic, assign) NSUInteger orderStatus;

///商品售卖状态View是否隐藏
@property (nonatomic, assign) BOOL auctionStatusViewHidden;
///商品售卖状态 文字颜色
@property (nonatomic, copy) NSAttributedString *auctionStatusText;
///商品售卖状态 背景色
@property (nonatomic, copy) UIColor *auctionStatusBackgroundColor;

@property (nonatomic, assign) NSUInteger sellerType;
@end

NS_ASSUME_NONNULL_END

//
//  JHStoreDetailModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品详情

#import <Foundation/Foundation.h>
#import "JHUserAuthModel.h"
#import "JHAudienceCommentMode.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - 拍卖
@interface JHProductAuctionFlowModel : NSObject
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 拍卖流水号
@property (nonatomic, copy) NSString *auctionSn;
/// 起拍价（单位分
@property (nonatomic) NSInteger startPrice;
/// 加价幅度（单位分
@property (nonatomic) NSInteger bidIncrement;
/// 保证金（单位分）
@property (nonatomic) NSInteger earnestMoney;
/// 拍卖开始时间
@property (nonatomic, copy) NSString *auctionStartTime;
/// 拍卖结束时间
@property (nonatomic, copy) NSString *auctionEndTime;
/// 当前最高出价
@property (nonatomic, copy) NSString *maxBuyerPrice;
/// 拍卖订单Id
@property (nonatomic, copy) NSString *orderId;

/// /拍卖状态（0 待拍 1竞拍中 2 已结束）"
@property (nonatomic) NSInteger auctionStatus;

/// /是否预约拍卖 0 未预约 1 预约了
@property (nonatomic) NSInteger auctionRemindStatus;
/// /预约拍卖商品人数"
@property (nonatomic, copy) NSString *auctionRemindCount;

/// 1:下架      以下状态都表示为上架 因为是基于上架状态使用的      10:待拍 11:已预约拍卖    20:开拍该用户无动作  21：领先 22：出局      30:表示拍卖结束 无出价  31:拍卖结束有中拍  32:中拍待支付  33 中拍支付中 （根据这两个值区分提单页面还是支付页面）35:支付完成"
@property (nonatomic) NSInteger productDetailStatus;

/// 当前价（单位分
@property (nonatomic) NSInteger auctionNewPrice;

/// 当前价（单位分
@property (nonatomic) NSInteger endTime;


@end


#pragma mark - 图片详情
@interface ProductImageInfo : NSObject
/// 宽
@property (nonatomic) CGFloat width;
/// 高
@property (nonatomic) CGFloat height;
/// 图片地址
@property (nonatomic, copy) NSString *url;
/// 图片地址
@property (nonatomic, copy) NSString *middleUrl;

@end
#pragma mark - 商品规格详情
@interface ProductSpecInfo : NSObject
/// 规格名称
@property (nonatomic, copy) NSString *attrName;
/// 规格值 多个,分隔
@property (nonatomic, copy) NSString *attrValue;
/// 属性说明标题
@property (nonatomic, copy) NSString *attrDescTitle;
/// 属性id
@property (nonatomic, copy) NSString *ID;

@end

#pragma mark - 分享详情
@interface ProductShareInfo : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 描述
@property (nonatomic, copy) NSString *desc;
/// 图片
@property (nonatomic, copy) NSString *img;
/// 跳转地址
@property (nonatomic, copy) NSString *url;


@end

#pragma mark - 店铺推荐商品详情
@interface ShopProductInfo : NSObject

/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 店铺id
@property (nonatomic, copy) NSString *shopId;
/// 封面地址
@property (nonatomic, strong) ProductImageInfo *coverImage;
/// 视频地址
@property (nonatomic, copy) NSString *videoUrl;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 商品标签列表
@property (nonatomic, strong) NSArray<NSString *> *productTagList;
/// 商品售卖状态 0-在售 1-下架 2-已抢光
@property (nonatomic, copy) NSString *productSellStatus;
/// 商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单
@property (nonatomic, copy) NSString *productSellStatusDesc;
/// 商品售价
@property (nonatomic, copy) NSString *price;
/// 专场名称
@property (nonatomic, copy) NSString *showName;
/// 专场地址
@property (nonatomic, copy) NSString *showUrl;
/// 专场价格
@property (nonatomic, copy) NSString *showPrice;
/// 专场价格名称
@property (nonatomic, copy) NSString *showPriceName;
/// 孤品状态 0-非孤品 1-孤品
@property (nonatomic, copy) NSString *uniqueStatus;

@end

#pragma mark - 店铺详情
@interface ProductShopInfo : NSObject
/// 店铺id
@property (nonatomic, copy) NSString *shopId;
/// 商家名称
@property (nonatomic, copy) NSString *sellerId;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;
/// 店铺logo
@property (nonatomic, copy) NSString *shopLogoImg;
/// 店铺粉丝
@property (nonatomic, copy) NSString *followNum;
/// 店铺好评度
@property (nonatomic, copy) NSString *orderGrades;
/// 是否已经关注店铺
@property (nonatomic, assign) BOOL followStatus;
/// 店铺推荐商品列表
@property (nonatomic, strong) NSArray<ShopProductInfo *>* shopProductList;

/// 商品分
@property (nonatomic, copy) NSString *goodsScore;
/// 物流分
@property (nonatomic, copy) NSString *logisticsScore;
/// 客服分
@property (nonatomic, copy) NSString *customerServiceScore;
/// 综合分
@property (nonatomic, copy) NSString *comprehensiveScore;
/** 认证类型 0未认证、1个人、2企业、3个体户 */
@property (nonatomic, assign) JHUserAuthType sellerType;

/// 增加粉丝数
- (void)addFollowNum;
/// 减少粉丝数
- (void)minusFollowNum;
@end


#pragma mark - 专场详情
@interface ProductSpecialShowInfo : NSObject
/// 专场ID
@property (nonatomic, copy) NSString *showId;
/// 专场名称
@property (nonatomic, copy) NSString *showName;
/// 专场地址
@property (nonatomic, copy) NSString *showUrl;
/// 专场价格
@property (nonatomic, copy) NSString *showPrice;
/// 专场价格名称
@property (nonatomic, copy) NSString *showPriceName;
/// 专场状态 selling 热卖、advance 预告
@property (nonatomic, copy) NSString *showStatus;
/// 专场类型 0-新人专场 1-普通专场  2 拍卖 3 秒杀 用来区分是普通专场还是新人专场
@property (nonatomic, copy) NSString *showType;
/// 专场折扣
@property (nonatomic, copy) NSString *showDiscount;
/// 专场开始时间
@property (nonatomic, copy) NSString *showSaleStartTime;
/// 专场剩余时间
@property (nonatomic, assign) NSUInteger showRemainTime;
/// 开售提醒人数
@property (nonatomic, copy) NSString *showRemindCount;
/// 增加开售提醒人数
- (void)addRemindCount;
@end


#pragma mark - 商品详情
/// 商品详情
@interface JHStoreDetailModel : NSObject
/// 商品id
@property (nonatomic, copy) NSString *productId;
/// 商品sn
@property (nonatomic, copy) NSString *productSn;
/// 商品名称
@property (nonatomic, copy) NSString *productName;
/// 商品描述
@property (nonatomic, copy) NSString *productDesc;
/// 商品标签列表
@property (nonatomic, strong) NSArray<NSString *> *productTagList;
/// 商品主图列表
@property (nonatomic, strong) NSArray<NSString *> *mainImageUrl;
/// 商品主图列表 - 中图
@property (nonatomic, strong) NSArray<NSString *> *mainImageMiddleUrl;
/// 商品视频
@property (nonatomic, copy) NSString *videoUrl;
/// 商品视频封面
@property (nonatomic, copy) NSString *videoCoverUrl;
/// 商品规格属性列表
@property (nonatomic, strong) NSMutableArray<ProductSpecInfo *> *productAttrList;
/// 商品详情图列表
@property (nonatomic, strong) NSArray<ProductImageInfo *> *detailImages;
///// 商品详情图列表 - 中图
//@property (nonatomic, strong) NSArray<ProductImageInfo *> *detailImageMiddles;
/// 商品售价
@property (nonatomic, copy) NSString *price;
/// 孤品状态 0-非孤品 1-孤品
@property (nonatomic, copy) NSString *uniqueStatus;
/// 商品售卖状态 0-在售 1-已下架 2-已抢光
@property (nonatomic, copy) NSString *productSellStatus;
/// 商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单
@property (nonatomic, copy) NSString *productSellStatusDesc;
/// 商品优惠券列表
@property (nonatomic, strong) NSArray<NSString *> *couponList;
/// 店铺推荐商品列表
@property (nonatomic, strong) ProductShopInfo *shopInfo;
/// 是否存在专场
@property (nonatomic, assign) BOOL existShow;
/// 专场
@property (nonatomic, strong) ProductSpecialShowInfo *specialShowInfo;
/// 分享信息
@property (nonatomic, strong) ProductShareInfo *shareInfo;
/// 商品售价
@property (nonatomic, assign) BOOL followStatus;
/// 商品库存
@property (nonatomic, assign) NSInteger sellStock;
/// 用户教育url
@property (nonatomic, copy) NSString *userEducationUrl;
///是否直发 0否1是",
@property(nonatomic, assign)  NSInteger directDelivery;

/// 券后价格
@property (nonatomic, copy) NSString *discountPrice;

/// 商品一级分类
@property (nonatomic, copy) NSString *firstCateName;

/// 商品二级分类
@property (nonatomic, copy) NSString *secondCateName;

/// 三级分类中文
@property (nonatomic, copy) NSString *thirdCateName;


/// 商品类型  // 0一口价 1拍卖",
@property (nonatomic, copy) NSString *productType;

/// 是否预约拍卖 0 未预约 1 预约了
@property (nonatomic, copy) NSString *auctionRemindStatus;

/// 预约拍卖商品人数
@property (nonatomic, copy) NSString *auctionRemindCount;

/// 拍卖信息
@property (nonatomic, strong) JHProductAuctionFlowModel *auctionFlow;

@end



#pragma mark - 评论
@interface JHStoreCommentModel : NSObject
/// 数量
@property (nonatomic, copy) NSString *countStr;
/// 好评度
@property (nonatomic, copy) NSString *orderGrade;
/// 评论list
@property (nonatomic, strong) NSArray<JHAudienceCommentMode *> *datas;

@end


#pragma mark - 说明
@interface JHProductIntrductModel : NSObject
/// id
@property (nonatomic, copy) NSString *attrId;
/// 文本
@property (nonatomic, copy) NSString *attrDescContent;

@end



@interface JHB2CAuctionRefershModel : NSObject



/// 开始时间
@property (nonatomic, copy) NSString* auctionStartTime;

/// 结束时间  auctionEndTime = "2021-07-01T18:43:00";
@property (nonatomic, copy) NSString* auctionEndTime;

/// 序列号
@property (nonatomic, copy) NSString* auctionSn;

/// 0-上架 1-下架 2违规禁售  3预告中  4已售出  5流拍  6交易取消
@property (nonatomic) NSInteger productStatus;

/// 当前用户拍卖状态（0无状态 1 失效 2出局 3领先 4中拍）
@property (nonatomic) NSInteger auctionStatus;

/// 拍卖订单状态 1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定
@property (nonatomic) NSUInteger orderStatus;

/// 拍卖状态（0 待拍 1竞拍中 2 已结束 ）
@property (nonatomic) NSInteger flowStatus;

/// 加价幅度
@property (nonatomic, copy) NSString* bidIncrement;

/// 最高出价买家id
@property (nonatomic, copy) NSString* buyerId;

/// 当前最高出价
@property (nonatomic, copy) NSString* buyerPrice;

/// 当前用户是否设置过代理 0:否 1:是
@property (nonatomic) BOOL isAgent;

/// 已出价次数
@property (nonatomic, copy) NSString* number;

/// 起拍价
@property (nonatomic, copy) NSString* startPrice;

/// 当前用户代理价(分)
@property (nonatomic, copy) NSString* expectedPrice;

/// 订单ID
@property (nonatomic, copy) NSString* orderId;

/// 开始时间  秒
@property (nonatomic) NSInteger startTime;
/// 结束时间 秒
@property (nonatomic) NSInteger endTime;

/// 代理价格(分)
@property (nonatomic) NSInteger agentPrice;

/// 是否存在用户出价 0否 1是",
@property (nonatomic) NSInteger isBuying;

/// 是否预约拍卖 0 未预约 1 预约了",
@property (nonatomic) NSInteger auctionRemindStatus;

/// 预约拍卖商品人数"
@property (nonatomic, copy) NSString * auctionRemindCount;


/// 1:下架      以下状态都表示为上架 因为是基于上架状态使用的      10:待拍 11:已预约拍卖    20:开拍该用户无动作  21：领先 22：出局      30:表示拍卖结束 无出价  31:拍卖结束有中拍  32:中拍待支付  33 中拍支付中 （根据这两个值区分提单页面还是支付页面）35:支付完成"
@property (nonatomic) NSInteger productDetailStatus;


@end

NS_ASSUME_NONNULL_END

//
//  JHNewStoreHomeModel.h
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 专场
 */

@class JHNewStoreHomeBoutiqueShowListProductList;
@class JHNewStoreHomeShareInfoModel;
@class JHNewStoreHomeBoutiqueShowListModel;
@interface JHNewStoreHomeBoutiqueModel : NSObject
@property (nonatomic, strong) NSArray<JHNewStoreHomeBoutiqueShowListModel *>* showList;
@end

@interface JHNewStoreHomeBoutiqueShowListModel : NSObject
//专场id
@property (nonatomic, assign) long showId;
//封面。广告图对应app首页专场的封面
@property (nonatomic,   copy) NSString *coverImg;
//标题
@property (nonatomic,   copy) NSString *title;
/**
 * 专场状态--0 预告、1 热卖、2 结束、-1 未知
 */
@property (nonatomic, assign) NSInteger showStatus;
/**
 * 专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀
 */
@property (nonatomic, assign) NSInteger showType;
//标签
@property (nonatomic, strong) NSArray<NSString *>*tags;
//推荐商品
@property (nonatomic, strong) NSArray<JHNewStoreHomeBoutiqueShowListProductList *>* productList;
//活动结束时间
@property (nonatomic,   copy) NSString *saleEndTime;
//活动开始时间
@property (nonatomic,   copy) NSString *saleStartTime;
//前台价格名称
@property (nonatomic,   copy) NSString *priceName;
//热卖专场剩余时间（单位：毫秒）
@property (nonatomic, assign) long remainTime;
//专场分享信息
@property (nonatomic, strong) JHNewStoreHomeShareInfoModel *shareInfoBean;
//订阅状态 0 未订阅，1 订阅"
@property (nonatomic, assign) NSInteger subscribeStatus;
@end



@interface JHNewStoreHomeBoutiqueShowListProductList : NSObject
//商品id
@property (nonatomic, assign) long      productId;
//封面地址
@property (nonatomic,   copy) NSString  *coverUrl;
//视频地址
@property (nonatomic,   copy) NSString  *videoUrl;
//商品名称
@property (nonatomic,   copy) NSString  *productName;
//商品售价
@property (nonatomic,   copy) NSString  *price;
//专场价
@property (nonatomic,   copy) NSString  *showPrice;
/// 拍卖次数
@property (nonatomic,   copy) NSString  *auctionCount;
/**
 * 专场类型 0-新人 1-普通，2-拍卖，3-普通秒杀，4-大促秒杀
 */
@property (nonatomic, assign) NSInteger showType;

@end


/// 分享
@interface JHNewStoreHomeShareInfoModel : NSObject
//标题
@property (nonatomic,   copy) NSString *title;
//描述
@property (nonatomic,   copy) NSString *desc;
//图片
@property (nonatomic,   copy) NSString *img;
//跳转地址
@property (nonatomic,   copy) NSString *url;
@end





/*
 * 商品
 */

@class JHNewStoreHomeGoodsTabInfoModel;
@class JHNewStoreHomeGoodsProductListModel;
@interface JHNewStoreHomeGoodsListModel : NSObject
//商品列表
@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsProductListModel *> *productList;
@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsTabInfoModel *> *recommendTabList;
@end


@class JHNewStoreHomeGoodsImageInfoModel;
@interface JHNewStoreHomeGoodsProductListModel : NSObject
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

@end




@interface JHNewStoreHomeGoodsImageInfoModel  : NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic,   copy) NSString *url;
@property (nonatomic, assign) CGFloat   aNewHeight;
@end
 
@interface JHNewStoreHomeGoodsTabInfoModel : NSObject
//
@property (nonatomic, assign) long tabId;
//
@property (nonatomic,   copy) NSString *tabName;
@end




/// 秒杀专区
@class JHNewStoreHomeKillActivityPageItemModel;
@interface JHNewStoreHomeKillActivityModel: NSObject
/// 是否展示
@property (nonatomic, assign) BOOL      showBanner;
/// 秒杀倒计时描述
@property (nonatomic,   copy) NSString *seckillCountdownDesc;
/// 秒杀倒计时
@property (nonatomic, assign) long      seckillCountdown;
/// 秒杀分页商品数据
@property (nonatomic, strong) NSArray <JHNewStoreHomeKillActivityPageItemModel *>*productPageResult;
@end


@class JHNewStoreHomeKillActivityPageItemImageModel;
@interface JHNewStoreHomeKillActivityPageItemModel: NSObject
/// 商品id
@property (nonatomic,   copy) NSString *productId;
/// 商品主图
@property (nonatomic, strong) JHNewStoreHomeKillActivityPageItemImageModel *mainImageUrl;
/// 商品名称
@property (nonatomic,   copy) NSString *productName;
/// 商品原价
@property (nonatomic,   copy) NSString *productOriginalPrice;
/// 商品秒杀价
@property (nonatomic,   copy) NSString *productSeckillPrice;
/// 营销标签
@property (nonatomic, strong) NSArray<NSString *>*productTagList;
/// 秒杀进度
@property (nonatomic,   copy) NSString *seckillProgress;
/// 按钮类型 0-马上抢 1-已抢光 2-开售提醒 3-已设置提醒
@property (nonatomic, assign) NSInteger btnType;
@end



@interface JHNewStoreHomeKillActivityPageItemImageModel: NSObject
/// 宽
@property (nonatomic, assign) NSInteger width;
/// 高
@property (nonatomic, assign) NSInteger height;
/// 原图地址
@property (nonatomic,   copy) NSString *url;
/// 小图地址
@property (nonatomic,   copy) NSString *smallUrl;
/// 中图地址
@property (nonatomic,   copy) NSString *middleUrl;
/// 大图地址
@property (nonatomic,   copy) NSString *bigUrl;
/// 位置 0:正面 1:背面 2:侧面"
@property (nonatomic,   copy) NSString *location;
/// 0:图片 1:视频
@property (nonatomic,   copy) NSString *type;
/// 视频封面图
@property (nonatomic,   copy) NSString *detailVideoCoverUrl;
/// 图片URI
@property (nonatomic,   copy) NSString *path;
@end


NS_ASSUME_NONNULL_END



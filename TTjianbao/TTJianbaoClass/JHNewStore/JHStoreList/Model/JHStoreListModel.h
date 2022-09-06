//
//  JHStoreListModel.h
//  TTjianbao
//
//  Created by zk on 2021/10/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHStoreGoodsImgModel;
@interface JHStoreListModel : NSObject

@property (nonatomic, assign) NSInteger authStatus;//认证类型 0:否 1:是

@property (nonatomic, assign) NSInteger commentNum;//评论数量

@property (nonatomic, copy) NSString *comprehensiveScore;//综合分

@property (nonatomic, copy) NSString *customerServiceScore;//客服分

@property (nonatomic, assign) NSInteger enabled;//店铺状态:0关闭、1开启、-1合同到期
       
@property (nonatomic, assign) NSInteger followNum;//关注数

@property (nonatomic, assign) NSInteger followed;//关注状态:1已关注、0未关注

@property (nonatomic, copy) NSString *goodsScore;//商品分
        
@property (nonatomic, assign) NSInteger ID;//店铺id

@property (nonatomic, copy) NSString *logisticsScore;//物流分

@property (nonatomic, strong) NSNumber *orderGrades;//订单好评度
        
@property (nonatomic, assign) NSInteger sellerType;//商家类型 1:个人 2:企业 3:个体户
        
@property (nonatomic, copy) NSString *shopBgImg;//店铺背景图片

@property (nonatomic, copy) NSString *shopDesc;//推荐理由

@property (nonatomic, copy) NSString *shopLogoImg;//店铺logo

@property (nonatomic, copy) NSString *shopName;//店铺名称

@property (nonatomic, assign) CGFloat labW;

@property (nonatomic, strong) NSArray *productList;//商品列表

@end


@interface JHStoreItemModel : NSObject

@property (nonatomic, copy) NSString *appraisalReportResult;//鉴定报告结果 0 真 1 仿品 2 存疑 3 现代工艺品

@property (nonatomic, assign) NSInteger auctionEndStatus;//是否即将截拍 0否 1 是

@property (nonatomic, assign) NSInteger auctionPriceStatus;//拍卖是否出价 0未出价 1已出价

@property (nonatomic, assign) NSInteger auctionStatus;//拍卖状态（0 待拍 1竞拍中 2 已结束）

@property (nonatomic, assign) NSInteger directDelivery;//是否直发 0否1是

@property (nonatomic, assign) BOOL existShow;//区分是不是有普通专场或者新人专场

@property (nonatomic, copy) NSString *img;//用户图像

@property (nonatomic, copy) NSString *name;//用户名

@property (nonatomic, assign) NSInteger needFreight;//是否需要运费 0否 1是

@property (nonatomic, assign) NSInteger num;//出价次数

@property (nonatomic, copy) NSString *price;//商品售价

@property (nonatomic, assign) NSInteger productId;//商品id

@property (nonatomic, copy) NSString *productName;//商品名称

@property (nonatomic, assign) NSInteger productSellStatus;//商品售卖状态 0-在售 1-下架 2-已抢光 13可预约 14已成交 15已结束

@property (nonatomic, copy) NSString *productSellStatusDesc;//商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单

@property (nonatomic, strong) NSArray *productTagList;//商品标签列表

@property (nonatomic, assign) NSInteger productType;//商品类型 0一口价 1拍卖

@property (nonatomic, assign) NSInteger shopId;//店铺id

@property (nonatomic, assign) NSInteger showId;//专场id

@property (nonatomic, copy) NSString *showName;//专场名称

@property (nonatomic, copy) NSString *showPrice;//专场价格 新人价和专场价都是用showPrice一个字段

@property (nonatomic, copy) NSString *showUrl;//专场地址

@property (nonatomic, copy) NSString *videoUrl;//视频地址

@property (nonatomic, assign) NSInteger showType;//专场类型 0-新人专场 1-普通专场 用来区分是普通专场还是新人专场

@property (nonatomic, assign) NSInteger uniqueStatus;//孤品状态 0-非孤品 1-孤品

@property (nonatomic, assign) NSInteger wantCount;//想要人数

@property (nonatomic, strong) JHStoreGoodsImgModel *coverImage;//封面地址、商品图片

@end


@interface JHStoreGoodsImgModel : NSObject

@property (nonatomic, copy) NSString *detailVideoCoverUrl;//视频封面图

@property (nonatomic, copy) NSString *bigUrl;//大图地址

@property (nonatomic, copy) NSString *middleUrl;//中图地址

@property (nonatomic, copy) NSString *smallUrl;//小图地址

@property (nonatomic, copy) NSString *url;//原图地址

@property (nonatomic, copy) NSString *path;//图片URI

@property (nonatomic, copy) NSString *location;// 位置 0:正面 1:背面 2:侧面

@property (nonatomic, assign) NSInteger height;//高

@property (nonatomic, assign) NSInteger width;//宽

@property (nonatomic, assign) NSInteger type;//类型 0:图片 1:视频

@end

NS_ASSUME_NONNULL_END

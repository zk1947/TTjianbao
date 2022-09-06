//
//  JHC2CGoodsListModel.h
//  TTjianbao
//
//  Created by hao on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSearchPositionTargetModel : NSObject
@property (nonatomic, copy)NSString *componentName;
@property (nonatomic, copy)NSString *vc;//专题专区点击返回
@property (nonatomic, strong)NSMutableDictionary *params;
@end

///运营位栏位列表
@interface JHC2COperatingPositionListModel : NSObject
///运营位栏位id
@property (nonatomic, copy) NSString *detailsId;
///图片素材地址
@property (nonatomic, copy) NSString *imageUrl;
///落地页类型名称
@property (nonatomic, copy) NSString *targetName;
///落地页目标
@property (nonatomic, copy) NSString *landingTarget;
///落地页关联参数
@property (nonatomic, copy) NSString *landingId;

@property (nonatomic, strong) JHC2CSearchPositionTargetModel *target;

@end


///商品图
@interface JHC2CGoodsImageInfoModel : NSObject
/** 大图 */
@property (nonatomic, copy) NSString *big;
/** 小图 */
@property (nonatomic, copy) NSString *medium;
/** 原图 */
@property (nonatomic, copy) NSString *origin;
/** 缩略图 */
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *w;
@property (nonatomic, copy) NSString *h;
@property (nonatomic, assign) CGFloat aNewHeight;

///计算出来的所需图片的高度
@property (nonatomic, assign) CGFloat goodsImgHeight;

@end

///商品列表
@interface JHC2CProductBeanListModel : NSObject
///物品发布者  卖家类型 0商户 1个人卖家
@property (nonatomic, assign) NSInteger sellerType;
///商品id
@property (nonatomic, copy) NSString *productId;
///店铺id
@property (nonatomic, copy) NSString *shopId;
///封面地址
@property (nonatomic, strong) JHC2CGoodsImageInfoModel *images;
///视频地址
@property (nonatomic, copy) NSString *videoUrl;
///商品名称
@property (nonatomic, copy) NSString *productName;
///商品描述
@property (nonatomic, copy) NSString *productDesc;
///商品售卖状态 0-在售 1-下架 2-已抢光
@property (nonatomic, assign) NSInteger productSellStatus;
///商品售价
@property (nonatomic, copy) NSString *price;
///商品售价
@property (nonatomic, copy) NSString *showPrice;
///用户名
@property (nonatomic, copy) NSString *name;
///用户图像
@property (nonatomic, copy) NSString *img;
///鉴定报告结果( 0 真 1 仿品 2 存疑 3 现代工艺品)
@property (nonatomic, copy) NSString *appraisalReportResult;
///想要人数
@property (nonatomic, copy) NSString *wantCount;
///拍卖状态(0 待拍 1竞拍中 2 已结束）
@property (nonatomic, assign) NSInteger auctionStatus;
///拍卖是否出价 0未出价 1已出价
@property (nonatomic, assign) NSInteger auctionPriceStatus;
///商品类型 0一口价 1拍卖
@property (nonatomic, copy) NSString *productType;
///即将截拍 1
@property (nonatomic, assign) NSInteger auctionEndStatus;
///出价次数
@property (nonatomic, copy) NSString *num;
///是否需要运费 0否 1是
@property (nonatomic, assign) NSInteger needFreight;
///cell高
@property (nonatomic, assign) CGFloat itemHeight;
///cell高 商家
@property (nonatomic, assign) CGFloat sellerItemHeight;
///价格处是否一行显示
@property (nonatomic, assign) BOOL isOnelineOfMoney;
///用户信息处是否一行显示
@property (nonatomic, assign) BOOL isOnelineOfUserInfo;
///商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单",
@property (nonatomic, copy) NSString *productSellStatusDesc;
//商品标签列表
@property (nonatomic, strong) NSArray<NSString *> *productTagList;
//是否存在专场
@property (nonatomic, assign) BOOL existShow;
//商品售价
@property (nonatomic, copy) NSString *jhPrice;
//专场价格
@property (nonatomic, copy) NSString *jhShowPrice;
//专场类型 0-新人专场 1-普通专场 用来区分是普通专场还是新人专场",
@property (nonatomic, assign) NSInteger showType;
//专场名称
@property (nonatomic, copy) NSString *showName;


/// 新增
/// 是否直发 0否1是
@property (nonatomic, assign) NSInteger directDelivery;
//专场id
@property (nonatomic, copy) NSString *showId;
//新人h5 url
@property (nonatomic, copy) NSString *showUrl;
@end



@interface JHC2CGoodsListModel : NSObject

///运营位栏位列表
@property (nonatomic, copy) NSArray<JHC2COperatingPositionListModel *> *operationDefiniDetailsResponses;
///商品列表
@property (nonatomic, copy) NSArray<JHC2CProductBeanListModel *> *productListBeanList;
///分类列表
@property (nonatomic, copy) NSArray *cateIds;


@end

NS_ASSUME_NONNULL_END

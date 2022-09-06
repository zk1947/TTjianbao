//
//  JHFoucsShopModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDBaseModel.h"
#import "JHStoreDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 店铺推荐商品详情
@interface JHFoucsShopProductInfo : NSObject
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

//计算之后的JHDiscoverHomeFlowCollectionCell高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat descHeight;
@property (nonatomic, assign) CGFloat priceHeight;
@end


@interface JHFoucsShopInfo : YDBaseModel
/// 店铺ID
@property (nonatomic, copy) NSString *sellerId;
/// 店铺名称
@property (nonatomic, copy) NSString *shopName;
/// 店铺LOGO
@property (nonatomic, copy) NSString *shopLogoImg;
/// 店铺背景图
@property (nonatomic, copy) NSString *shopBgImg;
/// 推荐理由
@property (nonatomic, copy) NSString *shopDesc;
/// 粉丝数
@property (nonatomic, assign) NSInteger followNum;
/// 关注状态 1-已关注、2-未关注
@property (nonatomic, strong) NSNumber *followed;
/// 商品数量
@property (nonatomic, copy) NSString *productNum;

///商品数据
@property (nonatomic,strong) NSArray <JHFoucsShopProductInfo*>*goodsArray;

///自己加的字段
@property (nonatomic,assign) CGFloat cellheight;

@end


NS_ASSUME_NONNULL_END

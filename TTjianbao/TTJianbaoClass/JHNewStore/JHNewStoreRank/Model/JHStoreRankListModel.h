//
//  JHStoreRankListModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreRankPictureModel : NSObject
/** 宽*/
@property (nonatomic, copy) NSString *width;
/** 高*/
@property (nonatomic, copy) NSString *height;
/** 图片url*/
@property (nonatomic, copy) NSString *url;
@end

@interface JHStoreRankProductModel : NSObject
//商品id
@property (nonatomic, copy) NSString *productId;
//封面地址
@property (nonatomic, strong) JHStoreRankPictureModel *coverImage;
//商品名称
@property (nonatomic, copy) NSString *productName;
//是否存在专场
@property (nonatomic, assign) BOOL existShow;
//专场类型 0-新人 1-普通
@property (nonatomic, assign) NSInteger showType;
//专场价格
@property (nonatomic, copy) NSString *showPrice;
//普通价格
@property (nonatomic, copy) NSString *price;
@end

@interface JHStoreRankListModel : NSObject
//店铺id
@property (nonatomic, copy) NSString *storeId;
//店铺名称
@property (nonatomic, copy) NSString *shopName;
//店铺logo
@property (nonatomic, copy) NSString *shopLogoImg;
//店铺背景图片
@property (nonatomic, copy) NSString *shopBgImg;
//关注数
@property (nonatomic, copy) NSString *followNum;
//订单好评度
@property (nonatomic, copy) NSString *orderGrades;
//店铺状态:0关闭、1开启、-1合同到期
@property (nonatomic, copy) NSString *enabled;
//关注状态:1已关注、0未关注
@property (nonatomic, copy) NSString *followed;
//评论数量
@property (nonatomic, copy) NSString *commentNum;
//商品列表
@property (nonatomic, strong) NSArray <JHStoreRankProductModel *> *productList;
//slogan
@property (nonatomic, copy) NSString *shopDesc;
@end



NS_ASSUME_NONNULL_END

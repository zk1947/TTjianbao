//
//  JHNewShopHotSellModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopHotSellModel : NSObject

/** 商品id */
@property (nonatomic, copy) NSString *productId;
/** 店铺id */
@property (nonatomic, copy) NSString *shopId;
/** 封面地址 */
@property (nonatomic, copy) NSString *coverUrl;
/** 视频地址 */
@property (nonatomic, copy) NSString *videoUrl;
/** 商品名称 */
@property (nonatomic, copy) NSString *productName;
/** 商品标签列表 */
@property (nonatomic, strong) NSArray *productTagList;
/** 商品售卖状态 0-在售 1-下架 2-已抢光 */
@property (nonatomic, copy) NSString *productSellStatus;
/** 商品售卖状态描述 还有机会，有宝友拍下还未付款，10分钟内将解除订单 */
@property (nonatomic, copy) NSString *productSellStatusDesc;
/** 商品售价 */
@property (nonatomic, copy) NSString *price;
/** 是否存在专场 */
@property (nonatomic, copy) NSString *existShow;
/** 专场id */
@property (nonatomic, copy) NSString *showId;
/** 专场名称 */
@property (nonatomic, copy) NSString *showName;
/** 专场类型 0-新人 1-普通 */
@property (nonatomic, copy) NSString *showType;
/** 专场地址 */
@property (nonatomic, copy) NSString *showUrl;
/** 专场价格 */
@property (nonatomic, copy) NSString *showPrice;
/** 孤品状态 0-非孤品 1-孤品 */
@property (nonatomic, copy) NSString *uniqueStatus;

@end

NS_ASSUME_NONNULL_END

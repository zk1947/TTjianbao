//
//  JHRecycleDetailModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收详情-model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface JHRecycleDetailImageUrlModel : NSObject
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
@end

///宝贝细节地址
@interface JHRecycleDetailProductDetailUrlsModel : NSObject
/** 细节类型：0 图片 1 视频 */
@property (nonatomic, assign) NSInteger detailType;
/** 细节类型名称 */
@property (nonatomic, copy) NSString *detailTypeName;
/** 商品细节视频 */
@property (nonatomic, copy) NSString *detailVideoUrl;
/** 商品细节视频封面图 */
@property (nonatomic, copy) NSString *detailVideoCoverUrl;
/** 商品细节图片 */
@property (nonatomic, strong) JHRecycleDetailImageUrlModel *detailImageUrl;
@end




///宝贝图片地址
@interface JHRecycleDetailProductImgUrlsModel : NSObject
/** 商品图片类型：1 正面图，2 背面图 3 侧面图 4 细节图 */
@property (nonatomic, assign) NSInteger imgType;
/** 商品图片类型名称 */
@property (nonatomic, copy) NSString *imgTypeName;
/** 图片 */
@property (nonatomic, strong) JHRecycleDetailImageUrlModel *productImage;
@end




@interface JHRecycleDetailModel : NSObject
/** 宝贝id */
@property (nonatomic, assign) NSInteger productId;
/** 宝贝三级分类id */
@property (nonatomic, assign) NSInteger categoryThirdId;
/** 商品名称 */
@property (nonatomic, copy) NSString *productName;
/** 用户端 判断商品是否有报价 */
@property (nonatomic, assign) BOOL hasBid;
/** 商家端 判断商品是否已收藏 */
@property (nonatomic, assign) BOOL isCollectedByBusinessId;
/** 商家端 判断商品是否有出价 */
@property (nonatomic, assign) BOOL currentBusinessHasBid;
/** 分类名称 */
@property (nonatomic, copy) NSString *categoryName;
/** 上架时间 */
@property (nonatomic, copy) NSString *launchTime;
/** 宝贝描述 */
@property (nonatomic, copy) NSString *productDesc;
/** 审核状态: 0 待系统审核 1 系统审核不通过 2 待人工审核 3 人工审核不通过 4 人工审核通过 */
@property (nonatomic, assign) NSInteger auditStatus;
/** 禁售状态：0 正常 1禁售 */
@property (nonatomic, assign) NSInteger stopSellFlag;
/** 商品状态：0 上架 1 下架 2 交易中 3 交易关闭 4 交易成功 5 平台拒绝（审核不通过或者禁售）*/
@property (nonatomic, assign) NSInteger productStatus;
/** 状态类型：0 首次发布、3 重新上架、6 用户主动下架、9 回收商超时未出价、12 用户超时未确认报价、15 回收商超时未支付 18 已售出(用户确认报价) 21 交易取消 */
@property (nonatomic, assign) NSInteger productStatusType;
/** 商品报价数量 */
@property (nonatomic, assign) NSInteger bidCount;
/// 报价剩余时间
@property (nonatomic, assign) NSInteger tipInitCountdownTime;
/** 宝贝细节地址 */
@property (nonatomic, strong) NSArray<JHRecycleDetailProductDetailUrlsModel *> *productDetailUrls;
/** 宝贝图片地址 */
@property (nonatomic, strong) NSArray<JHRecycleDetailProductImgUrlsModel *> *productImgUrls;
/// 新增 期望价格
@property (nonatomic, copy) NSString *expectPrice;
/// 新增 发布商品用户id
@property (nonatomic, copy) NSString *launchCustomerId;
/// 新增用户名
@property (nonatomic, copy) NSString *customerName;
@end

NS_ASSUME_NONNULL_END

//
//  JHRecycleGoodsInfoModel.h
//  TTjianbao
//
//  Created by user on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHRecycleDetailInfoProductImgUrlsModel;
@class JHRecycleDetailInfoImageUrlModel;
@class JHRecycleDetailInfoProductDetailUrlsModel;

@interface JHRecycleGoodsInfoModel : NSObject
/// 宝贝id
@property (nonatomic,   copy) NSString *productId;
/// 宝贝三级分类id
@property (nonatomic,   copy) NSString *categoryThirdId;
/// 商品名称
@property (nonatomic,   copy) NSString *productName;
/// 分类名称
@property (nonatomic,   copy) NSString *categoryName;
/// 宝贝描述
@property (nonatomic,   copy) NSString *productDesc;
/// 商品状态：0 上架 1 下架 2 交易中 3 交易关闭 4 交易成功 5 平台拒绝（审核不通过或者禁售）
@property (nonatomic,   copy) NSString *productStatus;
/// 商品状态名称：0 首次发布、3 重新上架、6 用户主动下架、7 平台禁售、8 回收商已出价、9 回收商超时未出价、12 用户超时未确认报价、15 回收商超时未支付 18 已售出(用户确认报价) 21 交易取消
@property (nonatomic,   copy) NSString *productStatusType;
/// 审核状态: 0 待系统审核 1 系统审核不通过 2 待人工审核 3 人工审核不通过 4 人工审核通过
@property (nonatomic,   copy) NSString *auditStatus;
/// 禁售状态：0 正常 1禁售
@property (nonatomic,   copy) NSString *stopSellFlag;
/// 上架时间
@property (nonatomic,   copy) NSString *launchTime;
/// 埋点报价使用倒计时
@property (nonatomic,   copy) NSString *tipInitCountdownTime;
/// 用户端 判断商品是否有报价
@property (nonatomic, assign) BOOL hasBid;
/// 商家端参数 判断对当前商品是否有出价
@property (nonatomic, assign) BOOL currentBusinessHasBid;
/// 商家端参数 判断对当前商品是否收藏
@property (nonatomic, assign) BOOL isCollectedByBusinessId;
/// 回收商品 ---- 已成交
@property (nonatomic,   copy) NSString *productPrice;
/// 用户头像
@property (nonatomic,   copy) NSString *customerImg;
/// 用户昵称
@property (nonatomic,   copy) NSString *customerName;
/// 宝贝图片地址
@property (nonatomic, strong) NSArray<JHRecycleDetailInfoProductImgUrlsModel *> *productImgUrls;
/// 宝贝细节地址(带视频)
@property (nonatomic, strong) NSArray<JHRecycleDetailInfoProductDetailUrlsModel *> *productDetailUrls;

///
@property (nonatomic, strong) NSArray<NSString *> *productDetailMedium;
@property (nonatomic, strong) NSArray<NSString *> *productDetailOrigin;
@end


///宝贝图片地址
@interface JHRecycleDetailInfoProductImgUrlsModel : NSObject
/** 商品图片类型：1 正面图，2 背面图 3 侧面图 4 细节图 */
@property (nonatomic, assign) NSInteger imgType;
/** 商品图片类型名称 */
@property (nonatomic,   copy) NSString *imgTypeName;
/** 图片 */
@property (nonatomic, strong) JHRecycleDetailInfoImageUrlModel *productImage;
@end


@interface JHRecycleDetailInfoImageUrlModel : NSObject
/** 大图 */
@property (nonatomic,   copy) NSString *big;
/** 小图 */
@property (nonatomic,   copy) NSString *medium;
/** 原图 */
@property (nonatomic,   copy) NSString *origin;
/** 缩略图 */
@property (nonatomic,   copy) NSString *small;
/** 宽 */
@property (nonatomic,   copy) NSString *w;
/** 高 */
@property (nonatomic,   copy) NSString *h;
@property (nonatomic, assign) CGFloat   aNewHeight;
@end


///宝贝细节地址
@interface JHRecycleDetailInfoProductDetailUrlsModel : NSObject
/** 细节类型：0 图片 1 视频 */
@property (nonatomic, assign) NSInteger detailType;
/** 细节类型名称 */
@property (nonatomic,   copy) NSString *detailTypeName;
/** 商品细节视频 */
@property (nonatomic,   copy) NSString *detailVideoUrl;
/** 商品细节视频封面图 */
@property (nonatomic,   copy) NSString *detailVideoCoverUrl;
/** 商品细节图片 */
@property (nonatomic, strong) JHRecycleDetailInfoImageUrlModel *detailImageUrl;
@end




NS_ASSUME_NONNULL_END

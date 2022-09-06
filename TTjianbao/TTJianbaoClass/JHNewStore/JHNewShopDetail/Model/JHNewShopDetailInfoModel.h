//
//  JHNewShopDetailInfoModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

///店铺优惠券
@interface JHNewShopDetailCouponListModel : NSObject
/** 代金券id */
@property (nonatomic, copy) NSString *couponId;
/** 代金券名称 */
@property (nonatomic, copy) NSString *name;
/** 代金券使用说明 */
@property (nonatomic, copy) NSString *remark;
/** 满减条件 */
@property (nonatomic, copy) NSString *ruleFrCondition;
/** 满减金额 */
@property (nonatomic, copy) NSString *price;
/** 优惠券状态。0正常1删除 */
@property (nonatomic, copy) NSString *delFlag;
/** 优惠券数量 */
@property (nonatomic, assign) NSInteger count;
/** 创建者id */
@property (nonatomic, copy) NSString *creatorId;
/** 前端显示样式9，1折，200元 */
@property (nonatomic, copy) NSString *viewValue;
/** 使用类型 FR:满减 ，OD:折扣券, EFR:每满减 */
@property (nonatomic, copy) NSString *ruleType;
/** 领用方式： 0：领取券 1：发放 */
@property (nonatomic, copy) NSString *getType;
/** 是否已经领取过： 0：没领取 1：已经领取过 */
@property (nonatomic, copy) NSString *isReceive;

@end


///分享的信息
@interface JHNewShopDetailShareInfoModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *desc;
/** 图片 */
@property (nonatomic, copy) NSString *img;
/** 跳转地址 */
@property (nonatomic, copy) NSString *url;

@end

@interface JHNewShopBusinessCategory : NSObject
///品类id
@property (nonatomic, copy) NSString *cateId;
///分类名称
@property (nonatomic, copy) NSString *cateName;
///父节点id
@property (nonatomic, copy) NSString *pid;
///老分类id
@property (nonatomic, copy) NSString *oldCateId;
///父节点分类名称
@property (nonatomic, copy) NSString *parentCateName;
///分类图片
@property (nonatomic, copy) NSString *cateIcon;
///级别
@property (nonatomic, copy) NSString *cateLevel;
@end

@interface JHNewShopDetailInfoModel : NSObject
/** 店铺id */
@property (nonatomic, copy) NSString *shopId;
/** 店铺用户id */
@property (nonatomic, copy) NSString *customerId;
/** 店铺名称 */
@property (nonatomic, copy) NSString *shopName;
/** 店铺logo */
@property (nonatomic, copy) NSString *shopLogoImg;
/** 店铺背景图片 */
@property (nonatomic, copy) NSString *shopBgImg;
/** 关注数 */
@property (nonatomic, copy) NSString *followNum;
/** 订单好评度 */
@property (nonatomic, copy) NSString *orderGrades;
/** 店铺状态:0关闭、1开启、-1合同到期 */
@property (nonatomic, copy) NSString *enabled;
/** 关注状态:1已关注、0未关注 */
@property (nonatomic, copy) NSString *followed;
/** 评论数量 */
@property (nonatomic, copy) NSString *commentNum;
/** 优惠券列表 */
@property (nonatomic, strong) NSArray<JHNewShopDetailCouponListModel *> *couponList;
/** 分享*/
@property (nonatomic, strong) JHNewShopDetailShareInfoModel *shareInfo;

/** 认证类型 0未认证、1个人、2企业、3个体户 */
@property (nonatomic, assign) JHUserAuthType sellerType;

/// 0-未认证  1-已认证
@property (nonatomic, assign) NSInteger authStatus;
///经营品类
@property (nonatomic, copy) NSArray <JHNewShopBusinessCategory *>*backCateResponses;
/// 新增
///商品分
@property (nonatomic, copy) NSString *goodsScore;
///物流分
@property (nonatomic, copy) NSString *logisticsScore;
///客服分
@property (nonatomic, copy) NSString *customerServiceScore;
///综合分
@property (nonatomic, copy) NSString *comprehensiveScore;
///售卖商品类型标识  0 一口价，1 拍卖，2 全部
@property (nonatomic, assign) NSInteger productTypeTag;
/// 开店时间
@property (nonatomic, copy) NSString *openTime;


@end


NS_ASSUME_NONNULL_END

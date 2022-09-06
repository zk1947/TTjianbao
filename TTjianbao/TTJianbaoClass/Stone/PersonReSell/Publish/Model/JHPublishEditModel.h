//
//  JHPublishEditModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/5/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// <附件：图片、视频>
@interface JHPublishEditSourceModel : NSObject

/// 附件类型：0-未定义，1-图片，2-视频 = ['NONE', 'PICTURE', 'VIDEO']
@property (nonatomic, assign) NSInteger attachmentType;

///(string, optional): 视频覆盖图
@property (nonatomic, copy) NSString *coverUrl;

///地址
@property (nonatomic, copy) NSString *url;

@end

@interface JHPublishEditModel : NSObject

/// 订单code
@property (nonatomic, copy) NSString *sourceOrderCode;

/// 订单id
@property (nonatomic, copy) NSString *sourceOrderId;

/// 转售id
@property (nonatomic, copy) NSString *stoneResaleId;

///标题
@property (nonatomic, copy) NSString *goodsTitle;

///描述
@property (nonatomic, copy) NSString *goodsDesc;

/// 商品数量
@property (nonatomic, copy) NSString *goodsCount;

///重量
@property (nonatomic, copy) NSString *weight;

@property (nonatomic, copy) NSString *sourceType;

/// 价格
@property (nonatomic, copy) NSString *salePrice;

@property (nonatomic, copy) NSArray <JHPublishEditSourceModel *> *imgList;

@property (nonatomic, copy) NSArray <JHPublishEditSourceModel *> *videoList;

+ (void)getPublishModelWithStoneId:(NSString *)stoneId completeBlock:(nonnull void (^)(JHPublishEditModel * _Nonnull))completeBlock;

@end

NS_ASSUME_NONNULL_END

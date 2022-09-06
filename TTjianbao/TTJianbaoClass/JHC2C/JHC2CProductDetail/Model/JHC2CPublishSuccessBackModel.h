//
//  JHC2CPublishSuccessBackModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CPublishSuccessShareInfo : NSObject

///标题
@property (nonatomic, copy) NSString* title;
///描述
@property (nonatomic, copy) NSString* desc;
///图片
@property (nonatomic, copy) NSString* img;
///跳转地址
@property (nonatomic, copy) NSString* url;
///自定义朋友圈全标题
@property (nonatomic, copy) NSString* fullTitle;

@end

@interface JHC2CPublishSuccessOrder : NSObject

///订单Id
@property (nonatomic, copy) NSString* orderId;
///订单编号
@property (nonatomic, copy) NSString* orderCode;
///订单状态
@property (nonatomic, copy) NSString* orderStatus;
///支付过期时间点
@property (nonatomic, copy) NSString* payExpiredTime;

@end




@interface JHC2CPublishSuccessBackModel : NSObject

///商品Id
@property (nonatomic, copy) NSString* productId;
///商品编码
@property (nonatomic, copy) NSString* productSn;

/// 分享信息
@property(nonatomic, strong) JHC2CPublishSuccessShareInfo * shareInfo;

/// 订单信息
@property(nonatomic, strong) JHC2CPublishSuccessOrder * order;

@end

NS_ASSUME_NONNULL_END

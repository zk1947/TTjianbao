//
//  JHUnionPaySDKManager.h
//  TTjianbao
//
//  Created by yaoyao on 2020/6/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoMarcoEnum.h"
#import "WXApi.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHUnionPayResultInfo : NSObject
/*
字段名    变量名    类型    长度    输入/选择    备注
结果码    resultCode    C        M    “0000”表示成功 商户订单是否成功支付应该以商户后台收到支付结果为准，此处返回的结果仅作为支付请求的发送结果
结果信息    resultInfo    C        M    接口返回的状态描述，为JSON字符串
结果描述    resultMsg    C        M    支付结果描述
附加信息    extraMsg    C        M    支付结果附加的信息
原始信息    rawMsg    C        M    原始支付渠道返回的信息

结果码
0000    支付请求发送成功。商户订单是否成功支付应该以商户后台收到支付结果。
1000    用户取消支付
1001    参数错误
1002    网络连接错误
1003    支付客户端未安装
2001    订单处理中，支付结果未知(有可能已经支付成功)，请通过后台接口查询订单状态
2002    订单号重复
2003    订单支付失败
9999    其他支付错误
*/

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, copy) NSString *resultCode;
@property (nonatomic, copy) NSString *resultInfo;
@property (nonatomic, copy) NSString *resultMsg;
@property (nonatomic, copy) NSString *extraMsg;
@property (nonatomic, copy) NSString *rawMsg;

@end

@interface JHUnionPaySDKManager : NSObject

/// 初始化银联支付
+ (void)startUniconPay;


/// 调起银联支付
/// @param payType 1 微信支付  3支付宝支付 参照JHPayType
/// @param payData payData description
/// @param callbackBlock callbackBlock description
+ (void)payWithPayChannelType:(JHPayType)payType payData:(id)payData callbackBlock:(void(^)(JHUnionPayResultInfo *result))callback;

+ (BOOL)handleOpenURL:(NSURL *)url withDelegate:(id<WXApiDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END

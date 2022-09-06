//
//  JHLiveApiManager.h
//  TTjianbao
//
//  Created by jiangchao on 2020/9/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLiveUserStatus.h"
#import "JHCustomizePackageFlyOrderModel.h"

@interface JHLiveApiManager : NSObject
/// 请求发起连麦接口
+ (void)applyConnectMic:(NSString*)roomId images:(NSArray*)imgList  Completion:(JHApiRequestHandler)completion;

//申请回收
+ (void)applyRecycleConnectMic:(NSString*)roomId images:(NSArray*)imgList  Completion:(JHApiRequestHandler)completion;
/// 请求发起定制
+ (void)applyConnectCustomize:(NSString*)roomId orderCategory:(NSString*)orderCategory customizeOrderId:(NSString*)orderId Completion:(JHApiRequestHandler)completion;

//定制主播反向连麦
+ (void)reverseApplyConnectCustomize:(NSString*)roomId viewerId:(NSString*)viewerId Completion:(JHApiRequestHandler)completion;

//回收主播反向连麦
+ (void)reverseApplyConnectRecycle:(NSString*)roomId viewerId:(NSString*)viewerId Completion:(JHApiRequestHandler)completion;
//获取人数 （申请连麦成功调用，点击等待鉴定按钮调用）
+(void)getMicWaitingCountComplete:(JHFinishBlock)complete;

//获取回收等待人数
+(void)getRecycleMicWaitingCountComplete:(JHFinishBlock)complete;
//获取定制人数
+(void)getCustomizeWaitingCountComplete:(JHFinishBlock)complete;

+(void)audienceEnter:(NSString*)roomId;
+(void)audienceOut:(NSString*)roomId;


/// 创建定制套餐飞单
+ (void)createCustomizePackage:(NSString *)customerId Completion:(JHApiRequestHandler)completion;

/// 判断用户是否可以使用定制套餐飞单
+ (void)checkUserCanUseCustomizePackage:(NSInteger)customerId version:(NSString *)version Completion:(void(^_Nullable)(NSError *_Nullable error,RequestModel * _Nullable respondObject))completion;

/// 商家端查看用户可定制订单
+ (void)checkUserCustomizeListPackageWithCustomerId:(NSInteger)customerId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize Completion:(void(^)(NSError *_Nullable error, NSArray<JHCheckCustomizeOrderListModel *> *_Nullable array))completion;
@end


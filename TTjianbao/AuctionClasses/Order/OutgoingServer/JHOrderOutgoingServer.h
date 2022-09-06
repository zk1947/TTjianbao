//
//  JHOrderOutgoingServer.h
//  TTjianbao
//
//  Created by miao on 2021/7/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHOrderConfirmViewController;
@class JHOrderConfirmEntryDataObject;

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderOutgoingServer : NSObject

/// 统一获取提交订单页的方法（JHOrderConfirmViewController）
/// @param jumpObject 跳转对象
+(JHOrderConfirmViewController *)getOrderConfirmVC:(JHOrderConfirmEntryDataObject *)jumpObject;

@end

NS_ASSUME_NONNULL_END

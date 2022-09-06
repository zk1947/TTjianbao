//
//  JHGraphicOrderDetailViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  鉴定订单详情页

#import "JHBaseViewController.h"
#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"
#import "JHOrderDetailMode.h"
#import "JHGraphiclOrderDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphicOrderDetailViewController : JHBaseViewExtController

/// 创建鉴定的详情
/// @param recordInfoId  图文信息鉴定id
- (instancetype)initWithOrderInfoId:(NSString *)aOrderId
                          orderCode:(NSString *)aOrderCode
                           delegate:(id<JHGraphicalSubListVCDelegate>) aDelegate;
                             
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END

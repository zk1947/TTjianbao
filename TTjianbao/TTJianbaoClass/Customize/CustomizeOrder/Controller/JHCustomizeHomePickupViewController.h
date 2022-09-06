//
//  JHCustomizeHomePickupViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  预约上门取件
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN
@class OrderMode;
@interface JHCustomizeHomePickupViewController : JHBaseViewExtController
@property(nonatomic, copy) NSString* orderId;
@property(nonatomic, assign) BOOL  isSeller;
///来源：订单支付成功页，订单列表，订单详情
@property (nonatomic, copy) NSString *fromString;
@property (nonatomic, strong) OrderMode *orderMode;
@end

NS_ASSUME_NONNULL_END

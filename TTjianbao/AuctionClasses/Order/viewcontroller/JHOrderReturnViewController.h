//
//  JHOrderReturnViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN
@interface JHOrderReturnViewController : JHBaseViewExtController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *refundExpireTime;
//@property (nonatomic, strong) OrderMode *orderMode;
@property (nonatomic, assign) BOOL directDelivery;//是否直发
@end

NS_ASSUME_NONNULL_END

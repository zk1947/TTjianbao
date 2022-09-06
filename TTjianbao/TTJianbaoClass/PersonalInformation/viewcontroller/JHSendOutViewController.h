//
//  JHSendOutViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHOrderDetailMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSendOutViewController : JHBaseViewExtController
@property (nonatomic,   copy) NSString          *orderId;
@property (nonatomic, assign) BOOL               directDelivery; /// 直发标识
@property (nonatomic, strong) JHOrderDetailMode *orderShowModel;
@end

NS_ASSUME_NONNULL_END

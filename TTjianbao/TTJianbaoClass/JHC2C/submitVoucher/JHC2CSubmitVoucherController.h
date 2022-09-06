//
//  JHC2CSubmitVoucherController.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderMode.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSubmitVoucherController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(strong,nonatomic) NSString* workOrderId;
@property(copy,nonatomic) JHFinishBlock successBlock;

@end

NS_ASSUME_NONNULL_END

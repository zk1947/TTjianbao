//
//  JHMarketOrderRefundViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHMarketOrderModel.h"
#import "JHC2CRefundDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderRefundViewController : JHBaseViewController

@property (nonatomic, strong) JHMarketOrderModel *orderModel;
@property (nonatomic, copy) NSString *orderId;
//完成回调
@property (nonatomic, copy) void(^completeBlock)(void);
@property (nonatomic, strong) JHRefundOperationListModel *operationListModel;
@property (nonatomic, copy) NSString *workOrderId;
@end

NS_ASSUME_NONNULL_END

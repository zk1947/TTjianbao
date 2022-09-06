//
//  JHMarketOrderRefusedRefundViewController.h
//  TTjianbao
//
//  Created by 张坤 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//拒绝退货/退款

#import "JHBaseViewController.h"
#import "JHImagePickerPublishManager.h"

NS_ASSUME_NONNULL_BEGIN

/// 集市拒绝退货/退款
@interface JHMarketOrderRefusedRefundViewController : JHBaseViewController
/// 提交完成，刷新上层数据
@property (nonatomic, strong) RACSubject *reloadUPData;
@property (nonatomic, copy) NSString *orderId;
/// 工单状态
@property (nonatomic, copy) NSString *workOrderStatus;
/// 工单编号
@property (nonatomic, copy) NSString *workOrderId;
@end

NS_ASSUME_NONNULL_END



//
//  JHRefundBaseTableCell.h
//  TTjianbao
//
//  Created by hao on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHC2CRefundDetailModel.h"
#import "JHChatOrderInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundBaseTableCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
///订单编号
@property (nonatomic, copy) NSString *orderId;
///订单状态code
@property (nonatomic, copy) NSString *orderStatusCode;
///用户身份 1:买家 2:卖家
@property (nonatomic, assign) NSInteger userIdentity;
///工单编号
@property (nonatomic, copy) NSString *workOrderId;
///工单状态
@property (nonatomic, copy) NSString *workOrderStatus;
/// 对方ID -accId customerId  二者传其一即可
@property (nonatomic, copy) NSString *receiveaAccount;
/// 用户ID - customerId
@property (nonatomic, copy) NSString *userId;
/// 订单信息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;

@property (nonatomic, copy) JHFinishBlock reloadDataBlock;
//数据绑定
- (void)bindViewModel:(id)dataModel;
- (NSString *)timestampSwitchTime:(NSInteger)timestamp;
@end

NS_ASSUME_NONNULL_END

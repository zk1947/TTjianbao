//
//  JHStonePersonReSellPublishController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/5/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStonePersonReSellPublishController : JHBaseViewController

/// 原石个人转售Id(编辑才传)
@property (nonatomic, copy) NSString *stoneResaleId;

@property (nonatomic, copy) dispatch_block_t editSuccessBlock;

/// 源订单id(转售)
@property (nonatomic, copy) NSString *sourceOrderId;

/// 源订单code(转售)
@property (nonatomic, copy) NSString *sourceOrderCode;

/// 转售原石来源：0-原石（从已完成订单过来的）、1-回血（从买入原石列表过来的），默认1 ,
@property (nonatomic, copy) NSString *sourceTypeFlag;

@end

NS_ASSUME_NONNULL_END

//
//  JHMarketOrderDetailViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderDetailViewController : JHBaseViewController

@property (nonatomic, copy) NSString *orderId;

/** 是否是买家*/
@property (nonatomic, assign) BOOL isBuyer;

/** 通知刷新UI*/
@property (nonatomic, copy) void(^completeRefreshBlock)(BOOL isDelete);
@end

NS_ASSUME_NONNULL_END

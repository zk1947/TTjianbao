//
//  JHImageTextAuthDetailViewController.h
//  TTjianbao
//
//  Created by zk on 2021/6/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  鉴定详情

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHImageTextAuthDetailViewController : JHBaseViewController

@property (nonatomic, assign) int recordInfoId;//图文信息鉴定id
@property (nonatomic, assign) int taskId;//图文信息鉴定id
@property(assign,nonatomic) BOOL  isFromIdentify;
@end

NS_ASSUME_NONNULL_END

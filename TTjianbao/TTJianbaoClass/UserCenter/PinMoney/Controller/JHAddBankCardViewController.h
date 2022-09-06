//
//  JHAddBankCardViewController.h
//  TTjianbao
//  Description:添加银行卡
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class JHWithdrawInfoModel;

@interface JHAddBankCardViewController : JHBaseViewController

- (void)setShowData:(JHWithdrawInfoModel*)model;
@end

NS_ASSUME_NONNULL_END

//
//  JHStonePinMoneySubViewController.h
//  TTjianbao
//  Description:原石零钱:tab下子controller-@"收入明细", @"提现明细", @"未入账", @"提现中"
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTableViewController.h"
#import "JHStonePinMoneyDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStonePinMoneySubViewController : JHTableViewController

- (instancetype)initWithPageType:(JHStonePinMoneySubPageType)type;
- (void)refreshPage;
@end

NS_ASSUME_NONNULL_END

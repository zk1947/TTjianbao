//
//  JHWithdrawViewController.h
//  TTjianbao
//  Description:提现
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHStonePinMoneyDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHWithdrawViewController : JHBaseViewController

@property (nonatomic, assign) BOOL shouldRefreshPage;
@property (nonatomic, strong) NSString* withdrawableText;
@end

NS_ASSUME_NONNULL_END

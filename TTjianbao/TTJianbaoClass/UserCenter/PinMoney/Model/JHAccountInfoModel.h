//
//  JHAccountInfoModel.h
//  TTjianbao
//  Description:零钱header上信息
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAccountInfoModel : JHRespModel

@property (nonatomic, strong) NSString* incomeFreezeAccount;// (number, optional): 未入账账户 ,待结算
@property (nonatomic, strong) NSString* withdrawAccount;// (number, optional): 可提现账户

@property (nonatomic, strong) NSString* alreadyIncomeAccount;// 已结算

@end

NS_ASSUME_NONNULL_END

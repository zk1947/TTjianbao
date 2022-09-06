//
//  JHWithdrawInfoModel.h
//  TTjianbao
//  Description:提现申请 页面信息
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHAccountReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHWithdrawInfoReqModel : JHAccountReqModel

@property (nonatomic, strong) NSString* money;

@end

@interface JHWithdrawInfoModel : JHRespModel

@property (nonatomic, strong) NSString* accountName; //(string, optional): 户名 ,
@property (nonatomic, strong) NSString* accountNo; //(string, optional): 银行卡号 ,
@property (nonatomic, strong) NSString* bankBranch; //(string, optional): 银行支行名 ,
@property (nonatomic, strong) NSString* bankName; //(string, optional): 银行名 ,
@property (nonatomic, strong) NSString* withdrawMoney; //(number, optional): 可提现金额
@property (strong,nonatomic) NSString * cardType; /// 银行卡类型

@end

NS_ASSUME_NONNULL_END

//
//  JHAccountModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAccountModel : NSObject
@property (nonatomic, copy) NSString * balance ;//number, optional): 鉴豆总津贴 ,
@property (nonatomic, copy) NSString * cashBalance ;//number, optional): 现金总津贴 ,
@property (nonatomic, copy) NSString * cashFreeBalance ;//number, optional): 现金可用津贴 ,
@property (nonatomic, copy) NSString * cashFrozenBalance ;//number, optional): 现金冻结津贴 ,
@property (nonatomic, copy) NSString * customerPoint ;//integer, optional): 总积分 ,
@property (nonatomic, copy) NSString * freeBalance ;//number, optional): 鉴豆可用津贴 ,
@property (nonatomic, copy) NSString * freePoint ;//integer, optional): 可用积分 ,
@property (nonatomic, copy) NSString * frozenBalance ;//number, optional): 鉴豆冻结津贴 ,
@property (nonatomic, copy) NSString * frozenPoint ;//integer, optional): 冻结积分
@end


@interface JHBankInfoModel : NSObject
@property (nonatomic, copy) NSString * accountName;// (string, optional): 银行户名 ,
@property (nonatomic, copy) NSString * accountNo ;//(string, optional): 银行卡号 ,
@property (nonatomic, copy) NSString * bankBranch ;//(string, optional): 银行支行名 ,
@property (nonatomic, copy) NSString * bankCardId ;//(integer, optional): 银行卡ID ,
@property (nonatomic, copy) NSString * bankName;// (string, optional): 银行名称 ,
@property (nonatomic, assign) double totalWithdrawMoney;// (number, optional): 可提现金额
@property (nonatomic, copy) NSString * accountDate;

@property (nonatomic, copy) NSString * oldWithdrawMoney;

@property (nonatomic, copy) NSString * withdrawMoney;

@end
NS_ASSUME_NONNULL_END


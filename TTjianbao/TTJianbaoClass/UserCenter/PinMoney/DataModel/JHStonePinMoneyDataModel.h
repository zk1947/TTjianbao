//
//  JHStonePinMoneyDataModel.h
//  TTjianbao
//  Description:个人中心-原石零钱:数据管理
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAccountInfoModel.h"
#import "JHAccountFlowModel.h"
#import "JHWithdrawApplyReqModel.h"
#import "JHWithdrawInfoModel.h"
#import "JHAddBankcardReqModel.h"

#define kStonePinMoneyData kSingleInstance(JHStonePinMoneyDataModel)

#ifdef JH_UNION_PAY
typedef NS_ENUM(NSUInteger, JHStonePinMoneySubPageType) {
    JHStonePinMoneySubPageTypeUnaccount, //未入账 > 待结算
    JHStonePinMoneySubPageTypeIncomeDetail, //收入明细 > 已结算
    JHStonePinMoneySubPageTypeWithdrawing, //提现中
    JHStonePinMoneySubPageTypeWithdrawDetail, //提现明细
};
#else
 typedef NS_ENUM(NSUInteger, JHStonePinMoneySubPageType) {
    JHStonePinMoneySubPageTypeIncomeDetail, //收入明细
    JHStonePinMoneySubPageTypeWithdrawDetail, //提现明细
    JHStonePinMoneySubPageTypeUnaccount, //未入账
    JHStonePinMoneySubPageTypeWithdrawing //提现中
 };
#endif

NS_ASSUME_NONNULL_BEGIN

@interface JHStonePinMoneyDataModel : NSObject

singleton_h(JHStonePinMoneyDataModel)

//零钱header上信息
- (void)requestAccountInfoWith:(NSString*)customerId type:(NSString*)customerType response:(JHResponse)resp;
//零钱4tab信息,根据type区分
- (void)requestAccountFlowWith:(NSString*)customerId type:(NSString*)customerType pageType:(NSUInteger)pageType pageIndex:(JHStonePinMoneySubPageType)index response:(JHResponse)resp;
//提现申请
- (void)requestWithdrawApplyWith:(NSString*)customerId type:(NSString*)customerType money:(NSString*)money response:(JHResponse)resp;
//提现申请 页面信息
- (void)requestWithdrawInfoWith:(NSString*)customerId type:(NSString*)customerType money:(NSString*)money response:(JHResponse)resp;
//添加银行卡
- (void)requestAddBankcardWith:(NSString*)accountName cardNo:(NSString*)accountNo bank:(NSString*)bankName response:(JHResponse)resp;

@end

NS_ASSUME_NONNULL_END

//
//  JHStonePinMoneyDataModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStonePinMoneyDataModel.h"

@implementation JHStonePinMoneyDataModel

singleton_m(JHStonePinMoneyDataModel)

- (void)requestAccountInfoWith:(NSString*)customerId type:(NSString*)customerType response:(JHResponse)resp
{
    JHAccountReqModel* model = [JHAccountReqModel new];
    model.customerId = customerId;
    model.customerType = customerType;
    [self request:model response:^(id respData, NSString *errorMsg) {
        JHAccountInfoModel* data = [JHAccountInfoModel convertData:respData];
        resp(data, errorMsg);
    }];
}

- (void)requestAccountFlowWith:(NSString*)customerId type:(NSString*)customerType pageType:(NSUInteger)pageType pageIndex:(JHStonePinMoneySubPageType)index response:(JHResponse)resp
{
    JHAccountFlowReqModel* model = [JHAccountFlowReqModel new];
    model.customerId = customerId;
    model.customerType = customerType;
    model.accountType = [self convertAccountTypeFromPageType:pageType];
    model.pageIndex = index;
    
    [self request:model response:^(id respData, NSString *errorMsg) {
        NSArray* array = [JHAccountFlowModel convertData:respData];
        resp(array, errorMsg);
    }];
}

- (void)requestWithdrawApplyWith:(NSString*)customerId type:(NSString*)customerType money:(NSString*)money response:(JHResponse)resp
{
    JHWithdrawApplyReqModel* model = [JHWithdrawApplyReqModel new];
    model.customerId = customerId;
    model.customerType = customerType;
    model.money = money;
    [self request:model response:resp];
}

- (void)requestWithdrawInfoWith:(NSString*)customerId type:(NSString*)customerType money:(NSString*)money response:(JHResponse)resp
{
    JHWithdrawInfoReqModel* model = [JHWithdrawInfoReqModel new];
    model.customerId = customerId;
    model.customerType = customerType;
    model.money = money;
    [self request:model response:^(id respData, NSString *errorMsg) {
        JHWithdrawInfoModel* data = [JHWithdrawInfoModel convertData:respData];
        resp(data, errorMsg);
    }];
}

- (void)requestAddBankcardWith:(NSString*)accountName cardNo:(NSString*)accountNo bank:(NSString*)bankName response:(JHResponse)resp
{
    JHAddBankcardReqModel* model = [JHAddBankcardReqModel new];
    model.accountName = accountName;
    model.accountNo = accountNo;
    model.bankName = bankName;
    [self request:model response:resp];
}

- (void)request:(JHReqModel*)model response:(JHResponse)resp
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

#pragma mark -
- (NSUInteger)convertAccountTypeFromPageType:(JHStonePinMoneySubPageType)index
{
    NSUInteger type;
    switch (index)
    {
        case JHStonePinMoneySubPageTypeIncomeDetail:
        default:
            type = 21;
            break;
            
        case JHStonePinMoneySubPageTypeWithdrawDetail:
            type = 20;
            break;
            
        case JHStonePinMoneySubPageTypeUnaccount:
            type = 11;
            break;
            
        case JHStonePinMoneySubPageTypeWithdrawing:
            type = 10;
            break;
    }
    
    return type;
}

@end

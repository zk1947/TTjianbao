//
//  JHBillTotalViewModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHMyShopModel.h"
#import "JHBillTotalViewModel.h"
#import "SVProgressHUD.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoKeyword.h"

#define STRING_APPEND(a,b) [NSString stringWithFormat:@"%@%.2f",a,b]

@implementation JHBillTotalViewModel


-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/account-info/detail-total") Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if(IS_DICTIONARY(respondObject.data))
        {
            _dataSource = [JHBillTotalModel mj_objectWithKeyValues:respondObject.data];
            
            [self configDataArray];
        }
        [subscriber sendNext:@1];
        [subscriber sendCompleted];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

-(RACCommand *)totalMoneyRequestCommand
{
    if (!_totalMoneyRequestCommand) {
        @weakify(self);
        _totalMoneyRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                [self totalMoneyRequestDataWithSubscriber:subscriber];
                return nil;
            }];
            
        }];
    }
    return _totalMoneyRequestCommand;
}

- (void)totalMoneyRequestDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    UserInfoRequestManager *user = [UserInfoRequestManager sharedInstance];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/withdraw/myWithdrawAccount") Parameters:@{@"customerType" : @(user.user.type) , @"customerId":user.user.customerId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (IS_DICTIONARY(respondObject.data)) {
            JHMyShopModel *model = [JHMyShopModel mj_objectWithKeyValues:respondObject.data];
            self.accountDate = model.accountDate;
            [subscriber sendNext:PRICE_FLOAT_TO_STRING(model.totalMoney)];
        }
        
        [subscriber sendCompleted];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@"0"];
        [subscriber sendCompleted];
    }];
}

-(void)configDataArray
{
#ifdef JH_UNION_PAY
    [self.dataArray addObject:@{@"title":@"收入统计",@"imageName":@"icon_shop_bill_in",@"data":@[@{@"title":@"销售额",@"money": self.dataSource.originalOrderPriceAmountStr,@"tip":@1},@{@"title":@"待结算",@"money": self.dataSource.waitSettleAmountStr,@"tip":@1},@{@"title":@"已结算", @"money":self.dataSource.alreadySettleAmountStr,@"tip":@1}]}];
#else
      [self.dataArray addObject:@{@"title":@"收入统计",@"imageName":@"icon_shop_bill_in",@"data":@[@{@"title":@"销售额",@"money": self.dataSource.originalOrderPriceAmountStr,@"tip":@1},@{@"title":@"已结算",@"money":self.dataSource.alreadySettleAmountStr,@"tip":@1},@{@"title":@"待结算",@"money": self.dataSource.waitSettleAmountStr,@"tip":@1}]}];
#endif
    
    [self.dataArray addObject:@{@"title":@"提现统计",@"imageName":@"icon_shop_bill_get",@"data":@[@{@"title":@"提现中",@"money": self.dataSource.withdrawIngAmountStr,@"tip":@1},@{@"title":@"已提现",@"money": self.dataSource.alreadyWithdrawAmountStr,@"tip":@0}]}];
    
    [self.dataArray addObject:@{@"title":@"退款统计",@"imageName":@"icon_shop_bill_out",@"data":@[@{@"title":@"退款处理中",@"money": self.dataSource.refundingAmountStr,@"tip":@1},@{@"title":@"待结算订单退款",@"money": self.dataSource.waitSettleRefundingAmountStr,@"tip":@0},@{@"title":@"已结算订单退款",@"money": self.dataSource.alreadySettleRefundingAmountStr,@"tip":@0}]}];
    
}
@end

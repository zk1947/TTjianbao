//
//  JHBillTotalModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillTotalModel.h"


@implementation JHBillTotalModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    self.originalOrderPriceAmountStr = [NSString stringWithFormat:@"￥%.2f",self.originalOrderPriceAmount];

    self.alreadySettleAmountStr = [NSString stringWithFormat:@"￥%.2f",self.alreadySettleAmount];
    
    self.waitSettleAmountStr = [NSString stringWithFormat:@"￥%.2f",self.waitSettleAmount];
    
    self.withdrawIngAmountStr = [NSString stringWithFormat:@"￥%.2f",self.withdrawIngAmount];
    
    self.alreadyWithdrawAmountStr = [NSString stringWithFormat:@"￥%.2f",self.alreadyWithdrawAmount];
    
    self.refundingAmountStr = [NSString stringWithFormat:@"￥%.2f",self.refundingAmount];
    
    self.waitSettleRefundingAmountStr = [NSString stringWithFormat:@"￥%.2f",self.waitSettleRefundingAmount];
    
    self.alreadySettleRefundingAmountStr = [NSString stringWithFormat:@"￥%.2f",self.alreadySettleRefundingAmount];
}

@end

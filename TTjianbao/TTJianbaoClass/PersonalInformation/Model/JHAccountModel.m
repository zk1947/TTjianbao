//
//  JHAccountModel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAccountModel.h"

@implementation JHAccountModel
- (NSString *)cashFreeBalance {
    if (_cashFreeBalance) {
        double d            = [_cashFreeBalance doubleValue];
        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _cashFreeBalance = [dn stringValue];
    }
    
 
    return _cashFreeBalance;
}

- (NSString *)cashFrozenBalance {
    if (_cashFrozenBalance) {
        double d            = [_cashFrozenBalance doubleValue];
        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _cashFrozenBalance = [dn stringValue];
    }
    
    
    return _cashFrozenBalance;
}

@end

@implementation JHBankInfoModel

@end





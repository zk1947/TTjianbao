//
//  JHAmountRecordModel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAmountRecordModel.h"

@implementation JHAmountRecordModel
- (NSString *)changeAmount {
    if (_changeAmount) {
        double d            = [_changeAmount doubleValue];
        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _changeAmount         = [dn stringValue];
    }
    return _changeAmount;

}
@end

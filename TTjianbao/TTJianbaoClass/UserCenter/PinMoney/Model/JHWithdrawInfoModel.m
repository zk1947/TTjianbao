//
//  JHWithdrawInfoModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHWithdrawInfoModel.h"

@implementation JHWithdrawInfoReqModel

- (NSString *)uriPath
{
    return @"/app/withdraw/form";
}

@end

@implementation JHWithdrawInfoModel

- (void)setAccountName:(NSString *)accountName {
    _accountName = accountName.copy;
    if (_accountName.length == 0) {
        _accountName = @"";
    }
}

- (void)setAccountNo:(NSString *)accountNo {
    _accountNo = accountNo.copy;
    if (_accountNo.length == 0) {
        _accountNo = @"";
    }
}

- (void)setCardType:(NSString *)cardType {
    _cardType = cardType.copy;
    if (_cardType.length == 0) {
        _cardType = @"";
    }
}

- (void)setBankName:(NSString *)bankName {
    _bankName = bankName.copy;
    if (_bankName.length == 0) {
        _bankName = @"";
    }
}

- (void)setBankBranch:(NSString *)bankBranch {
    _bankBranch = bankBranch.copy;
    if (_bankBranch.length == 0) {
        _bankBranch = @"";
    }
}

@end

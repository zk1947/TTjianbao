//
//  WXPayDataMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXPayDataMode : NSObject
@property (nonatomic, strong) NSString *partnerid;
@property (nonatomic, strong) NSString *prepayid;
@property (nonatomic, strong) NSString *package;
@property (nonatomic, strong) NSString *noncestr;
@property (nonatomic, strong) NSString *sign;
@property (nonatomic, strong) NSString *out_trade_no; //TODO:JH_UNION_PAY
@property (nonatomic, assign) UInt32 timestamp;

/// 322改成银联支付 只需要这一个字段调起支付
@property (nonatomic, copy) NSString *appPayRequest;
@property (nonatomic, strong) NSString *outTradeNo;

/// 红包支付使用token调起支付
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *relevanceId;
@property (nonatomic, strong) NSString *payWay;
@end

@interface ALiPayDataMode : NSObject
@property (nonatomic, strong) NSString *outTradeNo;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, copy) NSString *appPayRequest;
@end


@interface BankPayDataMode : NSObject
@property (nonatomic, strong) NSString *accountName;
@property (nonatomic, strong) NSString *accountNo;
@property (nonatomic, strong) NSString *bankBranch;
@property (nonatomic, strong) NSString *Id;
@end


@interface PayResultMode : NSObject
@property (nonatomic, strong) NSString *balance;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *return_code;
@property (nonatomic, strong) NSString *return_msg;
@end




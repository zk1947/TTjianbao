//
//  WXPayDataMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "WXPayDataMode.h"

@implementation WXPayDataMode

@end

@implementation ALiPayDataMode

@end

@implementation BankPayDataMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             };
}
@end

@implementation PayResultMode

@end


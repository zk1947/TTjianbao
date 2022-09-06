//
//  JHChatUserInfo.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatUserInfo.h"

@implementation JHChatUserInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"userId" : @"customerAccId",
        @"customerId" : @"customerId",
        @"nickName" : @"customerName",
        @"vatarUrl" : @"customerIcon",
    };
}
@end

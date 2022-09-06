//
//  JHLuckyBagModel.m
//  TTjianbao
//
//  Created by zk on 2021/11/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagModel.h"

@implementation JHLuckyBagModel

@end

@implementation JHLuckyBagPlatformModel
//modelCustomPropertyMapper
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return@{@"ID" :@"id"};
}

@end

@implementation JHLuckyBagMarchantModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return@{@"ID" :@"id"};
}

@end

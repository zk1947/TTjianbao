//
//  JHLuckyBagTaskModel.m
//  TTjianbao
//
//  Created by zk on 2021/11/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagTaskModel.h"

@implementation JHLuckyBagTaskModel

@end

@implementation JHLuckyBagTaskInfoModel

@end

@implementation JHLuckyBagTaskRewardModel

@end

@implementation CustomerBagTagModel

- (NSInteger)sellerConfigId{
    if (_sellerConfigId == 0) {
        return _ID;
    }
    return _sellerConfigId;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return@{@"ID" :@"id"};
}

@end

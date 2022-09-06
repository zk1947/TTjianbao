//
//  JHNewStoreSpecialModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSpecialModel.h"

@implementation JHNewStoreSpecialShowTabModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"specialTabId" : @"id"};
}
@end

@implementation JHNewStoreSpecialModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"showTabs" : @"JHNewStoreSpecialShowTabModel",
    };
}
@end

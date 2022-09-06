//
//  JHRecycleLogisticsModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleLogisticsModel.h"

@implementation JHRecycleLogisticsListModel

@end

@implementation JHRecycleLogisticsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"logisticsId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"data" : [JHRecycleLogisticsListModel class]
    };
}
@end

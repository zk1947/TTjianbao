//
//  JHStealTowerModel.m
//  TTjianbao
//
//  Created by zk on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStealTowerModel.h"

@implementation JHStealTowerModel

@end

@implementation JHStealTowerHeadModel
+ (NSDictionary *)replacedKeyFromPropertyName{
     return @{
               @"ID" : @"id"
              };
}
@end

@implementation JHStealTowerContentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"resultList" : [JHNewStoreHomeGoodsProductListModel class]
    };
}
@end


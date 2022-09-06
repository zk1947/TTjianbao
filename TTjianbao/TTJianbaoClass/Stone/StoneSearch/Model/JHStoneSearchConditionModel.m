//
//  JHStoneSearchConditionModel.m
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionModel.h"

@implementation JHStoneSearchConditionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation JHStoneSearchConditionSelectModel

-(NSMutableArray *)labelIdList
{
    if(!_labelIdList)
    {
        _labelIdList = [NSMutableArray new];
    }
    return _labelIdList;
}
@end

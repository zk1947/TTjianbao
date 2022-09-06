//
//  JHNewStoreTypeModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreTypeModel.h"

@implementation JHNewStoreTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"children" : JHNewStoreTypeModel.class};
}
@end

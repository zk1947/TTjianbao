//
//  JHGoodManagerFilterModel.m
//  TTjianbao
//
//  Created by user on 2021/8/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerFilterModel.h"

@implementation JHGoodManagerFilterModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"cateId":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"children" : [JHGoodManagerFilterModel class],
    };
}



@end

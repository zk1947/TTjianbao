//
//  JHServiceManageModel.m
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHServiceManageModel.h"

@implementation JHServiceManageModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"termsList" : [JHServiceManageItemModel class]
    };
}

@end

@implementation JHServiceManageItemModel
@end

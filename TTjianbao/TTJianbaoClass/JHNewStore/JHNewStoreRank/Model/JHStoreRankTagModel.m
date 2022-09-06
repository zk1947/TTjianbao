//
//  JHStoreRankTagModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreRankTagModel.h"


@implementation JHStoreRankTagListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"tagId":@"id"};
}
@end

@implementation JHStoreRankTagModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"tagList" : [JHStoreRankTagListModel class]
    };
}
@end

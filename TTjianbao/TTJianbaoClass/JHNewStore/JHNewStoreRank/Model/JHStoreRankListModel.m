//
//  JHStoreRankListModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreRankListModel.h"
@implementation JHStoreRankPictureModel

@end

@implementation JHStoreRankProductModel

@end

@implementation JHStoreRankListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"storeId":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productList" : [JHStoreRankProductModel class]
    };
}
@end


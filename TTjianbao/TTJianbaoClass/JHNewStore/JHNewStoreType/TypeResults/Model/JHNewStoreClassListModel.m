//
//  JHNewStoreClassListModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassListModel.h"

@implementation JHNewStoreClassListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productList" : [JHNewStoreHomeGoodsProductListModel class],
    };
}
@end

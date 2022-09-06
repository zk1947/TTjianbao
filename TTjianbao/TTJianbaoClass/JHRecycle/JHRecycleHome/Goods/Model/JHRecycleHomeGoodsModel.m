//
//  JHRecycleHomeGoodsModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsModel.h"

@implementation JHRecycleHomeGoodsResultProductImageModel
@end

@implementation JHRecycleHomeGoodsResultListModel
@end


@implementation JHRecycleHomeGoodsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"resultList" : [JHRecycleHomeGoodsResultListModel class]
    };
}

@end

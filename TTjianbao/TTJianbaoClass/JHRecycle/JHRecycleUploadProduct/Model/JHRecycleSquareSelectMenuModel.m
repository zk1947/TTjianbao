//
//  JHRecycleSquareSelectMenuModel.m
//  TTjianbao
//
//  Created by hao on 2021/7/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSquareSelectMenuModel.h"

@implementation JHRecycleSquareSelectMenuListModel
@end


@implementation JHRecycleSquareSelectMenuModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"categorys": JHRecycleSquareSelectMenuListModel.class,
             @"highQualityDicts": JHRecycleSquareSelectMenuListModel.class,
             @"sourceDicts": JHRecycleSquareSelectMenuListModel.class
    };
}
@end

//
//  JHMarketHomeModel.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketHomeModel.h"

@implementation JHMarketHomeModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"operationSubjectList" : [JHMarketHomeKingKongItemModel class],
        @"operationPosition" : [JHMarketHomeSpecialItemModel class]
    };
}
@end

@implementation JHMarketHomeSearchWordListItemViewModel

@end

@implementation JHMarketHomeKingKongItemModel

@end

@implementation JHMarketHomeKingKongTargetModel

@end

@implementation JHMarketHomeSpecialItemModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"definiDetails" : [JHMarketHomeSpecialSubItemModel class]
    };
}
@end

@implementation JHMarketHomeSpecialSubItemModel

@end

@implementation JHMarketHomeSpecialSubTowItemModel

@end


@implementation JHMarketHomeGoodsListItemModel

@end

@implementation JHMarketHomeHotTopItemModel

@end

@implementation JHMarketHomeLikeStatusModel

@end



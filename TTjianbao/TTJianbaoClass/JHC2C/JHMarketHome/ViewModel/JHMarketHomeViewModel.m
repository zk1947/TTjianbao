//
//  JHMarketHomeViewModel.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketHomeViewModel.h"

@implementation JHMarketHomeViewModel
@end

@implementation JHMarketHomeSearchWordListViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productListBeanList" : [JHMarketHomeSearchWordListItemViewModel class]
    };
}
@end

@implementation JHMarketHomeCellStyleKingKongViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"operationSubjectList" : [JHMarketHomeKingKongItemModel class]
    };
}
@end

@implementation JHMarketHomeCellStyleBgAdViewModel
@end

@implementation JHMarketHomeCellStyleSpecialViewModel
@end

@implementation JHMarketHomeCellStyleGoodsViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productList" : [JHC2CProductBeanListModel class],
        @"hotTopicResponses" : [JHMarketHomeHotTopItemModel class]
    };
}
@end


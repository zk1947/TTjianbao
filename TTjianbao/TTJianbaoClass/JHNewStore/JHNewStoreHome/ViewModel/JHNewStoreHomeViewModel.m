//
//  JHNewStoreHomeViewModel.m
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeViewModel.h"


@implementation JHNewStoreHomeCellStyle_MallModelViewModel
@end

@implementation JHNewStoreHomeCellStyle_BannerViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"slideShow" : [JHMallBannerModel class]
    };
}
@end

@implementation JHNewStoreHomeCellStyle_KingKongViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"operationSubjectList" : [JHMallCategoryModel class]
    };
}
@end

@implementation JHNewStoreHomeCellStyle_BgAdViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"operationPosition" : [JHMallCategoryModel class]
    };
}
@end

@implementation JHNewStoreHomeCellStyle_NewPeopleViewModel
@end


@implementation JHNewStoreHomeCellStyle_BoutiqueViewModel
//+ (NSDictionary *)mj_objectClassInArray {
//    return @{
//        @"showList" : [JHNewStoreHomeBoutiqueShowListModel class]
//    };
//}
@end

@implementation JHNewStoreHomeCellStyle_GoodsLineViewModel

@end

@implementation JHNewStoreHomeCellStyle_GoodsViewModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productList" : [JHNewStoreHomeGoodsProductListModel class],
        @"recommendTabList" : [JHNewStoreHomeGoodsTabInfoModel class]
    };
}
@end


@implementation JHNewStoreHomeCellStyle_KillActivityViewModel


@end


//
//  JHNewStoreHomeReport.m
//  TTjianbao
//
//  Created by user on 2021/3/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeReport.h"

@implementation JHNewStoreHomeReport

+ (JHNewStoreHomeReport *)shared {
    static JHNewStoreHomeReport *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[JHNewStoreHomeReport alloc] init];
    });
    return helper;
}

/// 商城首页 - 搜索框点击事件上报
+ (void)jhNewStoreSearchViewClickReport {
    NSDictionary *dic = @{
        @"page_position":@"天天商城首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"searchButtonClick" params:dic type:JHStatisticsTypeSensors];
}

/// 顶部导航教育信息点击事件
+ (void)jhNewStoreHomeGoToEducationClick {
    NSDictionary *dic = @{
        @"store_from":@"天天商城首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"dbdhjyxxClick" params:dic type:JHStatisticsTypeSensors];
}


/// 商城首页 - 金刚位点击上报
+ (void)jhNewStoreHomeKingKongClickReport:(NSString *)jgw_name
                            position_sort:(NSString *)position_sort {
    NSDictionary *dic = @{
        @"page_position":@"天天商城首页",
        @"jgw_name":NONNULL_STR(jgw_name),
        @"position_sort":NONNULL_STR(position_sort)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"jgwClick" params:dic type:JHStatisticsTypeSensors];
}


/// 商城首页 - 轮播图点击上报
+ (void)jhNewStoreHomeBannerClickReport:(NSString *)page_position
                          position_sort:(NSInteger)position_sort
                            content_url:(NSString *)content_url
                               ad_title:(NSString *)ad_title {
    NSDictionary *dic = @{
        @"ad_title":NONNULL_STR(ad_title),
        @"page_position":NONNULL_STR(page_position),
        @"position_sort":@(position_sort),
        @"content_url":NONNULL_STR(content_url)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 横幅广告点击
+ (void)jhNewStoreHomeAdClickReport:(NSString *)ad_id
                           ad_title:(NSString *)ad_title
                      position_sort:(NSInteger)position_sort {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:ad_id forKey:@"ad_id"];
    [params setValue:ad_title forKey:@"ad_title"];
    [params setValue:@(position_sort) forKey:@"position_sort"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"hfadClick" params:params type:JHStatisticsTypeSensors];

}

/// 商城首页 - 新人活动点击
+ (void)jhNewStoreHomeNewPeopleClickReport:(NSString *)store_from {
    [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick"
                                          params:@{@"store_from" : NONNULL_STR(store_from)}
                                            type:JHStatisticsTypeSensors];
}

/// 商城首页 - Tab点击
+ (void)jhNewStoreHomeTabClickReport:(NSString *)tab_Name {
    NSDictionary *dic = @{@"tab_name":NONNULL_STR(tab_Name)};
    [JHAllStatistics jh_allStatisticsWithEventId:@"tabnavigationClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 专场分享点击
+ (void)jhNewStoreHomeBoutiqueShareClickReport:(NSString *)zc_name
                                       zc_type:(NSInteger)zc_type
                                         zc_id:(NSString *)zc_id {
    NSDictionary *dic = @{
        @"zc_name":NONNULL_STR(zc_name),
        @"zc_type":NONNULL_STR([self getZC_type:zc_type]),
        @"zc_id":NONNULL_STR(zc_id)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"zcfxClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 专场开售提醒点击
+ (void)jhNewStoreHomeBoutiqueWillActiveClickReport:(NSString *)zc_name
                                              zc_id:(NSString *)zc_id {
    NSDictionary *dic = @{
        @"zc_name":NONNULL_STR(zc_name),
        @"zc_id":NONNULL_STR(zc_id)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"zckstxClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 推荐商品筛选标签点击
+ (void)jhNewStoreHomeGoodsTabClickReport:(NSString *)tab_name {
    NSDictionary *dic = @{
        @"tab_name":NONNULL_STR(tab_name)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"tjspsxbqClick" params:dic type:JHStatisticsTypeSensors];
}

///// 商城首页 - 专场点击
//+ (void)jhNewStoreHomeBoutiqueClickReport:(NSString *)zc_name
//                                  zc_type:(NSInteger)zc_type /*01.预告，02.热卖，03.已结束*/
//                                    zc_id:(NSString *)zc_id
//                               store_from:(NSString *)store_from {
//    NSDictionary *dic = @{
//        @"zc_name":NONNULL_STR(zc_name),
//        @"zc_type":[self getZC_type:zc_type],
//        @"zc_id":NONNULL_STR(zc_id),
//        @"store_from":@"专场",
//    };
//    [JHAllStatistics jh_allStatisticsWithEventId:@"zcEnter" params:dic type:JHStatisticsTypeSensors];
//}

/// 商城首页 - TabBar item 点击
+ (void)jhNewStoreHomeTabBarItemClickReport:(NSString *)tab_attribute {
    NSDictionary *dic = @{
        @"tab_name":@"天天商城",
        @"tab_attribute":NONNULL_STR(tab_attribute)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"tabClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 天天商城浏览
+ (void)jhNewStoreHomeShowReport {
    NSDictionary *dic = @{
        @"page_name":@"天天商城首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"storeHomePageView" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 收藏点击
+ (void)jhNewStoreHomeCollectionBtnClick:(NSString *)zc_name
                                   zc_id:(NSString *)zc_id
                              store_from:(NSString *)store_from {
    NSDictionary *dic = @{
        @"zc_name":NONNULL_STR(zc_name),
        @"zc_id":NONNULL_STR(zc_id),
        @"store_from":NONNULL_STR(store_from)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 推荐商品列表
+ (void)jhNewStoreHomeGoodsShowListReportWithTag_name:(NSString *)tag_name
                                           goodsIdArr:(NSArray *)goodsIdArr {
    NSString *ids = @"";
    if (goodsIdArr.count >0) {
        ids = [goodsIdArr componentsJoinedByString:@","];
    }
    NSDictionary *dic = @{
        @"tag_name":NONNULL_STR(tag_name),
        @"item_ids":NONNULL_STR(ids)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"tjTagView" params:dic type:JHStatisticsTypeSensors];
}

/// 商城首页 - 推荐商品点击
+ (void)jhNewStoreHomeGoodsShowListClick:(NSString *)goodId
                         commodity_label:(NSString *)commodity_label
                          commodity_name:(NSString *)commodity_name
                         andCurrentTitle:(NSString *)curTitle{
    NSDictionary *dic = @{
        @"sort_name":@"",
        @"sort_id":@"",
        @"sort_rank":@"",
        @"store_from":@"商品推荐列表",
        @"item_id":NONNULL_STR(goodId),
        @"tag_name":NONNULL_STR(commodity_name)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"goodsListClick" params:dic type:JHStatisticsTypeSensors];
    
    NSDictionary *dic2 = @{
        @"page_position":@"天天商城",
        @"model_type":@"精选商品推荐位",
        @"commodity_label":NONNULL_STR(commodity_label),
        @"commodity_id":NONNULL_STR(goodId),
        @"commodity_name":NONNULL_STR(commodity_name),
        @"tab_name":NONNULL_STR(curTitle)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:dic2 type:JHStatisticsTypeSensors];
}

+ (NSString *)getZC_type:(NSInteger)zc_type {
    if (zc_type == 1) {
        return @"预告";
    } else if (zc_type == 2) {
        return @"热卖";
    } else if (zc_type == 3) {
        return @"已结束";
    }
    return @"";
}

@end

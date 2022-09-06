//
//  JHMarketHomeDataReport.m
//  TTjianbao
//
//  Created by zk on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketHomeDataReport.h"

@implementation JHMarketHomeDataReport

/**
 首页集市-页面埋点
 */
+ (void)marketHomePageReport{
    NSDictionary *dic = @{
        @"page_name":@"宝友集市首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
}

/**
 首页社区-页面埋点
 */
+ (void)marketCommunityPageReport{
    NSDictionary *dic = @{
        @"page_name":@"宝友社区首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
}

/**
 首页集市-金刚位点击
 */
+ (void)kingKongTouchReport:(NSString *)kingKongName{
    NSDictionary *dic = @{
        @"page_position":@"宝友集市首页",
        @"jgw_name":kingKongName
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"jgwClick" params:dic type:JHStatisticsTypeSensors];
}

/**
 首页集市-点击搜索按钮
 */
+ (void)searchTouchReport{
    NSDictionary *dic = @{
        @"page_position":@"宝友集市首页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"searchButtonClick" params:dic type:JHStatisticsTypeSensors];
}

/**
 首页集市-点击活动宫格专题资源位
 */
+ (void)specialTouchReport:(NSString *)url type:(NSString *)type{
    NSDictionary *dic = @{
        @"page_position":@"宝友集市首页",
        @"content_url":url,
        @"spm_type":type
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dic type:JHStatisticsTypeSensors];
}

/**
 首页集市-点击商品
 */
+ (void)goodsTouchReport:(NSString *)goodsId goodsTag:(NSString *)goodsTag goodsPrice:(NSString *)goodsPrice type:(NSString *)type{
    NSDictionary *dic = @{
        @"commodity_id":goodsId,
        @"commodity_label":goodsTag,
        @"original_price":goodsPrice,
        @"model_type":type,
        @"page_position":@"宝友集市首页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:dic type:JHStatisticsTypeSensors];
}

@end

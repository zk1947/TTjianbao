//
//  JHNewStoreSpecialBussinew.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSpecialBussinew.h"
@implementation JHNewStoreSpecialBussinew
/// 获取专场详情信息
///
+ (void)getStoreSpecialInfoWithSpecialId : (NSString *)showId
                            successBlock:(succeedBlock) success
                            failureBlock:(failureBlock)failure {
    long showid = [showId longValue];
    NSDictionary *par = @{@"showId" : @(showid)};
    NSString *url = FILE_BASE_STRING(@"/api/mall/show/detailInfo");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil ) { return; }
        failure(respondObject);
    }];
}

///api/mall/show/detailProducts
///获取专场商品列表
+ (void)requestSpecialProductListWithParams:(NSDictionary *)params
                               successBlock:(succeedBlock) success
                               failureBlock:(failureBlock)failure{
    NSString *url = FILE_BASE_STRING(@"/api/mall/show/detailProducts");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil ) { return; }
        failure(respondObject);
    }];
}

///获取pv用户数据
///api/mall/show/getUserList
+ (void)requestSpecialUserList:(NSString *)showId
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure{
    NSString *url = FILE_BASE_STRING(@"/api/mall/show/getUserList");
    long showid = [showId longValue];
    NSDictionary *params = @{@"showId" : @(showid)};
   
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil ) { return; }
        failure(respondObject);
    }];
}

//开售提醒
+(void)requestSalesReminderWithParams:(NSDictionary *)params
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure{
   NSString *url = FILE_BASE_STRING(@"/api/mall/show/salesReminder");
   [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
       success(respondObject);
   } failureBlock:^(RequestModel * _Nullable respondObject) {
       if (failure == nil ) { return; }
       failure(respondObject);
   }];
}

//专场曝光埋点
+ (void)sa_enterSpecialDetailWithName:(NSString *)zc_name
                              zc_type:(NSString *)zc_type
                                zc_id:(NSString *)zc_id
                           store_from:(NSString *)store_from
                              zc_time:(NSString *)zc_time
                            show_type:(NSString *)show_type {
    NSDictionary *dic = @{
        @"zc_name":NONNULL_STR(zc_name),
        @"zc_type":NONNULL_STR(zc_type),
        @"zc_id":NONNULL_STR(zc_id),
        @"store_from":NONNULL_STR(store_from),
        @"zc_time":NONNULL_STR(zc_time),
        @"show_type":NONNULL_STR(show_type)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"zcEnter" params:dic type:JHStatisticsTypeSensors];
}
@end

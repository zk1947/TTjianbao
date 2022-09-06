//
//  JHAllStatistics.m
//  TTjianbao
//
//  Created by wangjianios on 2021/1/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAllStatistics.h"
#import "JHBuryPointOperator.h"
@implementation JHAllStatistics
+ (void)setProfile : (NSDictionary *)params {
    [JHTracking setProfile:params];
}
///
+ (void)jh_allStatisticsWithEventId:(NSString *)eventId params:(NSDictionary *)params type:(JHStatisticsType)type {

    if(type & JHStatisticsTypeGrowing) {
        [JHGrowingIO trackEventId:eventId variables:params];
    }
    if(type & JHStatisticsTypeBI) {
        [JHBuryPointOperator buryWithEventId:eventId param:params];
    }
    if(type & JHStatisticsTypeSensors) {
        [JHTracking trackEvent:eventId property:params];
    }
    
    
}

+ (void)jh_allStatisticsWithEventId:(NSString *)eventId type:(JHStatisticsType)type {
    
    if(type & JHStatisticsTypeGrowing) {
        [JHGrowingIO trackEventId:eventId];
    }
    if(type & JHStatisticsTypeBI) {
        [JHBuryPointOperator buryWithEventId:eventId param:@{}];
    }
    if(type & JHStatisticsTypeSensors) {
        [JHTracking trackEvent:eventId property:@{}];
    }
}


@end

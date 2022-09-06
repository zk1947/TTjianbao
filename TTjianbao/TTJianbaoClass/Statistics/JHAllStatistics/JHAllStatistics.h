//
//  JHAllStatistics.h
//  TTjianbao
//  集合埋点（一次埋多个渠道）
//  Created by wangjianios on 2021/1/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGrowingIO.h"
#import "JHLogCollectConfig.h"

typedef NS_ENUM(NSInteger, JHStatisticsType)
{
    /// 无
    JHStatisticsTypeNone = 0,
    
    /// Growing
    JHStatisticsTypeGrowing = 1 << 0,
    
    /// BI
    JHStatisticsTypeBI = 1 << 1,
    
    /// 神测
    JHStatisticsTypeSensors = 1 << 2,
    
    /// 用户画像
    JHStatisticsTypeUserProfile = 1 << 3,
};


NS_ASSUME_NONNULL_BEGIN

/// 集合埋点（一次埋多个渠道）
@interface JHAllStatistics : NSObject
+ (void)jh_allStatisticsWithEventId:(NSString *)eventId params:(NSDictionary *)params type:(JHStatisticsType)type;

+ (void)jh_allStatisticsWithEventId:(NSString *)eventId  type:(JHStatisticsType)type;
+ (void)setProfile : (NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END

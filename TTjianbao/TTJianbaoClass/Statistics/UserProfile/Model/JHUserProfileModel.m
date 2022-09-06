//
//  JHUserProfileModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserProfileModel.h"
#import "JHPersistData.h"
#import "CommHelp.h"

#define kUserProfileStatisticsArrayPath @"JHUserProfileStatisticsArrayPath"

@implementation JHUserProfileModel

@end

@implementation JHUserProfileReportModel

- (instancetype)initWithEvent:(NSString *)eventType bodyDict:(NSDictionary*)paramDict
{
    if(self = [super init])
    {
        self.event_type = eventType;
        self.params = [NSDictionary dictionaryWithDictionary:paramDict];
        //当前时间戳
        self.client_time = [CommHelp getNowTimetampBySyncServeTime];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if(self = [super init])
    {
        _event_type = [coder decodeObjectForKey:@"userProfile_event_type"];
        _client_time = [coder decodeObjectForKey:@"userProfile_client_time"];
        _params = [coder decodeObjectForKey:@"userProfile_params"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_event_type forKey:@"userProfile_event_type"];
    [coder encodeObject:_client_time forKey:@"userProfile_client_time"];
    [coder encodeObject:_params forKey:@"userProfile_params"];
}

+ (void)saveNoteTimingEvent:(JHUserProfileReportModel*)model
{
    //1用新数据,创建新的数组
    NSMutableArray* allArray = [NSMutableArray arrayWithObject:model];
    //2获取已经存在数据
    NSArray* arr = [self getNoteTimingEvent];
    //3拼接老数据,新老数据合并
    if([arr count] > 0)
        [allArray addObjectsFromArray:arr];
        
    [JHPersistData savePersistData:allArray savePath:kUserProfileStatisticsArrayPath];
}

+ (NSArray*)getNoteTimingEvent
{
    NSArray* arr = [JHPersistData persistDataByPath:kUserProfileStatisticsArrayPath];
    return arr;
}

+ (void)clearNoteTimingEvent
{
    [JHPersistData deletePersistDataPath:kUserProfileStatisticsArrayPath];
}

@end

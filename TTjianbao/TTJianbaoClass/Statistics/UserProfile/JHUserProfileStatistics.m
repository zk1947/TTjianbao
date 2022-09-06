//
//  JHUserProfileStatistics.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserProfileStatistics.h"
#import "JHUserProfileStatisticsModel.h"

#define kUserProfileStatisticsRepeatCount 3 //非实时上报重试次数

@interface JHUserProfileStatistics ()

@property (nonatomic, assign) NSInteger timingReportRepeatCount;
@property (nonatomic, strong) NSDictionary* notingBrowseDurationEventParamDict;
@property (nonatomic, copy) NSString* notingBrowseDurationEventType;
@end

@implementation JHUserProfileStatistics

singleton_m(JHUserProfileStatistics)

+ (instancetype)sharedNull
{
    return nil;
}

//MARK: - 实时上报
- (void)noteEventType:(NSString*)eventType params:(NSDictionary*)paramDict
{
    [self noteEventType:eventType params:paramDict resumeBrowse:NO];
}

/**实时上报,浏览时长可能中断,需要恢复设置参数
 *是否需要恢复浏览时长？？
 *1浏览以外的埋点不需要2普通的浏览事件不需要(仅Root层几个需要)
 */
- (void)noteEventType:(NSString*)eventType params:(NSDictionary*)paramDict resumeBrowse:(BOOL)isResume
{
    if([self invalidEventType:eventType params:paramDict])
        return;
    
    //上报埋点
    NSLog(@">UserProfile3埋点>>&>936>note event type: %@ >>> param dict:%@", eventType, paramDict);
    JHUserProfileStatisticsModel* model = [JHUserProfileStatisticsModel new];
    [model setEventType:eventType bodyDict:paramDict]; //拼接公参
    [JH_REQUEST asynPost:model subQueueSuccess:^(id respData) {
        NSLog(@">>&>936>note event success !!");
    } subQueueFailure:^(NSString *errorMsg) {
        NSLog(@">>&>936>note event fail !!");
    }];
    
    //记录浏览时长事件,以便中断时恢复事件
    if(isResume)
    {
        [self checkBrowseDurationEventType:eventType params:paramDict];
    }
}

#pragma mark - 定时(非实时)记录(未实时上报)
- (void)noteTimingEventType:(NSString*)eventType params:(NSDictionary*)paramDict
{
    if([self invalidEventType:eventType params:paramDict])
        return;
    NSLog(@">UserProfile3埋点>>&>936>noteTiming event type: %@ >>> param dict:%@", eventType, paramDict);
    JHUserProfileReportModel* model = [[JHUserProfileReportModel alloc] initWithEvent:eventType bodyDict:paramDict];
    //保存非实时埋点事件
    [JHUserProfileReportModel saveNoteTimingEvent:model];
}

#pragma mark - 上报定时(非实时)埋点数据
- (void)reportNoteDataTiming
{
    self.timingReportRepeatCount = kUserProfileStatisticsRepeatCount;
    [self repeatReportNoteDataTiming]; //可以重试N次
}
//上报失败后,需要重试
- (void)repeatReportNoteDataTiming
{
    if(self.timingReportRepeatCount <= 0)
        return;
    self.timingReportRepeatCount--;
    
    NSLog(@">UserProfile3埋点>>&>936>repeatReportNoteDataTiming times=%zd", self.timingReportRepeatCount);
    
    JHUserProfileStatisticsModel* model = [JHUserProfileStatisticsModel new];
    [model setEventArray:[JHUserProfileReportModel getNoteTimingEvent]]; //拼接公参
    
    [JH_REQUEST asynPost:model subQueueSuccess:^(id respData) {
        NSLog(@">>&>936>note event success !!");
        [self clearData];
    } subQueueFailure:^(NSString *errorMsg) {
        NSLog(@">>&>936>note event fail !!");
        [self repeatReportNoteDataTiming]; //失败后重试
    }];
}

- (void)clearData
{
    self.timingReportRepeatCount = 0;
    [JHUserProfileReportModel clearNoteTimingEvent];
}

#pragma mark - 辅助common methods

/**挂起当前浏览时长事件
* 主要应用于:「退后台」需要停止浏览记录(中断事件)
*/
- (void)suspendBrowseDurationEvent
{
    //如果存在之前中断浏览事件,则需要挂起
    if(self.notingBrowseDurationEventType)
    {
        //暂存需要挂起的事件:type和dict
        NSString* suspendEventType = self.notingBrowseDurationEventType;
        NSDictionary* suspendParamDict = self.notingBrowseDurationEventParamDict;
        
        //重新更新参数:主要是浏览结束字段
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        if(self.notingBrowseDurationEventParamDict)
            [dic setDictionary:self.notingBrowseDurationEventParamDict];
        [dic setObject:JHUPBrowseEnd forKey:JHUPBrowseKey];
        //记录中断浏览
        [self noteEventType:self.notingBrowseDurationEventType params:dic resumeBrowse:YES];
        //需要重新记录,因为noteEventType里面遇到JHUPBrowseEnd会清空记录
        [self setBrowseDurationEventType:suspendEventType params:suspendParamDict];
    }
}

/**恢复当前浏览时长事件
* 主要应用于:中断事件「退后台」需要停止浏览记录,「进前台」恢复之前浏览记录
*/
- (void)resumeBrowseDurationEvent
{
    //如果存在之前中断浏览事件,则需要恢复
    if(self.notingBrowseDurationEventType)
    {
        [self noteEventType:self.notingBrowseDurationEventType params:self.notingBrowseDurationEventParamDict resumeBrowse:YES];
    }
}

/**检查当前「浏览时长事件」参数
 * 对于浏览时长，客户端上报需要分两步，上报开始时间和结束时间
 * 1开始时,set 2结束时,clear
 * {"type":"0"}
 * type=0代表进入时间 type=1代表离开时间
 */
- (void)checkBrowseDurationEventType:(NSString*)eventType params:(NSDictionary*)paramDict
{
    if(paramDict)
    {
        NSString* type = paramDict[JHUPBrowseKey];
        if([type isEqualToString:JHUPBrowseBegin])
        {//开始时,记录参数
            [self setBrowseDurationEventType:eventType params:paramDict];
        }
        else
        {//结束时,清理参数
            [self clearBrowseDurationEvent];
        }
    }
}
/**记录当前浏览时长事件参数:开始时
 * 主要应用于:中断事件「退后台」需要停止记录
 */
- (void)setBrowseDurationEventType:(NSString*)eventType params:(NSDictionary*)paramDict
{
    self.notingBrowseDurationEventType = eventType;
    self.notingBrowseDurationEventParamDict = paramDict;
}
/**
 *清理浏览时长事件参数:结束时
 */
- (void)clearBrowseDurationEvent
{
    [self setBrowseDurationEventType:nil params:nil];
}

- (BOOL)invalidEventType:(NSString*)eventType params:(NSDictionary*)paramDict
{
    //1事件有值2参数为空或者参数类型为字典
    if(eventType && (!paramDict || [paramDict isKindOfClass:[NSDictionary class]]))
        return NO;
    return YES;
}

///很无奈的做法:用来判断是否已经存在顶级浏览事件
- (BOOL)hasResumeBrowseEvent
{
    if(self.notingBrowseDurationEventType)
        return YES;
    return NO;
}

@end

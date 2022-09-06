//
//  JHUserProfileStatistics.h
//  TTjianbao
//  Description:用户画像（第三套>统计）
//  Created by Jesse on 2020/8/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUserProfileEventType.h"

//用户画像开关
#define USER_STATISTICS_OPEN

#ifdef USER_STATISTICS_OPEN
    #define JHUserStatistics  kSingleInstance(JHUserProfileStatistics)
#else
    #define JHUserStatistics [JHUserProfileStatistics sharedNull]
#endif

@interface JHUserProfileStatistics : NSObject

singleton_h(JHUserProfileStatistics)

/**
 *空对象,主要用于开关
 */
+ (instancetype)sharedNull;

/** 实时上报
 * 用户画像统计对外接口
 * eventType:事件类型 or 事件Id
 * paramDict:事件所需要的参数,动态可变
 */
- (void)noteEventType:(NSString*)eventType params:(NSDictionary*)paramDict;

/**实时上报,浏览时长可能中断,需要恢复设置参数
 *是否需要恢复浏览时长？？
 *1浏览以外的埋点不需要2普通的浏览事件不需要(仅Root层几个需要)
 */
- (void)noteEventType:(NSString*)eventType params:(NSDictionary*)paramDict resumeBrowse:(BOOL)isResume;

/**定时(非实时)记录(未实时上报)
 * 数据存储在本地
 * 在恰当时机读取文件信息上报
 */
- (void)noteTimingEventType:(NSString*)eventType params:(NSDictionary*)paramDict;

/**上报定时(非实时)埋点数据
 * 1在本地读取数据
 * 2上报失败需要尝试N次
 */
- (void)reportNoteDataTiming;

///MARK:辅助记录解决方案

/**恢复当前浏览时长事件
* 主要应用于:中断事件「退后台」需要停止浏览记录,「进前台」恢复之前浏览记录
*/
- (void)resumeBrowseDurationEvent;

/**挂起当前浏览时长事件
* 主要应用于:「退后台」需要停止浏览记录(中断事件)
*/
- (void)suspendBrowseDurationEvent;

/**很无奈的做法:初始化与tab切换时事件冲突
 *  用来判断是否已经存在顶级浏览事件
 */
-  (BOOL)hasResumeBrowseEvent;

@end


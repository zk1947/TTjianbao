//
//  JHCalendarEvent.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/9/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCalendarEventModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SuccessHandler) (BOOL success);
@interface JHCalendarEvent : NSObject
+ (instancetype)shared;

/// 添加日历提醒事件
+ (void)addEventWithModels : (NSArray<JHCalendarEventModel*> *)models successHandler : (SuccessHandler)successHandler;
/// 添加日历提醒事件
/// startTime : 开始时间戳（秒）
/// endTime : 结束时间戳(秒)
+ (void)addEventTitle : (NSString *)title
            startTime : (NSInteger)startTime
              endTime : (NSInteger)endTime
           alarmArray : (NSArray<NSString *> *)alarmArray;

/// 添加日历提醒事件
/// title : 事件标题
/// location : 事件位置
/// startDate : 开始时间
/// endDate : 结束时间
/// allDay : 是否全天
/// alarmArray 闹钟集合 - 开始前多久开始提醒。
/// successText : 添加成功提示文本
- (void)addEventTitle : (NSString *)title
             location : (NSString *)location
            startDate : (NSDate *)startDate
              endDate : (NSDate *)endDate
               allDay : (BOOL)allDay
           alarmArray : (NSArray<NSString *> *)alarmArray
          successText : (NSString *)tex;
@end

NS_ASSUME_NONNULL_END

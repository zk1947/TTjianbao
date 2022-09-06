//
//  JHCalendarEventModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/9/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCalendarEventModel : NSObject
/// 事件标题
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL allDay;
@property (nonatomic, copy) NSString *location;
/// 开始时间戳
@property (nonatomic, assign) NSInteger startTime;
/// 结束时间戳
@property (nonatomic, assign) NSInteger endTime;
/// 添加成功后的toast 提示文案
@property (nonatomic, copy) NSString *successText;
/// 事件提前多久提醒用户，可多次提醒
@property (nonatomic, strong) NSArray<NSString *> *alarmArray;

@end

NS_ASSUME_NONNULL_END

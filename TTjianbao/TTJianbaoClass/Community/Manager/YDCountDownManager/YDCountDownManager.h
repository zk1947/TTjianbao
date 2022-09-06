//
//  YDCountDownManager.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  倒计时管理
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kCountDownManager [YDCountDownManager sharedManager]

extern NSString *const YDCountDownNotification; ///倒计时通知

#pragma mark -
#pragma mark - YDCountDownTimerSource
@interface YDCountDownTimerSource : NSObject
@end


#pragma mark -
#pragma mark - YDCountDownManager

@interface YDCountDownManager : NSObject

/*! 每秒自增的时间间隔，用于计算倒计时 */
@property (nonatomic, assign) NSInteger runLoopTimeInterval;

+ (instancetype)sharedManager;

- (BOOL)isRunning; /*! 是否已经启动 */
- (void)startTimer; /*! 启动倒计时管理器 */
- (void)endTimer; /*! 停止倒计时 */

#pragma mark - 以下是 timer source 相关方法

/*! 获取某个timer source的间隔时间 */
- (NSInteger)timeIntervalWithId:(NSString *)identifier;

/*! 添加倒计时timer source，用于管理多页面倒计时情况（标识符可以是当前页数） */
- (void)addTimerSourceWithId:(NSString *)identifier;

/*! 重置runLoopTimeInterval */
- (void)resetRunLoopTimeInterval;

/*! 重置所有timer source */
- (void)resetAllTimerSource;

/*! 重置某个标识符对应的timer source */
- (void)resetTimerSourceWithId:(NSString *)identifier;

/*! 移除所有timer source */
- (void)removeAllTimerSources;

/*! 删除某个标识符对应的timer source */
- (void)removeTimerSourceWithId:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END

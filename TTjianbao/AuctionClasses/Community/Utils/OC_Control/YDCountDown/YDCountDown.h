//
//  YDCountDown.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//  倒计时工具 fork @郑文明 https://github.com/zhengwenming/CountDown
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YDCountDown : NSObject

///用NSDate日期倒计时
- (void)startWithBeginDate:(NSDate *)beginDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock;

///用时间戳倒计时
- (void)startWithbeginTimeStamp:(long long)beginTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock;

///用时间间隔倒计时
- (void)startWithFinishTimeStamp:(long)finishTimeStamp completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock;

///每秒走一次，回调block
- (void)countDownWithPER_SECBlock:(void(^)(void))PER_SECBlock;

- (void)destoryTimer;

- (NSDate *)dateWithLongLong:(long long)longlongValue;


@end

NS_ASSUME_NONNULL_END

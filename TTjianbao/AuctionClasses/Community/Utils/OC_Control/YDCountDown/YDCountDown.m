//
//  YDCountDown.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDCountDown.h"

@interface YDCountDown ()
@property(nonatomic, strong) dispatch_source_t timer;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation YDCountDown

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
        [self.dateFormatter setTimeZone:localTimeZone];
    }
    return self;
}

- (void)startWithBeginDate:(NSDate *)beginDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock {
    if (_timer == nil) {
        NSTimeInterval timeInterval = [finishDate timeIntervalSinceDate:beginDate];
        __block int timeout = timeInterval; //倒计时时间
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                } else {
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

- (void)countDownWithPER_SECBlock:(void (^)(void))PER_SECBlock {
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                PER_SECBlock();
            });
        });
        dispatch_resume(_timer);
    }
}

- (NSDate *)dateWithLongLong:(long long)longlongValue {
    long long value = longlongValue;
    NSNumber *time = [NSNumber numberWithLongLong:value];
    //转换成NSTimeInterval,用longLongValue，防止溢出
    NSTimeInterval nsTimeInterval = [time longLongValue];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    return date;
}

//时间戳转日期
- (NSDate *)getDateFromTimestamp:(long long)timestamp {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return confromTimesp;
}

- (void)startWithbeginTimeStamp:(long long)beginTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock {
    if (_timer == nil) {
        NSDate *finishDate = [self getDateFromTimestamp:finishTimeStamp];
        NSDate *beginDate  = [self getDateFromTimestamp:beginTimeStamp];
        
        NSTimeInterval timeInterval = [finishDate timeIntervalSinceDate:beginDate];
        __block int timeout = timeInterval; //倒计时时间
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                } else {
#if 1
                    int days = (int)(timeout/(3600*24));
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
#endif
//                    int hours = (int)(timeout/3600);
//                    int minute = (int)(timeout/60%60);
//                    int second = (int)(timeout%60);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
    }
}

///根据当前时间差倒计时
- (void)startWithFinishTimeStamp:(long)finishTimeStamp completeBlock:(void (^)(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second))completeBlock {
//    if (_timer == nil) {
        __block long timeout = finishTimeStamp; //倒计时时间
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(self->_timer);
                    self->_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(0,0,0,0);
                    });
                } else {
                    
                    int days = (int)(timeout/3600/24);
                    int hours = (int)(timeout/3600%24);
                    int minute = (int)(timeout/60%60);
                    int second = (int)(timeout%60);
                                        
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(days,hours,minute,second);
                    });
                    timeout--;
                }
            });
            dispatch_resume(_timer);
        }
//    }
}



/**
 *  获取当天的年月日的字符串
 *  @return 格式为年-月-日
 */
- (NSString *)getNowyyyymmdd {
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formatDay stringFromDate:now];
    return dayStr;
}

/**
 *  主动销毁定时器
 */
- (void)destoryTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)dealloc {
    NSLog(@"%s dealloc",object_getClassName(self));
}

@end

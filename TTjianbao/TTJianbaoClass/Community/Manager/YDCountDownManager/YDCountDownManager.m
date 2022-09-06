//
//  YDCountDownManager.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "YDCountDownManager.h"


#pragma mark -
#pragma mark - YDCountDownTimerSource

@interface YDCountDownTimerSource ()
@property (nonatomic, assign) NSInteger timeInterval;
+ (instancetype)timerSource;
@end

@implementation YDCountDownTimerSource
+ (instancetype)timerSource {
    YDCountDownTimerSource *object = [YDCountDownTimerSource new];
    object.timeInterval = 0;
    return object;
}
@end


#pragma mark -
#pragma mark - YDCountDownManager

@interface YDCountDownManager ()
@property (nonatomic, strong) NSTimer *timer;
/// 记录每个timerSource的时间间隔
@property (nonatomic, strong) NSMutableDictionary<NSString *, YDCountDownTimerSource *> *timerSources;
/// 前后台切换时, 记录进入后台的绝对时间
@property (nonatomic, assign) BOOL didEnterBackground; //进入后台标记
@property (nonatomic, assign) CFAbsoluteTime lastTime;
@end


@implementation YDCountDownManager

NSString *const YDCountDownNotification = @"YDCountDownNotification";

+ (instancetype)sharedManager {
    static YDCountDownManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[YDCountDownManager alloc] init];
    });
    return _manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _timerSources = [NSMutableDictionary dictionary];
        [self __addAppCycleObserver];
    }
    return self;
}


#pragma mark -
#pragma mark - 进入前后台Observer
- (void)__addAppCycleObserver {
    @weakify(self);
    //进入前台
    //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        if (self.didEnterBackground) {
            CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
            [self __timerIntervalChanged:(NSInteger)timeInterval];
            [self startTimer];
        }
    }];
    
    //进入后台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        self.didEnterBackground = (_timer != nil);
        self.lastTime = CFAbsoluteTimeGetCurrent();
        [self endTimer];
    }];
}


#pragma mark -
#pragma mark - CountDown Methods

- (BOOL)isRunning {
    return _timer != nil;
}

- (void)startTimer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(__handleTimerEvent) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)endTimer {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark -
#pragma mark - Timer事件
- (void)__handleTimerEvent {
    //定时器每秒加1
    [self __timerIntervalChanged:1];
}

- (void)__timerIntervalChanged:(NSInteger)timeInterval {
    _runLoopTimeInterval += timeInterval; //时间间隔+1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        [_timerSources enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YDCountDownTimerSource * _Nonnull obj, BOOL * _Nonnull stop) {
            obj.timeInterval += timeInterval;
        }];
        // 发出通知
        dispatch_async(dispatch_get_main_queue(), ^{
            [JHNotificationCenter postNotificationName:YDCountDownNotification object:nil userInfo:nil];
        });
    });
}


#pragma mark -
#pragma mark - timer source 相关方法

///获取某个timer source的间隔时间
- (NSInteger)timeIntervalWithId:(NSString *)identifier {
    return _timerSources[identifier].timeInterval;
}

///添加倒计时timer source，用于管理多页面倒计时情况（标识符可以是当前页数）
- (void)addTimerSourceWithId:(NSString *)identifier {
    YDCountDownTimerSource *source = _timerSources[identifier];
    if (source) {
        source.timeInterval = 0;
    } else {
        [_timerSources setObject:[YDCountDownTimerSource timerSource] forKey:identifier];
    }
}

///重置runLoopTimeInterval
- (void)resetRunLoopTimeInterval {
    _runLoopTimeInterval = 0;
}

///重置所有timer source
- (void)resetAllTimerSource {
    [_timerSources enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, YDCountDownTimerSource * _Nonnull obj, BOOL * _Nonnull stop) {
        obj.timeInterval = 0;
    }];
}

///重置某个标识符对应的timer source
- (void)resetTimerSourceWithId:(NSString *)identifier {
    _timerSources[identifier].timeInterval = 0;
}

///移除所有timer source
- (void)removeAllTimerSources {
    [_timerSources removeAllObjects];
}

///删除某个标识符对应的timer source
- (void)removeTimerSourceWithId:(NSString *)identifier {
    if (!identifier) {
        return;
    }
    [_timerSources removeObjectForKey:identifier];
}

@end

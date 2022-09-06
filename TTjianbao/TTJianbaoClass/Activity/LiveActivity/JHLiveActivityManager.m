//
//  JHLiveActivityManager.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/9/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLiveActivityManager.h"
#import "JSCoreObject.h"

@interface JHLiveActivityManager()
/// 倒计时时间
@property (nonatomic, assign) NSUInteger countdownTime;
@property (nonatomic, strong) RACDisposable * dispoable;
@property (nonatomic, assign) BOOL isStarted;
@end
@implementation JHLiveActivityManager
#pragma  mark - Public
+ (instancetype)sharedManager
{
    static JHLiveActivityManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHLiveActivityManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)startCountDown : (NSUInteger) countDown {
    if (countDown <= 0) return;
    JHLiveActivityManager *manager = [JHLiveActivityManager sharedManager];
    manager.countDown = countDown;
    manager.countdownTime = countDown;
    [manager startCountDown];
}
/// 开始倒计时
- (void)startCountDown {
    if (self.countdownTime <= 0) return;
    
    RACSignal *timerSignal = [RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]];
    self.isStarted = true;
    timerSignal = [timerSignal take:self.countdownTime];
    @weakify(self)
    self.dispoable = [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.countdownTime--;
    } completed:^{
        @strongify(self)
        self.isStarted = false;
        [self countdownCompleted];
    }];
    
}
- (void)restartCountDown {
    if (self.countDown <= 0) return;
    if (self.countdownTime <= 0) return;
    if (self.isStarted == true) return;
    [self startCountDown];
}
/// 暂停倒计时
- (void)pauseCountDown {
    
}
/// 停止倒计时
- (void)stopCountDown {
    if (self.dispoable == nil) return;
    if (self.isStarted == false) return;
    [self.dispoable dispose];
    self.isStarted = false;
    [self resetCountdown];
}
- (void)stopAndInitCountDown {
    [self stopCountDown];
    self.countDown = 0;
    self.countdownTime = 0;
}
#pragma  mark - Private
- (void)setupManager {
    
}
- (void)countdownCompleted {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameWebViewHandler object:nil];
    self.countDown = 0;
    self.countDownText = @"";
    [self signinFinishedRequest];
}
- (void)resetCountdown {
    // 重置倒计时时间
    self.countdownTime = self.countDown;
    self.countDownText = @"";
}
#pragma  mark - Request
// 签到结束请求
- (void)signinFinishedRequest {
//    NSDictionary *par = @{
//        @"anchorId" : @"",
//    };
    NSString *url = FILE_BASE_STRING(@"/activity/api/cdk/auth/continuous-view-complete");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
#pragma  mark - LAZY
- (void)setCountdownTime:(NSUInteger)countdownTime {
    _countdownTime = countdownTime;
    if (countdownTime <= 0) return;
    self.countDownText = [NSString stringWithFormat:@"继续观看 %lu 秒，完成签到", (unsigned long)_countdownTime];
}
@end

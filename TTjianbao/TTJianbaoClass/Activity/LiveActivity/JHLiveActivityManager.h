//
//  JHLiveActivityManager.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/9/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveActivityManager : NSObject
+ (instancetype)sharedManager;
/// 开始倒计时
+ (void)startCountDown : (NSUInteger) countDown;
/// 倒计时时间
@property (nonatomic, assign) NSUInteger countDown;
/// 倒计时文本
@property (nonatomic, strong) NSString *countDownText;
/// 开始倒计时
- (void)startCountDown;
/// 重新开始计时
- (void)restartCountDown;
/// 暂停倒计时
- (void)pauseCountDown;
/// 停止倒计时
- (void)stopCountDown;
- (void)stopAndInitCountDown;
@end

NS_ASSUME_NONNULL_END

//
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^HandlerBlock)(int presentTime);
typedef void(^TimerBlock)(void);

@interface BYTimer : NSObject

- (void)startGCDTimerOnMainQueueWithInterval:(float)interval Blcok:(TimerBlock)timerBlcok;
- (void)createTimerWithTimeout:(int)timeout handlerBlock:(HandlerBlock)handlerBlock finish:(TimerBlock)finish;
- (void)stopGCDTimer;

@end

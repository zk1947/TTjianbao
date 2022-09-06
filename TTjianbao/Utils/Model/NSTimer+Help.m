//
//  NSTimer+Help.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "NSTimer+Help.h"


@implementation NSTimer (Help)

+ (NSTimer *)jh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block

{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval
                                                   target:self
                                                 selector:@selector(jh_blockInvoke:)
                                                 userInfo:[block copy]
                                                  repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

+ (void)jh_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
}

-(void)jh_stop{
    [self setFireDate:[NSDate distantFuture]];
}

-(void)jh_star{
    [self setFireDate:[NSDate date]];
}


@end

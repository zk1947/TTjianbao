//
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "BYTimer.h"

@interface BYTimer ()
{
     dispatch_source_t timer;
     int _timeout;
}
@property (nonatomic, copy) HandlerBlock handlerBlock;

@property (nonatomic, copy) TimerBlock finish;
@end

@implementation BYTimer

- (void)startGCDTimerOnMainQueueWithInterval:(float)interval Blcok:(TimerBlock)timerBlcok {
    
    self.finish = timerBlcok;
    if (!interval) interval = 1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{

            if (self.finish) {
                self.finish();
            }

        });
    });
    
    // 开启定时器
    dispatch_resume(timer);
}
- (void)createTimerWithTimeout:(int)timeout handlerBlock:(HandlerBlock)handlerBlock finish:(TimerBlock)finish {
    
    _timeout = timeout;
    self.handlerBlock = handlerBlock;
    self.finish = finish;
    [self _startCountdown];
    
}

- (void)_startCountdown {
    
    int interval = 1;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        
        if (_timeout <= 0) {
            
            NSLog(@"倒计时结束");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_finish) {
                    _finish();
                }
            });
            
            dispatch_source_cancel(timer);
            
        } else {
            
            //NSLog(@"%d", _timeout);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (_handlerBlock) {
                    _handlerBlock(_timeout);
                }
                _timeout --;
            });
            
            
        }
        
    });
    
    // 开启定时器
    dispatch_resume(timer);
    
}

- (void)stopGCDTimer {
    
    if(timer)
    {
        dispatch_source_cancel(timer);
    }
    
}


@end

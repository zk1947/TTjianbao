//
//  NSTimer+Help.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Help)


+ (NSTimer *)jh_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                       repeats:(BOOL)repeats
                                         block:(void(^)(void))block;

-(void)jh_stop;

-(void)jh_star;

@end

NS_ASSUME_NONNULL_END

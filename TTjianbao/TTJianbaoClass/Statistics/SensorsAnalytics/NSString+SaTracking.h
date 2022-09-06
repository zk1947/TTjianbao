//
//  NSString+SaTracking.h
//  TTjianbao
//
//  Created by apple on 2020/12/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SaTracking)
//获取当前时间
+ (NSString *)getCurrentTime;
//获取时间差
+ (NSString *) getTimeWithBeginTime:(NSString *) beginTime endTime:(NSString *) endTime;
@end

NS_ASSUME_NONNULL_END

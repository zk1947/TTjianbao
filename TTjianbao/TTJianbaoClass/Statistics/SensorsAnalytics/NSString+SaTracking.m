//
//  NSString+SaTracking.m
//  TTjianbao
//
//  Created by apple on 2020/12/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NSString+SaTracking.h"

@implementation NSString (SaTracking)
//获取时间差
+ (NSString *) getTimeWithBeginTime:(NSString *) beginTime endTime:(NSString *) endTime{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    
    NSDate * date1 = [formatter dateFromString:beginTime];
    NSDate * date2 = [formatter dateFromString:endTime];
    
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1]; //date1是前一个时间(早)，date2是后一个时间(晚)
    
    return [NSString stringWithFormat:@"%.0f",time*1000];
}



//获取当前时间
+ (NSString *)getCurrentTime{
    
    return [self getTimeWithDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
}

/// 获取当前时间
/// @param dateFormat 时间格式  @"yyyy-MM-dd HH:mm:ss SSS"  @"yyyy-MM-dd"  @"yyyy-MM"  @"MM-dd" 等等
+ (NSString *)getTimeWithDateFormat:(NSString *)dateFormat {
    
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:dateFormat?:@"yyyy-MM-dd HH:mm:ss SSS"];
    NSString *curTime = [formatter stringFromDate:date];
    return curTime;
}
@end

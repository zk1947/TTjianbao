//
//  NSDate+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (YDAdd)

- (BOOL)isSameDay:(NSDate*)anotherDate;

- (NSInteger)secondsAgo;
- (NSInteger)minutesAgo;
- (NSInteger)hoursAgo;
- (NSInteger)monthsAgo;
- (NSInteger)yearsAgo;
- (NSInteger)leftDayCount;

- (NSString *)string_yyyy_MM_dd_EEE;//@"yyyy-MM-dd EEE" + (今天/昨天)
- (NSString *)string_yyyy_MM_dd;//@"yyyy-MM-dd"
- (NSString *)stringDisplay_HHmm;//n秒前 / 今天 HH:mm
- (NSString *)stringDisplay_MMdd;//n秒前 / 今天 / MM/dd
- (NSString *)stringDisplay_HH_MM_SS;//n秒前 / n分钟前 / n小时前

+ (NSString *)convertStr_yyyy_MM_ddToDisplay:(NSString *)str_yyyy_MM_dd;//(今天、明天) / MM月dd日 / yyyy年MM月dd日

- (NSString *)stringTimesAgo;//代码更新时间

- (NSUInteger)numDaysInMonth;
- (NSUInteger)firstWeekDayInMonth;

- (NSDate *)offsetYear:(NSInteger)numYears;
- (NSDate *)offsetMonth:(NSInteger)numMonths;
- (NSDate *)offsetDay:(NSInteger)numDays;
- (NSDate *)offsetHours:(NSInteger)hours;

+ (NSDate *)dateStartOfDay:(NSDate *)date;
+ (NSDate *)dateStartOfWeek;
+ (NSDate *)dateEndOfWeek;
/** 返回两个日期差 */
+ (NSInteger)numberOfDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

@end

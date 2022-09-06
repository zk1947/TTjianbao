//
//  YDHelper.h
//  YDCategoryKit
//
//  Created by WU on 14-12-22.
//  Copyright (c) 2014年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YDHelper : NSObject

// GB2312转换为UTF8格式
+ (NSData *)convertGB2312ToUTF8Data:(NSData *)gb2312Data;
// NSData转NSString
+ (NSString *)convertDataToString:(NSData *)aData;
// NSString转NSData
+ (NSData *)convertStringToData:(NSString *)aString;

// 时间NSDate转NSString
+ (NSString *)convertDateToString:(NSDate *)aDate withFormat:(NSString *)format;
// NSString转NSDate时间
+ (NSDate *)convertStringToDate:(NSString *)aString withFormat:(NSString *)format;
//两个日期之间差多少天
+ (NSInteger)getDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate;

// 获取当前日期时间戳(13位)
+ (NSString *)get13TimeStamp;
// 日期转时间戳(13位)
+ (NSString *)get13TimeStampFromDate:(NSDate *)aDate;
// 时间戳转日期(13位)
+ (NSDate *)getDateFrom13Timestamp:(NSString *)timestamp;
// 时间戳转时间(默认10位)
+ (NSString *)getStringFromTimestamp:(NSString *)timestamp withFormat:(NSString *)format;
// 时间戳转时间(13位)
+ (NSString *)getStringFrom13Timestamp:(NSString *)timestamp withFormat:(NSString *)format;

// 十六进制色值转rgb
+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

/**
 * 获取一个随机整数，范围在[from, to]，包括from，包括to
 * 1、获取一个随机整数范围在：[0,100)包括0，不包括100 (int x = arc4random() % 100;)
 * 2、获取一个随机数范围在：[500,1000]，包括500，包括1000 (int y = (arc4random() % 501) + 500;)
 */
+ (NSInteger)randomNumFrom:(NSInteger)from toNum:(NSInteger)to;

/** 返回26位大小写字母和数字 */
+ (NSString *)random26LetterAndNumber;


@end

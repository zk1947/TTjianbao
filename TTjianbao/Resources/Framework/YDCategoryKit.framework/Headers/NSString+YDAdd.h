//
//  NSString+YDAdd.h
//  YDCategoryKit
//
//  Created by WU on 16/4/15.
//  Copyright © 2016年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NSString (YDAdd)

+ (NSString *)userAgentStr;

- (NSString *)md5Str;
- (NSString *)sha1Str;

- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

+ (NSString *)sizeDisplayWithByte:(CGFloat)sizeOfByte;

- (NSRange)rangeByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSRange)rangeByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

- (NSString *)stringByTrimmingLeftCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingRightCharactersInSet:(NSCharacterSet *)characterSet;

#pragma mark -
#pragma mark - 数据类型转换
/*！转换拼音 */
- (NSString *)transformToPinyin;
/*！NSString转NSData */
- (NSData *)convertToData;

#pragma mark -
#pragma mark - 验证

//按照中文两个字符，英文数字一个字符计算字符数
- (NSUInteger)unicodeLengthOfString:(NSString *)text;

//去掉两端的空格
- (NSString *)trimString;
- (NSString *)trimWhitespace;
- (NSString *)trimAllSpace;

- (BOOL)isEmpty;
- (BOOL)isEmptyOrListening;

//判断字符串是否都为空格“ ”
- (BOOL)isAllSpaceText;
//手机号验证
- (BOOL)isPhoneNumber;
//Email验证
- (BOOL)isEmail;
//判断是否为整形
- (BOOL)isPureInt;
//判断是否为浮点形
- (BOOL)isPureFloat;
//银行卡
- (BOOL)checkCardNo;

//判断名称是否合法
- (BOOL)isNameValid;

//是否是表情
+ (BOOL)isStringContainsEmoji:(NSString *)string;

@end

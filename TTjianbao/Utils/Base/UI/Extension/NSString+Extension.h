//
//  NSString+Extension.h
//  Description:字符串扩展
//  Created by Jesse on 2020/01/01.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/**检测字符串的长度,区分中英文字符*/
- (NSInteger)getStringLenthOfBytes;

/**获取字符串给定长度的子字符串,包含中英文字符*/
- (NSString *)subBytesOfstringToIndex:(NSInteger)index;
@end

@interface NSString (Validate)
//检测金额
+ (BOOL)validateMoney:(NSString*)money;
//检测数字
+ (BOOL)validateNumbers:(NSString*)number;
//检测数字 包括0
+ (BOOL)validateZeroNumbers:(NSString*)number;
+ (BOOL)isNineKeyBoard:(NSString *)string;
+ (BOOL)validatePhoneNumbers:(NSString*)number;
+ (BOOL)inputCapitalAndLowercaseLetter:(NSString*)string;
+ (BOOL)inputCapitalAndLowercaseLetterChinese:(NSString*)string;
+ (BOOL)inputCapitalAndNumLowercaseLetterChinese:(NSString*)string;
//检测中文
+ (BOOL)validateChinese:(NSString*)string;
//检测中文或者中文符号
+ (BOOL)validateChineseChar:(NSString *)string;
//去掉HTML标签
+ (NSString *)removeHtmlWithString:(NSString *)htmlString;
+ (BOOL)onlyInputChineseCharacters:(NSString*)string;
//检测空字符串
+ (BOOL)isBlankString:(NSString *)string;
- (NSString *)returnBankCard;
- (NSString *)returnCiphertext:(NSInteger)n;

@end

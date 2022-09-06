//
//  NSString+Extension.m
//
//   Created by Jesse on 2020/01/01.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**检测字符串的长度,区分中英文字符*/
- (NSInteger)getStringLenthOfBytes
{
    NSInteger length = 0;
    for (int i = 0; i<[self length]; i++)
    {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([NSString validateChineseChar:s])
        {
            NSLog(@" s 打印信息:%@",s);
            length +=2;
        }
        else
        {
            length +=1;
        }
        
        NSLog(@" 打印信息:%@  %ld",s,(long)length);
    }
    return length;
}

/**获取字符串给定长度的子字符串,包含中英文字符*/
- (NSString *)subBytesOfstringToIndex:(NSInteger)index
{
    NSInteger length = 0;
    
    NSInteger chineseNum = 0;
    NSInteger zifuNum = 0;
    
    for (int i = 0; i<[self length]; i++) {
        //截取字符串中的每一个字符
        NSString *s = [self substringWithRange:NSMakeRange(i, 1)];
        if ([NSString validateChineseChar:s])
        {
            if (length + 2 > index)
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            
            length +=2;
            
            chineseNum +=1;
        }
        else
        {
            if (length +1 >index)
            {
                return [self substringToIndex:chineseNum + zifuNum];
            }
            length+=1;
            
            zifuNum +=1;
        }
    }
    return [self substringToIndex:index];
}

@end

@implementation NSString (Validate)

//检测金额
+ (BOOL)validateMoney:(NSString*)money
{
    BOOL flag = NO;
    if(money)
    {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,6}(([.]\\d{0,2})?)))?";
        NSPredicate *mMoney = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        flag = [mMoney evaluateWithObject:money];
    }
    return flag;
}

//检测数字
+ (BOOL)validateNumbers:(NSString*)number
{
    BOOL flag = NO;
    if(number)
    {
        NSString *stringRegex = @"^[0-9]*[1-9][0-9]*$";
        NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        flag = [num evaluateWithObject:number];
    }
    return flag;
}

//检测数字包括0
+ (BOOL)validateZeroNumbers:(NSString*)number
{
    BOOL flag = NO;
    if(number)
    {
        NSString *stringRegex = @"^[0-9]*$";
        NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        flag = [num evaluateWithObject:number];
    }
    return flag;
}

/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
+(BOOL)isNineKeyBoard:(NSString *)string {
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

//检测手机号
+ (BOOL)validatePhoneNumbers:(NSString*)number
{
    BOOL flag = NO;
    if(number)
    {
        NSString *stringRegex = @"^([1][3,4,5,6,7,8,9])\\d{9}$";
        NSPredicate *num = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        flag = [num evaluateWithObject:number];
    }
    return flag;
}

//检测是都是大小写
+ (BOOL)inputCapitalAndLowercaseLetter:(NSString*)string {
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//大小写 + 中文
+ (BOOL)inputCapitalAndLowercaseLetterChinese:(NSString*)string {
    NSString *regex =@"[\u4e00-\u9fa5a-zA-Z]{1,30}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//大小写 + 中文 + 数字
+ (BOOL)inputCapitalAndNumLowercaseLetterChinese:(NSString*)string {
    NSString *regex =@"[0-9\u4e00-\u9fa5a-zA-Z]{1,30}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}

//检测中文或者中文符号
+ (BOOL)validateChineseChar:(NSString *)string
{
    NSString *nameRegEx = @"[\\u0391-\\uFFE5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

//检测中文
+ (BOOL)validateChinese:(NSString*)string
{
    NSString *nameRegEx = @"[\u4e00-\u9fa5]";
    if (![string isMatchesRegularExp:nameRegEx]) {
        return NO;
    }
    return YES;
}

// 中文 不限制字数
+ (BOOL)onlyInputChineseCharacters:(NSString*)string {
    NSString *inputString =@"[\u4e00-\u9fa5]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",inputString];
    BOOL res = [predicate evaluateWithObject:string];
    return res;
}

- (BOOL)isMatchesRegularExp:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

+ (NSString *)removeHtmlWithString:(NSString *)htmlString {
    //正则去除标签
    NSRegularExpression * regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    htmlString = [regularExpretion stringByReplacingMatchesInString:htmlString options:NSMatchingReportProgress range:NSMakeRange(0, htmlString.length) withTemplate:@""];
    return htmlString;
}

+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqual:nil] || [string isEqual:Nil]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if (0 == [string length]){
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    if([string isEqualToString:@"(null)"]){
        return YES;
    }
    
    return NO;
}

- (NSString *)returnBankCard {
    NSString *bankNum = self;
    NSMutableString *mutableStr;
    if (bankNum.length > 4) {
        mutableStr = [NSMutableString stringWithString:bankNum];
        for (int i = 0 ; i < bankNum.length; i++) {
            if (i<bankNum.length - 4) {
                [mutableStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
            }
        }
        NSString *text = mutableStr;
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSString *newString = @"";
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        while (subString.length) {
            newString = [newString stringByAppendingString:subString];
            newString = [newString stringByAppendingString:@" "];
            text = [text substringFromIndex:MIN(text.length, 4)];
            subString = [text substringToIndex:MIN(text.length, 4)];
        }
//        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        return newString;
    }
    
    return self;
}

- (NSString *)returnCiphertext:(NSInteger)n {
    NSString *result = @"";
    for (int i=0; i<n; i++) {
        result = [result stringByAppendingFormat:@"*"];
    }
    return result;
}

@end


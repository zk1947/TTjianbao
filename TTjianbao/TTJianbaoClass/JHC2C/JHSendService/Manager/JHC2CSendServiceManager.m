//
//  JHC2CSendServiceManager.m
//  TTjianbao
//
//  Created by hao on 2021/6/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSendServiceManager.h"

@implementation JHC2CSendServiceManager
///过滤修剪字符串
+ (NSString *)trimmingCharactersInSetOfString:(NSString *)string{
    NSString *specialStr = @"\\ # & + \" % < > '";
    NSArray *currentArr = [specialStr componentsSeparatedByString:@" "];
    for (int i = 0; i < currentArr.count; ++i){
        string = [string stringByReplacingOccurrencesOfString:currentArr[i] withString:@""];
    }
    return string;
    
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"\\#&+\"%<>'"];
//    NSString *trimmedString = [string stringByTrimmingCharactersInSet:set];
//    return trimmedString;
}
@end

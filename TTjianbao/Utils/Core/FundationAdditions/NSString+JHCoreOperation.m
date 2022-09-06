//
//  NSString+JHCoreOperation.m
//  TTjianbao
//
//  Created by miao on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "NSString+JHCoreOperation.h"

@implementation NSString (JHCoreOperation)


+ (NSString *)safeGet_ttjb:(NSString *)str {
    
    return !str ? @"" : str;
}

@end

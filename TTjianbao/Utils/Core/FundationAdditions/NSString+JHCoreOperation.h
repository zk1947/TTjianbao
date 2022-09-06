//
//  NSString+JHCoreOperation.h
//  TTjianbao
//
//  Created by miao on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JHCoreOperation)

/// 安全获取str为nil返回空
/// @param str 目标字符串
+ (NSString *)safeGet_ttjb:(NSString *)str;

@end

NS_ASSUME_NONNULL_END

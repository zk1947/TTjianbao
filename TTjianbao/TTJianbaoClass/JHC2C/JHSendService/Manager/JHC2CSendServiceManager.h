//
//  JHC2CSendServiceManager.h
//  TTjianbao
//
//  Created by hao on 2021/6/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSendServiceManager : NSObject
/// 过滤修剪字符串
/// @param string 需要修剪的字符串
+ (NSString *)trimmingCharactersInSetOfString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END

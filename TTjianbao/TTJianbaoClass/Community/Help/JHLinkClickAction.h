//
//  JHLinkClickAction.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHLinkClickAction : NSObject

/// 点击网页链接跳转事件
/// @param linkType 跳转的type值
/// @param urlString 跳转的链接
+ (void)linkClickActionWithType:(NSInteger )linkType andUrl:(NSString *)urlString;

/// 跳转到个人详情页
/// @param userName 用户名
+ (void)linkClickActionWithUserName:(NSString *)userName;

@end

NS_ASSUME_NONNULL_END

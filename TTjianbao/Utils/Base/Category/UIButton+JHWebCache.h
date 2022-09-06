//
//  UIButton+JHWebCache.h
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///按钮添加网络图片

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (WebCache)

///按钮添加网络图片
- (void)jh_setButtonImageWithUrl:(NSString *)urlStr;

- (void)jh_setButtonImageWithUrl:(NSString *)urlStr controlState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END

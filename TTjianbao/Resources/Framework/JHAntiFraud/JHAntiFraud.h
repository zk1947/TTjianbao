//
//  JHAntiFraud.h
//  TTjianbao
//  Description:天天鉴宝~风控
//  Created by jesee on 25/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAntiFraud : NSObject

//注册风控配置
+ (void)registerExtHandler;
//从风控端获取设备id
+ (NSString*)deviceId;

@end

NS_ASSUME_NONNULL_END

//
//  JHBusinessModelTitleConfig.h
//  TTjianbao
//
//  Created by miao on 2021/7/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nullable const JHStraightHairConfigKey;   // 直发
extern NSString * _Nullable const JHDeliveryConfigKey;       // 过仓

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessModelTitleConfig : NSObject

/// 获得不同商品模式的配置文件（直发/过仓）
+ (NSDictionary *)businessModelTitleConfig;

@end

NS_ASSUME_NONNULL_END

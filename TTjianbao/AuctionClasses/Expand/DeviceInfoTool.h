//
//  DeviceInfoTool.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoTool : NSObject
/** 返回手机型号 */
+ (NSString *)deviceVersion;

/** 获取总磁盘容量 */
+ (long long)getTotalDiskSize;

/** 获取可用磁盘容量 */
+ (long long)getAvailableDiskSize;


/**
 获取app 版本号
 
 @return 版本号
 */
+ (NSString *)getAppVersion;

/**
 获取APP名字
 
 @return 名字
 */
+ (NSString *)getAppName;
@end

NS_ASSUME_NONNULL_END

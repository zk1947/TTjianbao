//
//  SFHelper.h
//  SensorsFocusHelper.h
//
//  Created by 曹犟 on 15/7/1.
//  Copyright © 2015-2020 Sensors Data Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SensorsFocusHelper : NSObject

/// 埋点“App 打开推送”事件
/// @param userInfo 包含与远程通知相关的信息的字典
+ (void)trackSensorsFocusAppOpenNotificationWithUserInfo:(NSDictionary *)userInfo;

/// 神策智能运营处理推送消息，做页面跳转
/// @param userInfo 包含与远程通知相关的信息的字典
/// @param aLink 打开 URL 的回调
/// @param aCustomized 处理自定义消息回调
+ (BOOL)dealSensorsFocusAction:(NSDictionary *)userInfo
                link:(void (^ __nullable)(NSString *urlString))aLink
           customize:(void (^ __nullable)(NSDictionary *customizedDic))aCustomized;

@end

NS_ASSUME_NONNULL_END

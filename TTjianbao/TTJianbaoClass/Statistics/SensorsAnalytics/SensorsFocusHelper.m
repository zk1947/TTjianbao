//  SensorsFocusHelper.m
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

#import "SensorsFocusHelper.h"
#if __has_include(<SensorsAnalyticsSDK.h>)
#import <SensorsAnalyticsSDK.h>
#else
#import "SensorsAnalyticsSDK.h"
#endif

@implementation SensorsFocusHelper

/// 神策智能运营处理推送消息，做页面跳转
/// @param userInfo 包含与远程通知相关的信息的字典
/// @param aLink 打开 URL 的回调
/// @param aCustomized 处理自定义消息回调
+ (BOOL)dealSensorsFocusAction:(NSDictionary *)userInfo link:(void (^)(NSString * _Nonnull))aLink customize:(void (^)(NSDictionary * _Nonnull))aCustomized {
    @try {
           // 解析 sf_data
           NSString *jsonString = userInfo[@"sf_data"];
           NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
           NSError *error;
           NSDictionary *sfDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
           if (!sfDictionary || error) {
               return NO;
           }

           NSString *sf_landing_type = sfDictionary[@"sf_landing_type"];
           if ([sf_landing_type isEqualToString:@"LINK"]) {
                // 打开 URL
               NSString *url = sfDictionary[@"sf_link_url"];
               if (aLink) {
                   aLink(url);
               }

           }
           else if ([sf_landing_type isEqualToString:@"CUSTOMIZED"]) {
               // 处理自定义消息
               // 如果你们已经有了根据附加字段跳转逻辑，此处无需处理。（因为神策智能运营发的推送消息会兼容极光控制台的 "附加字段"）
               NSDictionary *customized = sfDictionary[@"customized"];
               if (aCustomized) {
                   aCustomized(customized);
               }
           }
           return YES;
       } @catch (NSException *exception) {
       }
       return NO;
}

//// 埋点“App 打开推送”事件
/// @param userInfo 包含与远程通知相关的信息的字典
+ (void)trackSensorsFocusAppOpenNotificationWithUserInfo:(NSDictionary *)userInfo {
    NSMutableDictionary *pushProperties = [NSMutableDictionary dictionary]; // track 字典
    @try { // sf_data
        NSData *jsonData = [userInfo[@"sf_data"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *sfDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (!error && [sfDictionary isKindOfClass:NSDictionary.class]) {
            pushProperties[@"$sf_msg_id"] = sfDictionary[@"sf_msg_id"]; // SF 消息 id
            pushProperties[@"$sf_plan_id"] = sfDictionary[@"sf_plan_id"];
            pushProperties[@"$sf_audience_id"] = sfDictionary[@"sf_audience_id"];
            pushProperties[@"$sf_plan_strategy_id"] = sfDictionary[@"sf_plan_strategy_id"];
            pushProperties[@"$sf_plan_type"] = sfDictionary[@"sf_plan_type"];
            pushProperties[@"$sf_strategy_unit_id"] = sfDictionary[@"sf_strategy_unit_id"];
            pushProperties[@"$sf_enter_plan_time"] = sfDictionary[@"sf_enter_plan_time"];
            pushProperties[@"$sf_channel_id"] = sfDictionary[@"$sf_channel_id"];
            pushProperties[@"$sf_channel_category"] = sfDictionary[@"sf_channel_category"];
            pushProperties[@"$sf_channel_service_name"] = sfDictionary[@"sf_channel_service_name"];
            if ([sfDictionary[@"sf_landing_type"] isEqualToString:@"LINK"]) { // 打开 URL
                pushProperties[@"$sf_link_url"] = sfDictionary[@"sf_link_url"];
            }
            NSDictionary *customizedParams = sfDictionary[@"customized"];
            if ([customizedParams isKindOfClass:NSDictionary.class]) {
                [pushProperties addEntriesFromDictionary:customizedParams];
            }
        }
    } @catch (NSException *exception) {
    }
    @try { // aps alert
        NSDictionary *apsAlert = userInfo[@"aps"][@"alert"];
        if ([apsAlert isKindOfClass:NSDictionary.class]) {
            pushProperties[@"$sf_msg_title"] = apsAlert[@"title"]; // 推送标题
            pushProperties[@"$sf_msg_content"] = apsAlert[@"body"]; // 推送内容
        }
        else if ([apsAlert isKindOfClass:NSString.class]) {
            pushProperties[@"$sf_msg_content"] = apsAlert; // 推送内容
        }
    } @catch (NSException *exception) {
    }
    [SensorsAnalyticsSDK.sharedInstance track:@"$AppPushClick" withProperties:pushProperties];
}


@end

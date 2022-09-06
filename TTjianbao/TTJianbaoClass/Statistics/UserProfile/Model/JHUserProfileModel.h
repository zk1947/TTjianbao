//
//  JHUserProfileModel.h
//  TTjianbao
//  Description:用户画像（第三套>统计）子类参数>公参、私参
//  Created by Jesse on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserProfileModel : NSObject

@property (nonatomic, copy) NSString* app_ver; //版本号
@property (nonatomic, copy) NSString* channel; //渠道号
@property (nonatomic, copy) NSString* device_id; //设备唯一标识
@property (nonatomic, copy) NSString* sessionId;
@property (nonatomic, copy) NSString* user_id; //用户id
@property (nonatomic, copy) NSString* brand; //设备厂商 iphone
@property (nonatomic, copy) NSString* model; //设备型号 iphone6
@property (nonatomic, copy) NSString* platform; //设备类型 iOS Android
@property (nonatomic, copy) NSString* os_ver; //android sdk版本号 10.2
@property (nonatomic, copy) NSString* network_status; //网络连接状态:unknown/unReachable/wifi/cell network
@property (nonatomic, copy) NSString* sdk_version; //用户画像sdk版本

@end

@interface JHUserProfileReportModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString* event_type; //直播间浏览事件
@property (nonatomic, copy) NSString* client_time; //客户端时间
//动态参数{"time":1231231231，”type“：0,room_id:"121"}
@property (nonatomic, strong) NSDictionary* params; //type=0代表进入时间

- (instancetype)initWithEvent:(NSString *)eventType bodyDict:(NSDictionary*)paramDict;
//保存事件数据
+ (void)saveNoteTimingEvent:(JHUserProfileReportModel*)model;
//获取事件数据
+ (NSArray*)getNoteTimingEvent;
//清理事件数据
+ (void)clearNoteTimingEvent;

@end

NS_ASSUME_NONNULL_END

//
//  JHAntiFraud.m
//  TTjianbao
//
//  Created by jesee on 25/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAntiFraud.h"
#import "SmAntiFraud.h"
#import "NSString+Common.h"

#define kOrganizationStr @"Y249BgiTbsHsEKZSshsZ"
#define kAppIdStr [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]
#define kPublickKeyStr @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDN1L/LWR8Us4AB19qonxsH4A7hyyr8hqKzKcJ+ovBRhq05OIdZvmrE8sLe0ThYO9ILAQ46cMIrbLIR99edPcQ1fqv+x7gIW9v+k4oOiL7LHaqraa+/t9fiJtJojpGMCby3OGHqEeZTEOtwcSG8QN4Uhco2Ovhw31uaJl3yIHIb5wIDAQAB"

@implementation JHAntiFraud

//注册风控配置
+ (void)registerExtHandler
{
    [self smAntiFraudRegister];
}

//注册数美配置参数
+ (void)smAntiFraudRegister
{//8DhykSie1sZuN3wPsVQO
    //通用配置项
    SmOption * option = [[SmOption alloc] init];
    [option setOrganization:kOrganizationStr];
    [option setAppId:kAppIdStr];
    [option setPublicKey:kPublickKeyStr];
    //连接机房特殊配置项
    [option setArea:AREA_BJ];
    //注册初始化
    [[SmAntiFraud shareInstance] create:option];
}

//从风控端获取设备id
+ (NSString*)deviceId
{
    NSString * deviceID = [[SmAntiFraud shareInstance] getDeviceId];
    if([NSString isEmpty:deviceID])
    {
        deviceID = @"deviceId_ios"; //默认获取为空，填充数据
    }
    else
    {
//        deviceID = @"special_device_id_iOS"; //临时验证数美数据
    }
    return deviceID;
}

//获取~风控SDK版本号
+ (NSString*)getSDKVersion
{
    NSString *version = [SmAntiFraud getSDKVersion];
    return version;
}

@end

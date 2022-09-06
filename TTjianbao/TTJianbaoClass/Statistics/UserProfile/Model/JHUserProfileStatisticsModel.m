//
//  JHUserProfileStatisticsModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserProfileStatisticsModel.h"
#import "Reachability.h"
#import "DeviceInfoTool.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoKeyword.h"

#define kUserProfileStatisticsReq @"/anon/advert_channel/persona-report/"
#define kUserProfileStatisticsVersion @"0.0.1"

@implementation JHUserProfileStatisticsModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.base_info = [JHUserProfileModel new];
        [self makeCommonParams]; //公参
    }
    return self;
}

- (NSString *)uriPath
{//~/anon/advert_channel/persona-report/
    return [NSString stringWithFormat:@"%@",kUserProfileStatisticsReq];
}

#pragma mark - make params
- (void)recordEventType:(NSString *)eventType bodyDict:(NSDictionary*)paramDict
{
    JHUserProfileReportModel* report = [[JHUserProfileReportModel alloc] initWithEvent:eventType bodyDict:paramDict];
    self.report_info = [NSArray arrayWithObject:report];
}

- (void)setEventArray:(NSArray*)array
{
    //私参
    self.report_info = [NSArray arrayWithArray:array];
    //公参
    self.base_info = [JHUserProfileModel new];
    [self makeCommonParams];
}

- (void)setEventType:(NSString *)eventType bodyDict:(NSDictionary*)paramDict
{
    //私参
    [self recordEventType:eventType bodyDict:paramDict];
    //公参
    self.base_info = [JHUserProfileModel new];
    [self makeCommonParams];
}

- (void)makeCommonParams
{
    self.base_info.app_ver = JHAppVersion;
    self.base_info.channel = JHAppChannel;
    self.base_info.device_id = [CommHelp deviceIDFA];
    self.base_info.sessionId = [[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id]?:@"";
    self.base_info.user_id = [UserInfoRequestManager sharedInstance].user.customerId ? : @"";
    self.base_info.brand = @"Apple";
    self.base_info.model = [DeviceInfoTool deviceVersion];
    self.base_info.platform = @"iOS";
    self.base_info.os_ver = [UIDevice currentDevice].systemVersion;
    self.base_info.sdk_version = kUserProfileStatisticsVersion;
    //网络连接状态:unknown/unReachable/wifi/cell network
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NSString* networkStatus =  [reachability currentReachabilityString];
    self.base_info.network_status = networkStatus;
}

@end


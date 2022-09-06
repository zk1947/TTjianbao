//
//  JHCustomBugly.m
//  TTjianbao
//
//  Created by yaoyao on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomBugly.h"
#import <Bugly/Bugly.h>
#import "UserInfoRequestManager.h"
#import "JHHttpSessionManager.h"

#define kBuglyReleaseAppId @"7fe8814afe"
#define kBuglyDebugAppId @"f41366009e"

@implementation JHCustomBugly

+ (void)buglySetUp {

#ifdef DEBUG
    [Bugly startWithAppId:kBuglyDebugAppId];  //测试环境也上报 异常
#else
     [Bugly startWithAppId:kBuglyReleaseAppId];
#endif
    
    [Bugly setUserIdentifier:[UserInfoRequestManager sharedInstance].user.customerId?:@""];
}

//上报自定义错误
+ (void)customException:(NSException*)exception
{
    [Bugly reportException:exception];
}

//上报自定义错误:默认dic<公参
+ (void)customExceptionClass:(Class)class reason:(NSString*)reason
{
    [self customExceptionClass:class reason:reason message:@{}];
}

//上报自定义错误:可以添加自定义参数+公参
+ (void)customExceptionClass:(Class)class reason:(NSString*)reason message:(NSDictionary*)dic
{
    NSArray* callStack = [NSArray array]; //空数组
    NSMutableDictionary* extraInfo = [self customExtraInfo:dic];
    NSLog(@">>>customExceptionClass:dic=%@", extraInfo);
    [Bugly reportExceptionWithCategory:3 name:NSStringFromClass(class) reason:reason callStack:callStack extraInfo:extraInfo terminateApp:NO];
}

+ (NSMutableDictionary*)customExtraInfo:(NSDictionary*)dic
{
    //借用一下
    JHHttpSessionManager* httpSession = [JHHttpSessionManager new];
    [httpSession setSessionManager:0 encryptParams:nil timeoutInterval:0];
    NSDictionary* publicDic = httpSession.requestSerializer.HTTPRequestHeaders;
    //组成公参
    NSMutableDictionary* extraDic = [NSMutableDictionary dictionary];
    [extraDic setDictionary:publicDic];
    [extraDic addEntriesFromDictionary:dic];
    
    return extraDic;
}

@end

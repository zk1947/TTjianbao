//
//  JHHttpSessionManager.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHttpSessionManager.h"
#import "DeviceInfoTool.h"
#import "TTjianbaoMarcoKeyword.h"
#import "CommHelp.h"
#import "UMengManager.h"

//如果未传值,或者太小,认为无效,以3秒为界限
#define kMinTimeoutInterval 3

@implementation JHHttpSessionManager

//获取AFHTTPSessionManager,添加公参,并且设置超时(bu设置默认为20 s)
- (void)setSessionManager:(RequestSerializerType)serializerType encryptParams:(NSDictionary*)params timeoutInterval:(NSTimeInterval)timeoutInterval
{
    ///requestSerializer setting
    if (serializerType == RequestSerializerTypeJson)
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    else //if (serializerType == RequestSerializerTypeHttp)
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //如果小于3秒,认为无效,设置20s
    if(timeoutInterval > kMinTimeoutInterval)
        self.requestSerializer.timeoutInterval = timeoutInterval;
    else
        self.requestSerializer.timeoutInterval = kDefaultTimeoutInterval;
    
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    NSLog(@">>&>>token: %@", [NSString stringWithFormat:@"Bearer %@",token]);
    if ([JHRootController isLogin] && token)
    {
         [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    
    if (params)
    {
        SignModel* signMode = [self encryption:params];
        [self.requestSerializer setValue:signMode.locality_Time forHTTPHeaderField:@"X-Client-Time"];
        [self.requestSerializer setValue:signMode.encryption_Sign forHTTPHeaderField:@"X-TtjbSign"];
        [self.requestSerializer setValue: signMode.nonceStr forHTTPHeaderField:@"X-NonceStr"];
    }
    
//    [self.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-App-Id"];
    
//    [self.requestSerializer setValue: [CommHelp getKeyChainUUID] forHTTPHeaderField:@"X-Device-IMEI"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id].length>0) {
        [self.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id] forHTTPHeaderField:@"X-SESSION-ID"];
    }
    [self.requestSerializer setValue:JHAppVersion forHTTPHeaderField:@"X-App-Version"];
    [self.requestSerializer setValue:[HttpRequestTool getPublicInfoString] forHTTPHeaderField:@"X-App-Info"];
//    [self.requestSerializer setValue:JHAppChannel forHTTPHeaderField:@"X-App-Channel"];
//    [self.requestSerializer setValue:[DeviceInfoTool deviceVersion] forHTTPHeaderField:@"X-Device-Model"];
//    [self.requestSerializer setValue:@"Apple" forHTTPHeaderField:@"X-Device-Name"];
//    [self.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"X-Device-Version"];
//    [self.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenW] forHTTPHeaderField:@"X-Device-Width"];
//    [self.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenH] forHTTPHeaderField:@"X-Device-Height"];
//    [self.requestSerializer setValue:[[UMengManager shareInstance] getUmengId] forHTTPHeaderField:@"X-Device-UMId"];
//    [self.requestSerializer setValue:[[UMengManager shareInstance] getUmengUtid] forHTTPHeaderField:@"X-Device-UTDId"];
//    [self.requestSerializer setValue:[Growing getDeviceId] forHTTPHeaderField:@"X-Device-GIId"];
//    [self.requestSerializer setValue:[CommHelp deviceIDFA] forHTTPHeaderField:@"X-Device-IDFA"];
    
    //responseSerializer set accept content type
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];

    NSLog(@">>&>>requestSerializer:%@", self.requestSerializer.HTTPRequestHeaders);
}

//加密
- (SignModel*)encryption:(NSDictionary*)parameters
{
    SignModel* mode = [[SignModel alloc]init];
    NSString* timeStamp = [CommHelp getNowTimetampBySyncServeTime];
    NSString* randomNumber = [CommHelp getRandomNumber];
    NSMutableArray* paramArr = [[NSMutableArray alloc]initWithCapacity:10];
    for (NSString* key in [parameters allKeys])
    {
        [paramArr addObject:@{@"sort":key,@"desc":[NSString stringWithFormat:@"%@=%@",key,parameters[key]]}];
    }
    NSMutableString* paramStr = [[NSMutableString alloc]initWithCapacity:10];
    for (NSDictionary* dic in [CommHelp sortString:paramArr forParameter:@"sort"])
    {
        [paramStr appendString:
         [NSString stringWithFormat:@"%@&",dic[@"desc"]]];
    }
     [paramStr appendString:[NSString stringWithFormat:@"nonceStr=%@", randomNumber]];
    
     mode.locality_Time = timeStamp;
     mode.nonceStr = randomNumber;
     mode.encryption_Sign = [CommHelp sha1:[[@"87918F0C553F9B0E1236224EA107BEBA" stringByAppendingString:[CommHelp md5:paramStr]] stringByAppendingString:OBJ_TO_STRING(mode.locality_Time)]];
    
    return mode;
}

@end

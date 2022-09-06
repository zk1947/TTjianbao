//
//  HttpRequestTool.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/14.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "HttpRequestTool.h"
#import "DeviceInfoTool.h"
#import "TTjianbaoMarcoKeyword.h"
#import "TTjianbaoHeader.h"
#import "NSString+AES.h"
#import "JHAntiFraud.h"
#import "Tracking.h"
#import "RequestModel.h"
#import "UMengManager.h"

static AFHTTPSessionManager *manager; //默认返回主线程
static AFHTTPSessionManager *childThreadManager;  //主动设置返回子线程

@interface HttpRequestTool ()

//返回子队列（子线程）
@property (nonatomic, assign) BOOL needCompletionChildQueue;
@end

@implementation HttpRequestTool
+ (AFHTTPSessionManager *)sessionManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

+ (AFHTTPSessionManager *)childThreadSessionManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        childThreadManager = [AFHTTPSessionManager manager];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        childThreadManager.completionQueue  = queue;
    });
    return childThreadManager;
}

+ (void)getWithURL:(NSString*)url Parameters:(id )parameters successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    NSLog(@"url %@ parameters %@", url, parameters);
    AFHTTPSessionManager *manager = [self getSessionManager:RequestSerializerTypeHttp encryption:nil];
    
    [manager GET:url parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successBlock:success failureBlock:failure response:responseObject];
        NSLog(@"*****************网络url-----%@",task.originalRequest.URL);
        DDLogInfo(@"*****************网络responseObject-----%@",responseObject);
        if ([responseObject[@"code"] integerValue] == 1000) {
//            NSLog(@"succeess URL:%@",task.originalRequest.URL);
        }else {
//            NSLog(@"fail URL:%@",task.originalRequest.URL);

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
        [self failureBlock:failure response:error];
    }];
}
+ (void)postWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType   successBlock:(succeedBlock) success failureBlock:(failureBlock)failure
{
    [self postWithURL:url Parameters:parameters requestSerializerType:serializerType timeoutInterval:20 successBlock:success failureBlock:failure];
}
+ (void)postWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType timeoutInterval:(NSTimeInterval)timeoutInterval  successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    
    NSLog(@"url %@ parameters %@", url, parameters);

    AFHTTPSessionManager *manager = [self getSessionManager:serializerType encryption:nil timeoutInterval:timeoutInterval];
    
    [manager POST:url parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"*****************网络url-----%@",task.originalRequest.URL);
        DDLogInfo(@"*****************网络responseObject-----%@",responseObject);
        [self successBlock:success failureBlock:failure response:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
        
        NSLog(@"localizedDescriptionL0000 %@", error);
        [self failureBlock:failure response:error];
    }];
}
///带有上传进度回调的方法
+ (void)postWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType uploadProgress:(uploadProgressBlock)uploadProgressBlock successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    
    NSLog(@"url %@ parameters %@", url, parameters);

    AFHTTPSessionManager *manager = [self getSessionManager:serializerType encryption:nil];
    
    [manager POST:url parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
        [self uploadProgressBlock:uploadProgressBlock uploadProgress:uploadProgress];
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successBlock:success failureBlock:failure response:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
        [self failureBlock:failure response:error];
    }];
   
}

+ (void)postWithURL:(NSString*)url Parameters:(id )parameters isEncryption:(BOOL)encryption  requestSerializerType:(RequestSerializerType)serializerType successBlock:(succeedBlock) success failureBlock:(failureBlock)failure{
    
    NSLog(@"url %@ parameters %@", url, parameters);
    
    AFHTTPSessionManager *manager = [self getSessionManager:serializerType encryption:[self encryption:parameters]];
    
    [manager POST:url parameters:parameters headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successBlock:success failureBlock:failure response:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
        [self failureBlock:failure response:error];
    }];
    
}
+ (void)putWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType   successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    AFHTTPSessionManager *manager = [self getSessionManager:serializerType encryption:nil];
    NSLog(@"url %@ parameters %@", url, parameters);

    [manager PUT:url parameters:parameters headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self successBlock:success failureBlock:failure response:responseObject];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
        [self failureBlock:failure response:error];
    }];
    
}
+(void)deleteWithURL:(NSString*)url Parameters:(id )parameters  requestSerializerType:(RequestSerializerType)serializerType   successBlock:(succeedBlock) success failureBlock:(failureBlock)failure {
    AFHTTPSessionManager *manager = [self getSessionManager:serializerType encryption:nil];
    NSLog(@"url %@ parameters %@", url, parameters);
    
    [manager DELETE:url parameters:parameters headers:@{} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
      [self successBlock:success failureBlock:failure response:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure URL:%@",task.originalRequest.URL);
         [self failureBlock:failure response:error];
    }];

}
+ (AFHTTPSessionManager *)getSessionManager:(RequestSerializerType)serializerType  encryption:(SignModel*)signMode {
    return [self getSessionManager:serializerType encryption:signMode timeoutInterval:20];
}

+ (AFHTTPSessionManager *)getSessionManager:(RequestSerializerType)serializerType  encryption:(SignModel*)signMode timeoutInterval:(NSTimeInterval)timeoutInterval
{
    AFHTTPSessionManager *manager =[HttpRequestTool sessionManager];
//    if(self.needCompletionChildQueue)
//    {
//        manager =[HttpRequestTool childThreadSessionManager];
//    }
        
    
    NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    //这里是为了过虑后台返回的null
    serializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = serializer;
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    if (serializerType == RequestSerializerTypeJson){
        manager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    
    else  if (serializerType == RequestSerializerTypeHttp) {
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    }
    
    if ([JHRootController isLogin]&&token) {
         [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
        DDLogInfo(@"token =%@",[NSString stringWithFormat:@"Bearer %@",token]);
    }
    
    if (signMode) {
        [manager.requestSerializer setValue:signMode.locality_Time forHTTPHeaderField:@"X-Client-Time"];
        [manager.requestSerializer setValue:signMode.encryption_Sign forHTTPHeaderField:@"X-TtjbSign"];
        [manager.requestSerializer setValue: signMode.nonceStr forHTTPHeaderField:@"X-NonceStr"];
    }
    
//    [manager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"X-App-Id"];
    
//    [manager.requestSerializer setValue: [CommHelp getKeyChainUUID] forHTTPHeaderField:@"X-Device-IMEI"];
    if ([[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id].length>0) {
        [manager.requestSerializer setValue: [[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id] forHTTPHeaderField:@"X-SESSION-ID"];
    }
    [manager.requestSerializer setValue:JHAppVersion forHTTPHeaderField:@"X-App-Version"];
    [manager.requestSerializer setValue:[HttpRequestTool getPublicInfoString] forHTTPHeaderField:@"X-App-Info"];
//    [manager.requestSerializer setValue:JHAppChannel forHTTPHeaderField:@"X-App-Channel"];
//    [manager.requestSerializer setValue:[DeviceInfoTool deviceVersion] forHTTPHeaderField:@"X-Device-Model"];
//    [manager.requestSerializer setValue:@"Apple" forHTTPHeaderField:@"X-Device-Name"];
//    [manager.requestSerializer setValue:[UIDevice currentDevice].systemVersion forHTTPHeaderField:@"X-Device-Version"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenW] forHTTPHeaderField:@"X-Device-Width"];
//    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%f",ScreenH] forHTTPHeaderField:@"X-Device-Height"];
//
//
//    [manager.requestSerializer setValue:[[UMengManager shareInstance] getUmengId] forHTTPHeaderField:@"X-Device-UMId"];
//    [manager.requestSerializer setValue:[[UMengManager shareInstance] getUmengUtid] forHTTPHeaderField:@"X-Device-UTDId"];
//    [manager.requestSerializer setValue:[Growing getDeviceId] forHTTPHeaderField:@"X-Device-GIId"];
//
//    [manager.requestSerializer setValue:[CommHelp deviceIDFA] forHTTPHeaderField:@"X-Device-IDFA"];
//
    
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain", nil];
     return manager;
   
}

/// 3.5.5 新增 替换原来所有外面暴露的
+ (NSString *)getPublicInfoString {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"ios" forKey:@"platform"];
    [params setValue:[NSString stringWithFormat:@"cid%@",[CommHelp getAppinUUIDFoKeyChain]] forKey:@"cid"];
    [params setValue:JHAppVersion forKey:@"appver"];
    [params setValue:@1006 forKey:@"appvernum"];
    [params setValue:@"AppStore" forKey:@"channel"];
    [params setValue:@"Apple" forKey:@"dname"];
    [params setValue:[UIDevice currentDevice].systemVersion forKey:@"dver"];
    [params setValue:[DeviceInfoTool deviceVersion] forKey:@"dmode"];
    [params setValue:[NSString stringWithFormat:@"%f",ScreenW] forKey:@"w"];
    [params setValue:[NSString stringWithFormat:@"%f",ScreenH] forKey:@"h"];
    [params setValue:[CommHelp deviceIDFA] forKey:@"idfa"];
    [params setValue:[Growing getDeviceId] forKey:@"giid"];
    [params setValue:[[UMengManager shareInstance] getUmengId] forKey:@"umid"];
    [params setValue:[[UMengManager shareInstance] getUmengUtid] forKey:@"utdid"];
    [params setValue:[[NSUserDefaults standardUserDefaults] stringForKey:Gen_Session_Id] forKey:@"sessionId"];
    [params setValue:[Tracking getDeviceId] forKey:@"reyun_id"];
    [params setValue:[JHAntiFraud deviceId] forKey:@"sm_deviceId"];
    [params setValue:[UserInfoRequestManager sharedInstance].registrationID forKey:@"jpush_id"];
    
    // 如有活动code 就添加到INFO 中
    NSString *cdkCode = [[NSUserDefaults standardUserDefaults] stringForKey:@"ActivityCDKCode"];
    if (cdkCode.length > 0) {
        [params setValue:cdkCode forKey:@"frCode"];
    }
//    if (![JHRootController isLogin]) {
        [params setValue:[JHTracking userTrackAnonymousId] forKey:@"sc_id"];
//    } else {
//        [params setValue:@"" forKey:@"sc_id"];
//    }
    [params setValue:JH_IDFV forKey:@"idfv"];
#if DEBUG
    [params setValue:@"debug" forKey:@"envType"];
#endif
    NSString *jsonString = params.mj_JSONString;
    NSString *jsonAES = [jsonString aci_encryptWithAES];
    return jsonAES;
}

///上传进度回调
+ (void)uploadProgressBlock:(uploadProgressBlock)uploadProgressBlock uploadProgress:(NSProgress *)uploadProgress {
    if (!uploadProgress) {
        return;
    }
    if (uploadProgressBlock) {
        uploadProgressBlock(uploadProgress);
    }
}

+ (void)successBlock:(succeedBlock)success failureBlock:(failureBlock)failure   response:(id)responseObject{
//    NSLog(@"jsonDic==%@",responseObject);
    RequestModel *model = [RequestModel mj_objectWithKeyValues:responseObject];
    if (model.code == 1000) {
        if (success) {
            success(model);
        }
    }
    else  if (model.code == 1002) {
        //未登陆或者token过期
        //[JHRootController presentLoginVC];
        [SVProgressHUD dismiss];
        if (failure) {
            failure(model);
        }
    }
    else {
        if (!model.message || ![model.message isKindOfClass:[NSString class]]) {
            model.message = @"错误";
             [SVProgressHUD dismiss];
        }
        if (failure) {
            failure(model);
        }
    }
}

+ (void)failureBlock:(failureBlock)failure response:(NSError *)responseObject{
    
//    NSLog(@"jsonDic==%@",responseObject);

    RequestModel *model = [[RequestModel alloc] init];
    model.code = responseObject.code;
    model.message = @"连接失败,请检查网络";
    if (failure) {
        failure(model);
    }
    
}
+ (SignModel*)encryption:(NSDictionary*)parameters {
    
    SignModel * mode=[[SignModel alloc]init];
    NSString * timeStamp=[CommHelp getNowTimetampBySyncServeTime];
    NSString * randomNumber=[CommHelp getRandomNumber];
    NSMutableArray * paramArr=[[NSMutableArray alloc]initWithCapacity:10];
    for (NSString * key in [parameters allKeys]) {
        [paramArr addObject:@{@"sort":key,@"desc":[NSString stringWithFormat:@"%@=%@",key,parameters[key]]}];
    }
    NSMutableString * paramStr=[[NSMutableString alloc]initWithCapacity:10];
    for (NSDictionary * dic in [CommHelp sortString:paramArr forParameter:@"sort"]) { 
        [paramStr appendString:
         [NSString stringWithFormat:@"%@&",dic[@"desc"]]];
    }
     [paramStr appendString:[NSString stringWithFormat:@"nonceStr=%@", randomNumber]];
    
     mode.locality_Time=timeStamp;
     mode.nonceStr=randomNumber;
     mode.encryption_Sign=[CommHelp sha1:[[@"87918F0C553F9B0E1236224EA107BEBA" stringByAppendingString:[CommHelp md5:paramStr]] stringByAppendingString:OBJ_TO_STRING(mode.locality_Time)]];
    
    return mode;
    
}
@end

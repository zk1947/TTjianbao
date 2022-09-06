//
//  JHASAManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHASAManager.h"
#import "CommHelp.h"
#import <iAd/iAd.h>
#import <AdServices/AdServices.h>

static NSString * const ASAReportKey = @"ASAReportKey";
static NSUInteger const LimitRetryNum = 5;

typedef void(^TokenHandler)(NSString *token);

@interface JHASAManager ()<NSURLSessionDelegate>
@property (nonatomic, assign) NSUInteger limitRetryNum;
@property (nonatomic, strong) NSOperationQueue *queue;
@end
@implementation JHASAManager

+ (instancetype)sharedManager
{
    static JHASAManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHASAManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.limitRetryNum = LimitRetryNum;
    }
    return self;
}

/// 获取归因包
- (void)asaAttribution {
    @weakify(self)
    [self.queue addOperationWithBlock:^{
        @strongify(self)
        BOOL isReport = [[NSUserDefaults standardUserDefaults] boolForKey: ASAReportKey];
        if (isReport) return;
        
        if (@available(iOS 14.3, *)) {
            [self getAttributionToken:^(NSString *token) {
                [self getAttributionWithToken:token];
            }];
        } else {
            [self getAttribution];
        }
    }];
    
}

- (void)getAttributionToken : (TokenHandler)handler{
    __block NSString *token = nil;
    if (@available(iOS 14.3, *)) {
        [self.queue addOperationWithBlock:^{
            NSError *error;
            NSString *attributionToken = [AAAttribution attributionTokenWithError: &error];
            if (!error) {
                token = attributionToken;
            }
            [NSThread sleepForTimeInterval:10.0];
            if (token == nil) {
                [self retry];
                NSLog(@"token 请求超时");
            }
            handler(token);
        }];
    }
}

/// 获取ASA归因数据包 - 14.3以下
- (void)getAttribution{
    @weakify(self)
    [self.queue addOperationWithBlock:^{
        @strongify(self)
        if (![[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) return;
        
        @weakify(self)
        [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary<NSString *,NSObject *> * _Nullable attributionDetails, NSError * _Nullable error) {
            @strongify(self)
            if (error || attributionDetails == nil) {
                [self retry];
                return;
            }
            [self reportAttributionWithParams:attributionDetails isNew : false token : nil];
        }];
    }];
}
/// 获取归因数据包- 14.3以上版本
- (void)getAttributionWithToken:(NSString *)token{
    if (token == nil) return;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"https://api-adservices.apple.com/api/v1/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSData* postData = [token dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    @weakify(self)
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        @strongify(self)
        NSError *resError;
        if (data == nil) {
            [self retry];
            return;
        }
        NSMutableDictionary *resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&resError];
        if (resError) {
            [self retry];
            return;
        }
       
        [self reportAttributionWithParams:resDic isNew : true token : token];
        NSLog(@"%@" , resDic);
        
    }];
    [postDataTask resume];
}
- (void)retry {
    self.limitRetryNum -= 1;
    if (self.limitRetryNum <= 0) return;
    @weakify(self)
    [self.queue addOperationWithBlock:^{
        @strongify(self)
        [NSThread sleepForTimeInterval:10.0];
        [self asaAttribution];
    }];
}
/// 归因数据上报服务器
- (void)reportAttributionWithParams : (NSDictionary *)params isNew : (BOOL)isNew token : (NSString *)token{
    NSString *json = [params mj_JSONString];
    NSDictionary *par = @{
        @"asaToken" : token ?: @"",
        @"newVersion" : @(isNew),
        @"dataJson" : json,
    };
    
    NSString *url = FILE_BASE_STRING(@"/data/asa/upload");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        [[NSUserDefaults standardUserDefaults] setValue:@(true) forKey: ASAReportKey];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self retry];
    }];
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}
@end

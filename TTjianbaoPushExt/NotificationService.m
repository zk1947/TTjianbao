//
//  NotificationService.m
//  TTjianbaoPushExt
//
//  Created by jesee on 26/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NotificationService.h"
#import "JPushNotificationExtensionService.h"
#define kReqReportUrl @"https://api.ttjianbao.com/mc/anon/msg/push/report"
//#define kReqReportUrl @"https://api-test.ttjianbao.com/mc/anon/msg/push/report"
#define kExtService @"JHExtService"
#define kExtAccount @"JHExtAccount"
#define kExtAccessGroup @"com.tianmou.jianbao.accessGroups"
#define kInfoXgKey @"xg"
#define kInfoApsKey @"aps"
#define kInfoApsAlertKey @"alert"
#define kInfoPushIdKey @"pushId"
@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
         NSLog(@"didReceiveNotificationRequest");
         // Modify the notification content here...
//         self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
         //获取通知信息数据：语音播报的文案 + 通知栏的title + 以及通知内容
     NSDictionary* infoDict = self.bestAttemptContent.userInfo;

     [self reportPushData:infoDict];
         //如果想解决当同时推送了多条消息，这时我们想多条消息一条一条的挨个播报，我们就需要将此行代码注释
//         self.contentHandler(self.bestAttemptContent);
    
    //jpush上报统计
    [self apnsDeliverWith:request];
}
- (void)apnsDeliverWith:(UNNotificationRequest *)request {
  
  [JPushNotificationExtensionService setLogOff];
  [JPushNotificationExtensionService jpushSetAppkey:@"ce5736172f26bb361ebd777d"];
  [JPushNotificationExtensionService jpushReceiveNotificationRequest:request with:^ {
    NSLog(@"apns upload success");
  }];
}
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

#pragma mark - bussiness
- (void)reportPushData:(NSDictionary*)userInfo
{
//    NSDictionary * userInfo = request.content.userInfo;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    //服务端与客户端约定各种资源的url，根据url资源进行下载
    NSString * imageUrl = [userInfo objectForKey:@"largeIcon"];
    NSString * typeString ;
    NSURL * url;
    if (imageUrl.length>0) {
        url = [NSURL URLWithString:imageUrl];
        typeString = @"jpg";//[userInfo objectForKey:@"pic_type"];
    }
    if (url) {
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];

        __weak typeof(self) weakSelf = self;
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:urlRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            __strong typeof(weakSelf) strongSelf = weakSelf;

            if (!error) {
                NSString *path = [location.path stringByAppendingString:[NSString stringWithFormat:@".%@",typeString]];
                NSError *err = nil;
                NSURL * pathUrl = [NSURL fileURLWithPath:path];
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:pathUrl error:nil];
                UNNotificationAttachment *resource_attachment = [UNNotificationAttachment attachmentWithIdentifier:@"attachment" URL:pathUrl options:nil error:&err];
                if (resource_attachment) {
                    strongSelf.bestAttemptContent.attachments = @[resource_attachment];
                }
                if (error) {
                    NSLog(@"%@", error);
                }
                //设置为@""以后，进入app将没有启动页
                strongSelf.bestAttemptContent.launchImageName = @"";
                UNNotificationSound *sound = [UNNotificationSound defaultSound];
                strongSelf.bestAttemptContent.sound = sound;
                strongSelf.contentHandler(strongSelf.bestAttemptContent);
            }
            else{
                strongSelf.contentHandler(strongSelf.bestAttemptContent);
            }
        }];
        [task resume];
    }
    else{
        self.contentHandler(self.bestAttemptContent);
    }
}

- (NSURLRequest *)makeTaskRequest:(NSDictionary*)infoDict
{
    //    JHPushReportModel* pushReq = [JHPushReportModel new];
    NSString *urlString = kReqReportUrl;//[pushReq fullUrl];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
   // [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     
    NSDictionary* xgDic = [infoDict objectForKey:kInfoXgKey];
    NSMutableDictionary *post = [NSMutableDictionary dictionaryWithDictionary:xgDic ? : infoDict];
    
    NSString *deviceToken = [infoDict objectForKey:kInfoPushIdKey];
    if(deviceToken)
    {
        [post setObject:deviceToken forKey:@"pushIds"];
    }
    NSString *bodyStr =[NSString stringWithFormat:@"%@=%@",@"pushIds",deviceToken?:@""];
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
   // [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:post options:0 error:nil]];
    return request;
}

#pragma mark - keychain
- (NSString *)readExtValue
{
    NSMutableDictionary *attributes = [self keychainQueryWithService:kExtService account:kExtAccount accessGroup:kExtAccessGroup];
    attributes[(__bridge id)kSecMatchLimit] = (__bridge id)(kSecMatchLimitOne);
    attributes[(__bridge id)kSecReturnAttributes] = (__bridge id _Nullable)(kCFBooleanTrue);
    attributes[(__bridge id)kSecReturnData] = (__bridge id _Nullable)(kCFBooleanTrue);

    CFMutableDictionaryRef queryResult = nil;
    OSStatus keychainError = noErr;
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)attributes,(CFTypeRef *)&queryResult);
    if (keychainError == errSecItemNotFound) {
        if (queryResult) CFRelease(queryResult);
        return nil;
    }else if (keychainError == noErr) {

        if (queryResult == nil){return nil;}

        NSMutableDictionary *resultDict = (__bridge NSMutableDictionary *)queryResult;
        NSData *valueData = resultDict[(__bridge id)kSecValueData];
        CFRelease(queryResult);
        NSString *mVlaue = [[NSString alloc] initWithData:valueData encoding:NSUTF8StringEncoding];

        return mVlaue;
    }else
    {
        NSAssert(NO, @"Serious error.\n");
        if (queryResult) CFRelease(queryResult);
    }

    return nil;
}

- (NSMutableDictionary *)keychainQueryWithService:(NSString *)service account:(NSString *)account accessGroup:(NSString *)accessGroup
{
    NSMutableDictionary *query = [NSMutableDictionary dictionary];

    query[(__bridge id)kSecClass] = (__bridge id)kSecClassGenericPassword;

    query[(__bridge id)kSecAttrService] = service;

    query[(__bridge id)kSecAttrAccount] = account;

//    query[(__bridge id)kSecAttrAccessGroup] = accessGroup;

    return query;
}

@end


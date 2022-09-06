//
//  AppDelegate+pullApp.m
//  TTjianbao
//
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "AppDelegate+pullApp.h"
#import "WXApi.h"
#import "UMengManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JHUnionPaySDKManager.h"
#import <LinkedME_iOS/LinkedME.h>
#import "TTjianbaoUtil.h"
#import <SensorsAnalyticsSDK.h>
#import <SensorsABTest.h>

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate (pullApp)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler
{
    //自己的实现代码
//    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    if ([WXApi handleOpenUniversalLink:userActivity delegate:self]) {
        return true;
    }
 
    //判断是否是通过LinkedME的Universal Links唤起App
    if ([[userActivity.webpageURL description] rangeOfString:@"ap4y.lkme.cc"].location != NSNotFound) {
        return  [[LinkedME getInstance] continueUserActivity:userActivity];
    }
    return true;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([[SensorsAnalyticsSDK sharedInstance] handleSchemeUrl:url]) {
        return YES;
    }
    
//    if ([TencentOAuth CanHandleOpenURL:url]) {
//        
//        return [TencentOAuth HandleOpenURL:url];//growing.8ab4ab85ee01fa15
//    }
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:nil];
        return YES;
    }
    
    if ([url.absoluteString containsString:@"loginwx"]||[url.absoluteString containsString:@"bindwx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }

    if ([[SensorsABTest sharedInstance] handleOpenURL:url]) {
            return YES;
        }
    #ifdef JH_UNION_PAY
            [[UMSocialManager defaultManager] handleOpenURL:url options:options];
            [JHUnionPaySDKManager handleOpenURL:url withDelegate:self];
            return YES;
    #endif
    
    //判断是否是通过LinkedME的UrlScheme唤起App
    if ([[url description] rangeOfString:@"ttjianbao"].location != NSNotFound) {
        return [[LinkedME getInstance] handleDeepLink:url];
    }
    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];

}

#pragma mark - register wechat
- (void)launchingRegisterPullAppOptions:(NSDictionary *)launchOptions
{
#ifdef JH_UNION_PAY
    [JHUnionPaySDKManager startUniconPay];
#endif
    [WXApi registerApp:WXAPPID universalLink:AppUniversalLink];
    
    [self initLinkedMeOptions:launchOptions];
}

#pragma mark - WXApiDelegate
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq*)req{
    
}
-(void) onResp:(BaseResp*)resp
{
    //wx
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode==0) {
            SendAuthResp * res=(SendAuthResp*)resp;
            NSLog(@"cccc==%@",res.state);
            if ([res.state isEqualToString:@"loginwx"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WXLOGINSUSSNotifaction object:res.code];
            }
            else if ([res.state isEqualToString:@"bindwx"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WXBINDSUSSNotifaction object:res.code];
            }
        }
    }
    
    //wx pay
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                NSLog(@"支付成功");
                break;
                
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

//linkedMe  init
- (void)initLinkedMeOptions:(NSDictionary *)launchOptions{
       //初始化及实例
        LinkedME* linkedme = [LinkedME getInstance];
      
        //设置重试次数
        [linkedme setMaxRetries:30];
        //设置重试间隔时间
        [linkedme setRetryInterval:2];
        
        //打印日志
        [linkedme setDebug];
        
        //[自动跳转]如果使用自动跳转需要注册viewController
        //[linkedme registerDeepLinkController:featureVC forKey:@"LMFeatureViewController"];
     
    #warning 必须实现
        //获取跳转参数
        [linkedme initSessionWithLaunchOptions:launchOptions automaticallyDisplayDeepLinkController:NO deepLinkHandler:^(NSDictionary* params, NSError* error) {
            if (!error) {
                //防止传递参数出错取不到数据,导致App崩溃这里一定要用try catch
                @try {
                NSLog(@"LinkedME finished init with params111 = %@",[params description]);
                //获取详情页类型(如新闻客户端,有图片类型,视频类型,文字类型等)
    //            NSString *title = [params objectForKey:@"$og_title"];
                
                    
                    //路由跳转
//                    [JHRouters gotoPageByJson:params[@"$control"]];
                    id values = [params[@"$control"] mj_JSONObject];
                    if (values) {
                        [UserInfoRequestManager sharedInstance].isDeepLinkInto = YES;
                    }
                    JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:values];
                    [JHRouterManager deepLinkRouter:router];
                    } @catch (NSException *exception) {
        
                    } @finally {
        
                    }
                
            } else {
                NSLog(@"LinkedME failed init: %@", error);
            }
        }];
}
@end

//
//  JHPasteboardManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/9/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPasteboardManager.h"
#import "JHRouterManager.h"
#import "NSString+Extension.h"
#import "JHWebViewController.h"
#import "JHActivityWebAlertView.h"
@interface JHPasteboardManager()

@end
@implementation JHPasteboardManager
/// 剪切板数据解析
+ (void)pasteboardParse {
    NSString *pasteStr = [JHPasteboardManager getPasteboardString];
//    NSString *pasteStr = @"6(复:|:制)💰本条邀请码【S7cQYgPNL91D8kB7t】💰下载【天天鉴宝App】\r\n↓\r\n打开【天天鉴宝App】\r\n新用户必得30元现金红包，提现秒到账";
    
    if (pasteStr == nil) return;

    if ([JHPasteboardManager hasTTJBStr:pasteStr]) {
        [JHPasteboardManager parsingStr : pasteStr];
        
        // 清空剪切板
        [[UIPasteboard generalPasteboard] setString:@""];
    }else if ([pasteStr hasPrefix:@"ttjbs://"]) {
        [JHPasteboardManager parsingUrlWithStr:pasteStr];
        // 清空剪切板
        [[UIPasteboard generalPasteboard] setString:@""];
    }
}
/// 是否是天天鉴宝的口令
+ (BOOL)hasTTJBStr : (NSString *)pasteStr {
    if (pasteStr.length <= 0) return false;
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"appInitData"];
    
    AppInitDataModel *model = [AppInitDataModel mj_objectWithKeyValues:dict];
    NSArray *regexs = model.activityRegulars;
    
    BOOL has = false;
    for (NSString *str in regexs) {
        NSString *regex = str;
        if (regex.length <= 0) {
            regex = @"^🧧复制[\\u4e00-\\u9fa5]{1,}🧧【\\w+】\\W{0,4}[\\u4e00-\\u9fa5A-Za-z]{0,4}「天天鉴宝[\\u4e00-\\u9fa5A-Za-z]{0,}」([\\s\\S]*)";
        }
        @try {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            
            BOOL result = [predicate evaluateWithObject:pasteStr];
            if (result) {
                has = true;
                break;
            }
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    return has;
}
/// 解析文本
+ (void)parsingStr : (NSString *)pasteStr{
    NSString *params = [JHPasteboardManager getParamsWithStr:pasteStr];
    NSLog(@"%@",params);
    if (params == nil) return;
    
    [JHPasteboardManager getRouterInfoRequest:params successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dict = [respondObject.data mj_JSONObject];
        if (dict == nil || ![dict isKindOfClass:[NSDictionary class]]) return;
        NSDictionary *body = (NSDictionary *)dict[@"intentBody"];
        if (body == nil) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            JHRouterModel* router = [JHRouterModel mj_objectWithKeyValues:body];
            [JHRouterManager deepLinkRouter:router];
        });
    }];
}
/// 解析Url
+ (void)parsingUrlWithStr : (NSString *)pasteStr {
    // 解析参数:
    NSDictionary *params = [JHPasteboardManager getParamsWithUrl:pasteStr];
    if(!params) return;
    NSString *productId = [params valueForKey:@"productId"];
    if(!productId) return;
    // 延迟处理
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[UserInfoRequestManager sharedInstance] findLandingTargetWithProductId:productId];
    });
}
/// 获取文本中的参数
+ (NSString *)getParamsWithStr : (NSString *)pasteStr {
    NSError *error;
    NSString *str = @"(?<=\\【).*?(?=\\】)";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:str options:0 error:&error];
    
    NSTextCheckingResult * result = [regular firstMatchInString:pasteStr options:NSMatchingReportProgress range:NSMakeRange(0, pasteStr.length)];
    
    NSString *params = [pasteStr substringWithRange:result.range];
    // 保存code
    [JHPasteboardManager saveCode:params];
    return params;
}
/// 根据string Url获取 ? 后面的参数
+ (NSDictionary *)getParamsWithUrl:(NSString *)str {
    NSURL *url = [NSURL URLWithString:str];
    if(!url && !url.absoluteString) return nil;
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
    NSMutableDictionary *res = [[NSMutableDictionary alloc] init];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.name && obj.value){
            [res setValue:obj.value forKey:obj.name];
        }
    }];
    return [res copy];
}

+ (NSString *)getPasteboardString {
    NSString *pasteStr = [UIPasteboard generalPasteboard].string;
    return pasteStr;
}
/// 获取透传信息
+ (void)getRouterInfoRequest : (NSString *)body successBlock:(succeedBlock) success{
    NSDictionary *par = @{
        @"cdkCode" : body,
    };
    
    NSString *url = FILE_BASE_STRING(@"/activity/api/cdk/check-and-landing-page");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
    }];
}
/// 保存活动code 30分钟后清除
+ (void)saveCode : (NSString *)code{
    if (code.length <= 0) return;
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:@"ActivityCDKCode"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * 60 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ActivityCDKCode"];
    });
}
@end

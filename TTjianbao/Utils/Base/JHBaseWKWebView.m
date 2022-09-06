//
//  JHBaseWKWebView.m
//  TTjianbao
//
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseWKWebView.h"
#import "YYWeakProxy.h"

@interface JHBaseWKWebView ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

/// key methodName  value method (block)
@property (nonatomic, strong) NSMutableDictionary *jh_registerMethodDic;

@property (nonatomic, strong) YYWeakProxy *jh_proxyTarget;

@end


@implementation JHBaseWKWebView

- (void)dealloc {
    for (NSString *methodName in self.jh_registerMethodDic) {
        [self.configuration.userContentController removeScriptMessageHandlerForName:methodName];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.allowsInlineMediaPlayback = true;
    self = [super initWithFrame:frame configuration:config];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.scrollView.bounces = NO;
        self.navigationDelegate = self;
        self.UIDelegate = self;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.viewController.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    return self;
}

#pragma mark --------------- public method start ---------------
- (void)jh_registerMethodName:(NSString *)methodName completeBlock:(ScriptMessageHandlerBlock)completeBlock {
    [self.jh_registerMethodDic setValue:completeBlock forKey:methodName];
    [self.configuration.userContentController addScriptMessageHandler:(id <WKScriptMessageHandler>)self.jh_proxyTarget name:methodName];
}

- (void)jh_nativeCallJSMethod:(NSString * __nullable)methodName param:(NSString * __nullable)param {
    [self jh_nativeCallJSMethod:methodName param:[NSString stringWithFormat:@"'%@'",param] completionHandler:nil];
}

- (void)jh_nativeCallJSMethod:(NSString *)methodName paramArray:(NSArray *)paramArray {
    NSString *str = @"";
    int i = 0;
    for (NSString *obj in paramArray) {
        if(i == 0) {
            str = [NSString stringWithFormat:@"'%@'",obj];
        } else {
            str = [NSString stringWithFormat:@",'%@'",obj];
        }
        i++;
    }
    [self jh_nativeCallJSMethod:methodName param:str completionHandler:nil];
}

/// wk调用js
/// @param methodName 方法名字
/// @param prarm 方法参数 jsonString   ()空串 @""         没有（）传nil
/// @param completionHandler 调用js的回调
- (void)jh_nativeCallJSMethod:(NSString * __nullable)methodName param:(NSString * __nullable)param completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    NSString *method = [NSString stringWithFormat:@"%@",methodName];
    if (param) {
        method = [NSString stringWithFormat:@"%@(%@)",methodName,param];
    }
    [self evaluateJavaScript:method completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        NSLog(@"1");
    }];
}

///加载url
- (void)jh_loadWebURL:(NSString *)string {
    NSURL *url = [NSURL URLWithString:string];
    if (url) {
        [self jh_show];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [self loadRequest:request];
    } else {
        ///非法URL  特殊字符，中文，（没 urlEncode）
        [self jh_hiddenWithUrl:string];
    }
}

///加载html
- (void)jh_loadWithHtml:(NSString *)string {
    [self loadHTMLString:string baseURL:nil];
}
#pragma mark --------------- public method end ---------------

#pragma mark ---------------------------- WKUIDelegate ----------------------------
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:action];
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            //不打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark --------- WKNavigationDelegate ---------------
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self jh_hiddenWithUrl:nil];
    if (self.jh_webViewDidFailBlock) {
        self.jh_webViewDidFailBlock((JHBaseWKWebView *)webView);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self jh_hiddenWithUrl:nil];
    if (self.jh_webViewDidFailBlock) {
        self.jh_webViewDidFailBlock((JHBaseWKWebView *)webView);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (_jh_webViewDidFinishBlock) {
        _jh_webViewDidFinishBlock((JHBaseWKWebView *)webView);
    }
}

#pragma mark --------------- WKScriptMessageHandler ---------------
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    for (NSString *methodName in self.jh_registerMethodDic) {
        if ([message.name isEqualToString:methodName]) {
            ScriptMessageHandlerBlock block = [_jh_registerMethodDic valueForKey:message.name];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(message);
                }
            });
        }
    }
}

#pragma mark --------------- get ---------------
- (YYWeakProxy *)jh_proxyTarget {
    if(!_jh_proxyTarget) {
        _jh_proxyTarget = [YYWeakProxy proxyWithTarget:self];
    }
    return _jh_proxyTarget;
}

- (NSMutableDictionary *)jh_registerMethodDic {
    if (!_jh_registerMethodDic) {
        _jh_registerMethodDic = [NSMutableDictionary dictionaryWithCapacity:15];
    }
    return _jh_registerMethodDic;
}

- (void)jh_hiddenWithUrl:(NSString *)url {
    self.hidden = YES;
//#ifdef DEBUG
//    NSString *text = @"网络连接错误或url为空(测试期间打开的)";
//    if(url)
//    {
//        text = [NSString stringWithFormat:@"链接错误url：%@(测试期间打开的)",url];
//    }
//    JHTOAST(text);
//#endif
}

- (void)jh_show {
    self.hidden = NO;
}

@end


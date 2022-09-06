//
//  JHBaseWKWebView.h
//  TTjianbao
//
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ScriptMessageHandlerBlock)(WKScriptMessage *message);

/// WKWebView  基类 (没有绑定任何业务)
/// js 调用 webkit.messageHandlers.方法名.postMessage
@interface JHBaseWKWebView : WKWebView

@property (nonatomic, copy) void(^ jh_webViewDidFinishBlock)(JHBaseWKWebView * _Nullable webView);

@property (nonatomic, copy) void(^ jh_webViewDidFailBlock) (JHBaseWKWebView * _Nullable webView);

- (void)jh_loadWithHtml:(NSString *)string;

- (void)jh_loadWebURL:(NSString *)string;

/// 注册js 调用方法 block 方法回调
-(void)jh_registerMethodName:(NSString *)methodName completeBlock:(ScriptMessageHandlerBlock)completeBlock;

/// wk调用js
/// @param methodName 方法名字
/// @param param 方法参数 jsonString   ()空串 @""         没有（）传nil
- (void)jh_nativeCallJSMethod:(NSString * __nullable)methodName param:(NSString * __nullable)param;

/// wk调用js
/// @param methodName 方法名字
/// @param param 方法参数 jsonString array
- (void)jh_nativeCallJSMethod:(NSString * __nullable)methodName paramArray:(NSArray * __nullable)paramArray;

/// wk调用js
/// @param methodName 方法名字
/// @param prarm 方法参数 jsonString   ()空串 @""         没有（）传nil
/// @param completionHandler 调用js的回调
- (void)jh_nativeCallJSMethod:(NSString *__nullable)methodName param:(NSString *__nullable)param completionHandler:(void (^ _Nullable)(id _Nullable response, NSError * _Nullable error))completionHandler;


@end

NS_ASSUME_NONNULL_END


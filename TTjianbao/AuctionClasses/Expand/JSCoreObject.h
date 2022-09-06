//
//  JSCoreObject.h
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "UMengManager.h"

//一 提供方法
//基础方法：
//1.window.appAndroid.startNative(String componentName, String params);//启动本地页面：[componentName.页面全路径, params：json格式字符串，里面存放跳转参数]
//2.window.appAndroid.getToken();//获取本地用户token。
//3.window.appAndroid.closeWebPage();//关闭当前web页面[前端区分当前是弹窗或者页面]
//4.window.appAndroid.showToast(String msg);//前端吐司
//5.window.appAndroid.setWebTitle(String title);//webview设置前端web页面的title[一般前端会在加载完成后获取，如有需要h5通过此方法修改]
//
//高级方法：
///**
// * h5调用端内方法
// * @param action 行为
// *               @param tag h5调用标识，直接再传给h5即可，前端不处理
// *                          @param callback h5回调方法
// *                                          @param params 参数[json格式字符串]
// * */
//window.appAndroid.subClientMsg(String action, String tag, String callback, String params);
//
//action种类:
//WebAction_OpenWebView = "WebAction_OpenWebView";//打开窗口
//WebAction_ResizeWebView = "WebAction_ResizeWebView";//更新设置webview属性方法
//WebAction_Share = "WebAction_Share";//分享（分享成功回调）
//WebAction_MergeData = "WebAction_MergeData";//存储、更新数据(成功回调)
//WebAction_QueryData = "WebAction_QueryData";//查询数据(同步返回,没有为null)
//WebAction_DeleteData = "WebAction_DeleteData";//删除数据(成功回调)
//WebAction_PrivateSocketMsg = "WebAction_PrivateSocketMsg";//直播间活动socket消息,js调用Native方法
//WebAction_SocketMsg = "WebAction_SocketMsg";//转发消息到Socket
//WebAction_ScreenCapture = "WebAction_ScreenCapture";//截屏(异步成功回调)
//WebAction_GetRoomInfo = "WebAction_GetRoomInfo";//获取房间信息
//WebAction_JsReadyComplete = "WebAction_JsReadyComplete";//js加载完成
//WebAction_ReloadWebView = "WebAction_ReloadWebView";//重新加载
//
//详细说明：
//1.WebAction_OpenWebView:
//params实例：
//{
//    "url":"要打开的页面地址",
//    "target":"两种:[blank表示页面打开,self表示当前页面用弹窗打开]",
//    "windowSizetype":"两种:[1：全屏带操作栏类型 2：全屏不带操作栏类型]",
//    "width":"弹窗时表示弹窗宽度，页面可不带",
//    "height":"弹窗时表示弹窗高度，页面可不带",
//    "gravity":"弹窗位置,见说明"
//}
//说明：
//LeftTop = "leftTop";//顶部左对齐
//RightTop = "rightTop";// 顶部右对齐
//LeftBottom = "leftBottom";//底部左对齐
//RightBottom = "rightBottom";//底部右对齐
//TopCenter = "topCenter";//顶部居中对齐
//BottomCenter = "bottomCenter";//底部居中对齐
//Center = "center";//全页居中对齐
//
//2.WebAction_ResizeWebView：
//params实例：
//{
//    "width":"弹窗时表示弹窗宽度，页面可不带",
//    "height":"弹窗时表示弹窗高度，页面可不带",
//    "gravity":"弹窗位置,同WebAction_OpenWebView"
//}
//
//3.WebAction_Share
//params实例：
//{
//    "showType":"分享方式[1:展示分享弹窗 2：直接分享]",
//    "type":"分享类型[1:正常分享（标题、图片、连接）2：图片分享]",
//    "platform":"分享平台[1:微信好友 2：微信朋友圈 3：qq好友 4：qq空间 5：微博]",
//    "title":"分享的标题",
//    "digest":"分享的描述",
//    "url":"分享的落地页地址",
//    "pic":"分享图标"
//}
//
//4.WebAction_SocketMsg
//发送消息需要格式
//
//5.WebAction_MergeData：存储异步返回结果
//params实例：
//{
//    "key":"要存储的key",
//    "obj":"要存储的内容"
//}
//
//6.WebAction_QueryData:查询同步返回
//params实例：
//{
//    "key":"要查询的key"
//}
//
//7.WebAction_DeleteData：删除异步返回结果
//params实例：
//{
//    "key":"要删除的key"
//}
//
//8.WebAction_PrivateSocketMsg：params无要求，h5调用本方法后，客户端会把params转发到当前所有存储的webview(h5页面)中，由h5自行处理[用于各个h5间通信]。
//
//9.WebAction_JsReadyComplete
//在h5页面加载成功前，如果有消息累积，本地存储，待收到本方法后，再将数据转发到h5页面中。
//备注：
//同步返回无数据格式要求，异步返回采用：json格式，与http相同。
//异步返回实例{
//    "code":1000,
//    "message":"错误信息，code非1000时返回",
//    "result":"{json数据格式}"
//}
//


NS_ASSUME_NONNULL_BEGIN

//action
extern NSString *const WebAction_OpenWebView;
extern NSString *const WebAction_OpenWebViewFull;
extern NSString *const WebAction_ResizeWebView;
extern NSString *const WebAction_Share;
extern NSString *const WebAction_MergeData;
extern NSString *const WebAction_QueryData;
extern NSString *const WebAction_DeleteData;
extern NSString *const WebAction_PrivateSocketMsg;
extern NSString *const WebAction_SocketMsg;
extern NSString *const WebAction_ScreenCapture;
extern NSString *const WebAction_GetRoomInfo;
extern NSString *const WebAction_JsReadyComplete;
extern NSString *const WebAction_ReloadWebView;
extern NSString *const WebAction_SendOrder;
extern NSString *const WebAction_CommunityCommentDialog;

//location
//LeftTop = "leftTop";//顶部左对齐
//RightTop = "rightTop";// 顶部右对齐
//LeftBottom = "leftBottom";//底部左对齐
//RightBottom = "rightBottom";//底部右对齐
//TopCenter = "topCenter";//顶部居中对齐
//BottomCenter = "bottomCenter";//底部居中对齐
//Center = "center";//全页居中对齐

extern NSString *const LeftTop;
extern NSString *const RightTop;
extern NSString *const LeftBottom;
extern NSString *const RightBottom;
extern NSString *const TopCenter;
extern NSString *const BottomCenter;
extern NSString *const Center;


extern NSString *const NotificationNamePrivateSocketMsg;
extern NSString *const NotificationNameShareFinish;
extern NSString *const NotificationNameSubClientSocketMsg;
extern NSString *const NotificationNameRefreshWebView;
extern NSString *const NotificationNameLoadFamilyTree;
extern NSString *const NotificationNameLoadFamilyTreePage;

@protocol JSObjectProtocol <JSExport>
@optional

JSExportAs(getToken, - (NSString *)operateToken:(NSString *)string);

JSExportAs(startNative, - (void)operateStartNative:(NSString *)type param:(NSString *)param);
JSExportAs(closeWebImage, - (void)operateCloseWeb:(NSString *)type);
JSExportAs(closeWebPage, - (void)operateCloseWebPage:(NSString *)type);
JSExportAs(showToast, -(void)showToast:(NSString *)string);

JSExportAs(setWebTitle, -(void)setWebTitle:(NSString *)string);
JSExportAs(showAlert, -(void)showAlert:(NSString *)string);

JSExportAs(subClientMsg, - (NSString *)subClientMsgAction:(NSString *)action tag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params);

//JSExportAs(showLoginPage, -(void)showLoginPage:(NSString *)string);

JSExportAs(getUserInfo, -(NSString *)getUserInfo:(NSString *)string);

JSExportAs(showShareIcon, -(void)showShareButton:(NSString *)string);

JSExportAs(setWebHelpText, - (void)setWebHelpText:(NSString *)title toUrl:(NSString *)toUrl);

JSExportAs(copyString, - (void)copyString:(NSString *)content);
JSExportAs(hideClose, - (void)hideCloseButton:(NSString *)string);
JSExportAs(startKF, - (void)openChatService:(NSString *)string);

JSExportAs(startPicPreview, - (void)startPicPreview:(NSString *)sender);

///商家活动出去的点击领取红包
JSExportAs(webCallbackApp, - (void)webCallbackApp:(NSString *)sender);

///联系平台客服
- (void)showChatViewcontroller;

@end

@class OpenWebModel;
@class WebShareModel;
@interface appIOS : NSObject <JSObjectProtocol>

@property (nonatomic, copy) void (^operateStartNative)(NSString *type,NSString *param);
@property (nonatomic, copy) void (^operateGetToken)(void);

@property (nonatomic, copy) void (^operateCloseWeb)(void);

@property (nonatomic, copy) void (^operateOpenWeb)(OpenWebModel *model);

@property (nonatomic, copy) void (^operateResetSize)(OpenWebModel *model);

@property (nonatomic, copy) void (^operateShare)(WebShareModel *model);

@property (nonatomic, copy) void (^operateSetTitle)(NSString *title);

@property (nonatomic, copy) void (^operatePrivateMsg)(NSString *param);

@property (nonatomic, copy) void (^operateSocketMsg)(NSString *param);

@property (nonatomic, copy) void (^operateCallBack)(NSString *callname, NSString *tag, NSString *data);

@property (nonatomic, copy) NSString *(^operateGetRoomInfo)(NSString *callname, NSString *tag, NSString *param);

@property (nonatomic, copy) void (^operateShowShareBtn)(NSString *string);

@property (nonatomic, copy) void (^operateAction)(NSString *actionType, NSString *jsonString);

@property (nonatomic, copy) void (^operateShowRightHelpButton)(NSString *title, NSString *toUrl);

@property (nonatomic, copy) void (^operateHideClose)(NSString *string);

@property (nonatomic, copy) void (^operateShowImage)(NSInteger index, NSArray *thumArray, NSArray *imageArray);

@property (nonatomic, copy) void (^operateShowInputView)(NSString *callname);

@end


@interface OpenWebModel : NSObject
//"url":"要打开的页面地址",
//"target":"两种:[blank表示页面打开,self表示当前页面用弹窗打开]",
//"windowSizetype":"两种:[1：全屏带操作栏类型 2：全屏不带操作栏类型]",
//"width":"弹窗时表示弹窗宽度，页面可不带",
//"height":"弹窗时表示弹窗高度，页面可不带",
//"gravity":"弹窗位置,见说明"

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *target;

@property (nonatomic, assign) NSInteger windowSizetype;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSString *gravity;

@property (nonatomic, assign) BOOL fullScreen;

@end


@interface WebShareModel : NSObject
//"showType":"分享方式[1:展示分享弹窗 2：直接分享]",
//"type":"分享类型[1:正常分享（标题、图片、连接）2：图片分享]",
//"platform":"分享平台[1:微信好友 2：微信朋友圈 3：qq好友 4：qq空间 5：微博]",
//"title":"分享的标题",
//"digest":"分享的描述",
//"url":"分享的落地页地址",

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *digest;
@property (nonatomic, copy) NSString *pic;

@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) SharePlatformType platform;


@end

NS_ASSUME_NONNULL_END

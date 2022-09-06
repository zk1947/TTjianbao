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
#import "OrderMode.h"

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
extern NSString *const WebAction_PublishSheetView;
extern NSString *const WebAction_CommunityCommentDialog;
extern NSString *const WebAction_ServerStatistics;
extern NSString *const WebAction_GrowingStatistics;
///获取地址
extern NSString *const WebAction_SelectAddress;
/// 日历
extern NSString *const WebAction_AddCalendarEvent;
/// 隐藏导航栏
extern NSString *const WebAction_HideNavi;
/// 绑定微信
extern NSString *const WebAction_BindWX;
/// 打开app
extern NSString *const WebAction_OpenApp;

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
extern NSString *const NotificationNameWebViewHandler;
extern NSString *const NotificationNameLoadFamilyTree;
extern NSString *const NotificationNameLoadFamilyTreePage;


@interface OpenWebModel : NSObject

///要打开的页面地址",
@property (nonatomic, copy) NSString *url;

///两种:[blank表示页面打开,self表示当前页面用弹窗打开]",
@property (nonatomic, copy) NSString *target;

///两种:[1：全屏带操作栏类型 2：全屏不带操作栏类型]",
@property (nonatomic, assign) NSInteger windowSizetype;

///弹窗时表示弹窗宽度，页面可不带",
@property (nonatomic, assign) CGFloat width;

///弹窗时表示弹窗高度，页面可不带",
@property (nonatomic, assign) CGFloat height;

///弹窗位置,见说明"
@property (nonatomic, copy) NSString *gravity;

@property (nonatomic, assign) BOOL fullScreen;

@end


@interface WebShareModel : NSObject

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *title;

///分享的描述",
@property (nonatomic, copy) NSString *digest;

@property (nonatomic, copy) NSString *pic;

///分享方式[1:展示分享弹窗 2：直接分享]",
@property (nonatomic, assign) NSInteger showType;

///分享类型[1:正常分享（标题、图片、连接）2：图片分享]",
@property (nonatomic, assign) NSInteger type;

///分享平台[1:微信好友 2：微信朋友圈 3：qq好友 4：qq空间 5：微博]",
@property (nonatomic, assign) SharePlatformType platform;

@end

@interface JHChatInfoModel : OrderMode
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, assign) int64_t groupId;
@property (nonatomic, copy) NSString *showText;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END

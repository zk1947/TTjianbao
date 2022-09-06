//
//  JHWebView.m
//  TTjianbao
//
//  Created by apple on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHWebView.h"
#import <UIView+Toast.h>
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoKeyword.h"
#import "JSCoreObject.h"
#import "JHWebViewController.h"
#import "TTjianbaoHeader.h"
#import "JHPhotoBrowserManager.h"
#import "JHSQPublishSheetView.h"
#import "JHEasyInputTextView.h"
#import "JHBaseOperationView.h"
#import "AdressManagerViewController.h"
#import "PayMode.h"
#import "JHOrderViewModel.h"
#import "JHCalendarEvent.h"

@interface JHWebView ()
@end
@implementation JHWebView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"🔥");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateMsg:) name:NotificationNamePrivateSocketMsg object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(natActionSubClientSocketMsg:) name:NotificationNameSubClientSocketMsg object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:NotificationNameRefreshWebView object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadFamilyTree:) name:NotificationNameLoadFamilyTree object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareFinish:) name:NotificationNameShareFinish object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(webViewHandler) name:NotificationNameWebViewHandler object:nil];
        [self setUserAgent];
        [self addRegisterMethod];
    }
    return self;
}
// H5回调刷新
- (void)webViewHandler {
    [self jh_nativeCallJSMethod:@"refresh" param:@""];
}

- (void)addRegisterMethod
{
    @weakify(self);
    [self jh_registerMethodName:@"startNative" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            [self startNativeWithVC:array[0] param:array[1]];
        }
    }];
    
    [self jh_registerMethodName:@"showToast" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0 && IS_STRING(array[0]))
        {
            [[UIApplication sharedApplication].keyWindow makeToast:array[0] duration:1.0 position:CSToastPositionCenter];
        }
        
    }];
    
    [self jh_registerMethodName:@"getToken" completeBlock:^(WKScriptMessage * _Nonnull message) {
        
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            @strongify(self);
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
            [self jh_nativeCallJSMethod:array[0] param:token ? : @""];
        }
    }];
    
    ///重复closeWebImage or closeWebPage
    [self jh_registerMethodName:@"closeWebPage" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        if(self.closeViewOrVC)
        {
            self.closeViewOrVC();
        }
        else
        {
            [self removeFromSuperview];
        }
    }];
    
    ///设置标题
    [self jh_registerMethodName:@"setWebTitle" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0 && self.titleChangeBlock)
        {
            self.titleChangeBlock(array[0]);
        }
    }];
    
    ///弹框
    [self jh_registerMethodName:@"showAlert" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        if([message.body isKindOfClass:[NSString class]])
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:array[0] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
            [JHRootController.homeTabController presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    [self jh_registerMethodName:@"getUserInfo" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSString *str = [[UserInfoRequestManager sharedInstance].user mj_JSONString];
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            [self jh_nativeCallJSMethod:array[0] param:str ? : @""];
        }
    }];
    
    ///分享按钮是否显示
    [self jh_registerMethodName:@"showShareIcon" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        if(self.showShareButtonBlock)
        {
            self.showShareButtonBlock();
        }
    }];
    
    ///复制到剪切板
    [self jh_registerMethodName:@"copyString" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = array[0];
        }
    }];
    
    [self jh_registerMethodName:@"startKF" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            JHChatInfoModel *model = [JHChatInfoModel mj_objectWithKeyValues:[array[0] mj_JSONObject]];
            JHQYStaffInfo *info = [[JHQYStaffInfo alloc] init];
            info.groupId = model.groupId;
            info.shopId = model.shopId;
            info.text = model.showText;
            info.title = model.title;
            
            [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:JHRootController staffInfo:info orderModel:model];
        }
    }];
    
    [self jh_registerMethodName:@"startPicPreview" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            [self showImageWithString:array[0]];
        }
    }];
    
    ///商家活动出去的点击领取红包
    [self jh_registerMethodName:@"webCallbackApp" completeBlock:^(WKScriptMessage * _Nonnull message) {
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count > 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLiveWebRedPacket object:array[0]];
        }
    }];
    
    [self jh_registerMethodName:@"setWebHelpText" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if(self.showHelpButtonBlock && IS_ARRAY(array) && array.count >= 2)
        {
            self.showHelpButtonBlock(array[0],array[1]);
        }
    }];
    
    [self jh_registerMethodName:@"subClientMsg" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if(IS_ARRAY(array) && array.count >= 4)
        {
            [self subClientMsgAction:array[0] tag:array[1] callback:array[2] params:array[3]];
        }
    }];
    
    ///联系客服
    [self jh_registerMethodName:@"showChatViewcontroller" completeBlock:^(WKScriptMessage * _Nonnull message) {
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
    }];
    /// 支付
    [self jh_registerMethodName:@"startPayActivity" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if (!IS_ARRAY(array) || array.count <= 0) return;
        [self actionPushPayWithPar:array[0]];
    }];
    
    /// 新支付
    [self jh_registerMethodName:@"startNewPayActivity" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if (!IS_ARRAY(array) || array.count <= 0) return;
        [self actionPushShopPayWithPar:array[0]];
    }];
    
    /// 退出登录
    [self jh_registerMethodName:@"iOSLogout" completeBlock:^(WKScriptMessage * _Nonnull message) {
        @strongify(self);
        NSArray *array = message.body;
        if (!IS_ARRAY(array) || array.count <= 0) return;
        [self logOut];
    }];
}

- (void)logOut {
    [JHRootController logoutAccountData];
}

- (void)getAppAddressMethodWithMethodName:(NSString *)methodName
{
    AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
    @weakify(self);
    vc.selectedBlock = ^(AdressMode *model) {
        @strongify(self);
        [self jh_nativeCallJSMethod:methodName param:@{@"addressResultJson" : model.mj_JSONString}.mj_JSONString];
    };
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)showImageWithString:(NSString *)sender
{
    NSDictionary *param = sender.mj_JSONObject;
    NSInteger index = [[param valueForKey:@"current"] intValue];
    NSString *thumArrayStr = [param valueForKey:@"thumb_list"];
    NSString *imageArrayStr = [param valueForKey:@"origin_list"];
    
    NSArray *thumArray = [thumArrayStr componentsSeparatedByString:@","];
    NSArray *imageArray = [imageArrayStr componentsSeparatedByString:@","];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < thumArray.count; i ++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        [arr addObject:imgView];
    }
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:thumArray origImages:imageArray sources:arr.copy currentIndex:index canPreviewOrigImage:YES showStyle:GKPhotoBrowserShowStyleNone];
}

- (void)setUserAgent {
    
    NSMutableDictionary *header = [HttpRequestTool sessionManager].requestSerializer.HTTPRequestHeaders.mutableCopy;
    header[@"User-Agent"] = nil;
    header[@"Accept-Language"] = nil;
    
    /// wkwebview的userAgent
    [self evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        if ([userAgent isKindOfClass:[NSString class]]) {
            NSString *systemUserAgent = @"";
            if (![userAgent containsString:@"==JianBao=="])
            {
                NSString *willAppendedString = [userAgent stringByAppendingFormat:@"%@", [NSString stringWithFormat:@"==JianBao==%@",[header mj_JSONString]]];
                NSString *newUserAgent = [systemUserAgent stringByAppendingString:willAppendedString];
                NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:newUserAgent, @"UserAgent", nil];
                [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self setCustomUserAgent:newUserAgent];
            }
        }
    }];
}

- (void)setModel:(OpenWebModel *)model {
    _model = model;
    if(_model.url)
    {
        [self jh_loadWebURL:_model.url];
    }
    
    [self setWebLocal];
}

- (void)setWebLocal {
    UIView *window = [self isAddView:self.model]?self.superview: self.superview.viewController.view;
    self.width = self.model.width?:window.width;
    self.height = self.model.height?:window.height;
    
    if ([self.model.gravity isEqualToString:LeftTop]) {
        self.top = 0;
        self.left = 0;
        
    } else if ([self.model.gravity isEqualToString:LeftBottom]) {
        self.bottom = window.bottom;
        self.left = 0;
        
    } else if ([self.model.gravity isEqualToString:RightTop]) {
        self.top = 0;
        self.right = window.right;

    }  else if ([self.model.gravity isEqualToString:RightBottom]) {
        self.bottom = window.bottom;
        self.right = window.right;

    }  else if ([self.model.gravity isEqualToString:TopCenter]) {
        self.center = window.center;
        self.top = 0;

    }  else if ([self.model.gravity isEqualToString:BottomCenter]) {
        self.center = window.center;
        self.bottom = window.bottom;
    }  else if ([self.model.gravity isEqualToString:Center]) {
        self.center = window.center;
    }
}

- (void)resetWebLocal
{
    UIView *window = [self isAddView:self.model]?self.superview: self.superview.viewController.view;
    self.width = self.model.width?:window.width;
    self.height = self.model.height?:window.height;
    
    if ([self.model.gravity isEqualToString:LeftTop]) {
        self.top = self.top;
        self.left = self.left;
        
    } else if ([self.model.gravity isEqualToString:LeftBottom]) {
        self.bottom = self.bottom;
        self.left = self.left;
        
    } else if ([self.model.gravity isEqualToString:RightTop]) {
        self.top = self.top;
        self.right = self.right;
        
    }  else if ([self.model.gravity isEqualToString:RightBottom]) {
        self.bottom = self.bottom;
        self.right = self.right;
        
    }  else if ([self.model.gravity isEqualToString:TopCenter]) {
        self.center = window.center;
        self.top = self.top;
        
    }  else if ([self.model.gravity isEqualToString:BottomCenter]) {
        self.center = window.center;
        self.bottom = self.bottom;
    }  else if ([self.model.gravity isEqualToString:Center]) {
        self.center = window.center;
    }
}

#pragma mark - js 交互方法
- (void)resetSizeWeb:(OpenWebModel *)model {
    if (!self.model) {
        self.model = [[OpenWebModel alloc] init];
    }
    self.model.height = model.height;
    self.model.width = model.width;
    self.model.gravity = model.gravity;
    [self resetWebLocal];
    if (self.resetSizeWebView) {
        self.resetSizeWebView(model);
    }
}
- (void)openNewWeb:(OpenWebModel *)model {
    if ([model.target isEqualToString:@"blank"]) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.isHiddenNav = (model.windowSizetype == 2 || model.fullScreen);
        vc.urlString = model.url;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.target isEqualToString:@"self"]) {
        JHWebView *web = [[JHWebView alloc] init];
        web.operateCloseComplet = self.operateCloseComplet;
        web.operateActionScreenCapture = self.operateActionScreenCapture;
        web.operateGetRoomInfo = self.operateGetRoomInfo;
        web.operateActionAuctionSendOrder = web.operateActionAuctionSendOrder;
        if ([self isAddView:model]) {
            [self.superview addSubview:web];
        }else {
            [self.superview.viewController.view addSubview:web];
        }

        web.model = model;
    }
}

- (void)privateMsg:(NSNotification *)noti {
    NSString *string = noti.object;
    [self jh_nativeCallJSMethod:@"natAction_SubPrivateSocketMsg" param:string];
}


- (void)natActionSubPublicSocketMsg:(NSString *)string {
    [self jh_nativeCallJSMethod:@"natAction_SubPublicSocketMsg" param:string];
}

- (void)natActionSubClientSocketMsg:(NSNotification *)noti {
    NSString *string = noti.object;
    [self jh_nativeCallJSMethod:@"natAction_SubClientSocketMsg" param:string];
}

- (void)loadFamilyTree:(NSNotification *)noti {
    NSString *string = noti.object;
    [self jh_nativeCallJSMethod:@"setFamilyTreeData" param:string];
}

- (BOOL)isAddView:(OpenWebModel *)model {
    if ([model.url containsString:@"auctionCreat"]) {
        return YES;
    }
    return NO;
}

- (void)shareFinish:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    RequestModel *model = [[RequestModel alloc] init];
    model.code = 1000;
    model.message = @"分享完成";
    
    [self jh_nativeCallJSMethod:dic[@"callback"] paramArray:@[dic[@"tag"],[model mj_JSONString]]];
}
- (void)startNativeWithVC:(NSString *)vc param:(NSString *)param {
    [JHRootController webToNativeVCName:vc param:param];
    
    // 埋点
    if (![self.from isEqualToString:@"直播间页"]) return;
    
    NSString *name = vc;
    
    if ([name isEqualToString:@"WebDialog"] || [name isEqualToString:@"JHWebViewController"]) {
        NSDictionary *dic = [param mj_JSONObject];
        name = dic[@"urlString"];
    }
    
    NSDictionary *dict = @{
        @"page_position" : self.from,
        @"spm_type" : @"浮窗",
        @"content_url" : name,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dict type:JHStatisticsTypeSensors];
}
#pragma mark - JS 交互事件
- (void)subClientMsgAction:(NSString *)action tag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    if ([action isEqualToString:WebAction_OpenWebView]) {
        [self actionOpenWebViewWithFullScreen:NO callback:callback params:params];
    }
    else if ([action isEqualToString:WebAction_OpenWebViewFull]) {
        [self actionOpenWebViewWithFullScreen:YES callback:callback params:params];
    }
    else if ([action isEqualToString:WebAction_ResizeWebView]) {
        [self actionResizeWebViewTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_Share]) {
        [self actionShareTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_PrivateSocketMsg]) {
        [self actionPrivateSocketMsgTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_SocketMsg]) {
        [self actionSocketMsgTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_JsReadyComplete]) {
        
    }else if ([action isEqualToString:WebAction_ReloadWebView]) {
        
    }else if ([action isEqualToString:WebAction_MergeData]) {
        [self actionSaveDataTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_DeleteData]) {
        [self actionDeleteDataTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_ScreenCapture]) {
        if (self.operateActionScreenCapture)
        {
            self.operateActionScreenCapture(action, params);
        }
    }else if ([action isEqualToString:WebAction_SendOrder]) {
        if (self.operateActionAuctionSendOrder)
        {
            self.operateActionAuctionSendOrder(action, params);
        }
    }
    else if ([action isEqualToString:WebAction_PublishSheetView]) {
        [JHSQPublishSheetView showPublishSheetViewWithType:1 topic:nil plate:nil addSuperView:JHRootController.view];
    }
    else if([action isEqualToString:WebAction_CommunityCommentDialog])
    {
        [self showInputTextWithCallName:callback];
    }
    else if([action isEqualToString:WebAction_ServerStatistics])
    {
        NSDictionary *dic = params.mj_JSONObject;
        NSString *eType = [dic valueForKey:@"e_type"];
        NSDictionary *p = [dic valueForKey:@"params"];
        if(eType && p)
        {
            [[JHBuryPointOperator shareInstance] buryWithEtype:eType param:p.mj_JSONObject];
        }
    }
    else if([action isEqualToString:WebAction_GrowingStatistics])
    {
        NSDictionary *dic = params.mj_JSONObject;
        NSString *eventId = [dic valueForKey:@"e_type"];
        NSDictionary *p = [dic valueForKey:@"params"];
        [JHGrowingIO trackEventId:eventId variables:p];
    }
    else if ([action isEqualToString:WebAction_GetRoomInfo]) {
        NSString *string = [self actionGetRoomInfoTag:tag callback:callback params:params];
        [self jh_nativeCallJSMethod:callback param:string];
    }
    else if ([action isEqualToString:WebAction_SelectAddress]) {
        [self getAppAddressMethodWithMethodName:callback];
    }
    else if ([action isEqualToString:WebAction_QueryData])
    {
        NSString  *string = [self actionQueryDataTag:tag callback:callback params:params];
        [self jh_nativeCallJSMethod:callback param:string];
    }
    // 添加日历提醒
    else if([action isEqualToString:WebAction_AddCalendarEvent])
    {
        [self actionAddCalendarEvent:params];
    }
    // 隐藏导航栏
    else if ([action isEqualToString:WebAction_HideNavi])
    {
        if (self.hidenNavi) {
            self.hidenNavi(true);
        }
    }
    // 打开app
    else if ([action isEqualToString:WebAction_OpenApp]) {
        [self openApp:params];
    }
    // 绑定微信
    else if ([action isEqualToString:WebAction_BindWX]) {
        [self actionBindWX:params];
    }
}

#pragma action
- (void)openApp : (NSString *)params {
    NSDictionary *dic = [params mj_JSONObject];
    NSString *urlSchemes = dic[@"schemeUrl"];
    if (urlSchemes.length <= 0) return;
    NSURL *url = [NSURL URLWithString:urlSchemes];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        NSLog(@"%@ 有效" ,urlSchemes);
        [[UIApplication sharedApplication] openURL:url];
    }else {
        NSLog(@"%@ 无效" ,urlSchemes);
    }
}
// 添加日历提醒事件
- (void)actionAddCalendarEvent:(NSString *)params {
    NSArray *jsonArray = [params mj_JSONObject];
    NSArray *list = [JHCalendarEventModel mj_objectArrayWithKeyValuesArray:jsonArray];
    if (list.count <= 0) return;
    @weakify(self)
    [JHCalendarEvent addEventWithModels:list successHandler:^(BOOL success) {
        @strongify(self)
        // 设置日历成功回调
        [self jh_nativeCallJSMethod:@"setCalendarSuccess" param:[NSString stringWithFormat:@"%@", @(success)]];
    }];
}
// 绑定微信
- (void)actionBindWX : (NSString *)params {
    NSDictionary *dic = [params mj_JSONObject];
    NSString *type = dic[@"type"];
    NSString *source = type ?: @"3";
    @weakify(self)
    [JHRootController bindWxWithWebSource:source block:^{
        @strongify(self)
        [self reload];
    }];
}
- (void)actionOpenWebViewWithFullScreen:(BOOL)fullScreen callback:(NSString *)callback params:(NSString *)params {
    
    OpenWebModel *model = [OpenWebModel mj_objectWithKeyValues:[params mj_JSONObject]];
    model.fullScreen = fullScreen;
    if ([model.target isEqualToString:@"blank"]) {
        JHWebViewController *vc = [[JHWebViewController alloc] init];
        vc.isHiddenNav = (model.windowSizetype == 2 || model.fullScreen);
        vc.urlString = model.url;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }else if ([model.target isEqualToString:@"self"]) {
        JHWebView *web = [[JHWebView alloc] init];
//        [[JHRouterManager jh_getViewController].view addSubview:web];
        web.operateCloseComplet = self.operateCloseComplet;
        web.operateActionScreenCapture = self.operateActionScreenCapture;
        web.operateGetRoomInfo = self.operateGetRoomInfo;
        web.operateActionAuctionSendOrder = web.operateActionAuctionSendOrder;
        web.model = model;

        if ([self isAddView:model]) {
            [self.superview addSubview:web];
        }else {
            [self.superview.viewController.view addSubview:web];
        }
    }
}

- (void)actionResizeWebViewTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    OpenWebModel *model = [OpenWebModel mj_objectWithKeyValues:[params mj_JSONObject]];
    [self resetSizeWeb:model];
}

///showType 1分享弹窗 2直接分享
///根据type判断 type: 1标题图片文字  2图片分享
- (void)actionShareTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    params = [params stringByReplacingOccurrencesOfString:@"\n\r" withString:@""];
    params = [params jsonValueDecoded];
    NSDictionary *dic = @{@"tag":tag,@"callback":callback};
    WebShareModel *model = [WebShareModel mj_objectWithKeyValues:[params mj_JSONObject]];
    if (model.showType == 1) {
        if (model.type == 1) {
//            [[UMengManager shareInstance] showShareWithTarget:nil
//                                                        title:model.title
//                                                         text:model.digest
//                                                     thumbUrl:model.pic
//                                                       webURL:model.url
//                                                         type:ShareObjectTypeWebShare
//                                                       object:dic];
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            info.desc = model.digest;
            info.img = model.pic;
            info.shareType = ShareObjectTypeWebShare;
            info.url = model.url;
            [JHBaseOperationView showShareView:info objectFlag:dic]; //TODO:Umeng share
            
        }else if (model.type == 2) {
//            [[UMengManager shareInstance] showShareImageWithTarget:nil title:model.title text:model.digest thumbUrl:model.pic type:ShareObjectTypeWebShare object:dic];
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            info.desc = model.digest;
            info.img = model.pic;
            info.shareType = ShareObjectTypeWebShare;
            [JHBaseOperationView showShareImageView:info objectFlag:dic]; //TODO:Umeng share
        }
    }else if (model.showType == 2){
        UMSocialPlatformType type = UMSocialPlatformType_WechatSession;
        switch (model.platform) {
            case SharePlatformTypeWeiXin:
                type = UMSocialPlatformType_WechatSession;
                break;
            case SharePlatformTypeWeiCircle:
                type = UMSocialPlatformType_WechatTimeLine;
                break;
            case SharePlatformTypeQQ:
                type = UMSocialPlatformType_QQ;
                break;
                
            default:
                break;
        }
        //转成operationType类型
        JHOperationType operationType = JHOperationTypeNone;
        if (type == UMSocialPlatformType_WechatSession) {
            operationType = JHOperationTypeWechatSession;
        }
        else if(type == UMSocialPlatformType_WechatTimeLine) {
            operationType = JHOperationTypeWechatTimeLine;
        }
        ///根据type判断 type: 1标题图片文字  2图片分享
        if (model.type == 1) {
//            [[UMengManager shareInstance] shareWebPageToPlatformType:type title:model.title text:model.digest thumbUrl:model.pic webURL:model.url type:ShareObjectTypeWebShare pageFrom:JHPageFromTypeUnKnown object:dic];
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            info.desc = model.digest;
            info.img = model.pic;
            info.shareType = ShareObjectTypeWebShare;
            info.pageFrom = JHPageFromTypeUnKnown;
            info.url = model.url;
            
            [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:dic];//TODO:Umeng share
        }else if (model.type == 2) {
//            [[UMengManager shareInstance] shareImageToPlatformType:type title:model.title text:model.digest thumbUrl:model.pic type:ShareObjectTypeWebShare object:dic];
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            info.desc = model.digest;
            info.img = model.pic;
            info.shareType = ShareObjectTypeWebShare;
            [JHBaseOperationAction toShareImage:operationType shareInfo:info];//TODO:Umeng share
        }else if (model.type == 3) {
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            [JHBaseOperationAction toShareText:operationType shareInfo:info];
        }
    }
}

- (NSString *)actionGetRoomInfoTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    if (self.operateGetRoomInfo) {
        return self.operateGetRoomInfo(callback, tag, params);
    }
    return @"";
    
}

- (void)actionPrivateSocketMsgTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePrivateSocketMsg object:params];
}

- (void)actionSocketMsgTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    ///没找到实现
}

- (void)actionSaveDataTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    NSDictionary *dic = [params mj_JSONObject];
    //    for (NSDictionary *dic in array) {
    if (!dic) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"存储格式错误"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"obj"] forKey:dic[@"key"]];
    //    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    RequestModel *model = [[RequestModel alloc] init];
    model.code = 1000;
    model.message = @"存储成功";
    [self jh_nativeCallJSMethod:callback paramArray:@[tag,[model mj_JSONString]]];
}

- (NSString *)actionQueryDataTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    NSDictionary *dic = [params mj_JSONObject];
    if (!dic) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"格式错误"];
        return @"";
    }
    
    if (dic[@"key"]) {
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:dic[@"key"]]);
        NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:dic[@"key"]];
        
        if (!string) {
            return @"";
        }
        if ([string isKindOfClass:[NSString class]]) {
            return string;
        }else {
            NSString *str = [string mj_JSONString];
            return str;
        }
    }
    return @"";
}

- (void)actionDeleteDataTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    NSDictionary *dic = [params mj_JSONObject];
    if (!dic) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"格式错误"];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:dic[@"key"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    RequestModel *model = [[RequestModel alloc] init];
    model.code = 1000;
    model.message = @"删除成功";
    [self jh_nativeCallJSMethod:callback paramArray:@[tag,[model mj_JSONString]]];
}
-(void)showInputTextWithCallName:(NSString *)callName {
    if(IS_LOGIN){
        UIViewController *vc = [JHRouterManager jh_getViewController];
        JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
        easyView.showLimitNum = YES;
        [vc.view addSubview:easyView];
        [easyView show];
        @weakify(self);
        @weakify(easyView);
        [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
            @strongify(self);
            @strongify(easyView);
            if(callName && callName.length) {
                [self jh_nativeCallJSMethod:@"comment" param:inputInfos.mj_JSONString];
            }
            [easyView endEditing:YES];
            [easyView removeFromSuperview];
        }];
    }
}


#pragma mark - 支付跳转
- (void)actionPushPayWithPar : (NSString *)params {
    NSDictionary *par = [params mj_JSONObject];
    NSString *money = [NSString stringWithFormat:@"%@",par[@"price"]];
    NSString *orderId = [NSString stringWithFormat:@"%@", par[@"orderId"]];
    int payId = [par[@"payType"] intValue];
    NSString *method = par[@"payCallBack"];
    switch (payId) {
        case JHPayTypeWxPay:
            [self wxPrepayWithPayId:payId money:money orderId:orderId method:method];
            break;
        case JHPayTypeAliPay:
            [self aliPrepayWithPayId:payId money:money orderId:orderId method:method];
            break;
        default:
            break;
    }
}

- (void)wxPrepayWithPayId : (int)payId money : (NSString *)money orderId : (NSString *)orderId method : (NSString *)method{
    JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
    reqMode.payId = [NSString stringWithFormat:@"%d", payId];
    reqMode.payMoney = money;
    reqMode.orderId = orderId;
    
   [PayMode WXOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
     [SVProgressHUD dismiss];
     if (!error) {
         WXPayDataMode *wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data];
         [self WXPay:wxPayMode method:method];
     }
 }];
 
 [SVProgressHUD show];
}
- (void)aliPrepayWithPayId : (int)payId money : (NSString *)money orderId : (NSString *)orderId method : (NSString *)method{
    JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
    reqMode.payId = [NSString stringWithFormat:@"%d", payId];
    reqMode.payMoney = money;
    reqMode.orderId = orderId;
    @weakify(self)
    [PayMode ALiOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if (!error) {
            ALiPayDataMode *aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data];
            [self AliPay:aLiPayMode.token payModel:aLiPayMode method:method];
        }
    }];
    
    [SVProgressHUD show];
}

#pragma mark - 商户资金支付跳转
- (void)actionPushShopPayWithPar : (NSString *)params {
    NSDictionary *par = [params mj_JSONObject];
    NSString *money = [NSString stringWithFormat:@"%@",par[@"price"]];
    NSString *shopRecordId = [NSString stringWithFormat:@"%@", par[@"shopRecordId"]];
    int payId = [par[@"payType"] intValue];
    NSString *method = par[@"payCallBack"];
    switch (payId) {
        case JHPayTypeWxPay:
            [self wxShopPrepayWithPayId:payId money:money shopRecordId:shopRecordId method:method];
            break;
        case JHPayTypeAliPay:
            [self aliShopPrepayWithPayId:payId money:money shopRecordId:shopRecordId method:method];
            break;
        default:
            break;
    }
}
- (void)wxShopPrepayWithPayId : (int)payId money : (NSString *)money shopRecordId : (NSString *)shopRecordId method : (NSString *)method{
    JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
    reqMode.payId = [NSString stringWithFormat:@"%d", payId];
    reqMode.payMoney = money;
    reqMode.shopRecordId = shopRecordId;
    
   [PayMode WXShopPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
     [SVProgressHUD dismiss];
     if (!error) {
         WXPayDataMode *wxPayMode=[WXPayDataMode mj_objectWithKeyValues: respondObject.data];
         [self WXPay:wxPayMode method:method];
     }
 }];
 
 [SVProgressHUD show];
}
- (void)aliShopPrepayWithPayId : (int)payId money : (NSString *)money shopRecordId : (NSString *)shopRecordId method : (NSString *)method{
    JHPrepayReqModel * reqMode=[[JHPrepayReqModel alloc]init];
    reqMode.payId = [NSString stringWithFormat:@"%d", payId];
    reqMode.payMoney = money;
    reqMode.shopRecordId = shopRecordId;
    @weakify(self)
    [PayMode ALiShopPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if (!error) {
            ALiPayDataMode *aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: respondObject.data];
            [self AliPay:aLiPayMode.token payModel:aLiPayMode method:method];
        }
    }];
    
    [SVProgressHUD show];
}



-(void)WXPay:(WXPayDataMode*)pay method : (NSString *)method{
    [PayMode WXPay:pay];
    [self payResultCallWebWithNo:pay.out_trade_no method: method];
}

-(void)AliPay:(NSString*)orderString payModel : (ALiPayDataMode*)payModel method : (NSString *)method{
//    @weakify(self)
    [PayMode AliPay:orderString callback:^(id obj) {

    } ];
    [self payResultCallWebWithNo:payModel.outTradeNo method:method];
}
- (void)payResultCallWebWithNo : (NSString *)outTradeNo method : (NSString *)method {
    NSDictionary *dic = @{@"outTradeNo" : outTradeNo};
    NSString *param = [dic mj_JSONString];
    [self jh_nativeCallJSMethod:method param:param];
}
@end

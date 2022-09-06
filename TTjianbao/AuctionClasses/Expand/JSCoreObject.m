//
//  JSCoreObject.m
//  TTjianbao
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JSCoreObject.h"
#import "JHWebViewController.h"

#import "TTjianbaoBussiness.h"
#import "NSString+Common.h"
#import "JHSQPublishSheetView.h"

NSString *const WebAction_CommunityCommentDialog = @"WebAction_CommunityCommentDialog";
NSString *const WebAction_OpenWebView = @"WebAction_OpenWebView";
NSString *const WebAction_OpenWebViewFull = @"WebAction_OpenWebViewFull";
NSString *const WebAction_ResizeWebView = @"WebAction_ResizeWebView";
NSString *const WebAction_Share = @"WebAction_Share";
NSString *const WebAction_MergeData = @"WebAction_MergeData";
NSString *const WebAction_QueryData = @"WebAction_QueryData";
NSString *const WebAction_DeleteData = @"WebAction_DeleteData";
NSString *const WebAction_PrivateSocketMsg = @"WebAction_PrivateSocketMsg";

NSString *const WebAction_SocketMsg = @"WebAction_SocketMsg";
NSString *const WebAction_ScreenCapture = @"WebAction_ScreenCapture";
NSString *const WebAction_GetRoomInfo = @"WebAction_GetRoomInfo";
NSString *const WebAction_JsReadyComplete = @"WebAction_JsReadyComplete";
NSString *const WebAction_ReloadWebView = @"WebAction_ReloadWebView";
NSString *const WebAction_SendOrder = @"WebAction_SendOrder";
NSString *const WebAction_PublishSheetView = @"WebAction_CommunityPublishDialog";
NSString *const WebAction_ServerStatistics = @"WebAction_ServerStatistics";
NSString *const WebAction_GrowingStatistics = @"WebAction_GrowingStatistics";


NSString *const LeftTop = @"LeftTop";//顶部左对齐
NSString *const RightTop = @"RightTop";// 顶部右对齐
NSString *const LeftBottom = @"LeftBottom";//底部左对齐
NSString *const RightBottom = @"RightBottom";//底部右对齐
NSString *const TopCenter = @"TopCenter";//顶部居中对齐
NSString *const BottomCenter = @"BottomCenter";//底部居中对齐
NSString *const Center = @"Center";//全页居中对齐


NSString *const NotificationNamePrivateSocketMsg = @"NotificationNamePrivateSocketMsg";
NSString *const NotificationNameShareFinish = @"NotificationNameShareFinish";
NSString *const NotificationNameSubClientSocketMsg = @"NotificationNameSubClientSocketMsg";
NSString *const NotificationNameRefreshWebView = @"NotificationNameRefreshWebView";
NSString *const NotificationNameLoadFamilyTree = @"NotificationNameLoadFamilyTree";
NSString *const NotificationNameLoadFamilyTreePage = @"NotificationNameLoadFamilyTreePage";


@implementation WebShareModel

@end

@implementation OpenWebModel

@end

@interface JHChatInfoModel : OrderMode
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, assign) int64_t groupId;
@property (nonatomic, copy) NSString *showText;
@property (nonatomic, copy) NSString *title;

@end

@implementation JHChatInfoModel

@end

@implementation appIOS

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareFinish:) name:NotificationNameShareFinish object:nil];
        
    }
    return self;
}

- (nonnull NSString *)operateToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.operateGetToken) {
            self.operateGetToken();
        }
    });
    return token;
}

//
- (nonnull NSString *)operateToken:(nonnull NSString *)string {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:IDTOKEN];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.operateGetToken) {
            self.operateGetToken();
        }
    });
    
    if (!token) {
        token = @"";
    }
    return token;
    
}

///商家活动出去的点击领取红包
- (void)webCallbackApp:(NSString *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLiveWebRedPacket object:sender];
}


- (void)operateStartNative:(nonnull NSString *)type param:(nonnull NSString *)param {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [JHRootController webToNativeVCName:type param:param];
    });
    
}


- (void)operateCloseWeb:(NSString *)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.operateCloseWeb) {
            self.operateCloseWeb();
        }
    });
}

- (void)operateCloseWebPage:(NSString *)type {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.operateCloseWeb) {
            self.operateCloseWeb();
        }
    });
    
}

- (void)showToast:(NSString *)string {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow makeToast:string duration:1.0 position:CSToastPositionCenter];
        
    });
    
}

- (void)setWebTitle:(nonnull NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.operateSetTitle) {
            self.operateSetTitle(string);
        }
        
    });
    
}

- (void)showAlert:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
        [JHRootController.homeTabController presentViewController:alert animated:YES completion:nil];
    });
}

- (NSString *)subClientMsgAction:(NSString *)action tag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    dispatch_async(dispatch_get_main_queue(), ^{
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
            if (self.operateAction) {
                self.operateAction(WebAction_ScreenCapture,params);
            }
        }else if ([action isEqualToString:WebAction_SendOrder]) {
            if (self.operateAction) {
                self.operateAction(WebAction_SendOrder,params);
            }
        }
        else if ([action isEqualToString:WebAction_PublishSheetView]) {
            [JHSQPublishSheetView showSheetViewAppraise:NO type:2];
        }
        else if([action isEqualToString:WebAction_CommunityCommentDialog])
        {
            if(_operateShowInputView)
            {
                _operateShowInputView(callback);
            }
        }
        else if([action isEqualToString:WebAction_ServerStatistics])
        {
            NSDictionary *dic = params.mj_JSONObject;
            NSString *eType = [dic valueForKey:@"e_type"];
            NSDictionary *p = [dic valueForKey:@"params"];
            if(eType && p)
            {
                [[JHBuryPointOperator shareInstance] buryH5WithEtype:eType param:p.mj_JSONObject];
            }
        }
        else if([action isEqualToString:WebAction_GrowingStatistics])
        {
            NSDictionary *dic = params.mj_JSONObject;
            NSString *eventId = [dic valueForKey:@"e_type"];
            NSDictionary *p = [dic valueForKey:@"params"];
            [JHGrowingIO trackEventId:eventId variables:p];
        }
    });
    
    NSString *string = @"";
    
    if ([action isEqualToString:WebAction_GetRoomInfo]) {
        string = [self actionGetRoomInfoTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_QueryData]) {
        string = [self actionQueryDataTag:tag callback:callback params:params];
    }
    
    return string;
}

#pragma action

- (void)actionOpenWebViewWithFullScreen:(BOOL)fullScreen callback:(NSString *)callback params:(NSString *)params {
    
    OpenWebModel *model = [OpenWebModel mj_objectWithKeyValues:[params mj_JSONObject]];
    model.fullScreen = fullScreen;
    if (self.operateOpenWeb) {
        self.operateOpenWeb(model);
    }
}

- (void)actionResizeWebViewTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    OpenWebModel *model = [OpenWebModel mj_objectWithKeyValues:[params mj_JSONObject]];
    
    if (model && self.operateResetSize) {
        self.operateResetSize(model);
    }
    
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
            [[UMengManager shareInstance] showShareWithTarget:nil
                                                        title:model.title
                                                         text:model.digest
                                                     thumbUrl:model.pic
                                                       webURL:model.url
                                                         type:ShareObjectTypeWebShare
                                                       object:dic];
            
        }else if (model.type == 2) {
            [[UMengManager shareInstance] showShareImageWithTarget:nil title:model.title text:model.digest thumbUrl:model.pic type:ShareObjectTypeWebShare object:dic];
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
        
        ///根据type判断 type: 1标题图片文字  2图片分享
        if (model.type == 1) {
            [[UMengManager shareInstance] shareWebPageToPlatformType:type title:model.title text:model.digest thumbUrl:model.pic webURL:model.url type:ShareObjectTypeWebShare object:dic];
        }else if (model.type == 2) {
            [[UMengManager shareInstance] shareImageToPlatformType:type title:model.title text:model.digest thumbUrl:model.pic type:ShareObjectTypeWebShare object:dic];
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
    
    if (self.operatePrivateMsg) {
        self.operatePrivateMsg(params);
    }
    
}



- (void)actionSocketMsgTag:(NSString *)tag callback:(NSString *)callback params:(NSString *)params {
    
    if (self.operateSocketMsg) {
        self.operateSocketMsg(params);
    }
    
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
    
    if (self.operateCallBack) {
        self.operateCallBack(callback, tag, [model mj_JSONString]);
    }
    
    
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
    
    if (self.operateCallBack) {
        self.operateCallBack(callback, tag, [model mj_JSONString]);
    }
    
}

- (void)shareFinish:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    RequestModel *model = [[RequestModel alloc] init];
    model.code = 1000;
    model.message = @"分享完成";
    
    if (self.operateCallBack) {
        self.operateCallBack(dic[@"callback"], dic[@"tag"], [model mj_JSONString]);
    }
    
}

- (void)showLoginPage:(NSString *)string {
    
}

- (NSString *)getUserInfo:(NSString *)string {
    NSString *str = [[UserInfoRequestManager sharedInstance].user mj_JSONString];
    if (str) {
        return str;
    }
    return @"";
}

- (void)showShareButton:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.operateShowShareBtn) {
            self.operateShowShareBtn(@"");
        }
    });
}

- (void)hideCloseButton:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.operateHideClose) {
            self.operateHideClose(@"");
        }
    });
}

- (void)setWebHelpText:(NSString *)title toUrl:(NSString *)toUrl {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.operateShowRightHelpButton) {
            self.operateShowRightHelpButton(title, toUrl);
        }
    });
}

- (void)copyString:(NSString *)content{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
        
    });

}

- (void)openChatService:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        JHChatInfoModel *model = [JHChatInfoModel mj_objectWithKeyValues:[string mj_JSONObject]];
        JHQYStaffInfo *info = [[JHQYStaffInfo alloc] init];
        info.groupId = model.groupId;
        info.shopId = model.shopId;
        info.text = model.showText;
        info.title = model.title;
        
        [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] staffInfo:info orderModel:model];
    });
}

///客服
-(void)showChatViewcontroller
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:nil];
    });
}

- (void)startPicPreview:(NSString *)sender
{
    NSDictionary *param = sender.mj_JSONObject;
    NSInteger index = [[param valueForKey:@"current"] intValue];
    NSString *thumArrayStr = [param valueForKey:@"thumb_list"];
    NSString *imageArrayStr = [param valueForKey:@"origin_list"];
    
    NSArray *thumArray = [thumArrayStr componentsSeparatedByString:@","];
    NSArray *imageArray = [imageArrayStr componentsSeparatedByString:@","];
    if (self.operateShowImage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.operateShowImage(index, thumArray, imageArray);
        });
    }
}
@end

//
//  JHNormalLiveController.m
//  TTjianbao
//
//  Created by jiang on 2019/9/3.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHActivityAlertView.h"
#import "JHNormalLiveController.h"
#import "TTjianbaoUtil.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "UIView+Toast.h"
#import "NTESLiveManager.h"
#import "NTESDemoLiveroomTask.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESDemoService.h"
#import "NTESSessionMsgConverter.h"
#import "NTESLiveInnerView.h"
#import "NTESPresentBoxView.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESMicAttachment.h"
#import "NTESLiveAnchorHandler.h"
#import "NTESTimerHolder.h"
#import "NTESDevice.h"
#import "NTESUserUtil.h"
#import "NTESCustomKeyDefine.h"
#import "NTESMixAudioSettingView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import "NTESLiveUtil.h"
#import "NTESVideoQualityView.h"
#import "NTESMirrorView.h"
#import "JHAnchorInnerView.h"
#import "JHAppraisalList.h"
#import "JHGemmologistViewController.h"
#import "JHConnectMicPopAlertView.h"
#import "JHAppraisalLinkerView.h"
#import <IQKeyboardManager.h>
#import "NTESLiveBypassView.h"
#import "JHCaptureView.h"
#import "UMengManager.h"
#import "JHLiveRoomDetailView.h"
#import "JHConnetcMicDetailView.h"
#import "JHConnetcMicDetailView.h"
#import "EnlargedImage.h"
#import "JHCustomBugly.h"
#import "NTESMessageModel.h"
#import "JHSendAmountView.h"
#import "JHWaterPrintView.h"
#import "JHWebView.h"
#import "JHGuessAnchourAlertView.h"
#import "JHAudienceOrderListView.h"
#import "JSCoreObject.h"
#import "JHWebViewController.h"
#import "JHMuteListViewController.h"
#import "JHBaseOperationView.h"
#import <UIButton+WebCache.h>
#import "JHSendOrderModel.h"
#import "JHRoomSendOrderView.h"
#import "JHRoomUserCardView.h"
#import "JHSendOrderProccessGoodView.h"
#import "JHSendOrderProccessGoodServiceView.h"
#import "JHHomeActivityMode.h"
#import "JHNimNotificationModel.h"
#import "JHLiveRoomRedPacketViewModel.h"
#import "NSString+Common.h"
#import "JHPublishAnnouncementController.h"
#import "PanNavigationController.h"
#import "JHFansListView.h"


#import "JHShanGouProductInfoView.h"
#import "JHShanGouTypeAlter.h"
#import "JHShanGouProductView.h"
#import "JHFlashSendOrderInputView.h"
#import "JHFlashSendOrderRecordListView.h"
#import "JHFlashSendOrderUserListView.h"

#define JHRoomSendOrderViewTag 1922
#define JHRoomFlashSendOrderViewTag 1988
typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);

@interface JHNormalLiveController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,NTESLiveAnchorHandlerDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NTESTimerHolderDelegate,NTESVideoQualityViewDelegate,NTESMirrorViewDelegate, JHLiveEndViewDelegate, JHAppraisalLinkerViewDelegate,JHConnetcMicDetailViewDelegate, UIAlertViewDelegate,JHMediaCaptureDelegate,JHAnchorInnerViewDelegate>
{
    NTESTimerHolder *_timer;
    NTESDisconnectAckHandler _ackHandler;
    int secondsCountDown;
    BOOL isFirstConnector;
    NSString *startTime;
    NSTimeInterval liveIntime;
}

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong)JHMediaCapture  *normalLiveCapture;

@property (nonatomic, strong) JHCaptureView *captureView;

@property (nonatomic, strong) JHAnchorInnerView *innerView;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) NTESMixAudioSettingView *mixAudioSettingView;

@property (nonatomic, strong) NTESVideoQualityView *videoQualityView;

@property (nonatomic, strong) NTESMirrorView *mirrorView;

@property (nonatomic, weak)   id<JHNormalLiveControllerDelegate> delegate;

@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, strong) JHConnetcMicDetailView * micDetailView;

@property (nonatomic) BOOL audioLiving;

@property (nonatomic) BOOL isflashOn;

@property (nonatomic) BOOL isFocusOn;

@property (nonatomic) BOOL gameSwitch;

@property (nonatomic, strong)NSMutableArray *audienceArray;

@property (nonatomic, strong)JHAppraisalLinkerView *appraisalList;
@property (nonatomic,strong) JHConnectMicPopAlertView *anchorMicAlert;

@property (nonatomic ,assign) BOOL remoteFullScreen;

@property (nonatomic ,assign) BOOL switchMainAreaError;
@property (nonatomic,strong) JHLiveRoomDetailView *roomDetailView;

@property (nonatomic,strong) JHSendAmountView *sendAmountView;

@property (nonatomic, strong) JHWaterPrintView  *playLogo;

@property (nonatomic,strong)  BYTimer  *downTimer;

@property (nonatomic,assign) BOOL isLinking;//是否正在连麦

@property (nonatomic,assign) NSInteger trySetMainCount;//设置次数

@property (nonatomic,strong) NSString * gameId;//游戏id
@property (nonatomic, assign) BOOL isCreatAnction;

@property (nonatomic, strong)JHWebView *auctionListWeb;
@property (nonatomic,strong) JHWebView *webActivity;
@property (nonatomic, strong)JHWebView *showWishPaperView;
@property (nonatomic,strong) JHWebView *webSpecialActivity;//指定活动 双11等

@property (nonatomic, assign)JHLiveSDKType  liveType;
@property (nonatomic, strong)JHRoomSendOrderView *auctionView;
//@property (nonatomic, strong)JHFlashSendOrderInputView *flashView; /// 闪购

@property (nonatomic,strong) JHLiveRoomRedPacketViewModel *redPacketViewModel;

///---lh
@property (strong, nonatomic) JHHomeActivityMode *homeActivityMode;

@property (nonatomic, assign) BOOL  isFlashSendOrder; /// 当前是否是闪购

@end

@implementation JHNormalLiveController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (void)dealloc{
    
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.type>0?2:1;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] liveOutBuryWithModel:model];
    
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [_downTimer stopGCDTimer];
    DDLogInfo(@"===dealloc anchorlive");
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(JHMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroom = chatroom;
        _currentMeeting = currentMeeting;
        self.automaticallyAdjustsScrollViewInsets = NO;
        _handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
        _handler.delegate = self;
        _delegate = delegate;
        _normalLiveCapture = capture;
        self.normalLiveCapture.delegate=self;
        self.liveType=JHNomalLiveSDK;
        [self submitCallId];
        DDLogInfo(@"&&&&&&开播成功");
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFlashSendOrder = NO;
    [self removeNavView];
    [NTESLiveManager sharedInstance].orientation = self.orientation;
    liveIntime = time(NULL);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatShanGouInfoNoticeAction:) name:@"ChatShanGouInfoNotice" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:LOGOUTSUSSNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNimNotification:) name:JHNIMNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoticeShopWindowMessage:) name:@"shopwindowNotificationMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShareAction) name:NotificationNameRedPacketGotoShare object:nil];
    
    [self setUp];
    
    self.channel.status=@"2";
    DDLogInfo(@"enter live room , live room type %d, current user: %@",
              (int)[NTESLiveManager sharedInstance].type,[[NIMSDK sharedSDK].loginManager currentAccount]);
    
    [NTESLiveManager sharedInstance].type = NTESLiveTypeVideo;
    [self.normalLiveCapture startVideoPreview:self.channel.pushUrl container:self.captureView];
    [self.innerView switchToPlayingUI];
    [self.view addSubview:self.roomDetailView];
    [self.roomDetailView addSubview:self.innerView];
    self.innerView.frame = CGRectMake(ScreenW, 0, ScreenW, ScreenH);
    [self.innerView updateView];
    
    [self.innerView updateBeautify:self.filterModel.filterIndex];
    [self.innerView updateQualityButton:[NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityHigh];
    self.innerView.pushSuggestVCdelegate = self;
    
    [self fetchAnchorInfo];
    
    [self.innerView updateRoleType:JHLiveRoleAnchor];
    self.innerView.type = self.type;
    
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.type>0?2:1;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] liveInBuryWithModel:model];
    
    [self getNotic];
    
    _playLogo = [[JHWaterPrintView alloc] initWithImage:[UIImage imageNamed:@"img_water_print"] roomId:self.channel.roomId];
    _playLogo.mj_x = ScreenW-45-_playLogo.mj_w-10;
   // _playLogo.centerY = UI.statusBarHeight + 10.+ 20;
    _playLogo.centerY = self.innerView.infoView.centerY;
    [self.view insertSubview:_playLogo belowSubview:self.roomDetailView];
    self.innerView.canAppraise = YES;
    
    if (self.innerView.auctionWeb) {
        JH_WEAK(self)
        self.innerView.auctionWeb.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
            JH_STRONG(self)
            NSLog(@"%@",[self.channel mj_JSONString]);
            return [self.channel mj_JSONString];
        };
    }
    
    self.innerView.canAuction = self.channel.canAuction;
    [self checkActivity];
    ///--- lh
    [self requestOpenActivity];
    
    [self requestCount];
    [self redPacketViewModel];
    
    JHRootController.serviceCenter.channelModel = self.channel; //主播记录channelmodel
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playLogo.centerY = self.innerView.infoView.centerY;
}

- (void)setUp
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.focusView];
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
}

#pragma mark - JHMediaCaptureDelegate
- (void)doLiveStreamError:(NSError*_Nullable)error
{
    DDLogError(@"on meeting error: %@", error.description);
    //    [JHRootController.homeTabController presentViewController:alertVc animated:YES completion:nil];
    NSString* errorDesc = error.description;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"直播失败" message:errorDesc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert showAlertWithCompletionHandler:nil];
    
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    [[NTESLiveManager sharedInstance] stop];
    MJWeakSelf
    [ SVProgressHUD show];
    [self.normalLiveCapture stopLiveStream:^(NSError * _Nullable error) {
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:weakSelf.chatroom.roomId completion:^(NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            [weakSelf.normalLiveCapture destory];
            dispatch_async(dispatch_get_main_queue(), ^{
                //   [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:NO];
            });
        }];
    }];
    //直播失败上报bugly
    errorDesc = [NSString stringWithFormat:@"直播失败<<%@>>%@", self.channel.pushUrl ? : @"", errorDesc ? : @""];
    [JHCustomBugly customExceptionClass:[self class] reason:errorDesc];
}

#pragma mark --- lh
- (void)requestOpenActivity {
    /// 活动
    [JHActivityAlertView getActivityAlertViewWithLocation:3];
}

- (void)showActivity {
    if ([self.homeActivityMode.homeActivityIcon.target.componentName isEqualToString:@"WebDialog"]) {
        JHWebView *webview = [[JHWebView alloc] init];
        webview.frame = self.view.bounds;
        ///isSell 普通商家固定值为1
        NSString *urlString = [self.homeActivityMode.homeActivityIcon.target.params objectForKey:@"urlString"];
        [webview jh_loadWebURL:[urlString stringByAppendingFormat:@"?isSell=%d&isBroad=%d&isAssistant=%d", 1, 1,(int)self.channel.isAssistant]];

        [self.view addSubview:webview];
        self.webSpecialActivity = webview;
        
        [self.view addSubview:webview];
        self.webSpecialActivity = webview;
    }
    else {
        [JHRootController toNativeVC:self.homeActivityMode.homeActivityIcon.target.componentName withParam:self.homeActivityMode.homeActivityIcon.target.params from:JHLiveFromh5];
    }
}

//- (BOOL)prefersUI.statusBarHeightidden{
//    return YES;
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_appraisalList hiddenAlert];
}

-(void)submitCallId {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[NSString  stringWithFormat:@"%llu",self.currentMeeting.callID] forKey:@"thisTimeId"];
    [params setValue:self.channel.meetingName forKey:@"meetingName"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/reportId/auth") Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

-(void)loginOut{
    
    [self doExitLive];
}
#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    switch (message.messageType) {
        case NIMMessageTypeText:
            [self.innerView addMessages:@[message]];
            break;
        default:
            break;
    }
}

- (void)onRecvMessages:(NSArray *)messages
{
    DDLogInfo(@"yy=onRecvMessages");
    
    //    dispatch_async(dispatch_queue_create(0, 0), ^{
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    
    for (NIMMessage *message in messages) {
        
        if (![message.session.sessionId isEqualToString:self.chatroom.roomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
            DDLogWarn(@"yy=onRecvMessages  不属于这个聊天室信息roomId %@ sessionType :%ld", message.session.sessionId, (long)message.session.sessionType);
            continue;
        }
        DDLogInfo(@"yy=onRecvMessages  当前线程 %@", [NSThread currentThread]);
        DDLogInfo(@"yy=onRecvMessages  messageType %ld", (long)message.messageType);
        
        DDLogInfo(@"%@  %@  %@",message.messageExt, message.remoteExt, message.text);
        
        
        switch (message.messageType) {
            case NIMMessageTypeText:
                [self.innerView addMessages:@[message]];
                break;
            case NIMMessageTypeCustom:
            {
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                id<NIMCustomAttachment> attachment = object.attachment;
                if ([attachment isKindOfClass:[JHRedPacketMessageModel class]]) {
                    JHRedPacketMessageModel *model = (JHRedPacketMessageModel *)attachment;
                    if (model.type == JHSystemMsgTypeRedPacketRemove) {
                        JHRoomRedPacketModel *redModel = ((JHRedPacketMessageModel *)model).body;
                        [self.redPacketViewModel updateReceivedRedId:redModel.redPacketId];
                        break;
                        
                    }else if (model.type == JHSystemMsgTypeRedPacketShowNew)
                    {
                        JHRoomRedPacketModel *redModel = ((JHRedPacketMessageModel *)model).body;
                        [self.redPacketViewModel showBigPacketWithModel:redModel];
                        break;
                    }
                    break;
                } else
                    if ([attachment isKindOfClass:[JHSystemMsgAttachment class]]) {
                        
                        JHSystemMsgType type = ((JHSystemMsgAttachment *)attachment).type;
                        
                        if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeEndLive) {    
                            break;
                        }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeForbidLive) {
                            [self forbidLiveWithMsg:((JHSystemMsgAttachment *)attachment).content isWarning:NO];
                            break;
                        } else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeWarning) {
                            [self forbidLiveWithMsg:((JHSystemMsgAttachment *)attachment).content isWarning:YES];
                            break;
                        } else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypePresent) {
                            [self.innerView addPresentModel:(JHSystemMsg *)attachment];
                            [self.innerView addMessages:@[message]];
                            
                            break;
                            
                        }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgType666) {
                            [self.innerView fireLike];
                            break;
                            
                        }
                        
                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeNotification) {
                            [self.innerView addMessages:@[message]];
                            break;
                        }
                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeOrderNotification) {
                            [self.innerView addAnimationMessage:(JHSystemMsg *)attachment];
                            
                            break;
                        }
                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRoomNotification) {
                            [self.innerView setRunViewText:((JHSystemMsgAttachment *)attachment).content andIcon:((JHSystemMsgAttachment *)attachment).icon andshowStyle:((JHSystemMsgAttachment *)attachment).showStyle];
                            [self.innerView showRunView];
                            
                            break;
                        }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeSwitchAppraise) {
                            
                            self.innerView.canAppraise = ((JHSystemMsgAttachment *)attachment).yesOrNo;
                            [self.innerView setRunViewText:((JHSystemMsgAttachment *)attachment).content andIcon:((JHSystemMsgAttachment *)attachment).icon andshowStyle:((JHSystemMsgAttachment *)attachment).showStyle];
                            [self.innerView showRunView];
                            
                            break;
                        }
                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRoomWatchCount) {
                            //直播间观看人数变化
                            self.channel.watchTotal =((JHSystemMsgAttachment *)attachment).watchTotal;
                            [self.innerView refreshChannel:self.channel];
                            break;
                        }

                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeActivityNotification) {
                            ///--- lh
                            [self.webSpecialActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            
                            [self.webActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            [self.auctionListWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            [self.innerView.auctionWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            
                            break;
                        }
                        
                        else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeActivityNotification) {
                            ///--- lh
                            [self.webSpecialActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            
                            [self.webActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            [self.auctionListWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            [self.innerView.auctionWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                            
                            break;
                        }
                        
                        if(type == JHSystemMsgTypeShopwindowAddGoods || type == JHSystemMsgTypeShopwindowRefreash || type == JHSystemMsgTypeShopwindowCount || type == JHSystemMsgTypeShopwindowAudienceCount)
                        {
                            return;
                        }
                        /// 挖个坑埋点土（要在公屏显示就执行下面👇）
                        //填坑 <4000 的不特殊处理 默认飘屏和公聊 以后在增加4000以上的
                        if (((JHSystemMsgAttachment *)attachment).type<JHSystemMsgTypeRoomWatchCount) {
                            [self.innerView addAnimationMessage:(JHSystemMsg *)attachment];
                            [self.innerView addMessages:@[message]];
                        }
                    }
                
                break;
            }
            case NIMMessageTypeNotification:{
                [self.handler dealWithNotificationMessage:message];
            }
                break;
            default:
                break;
        }
    }
}

- (void)receiveNoticeShopWindowMessage:(NSNotification *)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = sender.object;
        NSInteger type     = [dict jsonInteger:@"type"];
        NSDictionary *body = [dict jsonDict:@"body"];
        
        if(type == JHSystemMsgTypeShopwindowRefreash)///橱窗弹框刷新
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotification" object:nil];
        }
        
        if(type == JHSystemMsgTypeShopwindowCount)///橱窗弹框数量刷新
        {
            if(body && [body valueForKey:@"onlineNum"])
            {
                NSInteger num = [[body valueForKey:@"onlineNum"] integerValue];
                NSString *numStr = @"购";
                if(num > 0)
                {
                    numStr = [NSString stringWithFormat:@"%@",@(num)];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotificationNum" object:numStr];
            }
        }
    });
}

-(void)onReceiveNimNotification:(NSNotification*)note{
    JHNimNotificationModel *model =(JHNimNotificationModel*)note.object;
    
    if (![model.body.roomId isEqualToString:self.channel.roomId]) {
        return;
    }
    switch (model.type) {
        case JHSystemMsgTypeStoneInSaleCount:{
            self.innerView.countInfo.saleCount = model.body.saleCount;
            [self.innerView updateActionButtonCount:model.body.saleCount type:model.type];
            
        }
            break;
            
        case JHSystemMsgTypeStoneUserActionCount:{
            self.innerView.countInfo.seekCount = model.body.seekCount;
            [self.innerView updateActionButtonCount:model.body.offerCount type:model.type];
            
        }
            break;
            
        case JHSystemMsgTypeStoneWaitShelveCount:{
            self.innerView.countInfo.shelveCount = model.body.shelveCount;
            [self.innerView updateActionButtonCount:model.body.offerCount type:model.type];
        }
            break;
            
        case JHSystemMsgTypeStoneOrderCount:
            [self.innerView updateActionButtonCount:model.body.orderCount type:JHSystemMsgTypeStoneOrderCount];
            break;
            
        default:
            break;
    }
}
#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    
    NSString *content  = notification.content;
    NSDictionary *dict = [content jsonObject];
    DDLogInfo(@"onReceiveCustomSystemNotification%@",dict);
    //    NTESLiveCustomNotificationType type = [dict jsonInteger:@"command"];
    NTESLiveCustomNotificationType type = [[dict objectForKey:@"type"]  integerValue];
    switch (type) {
            
        case NTESLiveCustomNotificationTypePushMic:
        case NTESLiveCustomNotificationTypePopMic:
        case NTESLiveCustomNotificationTypeRejectAgree:
        case NTESLiveCustomNotificationTypeAudiencedEnterOrExitLiveRoom:
            
            //            if (type==NTESLiveCustomNotificationTypePopMic) {
            //                NSString *from  = [[dict jsonDict:@"body"] jsonString:@"accid"];
            //                NTESMicConnector *connector= [[NTESLiveManager sharedInstance] findConnector:from];
            //                if (connector.state==NTESLiveMicStateWait){
            //                    [self.downTimer stopGCDTimer];
            //                }
            //            }
            [self.handler dealWithBypassCustomNotification:notification];
            if (_appraisalList) {
                [_appraisalList reloadData:[NTESLiveManager sharedInstance].connectors];
            }
            
            DDLogInfo(@"连麦队列更新请求 当前线程 %@", [NSThread currentThread]);
            DDLogInfo(@"连麦队列更新connectors.count=%ld",[NTESLiveManager sharedInstance].connectors.count);
            [self.innerView setLinkNum:[NTESLiveManager sharedInstance].connectors.count?
             [NTESLiveManager sharedInstance].connectors.count:0];
            
            break;
        case NTESLiveCustomNotificationTypeAssistantReceived:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameUpdateOrderNumber" object:nil];
            break;
        case JHSystemMsgTypeActivityNotification:
            ///--- lh
            [self.webSpecialActivity natActionSubPublicSocketMsg:content];
            
            [self.webActivity natActionSubPublicSocketMsg:content];
            [self.auctionListWeb natActionSubPublicSocketMsg:content];
            [self.innerView.auctionWeb natActionSubPublicSocketMsg:content];
            
            break;
            
        case NTESLiveCustomNotificationTypeBeMuteUserSendToAnchorMsg:{
            return;
            NSDictionary *dic = dict[@"body"];
            NIMMessage *message = [[NIMMessage alloc] init];
            message.from = notification.sender;
            message.text = dic[@"msg"];
            
            
            NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
            requst.roomId = self.channel.roomId;
            requst.userIds = @[message.from];
            
            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
                if (error) {
                    DDLogInfo(@"进入没有拿到信息 %@",error);
                    return ;
                }
                NIMChatroomMember *mm = members.firstObject;
                
                if ([mm.roomNickname isEqual:[NSNull null]]&& ([mm.roomAvatar isEqual:[NSNull null]])) {
                    return;
                }
                NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
                ext.roomAvatar = mm.roomAvatar;
                ext.roomNickname = mm.roomNickname?:@"";
                
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[mm.roomExt mj_JSONObject]];
                mdic[@"tempMuted"] = @(1);
                ext.roomExt = mdic.copy;
                message.messageExt = ext;
                [self.innerView addMessages:@[message]];
                
            }];
            
        }
            
            break;
        case JHSystemMsgTypeWarning:{
            
            NSDictionary *dic = dict[@"body"];
            
            
            [self forbidLiveWithMsg:dic[@"content"] isWarning:YES];
            
        }
            
            break;
            
        case JHSystemMsgTypeForbidLive: {
            NSDictionary *dic = dict[@"body"];
            
            [self forbidLiveWithMsg:dic[@"content"] isWarning:NO];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)chatShanGouInfoNoticeAction:(NSNotification*)notice{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dict = notice.object;
        NSInteger type     = [dict jsonInteger:@"type"];
        NSDictionary *body = [dict jsonDict:@"body"];
        JHShanGouModel *shanGouModel = [JHShanGouModel mj_objectWithKeyValues:body];
        switch (type) {
                //闪购商品上架
            case FlashSalesMsg:{
                NSLog(@"FlashSalesMsg");
            }
            break;
                
                //闪购商品下架
            case FlashDownMsg:{
                NSLog(@"FlashDownMsg");
                @weakify(self);
                [JHDispatch ui:^{
                    @strongify(self);
                    JHFlashSendOrderUserListView *view = [[JHFlashSendOrderUserListView alloc] init];
                    view.anchorId = self.channel.anchorId;
                    view.productCode = shanGouModel.productCode;
                    view.isFinish = YES;
                    view.frame = self.view.bounds;
                    [self.innerView addSubview:view];
                    [view showAlert];
                }];
            }
            break;
                
                //闪购商品售罄
            case FlashSalesSellOutMsg:{
                NSLog(@"FlashSalesSellOutMsg");
                @weakify(self);
                [JHDispatch ui:^{
                    @strongify(self);
                    JHFlashSendOrderUserListView *view = [[JHFlashSendOrderUserListView alloc] init];
                    view.anchorId = self.channel.anchorId;
                    view.productCode = shanGouModel.productCode;
                    view.isFinish = YES;
                    view.frame = self.view.bounds;
                    [self.innerView addSubview:view];
                    [view showAlert];
                }];
            }
            break;

            default:
                break;
        }
    });
}


#pragma mark - NTESLiveAnchorHandlerDelegate

- (void)didUserBeMute:(BOOL)ismute message:(NIMMessage *)message {
    return;
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    
    for (NIMChatroomNotificationMember *m in content.targets) {
        NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
        
        NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
        requst.roomId = self.chatroom.roomId;
        requst.userIds = @[m.userId];
        
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            NIMChatroomMember *mm = members.firstObject;
            
            NSString *string = ismute?@"禁言":@"解除禁言";
            
            message.text = [NSString stringWithFormat:@"%@被%@",mm.roomNickname,string];//,content.source.nick,
            //            message.messageType = NIMMessageTypeCustom;
            //            JHSystemMsg *msg = [[JHSystemMsg alloc] init];
            //            msg.nick = mm.roomNickname?:@"";
            //            msg.content = message.text;
            //            msg.avatar = mm.roomAvatar?:@"";
            //            msg.type = JHSystemMsgTypeNotification;
            //            ext.roomAvatar = mm.roomAvatar;
            //            ext.roomNickname = mm.roomNickname?:@"";
            //            message.messageExt = ext;
            //            message.from = mm.userId;
            
            
            [self.innerView addMessages:@[message]];
            
        }];
    }
    
}
- (void)didUpdateConnectorStatus
{
    _appraisalList.statusType=0;
}
- (void)stopTimer
{
    [self.downTimer stopGCDTimer];
}

- (void)didUpdateChatroomMemebers:(BOOL)isAdd {
    if (isAdd) {
        self.channel.watchTotal ++;
        //        _chatroom.onlineUserCount++;
    } else {
        self.channel.watchTotal --;
        
        //        _chatroom.onlineUserCount--;
    }
    //    _chatroom.onlineUserCount = self.channel.watchTotal;
    //    _chatroom.onlineUserCount =
    //    (_chatroom.onlineUserCount < 0 ? 0 : _chatroom.onlineUserCount);
    //    [self.innerView refreshChatroom:_chatroom];
    self.channel.watchTotal =
    (self.channel.watchTotal < 0 ? 0 : self.channel.watchTotal);
    
    [self.innerView refreshChannel:self.channel];
    
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%d",roomId, (int)reason);
        [self.normalLiveCapture stopLiveStream:^(NSError * _Nullable error) {
            
        }];
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connection state changed roomId : %@  state : %d",roomId, (int)state);
}

#pragma mark - JHLiveEndViewDelegate

- (void)didPressBackButton {
    [self dismissToRootViewController];
    
}

- (void)dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)didPressCareOffButton:(UIButton *)btn {
    if (self.channel.isOpen && self.channel.fansClubStatus == 0) {
        JHFansListView  *fansListView = [[JHFansListView alloc] init];
        fansListView.anchorId = self.channel.anchorId;
        [JHKeyWindow addSubview:fansListView];
        [fansListView show];
        [fansListView loadNewData];
    }else if(self.channel.isOpen){
        JHTOAST(@"粉丝团已被挂起，请联系官方运营人员");
    }
}

#pragma mark - 闪购弹框事件
- (void)shanGouSeletedIndex:(JHShanGouTypeAlter_Action)index  andName:(NSString *)name andTypeId:(NSString *)typeId{
    switch (index) {
        case JHShanGouTypeAlter_CreatProduct:{
            JHFlashSendOrderInputView *view = [[JHFlashSendOrderInputView alloc] init];
            view.anchorId = self.channel.anchorId;
            if ([typeId isEqualToString:@"normal"]) {
                view.flashStyle = JHFlashSendOrderStyle_NormalOrder;
            } else if ([typeId isEqualToString:@"processingOrder"]) {
                view.flashStyle = JHFlashSendOrderStyle_ProcessOrder;
            } else if ([typeId isEqualToString:@"giftOrder"]) {
                view.flashStyle = JHFlashSendOrderStyle_WelfareOrder;
            }
            self.isFlashSendOrder = YES;
            view.tag = JHRoomFlashSendOrderViewTag;
            [self.innerView addSubview:view];
            view.frame = self.view.bounds;
            [view showAlert];
            @weakify(self);
            view.clickImage = ^(JHRoomUserCardView *sender) {
                @strongify(self);
                self.innerView.hidden = YES;
                [self cameraScreen];
            };
            view.clickClose = ^(id obj) {
                @strongify(self);
                self.isFlashSendOrder = NO;
            };
        }
            break;
            
            //闪购记录
        case JHShanGouTypeAlter_SeeList:{
            JHFlashSendOrderRecordListView *view = [[JHFlashSendOrderRecordListView alloc] init];
            view.anchorId = self.channel.anchorId;
            @weakify(self);
            [view setShowProductBlock:^(NSString * _Nullable productCode) {
                @strongify(self);
                [self showProductWithProductCode:productCode];
            }];

            [self.innerView addSubview:view];
            view.frame = self.view.bounds;
            [view showAlert];
        }
            break;

        default:
            break;
    }
}

- (void)showProductWithProductCode:(NSString*)proCode{
    JHShanGouProductInfoView *aa = [[JHShanGouProductInfoView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    aa.productCode = proCode;
    @weakify(self);
    [aa setJumpUserListBlock:^(JHShanGouModel * _Nullable productCode) {
        @strongify(self);
        [self jumpUserListWithProductCode:productCode];
    }];
    aa.anchorId = self.channel.anchorId;
    [self.view addSubview:aa];
}

#pragma mark - NTESLiveInnerViewDelegate
- (void)onShanGouBtnAction{
    [SVProgressHUD show];
    @weakify(self);
    NSString *url = FILE_BASE_STRING(@"/app/flash/sales/product/anchor");
    [HttpRequestTool postWithURL:url
                      Parameters:@{@"anchorId": self.channel.anchorId}
           requestSerializerType:RequestSerializerTypeJson
                    successBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];

        JHShanGouModel *model = [JHShanGouModel mj_objectWithKeyValues:respondObject.data];
        if (model.productCode.length) {
            JHShanGouProductInfoView *aa = [[JHShanGouProductInfoView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            [aa setJumpUserListBlock:^(JHShanGouModel * _Nullable productCode) {
                @strongify(self);
                [self jumpUserListWithProductCode:productCode];
            }];
            aa.anchorId = self.channel.anchorId;
            aa.shanGouModel = model;
            [self.view addSubview:aa];
        }else{
            JHShanGouTypeAlter *aa = [[JHShanGouTypeAlter alloc] initWithFrame:UIScreen.mainScreen.bounds];
            aa.flashCategories = self.channel.flashCategories;
            [aa setSeletedBlock:^(JHShanGouTypeAlter_Action index, NSString * _Nullable name, NSString * _Nullable typeId) {
                @strongify(self);
                [self shanGouSeletedIndex:index andName:name andTypeId:typeId];
            }];
            [self.view addSubview:aa];
        }
    }
                    failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD dismiss];

        JHTOAST(respondObject.message);
    }];
}


/// 跳转参与用户列表
/// @param productCode
- (void)jumpUserListWithProductCode:(JHShanGouModel*)productCode{
    JHFlashSendOrderUserListView *view = [[JHFlashSendOrderUserListView alloc] init];
    view.anchorId = self.channel.anchorId;
    view.productCode = productCode.productCode;
    view.isFinish = (productCode.productStatus == 2)?YES:NO;
    view.frame = self.view.bounds;
    [self.innerView addSubview:view];
    [view showAlert];
}

- (void)onShowAuctionListView:(UIButton *)btn {
    JHWebView *web = [[JHWebView alloc] init];
    [web jh_loadWebURL:AuctionListURL((int)(self.type >= 1),1,(int)self.channel.isAssistant)];
    
    web.frame = self.innerView.bounds;
    self.auctionListWeb = web;
    [self.innerView addSubview:web];
    
    @weakify(self);
    web.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        @strongify(self);
        return [self.channel mj_JSONString];
    };
    web.operateActionScreenCapture = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        @strongify(self);
        self.innerView.hidden = YES;
        self.auctionListWeb.hidden = YES;
        self.isCreatAnction = YES;
        [self cameraScreen];
        
    };
    web.operateActionAuctionSendOrder = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        NSDictionary *dic = [jsonString mj_JSONObject];
        @strongify(self);
        JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] init];
        view.frame = self.view.bounds;
        view.tag = JHRoomSendOrderViewTag;
        view.anchorId = self.channel.anchorId;
        view.clickImage = ^(JHRoomUserCardView *sender) {
            self.innerView.hidden = YES;
            [self cameraScreen];
        };
        view.addSelfToView = ^(UIView *sender) {
            [self.innerView addSubview:sender];
            
        };
        view.customerId = dic[@"viewerId"];
        view.biddingId = dic[@"biddingId"];
        [view showOrderTypePicker:self.channel.categories];
        self.auctionView = view;
        
    };
}

- (void)beginCamaro {
    [self cameraScreen];
}

- (void)onShareAction {
    NSString *url = [NSString stringWithFormat:@"%@channelid=%@&code=%@", [UMengManager shareInstance].shareLiveUrl, self.channel.channelLocalId, [UserInfoRequestManager sharedInstance].user.invitationCode];
    
    if (self.type == 0) {
        url = [NSString stringWithFormat:@"%@&type=1",url];
        NSString *title = [NSString stringWithFormat:ShareLiveAppraiseTitle,self.channel.anchorName];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveAppraiseText thumbUrl:nil webURL:url type:ShareObjectTypeAppraiseLive object:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveAppraiseText;
        info.shareType = ShareObjectTypeAppraiseLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}]; //TODO:Umeng share
    }else {
        
        url = [NSString stringWithFormat:@"%@&type=2",url];
        NSString *title = [NSString stringWithFormat:ShareLiveSaleTitle,self.channel.anchorName];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveSaleText;
        info.shareType = ShareObjectTypeSaleLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}]; //TODO:Umeng share
    }
    
    
    
}

- (BOOL)isPlayerPlaying {
    return NO;
}

- (void)didSendText:(NSString *)text
{
    // NSDictionary *ext = @{@"avatar":self.channel.anchorIcon?self.channel.anchorIcon:@"",@"nick":self.channel.anchorName?self.channel.anchorName:@""};
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    ext.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
    ext.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
    
    NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
    dic[@"roomRole"] = @(JHRoomRoleAnchor);
    
    ext.roomExt = [dic mj_JSONString];
    message.messageExt = ext;
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}
- (void)snapshotFromLocalVideoComplete:(void(^)(UIImage * __nullable image))result
{
    [self.normalLiveCapture snapImage:^(UIImage *image) {
        if (result) {
            result(image);
        }
    }];
}
- (void)onActionType:(NTESLiveActionType)type sender:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    switch (type) {
        case NTESLiveActionTypeLive:{
     
        }
            break;
        case NTESLiveActionTypePresent:{
            NTESPresentBoxView *box = [[NTESPresentBoxView alloc] initWithFrame:self.view.bounds];
            [box show];
            break;
        }
        case NTESLiveActionTypeCamera:
            [self.normalLiveCapture switchCamera];
            
            break;
        case NTESLiveActionTypeMute:
            sender.selected = !sender.selected;
            if (sender.selected) {
                [self.normalLiveCapture.capturer pauseAudioLiveStream];
                
            }else {
                [self.normalLiveCapture.capturer resumeAudioLiveStream];
            }
            break;
        case NTESLiveActionTypeWishPaper: {
            
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"我的心愿单";
            vc.urlString = ShowWishPaperURL((int)(weakSelf.type >= 1),1,(int)weakSelf.channel.isAssistant);
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
            
        case NTESLiveActionTypeMuteList: {
            
            JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        }
            
            break;
        case NTESLiveActionTypeInteract:{

        }
            break;
        case NTESLiveActionTypeBeautify:{

        }
            break;
        case NTESLiveActionTypeMixAudio:{
            [self.mixAudioSettingView show];
        }
            break;
        case NTESLiveActionTypeSnapshot:{
            
            [self snapshotFromLocalVideoComplete:nil];
        }
            break;
        case NTESLiveActionTypeShare:{
        }
            break;
        case NTESLiveActionTypeQuality:{
            [self.videoQualityView show];
        }
            break;
        case NTESLiveActionTypeMirror:{
            
            [self.mirrorView show];
        }
            break;
        case NTESLiveActionTypeWaterMark:{

        }
            break;
        case NTESLiveActionTypeFlash:{
            NSString *toast = @"前置摄像头模式，无法使用闪光灯";
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
        }
            break;
        case NTESLiveActionTypeFocus:
        {
            NSString *toast = @"前置摄像头模式，无法手动调焦";
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
        }
            break;
        case NTESLiveActionTypeGuess:
        {
            if (sender.selected) {
                JHGuessAnchourAlertView * view=[[JHGuessAnchourAlertView alloc]init];
                [self.view addSubview:view];
                JH_WEAK(self)
                view.compelteBlock = ^(NSString * _Nonnull price) {
                    JH_STRONG(self)
                    [self endGame:price];
                };
            }
            else{
                [self beginGame];
            }
        }
            break;
        case NTESLiveActionTypeAnnouncement:
        {
            [JHGrowingIO trackEventId:JHChannelLocalldNoticeClick variables:@{@"channelLocalId":self.channel.channelLocalId ? : @""}];
            JHPublishAnnouncementController *paController = [JHPublishAnnouncementController new];
            paController.channelId = self.channel.channelLocalId;
            paController.channel = self.channel;
            [self.navigationController pushViewController:paController animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)onTapChatView:(CGPoint)point
{
    //普通直播不做操作
}

- (void)onCanAppraiseAction:(UIButton *)btn {
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/channel/canAppraise/auth") Parameters:@{@"yesOrNo":@(btn.selected)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        //        btn.selected = !btn.selected;
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
}
-(void)onVideoQualityViewCancelButtonPressed
{
    [self.videoQualityView dismiss];
}

- (void)onCloseLiving{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定结束直播吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self doExitLive];
    }]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)doExitLive
{
    NSInteger dur = 0;
     if (liveIntime>0) {
         dur = time(NULL)-liveIntime;
     }
     [JHTracking trackEvent:@"endLive" property:@{@"live_duration":@(dur),@"channel_id":self.channel.channelId,@"channel_name":self.channel.title,@"channel_local_id":self.channel.channelLocalId}];
   
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    [[NTESLiveManager sharedInstance] stop];
    MJWeakSelf
    [  SVProgressHUD show];
    [self.normalLiveCapture stopLiveStream:^(NSError *error) {
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:weakSelf.chatroom.roomId completion:^(NSError * _Nullable error) {
            [ SVProgressHUD dismiss];
            [weakSelf.normalLiveCapture destory];
            dispatch_async(dispatch_get_main_queue(), ^{
                //    [weakSelf dismissToRootViewController];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
            
        }];
        
    }];
    
}

#pragma mark - NTESMirrorViewDelegate

-(void)onPreviewMirror:(BOOL)isOn
{
    self.mirrorView.isPreviewMirrorOn = isOn;
    //    [[NIMAVChatSDK sharedSDK].netCallManager setPreViewMirror:isOn];
}

-(void)onCodeMirror:(BOOL)isOn
{
    self.mirrorView.isCodeMirrirOn = isOn;
    //    [[NIMAVChatSDK sharedSDK].netCallManager setCodeMirror:isOn];
}

- (void)onMirrorCancelButtonPressed
{
    [self.mirrorView dismiss];
}

-(void)onMirrorConfirmButtonPressedWithPreviewMirror:(BOOL)isPreviewMirrorOn CodeMirror:(BOOL)isCodeMirrorOn
{
    [self.mirrorView dismiss];
    [self.innerView updateMirrorButton:isPreviewMirrorOn||isCodeMirrorOn];
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    if (holder == _timer) {
        if (_ackHandler) {
            NSError *error = [NSError errorWithDomain:NIMRemoteErrorDomain code:NIMRemoteErrorCodeTimeoutError userInfo:nil];
            _ackHandler(error);
        }
        _ackHandler = nil;
    } else {
        
    }
}
- (void)sendConnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithConnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)sendDisconnectedNotify:(NTESMicConnector *)connector
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithDisconnectedMic:connector];
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo;
{
    if(!error)
    {
        [self.view makeToast:@"截图已保存"];
    }
    else
    {
        [self.view makeToast:@"截图未保存"];
    }
}

- (BOOL)isCanUsePhotos {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    else {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted ||
            status == PHAuthorizationStatusDenied) {
            //无权限
            return NO;
        }
    }
    return YES;
}

- (void)beginAnimation
{
    
    [self.focusView.layer addAnimation:[self scaleAnimationFrom:1.4 to:1 begintime:0] forKey:@"scale"];
}

- (void)endAnimation {
    [self.focusView.layer removeAllAnimations];
}

- (CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.5;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = false;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
}

- (void)updateBeautify:(NSInteger)selectedIndex
{
    [self.innerView updateBeautify:selectedIndex != 0];
}

-(void)pushSuggestVC:(JHAnchorInnerView *)jhAnchorInnerView
{
        [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self anchorId:self.channel.anchorId];

}
#pragma mark - Get

- (void)makeCardViewWithModel:(NTESMessageModel *)model {
    JHRoomUserCardView *_sendOrderView = [JHRoomUserCardView new];
    _sendOrderView.frame = self.view.bounds;
    _sendOrderView.anchorId = self.channel.anchorId;
    _sendOrderView.roomId = self.chatroom.roomId;
    MJWeakSelf
    
    _sendOrderView.sendWish = ^(id sender) {
        [weakSelf sendWishPaper:sender];
    };
    
    _sendOrderView.tagArray = self.channel.categories.mutableCopy;
    
    [self.view addSubview:_sendOrderView];
    _sendOrderView.hidden = NO;
    _sendOrderView.model = model;
    [_sendOrderView showAlert];
    
    _sendOrderView.orderAction = ^(NTESMessageModel *object, OrderTypeModel *sender) {
        if ([sender.Id isEqualToString:@"normalCustomizeGroup"]) {
            /// 只有定制直播间可以飞定制套餐
            return;
        }
        if ([sender.Id isEqualToString:JHOrderCategoryHandlingService]) {//加工服务单
            JHSendOrderProccessGoodView *view = [[JHSendOrderProccessGoodView alloc] init];
            [weakSelf.innerView addSubview:view];
            [view requestProccessGoodsBuyId:object.customerId isAssistant:0];
            
        } else {
            JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] init];
            [weakSelf.innerView addSubview:view];
            view.orderCategory = sender;
            view.frame = weakSelf.view.bounds;
            view.tag = JHRoomSendOrderViewTag;
            view.customerId = object.customerId;
            view.anchorId = weakSelf.channel.anchorId;
            [view showAlert];
            view.clickImage = ^(JHRoomUserCardView *sender) {
                weakSelf.innerView.hidden = YES;
                [weakSelf cameraScreen];
            };
        }
    };
}

- (JHSendAmountView *)sendAmountView {
    if (!_sendAmountView) {
        _sendAmountView = [[NSBundle mainBundle] loadNibNamed:@"JHSendAmountView" owner:nil options:nil].firstObject;
        _sendAmountView.frame = self.view.bounds;
        
    }
    return _sendAmountView;
}

- (void)cameraScreen {
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    CGFloat ww = (ScreenW-70)/2.;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ww, ScreenH-90, 70, 70);
    [btn setImage:[UIImage imageNamed:@"icon_center_camare"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(actionSelecte:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(ScreenW-90,ScreenH-90, 70, 70);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    cancel.titleLabel.font = [UIFont systemFontOfSize:20];
    [view addSubview:cancel];
}

- (void)actionCancel:(UIButton *)btn {
    [btn.superview removeFromSuperview];
    if (self.type) {
        if (self.isCreatAnction) {
            self.innerView.hidden = NO;
            self.isCreatAnction = NO;
            self.auctionListWeb.hidden = NO;
            
        }else {
            self.innerView.hidden = NO;
        }
        
    }else {
        self.innerView.hidden = NO;
    }
    
}

- (void)actionSelecte:(UIButton *)btn {
    [btn.superview removeFromSuperview];
    //    if (btn.tag == 0){
    //        [_sendOrderView.sendOrderSecond removeFromSuperview];
    //        [_sendOrderView removeFromSuperview];
    //        self.innerView.hidden = NO;
    //        self.sendOrderView.sendOrderSecond.hidden = NO;
    //    }else
    {
        MJWeakSelf
        [self snapshotFromLocalVideoComplete:^(UIImage * _Nullable image) {
            dispatch_async(dispatch_queue_create(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf dealImage:image];
                });
            });
        }];
    }
}

- (void)dealImage:(UIImage *)image {
    if (self.type) {
        if (self.isCreatAnction) {//创建竞拍时候上传图片
            
            self.isCreatAnction = NO;
            self.innerView.hidden = NO;
            self.auctionListWeb.hidden = NO;
            
            JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] initWithFrame:self.view.bounds];
            view.hidden = YES;
            view.isAnction = YES;
            
            view.auctionUploadFinish = ^(NSString *sender) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"snap_Type_Key"] = @(1000);
                dic[@"snap_Value_Key"] = sender;
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSubClientSocketMsg object:[dic mj_JSONString]];
            };
            [self.innerView addSubview:view];
            [view showImageViewAction:image];
        } else {
            /// 闪购
            if (self.isFlashSendOrder) {
                JHFlashSendOrderInputView *view = [self.innerView viewWithTag:JHRoomFlashSendOrderViewTag];
                [view showImageViewAction:image];
                self.innerView.hidden = NO;
            } else {
                //卖场发单
                JHRoomSendOrderView *view = [self.innerView viewWithTag:JHRoomSendOrderViewTag];
                [view showImageViewAction:image];
                self.innerView.hidden = NO;
            }
        }
    } else { //鉴定认领订单结束
        self.innerView.hidden = NO;
        [self.innerView catchImage:image];
    }
    
}

- (NSMutableDictionary *)sendedReporterList {
    if (!_sendedReporterList) {
        _sendedReporterList = [NSMutableDictionary dictionary];
    }
    return _sendedReporterList;
}
- (JHLiveRoomDetailView *)roomDetailView {
    if (!_roomDetailView) {
        _roomDetailView = [[JHLiveRoomDetailView alloc] initWithFrame:self.view.bounds];
        _roomDetailView.isOpenGesture = YES;
        JH_WEAK(self)
        _roomDetailView.scaleActionBlock = ^(NSNumber *num) {
            JH_STRONG(self)
            self.normalLiveCapture.capturer.zoomScale = [num floatValue];
        };
    }
    return _roomDetailView;
}

- (JHAppraisalLinkerView *)appraisalList {
    if (!_appraisalList) {
        _appraisalList = [[JHAppraisalLinkerView alloc] initWithFrame:CGRectMake(0.f, ScreenH, ScreenW, 265./375.*ScreenW+UI.bottomSafeAreaHeight)];
        _appraisalList.delegate = self;
    }
    return _appraisalList;
}

-(JHConnectMicPopAlertView*)anchorMicAlert{
    
    if (!_anchorMicAlert) {
        _anchorMicAlert = [[JHConnectMicPopAlertView alloc]init];
        
    }
    return _anchorMicAlert;
}
- (UIView *)captureView
{
    if (!_captureView) {
        //        CGFloat bottom = 44.f;
        _captureView = [[JHCaptureView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
        _captureView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _captureView.clipsToBounds = YES;
    }
    return _captureView;
}

- (UIView *)innerView
{
    if (!_innerView) {
        _innerView = [[JHAnchorInnerView alloc] initWithChannel:self.channel frame:self.view.bounds isAnchor:YES];
        [_innerView refreshChatroom:self.chatroom];
        [_innerView refreshChannel:self.channel];
        _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _innerView.delegate = self;
        _innerView.careDelegate = self;
        _innerView.channel = self.channel;
        
    }
    return _innerView;
}

- (NTESMixAudioSettingView *)mixAudioSettingView
{
    //因为每次打开混音界面其实需要记住之前的状态，这里直接retain住
    if (!_mixAudioSettingView) {
        _mixAudioSettingView = [[NTESMixAudioSettingView alloc] initWithFrame:self.view.bounds];
        _mixAudioSettingView.delegate = self;
    }
    return _mixAudioSettingView;
}

- (NTESVideoQualityView *)videoQualityView
{
    if (!_videoQualityView) {
        _videoQualityView = [[NTESVideoQualityView alloc]initWithFrame:self.view.bounds quality:[NTESLiveManager sharedInstance].liveQuality];
        _videoQualityView.delegate =self;
    }
    return _videoQualityView;
}

- (NTESMirrorView *)mirrorView
{
    if (!_mirrorView) {
        _mirrorView = [[NTESMirrorView alloc]initWithFrame:self.view.bounds];
        _mirrorView.delegate =self;
    }
    return _mirrorView;
}

-(UIImageView *)focusView
{
    if (!_focusView) {
        _focusView = [[UIImageView alloc]init];
        _focusView.image = [UIImage imageNamed:@"icon_focus_frame"];
        [_focusView sizeToFit];
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(JHConnetcMicDetailView *)micDetailView
{
    if (!_micDetailView) {
        _micDetailView = [[JHConnetcMicDetailView alloc]initWithFrame:self.view.bounds];
        _micDetailView.delegate = self;
    }
    return _micDetailView;
}

#pragma mark - Rotate supportedInterfaceOrientations

-(BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    if ((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo&&[NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        return UIInterfaceOrientationLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationPortrait;
    }
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo&&[NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
- (void)fetchAnchorInfo {
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/authoptional/appraise") Parameters:@{@"customerId" : self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        
        DDLogInfo(@"fetchAnchorInfo=%@",respondObject);
        JHAnchorInfoModel *model = [JHAnchorInfoModel mj_objectWithKeyValues:respondObject.data];
        self.innerView.anchorInfoModel = model;
        self.roomDetailView.anchorDetailView.model = model;
        if (self.type>0) {
            [self.roomDetailView.anchorDetailView setSaleAnchor];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}

- (void)onReporter:(NSInteger)index model:(NTESMicConnector *)model {
    
}

- (void)sendRedPocket:(NSInteger)index model:(NTESMicConnector *)model {
    [self.view addSubview:self.sendAmountView];
    self.sendAmountView.viewerId = model.Id;
    [self.sendAmountView showAlert];
}
- (void)lookOrderList:(NSInteger)index model:(NTESMicConnector *)model{
    
    JHAudienceOrderListView * order=[[JHAudienceOrderListView alloc]init];
    [order  show];
    [order loadData:model];
}
- (void)didPressAnchorAvatar:(NIMChatroomMember *)member {
    if (self.type == 0) {
        JHGemmologistViewController *gemmologistVC = [[JHGemmologistViewController alloc] init];
        gemmologistVC.anchorId = self.channel.anchorId;
        gemmologistVC.isFromLivingRoom = YES;
        [self.navigationController pushViewController:gemmologistVC animated:YES];
        [JHGrowingIO trackEventId:JHEventAssayerprofile variables:@{JHKeyPagefrom:JHPageFromAppraiseRoom}];
    }
}
- (void)requestMute:(NSInteger)ismute accid:(NSString *)accid {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":accid,@"muteDuration":@(ismute)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
//主播端>打开飞单弹层
- (void)onShowInfoWithModel:(NTESMessageModel *)model{
   [self makeCardViewWithModel:model];
}

- (void)setMuteWithAccid:(NSString *)accid {
    
    NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
    requst.roomId = self.chatroom.roomId;
    requst.userIds = @[accid];
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        if (members.count) {
            NIMChatroomMember *mem = members.firstObject;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:mem.roomNickname message:mem.isTempMuted?@"已禁言":@"禁言" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":accid, @"muteDuration":mem.isTempMuted?@(0):@(300)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                    
                } failureBlock:^(RequestModel *respondObject) {
                    
                }];
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (BOOL)prefersStatusBarHidden {
    
    if (@available(iOS 11.0, *)) {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if (a>0) {
            return NO;
        }
    }
    return YES;
}

- (void)getNotic {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/sysNotice/roomNotice") Parameters:@{@"noticeEnum":@"enter",@"anchorId":self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        NSArray *array = respondObject.data;
        for (NSDictionary *dic in array) {
            if (dic[@"content"]) {
                [_innerView setRunViewText:dic[@"content"] andIcon:@"" andshowStyle:0];
            }
        }
        [_innerView showRunView];
    } failureBlock:^(RequestModel *respondObject) {
    }];
}
- (void)checkActivity {
    self.webActivity = [[JHWebView alloc] init];
    [self.webActivity jh_loadWebURL:ActivityURL(self.type >= 1,1,[YDHelper get13TimeStamp])];
    [self.innerView addSubview:self.webActivity];
    [self.webActivity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.innerView).offset(-5);
        make.top.equalTo(self.innerView).offset(UI.statusBarHeight + 40);
        make.size.mas_equalTo(CGSizeMake(94, 144));
    }];
    JH_WEAK(self)
    self.webActivity.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
}

-(void)beginGame{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/game/addGame/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        self.gameId=respondObject.data[@"gameId"];
        [self.innerView updateGuessButtonSelect:YES];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}
-(void)endGame:(NSString*)price{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/game/gameOver/auth") Parameters:@{@"gameId":self.gameId,@"price":price} successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.innerView updateGuessButtonSelect:NO];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
    }];
    [SVProgressHUD show];
}

- (void)sendWishPaper:(NSString *)accid {
    //    老版本
    //    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/expect/sendExpect/auth") Parameters:@{@"viewerAccId":accid} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
    //        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    //
    //    } failureBlock:^(RequestModel *respondObject) {
    //        [SVProgressHUD showErrorWithStatus:respondObject.message];
    //
    //    }];
    
    
    //    新版本  accid 改成customerId
    
    JHWebView *webview = [[JHWebView alloc] init];
    [webview jh_loadWebURL:FindWishPaperURL(accid)];
    webview.frame = self.view.bounds;
    [self.view addSubview:webview];
    JH_WEAK(self)
    webview.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        return [self.channel mj_JSONString];
    };
}

- (void)forbidLiveWithMsg:(NSString *)msg isWarning:(BOOL)isWarning {
    MJWeakSelf
    if (!isWarning) {//禁播
        [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
        [[NTESLiveManager sharedInstance] removeAllConnectors];
        [[NTESLiveManager sharedInstance] stop];
        
        [self.normalLiveCapture stopLiveStream:^(NSError *error) {
            [[NIMSDK sharedSDK].chatroomManager exitChatroom:weakSelf.chatroom.roomId completion:^(NSError * _Nullable error) {
                [weakSelf.normalLiveCapture destory];
            }];
            
        }];
        
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"停播提醒" andDesc:msg cancleBtnTitle:@"知道了"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            
        };
    }else {
        
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"违规提醒" andDesc:msg cancleBtnTitle:@"知道了"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        alert.cancleHandle = ^{
            
        };
    }
}

- (void)requestCount {
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-channel/report-channel-anchor-info") Parameters:@{@"channelId":self.channel.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            JHNimNotificationBody *model = [JHNimNotificationBody mj_objectWithKeyValues:respondObject.data];
            self.innerView.countInfo = model;
            [self.innerView updateActionButtonCount:model.saleCount type:JHSystemMsgTypeStoneInSaleCount];
            [self.innerView updateActionButtonCount:model.seekCount type:JHSystemMsgTypeStoneUserActionCount];

        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
        
    } else if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-channel/report-channel-order-info") Parameters:@{@"channelId":self.channel.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            JHNimNotificationBody *model = [JHNimNotificationBody mj_objectWithKeyValues:respondObject.data];
            [self.innerView updateActionButtonCount:model.orderCount type:JHSystemMsgTypeStoneOrderCount];
            
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
}

- (JHLiveRoomRedPacketViewModel *)redPacketViewModel {
    if (!_redPacketViewModel) {
        _redPacketViewModel = [[JHLiveRoomRedPacketViewModel alloc] init];
        _redPacketViewModel.isAnchor = YES;
        [_redPacketViewModel reuqestRedListChannelId:self.channel.channelLocalId roomId:self.channel.roomId superView:self.innerView right:12 top:UI.statusBarHeight + 185];
    }
    return _redPacketViewModel;
}

@end

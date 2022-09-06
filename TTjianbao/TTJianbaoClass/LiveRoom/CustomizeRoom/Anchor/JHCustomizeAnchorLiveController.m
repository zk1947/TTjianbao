//
//  NTESLiveViewController.m
//  NIM
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//
#import "JHActivityAlertView.h"
#import "JHCustomizeAnchorLiveController.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "JHAppraiseRedPacketHistoryView.h"
#import "UIView+Toast.h"
#import "NTESMediaCapture.h"
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
#import "NTESConnectQueueView.h"
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
#import "NTESFiterMenuView.h"
#import "NTESVideoQualityView.h"
#import "NTESMirrorView.h"
#import "NTESWaterMarkView.h"
#import "JHCustomizeAnchorInnerView.h"
#import "JHLiveEndPageView.h"
#import "JHRoomUserCardView.h"
#import "JHGemmologistViewController.h"
#import "JHConnectMicPopAlertView.h"
#import "JHCustomizeAnchorLinkView.h"
#import <IQKeyboardManager.h>
#import "NTESLiveBypassView.h"
#import "JHCaptureView.h"
#import "UMengManager.h"
#import "JHLiveRoomDetailView.h"
#import "JHConnetcMicDetailView.h"
#import "JHConnetcMicDetailView.h"
#import "EnlargedImage.h"
#import "JHSendOrderView.h"
#import "NTESMessageModel.h"
#import "JHSendAmountView.h"
#import "JHWaterPrintView.h"
#import "JHWebView.h"
#import "JHGuessAnchourAlertView.h"
#import "JHAudienceOrderListView.h"
#import "JSCoreObject.h"
#import "JHWebViewController.h"
#import "JHMuteListViewController.h"
#import "TTjianbaoUtil.h"
#import <UIButton+WebCache.h>
#import "JHHomeActivityMode.h"
#import "NSString+Common.h"
#import "JHAuthenticateRecordView.h"
#import "JHRoomSendOrderView.h"
#import "JHCustomizeUserOrderView.h"
#import "JHCustomerInfoController.h"
#import "JHBaseOperationView.h"
#import "JHWebImage.h"

#import "JHCustomizeFlyOrderView.h"
#import "JHCustomizeFlyOrderCountCategoryModel.h"
#import "JHStoneMessageModel.h"
#import "JHPublishAnnouncementController.h"
#import "JHBackApplyLinkPoPView.h"
#import "JHLiveApiManager.h"
#import "JHCustomizeOrderFlyListView.h"
#import "JHFansListView.h"

#import "JHShanGouProductInfoView.h"
#import "JHShanGouTypeAlter.h"
#import "JHShanGouProductView.h"
#import "JHFlashSendOrderInputView.h"
#import "JHFlashSendOrderRecordListView.h"
#import "JHShanGouModel.h"
#import "JHFlashSendOrderUserListView.h"

typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);
#define JHRoomFlashSendOrderViewTag 1988

@interface JHCustomizeAnchorLiveController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,NTESLiveAnchorHandlerDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NTESConnectQueueViewDelegate,NTESTimerHolderDelegate,NTESMixAudioSettingViewDelegate,NTESMenuViewProtocol,NTESVideoQualityViewDelegate,NTESMirrorViewDelegate,NTESWaterMarkViewDelegate, JHLiveEndViewDelegate, JHAppraisalLinkerViewDelegate,JHConnetcMicDetailViewDelegate, UIAlertViewDelegate>
{
    NTESTimerHolder *_timer;
    NTESDisconnectAckHandler _ackHandler;
    NSTimer*   __weak countDownTimer;
    int secondsCountDown;
    BOOL isFirstConnector;
    NSString *startTime;
    BOOL  hasShowMemoryWarning;
    NSTimeInterval liveIntime;
}

@property (nonatomic, copy)   NIMChatroom *chatroom;

@property (nonatomic, strong) NIMNetCallMeeting *currentMeeting;

@property (nonatomic, strong) NTESMediaCapture  *capture;

@property (nonatomic, strong) JHCaptureView *captureView;

@property (nonatomic, strong) JHCustomizeAnchorInnerView *innerView;

@property (nonatomic, strong) NTESLiveAnchorHandler *handler;

@property (nonatomic, strong) NTESMixAudioSettingView *mixAudioSettingView;

@property (nonatomic, strong) NTESVideoQualityView *videoQualityView;

@property (nonatomic, strong) NTESMirrorView *mirrorView;

@property (nonatomic, strong) NTESWaterMarkView *waterMarkView;

@property (nonatomic, weak)   id<JHNormalLiveControllerDelegate> delegate;

@property (nonatomic, strong) NTESFiterMenuView *filterView;

@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, strong) JHConnetcMicDetailView * micDetailView;

@property (nonatomic) BOOL audioLiving;

@property (nonatomic) BOOL isflashOn;

@property (nonatomic) BOOL isFocusOn;

@property (nonatomic) BOOL isVideoLiving;

@property (nonatomic) BOOL gameSwitch;

@property (nonatomic, strong)NSMutableArray *audienceArray;

@property (nonatomic, strong)JHCustomizeAnchorLinkView *appraisalList;
@property (nonatomic,strong) JHConnectMicPopAlertView *anchorMicAlert;
@property (nonatomic, strong) JHAuthenticateRecordView *authenticateRecordView;

@property (nonatomic ,assign) BOOL remoteFullScreen;

@property (nonatomic ,assign) BOOL switchMainAreaError;
@property (nonatomic,strong) JHLiveRoomDetailView *roomDetailView; //直播间scrollview 左中右
@property (nonatomic,strong) JHSendOrderView *sendOrderView;
@property (nonatomic,strong) JHSendAmountView *sendAmountView;

@property (nonatomic, strong) JHWaterPrintView  *playLogo;

@property (nonatomic,strong)  BYTimer  *downTimer;

@property (nonatomic,assign) BOOL isLinking;//是否正在连麦

@property (nonatomic,assign) NSInteger trySetMainCount;//设置次数

@property (nonatomic,strong) NSString * gameId;//游戏id
@property (nonatomic, assign) BOOL isCreatAnction;

@property (nonatomic,strong) JHWebView *webActivity;
@property (nonatomic, strong)JHWebView *auctionListWeb;
@property (nonatomic, strong)JHWebView *showWishPaperView;
@property (nonatomic,strong) JHWebView *webSpecialActivity;//指定活动 双11等

@property (nonatomic, assign)JHLiveSDKType  liveType;
///---lh
@property (strong, nonatomic) JHHomeActivityMode *homeActivityMode;

// 上报callID 是否成功
@property (nonatomic, assign) BOOL submitCallIdSuccessed;
@property (nonatomic, assign) NSUInteger submitRetryCount;

//本直播间当次开播已连接成功的用户，用来发定制单
@property (nonatomic, strong) NSMutableArray <NTESMicConnector*>*connecteds;
@property (nonatomic, strong) NSArray *countCategaryArray;//保存定制个数类别数据
@property (nonatomic, strong) JHBackApplyLinkPoPView * reverseLinkView; //反向连麦浮层

@property (nonatomic, strong) JHRoomSendOrderView     *normalOrderView;
@property (nonatomic, strong) JHCustomizeFlyOrderView *packageOrderView; /// 定制套餐
@property (nonatomic, strong) JHCustomizeFlyOrderView *orderView; /// 定制单

@end

@implementation JHCustomizeAnchorLiveController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (void)dealloc
{
    [self buryPointOut];//退出时,埋点
    [self clearSDKNotification]; //清理通知&视频SDK配置
    NSLog(@"&&&&&&Customize Anchor Live释放完毕");
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom capture:(NTESMediaCapture*)capture
{
    if(self = [super initWithNibName:nil bundle:nil])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self registerSDKNotification]; // 注册通知&sdk配置
        _chatroom = chatroom;
        _handler = [[NTESLiveAnchorHandler alloc] initWithChatroom:chatroom];
        _handler.delegate = self;
        if(capture)
            _capture = capture;
        else
            _capture = [[NTESMediaCapture alloc]init];
        
        NSLog(@"&&&&&&Customize Anchor Live开播成功, live room type: %d, current user: %@",
        (int)[NTESLiveManager sharedInstance].type,[[NIMSDK sharedSDK].loginManager currentAccount]);
    }
    return self;
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(NTESMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate
{
    if (self = [self initWithChatroom:chatroom capture:capture])
    {
        _currentMeeting = currentMeeting;
        _delegate = delegate;
        
        _isVideoLiving = YES;
        self.liveType=JHNomalLiveSDK;
        [self submitCallId];
        
        [[NIMAVChatSDK sharedSDK].netCallManager switchVideoQuality:NIMNetCallVideoQuality720pLevel];
    }
    return self;
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom
{
    if (self = [self initWithChatroom:chatroom capture:nil])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self removeNavView];
    self.channel.status=@"2";
    liveIntime = time(NULL);
    //subviews
    [self setUp];
    //请求
    [self fetchAnchorInfo];
    [self getRoomNotice];
    [self getAppraiseRedpeacketStatus];
    [self getAppGameStatus];
    [self getConnectMicQueue];
    //回调设置
    [self checkAuction];
    [self checkActivity];
    [self requestOpenActivity]; /// --- lh
    JHRootController.serviceCenter.channelModel = self.channel; //主播记录channelmodel
    [self buryPointIn]; //进入时,埋点
    [self getCountDataAll];//获取定制个数类别
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _playLogo.centerY = self.innerView.infoView.centerY;
}

//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)setUp
{
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.focusView];
    //视频直播
    if (_isVideoLiving) {
        [NTESLiveManager sharedInstance].type = NTESLiveTypeVideo;
        [_capture switchContainerToView:self.captureView];
        [self.innerView switchToPlayingUI]; // 直播上层，显示view初始化
        [self.view addSubview:self.roomDetailView];
        [self.roomDetailView addSubview:self.innerView];
        self.innerView.frame = CGRectMake(ScreenW, 0, ScreenW, ScreenH);
        [self.innerView updateView];
        
        [self.innerView updateBeautify:self.filterModel.filterIndex];
        [self.innerView updateQualityButton:[NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityHigh];
        //         [[NIMAVChatSDK sharedSDK].netCallManager setPreViewMirror:YES];
        //        [[NIMAVChatSDK sharedSDK].netCallManager setCodeMirror:YES];
        
        //更新画质的通知已经没什么用处了,没有接收者
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchVideoQualityLevel" object:nil];
        if (![self.capture isCameraBack]) {
            [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeMeiyan1];
        }
    }
    
    [self.innerView updateRoleType:JHLiveRoleAnchor];
    self.innerView.type = self.anchorLiveType;
    
    _playLogo = [[JHWaterPrintView alloc] initWithImage:[UIImage imageNamed:@"img_water_print"] roomId:self.channel.roomId];
    _playLogo.mj_x = ScreenW-45-_playLogo.mj_w-10;
   // _playLogo.centerY = UI.statusBarHeight + 10.+ 20;
    _playLogo.centerY = self.innerView.infoView.centerY;
    [self.view insertSubview:_playLogo belowSubview:self.roomDetailView];
    self.innerView.canAppraise = YES;
}

- (void)registerSDKNotification
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [NTESLiveManager sharedInstance].orientation = self.orientation;
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager setVideoCaptureOrientation:[NTESLiveManager sharedInstance].orientation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatShanGouInfoNoticeAction:) name:@"ChatShanGouInfoNotice" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:LOGOUTSUSSNotifaction object:nil];
}

- (void)clearSDKNotification
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_downTimer stopGCDTimer];
}

#pragma mark - request
-(void)getConnectMicQueue{
    
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/appraisal/connectMic/queue")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        DDLogInfo(@"connectMicqueue=%@",respondObject.data);
        
        [[NTESLiveManager sharedInstance] removeAllConnectors];
        
        for (NSDictionary * dic in respondObject.data) {
            NTESMicConnector *connector = [[NTESMicConnector alloc] initWithDictionary:dic];
             [[NTESLiveManager sharedInstance] updateConnectors:connector];
        }
        if (!_appraisalList) {
            [self.view addSubview:self.appraisalList];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_appraisalList reloadData:[NTESLiveManager sharedInstance].connectors];
            [self didUpdateConnectors];
        });
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

//获取定制个数分类数据
-(void)getCountDataAll {
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/customize/fee/template-list") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        self.countCategaryArray = [JHCustomizeFlyOrderCountCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)submitCallId{
    
    if (!self.submitCallIdSuccessed && self.submitRetryCount <= 5) {
        
        NSInteger retryTime = 0;
        if (self.submitRetryCount > 0)
            retryTime = 10 * self.submitRetryCount + 5;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSMutableDictionary *params = [NSMutableDictionary new];
            [params setValue:[NSString  stringWithFormat:@"%llu",self.currentMeeting.callID] forKey:@"thisTimeId"];
            [params setValue:self.channel.meetingName forKey:@"meetingName"];
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/reportId/auth") Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
                self.submitCallIdSuccessed = YES;
            } failureBlock:^(RequestModel *respondObject) {
                [self submitCallId];
            }];
        });
        self.submitRetryCount ++;
    }
}

- (void)getAppraiseRedpeacketStatus{
    JH_WEAK(self)
    [JHAppraiseRedPacketModel asynReqConfigQueryResp:^(NSString* msg, JHAppraiseRedPacketConfigQueryModel* data) {
        
        JH_STRONG(self)
        if(data)
        {
            [self.innerView updateSendRedpacketButton:[data.isStart integerValue]];
        }
    }];
}

-(void)getAppGameStatus{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/appGame/sw") Parameters:nil  successBlock:^(RequestModel *respondObject) {
        self.gameSwitch=[respondObject.data[@"gameSwitch"] boolValue];
        DDLogInfo(@" self.gameSwitch=%@",respondObject);
        [self.innerView updateGuessButton:self.gameSwitch];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)submitConnectMicStart:(NSString*)customizeId{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/start") Parameters:@{@"customizeId":customizeId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

-(void)submitReverseConnectMicStart:(NSString*)customizeId{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/start") Parameters:@{@"customizeId":customizeId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [_appraisalList hiddenAlert];
    [_authenticateRecordView hiddenAlert];
    MJWeakSelf
    
    
    if (touches.count == 2) {
        return;
    }
    if (touches.count) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        
        //判断是否进行手动对焦显示
        [self doManualFocusWithPointInView:point];
    }
}

#pragma mark - 埋点
- (void)buryPointIn
{
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.anchorLiveType > JHAnchorLiveAppraiseType?2:1;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] liveInBuryWithModel:model];
}

- (void)buryPointOut
{
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.anchorLiveType > JHAnchorLiveAppraiseType?2:1;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] liveOutBuryWithModel:model];
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
        for (NIMMessage *message in messages) {
        
        if (![message.session.sessionId isEqualToString:self.chatroom.roomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
            DDLogWarn(@"yy=onRecvMessages  不属于这个聊天室信息roomId %@ sessionType :%ld", message.session.sessionId, (long)message.session.sessionType);
            continue;
        }

        switch (message.messageType) {
            case NIMMessageTypeText:
                [self.innerView addMessages:@[message]];
                break;
            case NIMMessageTypeCustom:
            {
                NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
                id<NIMCustomAttachment> attachment = object.attachment;
                
                if ([attachment isKindOfClass:[JHSystemMsgAttachment class]]) {
                    
                    JHSystemMsgType type = ((JHSystemMsgAttachment *)attachment).type;
                    if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeEndLive) {
                        
                        break;
                    } else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypePresent) {
                        [self.innerView addPresentModel:(JHSystemMsg *)attachment];
                        [self.innerView addMessages:@[message]];
                        
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
                    }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeActivityNotification) {
                        ///--- lh
                        [self.webSpecialActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        
                        [self.webActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        [self.auctionListWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        [self.innerView.auctionWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];

                        break;
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRoomWatchCount) {
                        //直播间观看人数变化
                    self.channel.watchTotal =((JHSystemMsgAttachment *)attachment).watchTotal;
                    [self.innerView refreshChannel:self.channel];
                    break;
                    }
                    
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeEndAppraisal){
                        message.from = ((JHSystemMsgAttachment *)attachment).accid;
                        NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                        dic[@"customerId"] = ((JHSystemMsgAttachment *)attachment).customerId;
                        ext.roomExt = [dic mj_JSONString];
                        message.messageExt = ext;

                        [self.innerView addMessages:@[message]];
                    }
                    else if(type == JHSystemMsgTypeShopwindowRefreash)///橱窗弹框刷新
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotification" object:nil];
                    }
                    
                    else if(type == JHSystemMsgTypeShopwindowCount)///橱窗弹框数量刷新
                    {
                        NSDictionary *dataDic = ((JHSystemMsgAttachment *)attachment).data.mj_JSONObject;
                        NSDictionary *body = [dataDic valueForKey:@"body"];
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
                    //显示定制中的订单
                   else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeShowCustomizeOrder) {
                       
                       NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                       JHSystemMsgCustomizeOrder * model = [JHSystemMsgCustomizeOrder mj_objectWithKeyValues:dataDic[@"body"]];
                       [self.innerView setLeftCustomizeOrderHidden:YES withModel:model];
                       
                   }
                   //移除定制中的订单
                   else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRemoveCustomizeOrder) {
                       
                       [self.innerView setLeftCustomizeOrderHidden:NO withModel:nil];
                       
                   }
                   else if(type == JHSystemMsgTypeShopwindowAddGoods || type == JHSystemMsgTypeShopwindowRefreash || type == JHSystemMsgTypeShopwindowCount || type == JHSystemMsgTypeShopwindowAudienceCount)
                    {
                        return;
                    }
                                  
                    //填坑 <4000 的不特殊处理 默认飘屏和公聊 以后在增加4000以上的
                    else if (((JHSystemMsgAttachment *)attachment).type<JHSystemMsgTypeRoomWatchCount) {
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
            DDLogInfo(@"连麦队列更新connectors.count=%lu",(unsigned long)[NTESLiveManager sharedInstance].connectors.count);
            [self didUpdateConnectors];
            
            break;
        case NTESLiveCustomNotificationTypeAssistantReceived:
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameUpdateOrderNumber" object:nil];
            break;
        case NTESLiveCustomNotificationTypeAssistantCustomizeReceived:
        case NTESLiveCustomNotificationTypeAssistantCustomizeReceived_Two:
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

#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    if (_reverseLinkView) {
        [_reverseLinkView removeSelf];
        _reverseLinkView = nil;
    }
    [countDownTimer invalidate];
    [self.downTimer stopGCDTimer];
    [_appraisalList hiddenAlert];
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
    if (!connector) {
        DDLogInfo(@"connector 不在连麦队列里");
        NSDictionary * parameters=@{
                                    @"timeSpend":@"0",
                                    @"wyAccid":uid
                                    };
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
        return;
    }
    
    self.isLinking = YES;
   // [self.view makeToast:@"连麦成功" duration:2.0 position:CSToastPositionCenter];
    
    _appraisalList.statusType=2;
    
    startTime=[CommHelp getNowTimeTimestamp];
    
    DDLogInfo(@"on user joined uid %@",uid);
 
    if (connector) {
        connector.state = NTESLiveMicStateConnected;
        
        [[NTESLiveManager sharedInstance] addConnectorOnMic:connector];
        
        __block BOOL isHas = NO;
        [self.connecteds enumerateObjectsUsingBlock:^(NTESMicConnector *subConnector, NSUInteger idx, BOOL * _Nonnull stop) {
            if([subConnector.uid isEqualToString:connector.uid]){
                isHas = YES;
                //若存在就替换
                [self.connecteds replaceObjectAtIndex:idx withObject:connector];
                *stop = YES;
            }
        }];
        //若不存在就添加
        if(!isHas){
            [self.connecteds addObject:connector];
        }
        //将连麦者的GLView扔到右下角，并显示名字
        DDLogInfo(@"yy===开始创建小窗 %@", uid);
        [self.innerView switchToBypassStreamingUI:connector];
        
        //发送全局已连麦通知
        [self sendConnectedNotify:connector];
        
        //把鉴定id传给后台
        if (connector.connectType == 1) {
            [self submitReverseConnectMicStart:connector.customizeRecordId];
        }else{
            [self submitConnectMicStart:connector.customizeRecordId];
        }
        
        isFirstConnector = YES;
        
        DDLogInfo(@"yy===连麦开始 切换用户为大窗口 %@",uid);
        [self onSwitchMainScreenWithUid:uid];
        
        if (self.capture.cameraType == NIMNetCallCameraBack) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"系统检测到您当前为后置摄像头，请切换至前置摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"立即切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.capture switchCamera];
            }]];
        [self presentViewController:alert animated:YES completion:nil];
            
        }
    } else{
        DDLogError(@"未找到 uid %@", uid);
        NSString *string = @" all connector";
        for (NTESMicConnector *m in [NTESLiveManager sharedInstance].connectors) {
            string = [NSString stringWithFormat:@"%@%@",string, m.uid];
        }
        DDLogInfo(@"%@", string);
    }
}
- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    [self handleUserLeftMeetingFromUid:uid];
}
-(void)handleUserLeftMeetingFromUid:(NSString*)uid{
    
    [self.innerView setLeftCustomizeOrderHidden:NO withModel:nil];
   DDLogInfo(@"on user left %@",uid);
   NSMutableArray *uids = [[NTESLiveManager sharedInstance] uidsOfConnectorsOnMic];
   DDLogInfo(@"current on mic user is [%@]", [uids componentsJoinedByString:@" "]);
  //DDLogInfo(@"current on mic user is %@",[NTESLiveManager sharedInstance].connectorOnMic.uid);
   NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
    if (!connector) {
        return;
    }
    self.isLinking = NO;
 //   [self.view makeToast:@"用户已断开连麦" duration:2.0 position:CSToastPositionCenter];
    
    //弹出鉴定报告
    _appraisalList.statusType=0;
    [_appraisalList hiddenAlert];
 
//    if (!self.sendedReporterList[connector.appraiseRecordId]) {
//        self.reporter.micModel = connector;
//        [self.view addSubview:self.reporter];
//        [self.reporter showAlert];
//    }
    
    //上传连麦中离开时间
    [self connecterLeft:uid];
    
    //从排队队列删除
    [[NTESLiveManager sharedInstance] removeConnectors:uid];
    
      //从上麦队列删除
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    //  [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:uid];
 
    if (_appraisalList) {
        [_appraisalList reloadData:[NTESLiveManager sharedInstance].connectors];
    }
    
    //更新state,变为初始状态
    [self.connecteds enumerateObjectsUsingBlock:^(NTESMicConnector *subConnector, NSUInteger idx, BOOL * _Nonnull stop) {
        if([subConnector.uid isEqualToString:uid]){
            //若存在就替换
            subConnector.state = NTESLiveMicStateNone;
            *stop = YES;
        }
    }];
    
    [self didUpdateConnectors];
    
    //发送全局连麦者断开的通知
    
    NTESMicConnector *connectorOnMic = [[NTESLiveManager sharedInstance] connectorOnMicWithUid:uid];
    [self sendDisconnectedNotify:connectorOnMic];
    
    if (self.packageOrderView) {
        if (connectorOnMic.state == NTESLiveMicStateConnected) {
            self.packageOrderView.isConnecting = YES;
        } else {
            self.packageOrderView.isConnecting = NO;
        }
    }
    if (self.orderView) {
        if (connectorOnMic.state == NTESLiveMicStateConnected) {
            self.orderView.isConnecting = YES;
        } else {
            self.orderView.isConnecting = NO;
        }
    }
    
    //刷新小窗画面
       [self.innerView switchToPlayingUI];
    
    //可能是强制要求对面离开，这个时候肯定记录了回调，尝试回调
    if (_ackHandler) {
        _ackHandler(nil);
        _ackHandler = nil;
        _timer = nil;
    }

    [self.captureView removeFromSuperview];
     self.captureView = nil;
    [self.view addSubview:self.captureView];
    [self.view sendSubviewToBack: self.captureView];
    
    
    self.remoteFullScreen = YES;
    [self onSwitchMainScreenWithUid:self.chatroom.creator];
    
    [JHWebImage clearCacheMemory];
}
- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    DDLogError(@"on meeting error: %d", (int)error.code);
    [self.view.window makeToast:[NSString stringWithFormat:@"互动直播失败 code: %d", (int)error.code]
                       duration:2.0
                       position:CSToastPositionCenter];
    
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    
    [self.capture stopLiveStream];
    [self.capture stopVideoCapture];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.currentMeeting];
    [countDownTimer invalidate];
    [[NTESLiveManager sharedInstance] stop];
    MJWeakSelf
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.chatroom.roomId completion:^(NSError * _Nullable error) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    //  NSLog(@"onRemoteYUVReady");
     NTESMicConnector *connector =  [[NTESLiveManager sharedInstance] connectorOnMicWithUid:user];
    if (!connector) {
           NSLog(@"上麦流用户不存在");
        return;
    }
  
    if (_remoteFullScreen) {
        [self.captureView render:yuvData width:width height:height];
        
    }else {
        [self.innerView updateRemoteView:yuvData width:width height:height uid:user];
    }
}


-(void)onCameraTypeSwitchCompleted:(NIMNetCallCamera)cameraType
{
    if (cameraType == NIMNetCallCameraBack) {
        // 镜像关闭
        [self.mirrorView setMirrorDisabled];
        [self.innerView updateMirrorButton:NO];
        
        [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeNormal];
        
        _isFocusOn = YES;
    }
    else
    {
        [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeMeiyan1];
        //镜像重置
        //        [self.mirrorView resetMirror];
        //        [[NIMAVChatSDK sharedSDK].netCallManager setCodeMirror:YES];
        
        //闪光灯关闭 - 设置button图片
        _isflashOn = NO;
        [self.innerView updateflashButton:NO];
        
        //手动对焦关闭
        _isFocusOn = NO;
        [self.innerView updateFocusButton:NO];
        self.focusView.hidden = YES;
    }
    
    [self.innerView resetZoomSlider];
}

-(void)onCameraOrientationSwitchCompleted:(NIMVideoOrientation)orientation
{
    [self.capture onCameraOrientationSwitchCompleted:orientation];
}

- (void)onNetStatus:(NIMNetCallNetStatus)status user:(NSString *)user
{
//    if ([user isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
//        [self.innerView updateNetStatus:status];
//    }
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

- (void)didUpdateConnectors
{
    
    DDLogInfo(@"did update connectors");
    [self.innerView updateConnectorCount:[[NTESLiveManager sharedInstance] connectors:NTESLiveMicStateWaiting].count];
}
- (void)reverseLinkUserCancel{
    if (_reverseLinkView) {
        [_reverseLinkView removeSelf];
    }
}
- (void)didUpdateChatroomMemebers:(BOOL)isAdd {
    if (isAdd) {
        self.channel.watchTotal ++;
    } else {
        self.channel.watchTotal --;
    }

    self.channel.watchTotal = (self.channel.watchTotal < 0 ? 0 : self.channel.watchTotal);
    
    [self.innerView refreshChannel:self.channel];
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:self.chatroom.roomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%d",roomId, (int)reason);
        [self.capture stopLiveStream];
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

#pragma mark - NTESLiveInnerViewDelegate

//断开连麦
- (void)closeLinkAction:(NSString *)uid{
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"确定要断开与用户的连麦吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
//    [alert addBackGroundTap];
    [self.view addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self forceEndConnectMic:uid];
    };
    
}
- (void)onShanGouBtnAction{
    @weakify(self);
    NSString *url = FILE_BASE_STRING(@"/app/flash/sales/product/anchor");
    [SVProgressHUD show];
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

#pragma mark - 闪购弹框事件
- (void)shanGouSeletedIndex:(JHShanGouTypeAlter_Action)index  andName:(NSString *)name andTypeId:(NSString *)typeId{
    switch (index) {

        case JHShanGouTypeAlter_CreatProduct:{
            JHFlashSendOrderInputView *view = [[JHFlashSendOrderInputView alloc] init];
            if ([typeId isEqualToString:@"normal"]) {
                view.flashStyle = JHFlashSendOrderStyle_NormalOrder;
            } else if ([typeId isEqualToString:@"processingOrder"]) {
                view.flashStyle = JHFlashSendOrderStyle_ProcessOrder;
            } else if ([typeId isEqualToString:@"giftOrder"]) {
                view.flashStyle = JHFlashSendOrderStyle_WelfareOrder;
            }
            view.anchorId = self.channel.anchorId;
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

- (void)onShowAuctionListView:(UIButton *)btn {
    JHWebView *web = [[JHWebView alloc] init];
    [web jh_loadWebURL:AuctionListURL((int)(self.anchorLiveType >= JHAnchorLiveSaleType),1,(int)self.channel.isAssistant)];
    
    web.frame = self.innerView.bounds;
    JH_WEAK(self)
    web.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
    web.operateActionScreenCapture = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        JH_STRONG(self)
        self.innerView.hidden = YES;
        self.auctionListWeb.hidden = YES;
        self.isCreatAnction = YES;
        [self cameraScreen];

    };
    web.operateActionAuctionSendOrder = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        JH_STRONG(self)
        NSDictionary *dic = [jsonString mj_JSONObject];
        self.sendOrderView.hidden = YES;
        [self.innerView addSubview:self.sendOrderView];
        self.sendOrderView.customerId = dic[@"viewerId"];
        self.sendOrderView.biddingId = dic[@"biddingId"];
        [self.sendOrderView sendOrderAction:[NSNull null]];

    };
    self.auctionListWeb = web;
    [self.innerView addSubview:web];
}

- (void)beginCamaro {
    [self cameraScreen];
}

- (void)onShareAction {
    NSString *url = [NSString stringWithFormat:@"%@channelid=%@&code=%@", [UMengManager shareInstance].shareLiveUrl, self.channel.channelLocalId, [UserInfoRequestManager sharedInstance].user.invitationCode];
    
    if (self.anchorLiveType == JHAnchorLiveAppraiseType) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];
        NSString *title = [NSString stringWithFormat:ShareLiveAppraiseTitle,self.channel.anchorName];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveAppraiseText thumbUrl:nil webURL:url type:ShareObjectTypeAppraiseLive object:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveAppraiseText;
        info.shareType = ShareObjectTypeAppraiseLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}]; //TODO:Umeng share
     }
    else if(self.anchorLiveType == JHAudienceUserRoleTypeCustomize || self.anchorLiveType == JHAudienceUserRoleTypeCustomizeAssistant){

        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=7"]];
        
        NSString *text = [NSString stringWithFormat:ShareLiveCustomizeText,self.channel.anchorName];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:ShareLiveCustomizeTitle text:text thumbUrl:nil webURL:url type:ShareObjectTypeCustomizeLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = ShareLiveCustomizeTitle;
        info.desc = text;
        info.shareType = ShareObjectTypeCustomizeLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}]; //TODO:Umeng share
    }
    else {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=2"]];
        
        NSString *title = [NSString stringWithFormat:ShareLiveSaleTitle,self.channel.anchorName];
        
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveSaleText thumbUrl:nil webURL:url type:ShareObjectTypeSaleLive object:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveSaleText;
        info.shareType = ShareObjectTypeSaleLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.roomId,@"roomId":self.channel.roomId}]; //TODO:Umeng share
    }
}

- (void)onAppraiseWithType:(NSInteger)stateType {
    //主播操作 结束鉴定等
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
        
           
    NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];      dic[@"roomRole"] = @(JHRoomRoleAnchor);

    ext.roomExt = [dic mj_JSONString];
    message.messageExt = ext;
    NIMSession *session = [NIMSession session:self.chatroom.roomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}
- (void)onActionType:(NTESLiveActionType)type sender:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    switch (type) {
        case NTESLiveActionTypeLive:{
            if (!self.capture.isLiveStream) {
                [self.capture startLiveStreamHandler:^(NIMNetCallMeeting * _Nonnull meeting, NSError * _Nonnull error) {
                    if (error) {
                        [weakSelf.view makeToast:@"直播初始化失败"];
                        [weakSelf.innerView switchToWaitingUI];
                        DDLogError(@"start error:%@",error);
                    }else
                    {
                        //将服务器连麦请求队列清空
                        [[NIMSDK sharedSDK].chatroomManager dropChatroomQueue:weakSelf.chatroom.roomId completion:nil];
                        //发一个全局断开连麦的通知给观众，表示之前的连麦都无效了
                        [weakSelf sendDisconnectedNotify:nil];
                        weakSelf.audioLiving = YES;
                        weakSelf.currentMeeting = meeting;
                        [weakSelf.innerView switchToPlayingUI];
                    }
                }];
            }
        }
            break;
        case NTESLiveActionTypePresent:{
            NTESPresentBoxView *box = [[NTESPresentBoxView alloc] initWithFrame:self.view.bounds];
            [box show];
            break;
        }
        case NTESLiveActionTypeCamera:
            [self.capture switchCamera];
            
            
            break;
        case NTESLiveActionTypeMute:
            sender.selected = !sender.selected;
            [[NIMAVChatSDK sharedSDK].netCallManager setMute:sender.selected];
            
            break;
        case NTESLiveActionTypeWishPaper: {
            
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"我的心愿单";
            vc.urlString = ShowWishPaperURL((int)(weakSelf.anchorLiveType >= JHAnchorLiveSaleType),1,(int)weakSelf.channel.isAssistant);
            [weakSelf.navigationController pushViewController:vc animated:YES];

        }
            
            break;
            
            case NTESLiveActionTypeMuteList: {
                
                JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }
            
            break;
        case NTESLiveActionTypeInteract:{
            NTESConnectQueueView *queueView = [[NTESConnectQueueView alloc] initWithFrame:self.view.bounds];
            queueView.delegate = self;
            [queueView refreshWithQueue:[[NTESLiveManager sharedInstance] connectors: NTESLiveMicStateWaiting]];
            [queueView show];
        }
            break;
        case NTESLiveActionTypeBeautify:{
            [self.filterView show];
            
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
            [self shareStreamUrl];
        }
            break;
        case NTESLiveActionTypeQuality:{
            [self.videoQualityView show];
        }
            break;
        case NTESLiveActionTypeMirror:{
            if ([self.capture isCameraBack]) {
                [_mirrorView setMirrorDisabled];
                [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:1.0 position:CSToastPositionCenter];
            }
            else
            {
                [self.mirrorView show];
            }
        }
            break;
        case NTESLiveActionTypeWaterMark:{
            [self.waterMarkView show];
        }
            break;
        case NTESLiveActionTypeFlash:{
            NSString * toast ;
            if ([self.capture isCameraBack]) {
                _isflashOn = !_isflashOn;
                [[NIMAVChatSDK sharedSDK].netCallManager setCameraFlash:_isflashOn];
                toast = _isflashOn ? @"闪光灯已打开" : @"闪光灯已关闭";
                UIButton * button = (UIButton *)sender;
                [button setImage: [UIImage imageNamed:_isflashOn ? @"icon_flash_on_n" :@"icon_flash_off_n"] forState:UIControlStateNormal];
            }
            else
            {
                toast = @"前置摄像头模式，无法使用闪光灯";
            }
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
        }
            break;
        case NTESLiveActionTypeFocus:
        {
            NSString * toast ;
            if ([self.capture isCameraBack]) {
                _isFocusOn = !_isFocusOn;
                self.focusView.hidden = YES;
                toast = _isFocusOn ? @"手动对焦已打开" : @"手动对焦已关闭，启动自动对焦模式";
                if (!_isFocusOn) {
                    [[NIMAVChatSDK sharedSDK].netCallManager setFocusMode:NIMNetCallFocusModeAuto];
                }
                
                UIButton * button = (UIButton *)sender;
                button.selected = !button.selected;
                //                [button setImage:[UIImage imageNamed:_isFocusOn ? @"icon_focus_on_n" : @"icon_focus_off_n"] forState:UIControlStateNormal];
                //                [button setImage:[UIImage imageNamed:_isFocusOn ? @"icon_focus_on_p" : @"icon_focus_off_p"] forState:UIControlStateHighlighted];
            }
            else
            {
                toast = @"前置摄像头模式，无法手动调焦";
            }
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
        case NTESLiveActionTypeSendRedPacket:
        {
            [[JHAppraiseRedPacketHistoryView new] showWithAppraiserId:self.channel.anchorId channelId:self.channel.channelLocalId];
        }
            break;
        case NTESLiveActionTypeAnnouncement: {
            JHPublishAnnouncementController *paController = [JHPublishAnnouncementController new];
            paController.channelId = self.channel.channelLocalId;
            paController.channel = self.channel;
            [self.navigationController pushViewController:paController animated:YES];
        }
        default:
            break;
    }
}

-(void)onTapChatView:(CGPoint)point
{
    [self doManualFocusWithPointInView:point];
}
- (void)onAppraiseList {
    
    if (!_appraisalList) {
        [self.view addSubview:self.appraisalList];
    }
    [_appraisalList reloadData:[NTESLiveManager sharedInstance].connectors];
    [_appraisalList showAlert];
}

- (void)onCanAppraiseAction:(UIButton *)btn {
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/channel/canCustomize/auth") Parameters:@{@"yesOrNo":@(btn.selected)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        //        btn.selected = !btn.selected;
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
#pragma mark - NTESVideoQualityViewDelegate

- (void)onVideoQualitySelected:(NTESLiveQuality)type
{
    NIMNetCallVideoQuality q;
    
    switch (type) {
        case NTESLiveQualityNormal:
            q = NIMNetCallVideoQuality480pLevel;
            break;
        case NTESLiveQualityHigh:
            q = NIMNetCallVideoQuality720pLevel;
            break;
        default:
            q = [NTESUserUtil defaultVideoQuality];
            break;
    }
    
    BOOL success = [[NIMAVChatSDK sharedSDK].netCallManager switchVideoQuality:q];
    DDLogInfo(@"switch video quality: %d success %@", (int)type,(success?@"Y":@"N"));
    if (success) {
        [NTESLiveManager sharedInstance].liveQuality = type;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchVideoQualityLevel" object:nil];
    }else{
        [self.view makeToast:@"分辨率切换失败"];
    }
    
    NIMNetCallNetStatus status = [[NIMAVChatSDK sharedSDK].netCallManager netStatus:[NIMSDK sharedSDK].loginManager.currentAccount];
    [self.innerView updateNetStatus:status];
    
    [self.videoQualityView dismiss];
    [self.innerView updateQualityButton:type == NTESLiveQualityHigh];
    [self.innerView resetZoomSlider];
    
    //重置水印状态
    [self.innerView updateWaterMarkButton:NO];
    [self.waterMarkView reset];
    
    //重置闪光灯状态
    _isflashOn = NO;
    [self.innerView updateflashButton:NO];
}

-(void)onVideoQualityViewCancelButtonPressed
{
    [self.videoQualityView dismiss];
}

#pragma mark - NTESConnectQueueViewDelegate
- (void)onSelectMicConnector:(NTESMicConnector *)connector
{
    //点击头像同意连麦
    if (connector.state == NTESLiveMicStateWaiting) {
        __weak typeof(self) weakSelf = self;
        if (![[NTESLiveManager sharedInstance] canAddConnectorOnMic])
        {
            [weakSelf.view makeToast:@"当前正在连麦中" duration:2.0 position:CSToastPositionCenter];
        }
        else
        {
            _appraisalList.statusType=1;
            [self addTimerByConnect:connector];
            
            // 发送连麦申请
            [self agreeMicConnector:connector handler:^(NSError *error) {
              
            }];
        }
    }
}

- (void)onCloseLiving{
    
    if (!((NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeAudio&&!self.audioLiving)) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定结束直播吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"离开", nil];
            [alert showAlertWithCompletionHandler:^(NSInteger index) {
                switch (index) {
                    case 1:{
                        [self exitLive];
                        break;
                    }
                    default:
                        break;
                }
            }];
        }
        else
        {
            if (self.innerView.claimOrderListView.isAppraising) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"还有未结束订单，不能结束直播！" preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
                
                [self presentViewController:alertVc animated:YES completion:nil];
                return;
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"确定结束直播吗？" preferredStyle:UIAlertControllerStyleAlert];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self exitLive];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
        }
    }
    else
    {
        [self exitLive];
    }
}

- (void)exitLive {
    //! 停播上报接口，不成功不能退出直播
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/customerEndShow/auth") Parameters:@{@"channelId":[NSString  stringWithFormat:@"%@",self.channel.channelLocalId]} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self doExitLive];
    } failureBlock:^(RequestModel *respondObject) {
        if(respondObject.message)
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        else
            [SVProgressHUD dismiss];
    }];
}

- (void)doExitLive
{
    NSInteger dur = 0;
    if (liveIntime>0) {
        dur = time(NULL)-liveIntime;
    }
    
    [JHTracking trackEvent:@"endLive" property:@{@"live_duration":@(dur),@"channel_id":self.channel.channelId,@"channel_name":self.channel.title,@"channel_local_id":self.channel.channelLocalId}];
    [self.capture stopLiveStream];
    [self.capture stopVideoCapture];
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.currentMeeting];
    
    [countDownTimer invalidate];
    [[NTESLiveManager sharedInstance] stop];
    
    MJWeakSelf
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.chatroom.roomId completion:^(NSError * _Nullable error) {
        [weakSelf dismissToRootViewController];
        [JHRootController exitApp];
    }];
}

-(void)loginOut{
    
    [self doExitLive];
}

- (void)onSwitchMainScreenWithUid:(NSString *)uid {
    //    if (self.switchMainAreaError) {
    //        return;
    //    }
    
    self.remoteFullScreen = !self.remoteFullScreen;
    
    NSString *mainUid = uid;
    if (self.remoteFullScreen) {
        NTESLiveBypassView *view = self.innerView.liveBypassView;
        if (!view.localVideoDisplayView) {
            view.localVideoDisplayView = [[UIView alloc] initWithFrame:view.bounds];
            view.localVideoDisplayView.userInteractionEnabled = NO;
        }
     
        [self.capture switchContainerToView:view.localVideoDisplayView];
        [self.innerView.liveBypassView refresh:nil status:NTESLiveBypassViewStatusLocalVideo];
    } else {
        mainUid = self.chatroom.creator;
        [self.capture switchContainerToView:self.captureView];
        [self.innerView.liveBypassView refresh:nil status:NTESLiveBypassViewStatusStreamingVideo];
    }
    
    DDLogInfo(@"yy===本地切换大小窗口成功 主窗口uid %@", mainUid);
    
    if (self.isLinking) {
        self.trySetMainCount = 0;
        [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                 selector:@selector(setMainAreaWithId:) object:mainUid];
        [self setMainAreaWithId:mainUid];
    }
}

- (void)setMainAreaWithId:(NSString *)mainUid {
    //设置主画面
    if (self.trySetMainCount>5 || self.isLinking == NO) {
        return;
    }
    [[NIMAVChatSDK sharedSDK].netCallManager setAsMainArea:mainUid
                                                completion:^(NSError * _Nonnull error) {
                                                    if (!error) {
                                                        self.switchMainAreaError = NO;
                                                        [self.view makeToast:[NSString stringWithFormat:@"切换主画面成功"] duration:1.0 position:CSToastPositionBottom];
                                                        NSLog(@"uid====%@ ==== 切换成功", mainUid);
                                                        DDLogInfo(@"yy===远程切换大小窗口成功 主窗口uid %@", mainUid);
                                                    }
                                                    else
                                                    {
                                                        NSLog(@"uid====%@ ==== 切换失败", mainUid);
                                                        DDLogError(@"yy===远程切换大小窗口失败,目标大窗口uid %@",mainUid);
                                                        self.switchMainAreaError = YES;
                                                        [self performSelector:@selector(setMainAreaWithId:) withObject:mainUid afterDelay:3.];
                                                    }
                                                }];
}

- (void)onLocalDisplayviewReady:(UIView *)displayView {
    
}
- (void)onCloseBypassingWithUid:(NSString *)uid
{
    //主播关闭连麦
    if (![[NTESDevice currentDevice] canConnectInternet]) {
        [self.view makeToast:@"当前无网络,请稍后重试" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    
    //可能这个时候都没连上,或者连上了在说话
    __block NTESMicConnector *connector = nil;
    __block BOOL isConnecting = NO;
    [[[NTESLiveManager sharedInstance] connectors:NTESLiveMicStateConnecting] enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:connector.uid]) {
            connector = obj;
            isConnecting = YES;
            *stop = YES;
        }
    }];
    
    //等待连接中没找到，去已上麦里找
    if (!connector) {
        connector = [[NTESLiveManager sharedInstance] connectorOnMicWithUid:uid];
    }
    
    //NTESMicConnector *connector = [[NTESLiveManager sharedInstance] connectors:NTESLiveMicStateConnecting].firstObject;
    //NSString *uid = connector? connector.uid : [NTESLiveManager sharedInstance].connectorOnMic.uid;
    
    DDLogInfo(@"anchor close by passing");
    
    if (connector)
    {
        if (isConnecting)
        {
            DDLogInfo(@"anchor close when user is connecting uid: %@",uid);
            //还没有进入房间的情况
            [[NTESLiveManager sharedInstance] removeConnectors:uid];
            [self.innerView switchToPlayingUI];
            [self forceDisconnectedUser:uid handler:nil];
        }
        else
        {
            //进入房间了，就等等到那个人真的走了
            DDLogInfo(@"anchor close when user is connected uid: %@",uid);
            
            [SVProgressHUD show];
            [self forceDisconnectedUser:uid handler:^(NSError *error) {
                [SVProgressHUD dismiss];
                if (error)
                {
                    DDLogError(@"on close bypassing error: force disconnect user error %d", (int)error.code);
                }
                else
                {
                    [self.innerView switchToPlayingUI];
                }
            }];
        }
    }
    else
    {
        DDLogWarn(@"unfind uid info, unknown error.");
    }
}

#pragma mark - NTESMixAudioSettingViewDelegate
- (void)didSelectMixAuido:(NSURL *)url
               sendVolume:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume
{
    NIMNetCallAudioFileMixTask *task = [[NIMNetCallAudioFileMixTask alloc] initWithFileURL:url];
    task.sendVolume = sendVolume;
    task.playbackVolume = playbackVolume;
    [[NIMAVChatSDK sharedSDK].netCallManager startAudioMix:task];
}

- (void)didPauseMixAudio
{
    [[NIMAVChatSDK sharedSDK].netCallManager pauseAudioMix];
}

- (void)didResumeMixAudio
{
    [[NIMAVChatSDK sharedSDK].netCallManager resumeAudioMix];
}

- (void)didUpdateMixAuido:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume
{
    NIMNetCallAudioFileMixTask *task = [NIMAVChatSDK sharedSDK].netCallManager.currentAudioMixTask;
    if (task) {
        task.sendVolume = sendVolume;
        task.playbackVolume = playbackVolume;
        [[NIMAVChatSDK sharedSDK].netCallManager updateAudioMix:task];
    }
}

#pragma mark - NTESMenuViewProtocol
- (void)menuView:(NTESFiterMenuView *)menu didSelect:(NSInteger)index
{
    [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:(NIMNetCallFilterType)[NTESLiveUtil changeToLiveType:index]];
}

- (void)menuView:(NTESFiterMenuView *)menu contrastDidChanged:(CGFloat)value
{
    [[NIMAVChatSDK sharedSDK].netCallManager setContrastFilterIntensity:value];
}

- (void)menuView:(NTESFiterMenuView *)menu smoothDidChanged:(CGFloat)value
{
    [[NIMAVChatSDK sharedSDK].netCallManager setSmoothFilterIntensity:value];
}

-(void)onFilterViewCancelButtonPressed
{
    [self.filterView dismiss];
}

-(void)onFilterViewConfirmButtonPressed
{
    [self.filterView dismiss];
    [self.innerView updateBeautify:self.filterView.selectedIndex];
}

#pragma mark - NTESMirrorViewDelegate

-(void)onPreviewMirror:(BOOL)isOn
{
    if ([self.capture isCameraBack]) {
        [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:2.0 position:CSToastPositionCenter];
        self.mirrorView.isPreviewMirrorOn = NO;
        return;
    }
    self.mirrorView.isPreviewMirrorOn = isOn;
    //    [[NIMAVChatSDK sharedSDK].netCallManager setPreViewMirror:isOn];
}

-(void)onCodeMirror:(BOOL)isOn
{
    if ([self.capture isCameraBack]) {
        [self.view makeToast:@"后置摄像头模式，无法使用镜像" duration:2.0 position:CSToastPositionCenter];
        self.mirrorView.isCodeMirrirOn = NO;
        return;
    }
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

#pragma mark - NTESWaterMarkViewDelegate

-(void)onWaterMarkCancelButtonPressed
{
    [self.waterMarkView dismiss];
}

-(void)onWaterMarkTypeSelected:(NTESWaterMarkType)type
{
    UIImage *image = [UIImage imageNamed:@"icon_waterMark"];
    
    CGRect rect ;
    
    CGFloat topOffset = 30 ;
    
    if ([NTESLiveManager sharedInstance].liveQuality == NTESLiveQualityNormal) {
        rect = CGRectMake(10, 10 + topOffset, 110/1.5, 40/1.5);
    }
    else
    {
        rect = CGRectMake(10, 10 + topOffset * 1.5, 110, 40);
    }
    
    switch (type) {
        case NTESWaterMarkTypeNone:
            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            break;
            
        case NTESWaterMarkTypeNormal:
            
            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            [[NIMAVChatSDK sharedSDK].netCallManager addWaterMark:image rect:rect location:NIMNetCallWaterMarkLocationRightUp];
            break;
            
        case NTESWaterMarkTypeDynamic:
        {
            NSMutableArray *array = [NSMutableArray array];
            for (NSInteger i = 0; i < 23; i++) {
                NSString *str = [NSString stringWithFormat:@"水印_%ld.png",(long)i];
                UIImage* image = [UIImage imageNamed:[[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:str]];
                [array addObject:image];
            }
            
            [[NIMAVChatSDK sharedSDK].netCallManager cleanWaterMark];
            [[NIMAVChatSDK sharedSDK].netCallManager addDynamicWaterMarks:array fpsCount:4 loop:YES rect:rect location:NIMNetCallWaterMarkLocationRightUp];
        }
            break;
        default:
            break;
    }
    
    [self.innerView updateWaterMarkButton:type != NTESWaterMarkTypeNone];
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

#pragma mark - Private
- (void)forceDisconnectedUser:(NSString *)uid handler:(NTESDisconnectAckHandler)handler
{
    if (!uid.length) {
        DDLogError(@"force disconnect error : no user id!");
        handler(nil);
        return;
    }
}

- (void)agreeMicConnector:(NTESMicConnector *)connector handler:(NTESAgreeMicHandler)handler
{
    __weak typeof(self) weakSelf = self;
    NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationWithAgreeMic:self.chatroom.roomId style:connector.type];
    NIMSession *session = [NIMSession session:connector.uid type:NIMSessionTypeP2P];
    DDLogError(@"anchor: agree mic: %@",connector.uid);
    [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:^(NSError * _Nullable error) {
        
        connector.state=NTESLiveMicStateWait;
        //        if (!error) {
        //
        //            connector.state = NTESLiveMicStateConnecting;
        //
        //            [[NTESLiveManager sharedInstance] addConnectorOnMic:connector];
        //
        //            [[NTESLiveManager sharedInstance] updateConnectors:connector];
        //            //显示连接中的图案
        //            [weakSelf.innerView switchToBypassLoadingUI:connector];
        //            //刷新等待列表人数
        [weakSelf didUpdateConnectors];
        //        }else{
        //            DDLogError(@"notification with agree mic error: %@",error);
        //            [weakSelf.view makeToast:@"选择失败，请重试" duration:2.0 position:CSToastPositionCenter];
        //        }
        //        if (handler) {
        //            handler(error);
        //        }
    }];
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

- (void)shareStreamUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSDictionary * dic = [NTESLiveUtil dictByJsonString:self.chatroom.ext];
    NSString * pullUrl = [dic objectForKey:@"pullUrl"];
    if (pullUrl) {
        pasteboard.string = pullUrl;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"拉流地址已复制" message:@"在拉流播放器中粘贴地址\n观看直播" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"拉流地址已复制" message:@"在拉流播放器中粘贴地址\n观看直播" preferredStyle:UIAlertControllerStyleAlert];
        [alertVc addAction:[UIAlertAction actionWithTitle:@"知道了" style: UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

- (void)snapshotFromLocalVideoComplete:(void(^)(UIImage * __nullable image))result
{
    [[NIMAVChatSDK sharedSDK].netCallManager snapshotFromLocalVideoCompletion:^(UIImage * _Nonnull image) {
        if (result) {
            result(image);
        }
    }];
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

- (void)doManualFocusWithPointInView:(CGPoint)point
{
    if (self.anchorLiveType > JHAnchorLiveAppraiseType) {
        return;
    }
    CGFloat actionViewHeight = [self.innerView getActionViewHeight];
    BOOL pointsInRect = point.y < self.view.height - actionViewHeight;
    //后置摄像头允许对焦
    if (!_remoteFullScreen&&(NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo && [self.capture isCameraBack] && _isFocusOn && pointsInRect) {
        // 代执行的延迟消失数量
        static int delayCount = 0;
        
        // 焦点显示
        self.focusView.center = CGPointMake(point.x, point.y);
        [self.view bringSubviewToFront:self.focusView];
        self.focusView.hidden = NO;
        [self beginAnimation];
        
        CGPoint devicePoint = CGPointMake(self.focusView.center.x/self.innerView.frame.size.width, self.focusView.center.y/self.innerView.frame.size.height);
        //对焦
        [[NIMAVChatSDK sharedSDK].netCallManager changeNMCVideoPreViewManualFocusPoint:devicePoint];
        
        delayCount++;
        //3秒自动消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.focusView.hidden && delayCount == 1) {
                self.focusView.hidden = YES;
                [[NIMAVChatSDK sharedSDK].netCallManager setFocusMode:NIMNetCallFocusModeAuto];
                
            }
            delayCount--;
        });
    }
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

#pragma mark - Get

- (JHSendOrderView *)sendOrderView {
    if (!_sendOrderView) {
        _sendOrderView = [JHSendOrderView sendOrderViewFirst];
        _sendOrderView.frame = self.view.bounds;
        _sendOrderView.anchorId = self.channel.anchorId;
        _sendOrderView.roomId = self.chatroom.roomId;
        MJWeakSelf
        _sendOrderView.clickImage = ^(JHSendOrderView *sender) {
            weakSelf.innerView.hidden = YES;
            weakSelf.sendOrderView.sendOrderSecond.hidden = YES;
            [weakSelf cameraScreen];
        };
        _sendOrderView.sendWish = ^(id sender) {
            [weakSelf sendWishPaper:sender];
        };
    }
    return _sendOrderView;
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
    if (self.anchorLiveType > JHAnchorLiveAppraiseType) {
        if (self.isCreatAnction) {
            self.innerView.hidden = NO;
            self.normalOrderView.hidden = NO;
            self.isCreatAnction = NO;
            self.auctionListWeb.hidden = NO;

        }else {
            self.innerView.hidden = NO;
            self.normalOrderView.hidden = NO;
            self.sendOrderView.sendOrderSecond.hidden = NO;
        }
        
    }else {
        self.innerView.hidden = NO;
        self.normalOrderView.hidden = NO;
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
    if (self.normalOrderView) {
        [self.normalOrderView showImageViewAction:image];
        self.innerView.hidden = NO;
        self.normalOrderView.hidden = NO;
    } else {
        JHFlashSendOrderInputView *view = [self.innerView viewWithTag:JHRoomFlashSendOrderViewTag];
        [view showImageViewAction:image];
        self.innerView.hidden = NO;
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
    }
    return _roomDetailView;
}

- (JHCustomizeAnchorLinkView *)appraisalList {
    if (!_appraisalList) {
        _appraisalList = [[JHCustomizeAnchorLinkView alloc] initWithFrame:CGRectMake(0.f, ScreenH, ScreenW, 265./375.*ScreenW+UI.bottomSafeAreaHeight)];
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
        _innerView = [[JHCustomizeAnchorInnerView alloc] initWithChannel:self.channel frame:self.view.bounds isAnchor:YES];
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

- (NTESWaterMarkView *)waterMarkView
{
    if (!_waterMarkView) {
        _waterMarkView = [[NTESWaterMarkView alloc]initWithFrame:self.view.bounds];
        _waterMarkView.delegate =self;
    }
    return _waterMarkView;
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

-(NTESFiterMenuView *)filterView
{
    if (!_filterView) {
        _filterView = [[NTESFiterMenuView alloc]initWithFrame:self.view.bounds];
        _filterView.selectedIndex = self.filterModel.filterIndex;
        _filterView.smoothValue = self.filterModel.smoothValue;
        _filterView.constrastValue = self.filterModel.constrastValue;
        
        _filterView.delegate = self;
    }
    return _filterView;
}
-(JHConnetcMicDetailView *)micDetailView
{
    if (!_micDetailView) {
        _micDetailView = [[JHConnetcMicDetailView alloc]initWithFrame:self.view.bounds anchorLiveType:self.anchorLiveType];
        _micDetailView.delegate = self;
    }
    return _micDetailView;
}

- (JHAuthenticateRecordView *)authenticateRecordView {
    if (!_authenticateRecordView) {
        _authenticateRecordView = [JHAuthenticateRecordView authenticateRecord];
    }
    return _authenticateRecordView;
}
- (NSMutableArray *)connecteds {
    if (!_connecteds) {
        _connecteds = [NSMutableArray array];
    }
    return _connecteds;
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

#pragma mark - 获取聊天室成员

- (void)fetchMember {
    NIMChatroomMemberRequest *requst = [[NIMChatroomMemberRequest alloc] init];
    
    requst.roomId = _chatroom.roomId ;
    requst.type = NIMChatroomFetchMemberTypeTemp;
    requst.limit = 30;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        self.audienceArray = members.mutableCopy;
        [self.innerView reloadAudienceData:self.audienceArray];
    }];
}

- (void)fetchAnchorInfo {
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/authoptional/appraise") Parameters:@{@"customerId" : self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        
        DDLogInfo(@"fetchAnchorInfo=%@",respondObject);
        JHAnchorInfoModel *model = [JHAnchorInfoModel mj_objectWithKeyValues:respondObject.data];
        [self.roomDetailView setLiveRoomAnchorInfoModel:model roleType:9];
        self.innerView.anchorInfoModel = model;
        self.roomDetailView.anchorDetailView.model = model;
        if (self.anchorLiveType > JHAnchorLiveAppraiseType) {
            [self.roomDetailView.anchorDetailView setSaleAnchor];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
}

#pragma mark - JHAppraisalListDelegate
//连接
- (void)connectUser:(NSInteger)index model:(NTESMicConnector *)model {
    [self trackLiveRoomPublicEventId:JHIdentifyActivityOnlineClick];
    //不在队列里
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:model.uid];
    if (!connector) {
        return;
    }
    
    BOOL ispost=YES;
    
    for (NTESMicConnector * connector in [NTESLiveManager sharedInstance]. connectors) {
        
        if (connector.state==NTESLiveMicStateWait) {
            ispost=NO;
            break;
        }
    }
    if (!ispost) {
        
        [self.view makeToast:@"已邀请其他连麦者，请等待反馈后再发起新的邀请" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (model.onlineState==NTESLiveMicOnlineStateExitRoom) {
        [self.view makeToast:@"当前用户不在直播间" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    [self onSelectMicConnector:model];
}

- (void)disconnectUser:(NSInteger)index model:(NTESMicConnector *)model {
    
   // [self endConnectMic:model.uid];
    
     [self forceEndConnectMic:model.uid];
    
    //    if (!self.sendedReporterList[model.appraiseRecordId]) {
    //        self.reporter.micModel = model;
    //        [self.view addSubview:self.reporter];
    //        [self.reporter showAlert];
    //    }
    
}
//看详情
- (void)lookUserDetail:(NSInteger )index model:(NTESMicConnector *)model{
    
    if (_micDetailView) {
        [_micDetailView removeFromSuperview];
    }
    [self.view addSubview:self.micDetailView];
    [self.micDetailView show];
    [self.micDetailView setConnector:model];
    [self trackLiveRoomPublicEventId:JHIdentifyActivityDetailClick];
}
- (void)onReporter:(NSInteger)index model:(NTESMicConnector *)model {
}

- (void)sendRedPocket:(NSInteger)index model:(NTESMicConnector *)model {
    [self.view addSubview:self.sendAmountView];
    self.sendAmountView.viewerId = model.Id;
    [self.sendAmountView showAlert];
    
}
//看订单
- (void)lookOrderList:(NSInteger)index model:(NTESMicConnector *)model{
    
    JHAudienceOrderListView * order=[[JHAudienceOrderListView alloc]init];
    [order  show];
    [order loadData:model];
    [self trackLiveRoomPublicEventId:JHIdentifyActivityOrderClick];
}
- (void)didPressAnchorAvatar:(NIMChatroomMember *)member {
    if (self.anchorLiveType == JHAnchorLiveAppraiseType) {
        JHGemmologistViewController *gemmologistVC = [[JHGemmologistViewController alloc] init];
                gemmologistVC.anchorId = self.channel.anchorId;
        gemmologistVC.isFromLivingRoom = YES;
                [self.navigationController pushViewController:gemmologistVC animated:YES];
        [JHGrowingIO trackEventId:JHEventAssayerprofile variables:@{JHKeyPagefrom:JHPageFromAppraiseRoom}];
    }
    else if (self.anchorLiveType == JHAnchorLiveCustomizeType ||
             self.anchorLiveType == JHAnchorLiveCustomizeAssistantType) {///跳转定制师个人主页
        [JHRootController toNativeVC:NSStringFromClass([JHCustomerInfoController class])
                           withParam:@{@"roomId":self.channel.roomId,
                                       @"anchorId":self.channel.anchorId,
                                       @"channelLocalId":self.channel.channelLocalId}
                                from:JHLiveFromLiveRoom];
    }
}
//鉴定记录
- (void)showRecordList:(NSInteger)index model:(NTESMicConnector *)model {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraiseRecord/find-user-appraise-record") Parameters:@{@"customerId":model.Id} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHAnchorRecordModel *rModel = [JHAnchorRecordModel mj_objectWithKeyValues:respondObject.data];
        
        _authenticateRecordView.recordModel = rModel;
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    if (!_authenticateRecordView) {
        [self.view addSubview:self.authenticateRecordView];
    }
    [_authenticateRecordView showAlert];
    [self trackLiveRoomPublicEventId:JHIdentifyActivityAppraiseldClick];
}

- (void)trackLiveRoomPublicEventId:(NSString *)eventId
{
    [JHGrowingIO trackPublicEventId:eventId paramDict:@{@"roomId":self.channel.roomId ? : @"",@"anchorId":self.channel.anchorId ? : @"",@"channelType":self.channel.channelType,@"channelLocalId":self.channel.channelLocalId ? : @"", @"appraiserId":self.channel.anchorId ? : @"",  @"appraiseId":self.channel.anchorId ? : @"", @"channelCategory": self.channel.channelCategory ? : @""}];
}//TODO:appraiserId??

#pragma mark =============== JHConnetcMicDetailViewDelegate ===============

//无法鉴定
- (void)refuseAppraisal:(NTESMicConnector *) connector{
    
    if (connector.state==NTESLiveMicStateConnected) {
        [self.view makeToast:@"当前正在连麦中" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *url= [NSString stringWithFormat:FILE_BASE_STRING(@"/appraisal/connectMic/anchorCancel?customizeId=%@"),connector.customizeRecordId];
    
    [HttpRequestTool getWithURL:url  Parameters:nil   successBlock:^(RequestModel *respondObject) {
        
        DDLogInfo(@"refuseAppraisal=%@",respondObject);
        [SVProgressHUD dismiss];
        [self  removeConnector:connector];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        //[self  removeConnector:connector];
        
    }];
    
    [SVProgressHUD show];
    
}
//主播取消反向连麦
- (void)anchorCancelLink:(NTESMicConnector *) connector{
    if (connector.state==NTESLiveMicStateConnected) {
        [self.view makeToast:@"当前正在连麦中" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    NSString *url= [NSString stringWithFormat:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/anchorCancel?customizeId=%@"),connector.customizeRecordId];
    
    [HttpRequestTool getWithURL:url  Parameters:nil   successBlock:^(RequestModel *respondObject) {
        
        DDLogInfo(@"refuseAppraisal=%@",respondObject);
        [SVProgressHUD dismiss];
        [self  removeConnector:connector];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        //[self  removeConnector:connector];
        
    }];
    
    [SVProgressHUD show];
}
-(void)removeConnector:(NTESMicConnector *) connector{
    [self.micDetailView dismiss];
    [[NTESLiveManager sharedInstance] removeConnectors:connector.uid];
    if (_appraisalList) {
        [_appraisalList reloadData:[NTESLiveManager sharedInstance].connectors];
    }
    [self didUpdateConnectors];
    _appraisalList.statusType=0;
    
}
//断开连麦
-(void)forceEndConnectMic:(NSString *)uid{
    
    __block NTESMicConnector *connector = nil;
    [[NTESLiveManager sharedInstance]. connectors enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:uid]) {
            connector = obj;
            *stop = YES;
        }
    }];
    NSString *  timeSpend=[NSString stringWithFormat:@"%ld",([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000];
    if (connector.connectType == 1) {
        NSDictionary * parameters=@{
                                    @"customizeId":connector.customizeRecordId,
                                    @"timeSpend":timeSpend,
                                    @"wyAccid":connector.uid,
                                    @"anchorId":self.channel.anchorId
                                    };
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
            
           DDLogInfo(@"forceEndConnectMic:%@",respondObject.data);
            [SVProgressHUD dismiss];
            [self handleUserLeftMeetingFromUid:uid];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            
        }];
    }else{
        NSDictionary * parameters=@{
                                    @"customizeId":connector.customizeRecordId,
                                    @"timeSpend":timeSpend,
                                    @"wyAccid":connector.uid
                                    };
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
            
           DDLogInfo(@"forceEndConnectMic:%@",respondObject.data);
            [SVProgressHUD dismiss];
            [self handleUserLeftMeetingFromUid:uid];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
            
        }];
    }
    
    
    [SVProgressHUD show];
}
//上传连麦中离开时间
-(void)connecterLeft:(NSString *)uid{
    
    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
    
    if (connector) {
        NSString * urlStr = @"/appraisal/connectMic/break";
        if (connector.connectType == 1) {
            urlStr = @"/appraisal/reverse/connectMic/break";
        }
        NSString *  timeSpend=[NSString stringWithFormat:@"%ld",([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000];
        
        NSDictionary * parameters=@{
            @"customizeId":connector.customizeRecordId?:@"",
              @"timeSpend":timeSpend,
               @"anchorId":self.channel.anchorId
            };
        [HttpRequestTool postWithURL:FILE_BASE_STRING(urlStr)  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
}

-(void)addTimerByConnect:(NTESMicConnector *)connect{
    
    if (!_downTimer) {
        _downTimer=[[BYTimer alloc]init];
    }
    [_downTimer stopGCDTimer];
    JH_WEAK(self)
    [self.downTimer createTimerWithTimeout:40 handlerBlock:^(int presentTime) {
        JH_STRONG(self)
        [self.appraisalList setTimeCount:presentTime];
        
    } finish:^{
        JH_STRONG(self)
        [self refuseAppraisal:connect];
        [self.appraisalList setTimeCount:0];
    }
     ];
    
}
- (void)requestMute:(NSInteger)ismute accid:(NSString *)accid {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/room/auth/temporaryMute") Parameters:@{@"viewerAccId":accid,@"muteDuration":@(ismute)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
//主播端>打开飞单弹层
- (void)onShowInfoWithModel:(NTESMessageModel *)model{
    if (self.anchorLiveType == JHAnchorLiveCustomizeType) {
        [self makeCardViewWithModel:model];
    }
}

- (void)makeCardViewWithModel:(NTESMessageModel *)model {
    JHRoomUserCardView *_sendOrderView = [[JHRoomUserCardView alloc] initFromCustomize];
    //区分是否可以定制单
    [_sendOrderView canSendCustomizeOrder:[self findCustomizeConnector:model.message.from]];
    _sendOrderView.cardType = RoomUserCardViewTypeCustomize;
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
    
    if (self.normalOrderView) {
        [self.normalOrderView removeFromSuperview];
        self.normalOrderView = nil;
    }
    _sendOrderView.orderAction = ^(NTESMessageModel *object, OrderTypeModel *sender) {
//        if ([sender.Id isEqualToString:JHOrderCategoryHandlingService]) {//加工服务单
//            JHSendOrderProccessGoodView *view = [[JHSendOrderProccessGoodView alloc] init];
//            [weakSelf.innerView addSubview:view];
//            [view requestProccessGoodsBuyId:object.customerId isAssistant:0];
//
//        }else {
        if ([sender.Id isEqualToString:@"normal"]) {//常规订
            if (self.normalOrderView) {
                [self.normalOrderView removeFromSuperview];
            }
            self.normalOrderView = [[JHRoomSendOrderView alloc] init];
            [weakSelf.view addSubview:self.normalOrderView];
            self.normalOrderView.orderCategory = sender;
            self.normalOrderView.frame = weakSelf.view.bounds;
            self.normalOrderView.customerId = object.customerId;
            self.normalOrderView.anchorId = weakSelf.channel.anchorId;
            self.normalOrderView.isCustomizeSelf = YES;
            [self.normalOrderView showAlert];
            self.normalOrderView.clickImage = ^(JHRoomUserCardView *sender) {
                weakSelf.innerView.hidden = YES;
                weakSelf.normalOrderView.hidden = YES;
                [weakSelf cameraScreen];
            };
        }else if([sender.Id isEqualToString:@"connect"]){
            //反向连麦
            if (self.isLinking) {
                [self.view makeToast:@"正在连麦中..." duration:1.0 position:CSToastPositionCenter];
                return;
            }
            NTESMicConnector *connector =  [[NTESLiveManager sharedInstance] findConnector:object.message.from];
            if (connector) { //用户已经申请连麦  走正向连麦
                [self connectUser:0 model:connector];
                [self didUpdateConnectors];
                self.appraisalList.selectedModel = connector;
                [self onAppraiseList];
                self.appraisalList.statusType = 1;
                [self addTimerByConnect:connector];
            }else{
                JH_WEAK(self)
                [JHLiveApiManager reverseApplyConnectCustomize:self.channel.roomId viewerId:object.customerId Completion:^(RequestModel *respondObject, NSError *error) {
                    JH_STRONG(self)
                    if (!error) {
                        
                        NTESMicConnector *connector = [[NTESMicConnector alloc] init];
                        connector.uid    = respondObject.data[@"wyAccid"];
                        connector.customizeRecordId = respondObject.data[@"customizeId"];
    //                    connector.Id    = Id;
                        connector.state  = NTESLiveMicStateWait;
                        connector.nick   = model.nick;
                        connector.avatar = model.avatar;
                        connector.type   = NIMNetCallMediaTypeVideo;
                        connector.imgList   = @[kDefaultCoverImage];
                        connector.connectType = 1;
                        [[NTESLiveManager sharedInstance] insertConnector:connector atIndex:0];
                        [self didUpdateConnectors];
                        self.appraisalList.selectedModel = connector;
                        [self onAppraiseList];
                        self.appraisalList.statusType = 1;
                        [self addTimerByConnect:connector];
                    }else{
                        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                    }
                }];

            }
        }
        else if([sender.Id isEqualToString:@"ownerShipOrder"]){
            //意向单
            JHCustomizeUserOrderView * view = [[JHCustomizeUserOrderView alloc] init];
            view.orderCategory = sender.Id;
            view.anchorId = weakSelf.channel.anchorId;
            view.customerId = object.customerId;
            NTESMicConnector * con = [self findCustomizeConnector:object.message.from];
            if (con && con.imgList.count>0) {
                view.imageUrl = [con.imgList firstObject];
                view.parentOrderId = con.orderId;
            }
            view.orderType = JHCustomizeUserOrderTypeIntent;
            [weakSelf.view addSubview:view];
            view.frame = weakSelf.view.bounds;
            [view showAlert];
            
        } else if([sender.Id isEqualToString:@"personalCustomizeOrder"]) {
            /// 定制单
            [SVProgressHUD show];
            @weakify(self);
            [JHLiveApiManager checkUserCanUseCustomizePackage:[object.customerId integerValue] version:@"3.6.0" Completion:^(NSError * _Nullable error, RequestModel * _Nullable respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                if (error) {
                    if (isEmpty(respondObject.message)) {
                        [self.view makeToast:@"此用户的APP版本过低，不能飞定制订单" duration:1.0 position:CSToastPositionCenter];
                    } else {
                        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                    }
                    return;
                }
                [self flyCustomizeOrder:object sender:sender];
            }];
            
        } else if ([sender.Id isEqualToString:@"normalCustomizeGroup"]) {
            [SVProgressHUD show];
            @weakify(self);
            [JHLiveApiManager checkUserCanUseCustomizePackage:[object.customerId integerValue] version:@"3.6.5" Completion:^(NSError * _Nullable error, RequestModel * _Nullable respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                if (error) {
                    if (isEmpty(respondObject.message)) {
                        [self.view makeToast:@"此用户的APP版本过低，不能飞套餐订单" duration:1.0 position:CSToastPositionCenter];
                    } else {
                        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                    }
                    return;
                }
                [self flyCustomizePackageOrder:object sender:sender];
            }];
        }
    };
}


/// 飞定制单
- (void)flyCustomizeOrder:(NTESMessageModel *)object sender:(OrderTypeModel *)sender {
    JHCustomizeOrderFlyListView *view = [[JHCustomizeOrderFlyListView alloc] initWithCustomerId:[object.customerId integerValue]];
    [self.view addSubview:view];
    view.frame = self.view.bounds;
    [view showAlert];
    if (self.orderView) {
        [self.orderView removeFromSuperview];
        self.orderView = nil;
    }
    @weakify(self);
    view.cusActionBlock = ^(JHCheckCustomizeOrderListModel * _Nonnull model, JHCustomizeOrderFlyListView * _Nonnull view) {
        @strongify(self);
        if (model.buttonFlag == 0) {
            /// 如果自有,没连麦则提示该信息
            [self.view makeToast:@"需要与用户连麦，截取用户当前画面" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (!self.orderView) {
            self.orderView = [[JHCustomizeFlyOrderView alloc] init];
        }
        self.orderView.orderCategory            = @"personalCustomizeOrder";
        self.orderView.anchorId                 = self.channel.anchorId;
        self.orderView.viewerId                 = object.customerId;
        self.orderView.countCategaryArray       = self.countCategaryArray;

//                    NTESMicConnector * con = [weakSelf findCustomizeConnector:object.message.from];
//                    if (con && con.imgList.count>0) {
//                        orderView.imageUrl = [con.imgList componentsJoinedByString:@","];
//                        orderView.parentOrderId = con.orderId;
//                        NSString * cateId = con.goodsCateId;
//                        NSString * cateName = con.goodsCateName;
//                        if (con.state == NTESLiveMicStateConnected) {
//                            orderView.isConnecting = YES;
//                        } else {
//                            orderView.isConnecting = NO;
//                        }
//                        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                        if (cateId && cateId.intValue > 0) {
//                            [dic setValue:cateId forKey:@"id"];
//                            if (cateName) {
//                                [dic setValue:cateName forKey:@"name"];
//                            }
//                        }
//                        orderView.selectedCate = dic;
//                        orderView.customizeFeeId = con.customizeFeeId;
//                        if ([con.orderCategory isEqualToString:@"ownerShipOrder"]) {
//                            orderView.customizeType = JHCustomizedIntentionOrder;
//                        } else if ([con.orderCategory isEqualToString:@"normal"]) {
//                            orderView.customizeType = JHCustomizedNormalOrder;
//                        } else {
//                            orderView.customizeType = JHCustomizedOrder;
//                        }
//                    } else {
        self.orderView.imageUrl      = model.goodsUrl;
        self.orderView.parentOrderId = model.orderId;
        self.orderView.isConnecting  = self.isLinking;
        if ([model.orderCategory isEqualToString:@"normal"]) {
            self.orderView.customizeType = JHCustomizedNormalOrder;
        } else if ([model.orderCategory isEqualToString:@"ownerShipOrder"]) {
            self.orderView.customizeType = JHCustomizedIntentionOrder;
        } else {
            self.orderView.customizeType = JHCustomizedOrder;
        }
        self.orderView.selectedCate = @{
            @"id":model.goodsCateId,
            @"name":model.goodsCateIdName
        };

        self.orderView.snapShotCallBack = ^(JHCustomizeFlyOrderView * _Nonnull selfView) {
            @strongify(self);
            UIImage* image = [self getImageWithFullScreenshot];
            selfView.screenImage = image;
            [selfView reloadScreenImageBGView];
        };
        [self.view addSubview:self.orderView];
        self.orderView.frame = self.view.bounds;
        [self.orderView showAlert];
        
        [view removeFromSuperview];
        view = nil;
    };
}


//定制套餐捆绑
- (void)flyCustomizePackageOrder:(NTESMessageModel *)object sender:(OrderTypeModel *)sender {
    self.normalOrderView = [[JHRoomSendOrderView alloc] init];
    [self.view addSubview:self.normalOrderView];
    self.normalOrderView.orderCategory = sender;
    self.normalOrderView.frame = self.view.bounds;
    self.normalOrderView.customerId = object.customerId;
    self.normalOrderView.anchorId = self.channel.anchorId;
    self.normalOrderView.isCustomizePackage = YES;
    [self.normalOrderView showAlert];
    @weakify(self);
    self.normalOrderView.clickImage = ^(JHRoomUserCardView *sender) {
        @strongify(self);
        self.innerView.hidden = YES;
        self.normalOrderView.hidden = YES;
        [self cameraScreen];
    };
    self.normalOrderView.closeBlock = ^{
        @strongify(self);
        if (self.packageOrderView) {
            [self.packageOrderView removeFromSuperview];
            self.packageOrderView = nil;
        }
    };
    self.normalOrderView.nextBlock = ^(JHSendOrderModel * _Nonnull model) {
        @strongify(self);
        self.normalOrderView.hidden = YES;
        if (self.packageOrderView && self.packageOrderView.hidden) {
            self.packageOrderView.hidden = NO;
            [self.packageOrderView setCagetoryInfoTextField:[self.normalOrderView getCagetoryInfo]];
            self.packageOrderView.customizePackageModel = model;

        } else {
            self.packageOrderView = [[JHCustomizeFlyOrderView alloc] init];
            self.packageOrderView.customizeType  = JHCustomizedAndNormalOrder;
            self.packageOrderView.customizePackageModel = model;
            self.packageOrderView.snapShotCallBack = ^(JHCustomizeFlyOrderView * _Nonnull selfView) {
                @strongify(self);
                UIImage *image = [self getImageWithFullScreenshot];
                selfView.screenImage = image;
                [selfView reloadScreenImageBGView];
            };
            
            self.packageOrderView.orderCategory = @"normal";
            self.packageOrderView.anchorId = model.anchorId;
            self.packageOrderView.viewerId = object.customerId;
            self.packageOrderView.countCategaryArray = self.countCategaryArray;
            NTESMicConnector * con = [self findCustomizeConnector:object.message.from];
            if (con && con.imgList.count>0) {
//                self.packageOrderView.imageUrl = [con.imgList componentsJoinedByString:@","];
                self.packageOrderView.parentOrderId = con.orderId;
                NSString * cateId = con.goodsCateId;
                NSString * cateName = con.goodsCateName;
                if (con.state == NTESLiveMicStateConnected){
                    self.packageOrderView.isConnecting = YES;
                } else {
                    self.packageOrderView.isConnecting = NO;
                }
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                if(cateId && cateId.intValue > 0){
                    [dic setValue:cateId forKey:@"id"];
                    if(cateName){
                        [dic setValue:cateName forKey:@"name"];
                    }
                }
                self.packageOrderView.selectedCate   = dic;
                self.packageOrderView.customizeFeeId = con.customizeFeeId;
            }
            [self.view addSubview:self.packageOrderView];
            self.packageOrderView.frame = self.view.bounds;
            
            [self.packageOrderView setImgInfo:[self.normalOrderView getImageUrl]];
            [self.packageOrderView showAlert];
            [self.packageOrderView setCagetoryInfoTextField:[self.normalOrderView getCagetoryInfo]];
            
            self.packageOrderView.lastAction = ^{
                @strongify(self);
                self.packageOrderView.hidden = YES;
                self.normalOrderView.hidden = NO;
            };
        }
    };
}

- (JHBackApplyLinkPoPView *) reverseLinkView{
    if (!_reverseLinkView) {
        _reverseLinkView = [JHBackApplyLinkPoPView new];
    }
    return _reverseLinkView;
}
- (void)requestOpenActivity {
    /// 活动
    [JHActivityAlertView getActivityAlertViewWithLocation:3];
}

- (void)showActivity {
    if ([self.homeActivityMode.homeActivityIcon.target.componentName isEqualToString:@"WebDialog"]) {
            JHWebView *webview = [[JHWebView alloc] init];
            webview.frame = self.view.bounds;
            NSString *urlString = [self.homeActivityMode.homeActivityIcon.target.params objectForKey:@"urlString"];
            [webview jh_loadWebURL:[urlString stringByAppendingFormat:@"?isSell=%d&isBroad=%d&isAssistant=%d", self.anchorLiveType >  JHAnchorLiveAppraiseType?1:0, 1,(int)self.channel.isAssistant]];
            
            [self.view addSubview:webview];
            self.webSpecialActivity = webview;
    }
    else {
        [JHRootController toNativeVC:self.homeActivityMode.homeActivityIcon.target.componentName withParam:self.homeActivityMode.homeActivityIcon.target.params from:JHLiveFromh5];
    }
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

- (void)getRoomNotice {
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

- (void)checkAuction {
    if (self.innerView.auctionWeb) {
        JH_WEAK(self)
        self.innerView.auctionWeb.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
            JH_STRONG(self)
            return [self.channel mj_JSONString];
        };
    }
    
    self.innerView.canAuction = self.channel.canAuction;
}

- (void)checkActivity {
    self.webActivity = [[JHWebView alloc] init];
    [self.webActivity jh_loadWebURL:ActivityURL(self.anchorLiveType >= JHAnchorLiveSaleType,1,[YDHelper get13TimeStamp])];
    self.webActivity.frame = CGRectMake(0, UI.statusBarHeight + 100, 94, 144);
    [self.innerView addSubview:self.webActivity];
    JH_WEAK(self)
    self.webActivity.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
}

-(void)beginGame{
    JH_WEAK(self)
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/game/addGame/auth") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
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
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/expect/sendExpect/auth") Parameters:@{@"viewerAccId":accid} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
//
//    } failureBlock:^(RequestModel *respondObject) {
//        [SVProgressHUD showErrorWithStatus:respondObject.message];
//
//    }];
    
    //    新版本    accid 改成customerId
    
    JHWebView *webview = [[JHWebView alloc] init];
    [webview jh_loadWebURL:FindWishPaperURL(accid)];
    webview.frame = self.view.bounds;
    [self.view addSubview:webview];
    JH_WEAK(self)
    webview.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DDLogInfo(@"didReceiveMemoryWarning ");
    [JHWebImage clearCacheMemory];
//    if (!hasShowMemoryWarning) {
//        hasShowMemoryWarning=YES;
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"内存警告" message:@"请拍照留存并联系技术人员" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert showAlertWithCompletionHandler:nil];
//    }
}

- (void)forbidLiveWithMsg:(NSString *)msg isWarning:(BOOL)isWarning {
    MJWeakSelf
    if (!isWarning) {//禁播
        [self.capture stopLiveStream];
        [self.capture stopVideoCapture];
        [[NTESLiveManager sharedInstance] removeAllConnectors];
        
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.currentMeeting];
        
        [countDownTimer invalidate];
        [[NTESLiveManager sharedInstance] stop];
        
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:self.chatroom.roomId completion:^(NSError * _Nullable error) {
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

//通过uid获取定制连麦过用户 主播关播后队列清空
- (NTESMicConnector *)findCustomizeConnector:(NSString *)uid
{
    NTESMicConnector *micConnector = nil;
    for (NTESMicConnector *connector in self.connecteds) {
        if ([connector.uid isEqualToString:uid]) {
            micConnector = connector;
            if([connector.orderId length] > 0)
            {
                break;
            }
        }
    }
    return micConnector;
}


//截取用户画面
-(UIImage *)getImageWithFullScreenshot
{
    UIView*  window = self.captureView;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGSize imageSize = window.bounds.size;
    
//    //适配横屏状态
//    if (UIInterfaceOrientationIsPortrait(orientation) )
//        imageSize = [UIScreen mainScreen].bounds.size;
//    else
//        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, window.center.x, window.center.y);
    CGContextConcatCTM(context, window.transform);
    CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
    
    // Correct for the screen orientation
    if(orientation == UIInterfaceOrientationLandscapeLeft)
    {
        CGContextRotateCTM(context, (CGFloat)M_PI_2);
        CGContextTranslateCTM(context, 0, -imageSize.width);
    }
    else if(orientation == UIInterfaceOrientationLandscapeRight)
    {
        CGContextRotateCTM(context, (CGFloat)-M_PI_2);
        CGContextTranslateCTM(context, -imageSize.height, 0);
    }
    else if(orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        CGContextRotateCTM(context, (CGFloat)M_PI);
        CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
    }
    
    if([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    else
        [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextRestoreGState(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

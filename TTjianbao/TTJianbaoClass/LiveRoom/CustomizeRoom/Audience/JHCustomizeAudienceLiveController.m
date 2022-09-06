//
//  JHCustomizeAudienceLiveController.m
//  NIM
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//
#import "JHLiveStoreView.h"
#import "UIView+UIHelp.h"
#import "JHShopwindowGoodsAlert.h"
#import "JHEnvVariableDefine.h"
#import "JHActivityAlertView.h"
#import "JHMallGroupListViewModel.h"
#import "JHCustomizeAudienceLiveController.h"
#import "UIImage+NTESColor.h"
#import "UIView+NTES.h"
#import "NSString+NTES.h"
#import "JHAppAlertViewManger.h"
#import "JHLivePlayer.h"
#import "UIView+Toast.h"
#import "NTESLiveManager.h"
#import "NTESDemoLiveroomTask.h"
#import "NSDictionary+NTESJson.h"
#import "UIAlertView+NTESBlock.h"
#import "NTESDemoService.h"
#import "NTESSessionMsgConverter.h"
#import "NTESLiveInnerView.h"
#import "NTESPresentShopView.h"
#import "NTESAudienceConnectView.h"
#import "NTESInteractSelectView.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESLiveViewDefine.h"
#import "NTESMicConnector.h"
#import "NTESMicAttachment.h"
#import "NTESLiveAudienceHandler.h"
#import "NTESTimerHolder.h"
#import "NTESDevice.h"
#import "NTESUserUtil.h"
#import "NTESLiveUtil.h"
#import "NTESAudiencePresentViewController.h"
#import "NTESFiterMenuView.h"
#import "JHCustomizeAndienceInnerView.h"
#import "JHLiveEndPageView.h"
#import "ChannelMode.h"
#import "JHAnchorHomeView.h"
#import "JHLiveBottomBar.h"
#import "JHAudienceConnectView.h"
#import "LoginViewController.h"
#import "JHAnchorInfoModel.h"
#import <IQKeyboardManager.h>
#import "JHEvaluationViewController.h"
#import "UMengManager.h"
#import "HKClipperHelper.h"
#import "JHAudienceApplyConnectView.h"
#import "JHLiveRoomDetailView.h"
#import "HttpUpImageTool.h"
#import "NSDictionary+NTESJson.h"
#import "JHReporterCard.h"
#import "JHPushOrderView.h"
#import "NTESMessageModel.h"
#import "LiveRedPacketView.h"
#import "ReceiveCoponView.h"
#import "JHMyCouponViewController.h"
#import "JHSendAmountView.h"
#import "JHWebViewController.h"
#import "JHPopDownTimeView.h"
#import "JHAnchorPageViewController.h"
#import "JHApplyMicSuccessAlertView.h"
#import "JHWaterPrintView.h"
#import "JHAudienceCommentView.h"
#import "JHWebView.h"
#import "JHMuteListViewController.h"
#import "JHAudienceLiveTableViewCell.h"
#import "JHShowRiskAlert.h"
#import <UIButton+WebCache.h>
#import "NOSUpImageTool.h"
#import "TTjianbaoUtil.h"
#import "JHUnionSignSalePopView.h"
#import "JHSendOrderModel.h"
#import "JHRoomSendOrderView.h"
#import "JHRoomUserCardView.h"
#import "JHSendOrderProccessGoodPayView.h"
#import "JHSendOrderProccessGoodView.h"
#import "JHHomeActivityMode.h"
#import "JHConnectMicPopAlertView.h"
#import "JHUserLevelInfoMode.h"
#import "CoponPackageMode.h"
#import "BaseNavViewController.h"
#import "JHLivePlayerManager.h"
#import "JHNimNotificationModel.h"
#import "JHStoneMessageModel.h"
#import "JHStonePopViewHeader.h"
#import "JHLiveRoomRedPacketViewModel.h"
#import "NSString+Common.h"
#import "JHPushOrderView.h"
#import "JHLivePlaySMallView.h"
#import "JHGuestLoginNIMSDKManage.h"
#import "NSString+Common.h"
#import "JHNimNotificationManager.h"
#import "JHAnnouncementInfoModel.h"
#import "JHPublishAnnouncementController.h"
#import "JHUnionSignView.h"
#import "JHAnchorInfoViewController.h"
#import "JHLadderWidget.h"
#import "JHLadderApiManager.h"
#import "JHAppraiseRedPacketModel.h"
#import "SourceMallApiManager.h"

#define JHRoomSendOrderViewTag 2247
#define pagesize 10
#define KTrackLiveRoomLimitCount  40

typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);

@interface JHCustomizeAudienceLiveController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NTESLiveInnerViewDataSource,
NTESPresentShopViewDelegate,NTESInteractSelectDelegate,NTESAudienceConnectDelegate,NTESLiveAudienceHandlerDelegate,NTESLiveAudienceHandlerDatasource,NTESMenuViewProtocol,JHLiveEndViewDelegate,JHAudienceConnectDelegate,JHConnectMicPopAlertView,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate,JHAudienceApplyConnectViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,JHCustomizeAndienceInnerViewDelegate>
{
    NSTimeInterval _lastPressLikeTimeInterval;
    NIMNetCallCamera _cameraType;
    NSString *_chatroomId;
    JHConnectMicPopAlertView * connectMicAlert;
    BOOL isCameraBack;
    int secondsCountDown;
    NSTimer*   countDownTimer;
    NIMCustomSystemNotification *currentNotification;
    CoponPackageMode* coponMode;
    BOOL fetchHistory;
    NSTimeInterval liveIntime;
    BOOL noMoreData;
}

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong)  JHApplyMicSuccessAlertView  *applySuccessAlert;
@property (nonatomic,assign) JHMediaType mediaType;
@property (nonatomic, strong) NTESAudienceConnectView *connectingView;
@property (nonatomic, strong) JHPopDownTimeView *popDownTimeView;
@property (nonatomic, strong)   JHAudienceLiveTableViewCell * currentCell;
@property (nonatomic, strong) JHCustomizeAndienceInnerView *innerView; //直播间中间展示view

@property (nonatomic, strong) NTESLiveAudienceHandler *handler;

@property (nonatomic, copy) NSString *streamUrl;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *chatroomId;
@property (nonatomic, strong) NSString *appraiseId;
@property (nonatomic, strong) NSMutableArray *audienceArray;

@property (nonatomic, strong) JHAnchorHomeView *anchorHomeView;
@property (nonatomic,strong)  BYTimer  *downTimer;
@property (nonatomic,strong)  BYTimer  *likeCountTimer;
@property (nonatomic, strong) JHAudienceConnectView *audienceConnectView;
@property (nonatomic, strong)  JHAudienceApplyConnectView*  audienceAddPhotoView;
@property (nonatomic, strong) JHAnchorInfoModel *anchorInfoModel;
@property (nonatomic, assign) BOOL localFullScreen;
@property (nonatomic, assign) BOOL isflashOn;
@property (nonatomic, assign) BOOL isFocusOn;
@property (nonatomic, strong) UIImageView *focusView;
@property (nonatomic, strong) JHLiveRoomDetailView *roomDetailView; //直播间scrollview 左中右
@property (nonatomic, strong) NSMutableArray *imgList;
@property (strong, nonatomic) UIImage *photoImg;
@property (nonatomic, strong) JHReporterCard *reporterCard;
@property (nonatomic, strong) JHWaterPrintView  *playLogo;
@property (nonatomic, strong) JHPushOrderView *receivedOrder;
@property (nonatomic,strong) JHRecvAmountView *recvAmountView;
@property (nonatomic, assign) BOOL isPopFirstView;

@property (nonatomic,strong) JHWebView *webActivity; //商家优惠券
@property (nonatomic,strong) JHWebView *webRightBottom; //平台运营位
@property (nonatomic,strong) JHWebView *webSpecialActivity;//指定活动 双11等
@property (nonatomic,strong) JHWebView *auctionListWeb;

//--------------直播津贴功能---------------
@property (nonatomic, strong) UILabel *ladderLabel; //显示领取的金额
@property (nonatomic, strong) JHLadderModel *ladderModel;
@property (nonatomic, strong) JHLadderWidget *ladderWidget; //直播津贴视图
//---------------------------------------

@property (nonatomic,strong) NSArray *historyMessage;
@property (nonatomic,assign) NSInteger historyIndex;

@property (nonatomic, assign) BOOL isCreatAnction;
@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, assign) BOOL isClean;
@property (strong, nonatomic) JHHomeActivityMode *homeActivityMode;
@property (strong, nonatomic)  StoneChannelMode *stoneChannel;
@property (nonatomic,strong) UIButton *activityIcon;
@property (nonatomic,strong) JHLiveRoomRedPacketViewModel *redPacketViewModel;
@property (nonatomic,assign) BOOL needShowliveSmallView;
@end

@implementation JHCustomizeAudienceLiveController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatroomId = chatroomId;
        _streamUrl = url;
        _isFocusOn = YES;
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationDefault;
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (instancetype)initWithChannelId:(NSString *)channelId {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _channelId = channelId;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogInfo(@"===========yyyyyyyy dealloc  JHCustomizeAudienceLiveController");
}

- (void)buryOut {
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise?2:1;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    model.channel_local_id = self.channel.channelLocalId;
    [[JHBuryPointOperator shareInstance] liveOutBuryWithModel:model];
    
    LiveExtendModel *liveModel = [JHGrowingIO liveExtendModelChannel:self.channel];
    NSInteger dur = 0;
    if (liveIntime>0) {
        dur = time(NULL)-liveIntime;
    }
    
    liveModel.duration = @(dur).stringValue;
    [JHGrowingIO trackEventId:JHTracklive_duration variables:[liveModel mj_keyValues]];
    liveIntime = 0;
}

- (void)buryIn {
    liveIntime = time(NULL);
    JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
    model.anchor_id = self.channel.anchorId;
    model.live_id = self.channel.currentRecordId;
    model.room_id = self.channel.roomId;
    model.live_type = self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise?2:1;
    model.channel_local_id = self.channel.channelLocalId;
    model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    model.from = self.fromString;
    [[JHBuryPointOperator shareInstance] liveInBuryWithModel:model];
    
    LiveExtendModel *liveModel = [JHGrowingIO liveExtendModelChannel:self.channel];
    liveModel.from = self.fromString?:@"";
    liveModel.third_tab_from = self.third_tab_from ? : @"";
    [JHGrowingIO trackEventId:JHTracklive_in variables:[liveModel mj_keyValues]];
}

-(void)loginOut{
    
    [self doExitLive];
}
//后台
-(void)applicationDidEnterBackground{
    
    [self  audienceOut];
    [self buryOut];
}
//前台
-(void)applicationWillEnterForeground{
    
    [self  audienceEnter];
    [self buryIn];
    
}
-(void)registerApplicationObservers{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NTESLivePlayerFirstVideoDisplayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidPlay:) name:NTESLivePlayerFirstAudioDisplayedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinshed:) name:NTESLivePlayerPlaybackFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAgainEnterChatRoom) name:@"LiveLoginFinishNotifaction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:LOGOUTSUSSNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onReceiveNimNotification:) name:JHNIMNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLiveSmallView:) name:kNeedShowliveSmallViewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShareAction) name:NotificationNameRedPacketGotoShare object:nil];
    
    //登录成功
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kAllLoginSuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self handleLoginEvent];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRedPacketWebView:) name:NotificationNameLiveWebRedPacket object:nil];
}

///直播间商家红包
- (void)reloadRedPacketWebView:(NSNotification *)sender
{
    if(_webActivity)
    {
        [_webActivity stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"AppCallbackWeb('%@')",sender.object]];
    }
}
-(void)needLiveSmallView:(NSNotification*)note{
    self.needShowliveSmallView=YES;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    liveIntime = time(NULL);
    NSLog(@"===========yyyyyyyy viewDidLoad  JHCustomizeAudienceLiveController");
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [[JHLivePlaySMallView sharedInstance] close];
    [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
//    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
//        [JHGrowingIO trackEventId:JHEventAuthoptionalliveplay variables:@{@"from":(self.fromString?self.fromString:@"")}];
//    }else {
//        [JHGrowingIO trackEventId:JHEventBusinessliveplay variables:@{@"from":(self.fromString?self.fromString:@"")}];
//    }
  
    if ([self.channel.channelType isEqualToString:@"sell"]||
        self.channeArr.count==0) {
        self.currentSelectIndex=0;
        NSDictionary*dict = [self.channel mj_keyValues];
        JHLiveRoomMode *channel = [JHLiveRoomMode mj_objectWithKeyValues:dict];
        self.channeArr=[NSMutableArray arrayWithObjects:channel, nil];
        self.tableView.scrollEnabled=NO;
        //noMoreData=YES;
    }
    //
//    if (self.channeArr.count<pagesize) {
//        noMoreData=YES;
//    }
    [self registerApplicationObservers];
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        [[NTESLiveManager sharedInstance] requestPresentList];
    }
    [CommHelp SaveEnterRoomCount];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.focusView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView scrollRectToVisible:CGRectMake(0, self.currentSelectIndex*ScreenH, ScreenW, ScreenH) animated:NO];
        NSIndexPath *  indexPath = [NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0];
        self.currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self initNewRoom]; //初始化直播间页面
        [self reloadData];
        //获取鉴定红包状态：是否显示
        [self checkAppraiserRedpacketStatus];
        //获取翻页数据
        if ([self.channel.channelType isEqualToString:@"sell"]) {
               [self requestInfo];
           }
        
    });
//    if (![JHRootController isLogin] && self.type == 0 && [CommHelp isFirstTodayForName:@"RedPocketGuideLogin"]) {
//
//        [self performSelector:@selector(guideLoginRedPocket) afterDelay:60];
//    }
    if (self.channel.isAssistant) {
        [[UserInfoRequestManager sharedInstance] getCateAllWithType:1 successBlock:^(RequestModel * _Nullable respondObject) {
            
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoticeShopWindowMessage:) name:@"shopwindowNotificationMessage" object:nil];
    
    //用户画像埋点
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @""}];
    }
    else
    {
        [JHUserStatistics noteEventType:kUPEventTypeShopLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @"", @"group_id":self.groupId ? : @""}];
    }
}

//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
    [dic setValue:@(self.listFromType) forKey:@"from"];
    return dic;
}

-(void)reloadData{
    
    self.currentUserRole=CurrentUserRoleAudience;
    if (self.streamUrl) {
        if (self.channel.status.integerValue == 2) {
            self.mediaType = JHMediaTypeLiveStream;
            self.innerView.isVideo = NO;
            fetchHistory = NO;
            self.innerView.canAppraise = self.channel.canAppraise;
            [self enterChatroom];
            //当前直播间助理不显示小窗
            if (self.channel.isAssistant==0){
                [self requestStoneChannel];
            }
        }
        else if (self.channel.status.integerValue == 1) {
            self.mediaType = JHMediaTypeVideoStream;
            self.innerView.isVideo = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameHiddenAppraiseBtn" object:nil];
            [self.innerView updateBackPlayUI];//回放样式
        }
        self.roomDetailView.scrollEnabled=YES;
       // [self startPlay:self.streamUrl inView:self.canvas andControlView:self.innerView.playControlView andMedioType:self.mediaType];
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
        
    }
    else {
        [self.innerView switchToEndUI];
        self.roomDetailView.scrollEnabled=NO;
    }
    [self.currentCell.infoView insertSubview:self.playLogo belowSubview:self.roomDetailView];
    self.innerView.commentCount = self.channel.orderCommentCount;
    [self addLikeCountTimer];
    if (self.channel.isAssistant) {
        self.innerView.type = 2;
        self.audienceUserRoleType = JHAudienceUserRoleTypeSaleAssistant;
    }else {
        self.innerView.type = self.audienceUserRoleType;
    }
    if (self.channel.status.integerValue == 2) {
        if (self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise) {
            //红包移到直播间外了
            //[self getNewCopon];
        }
    }
     if (!self.channel.isAssistant&&self.audienceUserRoleType != JHAudienceUserRoleTypeAppraise) {
           //关注提示气泡
           [self.innerView  starBubble];
       }
    [self.innerView setLikeCount:self.channel.likeCount];
    [self.innerView refreshChannel:self.channel];
    [self fetchAnchorInfo];
    [self getNotic];
    [self getNoPayOrderCount];
    [self checkActivity];
    self.innerView.commentCount = self.channel.orderCommentCount;
    if (self.innerView.auctionWeb) {
        WEAKSELF
        self.innerView.auctionWeb.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
            return [weakSelf.channel mj_JSONString];
        };
    }
    self.innerView.canAuction = self.channel.canAuction;
    
    
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone] || [self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        self.innerView.riskTestBtn.hidden = NO;
        [self requestRiskTips];
        
    }else {
        self.innerView.riskTestBtn.hidden = YES;
    }
    
    [self requestOpenActivity];
    
    JHRootController.serviceCenter.channelModel = self.channel;
    [self buryIn];
    [self requestCount];
    if (self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise) {
        //商家红包
        [self.redPacketViewModel reuqestRedListChannelId:self.channel.channelLocalId superView:self.innerView right:12 top:StatusBarH + 185];
    }
    
    [self initWebRightBottom];
    [self fetchAnnouncementInfo];
    
    if (self.channel.status.integerValue == 2) { //直播中加载阶梯津贴
        //添加阶梯津贴视图
        [self addLadderWidget];
        [self addLadderLabel];
        //获取津贴列表
        [self initLadderModel];
        [self getLadderList];
        //直播间公告
        if (self.channel.roomNoticeUrl.length > 0) {
            [self displayAnnoucement:self.channel.roomNoticeUrl];
        }
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playLogo.centerY = JHSafeAreaBottomHeight + 10.+20;
    
}
- (UIImage *)openglSnapshotImage
{
    CGSize size = self.view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = self.view.frame;
    [self.view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (UIImage *)screenShotWithFrame:(CGRect )imageRect {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ScreenW, ScreenH), NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}

-(void)getNewCopon{
    
    if (![CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:[LiveLASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]]) {
        [self performSelector:@selector(requestCoupon) withObject:nil afterDelay:2.];
    }
}
-(void)requestCoupon{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/coupon/package/authoptional?code=%@"),@"P001"];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        coponMode = [CoponPackageMode mj_objectWithKeyValues:respondObject.data];
        if (coponMode.code==1710) {
            return ;
        }
        [self handleCopon];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)handleCopon{
    WEAKSELF
    LiveRedPacketView  *coponView=[[LiveRedPacketView alloc]initWithFrame:CGRectMake(ScreenW-100, ScreenH/2+50, 90, 103)];
    [coponView setMode:coponMode];
    [_innerView addSubview:coponView];
    coponView.buttonClick = ^(id sender) {
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:weakSelf complete:^(BOOL result) {
                if (result) {
                    [weakSelf receiveCoupon];
                }
            }];
        }
        else{
            [weakSelf receiveCoupon];
        }
    };
    
    if ([CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:[LASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]]) {
        [coponView showAnimation];
        [coponView setHidden:NO];
        return;
    }
    [coponView setHidden:YES];
    ReceiveCoponView * copon=[[ReceiveCoponView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)];
    [copon setMode:coponMode];
    [_innerView addSubview:copon];
    [copon show];
    copon.block = ^{
        [coponView setHidden:NO];
        [coponView showAnimation];
    };
    copon.buttonClick = ^(id sender) {
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:weakSelf complete:^(BOOL result) {
                if (result) {
                    [weakSelf receiveCoupon];
                }
            }];
        }
        else{
            [weakSelf receiveCoupon];
        }
        
    };
}
-(void)receiveCoupon{
    
    NSDictionary *parameters=@{@"id":coponMode.Id,@"type":@"couponPackage",};
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/receive/auth") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:[LiveLASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]];
        [[UIApplication sharedApplication].keyWindow makeToast:@"领取成功" duration:1.0 position:CSToastPositionCenter];
        JHMyCouponViewController *vc=[[JHMyCouponViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}
-(void)applyConnectMic{
    
    NSString *jsonStr=[CommHelp objectToJsonStr:self.imgList];
    NSString *url= [[NSString stringWithFormat:FILE_BASE_STRING(@"/auth/connectMic/apply?roomId=%@&imgList=%@"),self.channel.roomId,jsonStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        
        [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [_innerView showBubbleView:JHBubbleViewTypeWaitMic];
        
        self.appraiseId=[NSString stringWithFormat:@"%@",respondObject.data];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
       
//        if (self.popDownTimeView) {
//            [self.popDownTimeView removeFromSuperview];
//            self.popDownTimeView=nil;
//        }
        [self.innerView.praiseBtnView removeFromSuperview];
        self.innerView.praiseBtnView.hidden = nil;
//        self.innerView.praiseBtnView.hidden = YES;
        if (self.downTimer) {
            [self.downTimer stopGCDTimer];
        }
        [JHNimNotificationManager sharedManager].micWaitMode.waitAppraiseId=self.appraiseId;
        [JHNimNotificationManager sharedManager].micWaitMode.waitRoomId=self.channel.roomId;
        [JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId=self.channel.channelLocalId;
        
        [JHNimNotificationManager sharedManager].micWaitMode.isWait = YES;

        [_innerView updateRoleType:JHLiveRoleApplication];
        [self.audienceAddPhotoView dismiss];
        self.currentUserRole = CurrentUserRoleApplication;
        //
        [self getConnectMicWaitingCount:^{
            
            if ( [JHNimNotificationManager sharedManager].micWaitMode.waitCount>0) {
                
                if (!_applySuccessAlert) {
                    _applySuccessAlert=[[JHApplyMicSuccessAlertView alloc]initWithFrame:CGRectMake(0,ScreenH, ScreenW, ScreenH)];
                }
                _applySuccessAlert.mode=[JHNimNotificationManager sharedManager].micWaitMode;
                [_applySuccessAlert showAlert];
                WEAKSELF
                [_applySuccessAlert withSureClick:^{
                    weakSelf.isPopFirstView=YES;
                    [weakSelf onClosePlaying];
                }];
                [weakSelf freshPopDownTimeView];
                
            }
            else{
                WEAKSELF
                [weakSelf onAppraiseWithType:JHLiveRoleApplication];
                [weakSelf.view makeToast:@"申请成功,请等待主播连线" duration:1.0 position:CSToastPositionCenter];
            }
        }];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    [SVProgressHUD show];
    
}

-(void)cancleConnectMic{
    
    if ([self.appraiseId length]<=0) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/auth/connectMic/cancel?appraiseId=%@",self.appraiseId];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        
        [_innerView updateRoleType:JHLiveRoleAudience];
        [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [self.audienceConnectView dismiss];
        self.currentUserRole=CurrentUserRoleAudience;
       
        [JHNimNotificationManager sharedManager].micWaitMode=nil;
//        if (self.popDownTimeView) {
//            [self.popDownTimeView removeFromSuperview];
//            self.popDownTimeView=nil;
//        }
//        self.innerView.praiseBtnView.hidden = YES;
         [self.innerView.praiseBtnView removeFromSuperview];
         self.innerView.praiseBtnView = nil;
        //取消连麦后更新申请连麦按钮状态
         self.innerView.canAppraise = self.channel.canAppraise;
        if (self.downTimer) {
            [self.downTimer stopGCDTimer];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
    
    [SVProgressHUD show];
    
}
-(void)getConnectMicWaitingCount:(JHFinishBlock)complete{
    NSString *url = [NSString stringWithFormat:@"/auth/connectMic/waitCount?roomId=%@",[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        JHMicWaitMode * mode=[JHMicWaitMode mj_objectWithKeyValues:respondObject.data];
        [JHNimNotificationManager sharedManager].micWaitMode.waitCount=mode.waitCount;
        [JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond=mode.singleWaitSecond;
        //   [JHNimNotificationManager sharedManager].micWaitMode.isWait=mode.isWait;
        
        complete();
        
    } failureBlock:^(RequestModel *respondObject) {
        
        complete();
        // [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    //  [SVProgressHUD show];
    
}
-(void)getApplyMicInfo:(requsetSuccessBlock)complete{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/auth/connectMic/whichRoom") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHApplyMicRoomMode * mode=[JHApplyMicRoomMode mj_objectWithKeyValues:respondObject.data];
          complete(mode);
        
    } failureBlock:^(RequestModel *respondObject) {
        complete(nil);
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
}
-(void)audienceEnter{
    
    DDLogInfo(@"进来");
    NSString *url = [NSString stringWithFormat:@"/auth/connectMic/back?roomId=%@",self.channel.roomId];
    [HttpRequestTool putWithURL: FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)audienceOut{
    
    DDLogInfo(@"离开");
    NSString *url = [NSString stringWithFormat:@"/auth/connectMic/leave?roomId=%@",self.channel.roomId];
    [HttpRequestTool putWithURL:FILE_BASE_STRING(url) Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
        [self refreshOrder];
    }else if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
//        [self.innerView.resaleLiveRoomTabView refreshTable];
    }
    
    [self noteBrowseDurationBegin];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault
                                                animated:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = NO;
    }

    [self noteBrowseDurationEnd];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
        nav.isForbidDragBack = YES;
    }
    [JHAppAlertViewManger channelLocalId:self.channel.channelLocalId];
    [JHAppAlertViewManger isLinking:(self.currentUserRole == CurrentUserRoleLinker)];
    if (self.needShutDown) {
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    }
    if (self.needShowliveSmallView) {
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    }
    self.needShutDown=NO;
    self.needShowliveSmallView=NO;

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [JHAppAlertViewManger channelLocalId:@""];
    [JHAppAlertViewManger isLinking:NO];
    if (self.needShutDown) {
        [[JHLivePlayer sharedInstance] doDestroyPlayer];
    }
    if (self.needShowliveSmallView) {
        [self initLiveSmallView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    
    //判断是否进行手动对焦显示
    [self doManualFocusWithPointInView:point];
    
}
#pragma mark - 本地预览回调
- (void)onLocalDisplayviewReady:(UIView *)displayView {
    
    displayView.userInteractionEnabled = NO;
    _innerView.localDisplayView = displayView;
    
}

#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    switch (message.messageType) {
        case NIMMessageTypeText:
            [self.innerView addMessages:@[message]];
            break;
        case NIMMessageTypeCustom:
        {
            NIMCustomObject *object = message.messageObject;
            id<NIMCustomAttachment> attachment = object.attachment;
            if ([attachment isKindOfClass:[NTESPresentAttachment class]]) {
                [self.innerView addPresentMessages:@[message]];
            }
        }
            break;
        default:
            break;
    }
}

- (void)chatroomBeKicked:(NIMChatroomBeKickedResult *)result {
    [self didAddBlackMessage:nil];
    
}

- (void)onRecvMessages:(NSArray *)messages
{
    //    NSMutableArray *array = [NSMutableArray array];
    //
    //    for (int i = 0;i<1000;i++){
    //        [array addObjectsFromArray:messages];
    //    }
    //    messages = array.copy;
    for (NIMMessage *message in messages) {
        if (![message.session.sessionId isEqualToString:_chatroomId]
            && message.session.sessionType == NIMSessionTypeChatroom) {
            //不属于这个聊天室的消息
         
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
               //   NSLog(@"********==%ld",((JHSystemMsgAttachment *)attachment).type);
                if ([attachment isKindOfClass:[JHCustomChannelMessageModel class]]) {
                    [self switchMessageWithModel:(id)attachment];
                    break;
                }
                if ([attachment isKindOfClass:[JHRedPacketMessageModel class]]) {
                    [self switchMessageWithModel:(id)attachment];
                    
                    break;
                }
                if ([attachment isKindOfClass:[JHSystemMsgAttachment class]]) {
                    
                    JHSystemMsgType type = ((JHSystemMsgAttachment *)attachment).type;
                    if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeEndLive) {
                        
                        [self audienceOut];
                        if ([JHRootController isLogin]) {
                            [self  audienceOut];
                        }
                        [self exiteNtes];
                        [self.innerView makeUpEndPage];
                         self.roomDetailView.scrollEnabled=NO;
                         [self.innerView.endPageView forbidLiveWithReason:((JHSystemMsgAttachment *)attachment).content];
                          [self endLive];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameLiveDuring object:@(((JHSystemMsgAttachment *)attachment).second)];
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
                    }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeActivityNotification) {
                        [self.webSpecialActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        
                        [self.webActivity natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        [self.webRightBottom natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        
                        [self.auctionListWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        [self.innerView.auctionWeb natActionSubPublicSocketMsg:((JHSystemMsgAttachment *)attachment).data];
                        
                        
                        break;
                    }else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRoomNotification) {
                        [self.innerView showRunViewWithText:((JHSystemMsgAttachment *)attachment).content];
                        
                        break;
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRoomWatchCount) {
                        //直播间观看人数变化
                        self.channel.watchTotal =((JHSystemMsgAttachment *)attachment).watchTotal;
                        [self.innerView refreshChannel:self.channel];
                        break;
                    }
                    
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeSwitchAppraise) {
                        
                        self.channel.canAppraise = ((JHSystemMsgAttachment *)attachment).yesOrNo;
                        if (self.currentUserRole!=CurrentUserRoleApplication&&
                            self.currentUserRole!=CurrentUserRoleLinker){
                            self.innerView.canAppraise = self.channel.canAppraise;
                         }
                         
                        [self.innerView showRunViewWithText:((JHSystemMsgAttachment *)attachment).content];
                        
                        break;
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeStoneExplainMsg){
                        NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        //讲解状态:explainingFlag->1 讲解中 0不显示
                        [[NSNotificationCenter defaultCenter] postNotificationName:kPushStoneExplainNotification object:nil userInfo:[dataDic objectForKey:@"body"]];
                        break;
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypePublishAnnoucementMsg) {
                        
                        NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        [self handleAnnoucement:dataDic[@"body"]];
                        
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeAppraiserRedpacketNewMsg) {
                        
                        NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        [self handleAppraiserRedpacketNewMsg:dataDic[@"body"]];
                        
                    }
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeAppraiserRedpacketGotMsg) {
                        
                        NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        [self handleAppraiserRedpacketGotMsg:dataDic[@"body"]];
                        
                    }
                    
                    if(type == JHSystemMsgTypeShopwindowAddGoods || type == JHSystemMsgTypeShopwindowRefreash || type == JHSystemMsgTypeShopwindowCount || type == JHSystemMsgTypeShopwindowAudienceCount)
                    {
                        return;
                    }

                    //填坑 type<4000的消息 如果不特殊处理 默认飘屏和公聊 以后在增加4000以上的
                    if (((JHSystemMsgAttachment *)attachment).type<JHSystemMsgTypeRoomWatchCount) {
                        [self.innerView addAnimationMessage:(JHSystemMsg *)attachment];
                        [self.innerView addMessages:@[message]];
                    }
       
                    
                }
                
                //                NIMCustomObject *object = message.messageObject;
                //                id<NIMCustomAttachment> attachment = object.attachment;
                //                if ([attachment isKindOfClass:[NTESPresentAttachment class]]) {
                //                    [self.innerView addPresentMessages:@[message]];
                //                }
                //                else if ([attachment isKindOfClass:[NTESLikeAttachment class]]) {
                //                    [self.innerView fireLike];
                //                }
                //                else
                //                    if ([attachment isKindOfClass:[NTESMicConnectedAttachment class]] || [attachment isKindOfClass:[NTESDisConnectedAttachment class]]) {
                //                    [self.handler dealWithBypassMessage:message];
                //                }
                
            }
                break;
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
        NSLog(@"%@",dict);
        if(type == JHSystemMsgTypeShopwindowAddGoods)
        {
            if(self.channel.isAssistant)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotification" object:nil];
            }
            if(IS_DICTIONARY(body))
            {
                static BOOL isShow = NO;
                if(!isShow)
                {
                    isShow = YES;
                    if(![UserInfoRequestManager sharedInstance].showShopwindow && ![self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone])
                    {
                        JHShopwindowGoodsListModel *m = [JHShopwindowGoodsListModel mj_objectWithKeyValues:body];
                        JHShopwindowGoodsAlert *alert = [JHShopwindowGoodsAlert showWithModel:m];
                            [self.innerView addSubview:alert];
                        
                        [alert mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.innerView).offset(10);
                            make.size.mas_equalTo([JHShopwindowGoodsAlert viewSize]);
                            make.bottom.equalTo(self.innerView.bottomBar.mas_top).offset(-5);
                        }];
                        @weakify(self);
                        [alert jh_addTapGesture:^{
                            @strongify(self);
                            JHLiveStoreViewType type =  self.channel.isAssistant ? JHLiveStoreViewTypeSaler : JHLiveStoreViewTypeUser;
                            JHLiveStoreView *storeView = [[JHLiveStoreView alloc] initWithType:type channel:self.channel];
                            [JHRootController.currentViewController.view addSubview:storeView];
                        }];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert removeFromSuperview];
                        });
                    }
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    isShow = NO;
                });
            }
        }
        
        else if(type == JHSystemMsgTypeShopwindowRefreash)///橱窗弹框刷新
        {
            if(self.channel.isAssistant)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotification" object:nil];
            }
        }
        else if(type == JHSystemMsgTypeShopwindowCount)
        {
            if(self.channel.isAssistant)
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
        }
        else if(type == JHSystemMsgTypeShopwindowAudienceCount)///橱窗弹框数量刷新
        {
            if(!self.channel.isAssistant)
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
        }
    });
}

- (void)switchMessageWithModel:(JHCustomChannelMessageModel *)model {
    
    
    switch (model.type) {
        case JHSystemMsgTypeStoneStartLive:{
            self.stoneChannel.channelStatus=2;
            [self.innerView setStoneChannel:self.stoneChannel];
        }
            break;
        case JHSystemMsgTypeStoneEndLive:{
            self.stoneChannel.channelStatus=1;
            [self.innerView setStoneChannel:self.stoneChannel];
        }
            break;
            
            //原石寄售商品变化数量
        case JHSystemMsgTypeStoneForSaleCount:{
            self.stoneChannel.saleCount=model.body.saleCount;
            [self.innerView setStoneChannel:self.stoneChannel];
        }
            
            break;
            //原石小窗等待人数变化
        case JHSystemMsgTypeStoneWaitUserLookCount:{
            self.stoneChannel.seekCount=model.body.seekCount;
            [self.innerView setStoneChannel:self.stoneChannel];
        }
            
            break;
            
        case JHSystemMsgTypeStoneReSalePriceCount:
            
            [self.innerView updateResaleAmount:model.body.totalPrice];
            
            break;
            
        case JHSystemMsgTypeStoneRefreshList:
        
        [self.innerView updateActionButtonCount:0 type:JHSystemMsgTypeStoneRefreshList];
        
        break;
     
        case JHSystemMsgTypeRedPacketRemove: {
            JHRoomRedPacketModel *redModel = (JHRoomRedPacketModel *)model.body;
            [self.redPacketViewModel updateReceivedRedId:redModel.redPacketId];
        }
          
            break;
            
        case JHSystemMsgTypeRedPacketShowNew: {
            JHRoomRedPacketModel *redModel = (JHRoomRedPacketModel *)model.body;
            [self.redPacketViewModel showBigPacketWithModel:redModel];
        }
            break;
        default:
            break;
    }
    
    
}
-(void)onReceiveNimNotification:(NSNotification*)note{
    JHNimNotificationModel *model =(JHNimNotificationModel*)note.object;
    //连麦排队人数变化
    if (model.type==NTESLiveCustomNotificationTypeAudiencedAppraisalCountChange) {
        [self freshPopDownTimeView] ;
    }
    //队列销毁
    if (model.type==NTESLiveCustomNotificationTypeAudiencedRemoveQueue||
        model.type==NTESLiveCustomNotificationTypeAnchourDestroyQueue) {
//        if (self.popDownTimeView) {
//            [self.popDownTimeView removeFromSuperview];
//            self.popDownTimeView=nil;}
        [self.innerView.praiseBtnView removeFromSuperview];
        self.innerView.praiseBtnView = nil;
//        self.innerView.praiseBtnView.hidden = YES;
        if (self.downTimer) {
            [self.downTimer stopGCDTimer];}
        [JHNimNotificationManager sharedManager].micWaitMode=nil;
        [self.view makeToast:@"您已被移出鉴定队列" duration:2. position:CSToastPositionCenter];
    }
    
    if (![model.body.roomId isEqualToString:self.channel.roomId]) {
        return;
    }
    CGRect rect = [UIScreen mainScreen].bounds;
    switch (model.type) {
            
        case JHSystemMsgTypeStoneConfirmResaleAlert: {
            
            JHBePushComfirmResale *confirmResale = [[JHBePushComfirmResale alloc] initWithFrame:rect];
        
            confirmResale.channelCategory = self.channel.channelCategory;
            confirmResale.model = model.body;
            [confirmResale showAlertWithView:self.view];
        }
            break;
            
        case JHSystemMsgTypeStoneBuyerConfirmBreakAlert: {
            JHConfirmBreakPaperView *view = [[JHConfirmBreakPaperView alloc] initWithFrame:rect];
            view.channelCategory = self.channel.channelCategory;

            view.model = model.body;
            [view showAlert];
        }
            break;
        case JHSystemMsgTypeStoneHaveNewPrice: {
            self.innerView.countInfo.offerCount = model.body.offerCount;
            [self.innerView updateOfferPriceCount:model.body.offerCount];
        }
            break;
        case JHSystemMsgTypeStoneConfirmEditPrice: {
            JHBePushComfirmResale *confirmResale = [[JHBePushComfirmResale alloc] initWithFrame:rect];
            confirmResale.isEdit = YES;
            confirmResale.channelCategory = self.channel.channelCategory;
            confirmResale.model = model.body;
            [confirmResale showAlertWithView:self.view];
        }
        
        case JHSystemMsgTypeStoneInSaleCount:{
            self.innerView.countInfo.saleCount = model.body.saleCount;
            [self.innerView updateActionButtonCount:model.body.saleCount type:model.type];
            
        }
            break;
            
        case JHSystemMsgTypeStoneUserActionCount:{
            self.innerView.countInfo.seekCount = model.body.seekCount;
            [self.innerView updateActionButtonCount:model.body.seekCount type:model.type];
            
        }
            break;
            
        case JHSystemMsgTypeStoneWaitShelveCount:{
            self.innerView.countInfo.shelveCount = model.body.shelveCount;
            [self.innerView updateActionButtonCount:model.body.shelveCount type:model.type];
        }
            break;
        case JHSystemMsgTypeStoneOrderCount:
        
            [self.innerView updateActionButtonCount:model.body.orderCount type:JHSystemMsgTypeStoneOrderCount];

        break;
            
        case JHSystemMsgTypeResaleStoneSignUpTips:{

            [JHUnionSignSalePopView showSaleSignView].activeBlock = ^(id obj) {
                [JHUnionSignView signMethod];
            };
        }
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
    DDLogInfo(@"onReceiveAnchorSystemNotification");
    NSLog(@"%@",dict);
    NTESLiveCustomNotificationType type = [dict jsonInteger:@"type"];
    if (type != NTESLiveCustomNotificationTypeRecvOrderChange) {
        if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
            return;
        }
    }
    switch (type) {
        case NTESLiveCustomNotificationTypeAgreeConnectMic:{
            
            currentNotification=notification;
            [self.audienceConnectView dismiss];
            if (connectMicAlert) {
                [connectMicAlert removeFromSuperview];
            }
            if (_applySuccessAlert) {
                [_applySuccessAlert HideMicPopView];
            }
//            if (self.popDownTimeView) {
//                [self.popDownTimeView removeFromSuperview];
//                self.popDownTimeView=nil;
//            }
            [self.innerView.praiseBtnView removeFromSuperview];
            self.innerView.praiseBtnView = nil;
//            self.innerView.praiseBtnView.hidden = YES;
            if (self.downTimer) {
                [self.downTimer stopGCDTimer];
            }
            
            [self.innerView removeBubbleView:JHBubbleViewTypeWaitMic];
            
            NSString * waitTime=@"30";
            if([[dict[@"body"] allKeys] containsObject:@"expireTime"]){
                NSString* endTime=[dict[@"body"] jsonString:@"expireTime"];
                NSInteger time = [CommHelp dateRemaining:[CommHelp timeChange:endTime]];
                waitTime=[NSString stringWithFormat:@"%ld",(long)time];
                if (time>40||time<0) {
                    waitTime=@"30";
                }
            }
            else  if([[dict[@"body"] allKeys] containsObject:@"waitTime"]){
                waitTime=[dict[@"body"] jsonString:@"waitTime"];
            }
            
            self.tableView.scrollEnabled=NO;
            self.roomDetailView.scrollEnabled=NO;
            [JHGrowingIO trackEventId:JHTracklive_chat_invite_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            connectMicAlert=[[JHConnectMicPopAlertView alloc]initWithTitle:@"主播向你发起连麦 是否同意" cancleBtnTitle:@"不，现在忙" sureBtnTitle:[NSString stringWithFormat:@"接受连麦 %@",waitTime]];
            [self.innerView addSubview:connectMicAlert];
            connectMicAlert.delegate=self;
            secondsCountDown = [waitTime intValue];//秒倒计时
            if (countDownTimer) {
                [countDownTimer invalidate];
            }
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
            
        }
            break;
        case NTESLiveCustomNotificationTypeForceDisconnect:
        {
            
            [self.handler dealWithBypassCustomNotification:notification];
        }
            
            break;
        case NTESLiveCustomNotificationTypeRefuseConnectMic:
        {
            NSLog(@"$$$$$$$$踢");
            [self.handler dealWithBypassCustomNotification:notification];
        }
            
            break;
        case NTESLiveCustomNotificationTypeSendReporter:
        {
            
            _reporterCard = nil;
            [self.view addSubview:self.reporterCard];
            self.reporterCard.model = [JHRecorderModel mj_objectWithKeyValues:dict[@"body"]];
            [self.reporterCard showAlert];
            
        }
            break;
            
        case NTESLiveCustomNotificationTypeSendOrder:
        {
            if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
                return;
            }
            OrderMode *model = [OrderMode mj_objectWithKeyValues:dict[@"body"]];
            if ([model.orderCategory isEqualToString:JHOrderCategoryHandlingService]) {
                JHSendOrderProccessGoodPayView *view = [[JHSendOrderProccessGoodPayView alloc] init];
                [view setOrderModel:model];
                [self.innerView addSubview:view];
                LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
                model.orderCategory = model.orderCategory;
                
                [JHGrowingIO trackEventId:JHTracklive_orderreceive_show_process variables:[model mj_keyValues]];
            }else {
                
                    _receivedOrder = nil;
                    [self.view addSubview:self.receivedOrder];
                    self.receivedOrder.model = model;
                    [self.receivedOrder showAlert];
                    [self.innerView updateOrderCountAdd];
                
            }
            
        }
            
            break;
        case NTESLiveCustomNotificationTypeRecvRedPocket:
        {
            if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
                return;
            }
            _recvAmountView = nil;
            [self.view addSubview:self.recvAmountView];
            self.recvAmountView.model = [CoponPackageMode mj_objectWithKeyValues:dict[@"body"]];
            [self.recvAmountView showAlert];
            
        }
            
            break;
        case NTESLiveCustomNotificationTypeAssistantReceived:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNameUpdateOrderNumber" object:nil];
            break;
            
        case NTESLiveCustomNotificationTypeRecvOrderChange: {
            if ([JHRootController isLogin]) {
                NSString *cId = [NSString stringWithFormat:@"%@",dict[@"body"][@"customerId"]];
                
                if ([cId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
                    [self.innerView updateOrderCount:[dict[@"body"][@"orderSum"] integerValue]];
                    
                }
                
            }
            
        }
            
            break;
            
        case JHSystemMsgTypeActivityNotification:
        {
            [self.webSpecialActivity natActionSubPublicSocketMsg:content];
            [self.webActivity natActionSubPublicSocketMsg:content];
            [self.webRightBottom natActionSubPublicSocketMsg:content];
            [self.auctionListWeb natActionSubPublicSocketMsg:content];
            [self.innerView.auctionWeb natActionSubPublicSocketMsg:content];
            
            JHSystemMsg *msg = [JHSystemMsg mj_objectWithKeyValues:dict[@"body"]];
            if (msg.showStyle == 305) {
                NSString *string = dict[@"body"][@"hashMap"][@"grade"];
                [UserInfoRequestManager sharedInstance].user.gameGrade = [string intValue];
                [self updateChatRoomInfo];
            }
            
        }
            break;
            
        case JHSystemMsgTypeForRecvDealOrder:
        {
            if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
                return;
            }
            OrderMode *model = [OrderMode mj_objectWithKeyValues:dict[@"body"]];
            
                JHConfirmDealOrderView *view = [[JHConfirmDealOrderView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                view.model = model;
                [view showAlert];
        }
            break;
            
        default:
            break;
    }
}
 //检查是否需要展示右下角红包图标（鉴定红包）
- (void)checkAppraiserRedpacketStatus
{
    JH_WEAK(self)
    [JHAppraiseRedPacketModel asynReqListChannelId:self.channel.channelLocalId Resp:^(id obj, JHAppraiseRedPacketListModel* data) {
        JH_STRONG(self)
        if(data)
        {
            [self->_innerView setAppraiseRedPacketData:data];
            [self->_innerView appraiserRedPacketHidden:NO];
        }
    }];
}

//有红包消息来,展示红包‘开’页面
- (void)handleAppraiserRedpacketNewMsg:(NSDictionary *)body {
    if(body)
    {
        JHAppraiseRedPacketListModel* data = [JHAppraiseRedPacketListModel convertData:body];
        if([data.channelId length] <= 0) //优先使用消息中传过来Id
            data.channelId = self.channel.channelLocalId;
        [self->_innerView setAppraiseRedPacketData:data];
        [self->_innerView appraiserRedPacketHidden:NO];
    }
}

//领完红包后,右下角红包icon消失：4005
- (void)handleAppraiserRedpacketGotMsg:(NSDictionary *)body {
    NSString* redPacketId  = [body objectForKey:@"redPacketId"];
    [self->_innerView appraiserRedPacketHidden:YES];
}

- (void)handleAnnoucement:(NSDictionary *)body {
    // "公告状态：0-使用中、1-已下线【运营强制下线】、2-历史记录【主播或助理点击下线】")
    NSString *imageUrl = body[@"imageUrl"];
    NSNumber *statusFlag = body[@"statusFlag"];
    if (statusFlag.intValue == 0) {
        [self displayAnnoucement:imageUrl];
    }
    else  {
        [self.innerView removeAnnoucement];
    }
}
#pragma mark - JHConnectMicPopAlertView
- (void)ConnectViewButtonCancle:(JHConnectMicPopAlertView*)connectView{
    
    self.tableView.scrollEnabled=YES;
    self.roomDetailView.scrollEnabled=YES;
    if (connectView==connectMicAlert) {
        [countDownTimer invalidate];
        countDownTimer=nil;
        [self cancleConnectMic];
    }
    [JHGrowingIO trackEventId:JHTracklive_chat_invite_jujue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
}
- (void)ConnectViewButtonComplete:(JHConnectMicPopAlertView*)connectView{
    
    [JHGrowingIO trackEventId:JHTracklive_chat_invite_tongyi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    self.tableView.scrollEnabled=NO;
    self.roomDetailView.scrollEnabled=YES;
    if (connectView==connectMicAlert){
        [countDownTimer invalidate];
        if (self.currentUserRole==CurrentUserRoleApplication){
            [self.handler dealWithBypassCustomNotification:currentNotification];
        }
        else{
            [self.view makeToast:@"当前连麦已取消，连麦失败" duration:1.0 position:CSToastPositionCenter];
        }
    }
}
#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user joined uid %@",uid);
}
- (void)onUserLeft:(NSString *)uid
           meeting:(NIMNetCallMeeting *)meeting
{
    DDLogInfo(@"on user left %@",uid);
    NSMutableArray *uids = [[NTESLiveManager sharedInstance] uidsOfConnectorsOnMic];
    DDLogInfo(@"current on mic user is [%@]", [uids componentsJoinedByString:@" "]);
    //DDLogInfo(@"current on mic user is %@",[NTESLiveManager sharedInstance].connectorOnMic.uid);
    [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:uid];
    
    NIMChatroom *roomInfo = [[NTESLiveManager sharedInstance] roomInfo:_chatroomId];
    if ([uid isEqualToString:roomInfo.creator]) {
        //如果是遇到主播退出了的情况，则自己默默退出去
        [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
        [self.view makeToast:@"连接已断开" duration:2.0 position:CSToastPositionCenter];
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
    }
    
    [self.innerView refreshBypassUI];
    [self.innerView updateUserOnMic];
    
    self.localFullScreen = NO;
    
    
}
- (void)onMeetingError:(NSError *)error
               meeting:(NIMNetCallMeeting *)meeting
{
    
    DDLogError(@"on meeting error: %zd",error.code);
    [self.view.window makeToast:[NSString stringWithFormat:@"互动直播失败 code: %zd",error.code] duration:2.0 position:CSToastPositionCenter];
    //[NTESLiveManager sharedInstance].connectorOnMic = nil;
    [[NTESLiveManager sharedInstance] removeAllConnectors];
    [self.innerView switchToWaitingUI];
    [self requestPlayStream];
    
}

- (void)onKicked{
    
    DDLogInfo(@"被踢");
    if ( self.handler.currentMeeting) {
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
        self.handler.currentMeeting=nil;
        NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        [self didStopByPassingWithUid:myUid];
        [self didForceDisConnectMic];
    }
}
- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    [self.innerView updateRemoteView:yuvData width:width height:height uid:user];
}

- (void)onCameraTypeSwitchCompleted:(NIMNetCallCamera)cameraType {
    if (cameraType == NIMNetCallCameraBack) {
        [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeNormal];
        
    }
    else
    {
        [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeMeiyan1];
    }
    
}
#pragma mark - NTESLiveAudienceHandlerDelegate
- (void)didAddBlackMessage:(NIMMessage *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您已被踢出直播间" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self onClosePlaying];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)didUserBeMute:(BOOL)ismute message:(NIMMessage *)message {
    
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    
    for (NIMChatroomNotificationMember *m in content.targets) {
        NSString *uid = [NIMSDK sharedSDK].loginManager.currentAccount;
        if ([uid isEqualToString:m.userId]) {
            
            NSString *string = ismute?@"禁言":@"解除禁言";
            message.text = [NSString stringWithFormat:@"%@已经被管理员%@",@"您",string];
            [self.innerView addMessages:@[message]];
            
        }
        
        break;
        
        NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
        
        NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
        requst.roomId = self.chatroomId;
        requst.userIds = @[m.userId];
        
        [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
            
            NIMChatroomMember *mm = members.firstObject;
            NSString *string = ismute?@"禁言":@"解除禁言";
            message.text = [NSString stringWithFormat:@"%@被%@",mm.roomNickname,string];//,content.source.nick
            
            //                JHSystemMsg *msg = [[JHSystemMsg alloc] init];
            //                msg.nick = mm.roomNickname?:@"";
            //                msg.content = message.text;
            //                msg.avatar = mm.roomAvatar?:@"";
            //                msg.type = JHSystemMsgTypeNotification;
            //
            //                ext.roomAvatar = mm.roomAvatar;
            //                ext.roomNickname = mm.roomNickname?:@"";
            //                message.messageExt = ext;
            //                message.from = mm.userId;
            
            [self.innerView addMessages:@[message]];
            
        }];
    }
    
}

-(void)didcancleConnectMic{
    
    [self cancleConnectMic];
}

//主播拒绝无法鉴定或者倒计时结束
-(void)didForceDisConnectMic{
    
    NSLog(@"$$$$$$$$断开");
    [_innerView updateRoleType:JHLiveRoleAudience];
    [self.audienceConnectView dismiss];
    self.currentUserRole=CurrentUserRoleAudience;
    [self.innerView removeBubbleView:JHBubbleViewTypeWaitMic];
    
    //如果已经加入 就退出会议
    if ( self.handler.currentMeeting) {
        NSLog(@"$$$$$$$$离开");
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
        self.handler.currentMeeting=nil;
        NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        [self didStopByPassingWithUid:myUid];
    }
    
}
- (void)didUpdateUserOnMicWithUid:(NSString *)uid
{
    
    NSLog(@"%@ - %@", uid, [[NIMSDK sharedSDK].loginManager currentAccount]);
    
    if ([JHLivePlayer sharedInstance].player.playbackState != NELPMoviePlaybackStatePlaying) {
        //即普通连麦观众,并且是正在推拉流的状态,则整个UI更新一把
        NTESMicConnector *connector = [[NTESLiveManager sharedInstance] connectorOnMicWithUid:uid];
        [self.innerView refreshBypassUIWithConnector:connector];
    }
    [self.innerView updateUserOnMic];
}

- (void)willStartByPassing:(NTESPlayerShutdownCompletion)completion
{
    DDLogInfo(@"will start by passing");
    [[JHLivePlayer sharedInstance] doDestroyPlayer];
//    [self.player.view removeFromSuperview];
//       [self shutdown:^{
//           completion();
//       }];
    completion();
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)joinMeetingError:(NSError *)error
{
    DDLogInfo(@"join meeting error %@",error);
    [self.view makeToast:[NSString stringWithFormat:@"与主播连麦失败, code: %zd",error.code]];
    NSString *uid = [[NIMSDK sharedSDK].loginManager currentAccount];
    [self didStopByPassingWithUid:uid];
}

- (void)didStartByPassingWithUid:(NSString *)uid
{
    NSLog(@"$$$$$$$$加入成功");
    
    self.tableView.scrollEnabled=NO;
    
    //如果自己状态不是从申请中来的，可能已经被踢了 直接退出直播
    if ( self.currentUserRole!=CurrentUserRoleApplication) {
        [self   didForceDisConnectMic];
        return;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.audienceConnectView dismiss];
    [_innerView updateRoleType:JHLiveRoleLinker];
    self.currentUserRole=CurrentUserRoleLinker;

    [JHAppAlertViewManger isLinking:(self.currentUserRole == CurrentUserRoleLinker)];
    
    DDLogInfo(@"did start by passing:uid:[%@]", uid);
    NTESMicConnector *connector = [NTESMicConnector me:_chatroomId];
    [self.innerView switchToBypassingUI:connector];
    [self.connectingView dismiss];
    self.connectingView = nil;
    self.isPlaying = NO;
    
    self.localFullScreen = NO;
    [self onSwitchMainScreenWithUid:uid];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchVideoQualityLevel" object:nil];
    [[NIMAVChatSDK sharedSDK].netCallManager selectBeautifyType:NIMNetCallFilterTypeMeiyan1];
    isCameraBack = YES;
    [self.innerView showBubbleView:JHBubbleViewTypeLight];
    [JHGrowingIO trackEventId:JHTracklive_chat_connect_suc variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
}

//断开连麦
- (void)didStopByPassingWithUid:(NSString *)uid
{
    DDLogInfo(@"did stop by passing");
    
    self.tableView.scrollEnabled=YES;
    
    //断开连麦后更新申请连麦按钮状态
    self.innerView.canAppraise = self.channel.canAppraise;
    
    [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:uid];
    if ([uid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        //    [NTESLiveManager sharedInstance].connectorOnMic = nil;
        [self.innerView switchToWaitingUI];
        self.isPlaying = YES;
        [self requestPlayStream];
    } else {
        [self.innerView refreshBypassUI];
    }
    
    JHConnectMicPopAlertView  *connectAlert=[[JHConnectMicPopAlertView alloc]initWithTitle:@"当前鉴定已关闭 给主播个好评吧" cancleBtnTitle:@"暂不评价" sureBtnTitle:@"现在评价"];
    __weak typeof (self) weakSelf = self;
    [self.view addSubview:connectAlert];
    [connectAlert withSureClick:^{
        
        [weakSelf presentEvaluation];
    }];
    //
    [self.innerView removeBubbleView:JHBubbleViewTypeLight];
    
}

- (void)didUpdateLiveType:(NTESLiveType)type
{
    //说明主播重新进来了，这种情况下，刷下type就好了。
    DDLogInfo(@"on receive anchor update live type notification: %zd",type);
    [NTESLiveManager sharedInstance].type = type;
    if (type == NTESLiveTypeInvalid) {
        //发出全局播放结束通知
       // [self shutdown:nil];
         [[JHLivePlayer sharedInstance] doDestroyPlayer];
        [[NSNotificationCenter defaultCenter] postNotificationName:NTESLivePlayerPlaybackFinishedNotification object:nil userInfo:@{NELivePlayerPlaybackDidFinishReasonUserInfoKey:@(NELPMovieFinishReasonPlaybackEnded)}];
    }
}

-(void)didUpdateLiveOrientation:(NIMVideoOrientation)orientation
{
    //旋转controller
    if ( [NTESLiveManager sharedInstance].orientation != orientation)
    {
        NTESAudiencePresentViewController *vc = [[NTESAudiencePresentViewController alloc]init];
        [NTESLiveManager sharedInstance].orientation = orientation;
        //需要清掉界面，防止界面异常
        if (self.connectingView) {
            [self.connectingView dismiss];
            self.connectingView = nil;
        }
        
        [self presentViewController:vc animated:NO completion:^{
            dispatch_after(0, dispatch_get_main_queue(), ^{
                [vc dismissViewControllerAnimated:NO completion:nil];
            });
        }];
    }
}

- (void)didUpdateChatroomMemebers:(BOOL)isAdd  userId:(NSString *)userId{
    if (![userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        if (isAdd) {
            self.channel.watchTotal ++;
        } else {
            self.channel.watchTotal --;
            
        }
        self.channel.watchTotal =
        (self.channel.watchTotal < 0 ? 0 : self.channel.watchTotal);
        
        [self.innerView refreshChannel:self.channel];
        
        [self fetchMember];
    }
}

#pragma mark - NTESPresentShopViewDelegate
- (void)didSelectPresent:(NTESPresent *)present
{
    NIMMessage *message = [NTESSessionMsgConverter msgWithPresent:present];
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
}

#pragma mark - NIMChatroomManagerDelegate
- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason
{
    if ([roomId isEqualToString:_chatroomId]) {
        NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
        DDLogInfo(@"chatroom be kicked, roomId:%@  rease:%zd",roomId,reason);
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:roomId completion:nil];
        [self.view.window makeToast:toast duration:2.0 position:CSToastPositionCenter];
        //        [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state;
{
    DDLogInfo(@"chatroom connection state changed roomId : %@  state:%zd",roomId,state);
    if (state == NIMChatroomConnectionStateEnterOK) {
    }
}

#pragma mark - Private

- (void)changeKeyBoardHeight
{
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if ([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    possibleKeyboardSubview.height = 0;
                }
            }
        }
    }
}
- (void)enterChatroom
{
    
    __weak typeof(self) wself = self;
    NIMChatroomEnterRequest * request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = _chatroomId;
    request.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
    request.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
    
    if (![JHRootController isLogin]){
        
        if (![JHGuestLoginNIMSDKManage sharedInstance].isGuesterLogin) {
            DDLogInfo(@"未登录进入直播间**wself.channel.roomAddrs=%@",wself.channel.roomAddrs);
            request.roomNickname = [NSString stringWithFormat:@"宝友%@",[UserInfoRequestManager sharedInstance].nickRandomNumber];
            request. roomAvatar=@"https://sq-image.oss-cn-beijing.aliyuncs.com/images/img_head_default.png";

            NIMChatroomIndependentMode *mode=[[NIMChatroomIndependentMode alloc]init];
                   mode.username=nil;
                   request.mode=mode;
                   [NIMChatroomIndependentMode registerRequestChatroomAddressesHandler:^(NSString * _Nonnull roomId, NIMRequestChatroomAddressesCallback  _Nonnull callback) {
                       NSError * error;
                       callback(error,wself.channel.roomAddrs);
                       
                   }];
        }else {
            request.roomNickname = [JHGuestLoginNIMSDKManage sharedInstance].guesterInfo.name;
            request. roomAvatar = [JHGuestLoginNIMSDKManage sharedInstance].guesterInfo.img;
        }
       
    }
    
    
    //    User *user = [UserInfoRequestManager sharedInstance].user;
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    dic[@"customerId"] = user.customerId;
    //    dic[@"bought"] = @(self.channel.bought);
    //    dic[@"liveId"] = self.channel.currentRecordId;
    //    dic[@"nick"] = user.name;
    //    dic[@"avatar"] = user.icon;
    //    dic[@"gameGrade"] = @(user.gameGrade);
    //    dic[@"type"] = @(user.type);
    //    dic[@"roomRole"] = @(self.channel.isAssistant?JHRoomRoleAssistant:JHRoomRoleAndience);
    //    dic[@"userTitleLevelIcon"] = [UserInfoRequestManager sharedInstance].levelModel?[UserInfoRequestManager sharedInstance].levelModel.title_level_icon:nil;
    //    dic[@"userTitleLevel"] =  [UserInfoRequestManager sharedInstance].levelModel?[UserInfoRequestManager sharedInstance].levelModel.title_level:@"0";
    
    NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
    
    request.roomExt = [dic mj_JSONString];
    
    DDLogInfo(@"************wself.channel%@",[wself.channel  mj_keyValues]);
    
    
    [[NIMSDK sharedSDK].chatroomManager enterChatroom:request completion:^(NSError * _Nullable error, NIMChatroom * _Nullable chatroom, NIMChatroomMember * _Nullable me) {
        
        if (!error) {
            
            [[NTESLiveManager sharedInstance] cacheMyInfo:me roomId:request.roomId];
            [[NTESLiveManager sharedInstance] cacheChatroom:chatroom];
            wself.handler = [[NTESLiveAudienceHandler alloc] initWithChatroom:chatroom];
            wself.handler.delegate = self;
            wself.handler.datasource = self;
            wself.handler.channel = self.channel;
            [wself.innerView refreshChatroom:chatroom];
            if (wself.isPlaying) {
                //如果开始播放了，就刷一遍播放界面，否则什么事也不做
                [wself.innerView switchToPlayingUI];
            }
            
            WEAKSELF
            __strong typeof(weakSelf) sself = weakSelf;
            
            if (!sself->fetchHistory) {
                [wself fetchHistoryMsg];
                sself->fetchHistory = YES;
            }
            
            [wself getMicWaitStatus];
            if ([JHRootController isLogin]) {
                [wself  audienceEnter];
                [wself sendFreePresent];
            }
            
        }
        else
        {
            
            if ([error.userInfo[@"enum"] isEqualToString:@"NIMRemoteErrorCodeInChatroomBlackList"]) {
                
                [self didAddBlackMessage:nil];
                
                return;
            }
            DDLogError(@"enter chat room error, code : %@, room id : %@",error,request.roomId);
            DDLogError(@"enter chat room error : %@",error.description);
            if (error.code == 13005) {
                [wself.view makeToast:@"用户信息违规" duration:2.0 position:CSToastPositionCenter];
                return;
            }
            [wself.view makeToast:error.description duration:2.0 position:CSToastPositionCenter];
        }
    }];
    
    if (_webActivity) {
        [_webActivity reload];
    }
    
    if (_webRightBottom) {
        [_webRightBottom reload];
    }
    
    if (_webSpecialActivity) {
        [_webSpecialActivity reload];
    }
}

- (void)updateChatRoomInfo {
    
    //    User *user = [UserInfoRequestManager sharedInstance].user;
    [[UserInfoRequestManager sharedInstance] getUserLeveIlnfoCompletion:^(JHUserLevelInfoMode *mode, NSError *error) {
        if (!error) {
            //            NSDictionary *dic = @{@"customerId":user.customerId?:@"",@"bought":@(self.channel.bought),@"liveId":self.channel.currentRecordId,@"nick":user.name,@"avatar":user.icon,@"gameGrade":@(user.gameGrade)};
            NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
            NSString *roomExt = [dic mj_JSONString];
            NIMChatroomMemberInfoUpdateRequest *request = [[NIMChatroomMemberInfoUpdateRequest alloc] init];
            request.roomId = self.chatroomId;
            request.needNotify = YES;
            request.updateInfo = @{@(NIMChatroomMemberInfoUpdateTagExt):roomExt};
            [[NIMSDK sharedSDK].chatroomManager updateMyChatroomMemberInfo:request completion:^(NSError * _Nullable error) {
                
            }];
            
        }
    }];
    
}

-(void)getMicWaitStatus{
    WEAKSELF
    [self getApplyMicInfo:^(JHApplyMicRoomMode *mode) {
        
        [JHNimNotificationManager sharedManager].micWaitMode.waitRoomId=mode.roomId;
        [JHNimNotificationManager sharedManager].micWaitMode.isWait=mode.isWait;
        
        if ([mode.roomId length]>0&&mode.isWait) {
            //顶部倒计时
            [JHNimNotificationManager sharedManager].micWaitMode.waitCount=mode.waitCount;
            [JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond=mode.singleWaitSecond;
            
            [weakSelf freshPopDownTimeView];
            
            if ([mode.roomId isEqualToString:weakSelf.channel.roomId]) {
                weakSelf.appraiseId=mode.appraiseId;
                [JHNimNotificationManager sharedManager].micWaitMode.waitAppraiseId=weakSelf.appraiseId;
                [JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId=weakSelf.channel.channelLocalId;
                weakSelf.currentUserRole=CurrentUserRoleApplication;
                //恢复本房间排队状态
                weakSelf.innerView.canAppraise = YES;
                
                if (_innerView) {
                    [weakSelf.innerView showBubbleView:JHBubbleViewTypeWaitMic];
                    [weakSelf.innerView updateRoleType:JHLiveRoleApplication];
                }
            }
            
        }
        else{
            if (weakSelf.applyApprassal){
                
                if (!weakSelf.channel.canAppraise) {
                    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:@"主播已经暂停鉴定" preferredStyle:UIAlertControllerStyleAlert];
                    [alertVc addAction:[UIAlertAction actionWithTitle:@"先看一会" style:UIAlertActionStyleDefault handler:nil]];
                    [weakSelf presentViewController:alertVc animated:YES completion:nil];
                    weakSelf.applyApprassal=NO;
                    return ;
                }
                [JHGrowingIO trackEventId:JHEventClickfreeauthenticate];
                if (![JHRootController isLogin]) {
                    [JHRootController presentLoginVCWithTarget:weakSelf complete:^(BOOL result) {
                        if (result) {
                            [weakSelf onAgainEnterChatRoom];
                            [weakSelf onAppraiseWithType:JHLiveRoleAudience];
                        }
                    }];
                }else{
                    
                    [weakSelf onAppraiseWithType:JHLiveRoleAudience];
                }
                weakSelf.applyApprassal=NO;
            }
            
        }
    }];
    
}
-(void)freshPopDownTimeView{
    
    WEAKSELF
//    if (!_popDownTimeView) {
//        _popDownTimeView = [[JHPopDownTimeView alloc] initWithFrame:CGRectMake(0, 90+10+StatusBarH, ScreenW, 24)];
//        if (self.type == 1) {
//            _popDownTimeView.top = 90+10+StatusBarH+25+10;
//        }
//        [self.innerView addSubview:_popDownTimeView];
//    }
//    self.innerView.praiseBtnView.hidden = NO;
    if (self.downTimer) {
        [self.downTimer stopGCDTimer];
        self.downTimer=nil;
    }
    
    self.downTimer=[[BYTimer alloc]init];
    
    int waitNum=[JHNimNotificationManager sharedManager].micWaitMode.waitCount;
    __block  int allTime=[JHNimNotificationManager sharedManager].micWaitMode.waitCount*[JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond;
    int interval=60;
    //    if (allTime==0) {
    //        allTime=10;
    //        interval=1;
    //    }
    //其实就是这个角色时，JHLiveRoleApplication
    [weakSelf.innerView updateBottomBarAppraiseButtonTitle:(JHLiveRole)weakSelf.currentUserRole];
    //产品要求把这个预估时间条件去掉// 在其他直播间时,才会有提示
    if ([weakSelf canPopupTipsToAppraise])
    {
        [self trackLiveRoomPublicEventId:JHFromIdentifyActivity];
        NSString* text = [NSString stringWithFormat:@"您申请的鉴定即将到号（当前%d号），请返回直播间以免过号", waitNum];
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:text cancleBtnTitle:@"返回鉴定" sureBtnTitle:@"知道了"];
        [self.view addSubview:alert];
        @weakify(self);
        alert.cancleHandle = ^{
            @strongify(self);
            self.isExitVc = YES;
            [self onClosePlaying];
            self.closeBlock = ^{
                [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            };
            [self trackLiveRoomPublicEventId:JHIdentifyActivityReturnClick];
        };
        
        alert.handle = ^{
            @strongify(self);
            [self trackLiveRoomPublicEventId:JHIdentifyActivityKnowClick];
        };
    }
    [self.downTimer startGCDTimerOnMainQueueWithInterval:interval Blcok:^{
        // 在其他直播间时,才有排队提醒
        if(![weakSelf isSameLiveRoom])
        {
            
//            [weakSelf.popDownTimeView setWaitNum:waitNum waitSecond:allTime];
            weakSelf.innerView.clickApraiseViewBlock = ^{
                weakSelf.isExitVc = YES;
                [weakSelf onClosePlaying];
                weakSelf.closeBlock = ^{
                    [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
                };
            };
            [weakSelf.innerView updatePraiseBtnViewWithWaitNum:waitNum];
        }
        else
        {
            weakSelf.innerView.praiseBtnView.hidden = YES;
        }
        allTime=allTime-interval;
        
        if (allTime<interval)
        {
            [weakSelf.downTimer stopGCDTimer];
        }
    }];
}

- (void)fetchHistoryMsg {
    
    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
    option.limit = 20;
    option.order = NIMMessageSearchOrderDesc;
    option.messageTypes = @[@(NIMMessageTypeText)];
    NSLog(@"%@",self.channel.roomId);
    [[NIMSDK sharedSDK].chatroomManager fetchMessageHistory:self.channel.roomId option:option
     
                                                     result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
        NSArray *reversedArray = [[messages reverseObjectEnumerator] allObjects];
        NSLog(@"%@",messages);
        if (messages.count) {
            self.historyMessage = reversedArray;
            self.historyIndex = 0;
            [self progressHistoryMsg];
        }
        
    } ];
}

- (void)progressHistoryMsg {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressHistoryMsg) object:nil];
    
    if (self.historyIndex>=self.historyMessage.count-1) {
        return;
    }
    
    NIMMessage *message = self.historyMessage[self.historyIndex];
    
    if (message.timestamp*1000 >= self.channel.startShowTime) {//本次直播的消息
        [self.innerView addMessages:@[message]];
    } else {//上次直播的消息 直接执行下一条
        self.historyIndex ++;
        [self progressHistoryMsg];
        return;
    }
    self.historyIndex ++;
    [self performSelector:@selector(progressHistoryMsg) withObject:nil afterDelay:1];
}



- (void)requestPlayStream
{
    if ([JHLivePlayer sharedInstance].player.playbackState == NELPMoviePlaybackStatePlaying) {
        DDLogInfo(@"播放2");
        return;
    }
    DDLogInfo(@"播放3");
    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    if ([[NTESLiveManager sharedInstance] connectorOnMicWithUid:me]) {
        DDLogInfo(@"播放4");
        DDLogDebug(@"already on mic ,ignore requested play stream");
        //请求拉流地址回来后，发现自己已经上麦了，则不需要再开启播放器
        return;
    }
    
    [NTESLiveManager sharedInstance].type = NTESLiveTypeVideo;
    
    //[self.view insertSubview:self.canvas atIndex:0];
    DDLogInfo(@"播放5");
//    [self startPlay:self.channel.rtmpPullUrl inView:self.canvas andControlView:self.innerView.playControlView andMedioType:self.mediaType];
    [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    return;
    
    __weak typeof(self) wself = self;
    [[NTESDemoService sharedService] requestPlayStream:_chatroomId completion:^(NSError *error, NSString *playStreamUrl,NTESLiveType liveType,NIMVideoOrientation orientation) {
        NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
        
        if ([[NTESLiveManager sharedInstance] connectorOnMicWithUid:me]) {
            DDLogDebug(@"already on mic ,ignore requested play stream");
            //请求拉流地址回来后，发现自己已经上麦了，则不需要再开启播放器
            return;
        }
        //        if ([[NTESLiveManager sharedInstance].connectorOnMic.uid isEqualToString:me]) {
        //            DDLogDebug(@"already on mic ,ignore requested play stream");
        //            //请求拉流地址回来后，发现自己已经上麦了，则不需要再开启播放器
        //            return;
        //        }
        if (1) {
            DDLogDebug(@"request play stream complete: %@, canvas: %@, live type : %@",playStreamUrl,wself.canvas,[NTESLiveUtil liveTypeToString:liveType]);
            [NTESLiveManager sharedInstance].type = liveType;
//            [wself startPlay:self.channel.rtmpPullUrl inView:wself.canvas andControlView:wself.innerView.playControlView andMedioType:self.mediaType] ;
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    }
        else
        {
            DDLogDebug(@"start play stream error: %zd, try again in 5 sec.",error.code);
            //拉地址没成功，则过5秒重试
            NSTimeInterval delay = 5.f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself requestPlayStream];
            });
        }
    }];
}

- (void)shareStreamUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.streamUrl;
    
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


#pragma mark - NTESLiveInnerViewDelegate
- (void)onTapAndienceHelp {
    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self anchorId:self.channel.anchorId];
    
}

- (void)onShowAuctionListView:(UIButton *)btn {
    if (![JHRootController isLogin]) {
        WEAKSELF
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            [weakSelf.auctionListWeb loadWebURL:AuctionListURL(weakSelf.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0,weakSelf.channel.isAssistant)];
        }];
        return;
    }
    
    JHWebView *web = [[JHWebView alloc] init];
    [web loadWebURL:AuctionListURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0,self.channel.isAssistant)];
    web.frame = self.innerView.bounds;
    WEAKSELF
    web.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        return [weakSelf.channel mj_JSONString];
    };
    web.operateActionScreenCapture = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        weakSelf.isCreatAnction = YES;
        [weakSelf openCamara];
    };
    
    web.operateActionAuctionSendOrder = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        NSDictionary *dic = [jsonString mj_JSONObject];
        
        JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] init];
        [weakSelf.innerView addSubview:view];
        view.frame = weakSelf.view.bounds;
        view.tag = JHRoomSendOrderViewTag;
        view.anchorId = weakSelf.channel.anchorId;
        view.clickImage = ^(JHRoomUserCardView *sender) {
            [weakSelf openCamara];
        };
        view.customerId = dic[@"viewerId"];
        view.biddingId = dic[@"biddingId"];
        [view showAlert];
        
        
    };
    
    
    //    web.operateActionAuctionSendOrder = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
    //        NSDictionary *dic = [jsonString mj_JSONObject];
    //        weakSelf.sendOrderView.hidden = YES;
    //        [weakSelf.innerView addSubview:weakSelf.sendOrderView];
    //        weakSelf.sendOrderView.customerId = dic[@"viewerId"];
    //        weakSelf.sendOrderView.biddingId = dic[@"biddingId"];
    //        [weakSelf.sendOrderView sendOrderAction:[NSNull null]];
    //    };
    
#warning test
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        weakSelf.isCreatAnction = YES;
    //        [weakSelf openCamara];
    //
    //
    //    });
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        weakSelf.sendOrderView.hidden = YES;
    //        [weakSelf.innerView addSubview:weakSelf.sendOrderView];
    //        weakSelf.sendOrderView.customerId = @"";
    //        [weakSelf.sendOrderView sendOrderAction:[NSNull null]];
    //
    //    });
    
    
    self.auctionListWeb = web;
    [self.view addSubview:web];
}

- (void)onShowCommentListView:(UIButton *)btn {
    
    //显示评论列表
    JHAudienceCommentView * view=[[JHAudienceCommentView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.view addSubview:view];
    [view show];
    [view loadData:self.channel andShowCommentbar:NO];
    
    view.hideCompleteBlock = ^(AppraisalDetailMode *mode) {
        
    };
}

- (void)onShareAction {
    NSString *url = [NSString stringWithFormat:@"%@channelid=%@&code=%@", [UMengManager shareInstance].shareLiveUrl, self.channel.channelLocalId, [UserInfoRequestManager sharedInstance].user.invitationCode];
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];
        
        NSString *title = [NSString stringWithFormat:ShareLiveAppraiseTitle,self.channel.anchorName];
        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveAppraiseText thumbUrl:nil webURL:url type:ShareObjectTypeAppraiseLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
    }else {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=2"]];
        
        NSString *title = [NSString stringWithFormat:ShareLiveSaleTitle,self.channel.anchorName];
        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveSaleText thumbUrl:nil webURL:url type:ShareObjectTypeSaleLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
    }    
}
//申请鉴定、等待鉴定
- (void)onAppraiseWithType:(NSInteger)stateType {
    
    if (stateType==JHLiveRoleAudience) {
        [JHGrowingIO trackEventId:JHTracklive_bottom_identifyapplybtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        
        if (![JHRootController isLogin]) {
            [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
                if (result){
                    
                    [self onAgainEnterChatRoom];
                }
            }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_audienceAddPhotoView) {
                    [_audienceConnectView removeFromSuperview];
                }
                [self.view addSubview:self.audienceAddPhotoView];
                [self.audienceAddPhotoView showTags:self.anchorInfoModel.tags];
            });
           
            [JHGrowingIO trackEventId:JHEventClickfreeauthenticate];
            [JHGrowingIO trackEventId:JHTracklive_identifyapply_xianshi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        }
    }
    
    if (stateType==JHLiveRoleApplication) {
        
        WEAKSELF
        
        [SVProgressHUD show];
        [self getConnectMicWaitingCount:^{
            
            [SVProgressHUD dismiss];
            [weakSelf.audienceConnectView show];
            [weakSelf.audienceConnectView setWaitNum:[JHNimNotificationManager sharedManager].micWaitMode.waitCount andWaitTime:[JHNimNotificationManager sharedManager].micWaitMode.singleWaitSecond*[JHNimNotificationManager sharedManager].micWaitMode.waitCount];
            LiveExtendModel * mode =[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
            mode.waitNum=[NSString stringWithFormat:@"%d",[JHNimNotificationManager sharedManager].micWaitMode.waitCount];
            [JHGrowingIO trackEventId:JHTracklive_identifywait2_show variables:[mode mj_keyValues]];
        }];
    }
}

-(void)presentEvaluation{
    
    JHEvaluationViewController *vc = [[JHEvaluationViewController alloc] init];
    vc.anchorId =self.channel.anchorId ;
    vc.appraiseId =self.appraiseId ;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (BOOL)isPlayerPlaying {
    return ([JHLivePlayer sharedInstance].player.playbackState == NELPMoviePlaybackStatePlaying);
}

- (void)didSendText:(NSString *)text
{
    [JHGrowingIO trackEventId:JHTracklive_sendmsg_sendbtn variables:[[JHGrowingIO liveExtendModelChannel:self.channel] mj_keyValues]];
    //User *user = [UserInfoRequestManager sharedInstance].user;
    //NSDictionary *ext = @{@"avatar":user.icon?user.icon:@"",@"nick":user.name?user.name:@""};
    NIMMessage *message = [NTESSessionMsgConverter msgWithText:text];
    
    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
    User *user = [UserInfoRequestManager sharedInstance].user;
    ext.roomAvatar = [UserInfoRequestManager sharedInstance].user.icon?:@"";
    ext.roomNickname = [UserInfoRequestManager sharedInstance].user.name?:@"";
    
    if ([JHRootController isLogin]){
        
        NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
        ext.roomExt = [dic mj_JSONString];
        
    }
    
    message.messageExt = ext;
    
    NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
    
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:self.channel];
    
    if (error) {
        NSDictionary *dic = error.userInfo;
        NSString *string = dic[@"enum"];
        if ([string isEqualToString:@"NIMRemoteErrorCodeInChatroomMuteList"]) {
            
            //            User *user = [UserInfoRequestManager sharedInstance].user;
            //            NIMCustomSystemNotification *notification = [NTESSessionCustomNotificationConverter notificationBeMuteSendAnchorMsg:self.channel.roomId avatar:user.icon nick:user.name msg:message.text];
            //            NIMSession *session = [NIMSession session:self.channel.creatorId type:NIMSessionTypeP2P];
            //
            //            [[NIMSDK sharedSDK].systemNotificationManager sendCustomNotification:notification toSession:session completion:^(NSError * _Nullable error) {
            //
            //            }];
            [self.view makeToast:@"您已被禁言" duration:1.5 position:CSToastPositionCenter];
        }
        model.result = @"false";
    }else {
        model.result = @"true";
    }
    
    [JHGrowingIO trackEventId:JHTracklive_sendmsg_result variables:[model mj_keyValues]];
    
}


- (void)onActionType:(NTESLiveActionType)type sender:(UIButton *)sender
{
    switch (type) {
        case NTESLiveActionTypeLike:
        {
            NSTimeInterval frequencyTimestamp = 1.0; //赞最多一秒发一次
            NSTimeInterval now = [NSDate date].timeIntervalSince1970;
            if ( now - _lastPressLikeTimeInterval > frequencyTimestamp) {
                _lastPressLikeTimeInterval = now;
                NIMMessage *message = [NTESSessionMsgConverter msgWithLike];
                NIMSession *session = [NIMSession session:_chatroomId type:NIMSessionTypeChatroom];
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];
                if ([CommHelp isFirstForName:[self.channel.channelId stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]) {
                    [self uploadLikeCount];
                }
                
            }
            if ([sender isKindOfClass:[UIButton class]]) {
                [JHGrowingIO trackEventId:JHTracklive_landbtn variables:[[JHGrowingIO liveExtendModelChannel:self.channel] mj_keyValues]];
                
            }else {
                [JHGrowingIO trackEventId:JHTracklive_watch_doubleland variables:[[JHGrowingIO liveExtendModelChannel:self.channel] mj_keyValues]];
                
            }
            
            JHBuryPointLiveInfoModel *model = [[JHBuryPointLiveInfoModel alloc] init];
            model.anchor_id = self.channel.anchorId;
            model.live_id = self.channel.currentRecordId;
            model.room_id = self.channel.roomId;
            model.live_type = self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise?2:1;
            model.channel_local_id = self.channel.channelLocalId;
            model.time = [[CommHelp getNowTimeTimestampMS] integerValue];
            model.from = self.fromString;
            [[JHBuryPointOperator shareInstance] liveLikeBuryWithModel:model isDouble:![sender isKindOfClass:[UIButton class]]];
            
            
        }
            break;
        case NTESLiveActionTypePresent:{
            NTESPresentShopView *shop = [[NTESPresentShopView alloc] initWithFrame:self.view.bounds];
            shop.delegate = self;
            [shop show];
            break;
        }
        case NTESLiveActionTypeCamera:{
            if (!isCameraBack) {
                _cameraType = NIMNetCallCameraBack;
                isCameraBack = YES;
                self.focusView.hidden = YES;
            }else {
                _cameraType = NIMNetCallCameraFront;
                isCameraBack = NO;
                
            }
            [[NIMAVChatSDK sharedSDK].netCallManager switchCamera:_cameraType];
        }
            break;
        case NTESLiveActionTypeInteract:
            if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
            {
                if (self.connectingView) {
                    //说明正在请求连接
                    [self.connectingView show];
                }
                else
                {
                    NTESInteractSelectView *interact = [[NTESInteractSelectView alloc] initWithFrame:self.view.bounds];
                    interact.delegate = self;
                    if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeVideo) {
                        interact.types = @[@(NIMNetCallMediaTypeVideo),@(NIMNetCallMediaTypeAudio)];
                    }else{
                        interact.types = @[@(NIMNetCallMediaTypeAudio)];
                    }
                    [interact show];
                }
            }
            break;
            
        case NTESLiveActionTypeShare:{
            [self shareStreamUrl];
        }
            break;
        case NTESLiveActionTypeFlash:
        {
            NSString * toast ;
            if (isCameraBack) {
                _isflashOn = !_isflashOn;
                [[NIMAVChatSDK sharedSDK].netCallManager setCameraFlash:_isflashOn];
                toast = _isflashOn ? @"闪光灯已打开" : @"闪光灯已关闭";
                
            }
            else
            {
                toast = @"前置摄像头模式，无法使用闪光灯";
            }
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
        }
            break;
        case NTESLiveActionTypeWishPaper: {
            
            JHWebViewController *vc = [[JHWebViewController alloc] init];
            vc.titleString = @"我的心愿单";
            vc.urlString = ShowWishPaperURL((int)(self.audienceUserRoleType >JHAudienceUserRoleTypeAppraise),1,(int)self.channel.isAssistant);
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
            
        case NTESLiveActionTypeFocus:
        {
            NSString * toast ;
            if (isCameraBack) {
                if (self.localFullScreen) {
                    _isFocusOn = !_isFocusOn;
                    self.focusView.hidden = YES;
                    toast = _isFocusOn ? @"手动对焦已打开" : @"手动对焦已关闭，启动自动对焦模式";
                    if (!_isFocusOn) {
                        [[NIMAVChatSDK sharedSDK].netCallManager setFocusMode:NIMNetCallFocusModeAuto];
                    }
                    
                    UIButton * button = (UIButton *)sender;
                    button.selected = !button.selected;
                    
                }else {
                    toast = @"当前小窗口，无法手动调焦";
                    
                }
                
            }
            else
            {
                toast = @"前置摄像头模式，无法手动调焦";
            }
            
            [self.view makeToast:toast duration:1.0 position:CSToastPositionCenter];
            
        }
        case NTESLiveActionTypeMute:
            sender.selected = !sender.selected;
            [[NIMAVChatSDK sharedSDK].netCallManager setMute:sender.selected];
            
            break;
        case NTESLiveActionTypeMuteList: {
            
            JHMuteListViewController *vc = [[JHMuteListViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            
            break;
        case NTESLiveActionTypeJubao: {
            [self jubaoAction];
        }
            break;
        case NTESLiveActionTypeAnnouncement: {
            JHPublishAnnouncementController *paController = [JHPublishAnnouncementController new];
            paController.channelId = self.channel.channelLocalId;
            [self.navigationController pushViewController:paController animated:YES];
        }
            
        default:
            break;
    }
}
//进入直播间前,首先关闭之前播放器
- (void)onCloseRoom{
    
    if (self.currentUserRole==CurrentUserRoleLinker){
        return;
    }
   // [self onClosePlaying];
    
    [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:YES];
   // [self  doDestroyPlayer];
    [[JHLivePlayer sharedInstance] doDestroyPlayer];
    [[JHLivePlayerManager sharedInstance ] shutdown];
    [self clean];
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    [[NTESLiveManager sharedInstance] stop];
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroomId completion:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:JHKeyWindow animated:NO];
        if (self.closeBlock) {
            self.closeBlock();
        }
       
       }];
}
//退出直播间
- (void)onClosePlaying
{
    [JHGrowingIO trackEventId:JHTracklive_closebtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    //status = 2时，为直播或鉴定中
    if ((self.channel.status.integerValue == 2) || self.handler.currentMeeting) {
        
        if ([self canPopupTipsClose]) {
            
            int waitNum=[JHNimNotificationManager sharedManager].micWaitMode.waitCount;
            NSString* tipText = [NSString stringWithFormat:@"您申请的鉴定当前排在第%d位\n离开直播间可能会错过", waitNum];
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:tipText preferredStyle:UIAlertControllerStyleAlert];
            JH_WEAK(self)
            [alertVc addAction:[UIAlertAction actionWithTitle:@"留下" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                [self trackLiveRoomPublicEventId:JHIdentifyActivityStayClick];
            }]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                [self doExitLive];
                [self trackLiveRoomPublicEventId:JHIdentifyActivityLeaveClick];
            }]];
            [self presentViewController:alertVc animated:YES completion:nil];
            
        }
        else{
            
            [self doExitLive];
        }
    }
    else
    {
        [self doExitLive];
    }
}

- (void)trackLiveRoomPublicEventId:(NSString *)eventId
{
    [JHGrowingIO trackPublicEventId:eventId paramDict:[self trackPublicParams]];
}//TODO:appraiserId??

- (NSDictionary*)trackPublicParams
{
    return @{@"roomId":self.channel.roomId ? : @"",@"anchorId":self.channel.anchorId ? : @"",@"channelType":self.channel.channelType,@"channelLocalId":self.channel.channelLocalId ? : @"", @"appraiserId":self.appraiseId ? : @"",  @"appraiseId":self.appraiseId ? : @"", @"channelCategory": self.channel.channelCategory ? : @""};
}
/**
 * 1:连麦中 2:申请中(即排队中)>且排队数小于5
 */
- (BOOL)canPopupTipsClose
{
    if(self.currentUserRole == CurrentUserRoleLinker ||
       (self.currentUserRole == CurrentUserRoleApplication &&
       [JHNimNotificationManager sharedManager].micWaitMode.waitCount <= 5))
    {
        return YES;
    }
    return NO;
}

/**
 * 1:用户在其它直播间 2:鉴定队列用户，在次序1、3、5时,则给予弹屏提醒
 */
- (BOOL)canPopupTipsToAppraise
{
    int waitCount = [JHNimNotificationManager sharedManager].micWaitMode.waitCount;
    if(![self isSameLiveRoom] &&
       (waitCount == 1 || waitCount == 3 || waitCount == 5))
    {
        return YES;
    }
    return NO;
}

- (BOOL)isSameLiveRoom
{
    if([[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId isEqualToString:self.channel.roomId])
        return YES;
    return NO;
}

- (void)exiteNtes {
    
    [ self removeTimes];
    [self  removeChatManager];
    [self cancelRequest];
    [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressHistoryMsg) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(guideLoginRedPocket) object:nil];
    
    //关闭直播 如果小窗在播 关闭小窗
    if (self.stoneChannel) {
        self.stoneChannel.channelStatus=1;
        [self.innerView setStoneChannel:self.stoneChannel];
    }
}
- (void)doExitLive
{
    [self audienceOut];
    [self uploadLikeCount];
    [self exiteNtes];
    if (self.streamUrl) {
        [self buryOut];
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    __weak typeof(self) weakSelf = self;
    
    [[NTESLiveManager sharedInstance] delAllConnectorsOnMic];
    [[NTESLiveManager sharedInstance] stop];
    DDLogInfo(@"**********doExitLive");
    
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroomId completion:^(NSError * _Nullable error) {
        DDLogInfo(@"**********exitChatroom");
        [weakSelf.innerView clean];
        [[JHLivePlayerManager sharedInstance ] shutdown];
       // [weakSelf doDestroyPlayer];
        if ([[NSUserDefaults standardUserDefaults]boolForKey:kFloatWindowLiveClose]) {
              [[JHLivePlayer sharedInstance] doDestroyPlayer];
        }
        else{
            if ([weakSelf.channel.status isEqualToString:@"2"]){
                [weakSelf initLiveSmallView];
            }
        }
      
        DDLogInfo(@"**********shutdown");
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        if (weakSelf.isExitVc) {
            [weakSelf.navigationController  popToRootViewControllerAnimated:NO];
        }
        else{
            
            if (weakSelf.isPopFirstView) {
                [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
                [JHRootController setTabBarSelectedIndex:1];
            }
            else
            {
                [weakSelf.navigationController  popViewControllerAnimated:YES];
            }
        }
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    }];
    if ([CommHelp isShowAppraisalAlert]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            JHAppAlertModel *m = [JHAppAlertModel new];
            m.type = JHAppAlertTypeAppRaise;
            m.localType = JHAppAlertLocalTypeHome;
            m.typeName = AppAlertGuideMarket;
            [JHAppAlertViewManger addModelArray:@[m]];
        });
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportViewTime) object:nil];
    
}
-(void)initLiveSmallView{
    
    if ([JHLivePlayer sharedInstance].player) {
        JHLivePlaySMallView * view=[JHLivePlaySMallView sharedInstance];
        view.channelMode=self.channel;
        [JHKeyWindow addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(JHKeyWindow).offset(-200);
            make.right.equalTo(JHKeyWindow.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(120, 190));
        }];
        [[JHLivePlayer sharedInstance].player.view removeFromSuperview];
        [view.playView addSubview:[JHLivePlayer sharedInstance].player.view];
        [[JHLivePlayer sharedInstance].player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
    }
}
- (void)onCloseBypassingWithUid:(NSString *)uid
{
    DDLogInfo(@"audience close by passing");
    if (![[NTESDevice currentDevice] canConnectInternet]) {
        [self.view makeToast:@"当前无网络,请稍后重试" duration:2.0 position:CSToastPositionCenter];
        return;
    }
    [[NTESLiveManager sharedInstance] delConnectorOnMicWithUid:uid];
    
    if ([uid isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        [self.innerView switchToWaitingUI];
        [self requestPlayStream];
        [[NIMAVChatSDK sharedSDK].netCallManager leaveMeeting:self.handler.currentMeeting];
    }
}
- (void)onSwitchMainScreenWithUid:(NSString *)uid {
    self.localFullScreen = !self.localFullScreen;
    self.innerView.localFullScreen = self.localFullScreen;
}
-(void)onAgainEnterChatRoom{
    
    //登录后重新获取助理状态
    [SourceMallApiManager getChannelDetail:self.channel.channelLocalId Completion:^(BOOL hasError, ChannelMode *channelMode) {
        if (!hasError) {
            self.channel.isAssistant = channelMode.isAssistant;
            if (self.channel.isAssistant) {
                [self.innerView removeFollowBubble];
            }
        }
    } ];
    
    if (self.streamUrl) {
        [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroomId completion:^(NSError * _Nullable error) {
            [self enterChatroom];
        }];
    }
    [self.innerView reloadAnctionWeb];
}

#pragma mark =============== JHAudienceConnectDelegate
- (void)onCancelConnect:(id)sender
{
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您确定要取消排队吗？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [alert addBackGroundTap];
    [self.view addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
         [JHGrowingIO trackEventId:JHLiveRoomMicCancleConfirmClick];
        [self cancleConnectMic];
    };
}
- (void)onBackSourceMall:(id)sender{
    
    self.isPopFirstView=YES;
    [self onClosePlaying];
    
}
#pragma mark - Notification

- (void)playerDidPlay:(NSNotification *)notification
{
    DDLogInfo(@"player %@ did play",[JHLivePlayer sharedInstance].player);
    [self.innerView switchToPlayingUI];
    for (UIView * view in self.canvas.subviews) {
        NSLog(@"mmm==%@",[view class]);
        if ([view isKindOfClass:NSClassFromString(@"IJKSDLGLView")]) {
            view.contentMode = UIViewContentModeScaleAspectFill;
            break;
        }
    }
    self.isPlaying = YES;
}

- (void)playbackFinshed:(NSNotification *)notification
{
    switch ([[[notification userInfo] valueForKey:NELivePlayerPlaybackDidFinishReasonUserInfoKey] intValue])
    {
        case NELPMovieFinishReasonPlaybackEnded:
            self.isPlaying = NO;
            [self.innerView switchToEndUI];
            break;
        case NELPMovieFinishReasonPlaybackError:
            if (self.isPlaying) {
                NSLog(@"mmmmm11111");
                [self.innerView switchToLinkingUI];
            }else{
                NSLog(@"mmmmm22222");
                [self.innerView switchToEndUI];
            }
            break;
        case NELPMovieFinishReasonUserExited:
            break;
        default:
            break;
    }
}

#pragma mark - NTESLiveInnerViewDataSource
- (id<NELivePlayer>)currentPlayer
{
    return [JHLivePlayer sharedInstance].player;
}

- (void)onShowInfoWithModel:(NTESMessageModel *)model{
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant) {
        
        //        self.sendOrderView.hidden = NO;
        //        self.sendOrderView.biddingId = nil;
        //        [self.view addSubview:self.sendOrderView];
        //        self.sendOrderView.model = model;
        //        [self.sendOrderView showAlert];
        //
        [self makeCardViewWithModel:model];
        
        
    }
    
    
}

#pragma mark - Get


- (void)makeCardViewWithModel:(NTESMessageModel *)model {
    JHRoomUserCardView *_sendOrderView = [JHRoomUserCardView new];
    _sendOrderView.frame = self.view.bounds;
    _sendOrderView.anchorId = self.channel.anchorId;
    _sendOrderView.roomId = self.channel.roomId;
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
        if ([sender.Id isEqualToString:JHOrderCategoryHandlingService]) {//加工服务单
            JHSendOrderProccessGoodView *view = [[JHSendOrderProccessGoodView alloc] init];
            [weakSelf.innerView addSubview:view];
            [view requestProccessGoodsBuyId:object.customerId isAssistant:1];
            
        }else {
            JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] init];
            [weakSelf.innerView addSubview:view];
            view.orderCategory = sender;
            view.frame = weakSelf.view.bounds;
            view.tag = JHRoomSendOrderViewTag;
            view.customerId = object.customerId;
            view.anchorId = weakSelf.channel.anchorId;
            [view showAlert];
            
            view.clickImage = ^(JHRoomUserCardView *sender) {
                [weakSelf openCamara];
            };
        }
        
        
    };
    
}


- (void)openCamara {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.navigationController.navigationBar.translucent = NO;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //                picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟无效,请真机测试");
    }
    
}
-(JHPushOrderView *)receivedOrder {
    if (!_receivedOrder) {
        _receivedOrder = [[JHPushOrderView alloc] initWithFrame:self.view.bounds];
    }
    return _receivedOrder;
    
}
- (JHRecvAmountView *)recvAmountView {
    if (!_recvAmountView) {
        _recvAmountView = [[NSBundle mainBundle] loadNibNamed:@"JHSendAmountView" owner:nil options:nil].lastObject;
        _recvAmountView.frame = self.view.bounds;
    }
    return _recvAmountView;
    
}

- (JHReporterCard *)reporterCard {
    if (!_reporterCard) {
        _reporterCard = [[NSBundle mainBundle] loadNibNamed:@"JHReporterCard" owner:nil options:nil].firstObject;
        _reporterCard.frame = self.view.bounds;
    }
    return _reporterCard;
}


- (JHLiveRoomDetailView *)roomDetailView {
    if (!_roomDetailView) {
        _roomDetailView = [[JHLiveRoomDetailView alloc] initWithFrame:self.view.bounds];
    }
    return _roomDetailView;
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


- (UIView *)canvas
{
    if (!_canvas) {
        _canvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
        _canvas.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _canvas.contentMode = UIViewContentModeScaleAspectFill;
        _canvas.clipsToBounds = YES;
    }
    return _canvas;
}

- (UIView *)innerView
{
    //
    if (!_innerView&&!_isClean) {
        _innerView = [[JHCustomizeAndienceInnerView alloc] initWithChannel:self.channel frame:self.view.bounds isAnchor:NO];
        _innerView.type = self.audienceUserRoleType;
        _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_innerView refreshChannel:self.channel];
        _innerView.delegate = self;
        _innerView.dataSource = self;
        _innerView.careDelegate = self;
        //        _innerView.type=self.type;
        WEAKSELF
        _innerView.reSaleRoomHiddenActivity = ^(id obj) {
            if (weakSelf.activityIcon) {
                BOOL isHidden = [obj boolValue];
                weakSelf.activityIcon.hidden = isHidden;
            }
            
        };
    }
    return _innerView;
}

- (JHAnchorHomeView *)anchorHomeView {
    if (!_anchorHomeView) {
        _anchorHomeView = [[JHAnchorHomeView alloc] init];
        _anchorHomeView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH);
        _anchorHomeView.delegate = self;
    }
    return _anchorHomeView;
}

- (JHAudienceConnectView *)audienceConnectView {
    if (!_audienceConnectView) {
        _audienceConnectView = [[JHAudienceConnectView alloc] initWithFrame:self.view.bounds];
        _audienceConnectView.channel=self.channel;
        _audienceConnectView.delegate=self;
    }
    return _audienceConnectView;
}
- (JHAudienceApplyConnectView *)audienceAddPhotoView {
    if (!_audienceAddPhotoView) {
        _audienceAddPhotoView = [[JHAudienceApplyConnectView alloc] initWithFrame:self.view.bounds];
        _audienceAddPhotoView.delegate=self;
    }
    return _audienceAddPhotoView;
}
- (void)setAnchorInfoModel:(JHAnchorInfoModel *)anchorInfoModel {
    _anchorInfoModel = anchorInfoModel;
    self.innerView.anchorInfoModel = anchorInfoModel;
    [self.roomDetailView setLiveRoomAnchorInfoModel:anchorInfoModel roleType:self.audienceUserRoleType];
    //埋点数据传入
    [self.roomDetailView setLiveRoomEventData:[self trackPublicParams] roleType:self.audienceUserRoleType];
    self.roomDetailView.anchorDetailView.model = anchorInfoModel;
    if (self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise) {
        [self.roomDetailView.anchorDetailView setSaleAnchor];
    }
    
}
-(JHWaterPrintView*)playLogo{
    if (!_playLogo) {
        _playLogo = [[JHWaterPrintView alloc] initWithImage:[UIImage imageNamed:@"img_water_print"] roomId:self.channel.roomId];
        _playLogo.mj_x = ScreenW-45-_playLogo.mj_w-10;
        _playLogo.centerY = JHSafeAreaBottomHeight + 10.+20;
    }
    return _playLogo;
}
-(UITableView*)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource = self;
        _tableView.alwaysBounceVertical=NO;
        _tableView.bounces=NO;
        _tableView.scrollsToTop=NO;
        _tableView.scrollEnabled = YES;
        _tableView.pagingEnabled = YES;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView. estimatedRowHeight=ScreenH;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.backgroundColor = [UIColor blackColor];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
    }
    
    return _tableView;
    
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
    
    requst.roomId = _chatroomId;
    requst.type = NIMChatroomFetchMemberTypeTemp;
    requst.limit = 30;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
        self.audienceArray = members.mutableCopy;
        [self.innerView reloadAudienceData:self.audienceArray];
        
    }];
}

- (void)fetchAnchorInfo {
    [HttpRequestTool getWithURL:  FILE_BASE_STRING(@"/authoptional/appraise") Parameters:@{@"customerId" : self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        
        JHAnchorInfoModel *model = [JHAnchorInfoModel mj_objectWithKeyValues:respondObject.data];
        
        self.anchorHomeView.model = model;
        self.anchorInfoModel = model;
        if (model.isFollow) {
            [self.innerView removeFollowBubble];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
}

#pragma mark - JHLiveEndViewDelegate

- (void)didPressBackButton {
    [self onClosePlaying];
}

- (void)didPressCareOffButton:(UIButton *)btn {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result) {
                [self onAgainEnterChatRoom];
                [self fetchAnchorInfo];
                
            }
            
        }];
        return;
    }
    
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.channel.anchorId,@"status":@(!btn.selected)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        //        BOOL isfollow = !btn.selected;
        
        [self fetchAnchorInfo];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
}
- (void)didPressAnchorView:(ChannelMode *)mode {
    [self onClosePlaying];
    WEAKSELF
    self.closeBlock = ^{
        weakSelf.isExitVc = YES;
        [JHRootController EnterLiveRoom:mode.channelId fromString:JHLiveFromroomFinish];
    };
}
//直播间信息<头像点击>
- (void)didPressAnchorAvatar:(NIMChatroomMember *)member {
    
    if (self.currentUserRole==CurrentUserRoleApplication||self.currentUserRole==CurrentUserRoleLinker) {
        return;
    }
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {//0 鉴定观众
        [self.view addSubview:self.anchorHomeView];
        //  self.needShutDown=YES;
        [self fetchAnchorInfo];
        [_anchorHomeView showAlert];
    }
    else if (self.audienceUserRoleType == JHAudienceUserRoleTypeSale || self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant) {
        /// 1 卖货观众 2卖货助理 社区版本才可以跳转
            JHAnchorInfoViewController *vc = [[JHAnchorInfoViewController alloc] init];
            vc.channel = self.channel;
            [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
            [JHGrowingIO trackEventId:JHChannelLocalldAnchorClick variables:@{@"channelLocalId":self.channel.channelLocalId ? : @""}];
    }
}

-(void)timeFireMethod{ 
    
    secondsCountDown--;
    if (connectMicAlert) {
        [connectMicAlert setTimeCount:secondsCountDown];
    }
    if(secondsCountDown==0){
        
        [countDownTimer invalidate];
        countDownTimer=nil;
        self.tableView.scrollEnabled=YES;
        self.roomDetailView.scrollEnabled=YES;
        [self didcancleConnectMic];
        [connectMicAlert HideMicPopView];
        [JHGrowingIO trackEventId:JHTracklive_chat_invite_chaoshi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    }
}
-(void)addLikeCountTimer{
    
    
    WEAKSELF
    if (_likeCountTimer) {
        [_likeCountTimer stopGCDTimer];
    }
    _likeCountTimer=[[BYTimer alloc]init];
    [self.likeCountTimer startGCDTimerOnMainQueueWithInterval:20 Blcok:^{
        [weakSelf uploadLikeCount];
    }];
}

- (void)doManualFocusWithPointInView:(CGPoint)point
{
    CGFloat actionViewHeight = [self.innerView getActionViewHeight];
    BOOL pointsInRect = point.y < self.view.height - actionViewHeight;
    //后置摄像头允许对焦
    if (_localFullScreen && (NIMNetCallMediaType)[NTESLiveManager sharedInstance].type == NTESLiveTypeVideo && isCameraBack && _isFocusOn && pointsInRect ) {
        // 代执行的延迟消失数量
        static int delayCount = 0;
        
        // 焦点显示
        self.focusView.center = CGPointMake(point.x, point.y);
        [self.view bringSubviewToFront:self.focusView];
        self.focusView.hidden = NO;
        [self beginAnimation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self endAnimation];
        });
        
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


#pragma mark =============== addPhoto ===============
-(void)addPhoto{
    
    [HKClipperHelper shareManager].nav = self.navigationController;
    [HKClipperHelper shareManager].clippedImgSize = CGSizeMake(ScreenW, ScreenW*14./15.);
    
    [HKClipperHelper shareManager].clipperType = ClipperTypeImgMove;
    [HKClipperHelper shareManager].systemEditing = NO;
    [HKClipperHelper shareManager].isSystemType = YES;
    MJWeakSelf
    [HKClipperHelper shareManager].clippedImageHandler = ^(UIImage *image) {
        
        weakSelf.photoImg=image;
        [weakSelf UploadImage];
        
    };
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
    
}
-(void)UploadImage{
    
    NOSFormData * data=[[NOSFormData alloc]init];
    data.fileImage=self.photoImg;
    data.fileDir=@"apply_appraisal";
    
    WEAKSELF
    [[NOSUpImageTool getInstance] upImageWithformData:data successBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [SVProgressHUD showSuccessWithStatus:@"上传成功"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        [weakSelf.audienceAddPhotoView setCameraImage:weakSelf.photoImg];
        weakSelf.imgList=[NSMutableArray arrayWithCapacity:10];
        [weakSelf.imgList addObject:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        //后续流程可能执行NOSAsyncRun,此处不能保证主线程
        if([NSThread isMainThread])
        {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [SVProgressHUD showErrorWithStatus:respondObject.message];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [MBProgressHUD hideHUDForView:self.view animated:NO];
                 [SVProgressHUD showErrorWithStatus:respondObject.message];
                 [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            });
        }
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


-(void)onComplete{
    
    if ([self.imgList count]!=0) {
        
        [self applyConnectMic];
        
    }
    
    else{
        [self.view makeToast:@"请上传鉴定产品图片" duration:1.0 position:CSToastPositionCenter];
    }
    
}
//相册、相机调用方法
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[HKClipperHelper shareManager] photoWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
}

#pragma mark -
- (void)sendPresentWithId:(NSString *)giftId {
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/gift/send/auth") Parameters:@{@"giftId":giftId,@"roomId":self.chatroomId,@"amount":@(1)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [UserInfoRequestManager sharedInstance].user.balance = [NSString stringWithFormat:@"%@",respondObject.data];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRechargeSuccess object:nil];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:@"赠送失败"];
        
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
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.audienceUserRoleType) {
        if (self.isCreatAnction) {//创建竞拍时候上传图片
            
            self.isCreatAnction = NO;
            
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
            
            
            
        }else {//卖场发单
            
            JHRoomSendOrderView *view = [self.innerView viewWithTag:JHRoomSendOrderViewTag];
            [view showImageViewAction:image];
            
        }
        
        
    }
    
}

- (void)getNotic {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/sysNotice/roomNotice") Parameters:@{@"noticeEnum":@"enter",@"anchorId":self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        NSArray *array = respondObject.data;
        for (NSDictionary *dic in array) {
            if (dic[@"content"]) {
                [_innerView showRunViewWithText:dic[@"content"]];
                
            }
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)getNoPayOrderCount {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/countWaitPayOrderSum") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [_innerView updateOrderCount:[respondObject.data[@"orderSum"] integerValue]];
    } failureBlock:^(RequestModel *respondObject) {
//        NSLog(@"111");
    }];
}
- (void)uploadLikeCount{
    
    if (_innerView.ownLikeCount!=0) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channelLike") Parameters:@{@"likeCount":@(self.innerView.ownLikeCount),@"roomId":self.chatroomId,@"isFirst":@"1"} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            self.channel.likeCount=[[respondObject.data objectForKey:@"count"] integerValue];
            [_innerView setLikeCount:self.channel.likeCount];
            _innerView.ownLikeCount=0;
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
}

- (void)checkActivity {
    self.webActivity = [[JHWebView alloc] init];
    [self.webActivity loadWebURL:ActivityURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0)];
    self.webActivity.tag = 10009;
    [self.innerView addSubview:self.webActivity];
    UIView *endView = [self.innerView viewWithTag:10010];
    if (endView) {
        [self.innerView bringSubviewToFront:endView];
    }
    //卖货观众和卖货助理调整到右边尺寸变小,鉴定观众保持左边位置尺寸不变
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [self.webActivity mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(StatusBarH + 100);
            make.size.mas_equalTo(CGSizeMake(94, 144));
            make.left.equalTo(self.innerView);
        }];
    }
    else
    {
        [self.webActivity mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(StatusBarH + 100);
            make.size.mas_equalTo(CGSizeMake(75, 79));
            make.right.equalTo(self.innerView).offset(-5);
        }];
    }
    
    WEAKSELF
    self.webActivity.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        return [weakSelf.channel mj_JSONString];
    };
}

- (void)initWebRightBottom {
    _webRightBottom = [[JHWebView alloc] init];
    [self.innerView addSubview:self.webRightBottom];
                                                                                   //130
    CGFloat top = self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant ? 230 : 115;
//    if(![self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
        top = top - 100;
    [_webRightBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.innerView.bottomBar.mas_top).offset(-top);
        make.right.equalTo(self.innerView.mas_right);
        make.size.mas_equalTo(CGSizeMake(83, 83));
    }];
    
    NSString *url = RightBottomActivityURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0);
    if([JHEnvVariableDefine getService] == JHServiceTypeTest || [JHEnvVariableDefine getService] == JHServiceTypeDevelop){
        url = [url stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    }
    [_webRightBottom loadWebURL:url];
    @weakify(self);
    _webRightBottom.resetSizeWebView = ^(OpenWebModel * _Nonnull model) {
        @strongify(self);
        [self.webRightBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(model.width, model.height));
        }];
    };
    _webRightBottom.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        @strongify(self);
        return [self.channel mj_JSONString];
    };
    _webRightBottom.hidden = (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise);
    if (self.audienceUserRoleType) {
        RACChannelTo(self.webRightBottom, hidden) = RACChannelTo(self.innerView.bottomBar, hidden);
    }

}

-(void)getRecommendAnchors{
    // appraise
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/channel/recommendAppraise?channelType=") stringByAppendingString:self.audienceUserRoleType==1?@"sell":@"appraise"] Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *arr = [ChannelMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        
        [_innerView.endPageView setupRecommendAnchourView:arr];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

#pragma mark tableviewDatesource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.channeArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHAudienceLiveTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    if(cell == nil)
    {
        cell = [[JHAudienceLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setChannelMode:self.channeArr[indexPath.row]];
    
    return  cell;
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView!=self.tableView) {
        return;
    }
    if(!decelerate){
        DDLogInfo(@"******newPage*******");
        [self getNewPage:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView!=self.tableView) {
        return;
    }
    DDLogInfo(@"******newPage*******");
    [self getNewPage:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView!=self.tableView) {
        return;
    }
    [self.view endEditing:YES];
    CGFloat pageHeight = CGRectGetHeight(self.view.frame);
    if ( self.tableView.contentOffset.y- pageHeight*self.currentSelectIndex>=pageHeight
        ||pageHeight*self.currentSelectIndex-self.tableView.contentOffset.y>=pageHeight) {
        if (!self.isClean) {
            DDLogInfo(@"******cleanView*******");
           // [self  doDestroyPlayer];
            [[JHLivePlayer sharedInstance] doDestroyPlayer];
            [[JHLivePlayerManager sharedInstance ] shutdown];
            [self clean];
            self.isClean=YES;
        }
    }
}

- (void)noteBrowseDurationBegin
{
    //用户画像浏览时长:begin
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"room_id":self.channel.channelLocalId ? : @""}];
    }
    else
    {
        [JHUserStatistics noteEventType:kUPEventTypeLiveRoomDetailBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"room_id":self.channel.channelLocalId ? : @""}];
    }
}

- (void)noteBrowseDurationEnd
{
    //用户画像浏览时长:end
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"room_id":self.channel.channelLocalId ? : @""}];
    }
    else
    {
        [JHUserStatistics noteEventType:kUPEventTypeLiveRoomDetailBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"room_id":self.channel.channelLocalId ? : @""}];
    }
}

-(void)getNewPage:(UIScrollView*)scrollView{
    
    CGFloat pageHeight = CGRectGetHeight(self.view.frame);
    CGFloat pageFraction = self.tableView.contentOffset.y / pageHeight;
    NSInteger  currentPage = roundf(pageFraction);
    if (self.currentSelectIndex== currentPage&&!self.isClean) {
        return;
    }
    [self noteBrowseDurationEnd];//久的浏览计时结束
    self.currentSelectIndex=currentPage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0];
    self.currentCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.tableView.scrollEnabled = NO;
    self.fromString = @"roomScroll";
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroomId completion:^(NSError * _Nullable error) {
        [self getLiveDetail: self.currentCell.channelMode.ID isAppraisal:NO];
    }];
    
//    if ([self.groupId length]>0) {
//        if (currentPage==self.channeArr.count-2&&!noMoreData) {
//            self.PageNum++;
//            [self requestInfo];
//        }
//    }
//    if (self.listFromType ==JHGestureChangeLiveRoomFromMallGroupList||
//         self.listFromType ==JHGestureChangeLiveRoomFromRecommendList||
//         self.listFromType ==JHGestureChangeLiveRoomFromMallConditionList) {
//        if (currentPage==self.channeArr.count-2&&!noMoreData) {
//            self.PageNum++;
//            [self requestInfo];
//        }
//    }
}
-(void)clean{
    
    [self removeChatManager];
    [self  audienceOut];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressHistoryMsg) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(guideLoginRedPocket) object:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestCoupon) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportViewTime) object:nil];
    [_innerView clean];
    [self cleanView];
     [self removeTimes];
    [self cancelRequest];
    if (self.streamUrl) {
        [self buryOut];
        
    }
}
-(void)cleanView{
    
//    if (_popDownTimeView) {
//        [_popDownTimeView removeFromSuperview ];
//        _popDownTimeView=nil;
//    }
//    self.innerView.praiseBtnView.hidden = YES;
    [self.innerView.praiseBtnView removeFromSuperview];
    self.innerView.praiseBtnView = nil;
    
    [self.currentCell.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_playLogo removeFromSuperview];
    [_canvas removeFromSuperview];
    [_innerView removeFromSuperview];
    [_roomDetailView removeFromSuperview];
    _playLogo=nil;
    _canvas=nil;
    _innerView=nil;
    _roomDetailView=nil;
    [[SDImageCache sharedImageCache] clearMemory];
    
}
-(void)initNewRoom{
    if (_innerView) {
        [self cleanView];
    }
    self.isClean=NO;
    [self initConentView];  //初始化直播间页面
    [self registerChatManager];
    [self saveWatchTrack];
   
}
-(void)saveWatchTrack{
    
    NSMutableArray * watchTracks=[NSMutableArray arrayWithCapacity:10];
    if ([JHUserDefaults objectForKey:kMallWatchTrackKey]) {
        watchTracks=[[JHUserDefaults objectForKey:kMallWatchTrackKey] mutableCopy];
    }
    if ([watchTracks containsObject:self.channel.channelLocalId]) {
        [watchTracks removeObject:self.channel.channelLocalId];
    }
    [watchTracks insertObject:self.channel.channelLocalId atIndex:0];
    if (watchTracks.count>KTrackLiveRoomLimitCount) {
        watchTracks=[NSMutableArray arrayWithArray:[watchTracks subarrayWithRange:NSMakeRange(0, KTrackLiveRoomLimitCount)]] ;
    }
    [JHUserDefaults setObject:watchTracks forKey:kMallWatchTrackKey];
    [JHUserDefaults synchronize];
}
-(void)initConentView{
    self.innerView.channel = self.channel;
    [self.currentCell.infoView addSubview:self.canvas];
    [ self.currentCell.infoView addSubview:self.roomDetailView];
    [ self.roomDetailView addSubview:self.innerView];
    self.innerView.left = ScreenW;
    [self.innerView updateGlView:self.currentCell.infoView];
    [self.innerView updateCloseRoomButton:self.currentCell.infoView];
    self.innerView.type = self.audienceUserRoleType;
    self.innerView.pushSuggestVCDelegate = self;
    [self performSelector:@selector(reportViewTime) withObject:nil afterDelay:60*10];
    
}
-(void)registerChatManager{
    
    [[NIMSDK sharedSDK].chatroomManager addDelegate:self];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager addDelegate:self];
}
-(void)removeChatManager{
    
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    [[NIMAVChatSDK sharedSDK].netCallManager removeDelegate:self];
}
-(void)removeTimes{
    
    [_likeCountTimer stopGCDTimer];
    _likeCountTimer=nil;
    [self.downTimer stopGCDTimer];
    self.downTimer=nil;
    [countDownTimer invalidate];
    countDownTimer  =nil;
}
- (void)cancelRequest
{
    for (NSURLSessionTask  * task in [HttpRequestTool sessionManager].tasks) {
        // 离开直播间请求和上报点赞请求不取消
        if (![task.originalRequest.URL.path containsString:@"auth/connectMic/leave"]&&
            ![task.originalRequest.URL.path containsString:@"/channelLike"]) {
            [task cancel];
        }
    }
}

-(void)getLiveDetail:(NSString*)roomId  isAppraisal:(BOOL)isAppraisal{
    
    NSString* roomID;
    //crash判空处理,目前逻辑,如果异常继续执行网络回调
    if([NSString isEmpty:roomId])
        roomID = @"";
    else
        roomID = roomId;
    
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(roomID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        ChannelMode * channelMode= [ChannelMode mj_objectWithKeyValues:respondObject.data];
        _streamUrl = channelMode.httpPullUrl;
        _chatroomId = channelMode.roomId;
        self.channel=channelMode;
        self.applyApprassal=NO;
        self.coverUrl = channelMode.coverImg;
        if (channelMode.status.integerValue == 1) {
            _streamUrl = channelMode.lastVideoUrl;
        }
        if ([channelMode.channelType isEqualToString:@"sell"]) {
            self.audienceUserRoleType = JHAudienceUserRoleTypeSale;
        }else {
            self.audienceUserRoleType = JHAudienceUserRoleTypeAppraise;
        }
        [self initNewRoom];
        if (channelMode.roomNoticeUrl.length > 0) {
            [self displayAnnoucement:channelMode.roomNoticeUrl];
        }
        [self reloadData];
        self.tableView.scrollEnabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self noteBrowseDurationBegin]; //新的浏览计时开始
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        self.tableView.scrollEnabled = YES;
    }];
}
-(void)requestInfo{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/switSellChannels?channelLocalId=%@"),self.channel.channelLocalId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
      //  [UITipView showTipStr:respondObject.message];
    }];
    
//    if (self.listFromType ==JHGestureChangeLiveRoomFromMallConditionList) {
//        if(self.groupIds){
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
//            [dic setValue:self.groupIds forKey:@"groupIdList"];
//            [dic setValue:@(self.PageNum) forKey:@"pageNo"];
//            [dic setValue:@(pagesize) forKey:@"pageSize"];
//            [JHMallGroupListViewModel requestListWithParameters:dic block:^(BOOL success, NSArray * _Nonnull data) {
//                if(success)
//                {
//                    [self handleDataWithArr:data];
//                }
//            }];
//        }
//    }
//
//    if (self.listFromType ==JHGestureChangeLiveRoomFromMallGroupList){
//
//        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellByGroup?pageNo=%ld&pageSize=%ld&groupId=%@"),self.PageNum,pagesize,self.groupId];
//        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
//            [self handleDataWithArr:respondObject.data];
//
//        } failureBlock:^(RequestModel *respondObject) {
//            [UITipView showTipStr:respondObject.message];
//        }];
//
//    }
//    if (self.listFromType ==JHGestureChangeLiveRoomFromRecommendList){
//
//        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/getChannelRecommend?pageNo=%ld&pageSize=%ld&groupId=%@"),self.PageNum,pagesize,self.groupId];
//        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
//            [self handleDataWithArr:respondObject.data];
//
//        } failureBlock:^(RequestModel *respondObject) {
//            [UITipView showTipStr:respondObject.message];
//        }];
//
//    }
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    NSMutableArray * tempArr=[NSMutableArray array];
    for (JHLiveRoomMode * mode in arr) {
       // if ([mode.status integerValue]==2) {
            [tempArr addObject:mode];
       // }
    }
    [self.channeArr addObjectsFromArray:tempArr];
    
    if (self.channeArr.count>1) {
        self.tableView.scrollEnabled=YES;
    }
    [self.tableView reloadData];
}
- (void)sendWishPaper:(NSString *)accid {
    
    JHWebView *webview = [[JHWebView alloc] init];
    [webview loadWebURL:FindWishPaperURL(accid)];
    webview.frame = self.view.bounds;
    [self.view addSubview:webview];
    WEAKSELF
    webview.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        return [weakSelf.channel mj_JSONString];
    };
}

- (void)reportViewTime {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reportViewTime) object:nil];
    
    [[JHBuryPointOperator shareInstance] viewTimeWithChannelLocalId:self.channel.channelLocalId type:self.audienceUserRoleType == 0?ShareObjectTypeAppraiseLive:ShareObjectTypeSaleLive bz_val:1];
    [self performSelector:@selector(reportViewTime) withObject:nil afterDelay:60*10];
}

- (void)jubaoAction {
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.titleString = @"举报";
    NSString *url = H5_BASE_HTTP_STRING(@"/jianhuo/app/report.html?");
    url = [url stringByAppendingFormat:@"rep_source=6&rep_obj_id=%@&live_user_id=%@",self.channel.roomId, self.channel.anchorId];
    webVC.urlString = url;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)refreshOrder {
    //    if (_receivedOrder && _receivedOrder.isShow)
    {
        [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/risk") Parameters:nil successBlock:^(RequestModel *respondObject) {
            JHRiskDataModel *model = [JHRiskDataModel mj_objectWithKeyValues:respondObject.data];
            
            OrderMode *order = _receivedOrder.model;
            order.overAmountFlag = model.is_over;
            _receivedOrder.model = order;
            NSString *string = OBJ_TO_STRING(model.rank);
            [self.innerView.riskTestBtn setTitle:string forState:UIControlStateNormal];
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    
}

- (void)requestRiskTips {
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/risk") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHRiskDataModel *model = [JHRiskDataModel mj_objectWithKeyValues:respondObject.data];
        NSString *string = model.rank;
        [self.innerView.riskTestBtn setTitle:string forState:UIControlStateNormal];
        
        if ([JHRootController isLogin]) {
            [UserInfoRequestManager sharedInstance].levelModel.risk = model;
            if (_receivedOrder && _receivedOrder.isShow) {
                OrderMode *order = _receivedOrder.model;
                order.overAmountFlag = model.is_over;
                _receivedOrder.model = order;
            }
            
        }
        
        if (model.is_over) {
            
            if ([CommHelp isFirstTodayForName:ShowRiskOverAlertToday]) {
                JHAppAlertModel *m = [JHAppAlertModel new];
                m.type = JHAppAlertTypeRiskWarning;
                m.localType = JHAppAlertLocalTypeLiveRoom;
                m.typeName = AppAlertRough;
                m.body = [NSString stringWithFormat:@"%.2f",model.amount];
                [JHAppAlertViewManger addModelArray:@[m]];
            }
        }
    } failureBlock:^(RequestModel *respondObject) {}];
}


- (void)requestOpenActivity {
    
    [JHActivityAlertView getActivityAlertViewWithLocation:3];
    NSString *urlString = [NSString stringWithFormat:@"/activity/getSeedingResult?channelLocalId=%@&channelType=%@&isBroad=%d&isAssistant=%d", self.channel.channelLocalId, self.channel.channelType, 0, (int)self.channel.isAssistant];
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(urlString) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        JHHomeActivityMode *model = [JHHomeActivityMode mj_objectWithKeyValues:respondObject.data];
        self.homeActivityMode = model;
    } failureBlock:^(RequestModel *respondObject) {
        
        NSLog(@"respondObject:--- %@", respondObject);
        
        
    }];
}

- (void)showActivity {
    if ([self.homeActivityMode.homeActivityIcon.target.componentName isEqualToString:@"WebDialog"]) {
        JHWebView *webview = [[JHWebView alloc] init];
        webview.frame = self.view.bounds;
        NSString *urlString = [self.homeActivityMode.homeActivityIcon.target.params objectForKey:@"urlString"];
        [webview loadWebURL:[urlString stringByAppendingFormat:@"?isSell=%d&isBroad=%d&isAssistant=%d",self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise?1:0, 0,(int)self.channel.isAssistant]];
        [self.view addSubview:webview];
        self.webSpecialActivity = webview;
    }
    else {
        [JHRootController toNativeVC:self.homeActivityMode.homeActivityIcon.target.componentName withParam:self.homeActivityMode.homeActivityIcon.target.params from:JHLiveFromh5];
    }
}

- (void)guideLoginRedPocket {
    
    ReceiveCoponView * copon=[[ReceiveCoponView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)];
    [[UIApplication sharedApplication].keyWindow addSubview:copon];
    copon.block = ^{
        [JHRootController presentLoginVC];
        
    };
    
    copon.buttonClick = ^(id sender) {
        [JHRootController presentLoginVC];
    };
}
-(void)requestStoneChannel{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/anon/stone-channel/find-info") Parameters:@{@"channelId":self.channel.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        self.stoneChannel=[StoneChannelMode  mj_objectWithKeyValues:respondObject.data];
        if (self.stoneChannel.channelStatus ==2) {
            [self.innerView setStoneChannel:self.stoneChannel];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
      //  [self.view makeToast:respondObject.message];
    }];
}



- (void)requestCount {
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-channel/report-channel-customer-info") Parameters:@{@"channelId":self.channel.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHNimNotificationBody *model = [JHNimNotificationBody mj_objectWithKeyValues:respondObject.data];

        [self.innerView updateResaleAmount:model.totalPrice];
        [self.innerView updateOfferPriceCount:model.offerCount];
        [self.innerView updateOnsaleCount:model.saleCount];


    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        NSLog(@"222");
    }];
    
    if (self.channel.isAssistant) {
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
}

- (void)fetchAnnouncementInfo {
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/channel/announce/detail") Parameters:@{@"channelId" : self.channel.channelLocalId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        DDLogInfo(@"fetchAnnouncementInfo====>%@",respondObject);
        JHAnnouncementInfoModel *aModel = [JHAnnouncementInfoModel mj_objectWithKeyValues:respondObject.data];
        if (aModel.imageUrl.length > 0) {
            [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:aModel.imageUrl] options:SDWebImageRefreshCached progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image) {
                    [self.innerView displayAnnoucement:image];

                }
            }];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
//        NSLog(@"333");
//        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)displayAnnoucement:(NSString *)imageUrl {
    if (!self.channel.isAssistant)  {
        [SDWebImageManager.sharedManager loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRefreshCached progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) {
                [self.innerView displayAnnoucement:image];
            }
        }];
    }
}

- (JHLiveRoomRedPacketViewModel *)redPacketViewModel {
    if (!_redPacketViewModel) {
        _redPacketViewModel = [[JHLiveRoomRedPacketViewModel alloc] init];
        _redPacketViewModel.isAssistant = self.channel.isAssistant;
    }
    return _redPacketViewModel;
}

- (void)sendFreePresent {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/gift/sendFreeGift/auth") Parameters:@{@"channelId":self.channel.channelLocalId} successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
-(void)pushSuggestVC:(JHCustomizeAndienceInnerView *)jhAndienceInnerView
{
    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self anchorId:self.channel.anchorId];
    
}


#pragma mark -
#pragma mark - 直播领津贴模块

- (BOOL)needLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {}];
        return YES;
    }
    return NO;
}

//初始化津贴数据模型
- (void)initLadderModel {
    _ladderModel = [[JHLadderModel alloc] init];
    _ladderModel.channelId = self.channel.channelLocalId;
}

#pragma mark -
#pragma mark - 阶梯津贴视图
//添加津贴视图
- (void)addLadderWidget {
    @weakify(self);
    _ladderWidget = [JHLadderWidget ladderWithClickBlock:^{
        @strongify(self);
        [self sendReceiveLadderRequest];
        //埋点-点击阶梯红包
        [self growingIOForClickEvent];
    }];
    //[self.currentCell.infoView insertSubview:_ladderWidget belowSubview:self.innerView.endPageView];
    [self.innerView addSubview:_ladderWidget];
    [_ladderWidget mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.webRightBottom.mas_top).offset(-25);
        make.right.equalTo(self.innerView.mas_right);
        make.size.mas_equalTo([JHLadderWidget widgetSize]);
    }];
    _ladderWidget.hidden = YES;
}

- (void)addLadderLabel {
    //[self.currentCell.infoView insertSubview:self.ladderLabel belowSubview:self.innerView.endPageView];
    [self.innerView addSubview:self.ladderLabel];
    [self.ladderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ladderWidget.mas_top).offset(0);
        make.centerX.equalTo(self.ladderWidget).offset(0);
        make.size.mas_equalTo(CGSizeMake([JHLadderWidget widgetSize].width - 20, 20));
    }];
    self.ladderLabel.hidden = YES;
}
- (UILabel *)ladderLabel {
    if (!_ladderLabel) {
        _ladderLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:11] textColor:kColorMain];
        _ladderLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _ladderLabel.textAlignment = NSTextAlignmentCenter;
        _ladderLabel.clipsToBounds = YES;
        _ladderLabel.layer.cornerRadius = 10;
        _ladderLabel.minimumScaleFactor = 0.8;
        _ladderLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _ladderLabel;
}

- (void)resetLadderView {
    [UIView animateWithDuration:0.3 animations:^{
        self.ladderLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.ladderLabel.hidden = YES;
        
        [self.ladderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.ladderWidget.mas_top).offset(0);
        }];
    }];
    
    if (_ladderModel.list.count > 0) {
        [_ladderModel.list removeFirstObject];
        if (_ladderModel.list.count > 0) {
            [self startLadderTimer];
        } else {
            [self removeLadderView];
        }
    }
}

- (void)removeLadderView {
    [UIView animateWithDuration:0.3 animations:^{
        self.ladderLabel.alpha = 0;
        self.ladderWidget.alpha = 0;
    } completion:^(BOOL finished) {
        [self.ladderLabel removeFromSuperview];
        [self.ladderWidget removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - 网络请求

//获取津贴列表
- (void)getLadderList {
    //isResaleRoom - 回血直播间 不需要调用
    if (![self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        @weakify(self);
        [JHLadderApiManager getLadderList:_ladderModel block:^(JHLadderModel * _Nullable respObj, BOOL hasError) {
            @strongify(self);
            if (respObj) {
                [self.ladderModel configModel:respObj];
                if (self.ladderModel.list.count > 0) {
                    self.ladderWidget.hidden = NO;
                    [self startLadderTimer];
                }
                
            } else {
                _ladderWidget.hidden = YES;
            }
        }];
    }
}

//领取阶梯津贴请求
- (void)sendReceiveLadderRequest {
    if (_ladderModel.isLoading) {
        return;
    }
    if ([self needLogin]) {
        return;
    }
    
    _ladderWidget.userInteractionEnabled = NO;
    @weakify(self);
    [JHLadderApiManager sendReceiveRequest:_ladderModel block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            [self didReceiveSuccess:respObj];
        } else {
            [self removeLadderView];
        }
    }];
}

//开启津贴计时器
- (void)startLadderTimer {
    _ladderWidget.userInteractionEnabled = YES;
    JHLadderData *data = _ladderModel.list.firstObject;
    _ladderModel.ladderFlag = data.ladderFlag;
    [_ladderWidget startTimerWithTimeInterval:data.timeValue];
}

//领取成功后动画
- (void)didReceiveSuccess:(id)data {
    self.ladderLabel.hidden = NO;
    self.ladderLabel.alpha = 0.4;
    self.ladderLabel.text = [NSString stringWithFormat:@"津贴+%@", data[@"takeMoney"]];
    //开始动画
    [self.ladderLabel updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.ladderLabel.alpha = 1.0;
        
        [self.ladderLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.ladderWidget.mas_top).offset(-5);
        }];
        [self.ladderLabel.superview layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self performSelector:@selector(resetLadderView) afterDelay:1.5];
    }];
}

#pragma mark -
#pragma mark - 登录退出通知
- (void)handleLoginEvent {
    self.ladderWidget.hidden = YES;
    [self getLadderList];
}

#pragma mark -
#pragma mark - 埋点
- (void)growingIOForClickEvent {
    NSMutableDictionary *params = [[JHGrowingIO liveExtendModelChannel:self.channel] mj_keyValues];
    [params setObject:self.ladderModel.ladderFlag forKey:@"ladder_gift_name"];
    [JHGrowingIO trackEventId:@"ladder_gift_click" variables:params];
}
#pragma mark -
#pragma mark - 主播结束直播
- (void)endLive {
    [self getRecommendAnchors];
    self.channel.status = @"1";
    
    [_ladderWidget setWidgetEnabled:NO];
}

@end


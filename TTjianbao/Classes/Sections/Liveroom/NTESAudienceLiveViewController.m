//
//  NTESAudienceLiveViewController.m
//  NIM
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//
#import "JHLiveStoreView.h"
#import "JHShopwindowGoodsAlert.h"
#import "JHEnvVariableDefine.h"
#import "JHActivityAlertView.h"
#import "JHMallGroupListViewModel.h"
#import "NTESAudienceLiveViewController.h"
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
#import "ChannelMode.h"
#import "JHGemmologistViewController.h"
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
#import "NTESMessageModel.h"
#import "LiveRedPacketView.h"
#import "ReceiveCoponView.h"
#import "JHMyCouponViewController.h"
#import "JHSendAmountView.h"
#import "JHWebViewController.h"
#import "JHPopDownTimeView.h"
#import "JHGemmologistViewController.h"
#import "JHApplyMicSuccessAlertView.h"
#import "JHWaterPrintView.h"
#import "JHAudienceCommentView.h"
#import "JHWebView.h"
#import "JHMuteListViewController.h"
#import "JHAudienceLiveTableViewCell.h"
#import "JHShowRiskAlert.h"
#import "JHWebImage.h"
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
//定制直播间相关 新加
#import "JHAudienceApplyCustomizeView.h"
//#import "JHCustomizeAddPhotoView.h"
#import "JHLiveApiManager.h"
#import "JHCustomBugly.h"
#import "JHCustomizeUserOrderView.h"
#import "JHCustomerInfoController.h"
#import "JHBaseOperationView.h"
#import "JHGuideAnimalImage.h"
#import "JHCustomizeFlyUserOrderView.h"

#import "JHCustomizeApplyPopView.h"
#import "JHCustomizeApplyFirstGuide.h"
#import "JHCustomizePopModel.h"
#import "JHCustomizeLinkShowOrderView.h"
#import "JHCustomizeApplyProcessFirst.h"
#import "JHTrackingAudienceLiveRoomModel.h"

#import "JHCustomizePackagePushOrderView.h"
#import "JHCustomizeFlyOrderView.h"
#import "JHCustomizeFlyOrderCountCategoryModel.h"
#import "JHFansEquityPopView.h"
#import "JHFansTaskView.h"
#import "JHFansClubModel.h"
#import "JHFansClubBusiness.h"
#import "JHTaskHUD.h"
#import "JHFansListView.h"
#import "JHFansEquityListModel.h"
#import "JHFansUpgradeGuideView.h"
#import "JHRecycleInfoViewController.h"
#import "JHFansListView.h"
#import "JHIMEntranceManager.h"
#import "JHAuthorize.h"
#import "JHLiveActivityCountdownView.h"

#import "JHShanGouProductView.h"
#import "JHOrderConfirmViewController.h"
#import "UIView+Toast.h"

#import "JHShanGouProductInfoView.h"
#import "JHShanGouTypeAlter.h"
#import "JHFlashSendOrderUserListView.h"
#import "JHFlashSendOrderInputView.h"
#import "JHFlashSendOrderRecordListView.h"

#import "JHLuckyBagEntranceView.h"
#import "JHLuckyBagTaskView.h"
#import "JHLuckyBagRuleView.h"
#import "JHLuckyBagNoWinView.h"
#import "JHLuckyBagWinView.h"
#import "JHLuckyBagBusiniss.h"
#import "JHBusinessFansSettingBusiness.h"


#define JHRoomSendOrderViewTag 2247
typedef void(^NTESDisconnectAckHandler)(NSError *);
typedef void(^NTESAgreeMicHandler)(NSError *);
#define pagesize 10
#define KTrackLiveRoomLimitCount  40
#define JHRoomFlashSendOrderViewTag 1988
@interface NTESAudienceLiveViewController ()<NIMChatroomManagerDelegate,NTESLiveInnerViewDelegate,
NIMChatManagerDelegate,NIMSystemNotificationManagerDelegate,NIMNetCallManagerDelegate,NTESLiveInnerViewDataSource,
NTESPresentShopViewDelegate,NTESAudienceConnectDelegate,NTESLiveAudienceHandlerDelegate,NTESLiveAudienceHandlerDatasource,NTESMenuViewProtocol,JHLiveEndViewDelegate,JHAudienceConnectDelegate,JHConnectMicPopAlertView,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,JHAndienceInnerViewDelegate>
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
    NSString *startTime;
}

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) UIView *canvas;
@property (nonatomic, strong)  JHApplyMicSuccessAlertView  *applySuccessAlert;
@property (nonatomic,assign) JHMediaType mediaType;
@property (nonatomic, strong) NTESAudienceConnectView *connectingView;
@property (nonatomic, strong)   JHAudienceLiveTableViewCell * currentCell;
@property (nonatomic, strong) JHAndienceInnerView *innerView; //直播间中间展示view
@property (nonatomic, strong) NTESLiveAudienceHandler *handler;
@property (nonatomic, strong) JHGuideAnimalImage* guideAnimalImage;
@property (nonatomic, copy) NSString *streamUrl;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *chatroomId;
@property (nonatomic, strong) NSString *appraiseId;
@property (nonatomic, strong) NSString *applyId;
@property (nonatomic, strong) NSMutableArray *audienceArray;

@property (nonatomic,strong)  BYTimer  *likeCountTimer;
@property (nonatomic, strong) JHAudienceConnectView *audienceConnectView;
@property (nonatomic, strong)  JHAudienceApplyConnectView*  audienceAddPhotoView;
@property (nonatomic, strong) JHAnchorInfoModel *anchorInfoModel;
@property (nonatomic, assign) BOOL localFullScreen;
@property (nonatomic, assign) BOOL isflashOn;
@property (nonatomic, assign) BOOL isFocusOn;
@property (nonatomic, strong) UIImageView *focusView;
@property (nonatomic, strong) JHLiveRoomDetailView *roomDetailView; //直播间scrollview 左中右
@property (nonatomic, strong) JHReporterCard *reporterCard;
@property (nonatomic, strong) JHWaterPrintView  *playLogo;
@property (nonatomic, strong) JHPushOrderView *receivedOrder;
/// 新增套餐飞单view
@property (nonatomic, strong) JHCustomizePackagePushOrderView *packageOrder;

@property (nonatomic,strong) JHRecvAmountView *recvAmountView;
@property (nonatomic, assign) BOOL isPopFirstView;

@property (nonatomic,strong) JHWebView *webActivity; //商家优惠券
@property (nonatomic,strong) JHWebView *webRightBottom; //平台运营位
@property (nonatomic,strong) JHWebView *webSpecialActivity;//指定活动 双11等
@property (nonatomic,strong) JHWebView *auctionListWeb;
@property (nonatomic,strong) JHWebView *protectGoodsButton; //保护文物  鉴定直播间

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

//定制直播间相关 新加
@property (nonatomic, strong)  JHCustomizeApplyPopView *applyCustomizeView;
//@property (nonatomic, strong)  JHCustomizeAddPhotoView *customizeAddPhotoView;
@property (nonatomic, copy) NSString *customizeId;

@property (nonatomic, assign)NSInteger connectType ;//是否反向连麦

@property (nonatomic, strong) JHRoomSendOrderView     *normalOrderView;
@property (nonatomic, strong) JHCustomizeFlyOrderView *packageOrderView;
@property (nonatomic, strong) NSArray                 *countCategaryArray;//保存定制个数类别数据
//本直播间当次开播已连接成功的用户，用来发定制单
@property (nonatomic, strong) NSMutableArray <NTESMicConnector*>*connecteds;
///分享类型
@property (nonatomic, copy) NSString *shareType;
@property (nonatomic, copy) NSString *allowance;

@property (nonatomic, strong) JHFansTaskView *fansTaskView;
@property (nonatomic, strong) JHFansListView  *fansListView;


@property (nonatomic, strong) JHShanGouProductView  *shanGouView;
@property (nonatomic, assign) BOOL  isFlashSendOrder; /// 当前是否是闪购

@property (nonatomic, strong) JHLuckyBagEntranceView *luckView;
@property (nonatomic, strong) JHLuckyBagTaskView *luckTaskView;
@property (nonatomic, strong) JHLuckyBagRuleView *luckRuleView;
@property (nonatomic, strong) JHLuckyBagNoWinView *luckNoWinView;
@property (nonatomic, strong) JHLuckyBagWinView *luckWinView;
@property (nonatomic, strong) CustomerBagTagModel *cusBagModel;

@end

@implementation NTESAudienceLiveViewController

NTES_USE_CLEAR_BAR
NTES_FORBID_INTERACTIVE_POP

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self registerApplicationObservers];
    }
    return self;
}

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url{
    
    if (self = [self initWithNibName:nil bundle:nil]) {
        _chatroomId = chatroomId;
        _streamUrl = url;
        _isFocusOn = YES;
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationDefault;
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
        
    }
    return self;
}

- (instancetype)initWithChannelId:(NSString *)channelId {
    
    if (self = [self initWithNibName:nil bundle:nil]) {
        _channelId = channelId;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.isFlashSendOrder = NO;
    [self removeNavView];
    //获取当前直播间角色类型，之前是从外面传进来,现在里面统一处理
    self.audienceUserRoleType = [self getAudienceUserRoleType];
    
    liveIntime = time(NULL);
    self.view.backgroundColor = HEXCOLOR(0xdfe2e6);
    [[JHLivePlaySMallView sharedInstance] close];
    [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;

    if (self.channeArr.count==0) {
        self.currentSelectIndex=0;
        NSDictionary*dict = [self.channel mj_keyValues];
        JHLiveRoomMode *channel = [JHLiveRoomMode mj_objectWithKeyValues:dict];
        self.channeArr=[NSMutableArray arrayWithObjects:channel, nil];
        self.tableView.scrollEnabled=NO;
    }

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
        if ([JHLiveRoomStatus isLiveRoomType:JHLiveRoomTypeSell channelType:self.channel.channelType]) {
               [self requestInfo];
           }
        
    });
    //用户画像埋点
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @""}];
    } else {
        [JHUserStatistics noteEventType:kUPEventTypeShopLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @"", @"group_id":self.groupId ? : @""}];
    }
    [RACObserve(self, channel) subscribeNext:^( ChannelMode* _Nullable x) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.channel.fansClubStatus == 1  && self.channel.isFollow) {
                self.innerView.infoView.careBtn.hidden = YES;
            }
        });
    }];
    [self getCountDataAll];//获取定制个数类别
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.channel.fansClubStatus == 1 && self.channel.isFollow) {
            self.innerView.infoView.careBtn.hidden = YES;
        }
    });

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
    if (self.needShutDown && self.currentUserRole!=CurrentUserRoleLinker) {
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    }
    if (self.needShowliveSmallView&& self.currentUserRole!=CurrentUserRoleLinker) {
        [[JHLivePlayer sharedInstance] startPlay:self.streamUrl inView:self.canvas];
    }
    self.needShutDown=NO;
    self.needShowliveSmallView=NO;

    [self loadBagEntranceData];
}

- (void)loadBagEntranceData{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.channel.anchorId forKey:@"sellerId"];
    @weakify(self);
    [JHLuckyBagBusiniss loadBagEntranceData:param completion:^(NSError * _Nullable error, CustomerBagTagModel * _Nullable model) {
        @strongify(self);
        if (!error) {
            self.cusBagModel = model;
            [self showBagEntranceAlert];
        }
    }];
}

- (void)showBagEntranceAlert{
    //显示福袋
    if (self.cusBagModel.showTag && self.channel.isAssistant != 1) {
        [self.luckView show:self.cusBagModel.countdownSeconds];
    }
}

- (JHLuckyBagEntranceView *)luckView{
    if (!_luckView) {
        JHLuckyBagEntranceView *view = [JHLuckyBagEntranceView new];
        @weakify(self);
        view.touchEventBlock = ^{
            @strongify(self);
            if (IS_LOGIN) {
                [self.luckTaskView show:self.cusBagModel.sellerConfigId secandStr:self.luckView.countdownView.countdownLable.text];
            }
        };
        [self.view addSubview:view];
        _luckView = view;
    }
    return _luckView;
}

- (JHLuckyBagTaskView *)luckTaskView{
    if (!_luckTaskView) {
        JHLuckyBagTaskView *view = [JHLuckyBagTaskView new];
        @weakify(self);
        view.ruleBlock = ^{
            @strongify(self);
            [self.luckRuleView show];
        };
        view.taskBlock = ^(int index) {
            @strongify(self);
            //1-关注、2-评论
            if (index == 1) {
                [self dealFollowEvent];
            }else if (index == 2){
                [self sendBagMsg];
            }
        };
        _luckTaskView = view;
    }
    return _luckTaskView;
}

///福袋关注后刷新福袋任务
- (void)dealFollowEvent{
    @weakify(self);
    [self loadFollowInterFace:^{
        @strongify(self);
        JHTOAST(@"关注成功");
        //调用福袋任务接口
        [self.luckTaskView loadData:self.cusBagModel.sellerConfigId];
    }];
}

///福袋评论任务
- (void)sendBagMsg{
    [self didSendText:self.luckTaskView.taskModel.bagKey];
//    [self.innerView.textInputView.textView becomeFirstResponder];
//    [self.innerView popInputBarAction];
}

- (JHLuckyBagRuleView *)luckRuleView{
    if (!_luckRuleView) {
        JHLuckyBagRuleView *view = [JHLuckyBagRuleView new];
        _luckRuleView = view;
    }
    return _luckRuleView;
}

- (JHLuckyBagNoWinView *)luckNoWinView{
    if (!_luckNoWinView) {
        JHLuckyBagNoWinView *view = [JHLuckyBagNoWinView new];
        _luckNoWinView = view;
    }
    return _luckNoWinView;
}

- (JHLuckyBagWinView *)luckWinView{
    if (!_luckWinView) {
        JHLuckyBagWinView *view = [JHLuckyBagWinView new];
        @weakify(self);
        view.payBlock = ^(OrderMode * _Nonnull model) {
            @strongify(self);
            [self bagWinPayEvent:model];
        };
        _luckWinView = view;
    }
    return _luckWinView;
}

- (void)bagWinPayEvent:(OrderMode *)orderModel{
    if ([orderModel.channelCategory isEqualToString:@"roughOrder"]) {//原石订单
        if (orderModel.overAmountFlag) {
            [self reCatuAction];
            return;
        }else
        {
//            if (!self.agree) {
//                [SVProgressHUD showInfoWithStatus:@"请同意《原石交易协议》"];
//                return;
//            }
        }
    }
    
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = orderModel.orderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.navigationController pushViewController:vc animated:YES];
    [self.luckWinView remove];
    
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
    model.orderCategory = orderModel.orderCategory;
    [JHGrowingIO trackEventId:JHTracklive_orderreceive_paybtn variables:[model mj_keyValues]];
}
-(void)reCatuAction {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/riskTtest.html");
    vc.titleString = @"风险测试";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [JHAppAlertViewManger channelLocalId:@""];
    [JHAppAlertViewManger isLinking:NO];
    if (self.needShutDown && self.currentUserRole!=CurrentUserRoleLinker) {
        [[JHLivePlayer sharedInstance] doDestroyPlayer];
    }
    if (self.needShowliveSmallView && self.currentUserRole!=CurrentUserRoleLinker) {
        [self initLiveSmallView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _playLogo.centerY = UI.bottomSafeAreaHeight + 10.+20;
}

///闪购商品点击
- (void)tapShanGouProductWithModel:(JHShanGouModel*)model{
    NSMutableDictionary *staDic  =  [NSMutableDictionary dictionaryWithCapacity:0];
    staDic[@"page_position"]     = @"直播间页";
    staDic[@"spm_type"]          = @"闪购商品icon";
    staDic[@"commodity_id"]      = model.Id;
    staDic[@"channel_id"]        = self.channel.channelLocalId;
    staDic[@"is_sellout"]        = @NO;
    staDic[@"second_commodity"]  = model.secondCategory;
    staDic[@"commodity_name"]    = model.productTitle;
    staDic[@"present_price"]     = model.price;

    [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:staDic type:JHStatisticsTypeSensors];
    
    /// 跳转订单->支付（先查询可用库存）
    if (isEmpty(model.productCode)) {
        [self.view makeToast:@"商品已售罄" duration:0.7 position:CSToastPositionCenter];
        return;
    }
    
    NSDictionary *dic = @{
        @"productCode":model.productCode
    };
    @weakify(self);
    [SVProgressHUD show];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/app/flash/sales/product/store") Parameters:dic successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        NSInteger count = [respondObject.data integerValue];
        if (count >0) {
            JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc]init];
            vc.goodsId                       = model.productCode;
            vc.orderCategory                 = model.productType;
            vc.orderType                     = JHOrderTypeLive;
            vc.buyType                       = 1;
            vc.activeConfirmOrder            = YES;
            vc.fromString                    = @"shangou";
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [self.view makeToast:@"商品已售罄" duration:0.7 position:CSToastPositionCenter];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:0.7 position:CSToastPositionCenter];
    }];
}

- (void)chatShanGouInfoNoticeAction:(NSNotification*)notice{
    NSDictionary *dict = notice.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise ||
            self.audienceUserRoleType == JHAudienceUserRoleTypeSale ||
            self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize || self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
            [self shanaGouForUser:dict];
        }else{
            [self shanaGouForAsstitans:dict];
        }
    });
}

///助理
- (void)shanaGouForAsstitans:(NSDictionary*)dict{
    NSInteger type     = [dict jsonInteger:@"type"];
    NSDictionary *body = [dict jsonDict:@"body"];
    JHShanGouModel *shanGouModel = [JHShanGouModel mj_objectWithKeyValues:body];
    switch (type) {
            //闪购商品上架
        case FlashSalesMsg:{
            
        }
        break;
            
            //闪购商品下架
        case FlashDownMsg:{
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

}

///用户
- (void)shanaGouForUser:(NSDictionary*)dict{
    NSInteger type     = [dict jsonInteger:@"type"];
    NSDictionary *body = [dict jsonDict:@"body"];
    JHShanGouModel *shanGouModel = [JHShanGouModel mj_objectWithKeyValues:body];
    switch (type) {
            //闪购商品上架
        case FlashSalesMsg:{
            JHShanGouProductView *aa = [[JHShanGouProductView alloc] init];
            aa.model = shanGouModel;
            aa.mj_x = 2 * kScreenWidth;
            aa.mj_y = kScreenHeight - 250;
            @weakify(self);
            [aa setTapProduct:^(JHShanGouModel * _Nonnull model) {
                @strongify(self);
                [self tapShanGouProductWithModel:model];

            }];
            [self.roomDetailView addSubview:aa];
            self.shanGouView = aa;
            [UIView animateWithDuration:0.5 animations:^{
                aa.mj_x = 2 * kScreenWidth - 118;
            }];
        }
        break;
            
            //闪购商品下架
        case FlashDownMsg:{
            [UIView animateWithDuration:0.5 animations:^{
                self.shanGouView.mj_x = 2 * kScreenWidth;
            } completion:^(BOOL finished) {
                [self.shanGouView removeFromSuperview];
            }];

        }
        break;
            
            //闪购商品售罄
        case FlashSalesSellOutMsg:{
            [UIView animateWithDuration:0.5 animations:^{
                self.shanGouView.mj_x = 2 * kScreenWidth;
            } completion:^(BOOL finished) {
                [self.shanGouView removeFromSuperview];
            }];
        }
        break;

        default:
            break;
    }

}

-(void)registerApplicationObservers{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatShanGouInfoNoticeAction:) name:@"ChatShanGouInfoNotice" object:nil];

    
    
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNoticeShopWindowMessage:) name:@"shopwindowNotificationMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTabbarAndDoExitLive) name:NotificationNameGotoUsedAppraiseRedPacket object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchAnchorInfo) name:NotificationNameFollowStatus object:nil];
}

//获取定制个数分类数据
- (void)getCountDataAll {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/anon/customize/fee/template-list") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        self.countCategaryArray = [JHCustomizeFlyOrderCountCategoryModel mj_objectArrayWithKeyValuesArray:respondObject.data];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
    }];
}

- (void)selectedTabbarAndDoExitLive
{
    [JHRootController setTabBarSelectedIndex:1];
    [self doExitLive];
}

///直播间商家红包
- (void)reloadRedPacketWebView:(NSNotification *)sender
{
    if(_webActivity)
    {
        [_webActivity jh_nativeCallJSMethod:@"AppCallbackWeb" param:sender.object];
    }
}
-(void)needLiveSmallView:(NSNotification*)note{
    self.needShowliveSmallView=YES;
}

#pragma mark - 埋点
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
    
    liveModel.duration = @(dur*1000).stringValue;
    [JHGrowingIO trackEventId:JHTracklive_duration variables:[liveModel mj_keyValues]];
    //退出直播间
    [self sa_tracking:@"leaveChannel" andTime:dur*1000];
    
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
    
    //进入直播间
    [self sa_tracking:@"inChannel" andTime:0];
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
    
    //用户画像埋点
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @""}];
    }
    else
    {
        if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
        {///回血直播间
            
        }
        else if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone])
        {//原石直播间
            
        }
        else
        {
            [JHUserStatistics noteEventType:kUPEventTypeShopLiveRoomEntrance params:@{@"room_id":self.channel.channelLocalId ? : @"", @"group_id":self.groupId ? : @""}];
        }
    }
}

////埋点：扩展创建页面（进入页面的参数）
//- (NSMutableDictionary*)growingGetCreatePageParamDict
//{
//    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
//    [dic setValue:@(self.listFromType) forKey:@"from"];
//    return dic;
//}

#pragma mark - some methods
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
//     self.innerView.type = self.audienceUserRoleType;
    
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
        JH_WEAK(self)
        self.innerView.auctionWeb.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
            JH_STRONG(self)
            return [self.channel mj_JSONString];
        };
    }
    //定制观众没有竞拍
    if (self.audienceUserRoleType != JHAudienceUserRoleTypeCustomize) {
        self.innerView.canAuction = self.channel.canAuction;
    }
    
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
    if (self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise && self.channel.status.integerValue == 2) {
        //商家红包
        [self.redPacketViewModel reuqestRedListChannelId:self.channel.channelLocalId roomId:self.channel.roomId superView:self.innerView right:12 top:UI.statusBarHeight + 185];
        [JHFansClubBusiness checkAndSendReward:self.channel.anchorId completion:nil];
    }
    
    [self initWebRightBottom];
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        [self.innerView addSubview:self.protectGoodsButton];
        
        [self.protectGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.webActivity.mas_bottom).offset(0);
            make.left.mas_equalTo(self.innerView.mas_left).offset(0);
            make.size.mas_equalTo(CGSizeMake(60, 50));
        }];
    }
    
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

- (void)sa_trackingConnectionRequest {
    
    
    
}

-(void)applyCustomize:(NSString*)orderCategory customizeOrderId:(NSString*)orderId{
//    connectionRequest 定制
    [self sa_trackingApplicationClick:@"connectionRequest"];
    JH_WEAK(self)
    [JHLiveApiManager applyConnectCustomize:self.channel.roomId orderCategory:orderCategory customizeOrderId:orderId Completion:^(RequestModel *respondObject, NSError *error) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if (!error) {
            self.customizeId=respondObject.data[@"customizeId"];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

            [JHNimNotificationManager sharedManager].customizeWaitMode.customizeId=self.customizeId;
            [JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId=self.channel.roomId;
            [JHNimNotificationManager sharedManager].customizeWaitMode.waitChannelLocalId=self.channel.channelLocalId;
            [JHNimNotificationManager sharedManager].customizeWaitMode.isWait = YES;
            
            [self.audienceAddPhotoView dismiss];
            self.currentUserRole = CurrentUserRoleApplication;
      
            
            [JHLiveApiManager getCustomizeWaitingCountComplete:^{
            JH_STRONG(self)
            [self onCustomizeWithType:JHLiveButtonStyleWaitQueue];
            [self.view makeToast:@"申请成功,请等待定制主播连线" duration:1.0 position:CSToastPositionCenter];
            [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleWaitQueue];
            }];
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
     [SVProgressHUD show];
}
#pragma  mark - 鉴定申请连麦
-(void)applyConnectMic:(NSArray*)imgList{
//    connectionRequest 鉴定
    JH_WEAK(self)
    [JHLiveApiManager applyConnectMic:self.channel.roomId images:imgList Completion:^(RequestModel *respondObject, NSError *error) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if (!error) {
            self.appraiseId=[NSString stringWithFormat:@"%@",respondObject.data];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
            [JHNimNotificationManager sharedManager].micWaitMode.waitAppraiseId=self.appraiseId;
            [JHNimNotificationManager sharedManager].micWaitMode.waitRoomId=self.channel.roomId;
            [JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId=self.channel.channelLocalId;
            [JHNimNotificationManager sharedManager].micWaitMode.isWait = YES;
            
            [_innerView updateRoleType:JHLiveRoleApplication];
            [self.audienceAddPhotoView dismiss];
            self.currentUserRole = CurrentUserRoleApplication;
            //
            [JHLiveApiManager getMicWaitingCountComplete:^{
                if ( [JHNimNotificationManager sharedManager].micWaitMode.waitCount>0) {
                    if (!_applySuccessAlert) {
                        _applySuccessAlert=[[JHApplyMicSuccessAlertView alloc]initWithFrame:CGRectMake(0,ScreenH, ScreenW, ScreenH)];
                    }
                    _applySuccessAlert.mode=[JHNimNotificationManager sharedManager].micWaitMode;
                    [_applySuccessAlert showAlert];
                    
                    [_applySuccessAlert withSureClick:^{
                         JH_STRONG(self)
                         self.isPopFirstView=YES;
                        [self onClosePlaying];
                    }];
                    [self freshPopDownTimeView];
                    
                }
                else{
                    [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleWaitQueue];
                    [self.view makeToast:@"申请成功,请等待主播连线" duration:1.0 position:CSToastPositionCenter];
//                    [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAppraisalSuccess];
                }
            }];
            
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
     [SVProgressHUD show];
}
-(void)applyRecycleConnectMic:(NSArray*)imgList{
//    connectionRequest 回收
    JH_WEAK(self)
    [JHLiveApiManager applyRecycleConnectMic:self.channel.roomId images:imgList Completion:^(RequestModel *respondObject, NSError *error) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if (!error) {
            self.applyId=respondObject.data[@"applyId"];
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];

            [JHNimNotificationManager sharedManager].recycleWaitMode.applyId=self.applyId;
            [JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId=self.channel.roomId;
            [JHNimNotificationManager sharedManager].recycleWaitMode.waitChannelLocalId=self.channel.channelLocalId;
            [JHNimNotificationManager sharedManager].recycleWaitMode.isWait = YES;
            
            [self.audienceAddPhotoView dismiss];
            self.currentUserRole = CurrentUserRoleApplication;
            
            [JHLiveApiManager getRecycleMicWaitingCountComplete:^{
            JH_STRONG(self)
                
            [self onRecycleWithType:JHLiveButtonStyleWaitQueue];
                
            [self.view makeToast:@"申请成功,请等待定制主播连线" duration:1.0 position:CSToastPositionCenter];
            [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleWaitQueue];
            }];
           
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
     [SVProgressHUD show];
}
//主动断开连麦
- (void)forceCloseConnectMic{
    if (self.audienceUserRoleType == 9 || self.audienceUserRoleType == 10) {//定制的
        NSString *  timeSpend=[NSString stringWithFormat:@"%ld",([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000];
        NSDictionary * parameters=@{
                                    @"customizeId":self.customizeId,
                                    @"timeSpend":timeSpend,
                                    @"wyAccid":[[NIMSDK sharedSDK].loginManager currentAccount],
                                    @"anchorId":self.channel.anchorId
                                    };
        if (self.connectType == 1) {//反向连麦
            
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
               DDLogInfo(@"forceEndConnectMic:%@",respondObject.data);
                [SVProgressHUD dismiss];
                [self didForceDisConnectMic];
               
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                
            }];
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/reverse/connectMic/break")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
            } failureBlock:^(RequestModel *respondObject) {
                
            }];
        }else{
        
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
               DDLogInfo(@"forceEndConnectMic:%@",respondObject.data);
                [SVProgressHUD dismiss];
    
                [self didForceDisConnectMic];
                
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                
            }];
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/break")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
            } failureBlock:^(RequestModel *respondObject) {
                
            }];
        }
    }
    
  else if (self.audienceUserRoleType == 11 || self.audienceUserRoleType == 12) {//回收
      NSString *  timeSpend=[NSString stringWithFormat:@"%ld",([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000];
        NSDictionary * parameters=@{
                                    @"applyId":self.applyId,
                                    @"timeSpend":timeSpend,
                                    @"wyAccid":[[NIMSDK sharedSDK].loginManager currentAccount],
                                    @"anchorId":self.channel.anchorId
                                    };
        if (self.connectType == 1) {//反向连麦
            
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/connectMic/reverse/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
            
                [SVProgressHUD dismiss];
                [self didForceDisConnectMic];
                
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                
            }];
          
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/connectMic/reverse/break")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
            } failureBlock:^(RequestModel *respondObject) {
                
            }];
        }else{
        
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
            
                [SVProgressHUD dismiss];
                [self didForceDisConnectMic];
                
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                
            }];
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/recycle/connectMic/break")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
                
            } failureBlock:^(RequestModel *respondObject) {
                
            }];
        }
    }
    

}
//不接受连麦申请用cancel
-(void)cancleConnectMic{
    
    //鉴定观众
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        [self cancleAppraise];
    }
    //定制观众
  else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize) {
      if (self.connectType == 1) {//反向连麦取消
          [self cancleReverseCustomize];
      }else{
          [self cancleCustomize];
      }
    }
    //回收观众
  else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
      if (self.connectType == 1) {//反向连麦取消
          [self cancleReverseRecycle];
      }else{
          [self cancleRecycle];
      }
    }
   
}
//不接受连麦申请用cancel
-(void)cancleReverseCustomize{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"/appraisal/reverse/connectMic/cancel?customizeId=%@",self.customizeId];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
       
      [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleNormal];
         [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [self.audienceConnectView dismiss];
        self.currentUserRole=CurrentUserRoleAudience;
       
        [JHNimNotificationManager sharedManager].customizeWaitMode=nil;
    
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
}

-(void)cancleReverseRecycle{
    [SVProgressHUD show];
    NSString *url = [NSString stringWithFormat:@"/recycle/connectMic/reverse/cancel?applyId=%@",self.applyId];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
      [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleNormal];
         [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [self.audienceConnectView dismiss];
        self.currentUserRole=CurrentUserRoleAudience;
        [JHNimNotificationManager sharedManager].recycleWaitMode=nil;
    
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
}
-(void)cancleAppraise{
    
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
        
         [self.innerView updatePraiseBtnViewWithWaitNum:-1];
        
        //取消连麦后更新申请连麦按钮状态
         self.innerView.canAppraise = self.channel.canAppraise;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
    
    [SVProgressHUD show];
    
}
-(void)cancleCustomize{
    
    if (!self.customizeId) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/appraisal/connectMic/cancel?customizeId=%@",self.customizeId];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
      [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleNormal];
         [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [self.audienceConnectView dismiss];
        self.currentUserRole=CurrentUserRoleAudience;
       
        [JHNimNotificationManager sharedManager].customizeWaitMode=nil;
        
         [self.innerView updateCustomizeBtnViewWithWaitNum:-1];
        //取消连麦后更新申请连麦按钮状态
         self.innerView.canAppraise = self.channel.canAppraise;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
    
    [SVProgressHUD show];
    
}
-(void)cancleRecycle{
    
    if (!self.applyId) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"/recycle/connectMic/cancel?applyId=%@",self.applyId];
    [HttpRequestTool getWithURL: FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
      [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleNormal];
         [_innerView removeBubbleView:JHBubbleViewTypeWaitMic];
        [self.audienceConnectView dismiss];
        self.currentUserRole=CurrentUserRoleAudience;
       
        [JHNimNotificationManager sharedManager].recycleWaitMode=nil;

         [self.innerView updateRecycleBtnViewWithWaitNum:-1];
        //取消连麦后更新申请连麦按钮状态
         self.innerView.canAppraise = self.channel.canAppraise;
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
    }];
    
    [SVProgressHUD show];
    
}
-(void)audienceEnter{
    
    [JHLiveApiManager  audienceEnter:self.channel.roomId];
}
-(void)audienceOut{
    
       DDLogInfo(@"离开");
      [JHLiveApiManager  audienceOut:self.channel.roomId];
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
#pragma mark - IM 消息回调
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
                    
                        [[JHLivePlayer sharedInstance] doDestroyPlayer];
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
                    
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeSwitchAppraise) {
                        
                        self.channel.canAppraise = ((JHSystemMsgAttachment *)attachment).yesOrNo;
                        if (self.currentUserRole!=CurrentUserRoleApplication&&
                            self.currentUserRole!=CurrentUserRoleLinker){
                            self.innerView.canAppraise = self.channel.canAppraise;
                         }
                        [self.innerView setRunViewText:((JHSystemMsgAttachment *)attachment).content andIcon:((JHSystemMsgAttachment *)attachment).icon andshowStyle:((JHSystemMsgAttachment *)attachment).showStyle];
                        [self.innerView showRunView];
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
                    //显示定制中的订单
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeShowCustomizeOrder) {
                        
                        NSDictionary *dataDic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        JHSystemMsgCustomizeOrder * model = [JHSystemMsgCustomizeOrder mj_objectWithKeyValues:dataDic[@"body"]];
                        if (self.channel.isAssistant || model.showFlag || (self.currentUserRole == CurrentUserRoleLinker)) {
                            [self.innerView setLeftCustomizeOrderHidden:YES withModel:model];
                        }
                    }
                    //移除定制中的订单
                    else if (((JHSystemMsgAttachment *)attachment).type == JHSystemMsgTypeRemoveCustomizeOrder) {
                        
                        [self.innerView setLeftCustomizeOrderHidden:NO withModel:nil];
                        
                    }

                    else if(type == JHSystemMsgTypeShopwindowAddGoods || type == JHSystemMsgTypeShopwindowRefreash || type == JHSystemMsgTypeShopwindowCount || type == JHSystemMsgTypeShopwindowAudienceCount || type == JHSystemMsgTypeRecycleCountRefresh)
                    {
                        return;
                    }

                    //福袋上架
                    else if (((JHSystemMsgAttachment *)attachment).type ==JHSystemMsgTypeLuckyBagUp && self.channel.isAssistant != 1) {
                        NSDictionary *dic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        self.cusBagModel = [CustomerBagTagModel mj_objectWithKeyValues:dic[@"body"]];
                        self.cusBagModel.showTag = YES;
                        [self.luckView show:self.cusBagModel.countdownSeconds];
                    }
                    //福袋下架
                    else if (((JHSystemMsgAttachment *)attachment).type ==JHSystemMsgTypeLuckyBagDown && self.channel.isAssistant != 1) {
                        [self.luckView remove];
                        [self.luckTaskView downLuckyBag];
                        JHTOAST(@"福袋活动已下架");
                    }
                    //福袋开奖
                    else if (((JHSystemMsgAttachment *)attachment).type ==JHSystemMsgTypeLuckyBagRewardMsg && self.channel.isAssistant != 1) {
                        NSDictionary *dic = [((JHSystemMsgAttachment *)attachment).data mj_JSONObject];
                        JHLuckyBagTaskRewardModel *model = [JHLuckyBagTaskRewardModel mj_objectWithKeyValues:dic[@"body"]];
                        [self dealLuckyBagPrizeResult:model];
                    }
                    
                    //填坑 type<4000的消息 如果不特殊处理 默认飘屏和公聊 以后在增加4000以上的
                    else if (((JHSystemMsgAttachment *)attachment).type<JHSystemMsgTypeRoomWatchCount) {
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

- (void)dealLuckyBagPrizeResult:(JHLuckyBagTaskRewardModel *)model{
    User *user = [UserInfoRequestManager sharedInstance].user;
    //只有参与福袋且未中奖用户弹窗提示
    BOOL isNoWin = NO;
    for (NSNumber *indexId in model.nonCustomerIds) {
        if ([user.customerId integerValue] == [indexId integerValue]) {
            isNoWin = YES;
            break;
        }
        isNoWin = NO;
    }
    if (isNoWin) {
        [self.luckTaskView remove];
        [self.luckNoWinView show];
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
            //保证alert 's superview有值,防止mas crash
            if(IS_DICTIONARY(body) && _innerView.superview)
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
            if([redModel isKindOfClass:[JHRoomRedPacketModel class]])
            {
                redModel.channelId = self.channel.channelLocalId;
                redModel.roomId = self.channel.roomId;
            }
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
   else if (model.type==NTESLiveCustomNotificationTypeAudiencedRemoveQueue||
        model.type==NTESLiveCustomNotificationTypeAnchourDestroyQueue) {

       if (![[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId isEqualToString:self.channel.roomId]) {
           [self.view makeToast:@"您已被移出鉴定队列" duration:2. position:CSToastPositionCenter];
       }
        [self.innerView updatePraiseBtnViewWithWaitNum:-1];
        
       
       
    }
    //定制人数变化
   else  if (model.type==NTESLiveCustomNotificationTypeAudiencedCustomizeCountChange) {
       [self freshCustomizePopDownTimeView] ;
    }
    //定制队列销毁
   else if (model.type==NTESLiveCustomNotificationTypeCustomizeAudiencedRemoveQueue||
        model.type==NTESLiveCustomNotificationTypeCustomizeAnchourDestroyQueue) {
   
       if (![[JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId isEqualToString:self.channel.roomId]) {
           [self.view makeToast:@"您已被移出定制队列" duration:2. position:CSToastPositionCenter];
       }
        [self.innerView updateCustomizeBtnViewWithWaitNum:-1];
        [JHNimNotificationManager sharedManager].customizeWaitMode=nil;
        
    }
    
    //回收人数变化
   else  if (model.type==NTESLiveCustomNotificationTypeAudiencedRecycleCountChange) {
       [self freshRecyclePopDownTimeView] ;
    }
    //回收队列销毁
   else if (model.type==NTESLiveCustomNotificationTypeRecycleAudiencedRemoveQueue||
        model.type==NTESLiveCustomNotificationTypeRecycleAnchourDestroyQueue) {

       if (![[JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId isEqualToString:self.channel.roomId]) {
           [self.view makeToast:@"您已被移出回收队列" duration:2. position:CSToastPositionCenter];
       }
        [self.innerView updateRecycleBtnViewWithWaitNum:-1];
        [JHNimNotificationManager sharedManager].recycleWaitMode=nil;
       
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
    if (type != NTESLiveCustomNotificationTypeRecvOrderChange&&
        type != JHSystemMsgTypeFansUpgradeEquityMsg&&
        type != JHSystemMsgTypeFansUpexperienceMsg) {
        if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
            return;
        }
    }
    switch (type) {
        case NTESLiveCustomNotificationTypeReverseLink:
        //反向连麦  收到
       
            self.customizeId = [NSString stringWithFormat:@"%@",[dict[@"body"] jsonString:@"customizeRecordId"]];
            self.applyId = [NSString stringWithFormat:@"%@",[dict[@"body"] jsonString:@"applyId"]];
            
        case NTESLiveCustomNotificationTypeAgreeConnectMic:{

            self.connectType = [dict[@"body"] jsonInteger:@"connectType"];
            currentNotification=notification;
            [self.audienceConnectView dismiss];
            if (connectMicAlert) {
                [connectMicAlert removeFromSuperview];
            }
            if (_applySuccessAlert) {
                [_applySuccessAlert HideMicPopView];
            }
            if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
                [self.innerView updatePraiseBtnViewWithWaitNum:-1];
            }
            else if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize)  {
                [self.innerView updateCustomizeBtnViewWithWaitNum:-1];
            }
            else if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle)  {
                [self.innerView updateRecycleBtnViewWithWaitNum:-1];
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
            connectMicAlert=[[JHConnectMicPopAlertView alloc]initWithTitle:@"主播向你发起连麦\n是否同意？" cancleBtnTitle:@"不，现在忙" sureBtnTitle:[NSString stringWithFormat:@"接受连麦(%@s)",waitTime]];
            [self.innerView addSubview:connectMicAlert];
            connectMicAlert.delegate=self;
            secondsCountDown = [waitTime intValue];//秒倒计时
            if (countDownTimer) {
                [countDownTimer invalidate];
            }
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:countDownTimer forMode:NSRunLoopCommonModes];
            if (self.audienceUserRoleType == 9|| self.audienceUserRoleType == 10) {
                [JHNimNotificationManager sharedManager].customizeWaitMode = nil;
            }
            if (self.audienceUserRoleType == 11|| self.audienceUserRoleType == 12) {
                [JHNimNotificationManager sharedManager].recycleWaitMode = nil;
            }
            
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
            [self.view endEditing:YES];
            OrderMode *model = [OrderMode mj_objectWithKeyValues:dict[@"body"]];
            
            [[JHQYChatManage shareInstance] sendTextWithViewcontroller:self ToShop:model.sellerCustomerId title:model.goodsTitle andOrderId:model.orderId isPayFinish:NO];
            
            if ([model.orderCategory isEqualToString:JHOrderCategoryHandlingService]) {
                JHSendOrderProccessGoodPayView *view = [[JHSendOrderProccessGoodPayView alloc] init];
                [view setOrderModel:model];
                [self.innerView addSubview:view];
                LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
                model.orderCategory = model.orderCategory;
                
                [JHGrowingIO trackEventId:JHTracklive_orderreceive_show_process variables:[model mj_keyValues]];
            } else if ([model.orderCategory isEqualToString:@"normal"] && model.customizeType == 2) {
                /// 定制套餐
                _packageOrder = nil;
                [self.view addSubview:self.packageOrder];
                self.packageOrder.model = model;
                [self.packageOrder showAlert];
                [self.innerView updateCustomizePackageOrderCountAdd];
                [JHGrowingIO trackEventId:JHTrackAudiencelive_pay_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            } else {
                if ([model.source isEqualToString:@"3"]) {//福袋福利单
                    [self.luckTaskView remove];
                    [self.luckWinView show:model];
                }else{//其他福利单
                    _receivedOrder = nil;
                    [self.view addSubview:self.receivedOrder];
                    self.receivedOrder.model = model;
                    [self.receivedOrder showAlert];
                }
                
                [self.innerView updateOrderCountAdd];
                [JHGrowingIO trackEventId:JHTrackAudiencelive_pay_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            }
        }
            break;
        case NTESLiveCustomNotificationTypeSendCustomizeOrder:
        case NTESLiveCustomNotificationTypeSendCustomizeOrder_Two:
        {//定制服务飞单
            if (![[NSString stringWithFormat:@"%@",dict[@"body"][@"roomId"]] isEqualToString:self.channel.roomId]) {
                return;
            }
            [self.view endEditing:YES];
            OrderMode *model = [OrderMode mj_objectWithKeyValues:dict[@"body"]];
            if ([model.orderCategory isEqualToString:@"ownerShipOrder"]) {
                //意向单
                JHCustomizeUserOrderView * view = [[JHCustomizeUserOrderView alloc] init];
                view.model = model;
                view.orderType = JHCustomizeUserOrderTypeIntentUser;
                [self.view addSubview:view];
                view.frame = self.view.bounds;
                [view showAlert];
//                JHCustomizeFlyUserOrderView *view = [[JHCustomizeFlyUserOrderView alloc] init];
//                view.model = model;
//                [self.view addSubview:view];
//                view.frame = self.view.bounds;
//                [view showAlert];
                
            }else if([model.orderCategory isEqualToString:@"personalCustomizeOrder"]){
                //定制单
//                JHCustomizeUserOrderView * view = [[JHCustomizeUserOrderView alloc] init];
//                view.model = model;
//                view.orderType = JHCustomizeUserOrderTypeSureUser;
//                [self.view addSubview:view];
//                view.frame = self.view.bounds;
//                [view showAlert];
                JHCustomizeFlyUserOrderView *view = [[JHCustomizeFlyUserOrderView alloc] init];
                view.model = model;
                [self.view addSubview:view];
                view.frame = self.view.bounds;
                [view showAlert];
                [self.innerView updateOrderCountAdd];
            }
            [JHGrowingIO trackEventId:JHTrackAudiencelive_pay_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
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
             //粉丝升级弹窗  5000,
        case JHSystemMsgTypeFansUpgradeEquityMsg:{
            [((UITextView *)self.innerView.textInputView.textViewnew) resignFirstResponder];
            JHFansEquityLVModel * model = [JHFansEquityLVModel mj_objectWithKeyValues:dict[@"body"]];
            [[JHFansUpgradeGuideView signAppealpopWindow] show];
            [[JHFansUpgradeGuideView signAppealpopWindow] resetViewData:model];

        }
            break;
            //粉丝增加经验  5001
       case JHSystemMsgTypeFansUpexperienceMsg:{
           
           NSString *title = dict[@"body"][@"msgTitle"]?:@"";
           NSString *desc =[NSString stringWithFormat:@"%@",dict[@"body"][@"addExp"]?:@""] ;
           [JHTaskHUD showTitle:title desc:desc toNum:0];
           [[NSNotificationCenter defaultCenter] postNotificationName:FansClubTaskNotifaction  object:nil];
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
        if(data && self.innerView)
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
        data.trackingParams = [self sa_trackingParams];
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
    ///369神策埋点:直播间互动_红包领取后操作
    JHAppraiseRedPacketListModel* data = [JHAppraiseRedPacketListModel convertData:body];
    [self sa_trackRedPocket:@"zbjhdRedEncelopeOperation" redPockecModel:data];
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
    
//    if (self.audienceUserRoleType == 9) {
//           [JHGrowingIO trackEventId:JHTrackCustomizelive_chat_invite_jujue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
//       }
    self.tableView.scrollEnabled=YES;
    self.roomDetailView.scrollEnabled=YES;
    if (connectView==connectMicAlert) {
        [countDownTimer invalidate];
        countDownTimer=nil;
        [self cancleConnectMic];
    }
    [JHGrowingIO trackEventId:JHTracklive_chat_invite_jujue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    if (self.connectType == 1) {
        [self.view makeToast:@"您已拒绝主播连麦" duration:1.0 position:CSToastPositionCenter];
    }else{
        [self.view makeToast:@"已退出连麦队列" duration:1.0 position:CSToastPositionCenter];
    }
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"rejectConnection"} type:JHStatisticsTypeSensors];
    }
    
}
- (void)ConnectViewButtonComplete:(JHConnectMicPopAlertView*)connectView{
    
    //connectionSuccess
    [self sa_trackingApplicationClick:@"connectionSuccess"];
//    [self sa_tracking:@"connectionSuccess" andTime:([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000];
//    if (self.audienceUserRoleType == 9) {
//        [JHGrowingIO trackEventId:JHTrackCustomizelive_chat_invite_tongyi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
//    }
    [JHGrowingIO trackEventId:JHTracklive_chat_invite_tongyi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"acceptConnection"} type:JHStatisticsTypeSensors];
    }
   
    
    self.tableView.scrollEnabled=NO;
    self.roomDetailView.scrollEnabled=YES;
    if (connectView==connectMicAlert){
        [countDownTimer invalidate];
        if (self.connectType == 1) { //反向连麦
            [self.handler dealWithBypassCustomNotification:currentNotification];
        }else{
            if (self.currentUserRole==CurrentUserRoleApplication){
                [self.handler dealWithBypassCustomNotification:currentNotification];
            }
            else{
                [self.view makeToast:@"当前连麦已取消，连麦失败" duration:1.0 position:CSToastPositionCenter];
            }
        }
        
    }
}
#pragma mark - NIMNetCallManagerDelegate
- (void)onUserJoined:(NSString *)uid
             meeting:(NIMNetCallMeeting *)meeting {
    DDLogInfo(@"on user joined uid %@",uid);
//    NTESMicConnector *connector = [[NTESLiveManager sharedInstance] findConnector:uid];
//    if (!connector) {
//        DDLogInfo(@"connector 不在连麦队列里");
//        NSDictionary * parameters=@{
//                                    @"timeSpend":@"0",
//                                    @"wyAccid":uid
//                                    };
//        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/connectMic/forceClose")  Parameters:parameters requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
//        } failureBlock:^(RequestModel *respondObject) {
//
//        }];
//        return;
//    }
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
    
    //直播失败上报bugly
    NSString* errorDesc = error.description;
    errorDesc = [NSString stringWithFormat:@"互动直播失败<<%@>>%@", self.channel.pushUrl ? : @"", errorDesc ? : @""];
    [JHCustomBugly customExceptionClass:[self class] reason:errorDesc];
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

- (void)didRefuseConnectMic{
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"主播没有同意您的连麦" andDesc:@"您可以重拍照片再次申请" cancleBtnTitle:@"知道了"];
        [self.view addSubview:alert];
        
    }
    else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize){
        
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"主播没有同意您的定制申请" andDesc:@"您可以重拍照片再次申请" cancleBtnTitle:@"知道了"];
        [self.view addSubview:alert];
    }
    
    else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle){
        
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"主播暂时无法连麦" andDesc:@"" cancleBtnTitle:@"确定"];
        [self.view addSubview:alert];
    }
    [self didForceDisConnectMic];
}
//主播拒绝无法鉴定或者倒计时结束
-(void)didForceDisConnectMic{
    
    NSLog(@"$$$$$$$$断开");
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
           [_innerView updateRoleType:JHLiveRoleAudience];
       }
       else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize) {
           [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleNormal];
       }
       else  if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
           [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleNormal];
       }
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
    startTime = [CommHelp getNowTimeTimestamp];
    self.tableView.scrollEnabled=NO;
    
    //如果自己状态不是从申请中来的，可能已经被踢了 直接退出直播
    if ( self.currentUserRole!=CurrentUserRoleApplication && self.connectType != 1){
        [self didForceDisConnectMic];
        return;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.audienceConnectView dismiss];
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        [_innerView updateRoleType:JHLiveRoleLinker];
    }
    else if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize){
        [_innerView showFlashlightBtn:YES];
        [_webRightBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.innerView.mas_right).offset(100);
        }];
        [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleLinker];
    }
    
    else if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle){
        [_innerView showFlashlightBtn:YES];
        [_webRightBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.innerView.mas_right).offset(100);
        }];
        [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleLinker];
    }
   
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
    
    [self sa_trackingConnectionEnd];
    
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
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise){
        JHConnectMicPopAlertView  *connectAlert=[[JHConnectMicPopAlertView alloc]initWithTitle:@"当前鉴定已关闭 给主播个好评吧" cancleBtnTitle:@"暂不评价" sureBtnTitle:@"现在评价"];
        __weak typeof (self) weakSelf = self;
        [self.view addSubview:connectAlert];
        [connectAlert withSureClick:^{
            
            [weakSelf presentEvaluation];
        }];
    }else if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize){
        [_innerView showFlashlightBtn:NO];
        [_webRightBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.innerView.mas_right);
        }];
    }
    
    else if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle){
        [_innerView showFlashlightBtn:NO];
        [_webRightBottom mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.innerView.mas_right);
        }];
    }
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
    
    NSMutableDictionary *dic = [[UserInfoRequestManager sharedInstance] getEnterChatRoomExtWithChannel:self.channel];
    if (self.channel.specialEffectFlag) {
        [dic setValue:@"6" forKey:@"userEnterEffect"];
        [dic setValue:self.channel.levelImg forKey:@"levelImg"];
    }
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
            
            __strong typeof(self) sself = self;
            
            if (!sself->fetchHistory) {
                [wself fetchHistoryMsg];
                sself->fetchHistory = YES;
            }
            
            //鉴定状态
            [wself getMicWaitStatus];
              //定制状态
            [wself getCustomizeWaitStatus];
            
            //回收状态
            [wself getRecycleWaitStatus];
            
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
    JH_WEAK(self)
    [[UserInfoRequestManager sharedInstance] getApplyMicInfoComplete:^{
        JH_STRONG(self)
        JHMicWaitMode *mode =  [JHNimNotificationManager sharedManager].micWaitMode;
        if ([mode.waitRoomId length]>0&&mode.isWait) {
            //顶部倒计时
            [self freshPopDownTimeView];
            if ([mode.waitRoomId isEqualToString:self.channel.roomId]) {
                self.appraiseId=mode.waitAppraiseId;
                self.currentUserRole=CurrentUserRoleApplication;
                [self.innerView showBubbleView:JHBubbleViewTypeWaitMic];
                [self.innerView updateRoleType:JHLiveRoleApplication];
            }
            else{
                self.innerView.clickApraiseViewBlock = ^{
                    [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
                };
                  
            }
        }
        else{
            if (self.applyApprassal&&self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise){
                [self showApplyAppraiseView];
            }
        }
        
    }];
}
-(void)freshPopDownTimeView{
    
    JH_WEAK(self)
    int waitNum=[JHNimNotificationManager sharedManager].micWaitMode.waitCount;
    if ([self canPopupTipsToAppraise])
    {
        [self trackLiveRoomPublicEventId:JHFromIdentifyActivity];
        NSString* text = [NSString stringWithFormat:@"您申请的鉴定即将到号（当前%d号），请返回直播间以免过号", waitNum];
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:text cancleBtnTitle:@"返回鉴定" sureBtnTitle:@"知道了"];
        [self.view addSubview:alert];

        alert.cancleHandle = ^{
            JH_STRONG(self)
            [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].micWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            [self trackLiveRoomPublicEventId:JHIdentifyActivityReturnClick];
        };
        
        alert.handle = ^{
            JH_STRONG(self)
            [self trackLiveRoomPublicEventId:JHIdentifyActivityKnowClick];
        };
    }
    
    if([[JHNimNotificationManager sharedManager].micWaitMode.waitRoomId isEqualToString:self.channel.roomId]){
        //显示下边数字
        [self.innerView.bottomBar updateAppraiseButtonNum:JHLiveRoleApplication];
        // 当前直播间 隐藏左上角数字
        [self.innerView updatePraiseBtnViewWithWaitNum:-1];
    }
    else{
        [self.innerView updatePraiseBtnViewWithWaitNum:waitNum];
    }
}
-(void)showApplyAppraiseView{
    
        if (!self.channel.canAppraise) {
//            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"主播已经暂停鉴定" andDesc:@"" cancleBtnTitle:@"先看一会"];
//            [self.view addSubview:alert];
            self.applyApprassal=NO;
            return ;
       }
    [JHGrowingIO trackEventId:JHEventClickfreeauthenticate];
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result) {
                [self onAgainEnterChatRoom];
                if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
                    [self onAppraiseWithType:JHLiveRoleAudience];
                    
                }
            }
        }];
    }else{
        if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
            [self onAppraiseWithType:JHLiveRoleAudience];
        }
        
    }
    self.applyApprassal=NO;
}
-(void)getCustomizeWaitStatus{
    JH_WEAK(self)
    [[UserInfoRequestManager sharedInstance] getApplyCustomizeInfo:self.chatroomId finishComplete:^{
        JH_STRONG(self)
        JHMicWaitMode *mode =  [JHNimNotificationManager sharedManager].customizeWaitMode;
        if ([mode.waitRoomId length]>0&&mode.isWait) {
            //顶部倒计时
            [self freshCustomizePopDownTimeView];
           //是否是当前直播间
        if ([mode.waitRoomId isEqualToString:self.channel.roomId]) {
            self.customizeId=mode.customizeId;
            self.currentUserRole=CurrentUserRoleApplication;
            [self.innerView showBubbleView:JHBubbleViewTypeWaitMic];
            [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleWaitQueue];
        }
        else{
            self.innerView.clickCustomizeBlock = ^{
                [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].customizeWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            };
          }
        }
        
        else{
            if (self.applyApprassal&&((self.audienceUserRoleType == 9|| self.audienceUserRoleType == 10))){
                [self showApplyCustomizeView];
            }
            
        }
    }];
}
-(void)freshCustomizePopDownTimeView{
    
    JH_WEAK(self)
    int waitNum=[JHNimNotificationManager sharedManager].customizeWaitMode.waitCount;
    if ([self canPopupTipsToCustomize])
    {
        [self trackLiveRoomPublicEventId:JHFromIdentifyActivity];
        NSString* text = [NSString stringWithFormat:@"您申请的定制即将到号（当前%d号），请返回直播间以免过号", waitNum];
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:text cancleBtnTitle:@"返回定制" sureBtnTitle:@"知道了"];
        [self.view addSubview:alert];
        [JHGrowingIO trackEventId:JHTrackCustomizelive_out_queue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        alert.cancleHandle = ^{
            JH_STRONG(self)
            [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].customizeWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            [JHGrowingIO trackEventId:JHTrackCustomizedz_return_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        };
        
        alert.handle = ^{
            JH_STRONG(self)
             [JHGrowingIO trackEventId:JHTrackCustomizedz_know_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        };
    }
    
    if([[JHNimNotificationManager sharedManager].customizeWaitMode.waitRoomId isEqualToString:self.channel.roomId])
    {
          //显示下边数字
        [self.innerView.bottomBar updateCustomizeButtonStyle:JHLiveButtonStyleWaitQueue];
        //隐藏左上角数字
        [self.innerView updateCustomizeBtnViewWithWaitNum:-1];
    }
    else{
        [self.innerView updateCustomizeBtnViewWithWaitNum:waitNum];
    }
}
-(void)showApplyCustomizeView{
    
        if (!self.channel.canAppraise) {
//            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"主播已经暂停定制" andDesc:@"" cancleBtnTitle:@"先看一会"];
//            [self.view addSubview:alert];
            self.applyApprassal=NO;
            return ;
       }
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result) {
                [self onAgainEnterChatRoom];
                [self onCustomizeWithType:JHLiveButtonStyleNormal];
            }
        }];
    }else{
         [self onCustomizeWithType:JHLiveButtonStyleNormal];
    }
    self.applyApprassal=NO;
}

-(void)getRecycleWaitStatus{
    JH_WEAK(self)
    [[UserInfoRequestManager sharedInstance] getApplyRecycleInfo:self.chatroomId finishComplete:^{
        JH_STRONG(self)
        JHMicWaitMode *mode =  [JHNimNotificationManager sharedManager].recycleWaitMode;
        if ([mode.waitRoomId length]>0&&mode.isWait) {
            //顶部倒计时
            [self freshRecyclePopDownTimeView];
           //是否是当前直播间
        if ([mode.waitRoomId isEqualToString:self.channel.roomId]) {
            self.applyId=mode.applyId;
            self.currentUserRole=CurrentUserRoleApplication;
            [self.innerView showBubbleView:JHBubbleViewTypeWaitMic];
            [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleWaitQueue];
        }
        else{
            self.innerView.clickRecycleBlock = ^{
                [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].recycleWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            };
          }
        }
        
        else{
            if (self.applyApprassal&&((self.audienceUserRoleType == 11|| self.audienceUserRoleType == 12))){
                [self showApplyRecycleView];
            }
            
        }
    }];
}
-(void)freshRecyclePopDownTimeView{
    
    JH_WEAK(self)
    int waitNum=[JHNimNotificationManager sharedManager].recycleWaitMode.waitCount;
    if ([self canPopupTipsToRecycle])
    {
        [self trackLiveRoomPublicEventId:JHFromIdentifyActivity];
        NSString* text = [NSString stringWithFormat:@"您申请的连麦即将到号（当前%d号），请返回直播间以免过号", waitNum];
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:text cancleBtnTitle:@"返回连麦" sureBtnTitle:@"知道了"];
        [self.view addSubview:alert];
        [JHGrowingIO trackEventId:JHTrackCustomizelive_out_queue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        alert.cancleHandle = ^{
            JH_STRONG(self)
            [JHRootController EnterLiveRoom:[JHNimNotificationManager sharedManager].recycleWaitMode.waitChannelLocalId fromString:JHLiveFromwaitCountDownTipView];
            [JHGrowingIO trackEventId:JHTrackCustomizedz_return_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        };
        
        alert.handle = ^{
            JH_STRONG(self)
             [JHGrowingIO trackEventId:JHTrackCustomizedz_know_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        };
    }
    
    if([[JHNimNotificationManager sharedManager].recycleWaitMode.waitRoomId isEqualToString:self.channel.roomId])
    {
        //显示下边数字
      [self.innerView.bottomBar updateRecycleButtonStyle:JHLiveButtonStyleWaitQueue];
        
      [self.innerView updateRecycleBtnViewWithWaitNum:-1];
    }
    else{
        [self.innerView updateRecycleBtnViewWithWaitNum:waitNum];
    }
}
-(void)showApplyRecycleView{
    
        if (!self.channel.canAppraise) {
//            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"主播已经暂停定制" andDesc:@"" cancleBtnTitle:@"先看一会"];
//            [self.view addSubview:alert];
            self.applyApprassal=NO;
            return ;
       }
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result) {
                [self onAgainEnterChatRoom];
            [self onRecycleWithType:JHLiveButtonStyleNormal];
            }
        }];
    }else{
       
         [self onRecycleWithType:JHLiveButtonStyleNormal];
    }
    self.applyApprassal=NO;
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
        NSLog(@"-=-=-=-=%@",messages);
        if (messages.count) {
            self.historyMessage = reversedArray;
            self.historyIndex = 0;
            [self progressHistoryMsg];
        }
        
    } ];
}

- (void)progressHistoryMsg {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressHistoryMsg) object:nil];
    
    if (self.historyIndex>=self.historyMessage.count) {
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
- (void)onShanGouBtnAction{
    @weakify(self);
    [SVProgressHUD show];
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
            self.isFlashSendOrder = YES;
            view.tag = JHRoomFlashSendOrderViewTag;
            [self.innerView addSubview:view];
            view.frame = self.view.bounds;
            [view showAlert];
            @weakify(self);
            view.clickImage = ^(JHRoomUserCardView *sender) {
                @strongify(self);
                [self openCamara];
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


//小窗断开连麦
- (void)closeLinkAction:(NSString *)uid{
    [JHGrowingIO trackEventId:JHTrackAudiencedz_dklm_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"breakoffConnection"} type:JHStatisticsTypeSensors];
    }
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"确定要断开与主播的连麦吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
//    [alert addBackGroundTap];
    [self.view addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [self forceCloseConnectMic];
        [JHGrowingIO trackEventId:JHTrackAudiencedz_dklm_sure_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"breakoffConnectionConfirm"} type:JHStatisticsTypeSensors];
        }
    };
    alert.cancleHandle = ^{
        [JHGrowingIO trackEventId:JHTrackAudiencedz_dklm_close_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"breakoffConnectionCancel"} type:JHStatisticsTypeSensors];
        }
    };

}

- (void)onTapAndienceHelp {
    [JHIMEntranceManager pushSessionWithUserId:self.channel.anchorId sourceType:JHIMSourceTypeLive];
//    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self anchorId:self.channel.anchorId];
    
}

- (void)onShowAuctionListView:(UIButton *)btn {
    JH_WEAK(self)
    if (![JHRootController isLogin]) {
        
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            JH_STRONG(self)
            [self.auctionListWeb jh_loadWebURL:AuctionListURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0,self.channel.isAssistant)];
        }];
        return;
    }
    
    JHWebView *web = [[JHWebView alloc] init];
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant || self.audienceUserRoleType == JHAudienceUserRoleTypeRecycleAssistant) {
        [web jh_loadWebURL:AuctionListURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,1,self.channel.isAssistant)];
    } else {
        [web jh_loadWebURL:AuctionListURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0,self.channel.isAssistant)];
    }
    web.frame = self.innerView.bounds;
    web.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
    web.operateActionScreenCapture = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        JH_STRONG(self)
        self.isCreatAnction = YES;
        [self openCamara];
    };
    
    web.operateActionAuctionSendOrder = ^(NSString * _Nonnull actionType, NSString * _Nonnull jsonString) {
        JH_STRONG(self)
        NSDictionary *dic = [jsonString mj_JSONObject];
        JHRoomSendOrderView *view = [[JHRoomSendOrderView alloc] init];
        [self.innerView addSubview:view];
        view.frame = self.view.bounds;
        view.tag = JHRoomSendOrderViewTag;
        view.anchorId = self.channel.anchorId;
        view.clickImage = ^(JHRoomUserCardView *sender) {
            [self openCamara];
        };
        view.customerId = dic[@"viewerId"];
        view.biddingId = dic[@"biddingId"];
        [view showAlert];
    };
    
    self.auctionListWeb = web;
    [self.innerView addSubview:web];
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
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveAppraiseText thumbUrl:nil webURL:url type:ShareObjectTypeAppraiseLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveAppraiseText;
        info.shareType = ShareObjectTypeAppraiseLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId} completion:^(JHOperationType operationType) {
            [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
            ///369神策埋点:直播间互动_分享
            NSString *optionType = (operationType == JHOperationTypeWechatSession ? @"微信分享" : @"朋友圈分享");
            self.shareType = optionType;
            [self sa_tracking:@"zbjhdShare" andTime:0];
        }]; //TODO:Umeng share
    }else if(self.audienceUserRoleType == JHAudienceUserRoleTypeCustomize || self.audienceUserRoleType == JHAudienceUserRoleTypeCustomizeAssistant){
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=7"]];
        
        NSString *text = [NSString stringWithFormat:ShareLiveCustomizeText,self.channel.anchorName];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:ShareLiveCustomizeTitle text:text thumbUrl:nil webURL:url type:ShareObjectTypeCustomizeLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = ShareLiveCustomizeTitle;
        info.desc = text;
        info.shareType = ShareObjectTypeCustomizeLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId} completion:^(JHOperationType operationType) {
            [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
            ///369神策埋点:直播间互动_分享
            NSString *optionType = (operationType == JHOperationTypeWechatSession ? @"微信分享" : @"朋友圈分享");
            self.shareType = optionType;
            [self sa_tracking:@"zbjhdShare" andTime:0];
        }]; //TODO:Umeng share
    }
    else {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=2"]];
        
        NSString *title = [NSString stringWithFormat:ShareLiveSaleTitle,self.channel.anchorName];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:title text:ShareLiveSaleText thumbUrl:nil webURL:url type:ShareObjectTypeSaleLive object:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
        JHShareInfo* info = [JHShareInfo new];
        info.title = title;
        info.desc = ShareLiveSaleText;
        info.shareType = ShareObjectTypeSaleLive;
        info.url = url;
        [JHBaseOperationView showShareView:info objectFlag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId} completion:^(JHOperationType operationType) {
            [JHBaseOperationAction toShare:operationType operationShareInfo:info object_flag:@{@"currentRecordId":self.channel.currentRecordId,@"roomId":self.channel.roomId}];
            ///369神策埋点:直播间互动_分享
            NSString *optionType = (operationType == JHOperationTypeWechatSession ? @"微信分享" : @"朋友圈分享");
            self.shareType = optionType;
            [self sa_tracking:@"zbjhdShare" andTime:0];
        }]; //TODO:Umeng share
    }

}

//申请定制、等待鉴定
- (void)onCustomizeWithType:(JHLiveButtonStyle)stateType {
    
     [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    NSLog(@"countCategaryArray:---- %@", self.countCategaryArray);
    NSMutableArray *cateArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
        [cateArray addObject:model.customizeFeeName];
    }
    ///369神策埋点:申请定制点击
    [self sa_trackingApplicationClick:@"applicationClick"];
    
    if (![JHRootController isLogin]) {
        if (stateType == JHLiveButtonStyleNormal) {
            [JHGrowingIO trackEventId:@"enter_live_in" from:@"made_room_lianmai_click"];
        }
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                [self onAgainEnterChatRoom];
            }
        }];
        return;
    }
    if (stateType==JHLiveButtonStyleNormal) {
    
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"firstApplyCustomizeGuide"] == 0) {
            
            JHCustomizeApplyFirstGuide * first =[[JHCustomizeApplyFirstGuide alloc] initWithFrame:self.view.bounds];
            first.channelId = self.channel.channelLocalId;
            first.customerId = self.channel.anchorId;
            [self.view addSubview:first];
            [first showAlert];
            JH_WEAK(self)
            first.clickSureBlock = ^{
                JH_STRONG(self)
                if (self.applyCustomizeView) {
                    [self.applyCustomizeView removeFromSuperview];
                }
                [self.view addSubview:self.applyCustomizeView];
                [self.applyCustomizeView showAlert];
            };
            first.completeBlock = ^(id obj) {
                JHCustomizePopModel * mode = (JHCustomizePopModel*)obj;
                JH_STRONG(self)
                [self applyCustomize:mode.orderCategory customizeOrderId:mode.orderId];
            };
            [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_xieyi_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        }else{
            [self requestGetMaterialOrders];
            
        }
        
            
    }
    
   else if (stateType==JHLiveButtonStyleWaitQueue) {
        JH_WEAK(self)
        [SVProgressHUD show];
         [JHLiveApiManager getCustomizeWaitingCountComplete:^{
            JH_STRONG(self)
            [SVProgressHUD dismiss];
            [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_queue_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            [self.audienceConnectView show];
              JHMicWaitMode * waitMode = [JHNimNotificationManager sharedManager].customizeWaitMode;
            [self.audienceConnectView setWaitNum:waitMode.waitCount andWaitTime:waitMode.singleWaitSecond*(waitMode.waitCount-1)];
        }];
    }
}
- (void)onRecycleWithType:(JHLiveButtonStyle)stateType{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
                [self onAgainEnterChatRoom];
            }
        }];
        return;
    }
    if (stateType==JHLiveButtonStyleNormal) {
    
        [JHGrowingIO trackEventId:JHTracklive_bottom_identifyapplybtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_audienceAddPhotoView) {
                    [_audienceAddPhotoView removeFromSuperview];
                    _audienceAddPhotoView = nil;
                }
                [self.view addSubview:self.audienceAddPhotoView];
                //[self.audienceAddPhotoView showTags:self.anchorInfoModel.tags];
                self.audienceAddPhotoView.titleLabel.text = @"先给商品拍张照片，主播稍后会和您连线";
                self.audienceAddPhotoView.desWarningLabel.text = @"平台对连麦沟通进行全程监控，对任何不文明及违反法律、平台规则的行为将严厉打击，有权将相关信息移交公安等有关部门予以严肃处理！";
                [self.audienceAddPhotoView.sureButton setTitle:@"申请连麦" forState:UIControlStateNormal];
            });
            
        [JHGrowingIO trackEventId:JHEventClickfreeauthenticate];
        [JHGrowingIO trackEventId:JHTracklive_identifyapply_xianshi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        ///369神策埋点:申请鉴定点击
        [self sa_trackingApplicationClick:@"applicationClick"];
    }
    
   else if (stateType==JHLiveButtonStyleWaitQueue) {
        JH_WEAK(self)
        [SVProgressHUD show];
         [JHLiveApiManager getRecycleMicWaitingCountComplete:^{
             JH_STRONG(self)
            [SVProgressHUD dismiss];
            [self.audienceConnectView show];
              
             JHMicWaitMode * waitMode = [JHNimNotificationManager sharedManager].recycleWaitMode;
            [self.audienceConnectView setWaitNum:waitMode.waitCount andWaitTime:waitMode.singleWaitSecond*(waitMode.waitCount-1)];
            LiveExtendModel * mode =[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
            mode.waitNum=[NSString stringWithFormat:@"%d",[JHNimNotificationManager sharedManager].recycleWaitMode.waitCount];
            [JHGrowingIO trackEventId:JHTracklive_identifywait2_show variables:[mode mj_keyValues]];
        }];
    }
    
}
//申请鉴定、等待鉴定
- (void)onAppraiseWithType:(NSInteger)stateType {
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
                [self onAgainEnterChatRoom];
            }
        }];
        return;
    }
    if (stateType==JHLiveRoleAudience) {
    
        [JHGrowingIO trackEventId:JHTracklive_bottom_identifyapplybtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_audienceAddPhotoView) {
                    [_audienceAddPhotoView removeFromSuperview];
                    _audienceAddPhotoView = nil;
                }
                [self.view addSubview:self.audienceAddPhotoView];
                [self.audienceAddPhotoView showTags:self.anchorInfoModel.tags];
            });
            
        [JHGrowingIO trackEventId:JHEventClickfreeauthenticate];
        [JHGrowingIO trackEventId:JHTracklive_identifyapply_xianshi variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        ///369神策埋点:申请鉴定点击
        [self sa_trackingApplicationClick:@"applicationClick"];
    }
    
   else if (stateType==JHLiveRoleApplication) {
        JH_WEAK(self)
        [SVProgressHUD show];
         [JHLiveApiManager getMicWaitingCountComplete:^{
             JH_STRONG(self)
            [SVProgressHUD dismiss];
            [self.audienceConnectView show];
              
             JHMicWaitMode * waitMode = [JHNimNotificationManager sharedManager].micWaitMode;
            [self.audienceConnectView setWaitNum:waitMode.waitCount andWaitTime:waitMode.singleWaitSecond*(waitMode.waitCount-1)];
            LiveExtendModel * mode =[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
            mode.waitNum=[NSString stringWithFormat:@"%d",[JHNimNotificationManager sharedManager].micWaitMode.waitCount];
            [JHGrowingIO trackEventId:JHTracklive_identifywait2_show variables:[mode mj_keyValues]];
        }];
    }

}
- (void)requestGetMaterialOrders{
    JH_WEAK(self);
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/order/auth/getMaterialOrders") Parameters:@{@"customerId":self.channel.anchorId,@"channelId":self.channel.channelLocalId}
       successBlock:^(RequestModel *respondObject) {
        JH_STRONG(self);
        if ([respondObject.data isKindOfClass:[NSArray class]] && ((NSArray*)respondObject.data).count>0) {
            
            if (_applyCustomizeView) {
                [_applyCustomizeView removeFromSuperview];
                _applyCustomizeView = nil;
            }
            [self.view addSubview:self.applyCustomizeView];
             [self.applyCustomizeView showAlert];
            [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_show variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        }else{
            JHCustomizeApplyProcessFirst *applyCustomizeView = [[JHCustomizeApplyProcessFirst alloc] initWithFrame:self.view.bounds andCustomizeId:self.channel.anchorId];
            applyCustomizeView.channelId = self.channel.channelLocalId;
            applyCustomizeView.completeBlock = ^(id obj) {
                JHCustomizePopModel * mode = (JHCustomizePopModel*)obj;
                [self applyCustomize:mode.orderCategory customizeOrderId:mode.orderId];
            };
            [self.view addSubview:applyCustomizeView];
            [applyCustomizeView showAlert];
        }
    }
    failureBlock:^(RequestModel *respondObject) {

        JHCustomizeApplyProcessFirst *applyCustomizeView = [[JHCustomizeApplyProcessFirst alloc] initWithFrame:self.view.bounds andCustomizeId:self.channel.anchorId];
        applyCustomizeView.channelId = self.channel.channelLocalId;
        applyCustomizeView.completeBlock = ^(id obj) {
            JHCustomizePopModel * mode = (JHCustomizePopModel*)obj;
            [self applyCustomize:mode.orderCategory customizeOrderId:mode.orderId];
        };
        [self.view addSubview:applyCustomizeView];
        [applyCustomizeView showAlert];
        
    }];
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
    
    //如果当前为福袋任务状态2并且发送了福袋口令，则调用发送福袋评论接口
    if (self.luckTaskView.taskModel && self.luckTaskView.taskModel.buttonType == 2 && [self.luckTaskView.taskModel.bagKey isEqualToString:message.text]) {
        [self loadBagTalkTask];
    }
    
    [JHGrowingIO trackEventId:JHTracklive_sendmsg_result variables:[model mj_keyValues]];
    
}

- (void)loadBagTalkTask{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.channel.anchorId forKey:@"sellerId"];
    [JHLuckyBagBusiniss sendBagMsgData:param completion:^(NSError * _Nullable error, NSString * _Nullable message) {
        if (!error) {
            //调用福袋任务接口
            [self.luckTaskView loadData:self.cusBagModel.sellerConfigId];
            JHTOAST(@"已将您的评论口令发到直播间");
        }
    }];
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
            
            ///369神策埋点:直播间互动_点赞
            [self sa_trackingCommonClick:@"zbjhdLike"];
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
            paController.channel = self.channel;
            paController.entrance = self.entrance;
            paController.groupId = self.groupId;
            [self.navigationController pushViewController:paController animated:YES];
        }
            
        default:
            break;
    }
}
//从直播间进入直播间前,首先关闭当前播放器
- (void)onCloseRoom{
    
    if (self.currentUserRole==CurrentUserRoleLinker){
        [self onClosePlaying];
        return;
    }
   //
    [MBProgressHUD showHUDAddedTo:JHKeyWindow animated:YES];
   // [self  doDestroyPlayer];
    [[JHLivePlayer sharedInstance] doDestroyPlayer];
    [[JHLivePlayerManager sharedInstance] shutdown];
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
    if (self.channel.status.integerValue == 2) {
        
        if ([self canPopupTipsClose]&&
            self.currentUserRole == CurrentUserRoleApplication){
            
            JHMicWaitMode * waitMode = [self currentWaitModel];
            NSString* tipText;
            int waitNum=waitMode.waitCount;
            if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
                tipText = [NSString stringWithFormat:@"您申请的鉴定当前排在第%d位\n离开直播间可能会错过", waitNum];
            }
            else  if (self.audienceUserRoleType == 9|| self.audienceUserRoleType == 10) {
                tipText = [NSString stringWithFormat:@"您申请的定制当前排在第%d位\n离开直播间可能会错过", waitNum];
            }
            else  if (self.audienceUserRoleType == 11|| self.audienceUserRoleType == 12) {
                tipText = [NSString stringWithFormat:@"您申请的连麦当前排在第%d位\n离开直播间可能会错过", waitNum];
            }
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:tipText preferredStyle:UIAlertControllerStyleAlert];
            JH_WEAK(self)
            [alertVc addAction:[UIAlertAction actionWithTitle:@"留下" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                if (self.audienceUserRoleType == 9) {
                    [JHGrowingIO trackEventId:JHTrackCustomizedz_stay_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
                }
                else{
                    [self trackLiveRoomPublicEventId:JHIdentifyActivityStayClick];
                }
                
            }]];
            [alertVc addAction:[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JH_STRONG(self)
                [self doExitLive];
                if (self.audienceUserRoleType == 9) {
                    [JHGrowingIO trackEventId:JHTrackCustomizedz_leave_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
                }
                else{
                    [self trackLiveRoomPublicEventId:JHIdentifyActivityLeaveClick];
                }
                
            }]];
            if (self.audienceUserRoleType == 9) {
                [JHGrowingIO trackEventId:JHTrackCustomizelive_queue variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
            }
            [self presentViewController:alertVc animated:YES completion:nil];
        }
        else if (self.currentUserRole == CurrentUserRoleLinker) {
            
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"当前正在连麦中，确定离开吗？" cancleBtnTitle:@"离开" sureBtnTitle:@"留下"];
        //    [alert addBackGroundTap];
            [JHKeyWindow addSubview:alert];
            @weakify(self);
            alert.cancleHandle = ^{
                @strongify(self);
                [self doExitLive];
                [self cancleConnectMic];
                [self forceCloseConnectMic];
                if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
                    [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"closeLiveRoomConfirm"} type:JHStatisticsTypeSensors];
                }
            };
            alert.handle = ^{
                if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
                    [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"closeLiveRoomCancel"} type:JHStatisticsTypeSensors];
                }
            };
            
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
 * 1:用户在其它直播间 2:鉴定队列用户，在次序2、4、6时,则给予弹屏提醒
 */
- (BOOL)canPopupTipsToAppraise
{
    JHMicWaitMode * waitMode =  [JHNimNotificationManager sharedManager].micWaitMode;
    int waitCount = waitMode.waitCount;
    if(![waitMode.waitRoomId isEqualToString:self.channel.roomId] &&
       (waitCount == 2 || waitCount == 4 || waitCount == 6))
    {
        return YES;
    }
    return NO;
}
- (BOOL)canPopupTipsToCustomize
{
     JHMicWaitMode * waitMode =  [JHNimNotificationManager sharedManager].customizeWaitMode;
    int waitCount = waitMode.waitCount;
    if(![waitMode.waitRoomId isEqualToString:self.channel.roomId] &&
       (waitCount == 2 || waitCount == 4 || waitCount == 6))
    {
        return YES;
    }
    return NO;
}
- (BOOL)canPopupTipsToRecycle
{
     JHMicWaitMode * waitMode =  [JHNimNotificationManager sharedManager].recycleWaitMode;
    int waitCount = waitMode.waitCount;
    if(![waitMode.waitRoomId isEqualToString:self.channel.roomId] &&
       (waitCount == 2 || waitCount == 4 || waitCount == 6))
    {
        return YES;
    }
    return NO;
}
/**
 申请中(即排队中)>且排队数小于5
 */
- (BOOL)canPopupTipsClose
{
     JHMicWaitMode * waitMode = [self currentWaitModel];
    if(waitMode.waitRoomId == self.channel.roomId &&
        waitMode.waitCount <= 5)
    {
        return YES;
    }
    return NO;
}

-(JHMicWaitMode*)currentWaitModel{
    
    JHMicWaitMode * waitMode = nil;
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
        waitMode = [JHNimNotificationManager sharedManager].micWaitMode;
    }
    else  if (self.audienceUserRoleType == 9|| self.audienceUserRoleType == 10) {
        waitMode = [JHNimNotificationManager sharedManager].customizeWaitMode;
    }
    
    else  if (self.audienceUserRoleType == 11|| self.audienceUserRoleType == 12) {
        waitMode = [JHNimNotificationManager sharedManager].recycleWaitMode;
    }
    return waitMode;
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
        [[JHLivePlayerManager sharedInstance] shutdown];
       // [weakSelf doDestroyPlayer];
        if ([weakSelf.channel.status isEqualToString:@"2"]&&self.isPlaying&&
            ![[NSUserDefaults standardUserDefaults]boolForKey:kFloatWindowLiveClose]){
                [weakSelf initLiveSmallView];
            }
          else{
           [[JHLivePlayer sharedInstance] doDestroyPlayer];
         }
      
        DDLogInfo(@"**********shutdown");
        [MBProgressHUD hideHUDForView:weakSelf.view animated:NO];
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
        if (weakSelf.isExitVc) {
            //
           // [weakSelf.navigationController  popToRootViewControllerAnimated:NO];
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
    // 停止活动计时器
    [self.activityManager stopAndInitCountDown];
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
    if (self.audienceUserRoleType == 9) {
        [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_canslequeue_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    }
  
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您确定要取消排队吗？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [alert addBackGroundTap];
    [self.view addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
         [JHGrowingIO trackEventId:JHLiveRoomMicCancleConfirmClick];
        [self cancleConnectMic];
        if (self.audienceUserRoleType == 9) {
            [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_confirm_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
        }
    };
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"cancelQueue"} type:JHStatisticsTypeSensors];
    }
}
- (void)onBackSourceMall:(id)sender{
    if (self.audienceUserRoleType == 9) {
           [JHGrowingIO trackEventId:JHTrackCustomizelive_lmdz_ggzg_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
       }
    self.isPopFirstView=YES;
    [self onClosePlaying];
    [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
    JHRootController.homeTabController.selectedIndex = 1;
    [JHNotificationCenter postNotificationName:@"JHStoreHomePageIndexChangedNotification" object:@{@"selectedIndex" : @"1", @"item_type" : @"0"}];
    
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickOther" params:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":@"goLiveShopping"} type:JHStatisticsTypeSensors];
    }
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
//观众端>打开飞单弹层
- (void)onShowInfoWithModel:(NTESMessageModel *)model {
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant ||
        self.audienceUserRoleType == JHAudienceUserRoleTypeCustomizeAssistant ||
        self.audienceUserRoleType == JHAudienceUserRoleTypeRecycleAssistant) {
        [self makeCardViewWithModel:model];
    }
}

#pragma mark - Get
- (void)makeCardViewWithModel:(NTESMessageModel *)model {
    JHRoomUserCardView *_sendOrderView = [JHRoomUserCardView new];
    _sendOrderView.frame = self.view.bounds;
    _sendOrderView.anchorId = self.channel.anchorId;
    _sendOrderView.roomId = self.channel.roomId;
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeCustomizeAssistant) {
        _sendOrderView.isAssistant = YES;
        _sendOrderView.cardType = RoomUserCardViewTypeCustomize;
    }
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycleAssistant) {
        _sendOrderView.isAssistant = YES;
        _sendOrderView.cardType = RoomUserCardViewTypeRecycle;
    }
    
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
    
    @weakify(self);
    _sendOrderView.orderAction = ^(NTESMessageModel *object, OrderTypeModel *sender) {
        @strongify(self);
        if ([sender.Id isEqualToString:JHOrderCategoryHandlingService]) {//加工服务单
            JHSendOrderProccessGoodView *view = [[JHSendOrderProccessGoodView alloc] init];
            [weakSelf.innerView addSubview:view];
            [view requestProccessGoodsBuyId:object.customerId isAssistant:1];
            
        } else if ([sender.Id isEqualToString:@"normalCustomizeGroup"]) {
            [JHLiveApiManager checkUserCanUseCustomizePackage:[object.customerId integerValue] version:@"3.6.5" Completion:^(NSError * _Nullable error, RequestModel * _Nullable respondObject) {
                @strongify(self);
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
        } else if ([sender.Id isEqualToString:@"personalCustomizeOrder"]) {
            /// 助理，定制订单， 不支持
        } else if ([sender.Id isEqualToString:@"customizedOrder"]) {
            /// 助理，定制服务单，不支持
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
                [weakSelf openCamara];
            };
        }
    };
}


/// 助理飞定制套餐捆绑
- (void)flyCustomizePackageOrder:(NTESMessageModel *)object sender:(OrderTypeModel *)sender {
    self.normalOrderView = [[JHRoomSendOrderView alloc] init];
    [self.innerView addSubview:self.normalOrderView];
    self.normalOrderView.orderCategory = sender;
    self.normalOrderView.frame = self.view.bounds;
    self.normalOrderView.customerId = object.customerId;
    self.normalOrderView.anchorId = self.channel.anchorId;
    self.normalOrderView.isCustomizePackage = YES;
    self.normalOrderView.tag = JHRoomSendOrderViewTag;
    [self.normalOrderView showAlert];
    @weakify(self);
    self.normalOrderView.clickImage = ^(JHRoomUserCardView *sender) {
        @strongify(self);
        [self openCamara];
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

//通过uid获取定制连麦过用户 主播关播后队列清空
- (NTESMicConnector *)findCustomizeConnector:(NSString *)uid {
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
    } else {
        NSLog(@"模拟无效,请真机测试");
    }
}

- (JHPushOrderView *)receivedOrder {
    if (!_receivedOrder) {
        _receivedOrder = [[JHPushOrderView alloc] initWithFrame:self.view.bounds];
    }
    return _receivedOrder;
}

- (JHCustomizePackagePushOrderView *)packageOrder {
    if (!_packageOrder) {
        _packageOrder = [[JHCustomizePackagePushOrderView alloc] initWithFrame:self.view.bounds];
    }
    return _packageOrder;
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
        _innerView = [[JHAndienceInnerView alloc] initWithChannel:self.channel frame:self.view.bounds isAnchor:NO];
        _innerView.groupId = self.groupId;
        _innerView.entrance = self.entrance;
        _innerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_innerView refreshChannel:self.channel];
        _innerView.delegate = self;
        _innerView.dataSource = self;
        _innerView.careDelegate = self;
        JH_WEAK(self)
        _innerView.reSaleRoomHiddenActivity = ^(id obj) {
            JH_STRONG(self)
            if (self.activityIcon) {
                BOOL isHidden = [obj boolValue];
                self.activityIcon.hidden = isHidden;
            }
        };
        _innerView.showGuideBlock = ^{
            JH_STRONG(self)
            [self.guideAnimalImage animalImageWithTips:@"滑动一下，即可切换直播间哦" superView:self.view];
        };
    }
    return _innerView;
}


- (JHGuideAnimalImage *)guideAnimalImage
{
    if(!_guideAnimalImage)
    {
        _guideAnimalImage = [JHGuideAnimalImage new];
    }
    
    return _guideAnimalImage;
}

- (JHAudienceConnectView *)audienceConnectView {
    if (!_audienceConnectView) {
        _audienceConnectView = [[JHAudienceConnectView alloc] initWithFrame:self.view.bounds];
        _audienceConnectView.channel=self.channel;
        _audienceConnectView.delegate=self;
    }
    return _audienceConnectView;
}
- (JHCustomizeApplyPopView *)applyCustomizeView {
    if (!_applyCustomizeView) {
        _applyCustomizeView = [[JHCustomizeApplyPopView alloc] initWithFrame:self.view.bounds];
        _applyCustomizeView.customerId = self.channel.anchorId;
        _applyCustomizeView.channelId = self.channel.channelLocalId;
         @weakify(self);
        _applyCustomizeView.completeBlock = ^(id obj) {
            JHCustomizePopModel * mode = (JHCustomizePopModel*)obj;
            @strongify(self);
            [self applyCustomize:mode.orderCategory customizeOrderId:mode.orderId];
        };
        
    }
    return _applyCustomizeView;
}

- (JHAudienceApplyConnectView *)audienceAddPhotoView {
    if (!_audienceAddPhotoView) {
        _audienceAddPhotoView = [[JHAudienceApplyConnectView alloc] initWithFrame:self.view.bounds];
        //_audienceAddPhotoView.delegate=self;
        _audienceAddPhotoView.channel = self.channel;
        @weakify(self);
        _audienceAddPhotoView.completeBlock = ^(id obj) {
            @strongify(self);
            NSArray * imageUrls = [[NSArray alloc]initWithObjects:(NSString*)obj, nil];
            if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
                [self applyConnectMic:imageUrls];
            }
            else if (self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle){
                [self applyRecycleConnectMic:imageUrls];
            }
           
        };
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
        _playLogo.centerY = UI.bottomSafeAreaHeight + 10.+20;
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
//        [self.innerView reloadAudienceData:self.audienceArray];
        
    }];
}

- (void)fetchAnchorInfo {
    [HttpRequestTool getWithURL:  FILE_BASE_STRING(@"/authoptional/appraise") Parameters:@{@"customerId" : self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        
        JHAnchorInfoModel *model = [JHAnchorInfoModel mj_objectWithKeyValues:respondObject.data];
        if (model.isFollow) {
            [self.innerView removeFollowBubble];
        }else{
            self.channel.joinFlag = NO;
        }
        self.anchorInfoModel = model;
        self.channel.isFollow = model.isFollow;
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
}

#pragma mark - JHLiveEndViewDelegate

- (void)didPressBackButton {
    [self onClosePlaying];
}
-(void)getLoginLiveDetail{
    @weakify(self);
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(self.channel.channelLocalId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        ChannelMode * channelMode= [ChannelMode mj_objectWithKeyValues:respondObject.data];
        self.channel.isOpen = channelMode.isOpen;
        self.channel.fansClubId = channelMode.fansClubId;
        self.channel.fansClubName = channelMode.fansClubName;
        self.channel.specialEffectFlag = channelMode.specialEffectFlag;
        self.channel.joinFlag = channelMode.joinFlag;
        
        [self fetchAnchorInfo];
    } failureBlock:^(RequestModel *respondObject) {
       
    }];
}
- (void)followBtnClick{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result) {
                [self getLoginLiveDetail];
                [self onAgainEnterChatRoom];
//                [self fetchAnchorInfo];
            }
        }];
        return;
    }
    @weakify(self);
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.channel.anchorId,@"status":@(1)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        [self fetchAnchorInfo];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
    
    ///369神策埋点:直播间互动_关注
    [self sa_trackingAttention];
}

- (void)didPressCareOffButton:(UIButton *)btn {
    if ([self.channel.status isEqualToString:@"1"]) {
        [self followBtnClick];
        return;
    }
    if (self.channel.fansClubStatus == 1) {
        self.innerView.infoView.careBtn.hidden = YES;
    }
    if(self.channel.fansClubStatus == 1){
        JHTOAST(@"粉丝团已被挂起，主播整改后可用");
        return;
    }
    if (self.channel.isAssistant) { //助理
        if (self.channel.isOpen){//已关注并开通粉丝团
            if (self.channel.isFollow) {
                
                
                [JHBusinessFansSettingBusiness businessFansAnchorId:self.channel.anchorId StatusCompletion:^(NSError * _Nullable error, BOOL isGuaQi) {
                    if (isGuaQi) {
                        JHTOAST(@"粉丝团已被挂起，主播整改后可用");
                        return;
                    }else{
                        JHFansListView  *fansListView = [[JHFansListView alloc] init];
                        fansListView.anchorId = self.channel.anchorId;
                        [JHKeyWindow addSubview:fansListView];
                        [fansListView show];
                        [fansListView loadNewData];
                    }
                }];
                
            }else{
                [self followBtnClick];
            }
            
        }else{
            [self followBtnClick];
        }
    }else{
        if (self.channel.isFollow && self.channel.isOpen) {//已关注并开通粉丝团
            
            
            [JHBusinessFansSettingBusiness businessFansAnchorId:self.channel.anchorId StatusCompletion:^(NSError * _Nullable error, BOOL isGuaQi) {
                if (isGuaQi) {
                    JHTOAST(@"粉丝团已被挂起，主播整改后可用");
                    return;
                }else{
                    [((UITextView *)self.innerView.textInputView.textViewnew) resignFirstResponder];
                    if (self.channel.joinFlag) { //是粉丝
                        [self showFansTaskView];//粉丝任务列表
                    }else{//粉丝权益弹层
                        JHFansEquityPopView * view = [[JHFansEquityPopView alloc] initWithAnchorId:self.channel.anchorId andisFans:NO];
                        view.channel_id = self.channel.channelLocalId;
                        view.channel_name = self.channel.anchorName;
                        view.fansClubId = self.channel.fansClubId;
                        @weakify(self);
                        view.joinFansClubVlock = ^{
                            @strongify(self);
                            self.channel.joinFlag = YES;
                            [self.innerView refreshChannel:self.channel];
                            [self showFansTaskView];
                            [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"恭喜您，已成功加入%@的粉丝团",self.channel.anchorName] duration:1.0 position:CSToastPositionCenter];
                            
                        };
                        [self.view addSubview:view];
                        [JHTracking trackEvent:@"fsttcEnter" property:@{@"anchor_id":self.channel.anchorId,@"channel_local_id":self.channel.channelLocalId,@"from":@"加入粉丝团图标"}];
                    }
                }
            }];
        }else{//关注按钮
            
            if(self.channel.isFollow){
                return;
            }
            
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
                    if (result) {
                        [self getLoginLiveDetail];
                        [self onAgainEnterChatRoom];
//                        [self fetchAnchorInfo];
                        
                    }
                    
                }];
                return;
            }
            
            [self loadFollowInterFace:nil];
            
            ///369神策埋点:直播间互动_关注
            [self sa_trackingAttention];
        }
    }
    
    
    
    
}

- (void)loadFollowInterFace:(void(^)(void))finish{
    @weakify(self);
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.channel.anchorId,@"status":@(1)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        //        BOOL isfollow = !btn.selected;
        @strongify(self);
        [self fetchAnchorInfo];
        if (self.channel.isOpen) {
            [self joinFansClubTip];
        }
        // 开通了粉丝团的，不弹push
        if (self.channel.isOpen) return;
        // 鉴定直播间
        if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {
            [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAppraisalFollow];
        }
        // 卖货直播间
        else if (self.audienceUserRoleType == JHAudienceUserRoleTypeSale) {
            [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeAnchorFollow];
        }
        
        if (finish) {
            finish();
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message];
    }];
}

-(void)showFansTaskView{

    if (self.channel.isAssistant) {
        
        if (_fansListView) {
            [_fansListView HideAlert];
            _fansListView = nil;
        }
        _fansListView = [[JHFansListView alloc]init];
        _fansListView.anchorId = self.channel.anchorId;
        [JHKeyWindow addSubview:_fansListView];
        [_fansListView show];
        [_fansListView loadNewData];
        
        return;
    }

    if (_fansTaskView) {
        [_fansTaskView HideAlert];
        _fansTaskView = nil;
    }
    _fansTaskView = [[JHFansTaskView alloc]init];
    _fansTaskView.fansClubId = self.channel.fansClubId;
    _fansTaskView.channelLocalID = self.channel.channelLocalId;
    [JHKeyWindow addSubview:_fansTaskView];
    [_fansTaskView show];
    [_fansTaskView getFansClubInfo];
    @weakify(self);
    _fansTaskView.TaskAction = ^(id obj) {
        @strongify(self);
        JHFansTaskModel *model = (JHFansTaskModel*)obj;
        
        NSString *mission_name = model.taskBtnDesc;
        
        if (model.taskType == JHFansTaskOrderMoney||
            model.taskType == JHFansTaskOrderCount ) {
            mission_name = model.taskName;
        }
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"rwClick" params:@{@"mission_name":mission_name} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];

        switch (model.taskType) {
            case JHFansTaskLike:
            case JHFansTaskLookLive:
            case JHFansTaskOrderMoney:
            case JHFansTaskOrderCount:{
            [self.fansTaskView HideAlert];

            }
                break;
            case JHFansTaskPaiMai:{
                [self requestLiveAngtionStatus];
            }
                break;
            case JHFansTaskLookShowCase:{
              if (self.innerView.bottomBar.shopwindowButton.hidden) {
                  [UITipView showTipStr:@"暂无上架商品"];
                }
                else{
                    [self.fansTaskView HideAlert];
                }
                
            }
                break;
            case JHFansTaskSign:{
                [JHFansClubBusiness FansTaskReport:JHFansTaskSign anchorId:self.channel.anchorId channelId:self.channel.channelLocalId customerId:[UserInfoRequestManager sharedInstance].user.customerId];
              }
                break;
            case JHFansTaskSendMsg:{

            [self.fansTaskView HideAlert];
                [self.innerView.textInputView.textView becomeFirstResponder];
                [self.innerView popInputBarAction];
              }
                break;
            case JHFansTaskShare:{
                
                [self onShareAction];
              }
                break;

            default:
                break;
        }


    };
    _fansTaskView.ruleAction = ^(id obj) {
    @strongify(self);
    [JHAllStatistics jh_allStatisticsWithEventId:@"gzanClick" params:@{@"from":@"任务列表"} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"rwlbEnter" params:@{@"channel_local_id":self.channel.channelLocalId,@"anchor_id":self.channel.anchorId} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    

}


/// 查询拍卖状态
- (void)requestLiveAngtionStatus{
    NSString *url = FILE_BASE_STRING(@"/bidding/biddingStatus");
    url = [NSString stringWithFormat:@"%@?anchorId=%@", url,self.channel.anchorId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        if (dic[@"biddingId"]) {
            [self.fansTaskView HideAlert];
        }else{
            JHTOAST(@"暂无竞拍活动");
        }

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(@"暂无竞拍活动");
    }];
}



- (void)joinFansClubTip{
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"关注成功" andDesc:@"加入Ta的粉丝团,\n享受更多专属特权哟!" cancleBtnTitle:@"了解更多"];
    @weakify(self);
    alert.closeBlock = ^{
        [JHTracking trackEvent:@"fsttcClick" property:@{@"operation_type":@"关闭按钮点击"}];
    };
    alert.cancleHandle = ^{
        @strongify(self);
        JHFansEquityPopView * view = [[JHFansEquityPopView alloc] initWithAnchorId:self.channel.anchorId andisFans:NO];
        view.channel_id = self.channel.channelLocalId;
        view.channel_name = self.channel.anchorName;
        view.fansClubId = self.channel.fansClubId;
        view.joinFansClubVlock = ^{
            self.channel.joinFlag = YES;
            [self.innerView refreshChannel:self.channel];
            [self showFansTaskView];
            [[UIApplication sharedApplication].keyWindow makeToast:[NSString stringWithFormat:@"恭喜您，已成功加入%@的粉丝团",self.channel.anchorName] duration:1.0 position:CSToastPositionCenter];
            
        };
        [self.view addSubview:view];
        [JHTracking trackEvent:@"fsttcClick" property:@{@"operation_type":@"了解更多按钮点击"}];
        [JHTracking trackEvent:@"fsttcEnter" property:@{@"anchor_id":self.channel.anchorId,@"channel_local_id":self.channel.channelLocalId,@"from":@"关注后弹窗点击了解更多"}];
    };
    [alert addCloseBtn];
    [alert setDescTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:alert];
    [JHTracking trackEvent:@"fsttcExpose" property:@{@"anchor_id":self.channel.anchorId,@"channel_local_id":self.channel.channelLocalId}];
}
- (void)didPressAnchorView:(ChannelMode *)mode {
    [self onClosePlaying];
    JH_WEAK(self)
    self.closeBlock = ^{
        JH_STRONG(self)
        self.isExitVc = YES;
        [JHRootController EnterLiveRoom:mode.channelId fromString:JHLiveFromroomFinish];
    };
}
//直播间信息<头像点击>
- (void)didPressAnchorAvatar:(NIMChatroomMember *)member {
    
    if (self.currentUserRole==CurrentUserRoleLinker) {
        return;
    }
    if (self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise) {//0 鉴定观众
        JHGemmologistViewController *gemmologistVC = [[JHGemmologistViewController alloc] init];
        gemmologistVC.anchorId = self.channel.anchorId;
        gemmologistVC.isFromLivingRoom = YES;
        self.needShowliveSmallView = YES;
//        MJWeakSelf;
        gemmologistVC.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
            if (isFollow) {
                //点击关注户的回调,刷新ui
            }
        };
        [self.navigationController pushViewController:gemmologistVC animated:YES];
    }
    else if (self.audienceUserRoleType == JHAudienceUserRoleTypeSale ||
             self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant) {
        /// 1 卖货观众 2卖货助理 社区版本才可以跳转
        self.needShowliveSmallView = YES;
        JHAnchorInfoViewController *vc = [[JHAnchorInfoViewController alloc] init];
        vc.channel = self.channel;
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
        [JHGrowingIO trackEventId:JHChannelLocalldAnchorClick variables:@{@"channelLocalId":self.channel.channelLocalId ? : @""}];
    }
    else if (self.audienceUserRoleType == 9 ||
             self.audienceUserRoleType == 10) {
        self.needShowliveSmallView = YES;
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.roomId = self.channel.roomId;
        vc.anchorId = self.channel.anchorId;
        vc.channelLocalId = self.channel.channelLocalId;
        vc.fromSource = @"live_in";
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
    } else if (self.audienceUserRoleType == 11 ||
               self.audienceUserRoleType == 12) {
        self.needShowliveSmallView = YES;
        JHRecycleInfoViewController *vc = [[JHRecycleInfoViewController alloc] init];
        vc.roomId = self.channel.roomId;
        vc.anchorId = self.channel.anchorId;
        vc.channelLocalId = self.channel.channelLocalId;
        vc.fromSource = @"live_in";
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
    }
    
    ///369神策埋点:直播间互动_点击头像
    [self sa_trackingCommonClick:@"zbjhdHeadClick"];
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
    
    
    JH_WEAK(self)
    if (_likeCountTimer) {
        [_likeCountTimer stopGCDTimer];
    }
    _likeCountTimer=[[BYTimer alloc]init];
    [self.likeCountTimer startGCDTimerOnMainQueueWithInterval:20 Blcok:^{
        JH_STRONG(self)
        [self uploadLikeCount];
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
            if (self.isFlashSendOrder) {
                /// 闪购
                JHFlashSendOrderInputView *view = [self.innerView viewWithTag:JHRoomFlashSendOrderViewTag];
                [view showImageViewAction:image];
                self.innerView.hidden = NO;
            } else {
                /// 卖场发单
                JHRoomSendOrderView *view = [self.innerView viewWithTag:JHRoomSendOrderViewTag];
                [view showImageViewAction:image];
            }
        }
    }
}

- (void)getNotic {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/sysNotice/roomNotice") Parameters:@{@"noticeEnum":@"enter",@"anchorId":self.channel.anchorId} successBlock:^(RequestModel *respondObject) {
        NSArray *array = respondObject.data;
        for (NSDictionary *dic in array) {
            if (dic[@"content"]) {
                [_innerView setRunViewText:dic[@"content"] andIcon:nil andshowStyle:0];
            }
        }
        [_innerView showRunView];
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
     //TODO jiang  url后角色类型是不是需要兼容定制 现在角色类型逻辑是不是有问题 需要跟h5确认
    
    [self.webActivity jh_loadWebURL:ActivityURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0,[YDHelper get13TimeStamp])];
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
            make.top.mas_equalTo(UI.statusBarHeight + 120);
            make.size.mas_equalTo(CGSizeMake(94, 144));
            make.left.equalTo(self.innerView);
        }];
    }
    else
    {
        [self.webActivity mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(UI.statusBarHeight + 120);
            make.size.mas_equalTo(CGSizeMake(75, 79));
            make.right.equalTo(self.innerView).offset(-5);
        }];
    }
    
    @weakify(self);
    self.webActivity.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        @strongify(self);
//        [self sa_trackingWithOther_name:@"coupon"];
        return [self.channel mj_JSONString];
        
    };
}
- (JHWebView *)protectGoodsButton{
    if (!_protectGoodsButton) {
        _protectGoodsButton = [[JHWebView alloc] init];
        _protectGoodsButton.backgroundColor = [UIColor clearColor];
        [_protectGoodsButton jh_loadWebURL:H5_BASE_STRING(@"/jianhuo/app/preservation/preservationEn.html")];
    }
    return _protectGoodsButton;
}

- (void)initWebRightBottom {
    _webRightBottom = [[JHWebView alloc] init];
    _webRightBottom.from = @"直播间页";
    [self.innerView addSubview:self.webRightBottom];
                                                                                   //130
    CGFloat top = self.audienceUserRoleType == JHAudienceUserRoleTypeSaleAssistant ? 300 : 115;
//    if(![self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
        top = top - 100;
    _webRightBottom.tag = 100010;
    [_webRightBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.innerView.bottomBar.mas_top).offset(-top);
        make.right.equalTo(self.innerView.mas_right);
        make.size.mas_equalTo(CGSizeMake(83, 83));
    }];
    
    NSString *url = RightBottomActivityURL(self.audienceUserRoleType > JHAudienceUserRoleTypeAppraise,0);
    if([JHEnvVariableDefine getService] == JHServiceTypeDevelop){
        url = [url stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
    }
    [_webRightBottom jh_loadWebURL:url];
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
    
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [RACObserve(self, currentUserRole) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            CurrentUserRole type = [x integerValue];
            self.webRightBottom.hidden = (type == CurrentUserRoleLinker);
            self.roomDetailView.isOpenGesture = (type == CurrentUserRoleLinker);
        }];
    }
    else if (self.audienceUserRoleType && self.audienceUserRoleType != JHAudienceUserRoleTypeCustomize) {
        RACChannelTo(self.webRightBottom, hidden) = RACChannelTo(self.innerView.bottomBar, hidden);
    }
}

-(void)getRecommendAnchors{
    // appraise
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/channel/recommendAppraise?channelType=") stringByAppendingString:self.audienceUserRoleType==1?JHLiveRoomSell:JHLiveRoomAppraise] Parameters:nil successBlock:^(RequestModel *respondObject) {
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
        DDLogInfo(@"******newPage*******a");
        [self getNewPage:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView!=self.tableView) {
        return;
    }
    DDLogInfo(@"******newPage*******b");
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
            [[JHLivePlayerManager sharedInstance] shutdown];
            [self clean];
            self.isClean=YES;
        }
    }
}

- (void)noteBrowseDurationBegin
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:JHUPBrowseBegin forKey:JHUPBrowseKey];
    [params setValue:self.groupId forKey:@"group1_id"];
    [params setValue:(self.channel.channelLocalId ? : @"") forKey:@"room_id"];
    
    //用户画像浏览时长:begin
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomBrowse params:params];
    }
    else
    {
        if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
        {///回血直播间
            
        }
        else if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone])
        {//原石直播间
            
        }
        else
        {
            [JHUserStatistics noteEventType:kUPEventTypeLiveRoomDetailBrowse params:params];
        }
    }
}

- (void)noteBrowseDurationEnd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:JHUPBrowseEnd forKey:JHUPBrowseKey];
    [params setValue:self.groupId forKey:@"group1_id"];
    [params setValue:(self.channel.channelLocalId ? : @"") forKey:@"room_id"];
    //用户画像浏览时长:end
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeAppraise)
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomBrowse params:params];
    }
    else
    {
        if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
        {///回血直播间
            
        }
        else if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone])
        {//原石直播间
            
        }
        else
        {
            [JHUserStatistics noteEventType:kUPEventTypeLiveRoomDetailBrowse params:params];
        }
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
}
-(void)clean{
    
    if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
    {///回血直播间
        [JHUserStatistics noteEventType:kUPEventTypePayBackLiveRoomDetailBrowse params:@{@"room_id" : self.channel.channelLocalId, JHUPBrowseKey : JHUPBrowseEnd}];
    }
    
    [self removeChatManager];
    [self  audienceOut];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(progressHistoryMsg) object:nil];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(guideLoginRedPocket) object:nil];
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
    
    [self.currentCell.infoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_playLogo removeFromSuperview];
    [_canvas removeFromSuperview];
    [_innerView removeFromSuperview];
    [_roomDetailView removeFromSuperview];
    _playLogo=nil;
    _canvas=nil;
    _innerView=nil;
    _roomDetailView=nil;
    [JHWebImage clearCacheMemory];
}
-(JHAudienceUserRoleType)getAudienceUserRoleType{
    
    JHAudienceUserRoleType roleType = JHAudienceUserRoleTypeAppraise;
    
    if ([JHLiveRoomStatus isLiveRoomType:JHLiveRoomTypeSell channelType:self.channel.channelType]) {
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameCustomized]) {
            roleType = JHAudienceUserRoleTypeCustomize;
        }
      else  if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRecycle]) {
            roleType = JHAudienceUserRoleTypeRecycle;
        }
        else{
            roleType = JHAudienceUserRoleTypeSale;
        }
    }
    if (self.channel.isAssistant) {
        if ( roleType == JHAudienceUserRoleTypeSale){
            roleType = JHAudienceUserRoleTypeSaleAssistant;
        }
        
        else if ( roleType == JHAudienceUserRoleTypeCustomize){
            roleType = JHAudienceUserRoleTypeCustomizeAssistant;
        }
        else if ( roleType == JHAudienceUserRoleTypeRecycle){
            roleType = JHAudienceUserRoleTypeRecycleAssistant;
        }
    }
    return roleType;
}
-(void)initNewRoom{
    
    if (_innerView) {
        [self cleanView];
    }
    self.isClean=NO;
    [self initConentView];  //初始化直播间页面
    [self registerChatManager];
    [self saveWatchTrack];
    
    if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
    {///回血直播间
        [JHUserStatistics noteEventType:kUPEventTypePayBackLiveRoomDetailBrowse params:@{@"room_id" : self.channel.channelLocalId, JHUPBrowseKey : JHUPBrowseBegin}];
    }
    
    if([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone] || [self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone])
    {
        [JHUserStatistics noteEventType:kUPEventTypeResalLiveRoomDetailEntrance params:@{@"room_id" : self.channel.channelLocalId}];
    }
   
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
    [self.currentCell.infoView addSubview:self.roomDetailView];
    [self.roomDetailView addSubview:self.innerView];
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
    [countDownTimer invalidate];
     countDownTimer  =nil;
}
- (void)cancelRequest
{
    for (NSURLSessionTask  * task in [HttpRequestTool sessionManager].tasks) {
        // 离开直播间请求和上报点赞请求不取消
        if (![task.originalRequest.URL.path containsString:@"connectMic/leave"]&&
            ![task.originalRequest.URL.path containsString:@"connectMic/leave"]&&
            ![task.originalRequest.URL.path containsString:@"channelLike"]) {
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
        self.audienceUserRoleType = [self getAudienceUserRoleType];
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
    
//    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/switSellChannelsNew?channelLocalId=%@"),self.channel.channelLocalId];
//
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:10];
    [dic setObject:self.channel.channelLocalId forKey:@"channelLocalId"];
    if (self.groupId) {
        [dic setObject:self.groupId forKey:@"groupId"];
    }
    if (self.entrance) {
           [dic setObject:self.entrance forKey:@"entrance"];
       }
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/switSellChannelsNew") Parameters:dic successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
      //  [UITipView showTipStr:respondObject.message];
    }];
    
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
    [webview jh_loadWebURL:FindWishPaperURL(accid)];
    webview.frame = self.view.bounds;
    [self.view addSubview:webview];
    JH_WEAK(self)
    webview.operateGetRoomInfo = ^NSString * _Nonnull(NSString * _Nonnull callname, NSString * _Nonnull tag, NSString * _Nonnull param) {
        JH_STRONG(self)
        return [self.channel mj_JSONString];
    };
}

/// 观看直播10分钟
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
            string = [self filterBlankStr:string];
            if([string length] > 0)
            {
                [self.innerView.riskTestBtn setTitle:string forState:UIControlStateNormal];
            }
            
        } failureBlock:^(RequestModel *respondObject) {
            
        }];
    }
    
}
- (NSString*)filterBlankStr:(NSString*)str
{
    NSString *string = str;
    if(string)
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}

- (void)requestRiskTips {
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/risk") Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHRiskDataModel *model = [JHRiskDataModel mj_objectWithKeyValues:respondObject.data];
        NSString *string = model.rank;
        string = [self filterBlankStr:string];
        if([string length] > 0)
        {
            [self.innerView.riskTestBtn setTitle:string forState:UIControlStateNormal];
        }
        
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
        [webview jh_loadWebURL:[urlString stringByAppendingFormat:@"?isSell=%d&isBroad=%d&isAssistant=%d",self.audienceUserRoleType>JHAudienceUserRoleTypeAppraise?1:0, 0,(int)self.channel.isAssistant]];
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


- (void)displayAnnoucement:(NSString *)imageUrl {
    if (!self.channel.isAssistant)  {
        JH_WEAK(self)
        [JHWebImage loadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRefreshCached completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
            JH_STRONG(self)
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
        _redPacketViewModel.trackingParams = [self sa_trackingParams];
    }
    return _redPacketViewModel;
}

- (NSDictionary *)sa_trackingParams {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setValue:self.channel.channelId forKey:@"channel_id"];
    [params setValue:self.channel.title forKey:@"channel_name"];
    [params setValue:self.channel.anchorId forKey:@"anchor_id"];
    [params setValue:self.channel.anchorName forKey:@"anchor_nick_name"];
    [params setValue:self.channel.channelLocalId forKey:@"channel_local_id"];
    [params setValue:self.channel.channelType forKey:@"anchor_role"];
    return params.copy;
}

- (void)sendFreePresent {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/gift/sendFreeGift/auth") Parameters:@{@"channelId":self.channel.channelLocalId} successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
-(void)pushSuggestVC:(JHAndienceInnerView *)jhAndienceInnerView
{
    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self anchorId:self.channel.anchorId];
    
}


#pragma mark -
#pragma mark - 直播领津贴模块

- (BOOL)needLogin {
    if (![JHRootController isLogin]) {
        [JHGrowingIO trackEventId:@"enter_live_in" from:@"step_red_envelope_coollection_click"];
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
        
        [self sa_trackingWithOther_name:@"allowance"];
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
    ///369神策埋点:直播间互动_津贴领取
    [self sa_trackingAllowanceRecieve:data[@"takeMoney"]];
    
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
    if (self.audienceUserRoleType != 9 &&
        self.audienceUserRoleType != 10) {
        [self getRecommendAnchors];
     }
    self.channel.status = @"1";
    //如果连麦中 关闭连麦小窗
    if (self.currentUserRole == CurrentUserRoleLinker) {
        [self.innerView switchToWaitingUI];
    }

    [_ladderWidget setWidgetEnabled:NO];
    [self.audienceConnectView dismiss];
}

//神策埋点
- (void)sa_tracking:(NSString *)event andTime:(NSTimeInterval)tim{
    NSMutableArray *cateArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
        [cateArray addObject:model.customizeFeeName];
    }
    
    NSString *connectionType = @"";
    switch (self.audienceUserRoleType) {
        case JHAudienceUserRoleTypeAppraise: ///鉴定观众
            connectionType = @"鉴定";
            break;
        case JHAudienceUserRoleTypeCustomize: ///定制观众
            connectionType = @"定制";
            break;
        default:
            connectionType = @"鉴定";
            break;
    }
    
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = event;
    if (tim>0) {
        model.watch_duration = @(tim);
    }
    if ([self.shareType isNotBlank]) {
        model.operation_type = self.shareType;
        if ([self.shareType isEqualToString:@"关注"]) {
            model.page_position = @"直播间页面";
        }
    }
    model.source_page = self.entrance;
    model.connection_type = connectionType;
    model.anchor_range = cateArray.copy;
    [model transitionWithModel:self.channel needFollowStatus:NO];
    
    if ([self.channel.first_channel isNotBlank]) {
        if([self.channel.first_channel isEqualToString:@"sell"]) {
            model.first_channel = @[@"卖场"];
        }
        
        if([self.channel.first_channel isEqualToString:@"appraise"]) {
            model.first_channel = @[@"鉴定"];
        }
    }
    
    if ([self.channel.channelType isNotBlank]) {
        if([self.channel.channelType isEqualToString:@"sell"]) {
            model.first_channel = @[@"卖场"];
        }
        
        if([self.channel.channelType isEqualToString:@"appraise"]) {
            model.first_channel = @[@"鉴定"];
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
    
    if([model.event isEqualToString:@"applicationClick"] || [model.event isEqualToString:@"connectionEnd"] || [model.event isEqualToString:@"connectionRequest"] || [model.event isEqualToString:@"connectionSuccess"] || [model.event isEqualToString:@"zbjhdAllowanceReceive"] || [model.event isEqualToString:@"zbjhdAttention"] || [model.event isEqualToString:@"zbjhdComment"] || [model.event isEqualToString:@"zbjhdHeadClick"] || [model.event isEqualToString:@"zbjhdLike"]) {
        
        if([params valueForKey:@"is_follow_anchor"]) {
            [params removeObjectForKey:@"is_follow_anchor"];
        }
        
        
    }
    
    if([model.event isEqualToString:@"zbjhdAllowanceReceive"] || [model.event isEqualToString:@"zbjhdAttention"]|| [model.event isEqualToString:@"zbjhdHeadClick"]|| [model.event isEqualToString:@"zbjhdLike"]) {
        
        if([params valueForKey:@"connection_type"]) {
            [params removeObjectForKey:@"connection_type"];
        }
    }
    
    if([model.event isEqualToString:@"connectionSuccess"]) {
        
        if([params valueForKey:@"watch_duration"]) {
            [params removeObjectForKey:@"watch_duration"];
        }
    }
    
    if([model.event isEqualToString:@"connectionSuccess"]) {
        
        if([params valueForKey:@"watch_duration"]) {
            [params removeObjectForKey:@"watch_duration"];
        }
    }
    [JHAllStatistics jh_allStatisticsWithEventId:event params:params type:JHStatisticsTypeSensors];
}

///红包相关神策埋点
- (void)sa_trackRedPocket:(NSString *)event redPockecModel:(JHAppraiseRedPacketListModel *)data {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = event;
    model.red_envelope_id = data.redPacketId;
    model.red_envelope_name = data.sendCustomerName;
    [model transitionWithModel:self.channel needFollowStatus:NO];
    [JHTracking trackModel:model];
}

///369神策埋点:直播间互动_用户关注
- (void)sa_trackingAttention {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = @"zbjhdAttention";
    model.operation_type = @"关注";
    model.page_position = @"直播间页面";
    model.source_page = self.entrance;
    [model transitionWithModel:self.channel needFollowStatus:NO];
    [JHTracking trackModel:model];
}

///369神策埋点:直播间互动_点击头像
- (void)sa_trackingCommonClick:(NSString *)event {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = event;
    [model transitionWithModel:self.channel needFollowStatus:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if([model.event isEqualToString:@"applicationClick"] || [model.event isEqualToString:@"connectionEnd"] || [model.event isEqualToString:@"connectionRequest"] || [model.event isEqualToString:@"connectionSuccess"] || [model.event isEqualToString:@"zbjhdAllowanceReceive"] || [model.event isEqualToString:@"zbjhdAttention"] || [model.event isEqualToString:@"zbjhdComment"] || [model.event isEqualToString:@"zbjhdHeadClick"] || [model.event isEqualToString:@"zbjhdLike"]) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
        if([params valueForKey:@"is_follow_anchor"]) {
            [params removeObjectForKey:@"is_follow_anchor"];
        }
        
        
    }
    
    if([model.event isEqualToString:@"zbjhdAllowanceReceive"] || [model.event isEqualToString:@"zbjhdAttention"]|| [model.event isEqualToString:@"zbjhdHeadClick"]|| [model.event isEqualToString:@"zbjhdLike"]) {
        
        if([params valueForKey:@"connection_type"]) {
            [params removeObjectForKey:@"connection_type"];
        }
    }
    if([model.event isEqualToString:@"connectionSuccess"]) {
        
        if([params valueForKey:@"watch_duration"]) {
            [params removeObjectForKey:@"watch_duration"];
        }
    }
    
    if([model.event isEqualToString:@"connectionSuccess"]) {
        
        if([params valueForKey:@"watch_duration"]) {
            [params removeObjectForKey:@"watch_duration"];
        }
    }
    if (params.count <= 0) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:event params:params type:JHStatisticsTypeSensors];
}


///369神策埋点:申请点击
- (void)sa_trackingApplicationClick:(NSString *)event {
    NSMutableArray *cateArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
        [cateArray addObject:model.customizeFeeName];
    }

    NSString *connectionType = @"";
    switch (self.audienceUserRoleType) {
        case JHAudienceUserRoleTypeAppraise: ///鉴定观众
            connectionType = @"鉴定";
            break;
        case JHAudienceUserRoleTypeCustomize: ///定制观众
            connectionType = @"定制";
            break;
        default:
            connectionType = @"鉴定";
            break;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self sa_commonParams:YES]];
    [params setValue:connectionType forKey:@"connection_type"];
    [JHTracking trackEvent:event property:params.copy];
}

- (void)sa_trackingConnectionEnd {
//    connectionEnd
    NSMutableArray *cateArray = [NSMutableArray array];
    for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
        [cateArray addObject:model.customizeFeeName];
    }

    NSString *connectionType = @"";
    switch (self.audienceUserRoleType) {
        case JHAudienceUserRoleTypeAppraise: ///鉴定观众
            connectionType = @"鉴定";
            break;
        case JHAudienceUserRoleTypeCustomize: ///定制观众
            connectionType = @"定制";
            break;
        default:
            connectionType = @"鉴定";
            break;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self sa_commonParams:YES]];
    [params setValue:@(([[CommHelp getNowTimeTimestamp] integerValue]-[startTime integerValue])/1000) forKey:@"connection_duration"];
    
    if([params valueForKey:@"is_follow_anchor"]) {
        [params removeObjectForKey:@"is_follow_anchor"];
    }
    [params setValue:connectionType forKey:@"connection_type"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"connectionEnd" params:params type:(JHStatisticsTypeSensors)];
}

- (NSDictionary *)sa_commonParams:(BOOL)neenAnchorRange {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.channel.channelId forKey:@"channel_id"];
    [params setValue:self.channel.channelLocalId forKey:@"channel_local_id"];
    [params setValue:self.channel.title forKey:@"channel_name"];
    [params setValue:self.channel.anchorId forKey:@"anchor_id"];
    [params setValue:self.channel.anchorName forKey:@"anchor_nick_name"];
    if (neenAnchorRange) {
        NSMutableArray *cateArray = [NSMutableArray array];
        for (JHCustomizeFlyOrderCountCategoryModel *model in self.countCategaryArray) {
            [cateArray addObject:model.customizeFeeName];
        }
        [params setValue:cateArray forKey:@"anchor_range"];
    }
    return params.copy;
}
- (void)sa_trackingWithOther_name:(NSString *)other_name{
    if(self.audienceUserRoleType == JHAudienceUserRoleTypeRecycle){
        [JHTracking trackEvent:@"clickOther" property:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":other_name}];
    }
}
///直播间津贴领取
- (void)sa_trackingAllowanceRecieve:(NSString *)allowance {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = @"zbjhdAllowanceReceive";
    if ([allowance isNotBlank]) {
        model.allowance = [NSDecimalNumber decimalNumberWithString:allowance];
    }
    [model transitionWithModel:self.channel needFollowStatus:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([model.event isEqualToString:@"zbjhdAllowanceReceive"]) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
        if([params valueForKey:@"is_follow_anchor"]) {
            [params removeObjectForKey:@"is_follow_anchor"];
        }
    }
    if (params.count <= 0) {
        params = [NSMutableDictionary dictionaryWithDictionary:model.properties];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdComment" params:params type:JHStatisticsTypeSensors];
}

#pragma mark - LAZY
- (JHLiveActivityManager *)activityManager {
    if (!_activityManager) {
        _activityManager = [JHLiveActivityManager sharedManager];
    }
    return _activityManager;
}

@end


//
//  JHAndienceInnerView.m
//  TTjianbao
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAndienceInnerView.h"
#import "NTESLiveChatView.h"
#import "NTESLiveLikeView.h"
#import "NTESLivePresentView.h"
#import "NTESLiveCoverView.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "NTESLiveActionView.h"
#import "NTESTimerHolder.h"
#import "NTESLiveBypassView.h"
#import "NTESMicConnector.h"
#import "NTESGLView.h"
#import "NTESNetStatusView.h"
#import "NTESCameraZoomView.h"
#import "NTESNickListView.h"
#import "JHLivePopAlertViews.h"
#import "JHLiveEndPageView.h"
#import "UMengManager.h"
#import "JHSystemMsgAttachment.h"
#import "JHSystemMsgAnimationView.h"
#import "JHAnchorActionView.h"
#import "JHPresentBoxView.h"
#import "NTESPresent.h"
#import "JHPresentView.h"
#import "JHOrderListView.h"
#import "JHDoteNumberLabel.h"
#import "JHOrderListViewController.h"
#import "JHClaimOrderListView.h"
#import "JHLiveRoomGuidanceView.h"
#import "JHAutoRunView.h"
#import "JHPopDownTimeView.h"
#import "JHRightArrowBtn.h"
#import "JHWebViewController.h"
#import "JHSellRoomGuidenceView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHWebView.h"
#import "AnimotionObject.h"
#import "ChannelMode.h"
#import "TTjianbaoHeader.h"
#import "JHAppraiseRedPacketView.h"
#import "JHResaleLiveRoomStretchView.h"
#import "JHDotButtonView.h"
#import "JHUIFactory.h"
#import "JHMainLiveRoomTabView.h"
#import "JHMainRoomOnSaleStoneView.h"
#import "JHLastSaleStoneView.h"
#import "JHStoneLiveWindowGuideView.h"
#import "JHMakeRedpacketController.h"
#import "JHReplyMessageView.h"
#import "JHSVGAAnimationView.h"
#import "JHNewGuideTipsView.h"
#import "JHAnnouncementDisplayView.h"
#import "JHLiveRoomListView.h"
#import "JHLiveRoomListViewCellModel.h"
#import "NTESGrowingInternalTextView.h"
#import "AnimotionObject.h"
#import "JHLiveRoomPKView.h"
#import "JHLiveRoomPKModel.h"
#import "JHFollowBubbleImage.h"
#import "NSString+Extension.h"
#import "JHCustomizeAnchorBottomBar.h"
#import "JHLiveScrollLabelView.h"
#import "JHSaleLiveRoomCustomizeList.h"
#import "JHCustomizeLinkShowOrderView.h"
#import "JHStoneResaleViewController.h"
#import "JHCustomOrderView.h"
#import "JHLiveOrderSelectView.h"
#import "JHLinkSwichTipsView.h"
#import "JHNewOrderListViewController.h"
#import "CommAlertView.h"
#import "JHNimNotificationManager.h"
#import "JHTrackingAudienceLiveRoomModel.h"
#import "JHSendLivingTipManeger.h"
#import "JHRecycleUploadTypeSeleteViewController.h"
#import "JHLiveRoomTopTagsView.h"
#import "JHRecycleOrderPageController.h"
#import "JHChatBusiness.h"
#import "JHLuckyBagView.h"

#define kViewTagStoneOrderView 1111
#define kViewTagResaleView 2222
#define kViewTagUserActionView 3333
#define kViewTagForSaleView 2020
@interface JHAndienceInnerView()<NTESLiveActionViewDelegate,NTESTextInputViewDelegate,NTESTimerHolderDelegate,NTESLiveBypassViewDelegate,NTESLiveCoverViewDelegate,NTESLiveChatViewDelegate, JHLiveBottomBarDelegate,UIGestureRecognizerDelegate, JHAutoRunViewDelegate,JHLiveRoomListViewDelegate,JHCustomizeAnchorBottomBarDelegate,JHAnnouncementDisplayViewDelegate>{
    CGFloat _keyBoradHeight;
    NTESTimerHolder *_timer;
    CALayer *_cameraLayer;
    CGSize _lastRemoteViewSize;
    BOOL isSendOrderKeyBoard;
    BOOL isBackLook;//回放
}

@property (nonatomic, strong) UIButton *closeRoomButton;              //关闭直播按钮
@property (nonatomic, copy)   NSString *roomId;                   //聊天室ID

@property (nonatomic, strong) JHReplyMessageView   *replyMessageView;//快捷回复语
@property (nonatomic, strong) NTESLiveActionView   *actionView;    //操作条
@property (nonatomic, strong) NTESLiveLikeView     *likeView;      //爱心视图
@property (nonatomic, strong) NTESLivePresentView  *presentView;   //礼物到达视图
@property (nonatomic, strong) NTESLiveCoverView    *coverView;     //状态覆盖层

@property (nonatomic, strong) NSMutableArray <NTESLiveBypassView *> *bypassViews;
@property (nonatomic, strong) NTESGLView           *glView;        //接收YUV数据的视图

@property (nonatomic, strong) NTESNetStatusView    *netStatusView;    //网络状态视图

@property (nonatomic, strong) NTESCameraZoomView   *cameraZoomView;

@property (nonatomic) BOOL isActionViewMoveUp;    //actionView上移标识

@property (nonatomic, strong) JHLivePopAlertViews *hdAlert;

@property (nonatomic, strong) JHSystemMsgAnimationView *systemMsgAnimationView;

@property (nonatomic, strong) JHComeinAnimationView *comeInAnimationView;

@property (nonatomic,strong) JHAnchorActionView *anchorActionView;

@property (nonatomic,strong) JHPresentBoxView *presentBoxView;

@property (nonatomic,strong) JHPresentView *jhpresentView;

@property (nonatomic,strong) UIButton *orderBtn;



@property (nonatomic,strong) JHDotButtonView *havePriceBtn;
@property (nonatomic,strong) JHDoteNumberLabel *orderNumLabel;
@property (nonatomic,strong) JHSaleAnchorActionView *saleAnchorActionView;
@property (nonatomic,strong) JHOrderListView *orderListView;
@property (nonatomic,strong) JHClaimOrderListView *claimOrderListView;
@property (nonatomic,strong) JHLiveRoomGuidanceView *liveRoomGuidanceView;
@property (nonatomic,strong) JHAutoRunView *autoRunView;

@property (nonatomic, strong) JHAnnouncementDisplayView *announcementDisplayView;

@property (nonatomic, strong) JHStoneLiveView *stoneLiveView;
@property (nonatomic, strong) UIButton *restorePriceBtn;
@property (nonatomic, assign) CGFloat resaleHeight;
@property (nonatomic, strong) JHLiveRoomListView *liveRoomListView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *appraiserRedPacketBtn;
@property (nonatomic, strong) JHAppraiseRedPacketView* appraiseRedPacketView; //鉴定红包
@property (nonatomic, strong) JHAppraiseRedPacketListModel *appraiseRedPacketListModel;
@property (nonatomic, assign)NSInteger orderCount;
@property (nonatomic, strong) JHFollowBubbleImage *followImage;

@property (nonatomic, copy) NSString *jadeiteListStr;
@property (nonatomic, copy) NSString *rankName;

@property (nonatomic,strong) UIButton * saleGuide_NewUserBtn;
@property (nonatomic, strong) JHCustomizeAnchorBottomBar * customBottomBar;


@property (nonatomic, strong) JHSaleLiveRoomCustomizeList * customizeList;
@property (nonatomic, strong) JHCustomizeLinkShowOrderView *leftCustomizeOrder;
@property (nonatomic, strong) ChannelMode *channelMode;

//顶部按钮
@property (nonatomic, strong) JHLiveScrollLabelView * appraiseScopeLabel;//鉴定、回收范围

@property (nonatomic, strong) JHRightArrowBtn *safeTipsBtn;//源头好货
@property (nonatomic, strong) JHRightArrowBtn *commentBtn; //评价
@property (nonatomic, strong) JHRightArrowBtn *saleGuideBtn;//回血、定制攻略
@property (nonatomic, strong) UIView *secondFloorView; //第二层标签视图

@property (nonatomic,strong) JHLiveRoomCustomBtnView *orderBtnView;  //待付订单
@property (nonatomic,strong) JHLiveRoomCustomBtnView *customizeBtnView; //定制队列
@property (nonatomic,strong) JHLiveRoomCustomBtnView *praiseBtnView; //鉴定队列
@property (nonatomic,strong) JHLiveRoomCustomBtnView *recycleBtnView; //回收队列
@property (nonatomic, strong) JHRightArrowBtn *jadeiteListBtn;  //翡翠榜单
@property (nonatomic, strong) JHRightArrowBtn *stoneRestoreBtn;//原石回血按钮
@property (nonatomic, strong) JHLiveRoomCustomBtnView *waitRecycleBtn;//待回收按钮
@property (nonatomic, strong) JHLiveRoomTopTagsView *thirdFloorView; //第三层标签视图

@property (nonatomic, strong) NSMutableArray * topBtnArray;
@property (nonatomic, strong) JHLuckyBagView *luckyBagView;
@end
@implementation JHAndienceInnerView

- (instancetype)initWithChannel:(ChannelMode *)channel
                          frame:(CGRect)frame
                       isAnchor:(BOOL)isAnchor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channel = channel;
        _roomId = channel.roomId;
        self.resaleHeight = 0;
        [self setup];
        
        NSLog(@"innerview init");
        self.clipsToBounds = YES;
        self.ownLikeCount=0;
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapGesture];
        
        [self checkChatType];
    }
    
    return self;
}
-(void)starBubble{
    
    [self performSelector:@selector(showFollowBubble) withObject:nil afterDelay:300.];

}
-(void)removeFollowBubble{
    
    if (_followImage) {
        [_followImage removeFromSuperview];
        _followImage = nil;
    }
}
- (void)topBtnViewRemoveView:(UIView *)view andPosition:(NSInteger)index{
    if ([self.topBtnArray containsObject:view]) {
        [self.topBtnArray replaceObjectAtIndex:index withObject:@""];
        [self.thirdFloorView setTags:self.topBtnArray];
    }
}
- (void)topBtnViewAddView:(UIView *)view andPosition:(NSInteger)index{//0pk、1订单 2鉴定队列 3定制 4回收 5待回收 6原石回血
    if ([self.topBtnArray containsObject:view]) {
        
    }else{
//        if (index == 0) {
//            [self.topBtnArray insertObject:view atIndex:index];
//        }else if(index == 1){
//            if ([self.topBtnArray containsObject:self.orderBtnView]) {
//                [self.topBtnArray insertObject:view atIndex:index];
//            }else{
//                [self.topBtnArray insertObject:view atIndex:0];
//            }
//        }else{
//            [self.topBtnArray addObject:view];
//        }
//
        [self.topBtnArray replaceObjectAtIndex:index withObject:view];
        [self.thirdFloorView setTags:self.topBtnArray];
    }
    
}
- (void)updateGlView:(UIView*)view {
    
    [view insertSubview:self.glView atIndex:0];
}
-(void)updateCloseRoomButton:(UIView*)view{
    
    [view addSubview:self.closeRoomButton];
    [view bringSubviewToFront:self.closeRoomButton];
}
- (void)clean
{
    [self.glView removeFromSuperview];
    self.glView=nil;
    [self cleanMessages];
    [self stopShowBubble];
    [self stopPiaoPing];
    
}
-(void)stopShowBubble{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showFollowBubble) object:nil];
 
}
- (void)cleanMessages
{
    [_chatView cleanMessage];
    [_systemMsgAnimationView  cleanDataArr];
    [_comeInAnimationView cleanDataArr];
}
- (void)stopPiaoPing {
    
    [_autoRunView stopAndRemove];
    [_systemMsgAnimationView stopAndRemove];
    [_comeInAnimationView stopAndRemove];
    
    
}
- (void)dealloc{
    
    [_chatView.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_playControlView removeObserver:self forKeyPath:@"playControlHidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_autoRunView stopAnimation];
    [_autoRunView removeFromSuperview];
    _autoRunView = nil;
    
    NSLog(@"innerview  dealloc");
    
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gest {
    [self onActionType:NTESLiveActionTypeLike sender:gest.view];
}

- (UIButton *)appraiserRedPacketBtn
{
    if(!_appraiserRedPacketBtn)
    {
        _appraiserRedPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _appraiserRedPacketBtn.frame = CGRectMake(ScreenWidth - 15 - 35, ScreenHeight - 183 - 47, 78/2.0, 94/2.0);
        [_appraiserRedPacketBtn setImage:[UIImage imageNamed:@"icon_audiencelive_appraise_redpacket"] forState:UIControlStateNormal];
        [_appraiserRedPacketBtn addTarget:self action:@selector(openAppraiserRedpacketPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appraiserRedPacketBtn;
}

- (JHAppraiseRedPacketView *)appraiseRedPacketView
{
    if(!_appraiseRedPacketView)
    {
        _appraiseRedPacketView = [JHAppraiseRedPacketView new];
    }
    return _appraiseRedPacketView;
}

- (void)appraiserRedPacketHidden:(BOOL)isHidden
{
    if(isHidden)
    {
        [_appraiserRedPacketBtn removeFromSuperview];
        _appraiserRedPacketBtn = nil; //仅关闭小窗
    }
    else
    {
        [self.textInputView.textViewnew resignFirstResponder];
        //约束不起作用,???
        [self addSubview:self.appraiserRedPacketBtn];
        [self bringSubviewToFront:self.appraiserRedPacketBtn];
        [self.appraiserRedPacketBtn.layer addAnimation:[AnimotionObject shakeAnimalGroup] forKey:@"shake"];
        [self openAppraiserRedpacketPage];
    }
}
//打开鉴定师红包页
- (void)openAppraiserRedpacketPage
{
    
    [JHAppraiseRedPacketView dismissAllAppraiserRedPackeView];
    JH_WEAK(self)
    [self.appraiseRedPacketView showAppraiserData:self.appraiseRedPacketListModel action:^(id obj) {
        JH_STRONG(self)
        [self appraiserRedPacketHidden:YES]; //直接隐藏红包小icon
    }];
    
}

- (void)setAppraiseRedPacketData:(JHAppraiseRedPacketListModel*)model
{
    self.appraiseRedPacketListModel = model;
}

#pragma mark - Public
- (void)reloadAnctionWeb {
    if (self.type>0) {
        NSString *url = AuctionURL(self.type>0, NO, self.type == 2);
        [self.auctionWeb jh_loadWebURL:url];
        [UserInfoRequestManager sharedInstance].showShopwindow = NO;
    }
}

- (void)updateBackPlayUI {
    self.chatView.hidden = YES;
    self.bottomBar.hidden = YES;
    self.bottomBar.isBackLook = YES;
    isBackLook = YES;
}

- (void)setCanAppraise:(BOOL)canAppraise {
    _canAppraise = canAppraise;
    if (canAppraise) {
        self.bottomBar.pauseAppraiseBtn.hidden = YES;
    }else{
        self.bottomBar.pauseAppraiseBtn.hidden = NO;
        
    }
}
- (void)setRunViewText:(NSString *)string andIcon:(NSString *)url andshowStyle:(NSInteger)showStyle{
    [self.autoRunView addAnimationText:string andIcon:url andshowStyle:showStyle];
}
- (void)showRunView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:self.autoRunView];
        if (_endPageView) {
            [self bringSubviewToFront:self.endPageView];
        }
        [self.autoRunView startAnimation];
    });
    
}

- (void)catchImage:(UIImage *)image {
    
    [_claimOrderListView catchImage:image];
}

-(void)updaterestorePriceBtnAndsaleGuideBtnHeight {
#warning 方法逻辑有问题
    //方法逻辑有问题
    if ((self.restorePriceBtn.hidden && self.safeTipsBtn.hidden) && (self.saleGuideBtn.hidden && self.commentBtn.hidden && self.riskTestBtn.hidden)) {
        self.orderBtnView.hidden = NO;
        
    }
    else if ((self.restorePriceBtn.hidden && self.safeTipsBtn.hidden) ||(self.saleGuideBtn.hidden && self.commentBtn.hidden && self.riskTestBtn.hidden) ) {
        self.orderBtnView.hidden = NO;
        
    }
}

- (void)updateOrderCountAdd {
    if([self.channel.channelCategory containsString:JHRoomTypeNameRestoreStone]) {
        self.orderBtnView.hidden = YES;
        
        [self topBtnViewRemoveView:self.orderBtnView andPosition:1];

    } else {
        self.orderBtnView.hidden = NO;
        self.orderCount ++;
        NSString *orderNum = [NSString stringWithFormat:@"待付订单 %@",@(self.orderCount).stringValue];
        CGFloat labelW = [self getLabelWidth:orderNum]+18;
        [self updaterestorePriceBtnAndsaleGuideBtnHeight];
        self.orderBtnView.titleLabel.text = orderNum;
        self.orderBtnView.size = CGSizeMake(labelW, 18);

        [self topBtnViewAddView:self.orderBtnView andPosition:1];
        
    }
}


- (void)updateCustomizePackageOrderCountAdd {
    if ([self.channel.channelCategory containsString:JHRoomTypeNameRestoreStone]) {
        self.orderBtnView.hidden = YES;
        [self topBtnViewRemoveView:self.orderBtnView andPosition:1];
        
    } else {
        self.orderBtnView.hidden = NO;
        self.orderCount += 2;
        NSString *orderNum = [NSString stringWithFormat:@"待付订单 %@",@(self.orderCount).stringValue];
        CGFloat labelW = [self getLabelWidth:orderNum]+18;
        [self updaterestorePriceBtnAndsaleGuideBtnHeight];

        self.orderBtnView.titleLabel.text = orderNum;
        self.orderBtnView.size = CGSizeMake(labelW, 18);

        [self topBtnViewAddView:self.orderBtnView andPosition:1];
    }
}

- (void)updateOrderCount:(NSInteger)count {
    self.orderCount = count;

    if(count<=0 || [self.channel.channelCategory containsString:JHRoomTypeNameRestoreStone] || _type == 0 )
        //直播鉴定需要隐藏
    {
        self.orderBtnView.hidden = YES;
   
        [self topBtnViewRemoveView:self.orderBtnView andPosition:1];

    }else{
        self.orderBtnView.hidden = NO;
        NSString *orderNum = [NSString stringWithFormat:@"待付订单 %@",@(count).stringValue];
        CGFloat labelW = [self getLabelWidth:orderNum]+18;
        [self updaterestorePriceBtnAndsaleGuideBtnHeight];

        self.orderBtnView.titleLabel.text = orderNum;
        self.orderBtnView.size = CGSizeMake(labelW, 18);

        [self topBtnViewAddView:self.orderBtnView andPosition:1];
    }

}
-(void)updatePraiseBtnViewWithWaitNum:(NSInteger)waitNum
{
    //waitNum = -1 表示隐藏 不显示此按钮
    NSString *waitNumText = [NSString stringWithFormat:@"鉴定排队 %ld",(long)waitNum];
    CGFloat labelW = [self getLabelWidth:waitNumText]+18;
     
    if(waitNum>=0)
    {
        self.praiseBtnView.titleLabel.text = waitNumText;
        self.praiseBtnView.size = CGSizeMake(labelW, 18);
        [self topBtnViewAddView:self.praiseBtnView andPosition:2];
    }else
    {
        [self topBtnViewRemoveView:self.praiseBtnView andPosition:2];
    }
}
-(void)updateCustomizeBtnViewWithWaitNum:(NSInteger)waitNum
{
    //waitNum = -1 表示隐藏 不显示此按钮
    NSString *waitNumText = [NSString stringWithFormat:@"定制排队 %ld",(long)waitNum];
      CGFloat labelW = [self getLabelWidth:waitNumText]+18;
    _customizeBtnView.titleLabel.text = waitNumText;
    if(waitNum>0)
    {

        self.customizeBtnView.titleLabel.text = waitNumText;
        self.customizeBtnView.size = CGSizeMake(labelW, 18);
        [self topBtnViewAddView:self.customizeBtnView andPosition:3];
    }else
    {

        [self topBtnViewRemoveView:self.customizeBtnView andPosition:3];
    }
}
-(void)updateRecycleBtnViewWithWaitNum:(NSInteger)waitNum
{
    //waitNum = -1 表示隐藏 不显示此按钮
    NSString *waitNumText = [NSString stringWithFormat:@"回收排队 %ld",(long)waitNum];
      CGFloat labelW = [self getLabelWidth:waitNumText]+18;
    _recycleBtnView.titleLabel.text = waitNumText;
    if(waitNum>0)
    {
        self.recycleBtnView.titleLabel.text = waitNumText;
        self.recycleBtnView.size = CGSizeMake(labelW, 18);
        [self topBtnViewAddView:self.recycleBtnView andPosition:4];
    }else
    {
        [self topBtnViewRemoveView:self.recycleBtnView andPosition:4];
    }
}
//待回收
-(void)updatewaitRecycleBtnViewWithWaitNum:(NSInteger)waitNum
{
    //waitNum = -1 表示隐藏 不显示此按钮
    NSString *waitNumText = [NSString stringWithFormat:@"待回收 %ld",(long)waitNum];
      CGFloat labelW = [self getLabelWidth:waitNumText]+18;
    _waitRecycleBtn.titleLabel.text = waitNumText;
    if(waitNum>0)
    {

        self.waitRecycleBtn.titleLabel.text = waitNumText;
        self.waitRecycleBtn.size = CGSizeMake(labelW, 18);
        [self topBtnViewAddView:self.waitRecycleBtn andPosition:5];
    }else
    {

        [self topBtnViewRemoveView:self.waitRecycleBtn andPosition:5];
    }
}
-(CGFloat)getLabelWidth:(NSString *)text
{
    UIFont *titleFont = [UIFont fontWithName:kFontMedium size:9.0];
    NSDictionary *attributes = @{NSFontAttributeName:titleFont};
    CGSize orderBtnViewW = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return orderBtnViewW.width;
}
- (void)setCoverImage:(NSString *)url {
    [self.coverView setCoverImage:url];
}
- (void)userEnterRoom:(NSNotification *)noti {
    DDLogInfo(@"进场消息");
    
    NIMMessage *message = noti.object;
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    
    NIMChatroomNotificationContent *content = (NIMChatroomNotificationContent *)object.content;
    
    for (NIMChatroomNotificationMember *m in content.targets) {
        NIMChatroomMembersByIdsRequest *requst = [[NIMChatroomMembersByIdsRequest alloc] init];
        requst.roomId = self.roomId;
        requst.userIds = @[m.userId];
        
        if (message.messageExt) {
            [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembersByIds:requst completion:^(NSError * _Nullable error, NSArray<NIMChatroomMember *> * _Nullable members) {
                if (error) {
                    DDLogInfo(@"进入没有拿到信息 %@",error);
                    return ;
                }
                message.text = @"进入直播间";
                NIMChatroomMember *mm = members.firstObject;
                JHSystemMsg *msg = [[JHSystemMsg alloc] init];
                msg.nick = mm.roomNickname?:@"";
                msg.content = message.text;
                msg.avatar = mm.roomAvatar?:@"";
                
                if ([mm.roomNickname isEqual:[NSNull null]]&& ([mm.roomAvatar isEqual:[NSNull null]])) {
                    return;
                }
                NIMMessageChatroomExtension *ext = message.messageExt;
                ext.roomAvatar = mm.roomAvatar;
                ext.roomNickname = mm.roomNickname?:@"";
                message.messageExt = ext;
                //                [self addMessages:@[message]];
                [self.chatView addCommonComeInMessages:message];
                NSDictionary *dic = [ext.roomExt mj_JSONObject];
                if (dic) {
                    
                    //特效入场动画
                    msg.chartlet = dic[@"userTitleLevelIcon"];
                    JHMessageExtModel *extmodel = [JHMessageExtModel mj_objectWithKeyValues:dic];
                    if (extmodel.userTycoonLevel) {
                        [JHSVGAAnimationView showToView:self];
                        msg.userTycoonLevel = extmodel.userTycoonLevel;
                        msg.chartlet = extmodel.userTycoonLevelIcon;
                        [self addComeInMessage:msg];
                    }
                    
                    if ([dic[@"userEnterEffect"] integerValue]>0) {
                        msg.enter_effect = dic[@"userEnterEffect"];
                        msg.levelImg = dic[@"levelImg"];
                        [self addComeInMessage:msg];
                    }
                    
                }
            }];
        }else {
            DDLogInfo(@"进入没有扩展信息");
        }
    }
    
}

- (void)makeUpEndPage {
    
    self.endPageView.model = self.anchorInfoModel;
    [self addSubview:self.endPageView];
    [self bringSubviewToFront:self.endPageView];
    self.endPageView.frame = self.bounds;
    
}
- (void)addAnimationMessage:(JHSystemMsg *)msg {
    self.systemMsgAnimationView.bottom = self.chatView.top-10;
    [self.systemMsgAnimationView comeInActionWithModel:msg];
}

- (void)addComeInMessage:(JHSystemMsg *)msg {
    self.comeInAnimationView.bottom = self.chatView.top-50;
    [self.comeInAnimationView comeInActionWithModel:msg];
}


- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    [self.chatView addMessages:messages];
}

- (void)addPresentModel:(JHSystemMsg *)present {
    [self addSubview:self.jhpresentView];
    [self.jhpresentView comeInActionWithModel:present];
    
}
- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages
{
    //    for (NIMMessage *message in messages) {
    //        [self.presentView addPresentMessage:message];
    //    }
}

- (void)resetZoomSlider;
{
    [self.cameraZoomView reset];
}

- (void)fireLike
{
    self.likeCount++;
    [self.likeView fire666];
}

- (void)updateNetStatus:(NIMNetCallNetStatus)status
{
    [self.netStatusView refresh:status];
    [self.netStatusView sizeToFit];
}

- (void)updateConnectorCount:(NSInteger)count
{
    [self.actionView updateInteractButton:count];
}

- (void)refreshChatroom:(NIMChatroom *)chatroom
{
    _roomId = chatroom.roomId;
//    [self.infoView refreshWithChatroom:chatroom];
    
    NSString *placeHolder = [NSString stringWithFormat:@"当前直播间ID:%@",chatroom.roomId];
    placeHolder = self.type == 1 ? @"向主播询价..." : @"跟主播聊什么？";
    NTESGrowingInternalTextView *textView = self.textInputView.textViewnew;
    textView.editable = YES;
    textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}
- (void)refreshChannel:( ChannelMode*)channel{
    self.channelMode = channel;
    [self.infoView refreshWithChannel:channel];
    [self updatewaitRecycleBtnViewWithWaitNum:self.channel.awaitNum];
    
}

- (void)updateRoleType:(JHLiveRole)roleType{
    if (self.type == 1) {
        _anchorActionView.hidden = YES;
        return;
        
    }
    _bottomBar.roleType = roleType;
    
    if (roleType == JHLiveRoleAnchor) {
        _anchorActionView.hidden = NO;
        _anchorActionView.top = ScreenH-UI.bottomSafeAreaHeight-49- (ButtonHeight)*3;
        _anchorActionView.lightBtn.hidden = YES;
        
    }else if (roleType == JHLiveRoleLinker) {
        _anchorActionView.hidden = NO;
        _anchorActionView.muteBtn.hidden = YES;
        _anchorActionView.camaraBtn.hidden = YES;
        
    } else {
        _anchorActionView.hidden = YES;
    }
    
}
- (void)showFlashlightBtn:(BOOL)isShow{
    if (isShow) {
        _anchorActionView.hidden = NO;
        _anchorActionView.bottom = self.bottomBar.top;
        _anchorActionView.muteBtn.hidden = YES;
        _anchorActionView.camaraBtn.hidden = YES;
        _anchorActionView.lightBtn.hidden = NO;
    }else{
        _anchorActionView.hidden = YES;
    }

}
- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                     uid:(NSString *)uid
{
    NTESLiveBypassView *bypassView = [self bypassViewWithUid:uid];
    if (_lastRemoteViewSize.width != width || _lastRemoteViewSize.height != height) {
        _lastRemoteViewSize = CGSizeMake(width, height);
        [self setNeedsLayout];
    }
    
    if ([self.anchorInfoModel.customerId isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]){
        [bypassView updateRemoteView:yuvData width:width height:height];
        if (_lastRemoteViewSize.width != width || _lastRemoteViewSize.height != height) {
            _lastRemoteViewSize = CGSizeMake(width, height);
            [self setNeedsLayout];
        }
    }else
    {
        NIMChatroom *roomInfo = [[NTESLiveManager sharedInstance] roomInfo:self.roomId];
        if (self.localFullScreen) {
            
            if ([uid isEqualToString:roomInfo.creator])  {
                [self.liveBypassView updateRemoteView:yuvData width:width height:height];
                [self.liveBypassView refresh:nil status:NTESLiveBypassViewStatusStreamingVideo];
                self.localDisplayView.frame = self.glView.bounds;
                
                [self.glView addSubview:self.localDisplayView];
                
            }else {
                [bypassView updateRemoteView:yuvData width:width height:height];
                [bypassView updateRemoteView:yuvData width:width height:height];
                
            }
            
        }else {
            if ([uid isEqualToString:roomInfo.creator]) {
                for (UIView *v in _glView.subviews) {
                    if (v == self.localDisplayView) {
                        [v removeFromSuperview];
                    }
                }
                self.localDisplayView.frame = self.liveBypassView.bounds;
                [self.glView render:yuvData width:width height:height];
                [self.liveBypassView refresh:nil status:NTESLiveBypassViewStatusLocalVideo];
                
                
            } else {
                [bypassView updateRemoteView:yuvData width:width height:height];
            }
        }
    }
    

    
}
- (void)updateBeautify:(BOOL)isBeautify
{
    [self.actionView updateBeautify:isBeautify];
}
- (void)updateGuessButton:(BOOL)isOn{
    self.anchorActionView.guessBtn.hidden=!isOn;
}
- (void)updateGuessButtonSelect:(BOOL)isSelect{
    
    self.anchorActionView.guessBtn.selected=isSelect;
}
- (void)updateflashButton:(BOOL)isOn
{
    [self.actionView updateflashButton:isOn];
}

- (void)updateFocusButton:(BOOL)isOn
{
    [self.actionView updateFocusButton:isOn];
}

- (void)updateMirrorButton:(BOOL)isOn
{
    [self.actionView updateMirrorButton:isOn];
}

- (void)updateQualityButton:(BOOL)isHigh
{
    [self.actionView updateQualityButton:isHigh];
}

- (void)updateWaterMarkButton:(BOOL)isOn
{
    [self.actionView updateWaterMarkButton:isOn];
}

- (CGFloat)getActionViewHeight
{
    return self.actionView.height;
}

#pragma mark - Action
- (void)tapOrderView {
    [self showOrderListFromSource:@"homeMarketLiveDetail"];
    [self sa_trackingWithOther_name:@"paymentOrder"];
}

- (void)tapAppraiseView {
    if (self.clickApraiseViewBlock) {
        self.clickApraiseViewBlock();
    }
    [self sa_trackingWithOther_name:@"identifyQueue"];
}
- (void)tapRecycleBtnView{
    //回收队列点击
    if (self.clickRecycleBlock) {
        self.clickRecycleBlock();
    }
    [self sa_trackingWithOther_name:@"recyclingQueue"];
}
- (void)tapWaitRecycleBtnView{
    //待回收
    JHRecycleOrderPageController * vc = [[JHRecycleOrderPageController alloc] init];
    vc.selectIndex = 1;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    [self sa_trackingWithOther_name:@"waitRecycling"];
    
}
- (void)tapCustomizeBtnView {
    //定制队列点击
    if (self.clickCustomizeBlock) {
        self.clickCustomizeBlock();
    }
    [self sa_trackingWithOther_name:@"customQueue"];
}

- (void)showOrderList:(UIButton *)btn {
    [self showOrderListFromSource:@""]; //暂时没有定义来源
}

- (void)showOrderListFromSource:(NSString *)source {
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    
    self.orderListView.isAndience = YES;

    //关闭拉流
    if ( [self.viewController isKindOfClass: [NTESAudienceLiveViewController class]]) {
        NTESAudienceLiveViewController * vc=(NTESAudienceLiveViewController*)self.viewController;
        vc.needShutDown=YES;
    }
    JHNewOrderListViewController * orderList = [[JHNewOrderListViewController alloc] init];
    orderList.currentIndex = 1;
    [[JHRootController currentViewController].navigationController pushViewController:orderList animated:YES];

    [JHGrowingIO trackEventId:JHTracklive_right_orderunpaybtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
}


- (void)onClose:(id)sender
{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(onClosePlaying)]) {
        [self.delegate onClosePlaying];
    }
    
}

#pragma mark - Notification
- (void)sendOrderKeyBoard:(NSNotification *)noti {
    isSendOrderKeyBoard = [noti.object boolValue];
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if (isSendOrderKeyBoard) {
        
    }else {
        if ([self.delegate respondsToSelector:@selector(keyBoardWillShow:)]) {
            NSDictionary *info = notification.userInfo;
            [self.delegate keyBoardWillShow:[info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height];
            
        }
        NSDictionary *info = notification.userInfo;
        _keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        [self layoutSubviews];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (isSendOrderKeyBoard) {
        
    }else {
        if ([self.delegate respondsToSelector:@selector(keyBoardWillHidden)]) {
            [self.delegate keyBoardWillHidden];
        }
        _keyBoradHeight = 0;
        [self layoutSubviews];
    }
}

- (void)adjustViewPosition
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat bottomH = 49;
    CGFloat bottomY = ScreenH-UI.bottomSafeAreaHeight-bottomH;
    if ([self.channel.channelCategory isEqualToString: JHRoomTypeNameRestoreStone]) {
        if (self.resaleHeight>0.0) {
            bottomY = bottomY-self.resaleHeight+UI.bottomSafeAreaHeight;
        } else {
            bottomY = bottomY-self.resaleHeight;
        }
    }
    _bottomBar.frame = CGRectMake(0, bottomY,ScreenW,bottomH);
    self.auctionWeb.bottom = self.bottomBar.top;
    [self setChatViewLayout];
    CGFloat rightArrowButtonHeight = 16;
    CGFloat padding = 20.f;
    CGFloat delta = self.chatView.tableView.contentOffset.y;
    CGFloat bottom  = (delta < 0) ? self.chatView.top - delta : self.chatView.top;
    self.presentView.bottom = bottom - padding;
    
    self.likeView.bottom = self.bottomBar.top+10;
    self.likeView.right  = self.width - 10.f;
    
    self.glView.size = self.size;
    
    self.netStatusView.centerX = self.width * .5f;
    self.netStatusView.top = 70.f;
    
    self.actionView.left = 0;
    self.actionView.bottom = self.height - 10.f;
    self.actionView.width = self.width;
    
    self.infoView.left = 15;
    self.infoView.top = 10+UI.bottomSafeAreaHeight;
    self.infoView.height = 40;

    _closeRoomButton.frame = CGRectMake(ScreenW-50, UI.bottomSafeAreaHeight+10, 40, 40);
    
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        self.restorePriceBtn.left = 15;
        self.restorePriceBtn.top = self.infoView.bottom+5;
        self.restorePriceBtn.height = 27;
        self.restorePriceBtn.width = [JHUIFactory getWidthWithString:self.restorePriceBtn.titleLabel.text font:self.restorePriceBtn.titleLabel.font height:27]+40;
        self.restorePriceBtn.hidden = NO;
        
    } else {
        self.restorePriceBtn.left = 15;
        self.restorePriceBtn.top = self.infoView.bottom+5;
        self.restorePriceBtn.height = 27;
        self.restorePriceBtn.width = 0;
        self.restorePriceBtn.hidden = YES;
    }
    //统一隐藏不显示
    self.restorePriceBtn.hidden = YES;
//    if (_appraiseScopeLabel) {
//        self.safeTipsBtn.top = _appraiseScopeLabel.bottom;
//    }else{
//        self.safeTipsBtn.top = self.infoView.bottom+10;
//    }
//    //从左向右：1
//    self.safeTipsBtn.height = rightArrowButtonHeight;
//    self.safeTipsBtn.left = 15;
//    
//    //评价跟购物攻略调换位置
//    //从左向右：2
//    self.commentBtn.left = self.safeTipsBtn.right + (self.safeTipsBtn.hidden?0:10);//self.restorePriceBtn.right + (self.restorePriceBtn.hidden?0:10);
//    self.commentBtn.top = self.safeTipsBtn.top;//self.safeTipsBtn.bottom+10;
//    self.commentBtn.height = rightArrowButtonHeight;
//    //从左向右：3
////        self.saleGuideBtn.left = self.commentBtn.right + 10;
//    self.saleGuideBtn.top = self.commentBtn.top;//self.safeTipsBtn.bottom+10;
//    self.saleGuideBtn.height = rightArrowButtonHeight;
    
    if ([self.channel.channelCategory isEqualToString: JHRoomTypeNameRestoreStone]) {
        self.commentBtn.hidden = YES;
//        self.saleGuideBtn.left = self.commentBtn.left;
        [self.commentBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@16);
            make.top.equalTo(@8);
            make.left.mas_equalTo(self.safeTipsBtn.mas_right).offset(0);
            make.width.equalTo(@0);
        }];
    }else {
        //        self.commentBtn.hidden = NO;
//        self.saleGuideBtn.left = self.commentBtn.right+10;
    }
//
//    //从左向右：4
//    if (self.saleGuideBtn.hidden) {
//        self.riskTestBtn.left = self.commentBtn.right+10;
//    }else{
//        self.riskTestBtn.left = self.saleGuideBtn.right+10;
//    }
//
//    self.riskTestBtn.top = self.saleGuideBtn.top;
//    self.riskTestBtn.height = rightArrowButtonHeight;
//
//    if (self.riskTestBtn.hidden && self.saleGuideBtn.hidden && self.commentBtn.hidden && self.safeTipsBtn) {
//        if (_appraiseScopeLabel) {
//            self.saleGuideBtn.top = _appraiseScopeLabel.bottom;
//            self.saleGuideBtn.height = 0;
//        }else{
//            self.saleGuideBtn.top = self.infoView.bottom;
//            self.saleGuideBtn.height = 0;
//        }
//
//    }else{
//        self.saleGuideBtn.top = self.infoView.bottom + 10;
//        self.saleGuideBtn.height = rightArrowButtonHeight;
//    }

}

#pragma mark - NTESLiveActionViewDelegate

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender
{
    switch (type) {
        case NTESLiveActionTypeQuality:
            if (!_hdAlert) {
                [self addSubview: self.hdAlert];
            }
            [self.hdAlert showAlert];
            
            return;
            
            break;
        case NTESLiveActionTypeLike:
             {
                self.ownLikeCount++;
                [self fireLike];
                 [self sa_trackingWithOther_name:@"praise"];
            }
            break;
            
        case NTESLiveActionTypeChat:
        {
            self.textInputView.hidden = NO;
            UITextView *textview = (UITextView*)[self getTextViewFromTextInputView];
            [textview becomeFirstResponder];
        }
            break;
            
        case NTESLiveActionTypeMoveUp:
        {
            [self actionViewMoveToggle];
        }
            break;
            
        case NTESLiveActionTypeZoom:
        {
            self.cameraZoomView.hidden = !self.cameraZoomView.hidden;
            UIButton * button = (UIButton *)sender;
            [button setImage:[UIImage imageNamed:self.cameraZoomView.hidden ? @"icon_camera_zoom_n" :@"icon_camera_zoom_on_n"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.cameraZoomView.hidden ? @"icon_camera_zoom_p" :@"icon_camera_zoom_on_p"] forState:UIControlStateHighlighted];
        }
            break;
        case NTESLiveActionTypeSendStarPlayTips:
            [[JHSendLivingTipManeger shareManager] sendLivingTipManeger:self andChannelLocalId:self.channel.channelLocalId];
            break;
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:type sender:sender];
    }
}

#pragma mark - NTESTextInputViewDelegate
- (void)didSendText:(NSString *)text
{
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:text];
    }
     
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setValue:self.channel.channelLocalId forKey:@"room_id"];
    
    if([self.channel.channelCategory isEqualToString:@"restoreStone"])
    {
        [JHUserStatistics noteEventType:kUPEventTypeReSaleLiveRoomSpeak params:params];
    }
    else if ([self.channel.channelType isEqualToString:@"sell"])
    {
        [params setValue:self.groupId forKey:@"group1_id"];
        [JHUserStatistics noteEventType:kUPEventTypeShoppingLiveRoomSpeak params:params];
    }
    else if([self.channel.channelType isEqualToString:@"appraise"])
    {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyLiveRoomSpeak params:params];
    }
    
    ///369神策埋点:直播间互动_用户评论
    [self sa_tracking:@"zbjhdComment" content:text];
}

//神策埋点
- (void)sa_tracking:(NSString *)event content:(NSString *)content {
    JHTrackingAudienceLiveRoomModel * model = [JHTrackingAudienceLiveRoomModel new];
    model.event = event;
    model.comment_content = content;
    model.operation_type = @"主动发言";
    [model transitionWithModel:self.channel needFollowStatus:NO];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if([model.event isEqualToString:@"zbjhdComment"]) {
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

- (void)willChangeHeight:(CGFloat)height
{
    [self adjustViewPosition];
}

#pragma mark - NTESLiveBypassViewDelegate
- (void)didConfirmExitBypassWithUid:(NSString *)uid
{
    if ([self.delegate respondsToSelector:@selector(onCloseBypassingWithUid:)]) {
        [self.delegate onCloseBypassingWithUid:uid];
    }
}

- (void)switchMainScreenWithUid:(NSString *)uid {
    if ([self.delegate respondsToSelector:@selector(onSwitchMainScreenWithUid:)]) {
        [self.delegate onSwitchMainScreenWithUid:uid];
    }
}

#pragma mark - NTESLiveChatViewDelegate
- (void)onTapChatView:(CGPoint)point {
    if ([self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
    }
}

- (void)onClickeCellWithModel:(NTESMessageModel *)model {
    if ([self.delegate respondsToSelector:@selector(onShowInfoWithModel:)]) {
        [self.delegate onShowInfoWithModel:model];
    }
}

#pragma mark - NTESTimerHolderDelegate
- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    __weak typeof(self) wself = self;
    DDLogInfo(@"start refresh chatroom info");
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomInfo:self.roomId completion:^(NSError *error, NIMChatroom *chatroom) {
        if (!error) {
            DDLogInfo(@"refresh chatroom info OK");
            [wself.infoView refreshWithChatroom:chatroom];
        }else{
            DDLogInfo(@"refresh chatroom info error : %@",error);
        }
    }];
}

#pragma mark - Private
- (UIView *)getTextViewFromTextInputView
{
    UITextView *view = (UITextView *)self.textInputView.textViewnew;
    return view;
}

- (void)switchToWaitingUI
{
    DDLogInfo(@"switch to waiting UI");

    [self switchToLinkingUI];
    [self cleanBypassUI];
    [self updateUserOnMic];
}

- (void)switchToPlayingUI
{
    DDLogInfo(@"switch to playing UI");
    self.coverView.hidden = YES;
    self.textInputView.hidden = YES;
    NIMChatroom *room = [[NTESLiveManager sharedInstance] roomInfo:self.roomId];
    if (!room) {
        DDLogInfo(@"chat room has not entered, ignore show playing UI");
        return;
    }
    //    self.infoView.hidden = NO;
    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.netStatusView.hidden = YES;
    
    //更新bypass view
    [self refreshBypassUI];
    
    self.glView.hidden = YES;
    if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
        [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeBeautify disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeQuality disable:YES];
    }
    self.actionView.userInteractionEnabled = YES;
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:NO];
    if (isBackLook) {
        self.chatView.hidden = YES;
    }
}

- (void)switchToLinkingUI
{
    DDLogInfo(@"switch to Linking UI");
    
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusLinking];
    self.coverView.hidden = NO;
}

- (void)switchToEndUI
{
    [self makeUpEndPage];
}

- (void)cleanBypassUI {
    [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"--zgn-- 移除bypass view:[%@]", obj.uid);
        [obj removeFromSuperview];
    }];
    [_bypassViews removeAllObjects];
}


- (void)refreshBypassUIWithConnector:(NTESMicConnector *)connector {
    [self refreshBypassUI];
    
    NTESLiveBypassView *bypassView = [self bypassViewWithUid:connector.uid];
    NTESLiveBypassViewStatus status;
    if ([connector.uid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        status = connector.type == NIMNetCallMediaTypeAudio? NTESLiveBypassViewStatusLocalAudio: NTESLiveBypassViewStatusLocalVideo;
    } else {
        status = connector.type == NIMNetCallMediaTypeAudio ? NTESLiveBypassViewStatusStreamingAudio : NTESLiveBypassViewStatusStreamingVideo;
    }
    [bypassView refresh:connector status:status];
}

- (void)refreshBypassUI {
    
    if ([_delegate isPlayerPlaying]) {
        [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_bypassViews removeAllObjects];
        return;
    } else {
        __block NSMutableIndexSet *delIndex = [NSMutableIndexSet indexSet];
        NSMutableArray *connectorsOnMic = [NTESLiveManager sharedInstance].connectorsOnMic;
        __weak typeof(self) weakSelf = self;
        [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __block BOOL isExist = NO;
            [connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector *_Nonnull d_obj, NSUInteger d_idx, BOOL * _Nonnull d_stop) {
                if ([obj.uid isEqualToString:d_obj.uid]) {
                    isExist = YES;
                    *d_stop = YES;
                }
            }];
            if (!isExist) {
                NSLog(@"--zgn-- 移除bypass view:[%@]", obj.uid);
                [delIndex addIndex:idx];
                [obj removeFromSuperview];
            }
        }];
        
        if (delIndex.count != 0) {
            [_bypassViews removeObjectsAtIndexes:delIndex];
        }
        
        [connectorsOnMic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [weakSelf addBypassViewWithConnector:obj];
        }];
    }
    
    [self updateUserOnMic];
}

- (void)switchToBypassStreamingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypass streaming UI connector id %@",connector.uid);
    
    self.infoView.hidden = NO;
    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.textInputView.hidden = NO;
    self.netStatusView.hidden = NO;
    
    NTESLiveBypassViewStatus status = connector.type == NIMNetCallMediaTypeAudio? NTESLiveBypassViewStatusStreamingAudio: NTESLiveBypassViewStatusStreamingVideo;
    
    [self refreshBypassUI];
    NTESLiveBypassView *bypassView = [self bypassViewWithUid:connector.uid];
    [bypassView refresh:connector status:status];
    
    //[self.bypassView refresh:connector status:status];
    self.glView.hidden = YES;
    [self updateUserOnMic];
}

- (void)switchToBypassingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypassing UI connector id %@",connector.uid);
    
    self.infoView.hidden = NO;
    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.textInputView.hidden = NO;
    self.netStatusView.hidden = YES;
    
    [self refreshBypassUIWithConnector:connector];
    //[self.bypassView refresh:connector status:status];
    self.glView.hidden = NO;
    [self.actionView setActionType:NTESLiveActionTypeCamera disable: [NTESLiveManager sharedInstance].bypassType == NIMNetCallMediaTypeAudio];
    [self.actionView setActionType:NTESLiveActionTypeBeautify disable:[NTESLiveManager sharedInstance].bypassType == NIMNetCallMediaTypeAudio];
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:YES];
    [self updateUserOnMic];
}

- (void)switchToBypassLoadingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypass loading UI connector id %@",connector.uid);
    
    [self refreshBypassUI];
    NTESLiveBypassView *bypassView = [self bypassViewWithUid:connector.uid];
    [bypassView refresh:connector status:NTESLiveBypassViewStatusLoading];
    //    [self.bypassView refresh:connector status:NTESLiveBypassViewStatusLoading];
    [self setNeedsLayout];
}
#pragma mark - UI
- (void)setup
{
    self.topBtnArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    [self addSubview:self.playControlView];
    [self addSubview:self.likeView];
    [self addSubview:self.presentView];
    [self addSubview:self.systemMsgAnimationView];
    [self addSubview:self.comeInAnimationView];
    
    [self addSubview:self.chatView];
    [self addSubview:self.auctionWeb];
    [self addSubview:self.anchorActionView];
    [self addSubview:self.saleAnchorActionView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.infoView];
    [self addSubview:self.textInputView];
    [self addSubview:self.replyMessageView];
    
    [self addSubview:self.appraiseScopeLabel];
    
    [self addSubview:self.secondFloorView];
    [self.secondFloorView addSubview:self.safeTipsBtn];
    [self.secondFloorView addSubview:self.commentBtn];
    [self.secondFloorView addSubview:self.saleGuideBtn];
    [self.secondFloorView addSubview:self.riskTestBtn];
    
    [self addSubview:self.liveRoomListView];
    self.liveRoomListView.hidden = YES;
    self.liveRoomListView.layer.masksToBounds = YES;
    self.liveRoomListView.layer.cornerRadius = 4.0;
    
    //提前添加 防止后面约束崩溃
//    [self addSubview:self.orderBtnView];
//    [self addSubview:self.jadeiteListBtn];
//    [self addSubview:self.customizeBtnView];
    
    [self.appraiseScopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.top.equalTo(self.infoView.mas_bottom).with.offset(0);
    }];
    
    [self.secondFloorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@26);
        make.width.mas_equalTo(kScreenWidth);
        make.left.equalTo(@0);
        make.top.equalTo(self.appraiseScopeLabel.mas_bottom).with.offset(0);
    }];
    
    [self addSubview:self.thirdFloorView];
    [self.thirdFloorView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@60);
        make.width.mas_equalTo(kScreenWidth);
        make.left.equalTo(@0);
        make.top.equalTo(self.secondFloorView.mas_bottom).with.offset(0);
    }];
    
    
    [self.safeTipsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.left.equalTo(@15);
        make.top.equalTo(@8);
    }];

    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.top.equalTo(@8);
        make.left.mas_equalTo(self.safeTipsBtn.mas_right).offset(10);
        
    }];
  
    [self.saleGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.top.equalTo(@8);
        make.left.mas_equalTo(self.commentBtn.mas_right).offset(10);
        
    }];
    [self.riskTestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@16);
        make.top.equalTo(@8);
        make.left.mas_equalTo(self.saleGuideBtn.mas_right).offset(10);
        
    }];
    
//    [self.orderBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@16);
//        make.width.equalTo(@0);
//        make.left.equalTo(self.jadeiteListBtn.mas_right).offset(0);
//        make.top.equalTo(self.saleGuideBtn.mas_bottom).with.offset(15);
//    }];
//    [self.praiseBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@16);
//        make.width.equalTo(@0);
//        make.left.equalTo(self.orderBtnView.mas_right).with.offset(0);
//        make.top.equalTo(self.saleGuideBtn.mas_bottom).with.offset(15);
//    }];
//    [self.customizeBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@16);
//        make.width.equalTo(@0);
//        make.left.equalTo(self.praiseBtnView.mas_right).with.offset(0);
//        make.top.equalTo(self.saleGuideBtn.mas_bottom).with.offset(15);
//    }];
    
    if (self.channel.isAssistant) {
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
            [self addSubview:self.stoneOrderBtn];
            self.stoneOrderBtn.hidden = NO;
        }
    }
    //    去掉土豪榜
    //    [self setTuhaoBtn];
    [self adjustViewPosition];
    
    //原石回血按钮
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
//        [self addSubview:self.stoneRestoreBtn];
//        [self.stoneRestoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(16);
//            make.width.mas_equalTo(70);
//            make.left.mas_equalTo(15);
//            make.top.mas_equalTo(self.saleGuideBtn.mas_bottom).offset(45);
//        }];
        self.stoneRestoreBtn.size = CGSizeMake(70, 18);
        [self topBtnViewAddView:self.stoneRestoreBtn andPosition:6];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userEnterRoom:) name:NotificationNameEnterUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOrderKeyBoard:) name:NotificationNameSendOrderKeyBoard object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recycleGoodsNumChange:) name:@"RecycleGoodsNumChangeNotification" object:nil];
    [self.chatView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.playControlView addObserver:self forKeyPath:@"playControlHidden" options:NSKeyValueObservingOptionNew context:nil];
    
    
    [self.replyMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.bottom.equalTo(self.bottomBar.mas_top).offset(4);
        make.size.mas_equalTo(CGSizeMake(154, 192));
    }];

    [JHLiveRoomPKCategoryModel requestPKCategory:self.channel.channelId successBlock:^(NSString * _Nonnull category,NSString * _Nonnull rankName) {
        if (category.length>0) {
            self.jadeiteListStr = category;
            self.rankName = rankName;
            [self creatjadeiteListBtn];
        }
    }];
    
    if ([JHLiveActivityManager sharedManager].countDown > 0) {
        [self addSubview:self.countdownView];
        [self.countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.thirdFloorView.mas_bottom).offset(0);
            make.height.mas_equalTo(16);
            make.left.mas_equalTo(15);
        }];
    }
    
    @weakify(self)
    [RACObserve([JHLiveActivityManager sharedManager], countDownText) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *text = x;
        if (text.length <= 0) {
            self.countdownView.hidden = true;
        }else {
            self.countdownView.hidden = false;
            self.countdownView.text = text;
        }
    }];
    [RACObserve(self.thirdFloorView, height) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSUInteger height = [x unsignedIntegerValue];
        [self.thirdFloorView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        if (self.countdownView.superview == nil) return;
        if (height > 0) {
            [self.countdownView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.thirdFloorView.mas_bottom).offset(-5);
            }];
        }else {
            [self.countdownView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.thirdFloorView.mas_bottom).offset(8);
            }];
        }
    }];
}

-(void)recycleGoodsNumChange:(NSNotification *)noti
{
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        NSString *changeStatus = noti.object;
        if ([changeStatus boolValue]) {
            self.channel.awaitNum = self.channel.awaitNum + 1;
        }else{
            self.channel.awaitNum = self.channel.awaitNum - 1;
        }
        [self updatewaitRecycleBtnViewWithWaitNum:self.channel.awaitNum];
    });
}

- (void)setTuhaoBtn {
    if (![JHLiveRoomStatus isLiveRoomType:JHLiveRoomTypeSell channelType:self.channel.channelType]) {
        return;
    }
    UIButton *btn = [JHUIFactory createThemeBtnWithTitle:@"" cornerRadius:0 target:self action:@selector(tuhaoSortAction)];
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"btn_img_tuhao"] forState:UIControlStateNormal];
    [self addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-10);
        make.top.offset(UI.bottomSafeAreaHeight+10+40+10);
    }];
}

- (void)tuhaoSortAction {
    JHWebViewController *vc = [JHWebViewController new];
    vc.urlString = LiveRoomSortURL(self.channel.channelLocalId);
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)showFollowBubble{
    
    if (!self.anchorInfoModel.isFollow) {
         [self addSubview:self.followImage];
         [self.followImage addFollowBubbleByView:self.infoView];
        
    }
}

-(void)showBubbleView:(JHBubbleViewType)bubbleType{
    
    if (bubbleType != JHBubbleViewTypeComment){
        if (isBackLook) {
            return;
        }
    }
    
    JHBubbleView * bubble = [[JHBubbleView alloc]init];
    [self addSubview:bubble];
    
    switch (bubbleType) {
        case JHBubbleViewTypeShare:{
            if (self.resaleLiveRoomTabView.height>self.resaleHeight) {
                return;
            }
            [bubble setTitle:@"精彩要与好友一起分享" andArrowDirection:JHBubbleViewArrowDirectionenBottomCenter];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomBar.mas_top).offset(3);
                make.centerX.equalTo(self.bottomBar.shareBtn);
            }];
        }
            break;
        case JHBubbleViewTypeLight:{
            [bubble setTitle:@"手电筒" andArrowDirection:JHBubbleViewArrowDirectionenBottomRight];
            bubble.showCancleBtn=YES;
            bubble.tag=JHBubbleViewTypeLight;
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomBar.mas_top).offset(-65);
                make.right.equalTo(self.bottomBar).offset(-12);
            }];
        }
            break;
        case JHBubbleViewTypeFreeGift:{
            
            [bubble setTitle:@"有免费礼物可以送给主播" andArrowDirection:JHBubbleViewArrowDirectionenBottomCenter];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomBar.mas_top).offset(3);
                make.centerX.equalTo(self.bottomBar.giftBtn);
            }];
        }
            break;
        case JHBubbleViewTypeComment:{
            [bubble setTitle:@"下单前看看大家怎么说" andArrowDirection:JHBubbleViewArrowDirectionenTopCenter];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.commentBtn.mas_bottom).offset(3);
                make.centerX.equalTo(self.commentBtn);
            }];
        }
            break;
            
        case JHBubbleViewTypeFollow:{
            if (self.anchorInfoModel.isFollow) {
                return;
            }
            [bubble setTitle:@"点击关注不错过Ta的直播哟" andArrowDirection:JHBubbleViewArrowDirectionenTopCenter];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoView.mas_bottom).offset(-5);
                make.centerX.equalTo(self.infoView.mas_trailing).offset(-30);
            }];
        }
            break;
            
        case JHBubbleViewTypeWaitMic:{
            
            bubble.tag=JHBubbleViewTypeWaitMic;
            bubble.bubbleUserInteractionEnabled=NO;
            [bubble setTitle:@"排队中,请勿长时间退出" andArrowDirection:JHBubbleViewArrowDirectionenBottomCenter];
            [bubble mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.bottomBar.mas_top).offset(3);
                make.centerX.equalTo(self.bottomBar.appraiseBtn);
            }];
        }
            break;
            
            
        default:
            break;
    }
    if (bubbleType!=JHBubbleViewTypeLight&&bubbleType!=JHBubbleViewTypeWaitMic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bubble removeFromSuperview];
        });
    }
}
-(void)removeBubbleView:(JHBubbleViewType)tpye{
    
    for (UIView * view  in self.subviews) {
        if ([view isKindOfClass:[JHBubbleView class]]) {
            if (view.tag==tpye) {
                [view removeFromSuperview];
                break;
            }
        }
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"frame"]) {
        [self layoutIfNeeded];
        
    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        CGFloat padding = 20.f;
        CGFloat bottom = (point.y < 0) ? self.chatView.top - point.y : self.chatView.top;
        self.presentView.bottom = bottom - padding;
    }

}

- (void)setChatViewLayout {
    if (_keyBoradHeight)
    {
        self.textInputView.bottom = self.height - _keyBoradHeight;
        self.chatView.bottom = self.textInputView.top;//公屏不上移
//        self.chatView.bottom = self.textInputView.top-(self.replyMessageView.isShow ? 44 : 0);//公屏上移
        [self bringSubviewToFront:self.textInputView];
//        [self bringSubviewToFront:self.replyMessageView];
        
    }
    else
    {
        self.textInputView.top = self.height+44;
        if (_leftCustomizeOrder) {
            _chatView.bottom = self.bottomBar.top-10-self.auctionWeb.height - 100;
        }else{
            _chatView.bottom = self.bottomBar.top-10-self.auctionWeb.height;
        }
    }
    
    self.comeInAnimationView.bottom = self.chatView.top-50;
    self.jhpresentView.bottom = self.chatView.top-50-50;
    UITextView *textView = (UITextView *)[self getTextViewFromTextInputView];
    self.textInputView.hidden = !textView.isFirstResponder;
}

-(void)actionViewMoveToggle
{
    _isActionViewMoveUp = !_isActionViewMoveUp;
    CGFloat rowHeight = 35;
    [self.actionView firstLineViewMoveToggle:_isActionViewMoveUp];
    if (_isActionViewMoveUp) {
        [UIView animateWithDuration:0.5 animations:^{
            _chatView.bottom = self.height - 3 * rowHeight - 30;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            _chatView.bottom = self.height - rowHeight - 20;
        }];
    }
}

- (void)updateUserOnMic
{
    NSMutableArray *nicks = [NSMutableArray array];
    [[NTESLiveManager sharedInstance].connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *nickString = (obj.nick.length == 0 ? @"null" : obj.nick);
        [nicks insertObject:nickString atIndex:0];
    }];
}

- (void)showCommentView {
    [JHGrowingIO trackEventId:JHTracklive_maijiapingjia variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    if ([self.delegate respondsToSelector:@selector(onShowCommentListView:)]) {
        [self.delegate onShowCommentListView:self.commentBtn];
    }
    
}

- (void)showSaleGuide {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/zhinan.html");
    NSString *tracklive_gonglve = JHTracklive_gouwugonglue;
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        vc.urlString = StoneRestoreBuyRuleURL;
    }
    if (_type == JHAudienceUserRoleTypeCustomize || _type == JHAudienceUserRoleTypeCustomizeAssistant) {
        //定制攻略
        vc.urlString = H5_BASE_STRING(@"/jianhuo/app/customization.html");
        tracklive_gonglve = JHTracklive_dz_gl_click;;
    }else if(_type == JHAudienceUserRoleTypeRecycle || _type == JHAudienceUserRoleTypeRecycleAssistant){
        //回收
        vc.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/strategy.html");
    }
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [JHGrowingIO trackEventId:tracklive_gonglve variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
}

- (void)showSaleSafeTips {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/qualityControlLand/qualityControlLand.html");
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [JHGrowingIO trackEventId:JHTrackChannelLocalld_mind_rest_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    [self sa_trackingWithOther_name:@"goodSource"];
}
- (void)sa_trackingWithOther_name:(NSString *)other_name{
    if(_type == JHAudienceUserRoleTypeRecycle){
        [JHTracking trackEvent:@"clickOther" property:@{@"channel_local_id":self.channel.channelLocalId,@"page_position":@"recyclingLive",@"other_name":other_name}];
    }
}
- (void)showReguler {
    [JHGrowingIO trackEventId:JHTracklive_tuihuanhuo variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/refundRule.html");
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)stoneRestoreBtnAction{
    
    JHStoneResaleViewController *vc = [[JHStoneResaleViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - NTESLiveCoverViewDelegate
- (void)didPressBackButton
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - set

- (void)setCommentCount:(NSString *)commentCount {
    if([commentCount integerValue] > 9999)
        [self.commentBtn setTitle:@"评价 9999+" forState:UIControlStateNormal];
    else

        [self.commentBtn setTitle:[NSString stringWithFormat:@"评价 %@",[NSString isBlankString:commentCount]?@"0":commentCount] forState:UIControlStateNormal];
    
}

- (void)setCanAuction:(NSInteger)canAuction {
    _canAuction = canAuction;
    self.bottomBar.canAuction = canAuction;
}

- (void)setType:(JHAudienceUserRoleType)type {
    
    //TODO :因为新增加了两种类型 如果用到9和10  需要检查这页面type是否完全枚举
    //可以把涉及到主播的判断去掉了
    _type = type;
    
    self.bottomBar.channel = self.channel;
    _saleAnchorActionView.hidden = YES;
    if (_type >= 1) {
        self.infoView.platImage.hidden = YES;
        _anchorActionView.hidden = YES;
        if ( _type == 2) {
            _saleAnchorActionView.hidden = NO;
            self.bottomBar.roleType = JHLiveRoleSaleHelper;
            
        }else if(_type == JHAudienceUserRoleTypeCustomize){
            self.bottomBar.roleType = JHLiveRoleCustomizeAndience;
        }else if(_type == JHAudienceUserRoleTypeCustomizeAssistant){
            self.bottomBar.roleType = JHLiveRoleCustomizeHelper;
            self.bottomBar.hidden = YES;
            self.customBottomBar.frame = CGRectMake(0,ScreenH-UI.bottomSafeAreaHeight-49 ,ScreenW,49);
            [self addSubview:self.customBottomBar];
        }else if(_type == JHAudienceUserRoleTypeRecycle){
            self.bottomBar.roleType = JHLiveRoleRecycleAndience;
            //appraiseScopeLabel

            [self.appraiseScopeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@26);
            }];
        }else if(_type == JHAudienceUserRoleTypeRecycleAssistant){
//            self.bottomBar.roleType = JHLiveRoleRecycleHelper;
            self.bottomBar.hidden = YES;
            self.customBottomBar.frame = CGRectMake(0,ScreenH-UI.bottomSafeAreaHeight-49 ,ScreenW,49);
            [self addSubview:self.customBottomBar];
        } else {
            self.bottomBar.roleType = JHLiveRoleSaleAndience;
            [self addSubview:self.customizeList];
            self.customizeList.channelLocalId = self.channel.channelLocalId;
            [self.customizeList mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.infoView.mas_bottom).offset(60);
                make.left.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(66, 94));
            }];
        }
    }else if(_type == 0){
        self.bottomBar.roleType = JHLiveRoleAudience;
        
        [self.appraiseScopeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@26);
        }];
    }
    
    if (_type != 0  &&
        [CommHelp isFirstForName:@"isFirstInSaleLiveRoom"] &&
        [self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone] &&
        self.stoneChannel.channelStatus == 2) {
        if ([CommHelp isFirstForName:@"isFirstShowStoneGuide"])  {
            [JHStoneLiveWindowGuideView showGuideView];
        }
    }
    
    if (_type == 0) {
        self.infoView.platImage.hidden = NO;
    }else {
        
        self.saleGuideBtn.hidden = NO;
        self.safeTipsBtn.hidden = NO;
        self.commentBtn.hidden = NO;
        
    }
    
    [self reloadAnctionWeb];
    
    
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
    {
        self.bottomBar.isResaleRoom = YES;
        self.restorePriceBtn.hidden = NO;
        [self layoutSubviews];
        [self.saleGuideBtn setTitle:@"回血攻略" forState:UIControlStateNormal];
        
        if (_type == 1 && self.channel.isAssistant == 0) {
            [self onAndienceTapResaleAction];
        }
    }
    if (type == JHAudienceUserRoleTypeCustomize || type == JHAudienceUserRoleTypeCustomizeAssistant) {
        [self.saleGuideBtn setTitle:@"定制攻略" forState:UIControlStateNormal];
    }
    if (type == JHAudienceUserRoleTypeRecycle || type == JHAudienceUserRoleTypeRecycleAssistant) {
        [self.saleGuideBtn setTitle:@"回收攻略" forState:UIControlStateNormal];
    }
    if ([self.channel.buyGuideShow integerValue] == 1 && [self.saleGuideBtn.currentTitle containsString:@"购物攻略"] && self.type != JHAudienceUserRoleTypeAppraise && self.type != JHAudienceUserRoleTypeCustomize) {
        self.saleGuideBtn.hidden = YES;
        [self.saleGuideBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@16);
            make.top.equalTo(@8);
            make.left.mas_equalTo(self.commentBtn.mas_right).offset(0);
            make.width.equalTo(@0);
        }];
        [self addSubview:self.saleGuide_NewUserBtn];
        [self.saleGuide_NewUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(52, 48));
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(self.infoView.mas_bottom).offset(96);
        }];
    }else{
        if (self.type == JHAudienceUserRoleTypeAppraise) {
            self.saleGuideBtn.hidden = YES;
        }else{
            self.saleGuideBtn.hidden = NO;
        }
        
    }
    
    [self showTipsGuideView];
}

- (void)setAnchorInfoModel:(JHAnchorInfoModel *)anchorInfoModel {
    _anchorInfoModel = anchorInfoModel;
    _endPageView.model = anchorInfoModel;
    
    self.infoView.isjoinFansClub = self.channel.joinFlag;
    self.infoView.isOpenFansClub = self.channel.isOpen;
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameFollowStatus object:@(anchorInfoModel.isFollow)];
    [self.infoView updateStatus:anchorInfoModel.isFollow];
    NSLog(@"========%@  %@",[UserInfoRequestManager sharedInstance].user.customerId, [NSThread currentThread]);
    if ([[UserInfoRequestManager sharedInstance].user.customerId isEqualToString:anchorInfoModel.customerId]) {
        [_infoView hiddenCareBtn];
        [self updateRoleType:JHLiveRoleAnchor];
    }
    _infoView.hidden = NO;
    
    if (self.type == JHAudienceUserRoleTypeRecycle || self.type == JHAudienceUserRoleTypeAppraise) {
        if ([_anchorInfoModel.tags count] >0) {
            NSString * string = @"  鉴定范围：";
            if (self.type == JHAudienceUserRoleTypeRecycle) {
               string = @"  回收类别：";
           }
            for (int i = 0; i < [_anchorInfoModel.tags count]; ++i) {
                string = [string  stringByAppendingString:[NSString stringWithFormat:@"%@",[_anchorInfoModel.tags[i] objectForKey:@"tagName"]]];
                if (i != [_anchorInfoModel.tags count]-1) {
                    string = [string stringByAppendingString:@" 、"];
                }
            }
            [_appraiseScopeLabel setLabelText:string];
        }else{
            [_appraiseScopeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
    }
    
}
- (void)setCareDelegate:(id<JHLiveEndViewDelegate>)careDelegate {
    _careDelegate = careDelegate;
    self.infoView.delegate = careDelegate;
}

-(void)setLinkNum:(NSInteger)linkNum{
    
    [_bottomBar setLinkNum:linkNum];
}
-(void)setLikeCount:(NSInteger)likeCount{
    
    _likeCount=likeCount;
    self.bottomBar.likeCount =likeCount;
}

#pragma mark - Get
- (JHDotButtonView *)stoneOrderBtn {
    //TODO:yaoyao主播原石订单
    
    if (!_stoneOrderBtn) {
        _stoneOrderBtn = [[JHDotButtonView alloc] init];
        _stoneOrderBtn.frame = CGRectMake(ScreenW-80, 0, 80, 33);
        _stoneOrderBtn.centerY = ScreenH-360-UI.bottomSafeAreaHeight;
        _stoneOrderBtn.type = 2;
        [_stoneOrderBtn.button setTitle:@" 原石订单" forState:UIControlStateNormal];
        [_stoneOrderBtn.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _stoneOrderBtn.button.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        [_stoneOrderBtn addTarget:self action:@selector(stoneOrderList) forControlEvents:UIControlEventTouchUpInside];
        _stoneOrderBtn.hidden = YES;
        _stoneOrderBtn.dotLabel.text = @"10";
        
    }
    return _stoneOrderBtn;
}

- (JHWebView *)auctionWeb {
    if (!_auctionWeb) {
        JHWebView *web = [[JHWebView alloc] init];
        web.bottom = self.bottomBar.top;
        web.height = 0;
        web.left = 0;
        web.width = ScreenW-80;
        JH_WEAK(self)
        web.resetSizeWebView = ^(OpenWebModel * _Nonnull model) {
            JH_STRONG(self)
            self.auctionWeb.bottom = self.bottomBar.top;
            self.auctionWeb.height = model.height;
            [UserInfoRequestManager sharedInstance].showShopwindow = model.height > 10;
            [self setChatViewLayout];
        };
        _auctionWeb = web;
    }
    
    return _auctionWeb;
}

//新人攻略  saleGuide_NewUser
- (UIButton *)saleGuide_NewUserBtn{
    if (!_saleGuide_NewUserBtn) {
        _saleGuide_NewUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saleGuide_NewUserBtn setBackgroundImage:[UIImage imageNamed:@"saleGuide_NewUser"] forState:UIControlStateNormal];
        [_saleGuide_NewUserBtn addTarget:self action:@selector(showSaleGuide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleGuide_NewUserBtn;
}

- (JHLiveScrollLabelView *)appraiseScopeLabel{
    if (!_appraiseScopeLabel) {
        _appraiseScopeLabel = [[JHLiveScrollLabelView alloc] init];
    }
    return _appraiseScopeLabel;
}
- (UIView *)secondFloorView{
    if (!_secondFloorView) {
        _secondFloorView = [[UIView alloc] init];
    }
    return _secondFloorView;
}
- (JHLiveRoomTopTagsView *)thirdFloorView{
    if (!_thirdFloorView) {
        _thirdFloorView = [[JHLiveRoomTopTagsView alloc] init];
    }
    return _thirdFloorView;
}
- (JHRightArrowBtn *)safeTipsBtn {
    if (!_safeTipsBtn) {
        _safeTipsBtn = [[JHRightArrowBtn alloc] init];
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]){
            _safeTipsBtn.isRoughStone = YES;
        }
        [_safeTipsBtn resetRightArrowStyle:JHRightArrowStyleLight];
        [_safeTipsBtn setTitle:@"    源头好货 | 平台鉴定 | 退换无忧" forState:UIControlStateNormal];
        _safeTipsBtn.hidden = YES;
        [_safeTipsBtn addTarget:self action:@selector(showSaleSafeTips) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"icon_live_sale_auth"];
        [_safeTipsBtn addSubview:icon];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_safeTipsBtn).offset(5);
            make.centerY.equalTo(_safeTipsBtn);
            make.size.mas_equalTo(CGSizeMake(9, 10));
        }];
    }
    return _safeTipsBtn;
}

- (JHRightArrowBtn *)saleGuideBtn {
    if (!_saleGuideBtn) {
        _saleGuideBtn = [[JHRightArrowBtn alloc] init];
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]){
            _saleGuideBtn.isRoughStone = YES;
        }
         [_saleGuideBtn resetRightArrowStyle:JHRightArrowStyleLight];
        [_saleGuideBtn setTitle:@"购物攻略" forState:UIControlStateNormal];
        _saleGuideBtn.hidden = YES;
        [_saleGuideBtn addTarget:self action:@selector(showSaleGuide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleGuideBtn;
}

- (JHRightArrowBtn *)riskTestBtn {
    if (!_riskTestBtn) {
        _riskTestBtn = [[JHRightArrowBtn alloc] init];
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]){
            _riskTestBtn.isRoughStone = YES;
        }
        [_riskTestBtn resetRightArrowStyle:JHRightArrowStyleLight];
        NSString *string = @"收藏等级 未测试";
        [_riskTestBtn setTitle:string forState:UIControlStateNormal];
        _riskTestBtn.hidden = YES;
        [_riskTestBtn addTarget:self action:@selector(reCatuAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _riskTestBtn;
}


- (JHRightArrowBtn *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[JHRightArrowBtn alloc] init];
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]){
            _commentBtn.isRoughStone = YES;
        }
         [_commentBtn resetRightArrowStyle:JHRightArrowStyleLight];
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
        _commentBtn.hidden = YES;
        [_commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _commentBtn;
}

- (UIButton *)restorePriceBtn {
    if (!_restorePriceBtn) {
        _restorePriceBtn = [[UIButton alloc] init];
        [_restorePriceBtn setTitle:@"回血" forState:UIControlStateNormal];
        _restorePriceBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 30, 0, 5);
        [_restorePriceBtn setBackgroundImage:[UIImage imageNamed:@"img_restore_price_bg"] forState:UIControlStateNormal];
        _restorePriceBtn.hidden = YES;
        _restorePriceBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
        [_restorePriceBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _restorePriceBtn;
}
- (JHRightArrowBtn *)stoneRestoreBtn{
    if (!_stoneRestoreBtn) {
        _stoneRestoreBtn = [[JHRightArrowBtn alloc] init];
        [_stoneRestoreBtn setTitle:@"原石回血" forState:UIControlStateNormal];
        [_stoneRestoreBtn resetRightArrowStyle:JHRightArrowStyleMediumFont];
        [_stoneRestoreBtn addTarget:self action:@selector(stoneRestoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stoneRestoreBtn;
}

- (JHLiveRole)roleType {
    _roleType = self.bottomBar.roleType;
    return _roleType;
}

- (JHAutoRunView *)autoRunView {
    if (!_autoRunView) {
        _autoRunView = [[JHAutoRunView alloc] initWithFrame:CGRectMake(0, UI.topSafeAreaHeight, ScreenW, 24)];
        _autoRunView.directionType = LeftType;
        _autoRunView.delegate = self;
        
    }
    return _autoRunView;
}

- (JHLiveRoomGuidanceView *)liveRoomGuidanceView
{
    if (!_liveRoomGuidanceView) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"JHLiveRoomGuidanceView" owner:nil options:nil];
        _liveRoomGuidanceView = arr.firstObject;
        _liveRoomGuidanceView.frame = self.bounds;
    }
    return _liveRoomGuidanceView;
}


- (JHClaimOrderListView *)claimOrderListView {
    if (!_claimOrderListView) {
        MJWeakSelf
        _claimOrderListView = [[JHClaimOrderListView alloc] initWithFrame:self.bounds];
        _claimOrderListView.clickImage = ^(id sender) {
            weakSelf.hidden = YES;
            if ([weakSelf.delegate respondsToSelector:@selector(beginCamaro)]) {
                [weakSelf.delegate beginCamaro];
            }
        };
    }
    return _claimOrderListView;
}

- (JHOrderListView *)orderListView {
    if (!_orderListView) {
        _orderListView = [[JHOrderListView alloc] initWithFrame:self.bounds];
        _orderListView.isAssistant =  self.channel.isAssistant;
        _orderListView.roleType = self.type;
    }
    return _orderListView;
}
- (JHFollowBubbleImage *)followImage {
    if (!_followImage) {
       _followImage = [[JHFollowBubbleImage alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        @weakify(self);
        _followImage.block = ^{
           @strongify(self);
           if (self.careDelegate) {
                [self.careDelegate didPressCareOffButton:self.infoView.careBtn];
           }
          
       };
    }
    return _followImage;
}
- (JHDotButtonView *)havePriceBtn {
    //TODO:yaoyao用户有人出价
    
    if (!_havePriceBtn) {
        _havePriceBtn = [[JHDotButtonView alloc] init];
        _havePriceBtn.type = 0;
        _havePriceBtn.frame = CGRectMake(ScreenW-55, 0, 40, 33);
        _havePriceBtn.centerY = ScreenH/2.+40;
        [_havePriceBtn.button setImage:[UIImage imageNamed:@"icon_have_price_btn"] forState:UIControlStateNormal];
        _havePriceBtn.dotLabel.font = [UIFont fontWithName:kFontLight size:9];
        [_havePriceBtn.button addTarget:self action:@selector(onAndienceTapResaleAction) forControlEvents:UIControlEventTouchUpInside];
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
            _havePriceBtn.hidden = NO;
            
        }else {
            _havePriceBtn.hidden = YES;
            
        }
        _havePriceBtn.dotLabel.text = @"10";
        
    }
    return _havePriceBtn;
}


- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderBtn.backgroundColor = HEXCOLORA(0x000000, 0.8);
        _orderBtn.frame = CGRectMake(ScreenW-55, 0, 55, 33);
        _orderBtn.centerY = ScreenH/2.;
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_orderBtn.bounds byRoundingCorners: UIRectCornerTopLeft  | UIRectCornerBottomLeft cornerRadii:CGSizeMake(16.5, 16.5)];
        CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.path = maskPath.CGPath;
        _orderBtn.layer.mask = maskLayer;
        [_orderBtn setTitle:@" 订单" forState:UIControlStateNormal];
        [_orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_orderBtn addTarget:self action:@selector(showOrderList:) forControlEvents:UIControlEventTouchUpInside];
        _orderBtn.hidden = YES;
        
    }
    return _orderBtn;
}

- (JHDoteNumberLabel *)orderNumLabel {
    if (!_orderNumLabel) {
        _orderNumLabel = [[JHDoteNumberLabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _orderNumLabel.text = @"0";
        _orderNumLabel.hidden = YES;
        
    }
    return _orderNumLabel;
}

- (JHPresentView *)jhpresentView {
    if (!_jhpresentView) {
        _jhpresentView = [[JHPresentView alloc] initWithFrame:CGRectMake(0., ScreenH-260-40-50-40, 0., 41.)];
        
    }
    return _jhpresentView;
    
}

- (JHPresentBoxView *)presentBoxView {
    if (!_presentBoxView) {
        _presentBoxView = [[JHPresentBoxView alloc] initWithFrame:CGRectMake(0., ScreenH, ScreenW, 260.+UI.bottomSafeAreaHeight)];
        MJWeakSelf;
        _presentBoxView.sendPresnt = ^(NTESPresent *sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(sendPresentWithId:)]) {
                [weakSelf.delegate sendPresentWithId:sender.Id];
            }
        };
    }
    return _presentBoxView;
}
- (JHAnchorActionView *)anchorActionView {
    if (!_anchorActionView) {
        _anchorActionView = [[JHAnchorActionView alloc] initWithFrame:CGRectMake(ScreenW-ButtonHeight, ScreenH-UI.bottomSafeAreaHeight-49- (ButtonHeight)*ButtonCount, ButtonHeight+10, (ButtonHeight)*ButtonCount)];
        _anchorActionView.delegate = self;
        _anchorActionView.hidden = YES;
        
    }
    return _anchorActionView;
}

- (  JHSaleAnchorActionView *)saleAnchorActionView {
    if (!_saleAnchorActionView) {
        
        _saleAnchorActionView = [[JHSaleAnchorActionView alloc] init];
        _saleAnchorActionView.delegate = self;
        _saleAnchorActionView.hidden = YES;
        _saleAnchorActionView.clipsToBounds = YES;
        [_saleAnchorActionView resetActionView:2 andShowSendLivingTip:(self.channel.canSendLivingTip == 1)];//
        CGFloat y = ScreenH-(UI.bottomSafeAreaHeight+49+ ButtonHeight*_saleAnchorActionView.btnArray.count);
        _saleAnchorActionView.frame = CGRectMake(ScreenW-ButtonHeight, y, ButtonHeight+10, (ButtonHeight*_saleAnchorActionView.btnArray.count));
    }
    return _saleAnchorActionView;
}

- (JHComeinAnimationView *)comeInAnimationView {
    if (!_comeInAnimationView) {
        _comeInAnimationView = [[JHComeinAnimationView alloc] initWithFrame:CGRectMake(0., ScreenH-260-40-50, 0, 30.)];
        _comeInAnimationView.bottom = self.chatView.top-10;
        _comeInAnimationView.hidden = isBackLook;
    }
    return _comeInAnimationView;
}
- (JHSystemMsgAnimationView *)systemMsgAnimationView {
    if (!_systemMsgAnimationView) {
        _systemMsgAnimationView = [[JHSystemMsgAnimationView alloc] initWithFrame:CGRectMake(0., ScreenH-260-40, 0., 35.)];
        _systemMsgAnimationView.bottom = self.chatView.top-10;
        _systemMsgAnimationView.hidden = isBackLook;
    }
    return _systemMsgAnimationView;
}

- (JHLiveEndPageView *)endPageView
{
    if (!_endPageView) {
        _endPageView = [[NSBundle mainBundle] loadNibNamed:@"JHLiveEndPageView" owner:nil options:nil].firstObject;
        _endPageView.delegate = self.careDelegate;
        _endPageView.tag = 10010;
    }
    return _endPageView;
}

- (JHLivePopAlertViews *)hdAlert {
    if (!_hdAlert) {
        _hdAlert = [[NSBundle mainBundle] loadNibNamed:@"JHLivePopAlertViews" owner:nil options:nil].lastObject;
        
        _hdAlert.qualityDelegate =  (id<NTESVideoQualityViewDelegate>) self.delegate;
        _hdAlert.frame = CGRectMake(0, ScreenH, ScreenW, ScreenW/375.*140.);
        
    }
    return _hdAlert;
}

- (JHLiveBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[NSBundle mainBundle] loadNibNamed:@"JHLiveBottomBar" owner:nil options:nil].firstObject;
        if ([self.channel.canFlashPurchase isEqualToString:@"1"]) {
            _bottomBar.hasShanGou = YES;
        }

        _bottomBar.delegate = self;
    }
    
    return _bottomBar;
}
- (JHCustomizeAnchorBottomBar *)customBottomBar{
    if (!_customBottomBar) {
        NSInteger type = 1;
        if ([self.channel.canFlashPurchase isEqualToString:@"1"]) {
            type = NSIntegerMax;
        }
        _customBottomBar = [[JHCustomizeAnchorBottomBar alloc] initWithType:type];
        _customBottomBar.channel = self.channel;
        _customBottomBar.delegate = self;
    }
    return _customBottomBar;
}
#pragma make ---JHCustomizeAnchorBottomBarDelegate
- (void)customorderListAction:(UIButton *)sender{
//    [self orderListAction];
    JHCustomOrderView *orderview = [[JHCustomOrderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:orderview];
}
- (void)noticeAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeAnnouncement sender:nil];
    }
}

- (void)sayWhatBtnAction:(UIButton *)sender {
    [self popInputBarAction];
}

- (void)customclickListBtnAction:(UIButton *)btn Trailing:(CGFloat)trailing
{
    self.moreBtn = btn;
    btn.selected = !btn.selected;
    self.liveRoomListView.hidden = !btn.selected;
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:4];
    if(self.channel.showBlessingBag ){
        [arr addObject:@{@"title":@"福袋",@"icon":@"live_room_more_lucky"}];
    }
    if (self.channel.canSendLivingTip == 1) {
        [arr addObject:@{@"title":@"开播提醒",@"icon":@"startedtoRemind"}];
    }
    NSArray *arr1;
    if (self.canAuction) {
        arr1 = @[
             @{@"title":@"禁言",@"icon":@"live_room_more_mute"},
             @{@"title":@"竞拍",@"icon":@"live_room_more_auction_icon"},
             @{@"title":@"分享",@"icon":@"live_room_more_share"},
             @{@"title":@"发红包",@"icon":@"live_room_more_redpacket_icon"}
        ];
    } else {
        arr1 = @[
             @{@"title":@"禁言",@"icon":@"live_room_more_mute"},
             @{@"title":@"分享",@"icon":@"live_room_more_share"},
             @{@"title":@"发红包",@"icon":@"live_room_more_redpacket_icon"}
        ];
    }
    [arr addObjectsFromArray:arr1];
    CGFloat height = arr.count*34+12;
    CGFloat width = 79.0;
    CGFloat x = trailing - width/2.0;
    self.liveRoomListView.frame = CGRectMake(x,0, width, height);
    self.liveRoomListView.bottom = self.customBottomBar.top + 5;
    [self.liveRoomListView updateData:arr];
}


- (void)enterShopwindowAction
{
    
}
- (JHVideoPlayControlView *)playControlView {
    if (!_playControlView) {
        _playControlView =[[JHVideoPlayControlView alloc]init];
    }
    
    return _playControlView;
}

- (NTESTextInputView *)textInputView
{
    if (!_textInputView) {
        CGFloat height = 44.f;
        _textInputView = [[NTESTextInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, height) withType:(NTESTextInputViewTypeEmoji)];
        _textInputView.delegate = self;
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _textInputView.hidden = YES;
        NTESGrowingInternalTextView *textView = _textInputView.textViewnew;
        NSString *placeHolder = @"聊天室连接中，暂时无法发言";
        textView.editable = NO;
        textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    }
    return _textInputView;
}

/// 快捷回复语
-(JHReplyMessageView *)replyMessageView
{
    if(!_replyMessageView)
    {
        _replyMessageView = [[JHReplyMessageView alloc] initWithChannelModel:self.channel];
        _replyMessageView.frame = CGRectMake(0, 0, 154, 192);
        _replyMessageView.layer.zPosition = 1;
        _replyMessageView.hidden = YES;
    }
    return _replyMessageView;
}

- (JHStoneLiveView *)stoneLiveView
{
    if (!_stoneLiveView) {
        _stoneLiveView=[[JHStoneLiveView alloc]init];
    }
    return _stoneLiveView;
}

- (NTESLiveChatView *)chatView
{
    if (!_chatView) {
        CGFloat height = 160.f;
        CGFloat width  = ScreenW-100.;
        _chatView = [[NTESLiveChatView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _chatView.hidden = NO;
        _chatView.delegate = self;
        _chatView.isAnchor = NO;
    }
    return _chatView;
}

- (NTESLiveActionView *)actionView
{
    if (!_actionView) {
        _actionView = [[NTESLiveActionView alloc] initWithFrame:CGRectZero];
        [_actionView sizeToFit];
        _actionView.delegate = self;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _actionView.hidden = YES;
        if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
            [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        }
    }
    return _actionView;
}

- (NTESLiveLikeView *)likeView
{
    if (!_likeView) {
        CGFloat width  = 50.f;
        CGFloat height = 300.f;
        _likeView = [[NTESLiveLikeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _likeView.hidden = YES;
    }
    return _likeView;
}

- (NTESLivePresentView *)presentView
{
    if(!_presentView){
        CGFloat width  = 200.f;
        CGFloat height = 96.f;
        _presentView = [[NTESLivePresentView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _presentView.bottom = self.actionView.top;
        _presentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _presentView.hidden = YES;
    }
    return _presentView;
}

//- (NTESLiveCoverView *)coverView
//{
//    if (!_coverView) {
//        _coverView = [[NTESLiveCoverView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, self.mj_h)];
//        _coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _coverView.hidden = YES;
//        _coverView.delegate = self;
//
//    }
//    return _coverView;
//}



- (NTESLiveroomInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[NTESLiveroomInfoView alloc] init];
        _infoView.hidden = YES;
    }
    return _infoView;
}

- (UIButton *)closeRoomButton
{
    if(!_closeRoomButton)
    {
        _closeRoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeRoomButton setImage:[UIImage imageNamed:@"icon_circle_close"] forState:UIControlStateNormal];
        [_closeRoomButton setImage:[UIImage imageNamed:@"icon_circle_close"] forState:UIControlStateHighlighted];
        [_closeRoomButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        _closeRoomButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _closeRoomButton;
}


- (NTESGLView *)glView
{
    if (!_glView) {
        _glView = [[NTESGLView alloc] initWithFrame:self.bounds];
        _glView.contentMode = UIViewContentModeScaleAspectFill;
        _glView.hidden = YES;
    }
    return _glView;
}


- (NTESCameraZoomView*)cameraZoomView
{
    if(!_cameraZoomView)
    {
        _cameraZoomView = [[NTESCameraZoomView alloc]initWithFrame:CGRectZero];
        _cameraZoomView.hidden = YES;
    }
    return _cameraZoomView;
}


- (NTESNetStatusView *)netStatusView
{
    if (!_netStatusView) {
        _netStatusView = [[NTESNetStatusView alloc] initWithFrame:CGRectZero];
        //没有回调之前，默认为较好的网络情况
        [_netStatusView refresh:NIMNetCallNetStatusGood];
        [_netStatusView sizeToFit];
        _netStatusView.hidden = YES;
        [self setNeedsLayout];
    }
    return _netStatusView;
}

- (JHAnnouncementDisplayView *)announcementDisplayView {
    if (!_announcementDisplayView) {
        _announcementDisplayView = [JHAnnouncementDisplayView announcementDisplay:JHAnnouncementDisplayAudience];
        _announcementDisplayView.delegate = self;
    }
    return _announcementDisplayView;
}
- (void)recoverMaxView{
    [self sa_trackingWithOther_name:@"notice"];
}
-(JHLiveRoomListView *)liveRoomListView
{
    if(!_liveRoomListView)
    {
        _liveRoomListView = [JHLiveRoomListView new];
        _liveRoomListView.delegate = self;
    }
    return _liveRoomListView;
}
- (JHLuckyBagView *)luckyBagView{
    if (!_luckyBagView) {
        JHLuckyBagView *luckView = [[JHLuckyBagView alloc]init];
        _luckyBagView = luckView;
    }
    return _luckyBagView;
}
#pragma mark - 连麦视图
//添加连麦视图
- (NTESLiveBypassView *)addBypassViewWithConnector:(NTESMicConnector *)connector {
    
    __block BOOL isAdd = YES;
    __block NTESLiveBypassView *ret = nil;
    [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:connector.uid]) {
            isAdd = NO;
            ret = obj;
            *stop = YES;
        }
    }];
    
    if (isAdd) {
        NTESLiveBypassView *bypassView = [[NTESLiveBypassView alloc] initWithFrame:CGRectZero];
        bypassView.isAnchor = NO;
        bypassView.uid = connector.uid;
        bypassView.delegate = self;
        if ([connector.uid isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            bypassView.localVideoDisplayView = _localDisplayView;
        }
        [bypassView sizeToFit];
        if (!_bypassViews) {
            _bypassViews = [NSMutableArray array];
        }
        if (connector.type == NIMNetCallMediaTypeAudio) {
            if (connector.state == NTESLiveMicStateConnected) {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusStreamingAudio];
            } else if (connector.state == NTESLiveMicStateConnecting) {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusLoading];
            } else {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusPlayingAndBypassingAudio];
            }
        } else {
            if (connector.state == NTESLiveMicStateConnected) {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusStreamingVideo];
            } else if (connector.state == NTESLiveMicStateConnecting) {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusLoading];
            } else {
                [bypassView refresh:nil status:NTESLiveBypassViewStatusPlaying];
            }
        }
        
        [_bypassViews addObject:bypassView];
        CGFloat height = 190;
        CGFloat width =150;
        bypassView.frame = CGRectMake(ScreenW-width-20,
                                      UI.statusBarHeight+80,
                                      width,
                                      height);
        self.liveBypassView = bypassView;
        
        [self.viewController.view addSubview:bypassView];
        
        UIImageView * switImage = [[UIImageView alloc] init];
        switImage.tag = 10006;
        switImage.image = [UIImage imageNamed:@"linkWindowswitch"];
        [self.liveBypassView addSubview:switImage];
        [switImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(26, 26));
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(self.liveBypassView.mas_bottom).offset(-7);
        }];

        if (self.type == 9 || self.type == 11) {
            UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn addTarget:self action:@selector(closeLinkAction) forControlEvents:UIControlEventTouchUpInside];
            closeBtn.tag = 10008;
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"linkWindowsClose"] forState:UIControlStateNormal];
            [self.liveBypassView addSubview:closeBtn];
            [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(49, 26));
                make.bottom.mas_equalTo(self.liveBypassView.mas_bottom).offset(-6);
                make.centerX.mas_equalTo(self.liveBypassView.mas_centerX);
            }];
        }
        
        
        if ([CommHelp isFirstForName:@"GuideRoomFirstLinkSwichTips"]) {
            JHLinkSwichTipsView * tipView = [[JHLinkSwichTipsView alloc] init];
            tipView.tag = 10007;
            [self.liveBypassView addSubview:tipView];
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.liveBypassView);
                make.size.mas_equalTo(CGSizeMake(109, 78));
            }];
        }
    
        ret = bypassView;
        [self layoutIfNeeded];
        NSLog(@"--zgn-- 添加bypass view:[%@]", bypassView.uid);
    }
    return ret;
}
- (void)closeLinkAction{
    //点击关闭连麦
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeLinkAction:)]) {
        [self.delegate closeLinkAction:self.liveBypassView.uid];
    }
}
//查询连麦视图
- (NTESLiveBypassView *)bypassViewWithUid:(NSString *)uid {
    __block NTESLiveBypassView *ret = nil;
    [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.uid isEqualToString:uid]) {
            ret = obj;
            *stop = YES;
        }
    }];
    return ret;
}

#pragma mark - JHLiveBottomBarDelegate
//弹出快捷提示框
- (void)popQuickReplyView:(UIButton *)sender{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:nil];
        return;
    }
    
    self.replyMessageView.hidden = !self.replyMessageView.hidden;
    if (!self.replyMessageView.hidden) {
        [self.replyMessageView moveArrowsLocation:sender];
        [JHGrowingIO trackEventId:JHtrackBusinessliveQuickSpeakClick];
    }
    
    self.replyMessageView.groupId = self.groupId;
    
}

- (void)sendRedPacketAction:(UIButton *)btn {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    
    JHMakeRedpacketController *vc = [[JHMakeRedpacketController alloc] init];
    vc.liveRoomChannelId = self.channel.channelLocalId;
    vc.channel = self.channel;
    vc.groupId = self.groupId;
    vc.entrance = self.entrance;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}
- (void)onAnchorTapUserAction {
    //TODO:yaoyao宝友操作
    
    JHMainLiveRoomTabView* mainLiveRoomTabView = [[JHMainLiveRoomTabView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
    mainLiveRoomTabView.isAssitant = YES;
    mainLiveRoomTabView.channelCategory = self.channel.channelCategory;
    mainLiveRoomTabView.tag = kViewTagUserActionView;
    [self addSubview:mainLiveRoomTabView];
    [mainLiveRoomTabView drawSubviews:self.channel.channelLocalId];
    [mainLiveRoomTabView setRedDotNum:self.countInfo.shelveCount withIndex:1];
    [mainLiveRoomTabView setRedDotNum:self.countInfo.seekCount withIndex:2];
    JH_WEAK(self)
    mainLiveRoomTabView.toTabBlock = ^(id obj) {
        JH_STRONG(self)
        NSInteger index = [obj integerValue];
        switch (index) {
            case 0:
                break;
            case 1:
                self.countInfo.shelveCount = 0;
                break;
            case 2:
                self.countInfo.seekCount = 0;
                break;
            default:
                break;
        }
        [self updateActionButtonCount:0 type:JHSystemMsgTypeStoneUserActionCount];
        
    };
    [mainLiveRoomTabView showAlert];
    
}

- (void)onShanGouBtnAction{
    if ([self.delegate respondsToSelector:@selector(onShanGouBtnAction)]) {
        [self.delegate onShanGouBtnAction];
    }
}

- (void)onAnchorTapInsaleAction {
    //TODO:yaoyao在售
    
    JHMainRoomOnSaleStoneView* mrOnSaleView = [[JHMainRoomOnSaleStoneView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
    mrOnSaleView.tag = kViewTagResaleView;
    mrOnSaleView.channelId = self.channel.channelLocalId;
    [self addSubview:mrOnSaleView];
    [mrOnSaleView drawSubviewsWithPageType:JHMainLiveRoomTabTypeResaleStoneTab];
    [mrOnSaleView showAlert];
}
- (void)clickListBtnAction:(UIButton *)btn Trailing:(CGFloat)trailing
{
    self.moreBtn = btn;
    btn.selected = !btn.selected;
    self.liveRoomListView.hidden = !btn.selected;
    NSMutableArray *arr = [NSMutableArray array];
    if(self.channel.showBlessingBag ){
        [arr addObject:@{@"title":@"福袋",@"icon":@"live_room_more_lucky"}];
    }
    if(self.canAuction)
    {
        NSArray *arr1 = @[@{@"title":@"发红包",@"icon":@"live_room_more_redpacket_icon"},@{@"title":@"竞拍",@"icon":@"live_room_more_auction_icon"},@{@"title":@"订单",@"icon":@"live_room_more_order_icon"},@{@"title":@"联系平台",@"icon":@"live_room_more_service_icon"}];
        [arr addObjectsFromArray:arr1];
    }else
    {
        NSArray *arr1 = @[@{@"title":@"发红包",@"icon":@"live_room_more_redpacket_icon"},@{@"title":@"订单",@"icon":@"live_room_more_order_icon"},@{@"title":@"联系平台",@"icon":@"live_room_more_service_icon"}];
        [arr addObjectsFromArray:arr1];
    }
    CGFloat height = arr.count*34+6;
    CGFloat width = 84.0;
    CGFloat x = kScreenWidth - width - trailing+37/2.0;
    self.liveRoomListView.frame = CGRectMake(x,0, width, height);
    self.liveRoomListView.bottom = self.bottomBar.top + 5;
    
    
    [self.liveRoomListView updateData:arr];
}
- (void)publishIdleMethodAction{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:nil];
        return;
    }
    JHRecycleUploadTypeSeleteViewController *publish = [[JHRecycleUploadTypeSeleteViewController alloc] init];
    publish.businessId = self.channel.anchorId;
    [[JHRootController currentViewController].navigationController pushViewController:publish animated:YES];
}
-(void)hiddenLiveRoomListView
{
    self.liveRoomListView.hidden = YES;
    self.moreBtn.selected = NO;
}
-(void)didSelectedItem:(JHLiveRoomListViewCellModel *)model;
{
    [self hiddenLiveRoomListView];
    NSString *title = model.title;
    if([title isEqualToString:@"发红包"])
    {
        [self sendRedPacketAction:nil];
    }else if([title isEqualToString:@"竞拍"])
    {
        [self popAuctionListAction:nil];
        
    }else if([title isEqualToString:@"订单"])
    {
        [self orderListAction];
    }
    else if([title isEqualToString:@"联系平台"])
    {
        [self suggestAction];
    }else if([title isEqualToString:@"禁言"])
    {
        if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
            [self.delegate onActionType:NTESLiveActionTypeMuteList sender:nil];
        }
    }else if([title isEqualToString:@"分享"])
    {
//        if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
//            [self.delegate onActionType:NTESLiveActionTypeShare sender:nil];
//        }
        [self shareAction];
    }else if([title isEqualToString:@"开播提醒"]){
        [[JHSendLivingTipManeger shareManager] sendLivingTipManeger:self andChannelLocalId:self.channel.channelLocalId];
    }else if([title isEqualToString:@"福袋"]){
        [self luckyBagAction];
    }
}
- (void)luckyBagAction{
    [self.luckyBagView show];
}
-(void)suggestAction
{
    if(_pushSuggestVCDelegate && [_pushSuggestVCDelegate respondsToSelector:@selector(pushSuggestVC:)])
    {
        [_pushSuggestVCDelegate pushSuggestVC:self];
    }
}
- (void)onAndienceTapResaleAction {
    //TODO:yaoyao用户寄售按钮
    if (!self.resaleLiveRoomTabView) {
        self.resaleHeight = 0;
        JHResaleLiveRoomStretchView* resaleLiveRoomTabView = [[JHResaleLiveRoomStretchView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH - ScreenH*(386/812.0))];
        resaleLiveRoomTabView.tag = kViewTagForSaleView;
        [self addSubview:resaleLiveRoomTabView];
        
        JH_WEAK(self)
        [resaleLiveRoomTabView drawSubviews:self.channel.channelLocalId action:^(id obj) {
            JH_STRONG(self)
            //显示状态
            
            JHResaleTabStyle style = [obj intValue];
            CGFloat lowHeight = kResaleLiveShrinkHeight;
            switch (style) {
                case JHResaleTabStyleDefault :
                    self.resaleHeight = lowHeight;
                    [self layoutSubviews];
                    [self showResaleGuide];
                    
                    break;
                case JHResaleTabStyleLow :
                    self.resaleHeight = lowHeight;
                    [self layoutSubviews];
                    
                    break;
                    
                case JHResaleTabStyleHigh :
                    
                    break;
                    
                default:
                    break;
            }
            [self hiddenBarBottom:style == JHResaleTabStyleHigh];
            NSLog(@"JHResaleTabStyle:%zd", style);
        }];
        [resaleLiveRoomTabView setTabViewRedDotNum:self.countInfo.offerCount withIndex:2 clickAction:^(id obj) {
            JH_STRONG(self)
            NSInteger index = [obj integerValue];
            switch (index) {
                case 2:
                    self.countInfo.offerCount = 0;
                    break;
                default:
                    break;
            }
        }];
        
        self.resaleLiveRoomTabView = resaleLiveRoomTabView;
    }
}

- (void)hiddenBarBottom:(BOOL)isHide {
    self.bottomBar.hidden = isHide;
    self.chatView.hidden = isHide;
    self.comeInAnimationView.hidden = isHide;
    self.reSaleRoomHiddenActivity(@(isHide));
    self.systemMsgAnimationView.hidden = isHide;
}

- (void)popAuctionListAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(onShowAuctionListView:)]) {
        [_delegate onShowAuctionListView:btn];
    }
}

- (void)pressLikeAction:(UIButton *)likeCountBtn {
    //更新点赞数量
    [self onActionType:NTESLiveActionTypeLike sender:likeCountBtn];
}

- (void)claimOrderListAction {
    
}
- (void)canAppraiseAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(onCanAppraiseAction:)]) {
        [_delegate onCanAppraiseAction:btn];
    }
}

- (void)stoneOrderList {
    //TODO:yaoyao原石订单
    
    JHLastSaleStoneView* lastSaleView = [[JHLastSaleStoneView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
    lastSaleView.isAssitant = YES;
    lastSaleView.channelCategory = self.channel.channelCategory;
    lastSaleView.tag = kViewTagStoneOrderView;
    [lastSaleView drawSubviewsByPagetype:JHLastSaleCellTypeBuyer channelId:self.channel.channelLocalId];
    [self addSubview:lastSaleView];
    [lastSaleView showAlert];
    
}

- (void)orderListAction {
    
    [self addSubview:self.orderListView];
    [self.orderListView showAlert];
}
- (void)shareAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(onShareAction)]) {
        [_delegate onShareAction];
    }
}

- (void)popInputBarAction {
    
    [JHGrowingIO trackEventId:JHTracklive_bottom_sendmsgbtn variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    
    if (![JHRootController isLogin]) {
        if (self.type == JHAudienceUserRoleTypeSale) {
            [JHGrowingIO trackEventId:@"enter_live_in" from:@"shop_live_room_comment"];
        }
        if (self.type == JHAudienceUserRoleTypeAppraise) {
            [JHGrowingIO trackEventId:@"enter_live_in" from:@"appraisal_live_room_comment"];
        }
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
        }];
        return;
    }
    self.textInputView.hidden = NO;
    UITextView *textview = (UITextView*)[self getTextViewFromTextInputView];
    [textview becomeFirstResponder];
    
}


- (void)popGiftAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    
    if (!_presentBoxView) {
        [self addSubview: self.presentBoxView];
    }
    [self.presentBoxView showAlert];
    
}
// 连麦定制
- (void)onLineToCustomize:(JHLiveButtonStyle)CustomizeButtonStyle{
    if ([_delegate respondsToSelector:@selector(onCustomizeWithType:)]) {
        if (CustomizeButtonStyle == JHLiveButtonStyleNormal) {
            if ([JHNimNotificationManager sharedManager].customizeWaitMode.isWait) {
                CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"您目前正在其他房间排队，确定申请将从其他队列退出。" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                [self addSubview:alert];
                @weakify(self);
                alert.handle = ^{
                    @strongify(self);
                    [self.delegate onCustomizeWithType:CustomizeButtonStyle];
                };
            }else{
                [_delegate onCustomizeWithType:CustomizeButtonStyle];
            }
        }else{
            [_delegate onCustomizeWithType:CustomizeButtonStyle];
        }
        
    }
}
// 连麦回收
- (void)onLineToRecycle:(JHLiveButtonStyle)buttonStyle{
    if ([_delegate respondsToSelector:@selector(onRecycleWithType:)]) {
        if (buttonStyle == JHLiveButtonStyleNormal) {
            if ([JHNimNotificationManager sharedManager].recycleWaitMode.isWait) {
                CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"您目前正在其他房间排队，确定申请将从其他队列退出。" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                [self addSubview:alert];
                @weakify(self);
                alert.handle = ^{
                    @strongify(self);
                    [self.delegate onRecycleWithType:buttonStyle];
                };
            }else{
                [_delegate onRecycleWithType:buttonStyle];
            }
        }else{
            [_delegate onRecycleWithType:buttonStyle];
        }
        
    }
}
- (void)appraiseActionWithType:(JHLiveRole)roleType {
    if (_delegate && [_delegate respondsToSelector:@selector(onAppraiseWithType:)]) {
        //判断状态
        
        if (roleType == JHLiveRoleAnchor) {
            if ([_delegate respondsToSelector:@selector(onAppraiseList)]) {
                [_delegate onAppraiseList];
                
            }
        }else {
            if ([_delegate respondsToSelector:@selector(onAppraiseWithType:)]) {
                [_delegate onAppraiseWithType:roleType];
            }
            
        }
    }
}

- (void)onAndienceTapChat {
    if ([self.delegate respondsToSelector:@selector(onTapAndienceHelp)]) {
        [self.delegate onTapAndienceHelp];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenPopAlert];
    [self hiddenLiveRoomListView];
    [self endEditing:YES];
    [self.viewController touchesBegan:touches withEvent:event];
    
}

- (void)hiddenPopAlert {
    self.replyMessageView.hidden = YES;
    [_hdAlert hiddenAlert];
    [_presentBoxView hiddenAlert];
    [_claimOrderListView hiddenAlert];
    BaseView *view3 = [self viewWithTag:kViewTagStoneOrderView];
    if (view3) {
        [view3 hiddenAlert];
    }
    BaseView *view1 = [self viewWithTag:kViewTagResaleView];
    if (view1) {
        [view1 hiddenAlert];
    }
    BaseView *view2 = [self viewWithTag:kViewTagUserActionView];
    if (view2) {
        [view2 hiddenAlert];
    }
    
    [self endEditing:YES];
}


#pragma mark - JHAutoRunViewDelegate

- (void)operateLabel:(JHAutoRunView *)autoLabel animationDidStopFinished:(BOOL)finished {
    [_autoRunView removeFromSuperview];
    _autoRunView = nil;
}



- (void)reCatuAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/riskTtest.html");
    vc.titleString = @"风险测试";
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
#pragma --构建直播间小窗
-(void)setStoneChannel:(StoneChannelMode *)stoneChannel{
    _stoneChannel=stoneChannel;
    if (_stoneChannel.channelStatus==2) {
        if (![self.stoneLiveView isDescendantOfView:self]) {
            if (_announcementDisplayView) {
                [self insertSubview:self.stoneLiveView belowSubview:_announcementDisplayView];
            }
            else {
                [self addSubview:self.stoneLiveView];
            }
            UIView *webActivity = [self viewWithTag:10009];
            if (webActivity && !_endPageView) {
                [self bringSubviewToFront:webActivity];
            }
            [self.stoneLiveView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.offset(UI.statusAndNavBarHeight+75);
                make.right.offset(-10);
                make.size.mas_equalTo(CGSizeMake(110, 160));
            }];
        }
        self.stoneLiveView.stoneChannel=_stoneChannel;
        [self showStoneGuide];
        
    }
    else{
        [self.stoneLiveView removeFromSuperview];
        _stoneLiveView=nil;
        [[JHLivePlayerManager sharedInstance] shutdown];
    }
}

- (void)updateResaleAmount:(NSString *)price {
    
    [_restorePriceBtn setTitle:[NSString stringWithFormat:@"回血%@",price] forState:UIControlStateNormal];
    
}

- (void)updateOfferPriceCount:(NSInteger)count {
    //更新下面tab页面 未读数 和 按钮未读数
    //    self.havePriceBtn.hidden = NO;
    //    self.havePriceBtn.dotLabel.text = @(count).stringValue;
    self.countInfo.offerCount = count;
    [self.resaleLiveRoomTabView setTabViewRedDotNum:count withIndex:2 clickAction:nil];
}

- (void)updateOnsaleCount:(NSInteger)count {
    self.bottomBar.resaleBtn.dotLabel.text = @(count).stringValue;
}

- (void)updateActionButtonCount:(NSInteger)count type:(NSInteger)type {
    switch (type) {
        case JHSystemMsgTypeStoneInSaleCount: {
            NSString *string = @"在售";
            if (count > 0) {
                string = [NSString stringWithFormat:@"在售\n%zd",count];
            }
            [self.bottomBar.insaleBtn.button setTitle:string forState:UIControlStateNormal];
        }
            break;
        case JHSystemMsgTypeStoneUserActionCount:{
            count = self.countInfo.seekCount+self.countInfo.shelveCount+self.countInfo.unshelveCount;
            self.bottomBar.userActionBtn.dotLabel.text = @(count).stringValue;
            
        }
            break;
        case JHSystemMsgTypeStoneWaitShelveCount: {
            count = self.countInfo.seekCount+self.countInfo.shelveCount;
            self.bottomBar.userActionBtn.dotLabel.text = @(count).stringValue;
        }
            break;
            
        case JHSystemMsgTypeStoneOrderCount: {
            self.stoneOrderBtn.dotLabel.text = @(count).stringValue;
        }
            break;
            
        case JHSystemMsgTypeStoneRefreshList: {
            //不要了
        }
            
            break;
        default:
            break;
            
    }
}

- (void)displayAnnoucement:(UIImage *)announcementImage {
    if (!_announcementDisplayView) {
        self.announcementDisplayView.announcementImage = announcementImage;
//        if (_autoRunView) {
//            [self insertSubview:self.announcementDisplayView aboveSubview:_autoRunView];
//        }
//        else {
//            [self addSubview:self.announcementDisplayView];
//        }
        [self addSubview:self.announcementDisplayView];
        if (self.resaleLiveRoomTabView) {
            [self bringSubviewToFront:self.resaleLiveRoomTabView];
        }
    }
}

- (void)removeAnnoucement {
    [self.announcementDisplayView removeFromSuperview];
    _announcementDisplayView = nil;
}

- (void)showResaleGuide {
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone]) {
        if (![CommHelp isFirstForName:@"isFirstInSaleLiveRoom"]) {
            UIView *view = [self.viewController.view viewWithTag:956];
            if (view && [view isKindOfClass:[JHSellRoomGuidenceView class]]) {
                return;
            }
            if ([CommHelp isFirstForName:@"isFirstShowResaleGuide"])
            {
                [JHStoneLiveWindowGuideView showGuideViewWithIndex:1];
                
            }
        }
    }
}

- (void)showStoneGuide {
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
        if (![CommHelp isFirstForName:@"isFirstInSaleLiveRoom"]) {
            UIView *view = [self.viewController.view viewWithTag:956];
            if (view && [view isKindOfClass:[JHSellRoomGuidenceView class]]) {
                return;
            }
            if ([CommHelp isFirstForName:@"isFirstShowStoneGuide"]) {
                [JHStoneLiveWindowGuideView showGuideView];
                
            }
        }
    }
}

- (void)checkChatType {
    [JHChatBusiness getServeceWithUserId:self.channel.anchorId successBlock:^(RequestModel * _Nullable respondObject) {
        NSUInteger code = [respondObject.data integerValue];
        if (code == 1) {
            [self.bottomBar setChatTitle:@"联系商家"];
        }else {
            [JHQYChatManage checkChatTypeWithCustomerId:self.channel.anchorId saleType:JHChatSaleTypeFront completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
                [self.bottomBar setChatTitle:isShop?@"联系商家":@"联系平台"];
            }];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
}

- (void)showTipsGuideView {
    
    if (self.type == 0) {
        if ([CommHelp isFirstForName:kGuideRoomAppraise] && self.bottomBar.pauseActionBtn.hidden)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bottomBar layoutIfNeeded];
                CGRect rect = [self.bottomBar convertRect:self.bottomBar.appraiseBtn.frame toView:self];
                [JHNewGuideTipsView showGuideWithType:JHTipsGuideTypeAppraiseRoom transparencyRect:rect superView:self.viewController.view];
            });
        }
    }
    else if (self.type != JHAudienceUserRoleTypeCustomize &&
             self.type != JHAudienceUserRoleTypeCustomizeAssistant) {
        ///定制观众 和 定制助理不需要显示引导
        if ([CommHelp isFirstForName:kGuideRoomSellSayWhat])
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bottomBar layoutIfNeeded];
                CGRect rect = [self.bottomBar convertRect:self.bottomBar.sayWhateBtn.frame toView:self];
                [JHNewGuideTipsView showGuideWithType:JHTipsGuideTypeSellRoom transparencyRect:rect superView:self.viewController.view];
            });
        }
        if ([JHLiveRoomStatus isLiveRoomType:JHLiveRoomTypeSell channelType:self.channel.channelType]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ///第一次进入直播间需要展示直播间新手引导
                if ([CommHelp isFirstForName:kFirstEnterLiveRoomKey]) {
                    if (self.showGuideBlock) {
                        self.showGuideBlock();
                    }
                }
            });
        }
    }
    else if (self.type == JHAudienceUserRoleTypeCustomize){
        if ([CommHelp isFirstForName:@"GuideRoomFirstEnterCustomRoom"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bottomBar layoutIfNeeded];
                JHNewGuideTipsViewModel * model = [JHNewGuideTipsViewModel new];
                model.type = JHTipsGuideTypeCustomizeRoom;
                model.rect = [self.infoView convertRect:self.infoView.avatar.frame toView:self];
                JHNewGuideTipsViewModel * model2 = [JHNewGuideTipsViewModel new];
                model2.type = JHTipsGuideTypeCustomizeRoom_second;
                model2.rect = [self.bottomBar convertRect:self.bottomBar.appraiseBtn.frame toView:self];
                NSArray *array = @[model,model2];
                [JHNewGuideTipsView showGuideWithModelArray:array superView:self.viewController.view];
            });
        }
    }
    if (self.bottomBar.roleType == JHLiveRoleSaleAnchor) {
        if ([CommHelp isFirstForName:@"GuideRoomApplyAppraise"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.bottomBar layoutIfNeeded];
                CGRect rect = [self.bottomBar convertRect:self.bottomBar.appraiseBtn.frame toView:self];
                [JHNewGuideTipsView showGuideWithType:JHTipsGuideTypeAppraiseRoomApply transparencyRect:rect superView:self.viewController.view];
            });
        }
    }
}
-(JHLiveRoomCustomBtnView *)orderBtnView
{
    if(!_orderBtnView)
    {
        _orderBtnView = [JHLiveRoomCustomBtnView new];
        _orderBtnView.hidden = YES;
        _orderBtnView.layer.masksToBounds = YES;
        _orderBtnView.layer.cornerRadius = 8;
//        _orderBtnView.leftImageView.image = [UIImage imageNamed:@"live_room_no_order_icon"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOrderView)];
        [_orderBtnView addGestureRecognizer:tap];
        
    }
    return _orderBtnView;
}
-(JHLiveRoomCustomBtnView *)customizeBtnView
{
    if(!_customizeBtnView)
    {
        _customizeBtnView = [JHLiveRoomCustomBtnView new];
        _customizeBtnView.titleLabel.text = [NSString stringWithFormat:@"定制排队 %@",@"0"];
        _customizeBtnView.hidden = NO;
        _customizeBtnView.layer.masksToBounds = YES;
        _customizeBtnView.layer.cornerRadius = 8;
//        _customizeBtnView.leftImageView.image = [UIImage imageNamed:@"live_room_customize_icon"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCustomizeBtnView)];
        [_customizeBtnView addGestureRecognizer:tap];
        
    }
    return _customizeBtnView;
}

-(JHLiveRoomCustomBtnView *)praiseBtnView
{
    if(!_praiseBtnView)
    {
        _praiseBtnView = [JHLiveRoomCustomBtnView new];
//        _praiseBtnView.leftImageView.image = [UIImage imageNamed:@"live_room_praisequeuen_icon"];
        _praiseBtnView.layer.masksToBounds = YES;
        _praiseBtnView.layer.cornerRadius = 8;
        _praiseBtnView.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAppraiseView)];
        [_praiseBtnView addGestureRecognizer:tap];
    }
    return _praiseBtnView;
}

-(JHLiveRoomCustomBtnView *)recycleBtnView{
    if(!_recycleBtnView)
    {
        _recycleBtnView = [JHLiveRoomCustomBtnView new];
//        _recycleBtnView.leftImageView.image = [UIImage imageNamed:@"live_room_praisequeuen_icon"];
        _recycleBtnView.layer.masksToBounds = YES;
        _recycleBtnView.layer.cornerRadius = 8;
        _recycleBtnView.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecycleBtnView)];
        [_recycleBtnView addGestureRecognizer:tap];
    }
    return _recycleBtnView;
}
- (JHLiveRoomCustomBtnView *)waitRecycleBtn{
    if (!_waitRecycleBtn) {
        _waitRecycleBtn = [JHLiveRoomCustomBtnView new];
        _waitRecycleBtn.titleLabel.text = [NSString stringWithFormat:@"待回收 %@",@"0"];
        _waitRecycleBtn.hidden = NO;
        _waitRecycleBtn.layer.masksToBounds = YES;
        _waitRecycleBtn.layer.cornerRadius = 8;
//        _waitRecycleBtn.leftImageView.image = [UIImage imageNamed:@"live_room_customize_icon"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWaitRecycleBtnView)];
        [_waitRecycleBtn addGestureRecognizer:tap];
    }
    return _waitRecycleBtn;
}
- (void)creatjadeiteListBtn{
    
    self.jadeiteListBtn.hidden = NO;
    [self.jadeiteListBtn setTitle:[NSString stringWithFormat:@"    %@",self.jadeiteListStr] forState:UIControlStateNormal];
    CGFloat width = [self.jadeiteListStr sizeWithFont:JHMediumFont(10) maxSize:CGSizeMake(CGFLOAT_MAX, 20)].width;
    
    self.jadeiteListBtn.size = CGSizeMake(width+35, 18);
    [self topBtnViewAddView:self.jadeiteListBtn andPosition:0];
    
//    [self.jadeiteListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(16);
//        make.width.mas_equalTo(width + 35);
//        make.left.mas_equalTo(15);
//        make.top.equalTo(self.saleGuideBtn.mas_bottom).with.offset(15);
//    }];
}
- (JHRightArrowBtn *)jadeiteListBtn{
    if (!_jadeiteListBtn) {
        _jadeiteListBtn = [[JHRightArrowBtn alloc] init];
        _jadeiteListBtn.hidden = YES;
        if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]){
                  _jadeiteListBtn.isRoughStone = YES;
              }
        [_jadeiteListBtn resetRightArrowStyle:JHRightArrowStyleMediumFont];
        _jadeiteListBtn.backgroundColor = HEXCOLORA(0xFF3B3B, 0.4);
        [_jadeiteListBtn addTarget:self action:@selector(jadeiteListBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [UIImageView new];
        icon.image = [UIImage imageNamed:@"jadeiteList_image"];
        [_jadeiteListBtn addSubview:icon];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_jadeiteListBtn).offset(5);
            make.centerY.equalTo(_jadeiteListBtn);
            make.size.mas_equalTo(CGSizeMake(9, 10));
        }];
    }
    return _jadeiteListBtn;
}
- (void)jadeiteListBtnAction{
    if (self.channel.channelLocalId.length>0 && self.rankName.length>0) {
        [JHGrowingIO trackEventId:JHtrackRanding_listClick variables:@{@"channelLocalId":self.channel.channelLocalId,@"type":self.rankName}];
    }
    JHLiveRoomPKView * pkview = [[JHLiveRoomPKView alloc] initWithFrame:CGRectZero andType:_type andchannelId:self.channel.channelId];
    pkview.channel = self.channel;
    pkview.bottomBar = self.bottomBar;
    pkview.rankName = self.rankName;
    [pkview show];
}
- (JHSaleLiveRoomCustomizeList *) customizeList{
    if (!_customizeList) {
        _customizeList = [[JHSaleLiveRoomCustomizeList alloc] init];
    }
    return _customizeList;
}
- (JHCustomizeLinkShowOrderView *)leftCustomizeOrder{
    if (!_leftCustomizeOrder) {
        _leftCustomizeOrder = [[JHCustomizeLinkShowOrderView alloc] init];
    }
    return _leftCustomizeOrder;
}
- (void)setLeftCustomizeOrderHidden:(BOOL)isShow withModel:(JHSystemMsgCustomizeOrder *)model{
    if (isShow) {
        [self addSubview:self.leftCustomizeOrder];
        if (_type == JHAudienceUserRoleTypeCustomizeAssistant) {
            self.leftCustomizeOrder.isSeller = YES;
        }else{
            self.leftCustomizeOrder.isSeller = NO;
        }
        [self.leftCustomizeOrder showViewWithModel:model];
        [self.leftCustomizeOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(215, 90));
            make.bottom.equalTo(self.bottomBar.mas_top).offset(-5);
        }];
    }else{
        [self.leftCustomizeOrder removeFromSuperview];
        self.leftCustomizeOrder = nil;
    }
    [self setChatViewLayout];
}
- (JHLiveActivityCountdownView *)countdownView {
    if (!_countdownView) {
        _countdownView = [[JHLiveActivityCountdownView alloc] initWithFrame:CGRectZero];
    }
    return _countdownView;
}
@end


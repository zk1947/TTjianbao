//
//  JHCustomizeAnchorInnerView.m
//  TTjianbao
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHCustomizeAnchorInnerView.h"
#import "TTjianbaoHeader.h"

#import "NTESLiveChatView.h"
#import "NTESLivePresentView.h"
#import "NTESLiveCoverView.h"

#import "NTESTextInputView.h"
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
#import "JHAudienceListView.h"
#import "JHLivePopAlertViews.h"
#import "JHLiveEndPageView.h"
#import "UMengManager.h"
#import "JHSystemMsgAttachment.h"
#import "JHSystemMsgAnimationView.h"
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
#import "JHMainLiveRoomTabView.h"
#import "JHMainRoomOnSaleStoneView.h"
#import "JHLastSaleStoneView.h"
#import "JHDotButtonView.h"
#import "JHMakeRedpacketController.h"
#import "JHSVGAAnimationView.h"
#import "JHLiveRoomListView.h"
#import "JHLiveRoomListViewCellModel.h"
#import "NTESGrowingInternalTextView.h"

#import "JHLiveRoomPKView.h"
#import "JHLiveRoomPKModel.h"
#import "NTESLiveLikeView.h"
#import "JHCustomizeAnchorBottomBar.h"
#import "JHCustomizeLinkShowOrderView.h"
#import "JHCustomOrderView.h"
#import "JHLinkSwichTipsView.h"
#import "JHSendLivingTipManeger.h"
#import "JHLuckyBagView.h"

#define kViewTagStoneOrderView 1111
#define kViewTagResaleView 2222
#define kViewTagUserActionView 3333

@interface JHCustomizeAnchorInnerView()<NTESLiveActionViewDelegate,NTESTextInputViewDelegate,NTESTimerHolderDelegate,NTESLiveBypassViewDelegate,NTESLiveCoverViewDelegate,NTESLiveChatViewDelegate, JHLiveBottomBarDelegate,UIGestureRecognizerDelegate, JHAutoRunViewDelegate,JHLiveRoomListViewDelegate,JHCustomizeAnchorBottomBarDelegate>{
    CGFloat _keyBoradHeight;
    NTESTimerHolder *_timer;
    CALayer *_cameraLayer;
    CGSize _lastRemoteViewSize;
    BOOL isSendOrderKeyBoard;
    BOOL isBackLook;//回放
}

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮
@property (nonatomic, strong) UIButton *closeButton;              //关闭直播按钮

@property (nonatomic, strong) UIButton *closeRoomButton;              //关闭直播按钮

@property (nonatomic, copy)   NSString *roomId;                   //聊天室ID
@property (nonatomic, strong) NTESTextInputView    *textInputView; //输入框
@property (nonatomic, strong) NTESLiveChatView     *chatView;      //聊天窗
@property (nonatomic, strong) NTESLiveActionView   *actionView;    //操作条
@property (nonatomic, strong) NTESLivePresentView  *presentView;   //礼物到达视图
@property (nonatomic, strong) NTESLiveCoverView    *coverView;     //状态覆盖层
@property (nonatomic, strong) NTESLiveLikeView     *likeView;      //爱心视图
@property (nonatomic, strong) NSMutableArray <NTESLiveBypassView *> *bypassViews;
@property (nonatomic, strong) NTESGLView           *glView;        //接收YUV数据的视图
//@property (nonatomic, strong) NTESNickListView     *bypassNickList;  //互动直播昵称


@property (nonatomic, strong) NTESNetStatusView    *netStatusView;    //网络状态视图

@property (nonatomic, strong) NTESCameraZoomView   *cameraZoomView;

@property (nonatomic) BOOL isActionViewMoveUp;    //actionView上移标识

@property (nonatomic, assign) BOOL  isAnchor;

@property (nonatomic, strong) JHAudienceListView *audienceListView; //观众头像列表

@property (nonatomic, strong) JHLivePopAlertViews *moreAlert;

@property (nonatomic, strong) JHLivePopAlertViews *hdAlert;

@property (nonatomic, strong) JHSystemMsgAnimationView *systemMsgAnimationView;
@property (nonatomic, strong) JHComeinAnimationView *comeInAnimationView;

@property (nonatomic,strong) JHPresentBoxView *presentBoxView;

@property (nonatomic,strong) JHPresentView *jhpresentView;

@property (nonatomic,strong) UIButton *orderBtn;
@property (nonatomic,strong) JHDoteNumberLabel *orderNumLabel;

@property (nonatomic,strong) JHOrderListView *orderListView;

@property (nonatomic,strong) JHLiveRoomGuidanceView *liveRoomGuidanceView;
@property (nonatomic,strong) JHAutoRunView *autoRunView;
@property (nonatomic, strong) JHRightArrowBtn *saleGuideBtn;
@property (nonatomic, strong) JHRightArrowBtn *commentBtn;
@property(nonatomic,strong)JHLiveRoomListView *liveRoomListView;
@property(nonatomic,strong)UIButton *moreBtn;

@property (nonatomic, strong) JHCustomizeAnchorBottomBar * customBottomBar;

@property (nonatomic, strong) JHCustomizeLinkShowOrderView *leftCustomizeOrder;
@property (nonatomic, strong) JHLuckyBagView *luckyBagView;
@end
@implementation JHCustomizeAnchorInnerView

- (instancetype)initWithChannel:(ChannelMode *)channel
                          frame:(CGRect)frame
                       isAnchor:(BOOL)isAnchor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channel = channel;
        _roomId = channel.roomId;
        _isAnchor = isAnchor;
        [self setup];
        self.clipsToBounds = YES;
        self.ownLikeCount=0;
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:doubleTapGesture];
        
    }
    
    return self;
}

- (void)dealloc{
    
    [_chatView.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_playControlView removeObserver:self forKeyPath:@"playControlHidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_autoRunView stopAnimation];
    [_autoRunView removeFromSuperview];
    _autoRunView = nil;
    
}
- (void)handleDoubleTap:(UIGestureRecognizer *)gest {
    [self onActionType:NTESLiveActionTypeLike sender:gest.view];
}

#pragma mark - Public

- (void)reloadAnctionWeb {
    if (self.type>0) {
        [self.auctionWeb jh_loadWebURL:AuctionURL(self.type>0, self.isAnchor, NO)];
    }
    
    
}

- (void)updateBackPlayUI {
    self.chatView.hidden = YES;
    isBackLook = YES;
}

- (void)setCanAppraise:(BOOL)canAppraise {
    _canAppraise = canAppraise;
     self.customBottomBar.pauseBtn.selected = !_canAppraise;
}
- (void)setRunViewText:(NSString *)string andIcon:(NSString *)url andshowStyle:(NSInteger)showStyle{
    [self.autoRunView addAnimationText:string andIcon:url andshowStyle:showStyle];
}
- (void)showRunView{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addSubview:self.autoRunView];
        [self.autoRunView startAnimation];
    });
    
}

- (void)catchImage:(UIImage *)image {
    
    [_claimOrderListView catchImage:image];
}

- (void)updateOrderCountAdd {
    self.orderNumLabel.hidden = NO;
    NSInteger count = [self.orderNumLabel.text integerValue];
    count ++;
    self.orderNumLabel.text = @(count).stringValue;
    self.orderBtn.hidden = self.orderNumLabel.hidden;
    
}

- (void)updateOrderCount:(NSInteger)count {
    self.orderNumLabel.hidden = count<=0;
    self.orderBtn.hidden = self.orderNumLabel.hidden;
    self.orderNumLabel.text = @(count).stringValue;

}

- (void)setCoverImage:(NSString *)url {
    [self.coverView setCoverImage:url];
}
- (void)userEnterRoom:(NSNotification *)noti {
    
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
                    DDLogDebug(@"进入没有拿到信息 %@",error);
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
                NSDictionary *dic = [ext.roomExt mj_JSONObject];
                
                if (dic) {
//                    NSInteger userTitleLevel = [dic[@"userTitleLevel"] integerValue];
                    msg.chartlet = dic[@"userTitleLevelIcon"];


                    if (dic[@"userEnterEffect"]) {
                        msg.enter_effect = dic[@"userEnterEffect"];
                        msg.levelImg = dic[@"levelImg"];
                        if ([msg.enter_effect integerValue]>0) {
                            [self addComeInMessage:msg];
                        }
                    }
                    if (self.type>0) {
                        JHMessageExtModel *extmodel = [JHMessageExtModel mj_objectWithKeyValues:dic];
                        if (extmodel.userTycoonLevel) {
                            [JHSVGAAnimationView showToView:self];
                        }
                    }
                    
//                    else {
//                        if (userTitleLevel>=5)
//                        {
//                            [self addComeInMessage:msg];
//                        }
//                    }
                    
                }
                if (self.type == 0) {
                    return;
                }
                
//                [self addMessages:@[message]];
                [self.chatView addCommonComeInMessages:message];
                
                //                [self addAnimationMessage:msg];
                
            }];
        }
    }
    
}

- (void)makeUpEndPage {
    self.endPageView.model = self.anchorInfoModel;
    [self.viewController.view addSubview:self.endPageView];
    self.endPageView.frame = self.viewController.view.bounds;
    [self updateCloseRoomButton];
}
- (void)addAnimationMessage:(JHSystemMsg *)msg {
    //    [self addSubview:self.systemMsgAnimationView];
    self.systemMsgAnimationView.bottom = self.chatView.top-10;
    [self.systemMsgAnimationView comeInActionWithModel:msg];
}

- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    [self.chatView addMessages:messages];
}

- (void)addComeInMessage:(JHSystemMsg *)msg {
    //-->leak yaoyao
    if (self.type > 0) //鉴定师不显示
    {
        self.comeInAnimationView.bottom = self.chatView.top-50;
        [self.comeInAnimationView comeInActionWithModel:msg];

    }
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
    [self.likeView fire666];
}

- (void)updateNetStatus:(NIMNetCallNetStatus)status
{
    [self.netStatusView refresh:status];
    [self.netStatusView sizeToFit];
}

- (void)updateConnectorCount:(NSInteger)count
{
//    [self.actionView updateInteractButton:count];
    self.customBottomBar.doteLabel.text = @(count).stringValue;
}

- (void)refreshChatroom:(NIMChatroom *)chatroom
{
    _roomId = chatroom.roomId;
    [self.infoView refreshWithChatroom:chatroom];
    
    NSString *placeHolder = [NSString stringWithFormat:@"当前直播间ID:%@",chatroom.roomId];
    placeHolder = @"说点什么";
    NTESGrowingInternalTextView *textView = self.textInputView.textViewnew;
    textView.editable = YES;
    textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}
- (void)refreshChannel:(ChannelMode*)channel{
    [self.infoView refreshWithChannel:channel];
}

-(void)updateRoleType:(JHLiveRole)roleType{
    
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
    if (self.isAnchor){
        NTESLiveBypassView *bypassView = [self bypassViewWithUid:uid];
        [bypassView updateRemoteView:yuvData width:width height:height];
        if (_lastRemoteViewSize.width != width || _lastRemoteViewSize.height != height) {
            _lastRemoteViewSize = CGSizeMake(width, height);
            [self setNeedsLayout];
        }
    }else{
        
        
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
    
}
- (void)updateBeautify:(BOOL)isBeautify
{
    [self.actionView updateBeautify:isBeautify];
}
- (void)updateSendRedpacketButton:(BOOL)isOn{
  
}
- (void)updateGuessButton:(BOOL)isOn{
    
}
- (void)updateGuessButtonSelect:(BOOL)isSelect{
    
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

- (void)reloadAudienceData:(NSMutableArray *)array {
    [self.audienceListView reloadData:array];
}
#pragma mark - Action
- (void)showOrderList:(UIButton *)btn {
    if (self.isAnchor) {
        [self addSubview:self.claimOrderListView];
        [self.claimOrderListView showAlert];
        return;
    }
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            if (result&&self.delegate) {
                [self.delegate onAgainEnterChatRoom];
            }
            
        }];
        return;
    }
    
    self.orderListView.isAndience = YES;
    //    self.orderNumLabel.hidden = YES;
    //    [self addSubview:self.orderListView];
    //    [self.orderListView showAlert];
    JHOrderListViewController * orderList = [[JHOrderListViewController alloc]init];
    [self.viewController.navigationController pushViewController:orderList animated:YES];
}
- (void)startLive:(id)sender
{
    [self.startLiveButton setTitle:@"初始化中，请等待..." forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeLive sender:self.startLiveButton];
    }
}


- (void)onClose:(id)sender
{
    [self endEditing:YES];
    if (self.isAnchor) {
        if ([self.delegate respondsToSelector:@selector(onCloseLiving)]) {
            [self.delegate onCloseLiving];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(onClosePlaying)]) {
            [self.delegate onClosePlaying];
        }
    }
    
}

//- (void)stopBypassing:(id)sender
//{
//    [self switchToBypassExitConfirmUI];
//}

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

    
        
    self.auctionWeb.bottom = self.bottomBar.top;
    [self setChatViewLayout];
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

    _closeRoomButton.frame = CGRectMake(ScreenW-60, UI.statusBarHeight, 60, 60);
    _closeRoomButton.centerY = self.infoView.centerY;
    
    self.saleGuideBtn.left = 15;
    self.saleGuideBtn.top = self.infoView.bottom+10;
    self.saleGuideBtn.height = 25;
    
    self.commentBtn.left = self.saleGuideBtn.right + 10;
    self.commentBtn.top = self.infoView.bottom+10;
    self.commentBtn.height = 25;
    
    self.autoRunView.top = UI.topSafeAreaHeight;

    [self layoutIfNeeded];
}


- (void)updateView {
    [self.viewController.view addSubview:self.closeRoomButton];
    [self.viewController.view bringSubviewToFront:self.closeRoomButton];
    //  [self.viewController.view insertSubview:self.glView atIndex:0];
    [self.viewController.view insertSubview:self.coverView atIndex:0];
    
    
}
-(void)updateCloseRoomButton{
    
    [self.viewController.view bringSubviewToFront:self.closeRoomButton];
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
            if (!self.isAnchor) {
                
                self.ownLikeCount++;
                [self fireLike];
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
            // 主播公告
        case NTESLiveActionTypeAnnouncement:
        {
#warning 添加公告入入口
        }
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
- (void)onTapChatView:(CGPoint)point
{
    if ([self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
    }
}

- (void)onClickeCellWithModel:(NTESMessageModel *)model {
    if ([self.delegate respondsToSelector:@selector(onShowInfoWithModel:)]) {
        [self.delegate onShowInfoWithModel:model];
    }
}
- (void)onClickeAnonymityUser{
    [self makeToast:@"此用户未登录，不能做任何操作" duration:1.5 position:CSToastPositionCenter];
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
    NTESGrowingInternalTextView *view = (UITextView *)self.textInputView.textViewnew;
    return view;
//    for (UIView *view in self.textInputView.subviews) {
//        if ([view isKindOfClass:[NTESGrowingTextView class]]) {
//            for (UIView * subview in view.subviews) {
//                if ([subview isKindOfClass:[UITextView class]]) {
//                    return subview;
//                }
//            }
//        }
//    }
//    return nil;
}

- (void)switchToWaitingUI
{
    DDLogInfo(@"switch to waiting UI");
    if (!self.isAnchor)
    {
        [self switchToLinkingUI];
    }
    else
    {
        self.startLiveButton.hidden = NO;
        [self.startLiveButton setTitle:@"开始直播" forState:UIControlStateNormal];
    }
    
    [self cleanBypassUI];
    
    //[self.bypassView refresh:nil status:NTESLiveBypassViewStatusNone];
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
    self.startLiveButton.hidden = YES;
    //    self.infoView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.netStatusView.hidden = !self.isAnchor;
    
    
    
    //更新bypass view
    [self refreshBypassUI];
    
    self.glView.hidden = YES;
    if (!self.isAnchor || [NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
        [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeBeautify disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeQuality disable:YES];
    }
    self.actionView.userInteractionEnabled = YES;
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:NO];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
    if (isBackLook) {
        self.chatView.hidden = YES;
    }
}

- (void)switchToLinkingUI
{
    DDLogInfo(@"switch to Linking UI");
    self.startLiveButton.hidden = YES;
    self.closeButton.hidden = NO;
    
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusLinking];
    self.coverView.hidden = NO;
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
}

- (void)switchToEndUI
{
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusFinished];
    
    [self makeUpEndPage];
    return;
    DDLogInfo(@"switch to End UI");
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusFinished];
    self.coverView.hidden = NO;
    
    self.netStatusView.hidden = YES;
    if (self.isAnchor) {
        self.closeButton.hidden = YES;
    }else{
        self.closeButton.hidden = NO;
        [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
        [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
    }
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
    
    [self.liveBypassView removeFromSuperview];
    self.liveBypassView=nil;
    [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj=nil;
    }];
    [_bypassViews removeAllObjects];
    _bypassViews=nil;
    
    NSMutableArray *connectorsOnMic = [NTESLiveManager sharedInstance].connectorsOnMic;
    [connectorsOnMic enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addBypassViewWithConnector:obj];
    }];
    
    return;
    
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
    
    self.startLiveButton.hidden = YES;
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
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
}

- (void)switchToBypassingUI:(NTESMicConnector *)connector
{
    DDLogInfo(@"switch to bypassing UI connector id %@",connector.uid);
    self.startLiveButton.hidden = YES;
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
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
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

//- (void)switchToBypassExitConfirmUI
//{
//    DDLogInfo(@"switch to bypass exit confirm UI");
//
//    [self.bypassView refresh:nil status:NTESLiveBypassViewStatusExitConfirm];
//    [self setNeedsLayout];
//}

- (void)setup
{
    
    [self addSubview:self.startLiveButton];
    [self addSubview:self.playControlView];
    //    [self addSubview:self.bypassNickList];
    [self addSubview:self.likeView];
    [self addSubview:self.presentView];
    [self addSubview:self.chatView];
    [self addSubview:self.systemMsgAnimationView];
    [self addSubview:self.comeInAnimationView];
    
    [self addSubview:self.auctionWeb];

    [self addSubview:self.audienceListView];
    [self addSubview:self.bottomBar];
    self.bottomBar.hidden = YES;
    [self addSubview:self.infoView];
    [self addSubview:self.textInputView];
    [self addSubview:self.saleGuideBtn];
    [self addSubview:self.commentBtn];
    [self adjustViewPosition];
    [self addSubview:self.stoneOrderBtn];
    [self addSubview:self.liveRoomListView];
    self.liveRoomListView.hidden = YES;
    self.liveRoomListView.layer.masksToBounds = YES;
    self.liveRoomListView.layer.cornerRadius = 4.0;
    self.customBottomBar.frame = CGRectMake(0,ScreenH-UI.bottomSafeAreaHeight-49 ,ScreenW,49);
    [self addSubview:self.customBottomBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userEnterRoom:) name:NotificationNameEnterUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOrderKeyBoard:) name:NotificationNameSendOrderKeyBoard object:nil];
    
    [self.chatView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.playControlView addObserver:self forKeyPath:@"playControlHidden" options:NSKeyValueObservingOptionNew context:nil];
    
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
    [JHRootController toNativeVC:@"JHWebViewController" withParam:@{@"urlString":LiveRoomSortURL(self.channel.channelLocalId)} from:@""];

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
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        CGFloat padding = 20.f;
        CGFloat bottom = (point.y < 0) ? self.chatView.top - point.y : self.chatView.top;
        self.presentView.bottom = bottom - padding;
    }
    

    
    if ([keyPath isEqualToString:@"playControlHidden"]) {
        BOOL hidden = [change[@"new"] boolValue];
        if (hidden)
        {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomBar.mj_y = self.height-UI.bottomSafeAreaHeight-49;
                [self setChatViewLayout];
                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomBar.mj_y = self.height-UI.bottomSafeAreaHeight-50-49;
                [self setChatViewLayout];
            }];
            
        }
    }
}

- (void)setChatViewLayout {
    if (_keyBoradHeight)
    {
        self.textInputView.bottom = self.height - _keyBoradHeight;
        self.chatView.bottom = self.textInputView.top;//公屏不上移
        [self bringSubviewToFront:self.textInputView];
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
    
    //    _bypassNickList.hidden = (nicks.count == 0);
    //    _bypassNickList.nicks = nicks;
}

- (void)showCommentView {
    if ([self.delegate respondsToSelector:@selector(onShowCommentListView:)]) {
        [self.delegate onShowCommentListView:self.commentBtn];
    }
    
}

- (void)showSaleGuide {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/zhinan.html");

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
        [self.commentBtn setTitle:[NSString stringWithFormat:@"买家评价 %@",commentCount] forState:UIControlStateNormal];
    //    [self.commentCount];
}

- (void)setCanAuction:(NSInteger)canAuction {
    _canAuction = canAuction;
    self.bottomBar.canAuction = canAuction;
}

- (void)setType:(JHAnchorLiveType)type {
    _type = type;
    
    //TODO : 这里之前主播和观众共用一个view  所以逻辑多 ，定制这版在这里可以删掉冗余的 2020.9.12
    self.bottomBar.channel = self.channel;
    if (_type >= 1) {
        self.infoView.platImage.hidden = YES;
        if (self.isAnchor ) {
            if (_type == 1) {
                self.bottomBar.roleType = JHLiveRoleSaleAnchor;
                
            }
            
        }else
        {
            
            self.bottomBar.roleType = JHLiveRoleSaleAndience;
            [self addSubview:self.orderBtn];
            [self addSubview:self.orderNumLabel];
            [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.greaterThanOrEqualTo(@15);
                make.height.equalTo(@15);
                make.top.equalTo(self.orderBtn);
                make.leading.equalTo(self.orderBtn);
            }];
            
            
        }
    }else if (self.isAnchor){
        self.bottomBar.roleType = JHLiveRoleAnchor;
        [self addSubview:self.orderBtn];
        _orderBtn.mj_y = 200;
        [self addSubview:self.orderNumLabel];
        [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.greaterThanOrEqualTo(@15);
            make.height.equalTo(@15);
            make.top.equalTo(self.orderBtn);
            make.leading.equalTo(self.orderBtn);
        }];
        
        
    }
    
    if (_type == 0) {
        if (!self.isAnchor) {
            if ([CommHelp isFirstInLiveRoom])
            {
                [self addSubview:self.liveRoomGuidanceView];
                
            }
            
        }
        self.infoView.platImage.hidden = NO;
    }else {
        if (!_isAnchor) {
            self.saleGuideBtn.hidden = NO;
            self.commentBtn.hidden = NO;
            
            if ([CommHelp isFirstForName:@"isFirstInSaleLiveRoom"]) {
                NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"JHSellRoomGuidenceView" owner:nil options:nil];
                JHSellRoomGuidenceView *sellGuidanceView = arr.firstObject;
                sellGuidanceView.saleGuideBtn = self.saleGuideBtn;
                sellGuidanceView.frame = self.bounds;
                [self addSubview:sellGuidanceView];
                
            }
            
        }
    }
    [self reloadAnctionWeb];
    
    self.bottomBar.isResaleRoom = NO;
     self.stoneOrderBtn.hidden = YES;
    if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRestoreStone])
    {
        self.bottomBar.isResaleRoom = YES;
    }else if ([self.channel.channelCategory isEqualToString:JHRoomTypeNameRoughStone]) {
           self.stoneOrderBtn.hidden = NO;
    }
       
 
    
}
- (void)setAnchorInfoModel:(JHAnchorInfoModel *)anchorInfoModel {
    _anchorInfoModel = anchorInfoModel;
    _endPageView.model = anchorInfoModel;
    
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameFollowStatus object:@(anchorInfoModel.isFollow)];
    [self.infoView updateStatus:anchorInfoModel.isFollow];
    NSLog(@"========%@  %@",[UserInfoRequestManager sharedInstance].user.customerId, [NSThread currentThread]);
    if ([[UserInfoRequestManager sharedInstance].user.customerId isEqualToString:anchorInfoModel.customerId]) {
//        [_infoView hiddenCareBtn];
    }
    _infoView.hidden = NO;
    
}
- (void)setCareDelegate:(id<JHLiveEndViewDelegate>)careDelegate {
    _careDelegate = careDelegate;
    self.infoView.delegate = careDelegate;
}

-(void)setLinkNum:(NSInteger)linkNum{
    
//    [_bottomBar setLinkNum:linkNum];
    self.customBottomBar.doteLabel.text = @(linkNum).stringValue;
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
        _stoneOrderBtn.frame = CGRectMake(ScreenW-80, 200-33, 80, 33);
        _stoneOrderBtn.type = 2;
        [_stoneOrderBtn.button setTitle:@" 原石订单" forState:UIControlStateNormal];
        [_stoneOrderBtn.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _stoneOrderBtn.button.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        [_stoneOrderBtn addTarget:self action:@selector(stoneOrderList) forControlEvents:UIControlEventTouchUpInside];
        _stoneOrderBtn.hidden = YES;

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
        _auctionWeb = web;
        JH_WEAK(self)
        web.resetSizeWebView = ^(OpenWebModel * _Nonnull model) {
            JH_STRONG(self)
            self.auctionWeb.bottom = self.bottomBar.top;
            self.auctionWeb.height = model.height;
            [self setChatViewLayout];
        };
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            self.auctionWeb.height = 80;
        //            self.auctionWeb.bottom = self.bottomBar.top;
        //
        //        });
    }
    
    return _auctionWeb;
}

- (JHRightArrowBtn *)saleGuideBtn {
    if (!_saleGuideBtn) {
        _saleGuideBtn = [[JHRightArrowBtn alloc] init];
        [_saleGuideBtn setTitle:@"购物指南" forState:UIControlStateNormal];
        [_saleGuideBtn resetRightArrowStyle:JHRightArrowStyleLight];
        _saleGuideBtn.hidden = YES;
        [_saleGuideBtn addTarget:self action:@selector(showSaleGuide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleGuideBtn;
}

- (JHRightArrowBtn *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[JHRightArrowBtn alloc] init];
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
        [_commentBtn resetRightArrowStyle:JHRightArrowStyleLight];
        _commentBtn.hidden = YES;
        [_commentBtn addTarget:self action:@selector(showCommentView) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _commentBtn;
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
        _orderListView.isAssistant =  NO;
        _orderListView.roleType = 1;
    }
    return _orderListView;
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
        
        //        if (self.isAnchor) {
        //            _orderBtn.hidden = NO;
        //
        //        }else {
        //            _orderBtn.hidden = YES;
        //
        //        }
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
        _jhpresentView = [[JHPresentView alloc] initWithFrame:CGRectMake(0., ScreenH-260-40-50, 0., 41.)];
        
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
    }
    return _endPageView;
}



- (JHLivePopAlertViews *)moreAlert {
    if (!_moreAlert) {
        _moreAlert = [JHLivePopAlertViews moreListAlert];
        _moreAlert.frame = CGRectMake(ScreenW - 180.f, ScreenH, 120.f, 136.f);
        _moreAlert.delegate = self;
    }
    return _moreAlert;
}

- (JHLivePopAlertViews *)hdAlert {
    if (!_hdAlert) {
        _hdAlert = [[NSBundle mainBundle] loadNibNamed:@"JHLivePopAlertViews" owner:nil options:nil].lastObject;
        
        _hdAlert.qualityDelegate =  (id<NTESVideoQualityViewDelegate>) self.delegate;
        _hdAlert.frame = CGRectMake(0, ScreenH, ScreenW, ScreenW/375.*140.);
        
    }
    return _hdAlert;
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
- (JHLiveBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[NSBundle mainBundle] loadNibNamed:@"JHLiveBottomBar" owner:nil options:nil].firstObject;
        _bottomBar.delegate = self;
        _bottomBar.roleType = self.isAnchor?JHLiveRoleAnchor:JHLiveRoleAudience;
        
    }
    
    return _bottomBar;
}
- (JHVideoPlayControlView *)playControlView {
    if (!_playControlView) {
        _playControlView =[[JHVideoPlayControlView alloc]init];
        
        
    }
    
    return _playControlView;
}
- (JHAudienceListView *)audienceListView {
    return nil;
    if (!_audienceListView) {
        
        _audienceListView = [[JHAudienceListView alloc] initWithFrame:CGRectMake(ScreenW-(40*showCount+40), UI.statusBarHeight+10, 40*showCount, 35)];
    }
    return _audienceListView;
}
- (NTESLiveLikeView *)likeView
{
    if (!_likeView) {
        CGFloat width  = 50.f;
        CGFloat height = 300.f;
        _likeView = [[NTESLiveLikeView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//        _likeView.hidden = YES;
    }
    return _likeView;
}
- (UIButton *)startLiveButton
{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImageNormal = [[UIImage imageNamed:@"btn_round_rect_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"btn_round_rect_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_startLiveButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
        [_startLiveButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        [_startLiveButton setTitleColor:HEXCOLOR(0x238efa) forState:UIControlStateNormal];
        [_startLiveButton addTarget:self action:@selector(startLive:) forControlEvents:UIControlEventTouchUpInside];
        _startLiveButton.size = CGSizeMake(215, 46);
        _startLiveButton.center = self.center;
        _startLiveButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    }
    return _startLiveButton;
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

- (NTESLiveChatView *)chatView
{
    if (!_chatView) {
        CGFloat height = 160.f;
        CGFloat width  = ScreenW-100.;
        _chatView = [[NTESLiveChatView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _chatView.hidden = YES;
        _chatView.delegate = self;
        _chatView.isAnchor = self.isAnchor;
    }
    return _chatView;
}

- (NTESLiveActionView *)actionView
{
    return nil;
    if (!_actionView) {
        _actionView = [[NTESLiveActionView alloc] initWithFrame:CGRectZero];
        [_actionView sizeToFit];
        //        CGFloat bottom = 54.f;
        //        _actionView.bottom = self.height - bottom;
        _actionView.delegate = self;
        _actionView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _actionView.hidden = YES;
        if ([NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
            [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        }
    }
    return _actionView;
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

- (NTESLiveCoverView *)coverView
{
    if (!_coverView) {
        _coverView = [[NTESLiveCoverView alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, self.mj_h)];
        _coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _coverView.hidden = YES;
        _coverView.delegate = self;
        
    }
    return _coverView;
}

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
        bypassView.isAnchor = _isAnchor;
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
        
        
        // [self insertSubview:bypassView belowSubview:self.actionView];
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
        //linkWindowsClose
                
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


- (void)sendRedPacketAction:(UIButton *)btn {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    
    JHMakeRedpacketController *vc = [[JHMakeRedpacketController alloc] init];
    vc.liveRoomChannelId = self.channel.channelLocalId;
    vc.channel = self.channel;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

- (void)onAnchorTapUserAction {
    //TODO:yaoyao宝友操作
    
    JHMainLiveRoomTabView* mainLiveRoomTabView = [[JHMainLiveRoomTabView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
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
- (void)onAnchorTapInsaleAction {
    //TODO:yaoyao在售

    JHMainRoomOnSaleStoneView* mrOnSaleView = [[JHMainRoomOnSaleStoneView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
    mrOnSaleView.tag = kViewTagResaleView;
    mrOnSaleView.channelId = self.channel.channelLocalId;
    [self addSubview:mrOnSaleView];
    [mrOnSaleView drawSubviewsWithPageType:JHMainLiveRoomTabTypeResaleStoneTab];
    [mrOnSaleView showAlert];
}

- (void)popAuctionListAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(onShowAuctionListView:)]) {
        [_delegate onShowAuctionListView:btn];
    }
}

- (void)pressLikeAction:(UIButton *)likeCountBtn {
    //更新点赞数量
    [self onActionType:NTESLiveActionTypeLike sender:nil];
}

- (void)claimOrderListAction {
    if (self.isAnchor) {
        [self addSubview:self.claimOrderListView];
        [self.claimOrderListView showAlert];
        return;
    }
    
}
- (void)canAppraiseAction:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(onCanAppraiseAction:)]) {
        [_delegate onCanAppraiseAction:btn];
    }
}


- (void)stoneOrderList {
    //TODO:yaoyao原石订单
    
    JHLastSaleStoneView* lastSaleView = [[JHLastSaleStoneView alloc] initWithFrame:CGRectMake(0, ScreenH*(240/812.0), ScreenW, ScreenH - ScreenH*(240/812.0))];
    lastSaleView.channelCategory = self.channel.channelCategory;
    lastSaleView.tag = kViewTagStoneOrderView;
    [lastSaleView drawSubviewsByPagetype:JHLastSaleCellTypeBuyer channelId:self.channel.channelLocalId];
    [self addSubview:lastSaleView];
    [lastSaleView showAlert];
    
}
/**
 
 */
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
    if (![JHRootController isLogin]) {
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

- (void)moreAction {
    if (!_moreAlert) {
        [self addSubview: self.moreAlert];
    }
    [self.moreAlert showAlert];
    
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

- (void)onShanGouBtnAction{
    if ([self.delegate respondsToSelector:@selector(onShanGouBtnAction)]) {
        [self.delegate onShanGouBtnAction];
    }
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
        if([self.channel.canFlashPurchase isEqualToString:@"1"]){
            [arr addObject:@{@"title":@"订单",@"icon":@"live_room_more_order_icon"}];
        }
        [arr addObject:@{@"title":@"开播提醒",@"icon":@"startedtoRemind"}];
    }
    NSArray *arr1 = @[
    @{@"title":@"禁言",@"icon":@"live_room_more_mute"},
    @{@"title":@"分享",@"icon":@"live_room_more_share"},
    @{@"title":@"发红包",@"icon":@"live_room_more_redpacket_icon"}
    ];
    [arr addObjectsFromArray:arr1];
    CGFloat height = arr.count*34+6;
    CGFloat width = 79.0;
    CGFloat x = trailing - width/2.0;
    if (trailing + width/2.0 > ScreenW - 10) {
        x = ScreenW - 10 - width;
        [self.liveRoomListView.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.liveRoomListView.centerX + (trailing-x-width/2));
        }];
    }
    self.liveRoomListView.frame = CGRectMake(x,0, width, height);
    
    self.liveRoomListView.bottom = self.customBottomBar.top + 5;
    [self.liveRoomListView updateData:arr];
}
-(void)didSelectedItem:(JHLiveRoomListViewCellModel *)model;
{
    [self hiddenLiveRoomListView];
    NSString *title = model.title;
    if([title isEqualToString:@"禁言"])
    {
        if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
            [self.delegate onActionType:NTESLiveActionTypeMuteList sender:nil];
        }
    }else if([title isEqualToString:@"分享"])
    {
        [self shareAction];
    }else if([title isEqualToString:@"发红包"]){

        JHMakeRedpacketController *vc = [[JHMakeRedpacketController alloc] init];
        vc.liveRoomChannelId = self.channel.channelLocalId;
        vc.channel = self.channel;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }else if([title isEqualToString:@"开播提醒"]){
        [[JHSendLivingTipManeger shareManager] sendLivingTipManeger:self andChannelLocalId:self.channel.channelLocalId];
    }else if([title isEqualToString:@"订单"]){
        [self orderListAction];
    }else if([title isEqualToString:@"福袋"]){
        [self luckyBagAction];
    }
}
- (void)luckyBagAction{
    [self.luckyBagView show];
}
-(void)suggestAction
{
    if(_pushSuggestVCdelegate && [_pushSuggestVCdelegate respondsToSelector:@selector(pushSuggestVC:)])
    {
        [_pushSuggestVCdelegate pushSuggestVC:self];
    }
}
-(void)hiddenLiveRoomListView
{
    self.liveRoomListView.hidden = YES;
    self.moreBtn.selected = NO;
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hiddenPopAlert];
    [self hiddenLiveRoomListView];
    [self endEditing:YES];
    [self.viewController touchesBegan:touches withEvent:event];
    
}

- (void)hiddenPopAlert {
    [_moreAlert hiddenAlert];
    [_hdAlert hiddenAlert];
    [_presentBoxView hiddenAlert];
    [_claimOrderListView hiddenAlert];
    BaseView *view = [self viewWithTag:kViewTagStoneOrderView];
    if (view) {
        [view hiddenAlert];
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
    }
}

#pragma mark JHCustomizeAnchorBottomBarDelegate
- (void)sceneAction:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeCamera sender:sender];
    }
}
- (void)customorderListAction:(UIButton *)sender{
//    [self addSubview:self.orderListView];
//    [self.orderListView showAlert];
    JHCustomOrderView *orderview = [[JHCustomOrderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:orderview];
}
- (void)queueListAction:(UIButton *)sender{
    [self appraiseActionWithType:JHLiveRoleAnchor];//后面改成定制类型
}
- (void)soundAction:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeMute sender:sender];
    }
}
- (void)playOrPauseAction:(UIButton *)sender{
    if ([_delegate respondsToSelector:@selector(onCanAppraiseAction:)]) {
        [_delegate onCanAppraiseAction:sender];
    }
}
- (void)noticeAction:(UIButton *)sender{
   
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeAnnouncement sender:nil];
    }
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
        self.leftCustomizeOrder.isSeller = YES;
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
@end

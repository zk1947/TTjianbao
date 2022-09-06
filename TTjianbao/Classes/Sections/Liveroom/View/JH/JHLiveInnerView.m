//
//  JHLiveInnerView.m
//  TaodangpuAuction
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLiveInnerView.h"
#import "NTESLiveInnerView.h"
#import "NTESLiveChatView.h"
#import "NTESLiveLikeView.h"
#import "NTESLivePresentView.h"
#import "NTESLiveCoverView.h"
#import "NTESLiveroomInfoView.h"
#import "NTESTextInputView.h"
#import "NTESLiveManager.h"
#import "UIView+NTES.h"
#import "NTESLiveActionView.h"
#import "NTESTimerHolder.h"
#import "NTESLiveBypassView.h"
#import "NTESMicConnector.h"
#import "NTESGLView.h"
#import "NTESAnchorMicView.h"
#import "NTESNetStatusView.h"
#import "NTESCameraZoomView.h"
#import "NTESNickListView.h"
#import "JHAudienceListView.h"
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

@interface JHLiveInnerView()<NTESLiveActionViewDelegate,NTESTextInputViewDelegate,NTESTimerHolderDelegate,NTESLiveBypassViewDelegate,NTESLiveCoverViewDelegate,NTESLiveChatViewDelegate, JHLiveBottomBarDelegate,UIGestureRecognizerDelegate, JHAutoRunViewDelegate>{
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

@property (nonatomic, strong) UIButton *cameraButton;             //相机反转按钮

@property (nonatomic, copy)   NSString *roomId;                   //聊天室ID

@property (nonatomic, strong) NTESLiveroomInfoView *infoView;      //直播间信息视图
@property (nonatomic, strong) NTESTextInputView    *textInputView; //输入框
@property (nonatomic, strong) NTESLiveChatView     *chatView;      //聊天窗
@property (nonatomic, strong) NTESLiveActionView   *actionView;    //操作条
@property (nonatomic, strong) NTESLiveLikeView     *likeView;      //爱心视图
@property (nonatomic, strong) NTESLivePresentView  *presentView;   //礼物到达视图
@property (nonatomic, strong) NTESLiveCoverView    *coverView;     //状态覆盖层

@property (nonatomic, strong) NSMutableArray <NTESLiveBypassView *> *bypassViews;
@property (nonatomic, strong) NTESGLView           *glView;        //接收YUV数据的视图
@property (nonatomic, strong) NTESAnchorMicView    *micView;       //主播是音视频的时候的麦克风图
//@property (nonatomic, strong) NTESNickListView     *bypassNickList;  //互动直播昵称


@property (nonatomic, strong) NTESNetStatusView    *netStatusView;    //网络状态视图

@property (nonatomic, strong) NTESCameraZoomView   *cameraZoomView;

@property (nonatomic) BOOL isActionViewMoveUp;    //actionView上移标识

@property (nonatomic, assign) BOOL  isAnchor;

@property (nonatomic, strong) JHAudienceListView *audienceListView; //观众头像列表

@property (nonatomic, strong) JHLiveBottomBar *bottomBar;

@property (nonatomic, strong) JHLivePopAlertViews *moreAlert;

@property (nonatomic, strong) JHLivePopAlertViews *hdAlert;

@property (nonatomic, strong) JHSystemMsgAnimationView *systemMsgAnimationView;

@property (nonatomic,strong) JHAnchorActionView *anchorActionView;

@property (nonatomic,strong) JHPresentBoxView *presentBoxView;

@property (nonatomic,strong) JHPresentView *jhpresentView;

@property (nonatomic,strong) UIButton *orderBtn;
@property (nonatomic,strong) JHDoteNumberLabel *orderNumLabel;
@property (nonatomic,strong) JHSaleAnchorActionView *saleAnchorActionView;
@property (nonatomic,strong) JHOrderListView *orderListView;

@property (nonatomic,strong) JHClaimOrderListView *claimOrderListView;
@property (nonatomic,strong) JHLiveRoomGuidanceView *liveRoomGuidanceView;
@property (nonatomic,strong) JHAutoRunView *autoRunView;
@property (nonatomic, strong) JHRightArrowBtn *saleGuideBtn;
@property (nonatomic, strong) JHRightArrowBtn *commentBtn;

@end
@implementation JHLiveInnerView

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame
                        isAnchor:(BOOL)isAnchor
{
    self = [super initWithFrame:frame];
    if (self) {
        _roomId = chatroomId;
        _isAnchor = isAnchor;
        [self setup];
        if (!_isAnchor && !isBackLook) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NTESAudienceLiveViewController * vc=(NTESAudienceLiveViewController*)self.viewController;
                    if (vc.currentUserRole==CurrentUserRoleApplication||vc.currentUserRole==CurrentUserRoleLinker) {
                        return ;
                    }
                    if (self.type == 0) {
                    //    [self showBubbleView:JHBubbleViewTypeFreeGift];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                                 [self showBubbleView:JHBubbleViewTypeShare];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (!self.anchorInfoModel.isFollow) {
                                    [self showBubbleView:JHBubbleViewTypeFollow];
                                }
                            });


                        });

                    }else {
                        [self showBubbleView:JHBubbleViewTypeShare];
                    }
                });
            
        }
        
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
    [_micView removeObserver:self forKeyPath:@"hidden"];
    [_playControlView removeObserver:self forKeyPath:@"playControlHidden"];
    [_auctionWeb removeObserver:self forKeyPath:@"frame"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_autoRunView stopAnimation];
    [_autoRunView removeFromSuperview];
    _autoRunView = nil;
    
}
- (void)handleDoubleTap:(UIGestureRecognizer *)gest {
    [self onActionType:NTESLiveActionTypeLike sender:gest.view];
}

#pragma mark - Public
//- (void)setLocalFullScreen:(BOOL)localFullScreen {
//    _localFullScreen = localFullScreen;
//    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
//    if (_liveBypassView && [_liveBypassView.uid isEqualToString:myUid]) {
//        self.glView.hidden = NO;
//
//        if (localFullScreen) {
//            self.localDisplayView.frame = self.bounds;
//            [self.glView addSubview:self.localDisplayView];
//
//        }else {
//            for (UIView *v in _glView.subviews) {
//                if (v == self.localDisplayView) {
//                    [v removeFromSuperview];
//                }
//            }
//           // self.glView.hidden = YES;
//
//        }
//    }else {
//        self.glView.hidden = YES;
//    }
//
//}

- (void)reloadAnctionWeb {
    if (self.type>0) {
        [self.auctionWeb loadWebURL:AuctionURL(self.type>0, self.isAnchor, self.type == 2)];
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
    if (_isAnchor) {
        self.bottomBar.pauseActionBtn.selected = !canAppraise;
    } else {
        if (canAppraise) {
            self.bottomBar.pauseAppraiseBtn.hidden = YES;
        }else{
            self.bottomBar.pauseAppraiseBtn.hidden = NO;
            
        }
    }
}
- (void)showRunViewWithText:(NSString *)string {
    [self addSubview:self.autoRunView];
    self.autoRunView.text = string;
    [self.autoRunView startAnimation];
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
                message.text = @"进入直播间";
                NIMChatroomMember *mm = members.firstObject;
                JHSystemMsg *msg = [[JHSystemMsg alloc] init];
                msg.nick = mm.roomNickname?:@"";
                msg.content = message.text;
                msg.avatar = mm.roomAvatar?:@"";
                if (message.messageExt) {
                    NIMMessageChatroomExtension *ext = message.messageExt;
                    ext.roomAvatar = mm.roomAvatar;
                    ext.roomNickname = mm.roomNickname?:@"";
                    message.messageExt = ext;
                }else {
                    NIMMessageChatroomExtension *ext = [[NIMMessageChatroomExtension alloc] init];
                    ext.roomAvatar = mm.roomAvatar;
                    ext.roomNickname = mm.roomNickname?:@"";
                    message.messageExt = ext;
                    
                }
                
                [self addMessages:@[message]];
                [self addAnimationMessage:msg];
                
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
    [self addSubview:self.systemMsgAnimationView];
    self.systemMsgAnimationView.bottom = self.chatView.top-10;
    [self.systemMsgAnimationView comeInActionWithModel:msg];
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
    [self.infoView refreshWithChatroom:chatroom];
    
    NSString *placeHolder = [NSString stringWithFormat:@"当前直播间ID:%@",chatroom.roomId];
    placeHolder = @"说点什么";
    NTESGrowingTextView *textView = self.textInputView.textView;
    textView.editable = YES;
    textView.placeholderAttributedText = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSFontAttributeName:textView.font,NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
}
- (void)refreshChannel:( ChannelMode*)channel{
    [self.infoView refreshWithChannel:channel];
}

- (void)updateRoleType:(JHLiveRole)roleType{
    if (self.type == 1) {
        _anchorActionView.hidden = YES;
        return;
        
    }
    _bottomBar.roleType = roleType;
    
    if (roleType == JHLiveRoleAnchor) {
        _anchorActionView.hidden = NO;
        _anchorActionView.top = ScreenH-BottomSafeArea-49- (ButtonHeight)*3;
        _anchorActionView.lightBtn.hidden = YES;
        
    }else if (roleType == JHLiveRoleLinker) {
        _anchorActionView.hidden = NO;
        _anchorActionView.muteBtn.hidden = YES;
        _anchorActionView.camaraBtn.hidden = YES;
        
    } else {
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
    if (![[LoginPageManager sharedInstance] isLogin]) {
        [[LoginPageManager sharedInstance] presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
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

- (void)onRotateCamera:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onActionType:sender:)]) {
        [self.delegate onActionType:NTESLiveActionTypeCamera sender:self.cameraButton];
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
    
    if (self.isVideo) {
        
        _anchorActionView.hidden = YES;
        _saleAnchorActionView.hidden = YES;
        [_playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-BottomSafeArea-50);
            make.height.offset(49);
        }];
        
        if (_playControlView.playControlHidden) {
            
            self.bottomBar.mj_y = self.height-BottomSafeArea-49;
        }
        else{
            
            self.bottomBar.mj_y = self.height-BottomSafeArea-50-49;
            
        }
        
        
    }else {
        [_playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@0);
        }];
        
        [_bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-BottomSafeArea);
            make.height.offset(49);
        }];
        
    }
    self.auctionWeb.bottom = self.bottomBar.top;
    [self layoutIfNeeded];
    [self setChatViewLayout];
//    if (_keyBoradHeight)
//    {
//        self.textInputView.bottom = self.height - _keyBoradHeight;
//        self.chatView.bottom = self.textInputView.top;
//        [self bringSubviewToFront:self.textInputView];
//    }
//    else
//    {
//        CGFloat rowHeight = 35.f;
//        self.textInputView.bottom = self.height + 44.f;
//        if (_isActionViewMoveUp) {
//            _chatView.bottom = self.height - 3 * rowHeight -  30.f;
//        }
//        else
//        {
//            _chatView.bottom = self.height - 49 - BottomSafeArea-self.auctionWeb.height;
//            _chatView.bottom = self.bottomBar.top-10-self.auctionWeb.height;
//        }
//    }
    
    CGFloat padding = 20.f;
    CGFloat delta = self.chatView.tableView.contentOffset.y;
    CGFloat bottom  = (delta < 0) ? self.chatView.top - delta : self.chatView.top;
    self.presentView.bottom = bottom - padding;
    
    self.likeView.bottom = self.bottomBar.top+10;
    self.likeView.right  = self.width - 10.f;
    
    self.glView.size = self.size;
    
    //    self.bypassNickList.frame = CGRectMake(_roomIdLabel.right + padding,
    //                                           _infoView.top,
    //                                           _closeButton.left - padding*2 - _infoView.right,
    //                                           _bypassNickList.estimationHeight);
    self.netStatusView.centerX = self.width * .5f;
    self.netStatusView.top = 70.f;
    
    self.actionView.left = 0;
    self.actionView.bottom = self.height - 10.f;
    self.actionView.width = self.width;
    
    //    //互动直播连麦布局
    //    bottom = 10.0f + 32.0 + 8.0;
    //    __weak typeof(self) weakSelf = self;
    //
    //        CGFloat height = (self.height - (self.closeButton.bottom + 8.0) - bottom - 2*8.0)/3;
    //        CGFloat width = height / 1.7;
    //        [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //            obj.frame = CGRectMake(weakSelf.width - padding - width,
    //                                   weakSelf.height - bottom - (height + 8.0) * (idx + 1),
    //                                   width,
    //                                   height);
    //        }];
    
//    CGFloat height = 190;
//    CGFloat width = 150;
//    if (_bypassViews.count) {
//        NTESLiveBypassView *  passView= (NTESLiveBypassView *)[_bypassViews objectAtIndex:0];
//        passView.frame = CGRectMake(ScreenW-width-20,
//                                    StatusBarH+80,
//                                    width,
//                                    height);
//        self.liveBypassView = passView;
//
//    }
    
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(StatusBarH+10);
        make.height.equalTo(@40);
    }];
    _closeRoomButton.frame = CGRectMake(ScreenW-60, StatusBarH, 60, 60);
    
    [self.saleGuideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self.infoView.mas_bottom).offset(10);
        make.height.equalTo(@(25));
        
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.saleGuideBtn.mas_trailing).offset(10);
        make.top.equalTo(self.saleGuideBtn);
        make.height.equalTo(@(25));
    }];
    
    if (self.type == 0 || _isAnchor) {
        self.autoRunView.top = self.infoView.bottom+10;
        
    }else {
        self.autoRunView.top = self.commentBtn.bottom+10;
        
    }
    
    
    [self layoutIfNeeded];
    
    
    //    [self bringSubviewToFront:self.bypassNickList];
}

- (void)updateView {
    [self.viewController.view addSubview:self.closeRoomButton];
    [self.viewController.view bringSubviewToFront:self.closeRoomButton];
    [self.viewController.view insertSubview:self.glView atIndex:0];
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
//    if (self.type > 0)
    {
        if ([self.delegate respondsToSelector:@selector(onShowInfoWithModel:)]) {
            [self.delegate onShowInfoWithModel:model];
        }
        
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
    for (UIView *view in self.textInputView.subviews) {
        if ([view isKindOfClass:[NTESGrowingTextView class]]) {
            for (UIView * subview in view.subviews) {
                if ([subview isKindOfClass:[UITextView class]]) {
                    return subview;
                }
            }
        }
    }
    return nil;
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
    self.micView.hidden = [NTESLiveManager sharedInstance].type != NIMNetCallMediaTypeAudio;
    
    NIMChatroom *room = [[NTESLiveManager sharedInstance] roomInfo:self.roomId];
    if (!room) {
        DDLogInfo(@"chat room has not entered, ignore show playing UI");
        return;
    }
    self.startLiveButton.hidden = YES;
    //    self.infoView.hidden = NO;
    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.cameraButton.hidden = NO;
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
    self.cameraButton.hidden = YES;
    
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
        self.cameraButton.hidden = YES;
    }else{
        self.closeButton.hidden = NO;
        self.cameraButton.hidden = YES;
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
    self.cameraButton.hidden = NO;
    
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
    [self addSubview:self.micView];
    [self addSubview:self.playControlView];
    //    [self addSubview:self.bypassNickList];
    [self addSubview:self.likeView];
    [self addSubview:self.presentView];
    [self addSubview:self.chatView];
    [self addSubview:self.anchorActionView];
    [self addSubview:self.saleAnchorActionView];
    //[self addSubview:self.actionView];
    [self addSubview:self.audienceListView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.infoView];
    [self addSubview:self.auctionWeb];
    [self addSubview:self.textInputView];
    //    [self addSubview:self.closeButton];
    //    [self addSubview:self.netStatusView];
    //    [self addSubview:self.roomIdLabel];
    //    [self addSubview:self.cameraZoomView];
    //    [self addSubview:self.presentBoxView];
    [self addSubview:self.saleGuideBtn];
    [self addSubview:self.commentBtn];
    
    [self adjustViewPosition];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userEnterRoom:) name:NotificationNameEnterUser object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendOrderKeyBoard:) name:NotificationNameSendOrderKeyBoard object:nil];
    
    [self.chatView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.micView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.playControlView addObserver:self forKeyPath:@"playControlHidden" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
#warning 干嘛用的？？？？
    //    _timer = [[NTESTimerHolder alloc] init];
    //    [_timer startTimer:60 delegate:self repeats:YES];
    //
    //    self.userInteractionEnabled = YES;
    //    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopAlert)]];
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
    if ([keyPath isEqualToString:@"frame"]) {
        [self layoutIfNeeded];

    }
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        CGFloat padding = 20.f;
        CGFloat bottom = (point.y < 0) ? self.chatView.top - point.y : self.chatView.top;
        self.presentView.bottom = bottom - padding;
    }
    
    if ([keyPath isEqualToString:@"hidden"]) {
        BOOL hidden = [change[@"new"] boolValue];
        if (hidden)
        {
            [self.micView stopAnimating];
        }
        else
        {
            [self.micView startAnimating];
        }
    }
    
    if ([keyPath isEqualToString:@"playControlHidden"]) {
        BOOL hidden = [change[@"new"] boolValue];
        if (hidden)
        {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomBar.mj_y = self.height-BottomSafeArea-49;
                [self setChatViewLayout];
                
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^{
                self.bottomBar.mj_y = self.height-BottomSafeArea-50-49;
                [self setChatViewLayout];
            }];
            
        }
    }
}

- (void)setChatViewLayout {
    if (_keyBoradHeight)
    {
        self.textInputView.bottom = self.height - _keyBoradHeight;
        self.chatView.bottom = self.textInputView.top;
        [self bringSubviewToFront:self.textInputView];

    }
    else
    {
        self.textInputView.top = self.height;
        _chatView.bottom = self.bottomBar.top-10-self.auctionWeb.height;
    }
    
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
    vc.urlString = FILE_BASE_STRING(@"/jianhuo/zhinan.html");// @"https://napi.jianhuo.top/jianhuo/zhinan.html";
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - NTESLiveCoverViewDelegate
- (void)didPressBackButton
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - set

- (void)setCommentCount:(NSString *)commentCount {
    [self.commentBtn setTitle:[NSString stringWithFormat:@"买家评价 %@",commentCount] forState:UIControlStateNormal];
    //    [self.commentCount];
}

- (void)setCanAuction:(NSInteger)canAuction {
    _canAuction = canAuction;
    self.bottomBar.canAuction = canAuction;
}

- (void)setType:(NSInteger)type {
    _type = type;
    if (_type >= 1) {
        self.infoView.platImage.hidden = YES;
        _anchorActionView.hidden = YES;
        if (self.isAnchor || _type == 2) {
            if (_type == 1) {
                self.bottomBar.roleType = JHLiveRoleSaleAnchor;
                
            }else if (_type == 2) {
                self.bottomBar.roleType = JHLiveRoleSaleHelper;
                
            }
            
            if (self.isAnchor) {
                _saleAnchorActionView.hidden = NO;
            }else {
                _saleAnchorActionView.hidden = YES;
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
        _saleAnchorActionView.hidden = YES;
        self.bottomBar.roleType = JHLiveRoleAnchor;
        [self addSubview:self.orderBtn];
        _orderBtn.mj_y = self.anchorActionView.mj_y-50;
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
    
}
- (void)setAnchorInfoModel:(JHAnchorInfoModel *)anchorInfoModel {
    _anchorInfoModel = anchorInfoModel;
    _endPageView.model = anchorInfoModel;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameFollowStatus object:@(anchorInfoModel.isFollow)];
    NSLog(@"========%@  %@",[UserInfoRequestManager sharedInstance].user.customerId, [NSThread currentThread]);
    if ([[UserInfoRequestManager sharedInstance].user.customerId isEqualToString:anchorInfoModel.customerId]) {
        [_infoView hiddenCareBtn];
        [self updateRoleType:JHLiveRoleAnchor];
    }
    _infoView.hidden = NO;
    
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

- (JHWebView *)auctionWeb {
    if (!_auctionWeb) {
        JHWebView *web = [[JHWebView alloc] init];
        web.bottom = self.bottomBar.top;
        web.height = 0;
        web.left = 0;
        web.width = ScreenW-80;        
        _auctionWeb = web;
        [_auctionWeb addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:@"auctionWebHeight"];
        
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
        _saleGuideBtn.hidden = YES;
        [_saleGuideBtn addTarget:self action:@selector(showSaleGuide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleGuideBtn;
}

- (JHRightArrowBtn *)commentBtn {
    if (!_commentBtn) {
        _commentBtn = [[JHRightArrowBtn alloc] init];
        [_commentBtn setTitle:@"" forState:UIControlStateNormal];
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
        _autoRunView = [[JHAutoRunView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.infoView.frame)+10, ScreenW, 32)];
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
        _orderListView.isAssistant = self.type == 2;
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
        _presentBoxView = [[JHPresentBoxView alloc] initWithFrame:CGRectMake(0., ScreenH, ScreenW, 260.+BottomSafeArea)];
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
        _anchorActionView = [[JHAnchorActionView alloc] initWithFrame:CGRectMake(ScreenW-ButtonHeight, ScreenH-BottomSafeArea-49- (ButtonHeight)*4, ButtonHeight+10, (ButtonHeight)*4)];
        _anchorActionView.delegate = self;
        _anchorActionView.hidden = YES;
        
    }
    return _anchorActionView;
}

- (  JHSaleAnchorActionView *)saleAnchorActionView {
    if (!_saleAnchorActionView) {
        _saleAnchorActionView = [[JHSaleAnchorActionView alloc] initWithFrame:CGRectMake(ScreenW-ButtonHeight, ScreenH-BottomSafeArea-49- (ButtonHeight)*2, ButtonHeight+10, (ButtonHeight)*2)];
        _saleAnchorActionView.delegate = self;
        _saleAnchorActionView.hidden = YES;
        
    }
    return _saleAnchorActionView;
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
        
        _audienceListView = [[JHAudienceListView alloc] initWithFrame:CGRectMake(ScreenW-(40*showCount+40), StatusBarH+10, 40*showCount, 35)];
    }
    return _audienceListView;
}

- (UIButton *)startLiveButton
{
    if (!_startLiveButton) {
        _startLiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImageNormal = [[UIImage imageNamed:@"btn_round_rect_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        UIImage *backgroundImageHighlighted = [[UIImage imageNamed:@"btn_round_rect_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
        [_startLiveButton setBackgroundImage:backgroundImageNormal forState:UIControlStateNormal];
        [_startLiveButton setBackgroundImage:backgroundImageHighlighted forState:UIControlStateHighlighted];
        [_startLiveButton setTitleColor:UIColorFromRGB(0x238efa) forState:UIControlStateNormal];
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
        _textInputView = [[NTESTextInputView alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        _textInputView.delegate = self;
        _textInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _textInputView.hidden = YES;
        NTESGrowingTextView *textView = _textInputView.textView;
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

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraButton.tag = NTESLiveActionTypeCamera;
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_rotate_n"] forState:UIControlStateNormal];
        [_cameraButton setImage:[UIImage imageNamed:@"icon_camera_rotate_p"] forState:UIControlStateHighlighted];
        [_cameraButton sizeToFit];
        [_cameraButton addTarget:self action:@selector(onRotateCamera:) forControlEvents:UIControlEventTouchUpInside];
        _cameraButton.size = CGSizeMake(44, 44);
        _cameraButton.top = 5.f;
        _cameraButton.right = _closeButton.left - 10.f;
        
    }
    return _cameraButton;
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

- (NTESAnchorMicView *)micView
{
    if (!_micView) {
        _micView = [[NTESAnchorMicView alloc] initWithFrame:self.bounds];
        _micView.hidden = YES;
    }
    return _micView;
}

//- (NTESNickListView *)bypassNickList {
//    if (!_bypassNickList) {
//        _bypassNickList = [[NTESNickListView alloc] initWithFrame:CGRectZero];
//    }
//    return _bypassNickList;
//}
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
                                      StatusBarH+80,
                                      width,
                                      height);
        self.liveBypassView = bypassView;
        
        
        // [self insertSubview:bypassView belowSubview:self.actionView];
        [self.viewController.view addSubview:bypassView];
        
        ret = bypassView;
        [self layoutIfNeeded];
        NSLog(@"--zgn-- 添加bypass view:[%@]", bypassView.uid);
    }
    return ret;
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
- (void)orderListAction {
    
    [self addSubview:self.orderListView];
    [self.orderListView showAlert];
    
}
- (void)shareAction {
    if (![[LoginPageManager sharedInstance] isLogin]) {
        [[LoginPageManager sharedInstance] presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            
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
    if (![[LoginPageManager sharedInstance] isLogin]) {
        [[LoginPageManager sharedInstance] presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            
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
    if (![[LoginPageManager sharedInstance] isLogin]) {
        [[LoginPageManager sharedInstance] presentLoginVCWithTarget:self.viewController complete:^(BOOL result) {
            
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
    [self endEditing:YES];
    [self.viewController touchesBegan:touches withEvent:event];
    
}

- (void)hiddenPopAlert {
    [_moreAlert hiddenAlert];
    [_hdAlert hiddenAlert];
    [_presentBoxView hiddenAlert];
    [_claimOrderListView hiddenAlert];
    [self endEditing:YES];
}


#pragma mark - JHAutoRunViewDelegate

- (void)operateLabel:(JHAutoRunView *)autoLabel animationDidStopFinished:(BOOL)finished {
    [_autoRunView removeFromSuperview];
    _autoRunView = nil;
}


@end

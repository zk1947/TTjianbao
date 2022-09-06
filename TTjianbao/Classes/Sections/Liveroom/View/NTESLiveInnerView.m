//
//  NTESLiveInnerView.m
//  TTjianbao
//
//  Created by chris on 16/4/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

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


@interface NTESLiveInnerView()<NTESLiveActionViewDelegate,NTESTextInputViewDelegate,NTESTimerHolderDelegate,NTESLiveBypassViewDelegate,NTESLiveCoverViewDelegate,NTESLiveChatViewDelegate>{
    CGFloat _keyBoradHeight;
    NTESTimerHolder *_timer;
    CALayer *_cameraLayer;
    CGSize _lastRemoteViewSize;
}

@property (nonatomic, strong) UIButton *startLiveButton;          //开始直播按钮
@property (nonatomic, strong) UIButton *closeButton;              //关闭直播按钮
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
@property (nonatomic, strong) NTESNickListView     *bypassNickList;  //互动直播昵称
@property (nonatomic, strong) UILabel              *roomIdLabel;      //房间ID

@property (nonatomic, strong) NTESNetStatusView    *netStatusView;    //网络状态视图

@property (nonatomic, strong) NTESCameraZoomView   *cameraZoomView;

@property (nonatomic) BOOL isActionViewMoveUp;    //actionView上移标识

@property (nonatomic, assign) BOOL  isAnchor;

@property (nonatomic, strong) JHAudienceListView *audienceListView; //观众头像列表

@property (nonatomic, strong) JHLiveBottomBar *bottomBar;

@end

@implementation NTESLiveInnerView

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame
                        isAnchor:(BOOL)isAnchor
{
    self = [super initWithFrame:frame];
    if (self) {
        _roomId = chatroomId;
        _isAnchor = isAnchor;
        [self setup];
    }
    return self;
}


- (void)dealloc{
    [_chatView.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [_micView removeObserver:self forKeyPath:@"hidden"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)addMessages:(NSArray<NIMMessage *> *)messages
{
    [self.chatView addMessages:messages];
}

- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages
{
    for (NIMMessage *message in messages) {
        [self.presentView addPresentMessage:message];
    }
}

- (void)resetZoomSlider;
{
    [self.cameraZoomView reset];
}

- (void)fireLike
{
    [self.likeView fireLike];
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

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                     uid:(NSString *)uid
{
//    NTESLiveBypassView *bypassView = [self bypassViewWithUid:uid];
//    [bypassView updateRemoteView:yuvData width:width height:height];
    
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor){
        NTESLiveBypassView *bypassView = [self bypassViewWithUid:uid];
        [bypassView updateRemoteView:yuvData width:width height:height];
        if (_lastRemoteViewSize.width != width || _lastRemoteViewSize.height != height) {
            _lastRemoteViewSize = CGSizeMake(width, height);
            [self setNeedsLayout];
        }
    }else{
        NIMChatroom *roomInfo = [[NTESLiveManager sharedInstance] roomInfo:self.roomId];
        if ([uid isEqualToString:roomInfo.creator]) {
            [self.glView render:yuvData width:width height:height];
        } else {
            NTESLiveBypassView *bypassView = [self bypassViewWithUid:uid];
            [bypassView updateRemoteView:yuvData width:width height:height];
            [bypassView updateRemoteView:yuvData width:width height:height];
        }
    }
}

- (void)updateBeautify:(BOOL)isBeautify
{
    [self.actionView updateBeautify:isBeautify];
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
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
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

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    _keyBoradHeight = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self layoutSubviews];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _keyBoradHeight = 0;
    [self layoutSubviews];
}

- (void)adjustViewPosition
{
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_keyBoradHeight)
    {
        self.textInputView.bottom = self.height - _keyBoradHeight;
        self.chatView.bottom = self.textInputView.top;
    }
    else
    {
        CGFloat rowHeight = 35.f;
        self.textInputView.bottom = self.height + 44.f;
        if (_isActionViewMoveUp) {
            _chatView.bottom = self.height - 3 * rowHeight -  30.f;
        }
        else
        {
            _chatView.bottom = self.height - rowHeight - 20.f;
        }
    }
    CGFloat padding = 20.f;
    CGFloat delta = self.chatView.tableView.contentOffset.y;
    CGFloat bottom  = (delta < 0) ? self.chatView.top - delta : self.chatView.top;
    self.presentView.bottom = bottom - padding;
    
    self.roomIdLabel.top = self.infoView.bottom + 10.f;
    self.roomIdLabel.left = 10.f;
    self.roomIdLabel.width = [self getRoomIdLabelWidth];
    
    self.likeView.bottom = self.actionView.top;
    self.likeView.right  = self.width - 10.f;

    self.glView.size = self.size;
    
    self.bypassNickList.frame = CGRectMake(_roomIdLabel.right + padding,
                                           _infoView.top,
                                           _closeButton.left - padding*2 - _infoView.right,
                                           _bypassNickList.estimationHeight);
    self.netStatusView.centerX = self.width * .5f;
    self.netStatusView.top = 70.f;
    
    self.actionView.left = 0;
    self.actionView.bottom = self.height - 10.f;
    self.actionView.width = self.width;
    
    //互动直播连麦布局
    bottom = 10.0f + 32.0 + 8.0;
    __weak typeof(self) weakSelf = self;
    if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        CGFloat width = (self.width - 8.0*4)/3;
        CGFloat height = width/1.7;
        [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(weakSelf.width - (width + 8.0) * (idx + 1),
                                   weakSelf.height - bottom - (height + 8.0),
                                   width,
                                   height);
        }];
        
    } else {
        CGFloat height = (self.height - (self.closeButton.bottom + 8.0) - bottom - 2*8.0)/3;
        CGFloat width = height / 1.7;
        [_bypassViews enumerateObjectsUsingBlock:^(NTESLiveBypassView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(weakSelf.width - padding - width,
                                   weakSelf.height - bottom - (height + 8.0) * (idx + 1),
                                   width,
                                   height);
        }];
    }
    
    if ([NTESLiveManager sharedInstance].orientation == NIMVideoOrientationLandscapeRight) {
        self.cameraZoomView.centerY = self.infoView.centerY;
        self.cameraZoomView.centerX = self.width * .5f;
        self.cameraZoomView.height = 22.f;
        self.cameraZoomView.width = 225.f;
    }
    else
    {
        self.cameraZoomView.top = self.roomIdLabel.bottom + 20.f;
        self.cameraZoomView.centerX = self.width * .5f;
        self.cameraZoomView.height = 22.f;
        self.cameraZoomView.width = self.width - 2 * 30.f;
    }
    
    
    [self bringSubviewToFront:self.bypassNickList];
}

#pragma mark - NTESLiveActionViewDelegate

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender
{
    switch (type) {
        case NTESLiveActionTypeLike:
            [self fireLike];
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


#pragma mark - NTESLiveChatViewDelegate
- (void)onTapChatView:(CGPoint)point
{
    if ([self.delegate respondsToSelector:@selector(onTapChatView:)]) {
        [self.delegate onTapChatView:point];
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
    UITextView *view = (UITextView *)self.textInputView.textView.textView;
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
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience)
    {
        [self switchToLinkingUI];
    }
    else
    {
        self.startLiveButton.hidden = NO;
        self.roomIdLabel.hidden = YES;
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
    self.infoView.hidden = NO;
    self.likeView.hidden = NO;
    self.chatView.hidden = NO;
    self.presentView.hidden = NO;
    self.actionView.hidden  = NO;
    self.cameraButton.hidden = NO;
    self.roomIdLabel.hidden = NO;
    self.netStatusView.hidden = [NTESLiveManager sharedInstance].role == NTESLiveRoleAudience;

    //更新bypass view
    [self refreshBypassUI];

    self.glView.hidden = YES;
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAudience || [NTESLiveManager sharedInstance].type == NIMNetCallMediaTypeAudio) {
        [self.actionView setActionType:NTESLiveActionTypeCamera disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeBeautify disable:YES];
        [self.actionView setActionType:NTESLiveActionTypeQuality disable:YES];
    }
    self.actionView.userInteractionEnabled = YES;
    [self.actionView setActionType:NTESLiveActionTypeInteract disable:NO];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateHighlighted];
}

- (void)switchToLinkingUI
{
    DDLogInfo(@"switch to Linking UI");
    self.startLiveButton.hidden = YES;
    self.closeButton.hidden = NO;
    self.cameraButton.hidden = YES;
    self.roomIdLabel.hidden = YES;

    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusLinking];
    self.coverView.hidden = NO;
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_n"] forState:UIControlStateNormal];
    [self.closeButton setImage:[UIImage imageNamed:@"icon_close_p"] forState:UIControlStateHighlighted];
}

- (void)switchToEndUI
{
    DDLogInfo(@"switch to End UI");
    [self.coverView refreshWithChatroom:self.roomId status:NTESLiveCoverStatusFinished];
    self.coverView.hidden = NO;
    self.roomIdLabel.hidden = YES;

    self.netStatusView.hidden = YES;
    if ([NTESLiveManager sharedInstance].role == NTESLiveRoleAnchor) {
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
    self.roomIdLabel.hidden = NO;

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
    self.roomIdLabel.hidden = NO;

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
    [self addSubview:self.glView];
    [self addSubview:self.micView];
    [self addSubview:self.bypassNickList];
    [self addSubview:self.likeView];
    [self addSubview:self.presentView];
    [self addSubview:self.chatView];
    [self addSubview:self.actionView];
    [self addSubview:self.infoView];
    [self addSubview:self.audienceListView];
    [self addSubview:self.textInputView];
    [self addSubview:self.bottomBar];
    [self addSubview:self.coverView];
    [self addSubview:self.closeButton];
    [self addSubview:self.netStatusView];
    [self addSubview:self.roomIdLabel];
    [self addSubview:self.cameraZoomView];
    [self adjustViewPosition];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.chatView.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.micView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew context:nil];
    _timer = [[NTESTimerHolder alloc] init];
    [_timer startTimer:60 delegate:self repeats:YES];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
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

- (CGFloat)getRoomIdLabelWidth
{
    CGRect rectTitle = [_roomIdLabel.text boundingRectWithSize:CGSizeMake(999, 30)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.f]}
        
                                                       context:nil];
    
    return rectTitle.size.width + 10.f;
//    CGFloat width = self.infoView.width;
//    if (rectTitle.size.width > self.infoView.width) {
//        width = rectTitle.size.width + 10.f;
//    }
//
//    return width;
}

- (void)updateUserOnMic
{
    NSMutableArray *nicks = [NSMutableArray array];
    [[NTESLiveManager sharedInstance].connectorsOnMic enumerateObjectsUsingBlock:^(NTESMicConnector * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *nickString = (obj.nick.length == 0 ? @"null" : obj.nick);
        [nicks insertObject:nickString atIndex:0];
    }];

    _bypassNickList.hidden = (nicks.count == 0);
    _bypassNickList.nicks = nicks;
}

#pragma mark - NTESLiveCoverViewDelegate
- (void)didPressBackButton
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Get

- (JHLiveBottomBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[NSBundle mainBundle] loadNibNamed:@"JHLiveBottomBar" owner:nil options:nil].firstObject;
        

    }
    
    return _bottomBar;
}

- (JHAudienceListView *)audienceListView {
    if (!_audienceListView) {
        _audienceListView = [[JHAudienceListView alloc] initWithFrame:CGRectMake(ScreenW-44-32*5, UI.statusBarHeight+10, 32*5, CGRectGetHeight(_infoView.frame))];
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
        CGFloat height = 85.f;
        CGFloat width  = 200.f;
        _chatView = [[NTESLiveChatView alloc] initWithFrame:CGRectMake(15, 0, width, height)];
        _chatView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _chatView.hidden = YES;
        _chatView.delegate = self;
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
        _coverView = [[NTESLiveCoverView alloc] initWithFrame:self.bounds];
        _coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _coverView.hidden = YES;
        _coverView.delegate = self;
    }
    return _coverView;
}

- (NTESLiveroomInfoView *)infoView
{
    if (!_infoView) {
        _infoView = [[NTESLiveroomInfoView alloc] initWithFrame:CGRectMake(10, UI.statusBarHeight+10, 0, 0)];
//        [_infoView sizeToFit];
        _infoView.hidden = YES;
        _infoView.delegate = self.careDelegate;
    }
    return _infoView;
}

- (UIButton *)closeButton
{
    if(!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"icon_live_close_wihte"] forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_live_close_wihte"] forState:UIControlStateHighlighted];
        [_closeButton addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        _closeButton.size = CGSizeMake(44, 44);
        _closeButton.top = UI.statusBarHeight;
        _closeButton.right = self.width;
    }
    return _closeButton;
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

- (NTESNickListView *)bypassNickList {
    if (!_bypassNickList) {
        _bypassNickList = [[NTESNickListView alloc] initWithFrame:CGRectZero];
    }
    return _bypassNickList;
}

- (UILabel *)roomIdLabel
{
    if (!_roomIdLabel) {
        _roomIdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _roomIdLabel.backgroundColor = HEXCOLORA(0x0,0.6);
        _roomIdLabel.textColor = HEXCOLOR(0xffffff);
        _roomIdLabel.font = [UIFont systemFontOfSize:9.f];
        _roomIdLabel.text =[NSString stringWithFormat:@"ID:%@",_roomId];
        _roomIdLabel.textAlignment = NSTextAlignmentCenter;
        _roomIdLabel.layer.masksToBounds = YES;
        _roomIdLabel.layer.cornerRadius = 8.f;
        CGRect rectTitle = [_roomIdLabel.text boundingRectWithSize:CGSizeMake(999, 30)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9.f]}
                                                context:nil];
        _roomIdLabel.height = rectTitle.size.height + 8.f ;
    }
    return _roomIdLabel;
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
        [self insertSubview:bypassView belowSubview:self.actionView];
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




@end

//
//  JHCustomizeAndienceInnerView.h
//  TTjianbao
//  Description:定制直播间<观众端View
//  Created by mac on 2019/7/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NTESLiveInnerView.h"
#import "JHLiveBottomBar.h"
#import "JHAnchorHomeView.h"
#import "NTESLiveBypassView.h"
#import "JHSystemMsgAnimationView.h"
#import"JHVideoPlayControlView.h"
#import "JHBubbleView.h"
#import "JHWebView.h"
#import "JHRightArrowBtn.h"
#import "NTESLiveChatView.h"
#import "JHStoneLiveView.h"
#import "JHNimNotificationBody.h"
#import "JHResaleLiveRoomStretchView.h"
#import "JHLiveRoomCustomBtnView.h"

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode, JHCustomizeAndienceInnerView;

@protocol JHCustomizeAndienceInnerViewDelegate<NSObject>
-(void)pushSuggestVC:(JHCustomizeAndienceInnerView *)jhAndienceInnerView ;
@end

typedef void(^ClickApraiseViewBlock)();
@interface JHCustomizeAndienceInnerView : UIControl
@property(nonatomic,weak) id<JHCustomizeAndienceInnerViewDelegate> pushSuggestVCDelegate;
@property (nonatomic, strong) UIView *localDisplayView;  //本地预览视图

@property (nonatomic,weak) id<NTESLiveInnerViewDelegate> delegate;

@property (nonatomic,weak) id<JHLiveEndViewDelegate> careDelegate;

@property (nonatomic,weak) id<NTESLiveInnerViewDataSource> dataSource;

@property (nonatomic, strong) JHVideoPlayControlView *playControlView;

@property (nonatomic, strong) NTESLiveChatView   *chatView;      //聊天窗;
@property (nonatomic,strong) JHLiveEndPageView *endPageView;


@property (nonatomic,assign) NSInteger linkNum;

@property (nonatomic,assign) NSInteger likeCount;
@property (nonatomic,assign) NSInteger ownLikeCount;

- (instancetype)initWithChannel:(ChannelMode *)channel
                           frame:(CGRect)frame
                        isAnchor:(BOOL)isAnchor;

- (void)refreshChatroom:(NIMChatroom *)chatroom;

- (void)refreshChannel:( ChannelMode*)channel;

- (void)addMessages:(NSArray<NIMMessage *> *)messages;

- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages;

- (void)addPresentModel:(JHSystemMsg *)present;
//直播间显示-鉴定师红包
- (void)appraiserRedPacketHidden:(BOOL)isHidden;
//打开鉴定师红包页
- (void)openAppraiserRedpacketPage;
//保存鉴定师红包数据
- (void)setAppraiseRedPacketData:(id)model;

- (void)fireLike;

- (void)resetZoomSlider;

- (CGFloat)getActionViewHeight;

- (void)updateNetStatus:(NIMNetCallNetStatus)status;

- (void)updateUserOnMic;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;

- (void)updateGuessButton:(BOOL)isOn;
- (void)updateGuessButtonSelect:(BOOL)isSelect;
- (void)updateFocusButton:(BOOL)isOn;

- (void)updateMirrorButton:(BOOL)isOn;

- (void)updateConnectorCount:(NSInteger)count;

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                     uid:(NSString *)uid;

- (void)switchToWaitingUI;

- (void)switchToPlayingUI;

- (void)switchToLinkingUI;

- (void)switchToEndUI;

- (void)switchToBypassStreamingUI:(NTESMicConnector *)connector;

- (void)switchToBypassingUI:(NTESMicConnector *)connector;

- (void)switchToBypassLoadingUI:(NTESMicConnector *)connector;

- (void)refreshBypassUI;

- (void)refreshBypassUIWithConnector:(NTESMicConnector *)connector;
-(void)starBubble;
-(void)showBubble:(NSString*)type;
-(void)showBubbleView:(JHBubbleViewType)bubbleType;
-(void)removeBubbleView:(JHBubbleViewType)tpye;
-(void)removeFollowBubble;
//- (void)switchToBypassExitConfirmUI;

- (void)reloadAudienceData:(NSMutableArray *)array;

/** 显示结束页 */
- (void)makeUpEndPage;

//更新按钮状态
-(void)updateRoleType:(JHLiveRole)roleType;
//更新按钮titile
- (void)updateBottomBarAppraiseButtonTitle:(JHLiveRole)roleType;

- (void)userEnterRoom:(NSString *)nick;
- (void)addAnimationMessage:(JHSystemMsg *)msg;

@property (nonatomic, strong) JHAnchorInfoModel *anchorInfoModel;

@property (nonatomic, strong) NTESLiveBypassView *liveBypassView;

@property (nonatomic, assign) BOOL isShowReporter;

@property (nonatomic, assign) BOOL localFullScreen;

- (void)setCoverImage:(NSString *)url;

- (void)updateGlView:(UIView*)view ;
- (void)clean;
-(void)updateCloseRoomButton:(UIView*)view;
- (void)updateOrderCountAdd;
- (void)updateOrderCount:(NSInteger)count;

/**
 * JHAudienceUserRoleType
 * 0 直播鉴定 1 直播卖货 2卖货助理
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isVideo;

- (void)catchImage:(UIImage *)image;

- (void)showRunViewWithText:(NSString *)string;

- (void)updateBackPlayUI;
@property (nonatomic, assign) BOOL canAppraise;
@property (nonatomic, assign)JHLiveRole roleType;
@property (nonatomic, copy) NSString *commentCount;
- (void)reloadAnctionWeb;
@property (nonatomic, strong) JHWebView *auctionWeb;
@property (nonatomic, assign) NSInteger canAuction;
@property (nonatomic, strong) JHRightArrowBtn *riskTestBtn;

- (void)cleanMessages;
- (void)stopPiaoPing;
- (void)showRegularIcon;
@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic, strong) StoneChannelMode *stoneChannel;


- (void)updateResaleAmount:(NSString *)price;
- (void)updateOfferPriceCount:(NSInteger)count;
- (void)updateOnsaleCount:(NSInteger)count;
- (void)updateActionButtonCount:(NSInteger)count type:(NSInteger)type;
//! 显示公告
- (void)displayAnnoucement:(UIImage *)announcementImage;
- (void)removeAnnoucement;

@property (nonatomic, strong) JHNimNotificationBody *countInfo;
@property (nonatomic, strong) JHDotButtonView *stoneOrderBtn;

@property (nonatomic, copy) JHActionBlock reSaleRoomHiddenActivity;

@property (nonatomic, strong) JHResaleLiveRoomStretchView *resaleLiveRoomTabView;

@property (nonatomic, strong) JHLiveBottomBar *bottomBar;
@property (nonatomic,strong) JHLiveRoomCustomBtnView *praiseBtnView;
@property(nonatomic,copy)ClickApraiseViewBlock clickApraiseViewBlock;
-(void)updatePraiseBtnViewWithWaitNum:(NSInteger)waitNum;

@end

NS_ASSUME_NONNULL_END


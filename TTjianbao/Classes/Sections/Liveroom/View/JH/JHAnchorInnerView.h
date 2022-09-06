//
//  JHAnchorInnerView.h
//  TTjianbao
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 Netease. All rights reserved.
//


#import "NTESLiveInnerView.h"
#import "JHLiveBottomBar.h"
#import "NTESLiveBypassView.h"
#import "JHSystemMsgAnimationView.h"
#import"JHVideoPlayControlView.h"
#import "JHBubbleView.h"
#import "JHWebView.h"
#import "JHClaimOrderListView.h"
#import "JHNimNotificationBody.h"
#import "JHAnchorActionView.h"
#import "JHLiveEndPageView.h"
#import "NTESLiveroomInfoView.h"
NS_ASSUME_NONNULL_BEGIN
@class JHAnchorInnerView;
@protocol JHAnchorInnerViewDelegate<NSObject>
-(void)pushSuggestVC:(JHAnchorInnerView *)jhAnchorInnerView ;
@end
@class ChannelMode;
@interface JHAnchorInnerView : UIControl
@property(nonatomic,weak) id<JHAnchorInnerViewDelegate> pushSuggestVCdelegate;
@property (nonatomic, strong) UIView *localDisplayView;  //本地预览视图

@property (nonatomic,weak) id<NTESLiveInnerViewDelegate> delegate;

@property (nonatomic,weak) id<JHLiveEndViewDelegate> careDelegate;

@property (nonatomic,weak) id<NTESLiveInnerViewDataSource> dataSource;

@property (nonatomic, strong) JHVideoPlayControlView *playControlView;

@property (nonatomic,strong) JHLiveEndPageView *endPageView;

@property (nonatomic, strong) JHLiveBottomBar *bottomBar;

@property (nonatomic, strong) NTESLiveroomInfoView *infoView;      //直播间信息视图

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


- (void)fireLike;

- (void)resetZoomSlider;

- (CGFloat)getActionViewHeight;

- (void)updateNetStatus:(NIMNetCallNetStatus)status;

- (void)updateUserOnMic;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;
- (void)updateSendRedpacketButton:(BOOL)isOn;
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

-(void)showBubbleView:(JHBubbleViewType)bubbleType;
-(void)removeBubbleView:(JHBubbleViewType)tpye;
//- (void)switchToBypassExitConfirmUI;

- (void)reloadAudienceData:(NSMutableArray *)array;

/** 显示结束页 */
- (void)makeUpEndPage;

//更新按钮状态
-(void)updateRoleType:(JHLiveRole)roleType;

- (void)userEnterRoom:(NSString *)nick;
- (void)addAnimationMessage:(JHSystemMsg *)msg;

@property (nonatomic, strong) JHAnchorInfoModel *anchorInfoModel;

@property (nonatomic, strong) NTESLiveBypassView *liveBypassView;

@property (nonatomic, assign) BOOL isShowReporter;

@property (nonatomic, assign) BOOL localFullScreen;

- (void)setCoverImage:(NSString *)url;

- (void)updateView;
-(void)updateCloseRoomButton;
- (void)updateOrderCountAdd;
- (void)updateOrderCount:(NSInteger)count;

/**
 0 直播鉴定 1 直播卖货 2卖货助理
 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isVideo;

- (void)catchImage:(UIImage *)image;

- (void)setRunViewText:(NSString *)string andIcon:(NSString *)url andshowStyle:(NSInteger)showStyle;
- (void)showRunView;

- (void)updateBackPlayUI;
@property (nonatomic, assign) BOOL canAppraise;
@property (nonatomic, assign)JHLiveRole roleType;
@property (nonatomic, copy) NSString *commentCount;
- (void)reloadAnctionWeb;
@property (nonatomic, strong) JHWebView *auctionWeb;
@property (nonatomic, assign) NSInteger canAuction;
@property (nonatomic,strong) JHClaimOrderListView *claimOrderListView;
@property (nonatomic, strong) ChannelMode *channel;

@property (nonatomic, strong) JHNimNotificationBody *countInfo;
- (void)updateActionButtonCount:(NSInteger)count type:(NSInteger)type;
@property (nonatomic, strong) JHDotButtonView *stoneOrderBtn;
@property (nonatomic, readonly) JHSaleAnchorActionView *saleAnchorActionView;

@end

NS_ASSUME_NONNULL_END


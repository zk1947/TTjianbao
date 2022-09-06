//
//  NTESLiveInnerView.h
//  TTjianbao
//  Description:Netease未用到
//  Created by chris on 16/4/4.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK/NIMSDK.h"
#import <NELivePlayerFramework/NELivePlayerFramework.h>
#import "NTESLiveViewDefine.h"
#import "JHLiveBottomBar.h"
@class NTESMessageModel;
@class NTESMicConnector;

@protocol NTESLiveInnerViewDelegate <NSObject>

- (BOOL)isPlayerPlaying;


- (void)onShanGouBtnAction;

@optional

- (void)onCloseLiving;
- (void)onClosePlaying;
- (void)onCloseBypassingWithUid:(NSString *)uid;
- (void)onActionType:(NTESLiveActionType)type sender:(id)sender; //点击InnerView上的按钮
- (void)didSendText:(NSString *)text;
- (void)onTapChatView:(CGPoint)point;
- (void)onAppraiseWithType:(NSInteger)stateType;
- (void)onCustomizeWithType:(JHLiveButtonStyle)stateType;
- (void)onRecycleWithType:(JHLiveButtonStyle)stateType;
- (void)onAppraiseList;
- (void)onSwitchMainScreenWithUid:(NSString *)uid;
- (void)onAgainEnterChatRoom;
- (void)onShareAction;
- (void)onShowInfoWithModel:(NTESMessageModel *)model;
- (void)sendPresentWithId:(NSString *)giftId;
- (void)keyBoardWillShow:(CGFloat)height;
- (void)keyBoardWillHidden;

- (void)beginCamaro;
- (void)onCanAppraiseAction:(UIButton *)btn;
- (void)onShowCommentListView:(UIButton *)btn;
- (void)onShowAuctionListView:(UIButton *)btn;
- (void)onTapAndienceHelp;
- (void)closeLinkAction:(NSString *)uid; //断开连麦
@end

@protocol NTESLiveInnerViewDataSource <NSObject>

- (id<NELivePlayer>)currentPlayer;

@end

@protocol JHLiveEndViewDelegate;

#import "BaseView.h"

@interface NTESLiveInnerView : BaseView

@property (nonatomic, strong) UIView *localDisplayView;  //本地预览视图

@property (nonatomic,weak) id<NTESLiveInnerViewDelegate> delegate;

@property (nonatomic,weak) id<JHLiveEndViewDelegate> careDelegate;

@property (nonatomic,weak) id<NTESLiveInnerViewDataSource> dataSource;

- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame
                        isAnchor:(BOOL)isAnchor;

- (void)refreshChatroom:(NIMChatroom *)chatroom;

- (void)addMessages:(NSArray<NIMMessage *> *)messages;

- (void)addPresentMessages:(NSArray<NIMMessage *> *)messages;

- (void)fireLike;

- (void)resetZoomSlider;

- (CGFloat)getActionViewHeight;

- (void)updateNetStatus:(NIMNetCallNetStatus)status;

- (void)updateUserOnMic;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;

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

//- (void)switchToBypassExitConfirmUI;

- (void)reloadAudienceData:(NSMutableArray *)array;

@end

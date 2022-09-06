//
//  JHLiveBottomBar.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, JHLiveRole){
    
    JHLiveRoleAnchor, //鉴定主播
    JHLiveRoleAudience, //鉴定观众
    JHLiveRoleApplication, //连麦鉴定申请中。。。
    JHLiveRoleLinker,//连麦鉴定中
    JHLiveRoleSaleAnchor,  //卖货主播                       
    JHLiveRoleSaleHelper,  //卖货助理
    JHLiveRoleSaleAndience, //卖货直播间的观众
    JHLiveRoleCustomizeAndience, //定制直播间的观众
    JHLiveRoleCustomizeHelper, //定制直播间助理
    JHLiveRoleRecycleAndience, //回收直播间的观众
    JHLiveRoleRecycleHelper, //回收直播间助理
};

typedef NS_ENUM(NSInteger, JHLiveButtonStyle){
    
    JHLiveButtonStyleNormal, //连麦普通状态
    JHLiveButtonStyleWaitQueue, //排队中
    JHLiveButtonStylePause, //暂停连麦
    JHLiveButtonStyleLinker, //连麦中
};



@protocol JHLiveBottomBarDelegate <NSObject>

@optional
- (void)popInputBarAction;
- (void)moreAction;
- (void)shareAction;
- (void)popGiftAction;
- (void)orderListAction;
- (void)claimOrderListAction;
- (void)canAppraiseAction:(UIButton *)btn;
- (void)pressLikeAction:(UIButton *)likeCountBtn;
- (void)popAuctionListAction:(UIButton *)btn;

- (void)popQuickReplyView:(UIButton *)sender;
/**
 我要鉴定
 */
- (void)appraiseActionWithType:(JHLiveRole)roleType;
- (void)onAndienceTapChat;

- (void)onAndienceTapResaleAction;
- (void)onAnchorTapUserAction;
- (void)onAnchorTapInsaleAction;

- (void)sendRedPacketAction:(UIButton *)btn;

-(void)clickListBtnAction:(UIButton *)btn Trailing:(CGFloat)trailing;
//连麦定制
- (void)onLineToCustomize:(JHLiveButtonStyle)CustomizeButtonStyle;
//连麦定制
- (void)onLineToRecycle:(JHLiveButtonStyle)buttonStyle;

//发布闲置
- (void)publishIdleMethodAction;


/// 点击闪购
- (void)onShanGouBtnAction;

@end


#import "BaseView.h"
#import "JHDotButtonView.h"
@interface JHLiveBottomBar : BaseView

@property (nonatomic,weak) id<JHLiveBottomBarDelegate> delegate;

/** 主播 观众 连麦用户 卖货主播 卖货观众 卖货助理*/
@property (nonatomic, assign) JHLiveRole roleType;

@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic, assign) NSInteger linkNum;

@property (weak, nonatomic) IBOutlet UIButton *sayWhateBtn;

@property (weak, nonatomic) IBOutlet UIButton *pauseAppraiseBtn;

@property (nonatomic, assign) NSInteger likeCount;

@property (weak, nonatomic) IBOutlet UIButton *pauseActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;
@property (weak, nonatomic) IBOutlet UIButton *appraiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *listBtn;

@property (nonatomic, assign) CGFloat shareBtnCenterX;
@property (nonatomic, assign) BOOL isBackLook;
@property (nonatomic, assign) NSInteger canAuction;
@property (nonatomic, assign) BOOL isResaleRoom;


@property (nonatomic, strong) UIButton *shopwindowButton;

@property (strong, nonatomic) JHDotButtonView *insaleBtn; //原石主播直播间在售按钮
@property (strong, nonatomic) JHDotButtonView *userActionBtn;//原石主播直播间宝友操作按钮
@property (strong, nonatomic) JHDotButtonView *resaleBtn; //用户回血直播间寄售按钮

@property (nonatomic, copy) NSString *shopwindowButtonNum;  //购物橱窗字符串

@property (nonatomic, assign) JHLiveButtonStyle customizeButtonType;

@property(nonatomic, assign) BOOL  hasShanGou;
- (void)setChatTitle:(NSString *)title;

- (void)updateCustomizeButtonStyle:(JHLiveButtonStyle)customizeType;
- (void)updateAppraiseButtonNum:(JHLiveRole)roleType;
- (void)updateRecycleButtonStyle:(JHLiveButtonStyle)customizeType;
@end

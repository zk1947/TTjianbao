//
//  JHCustomizeAudienceLiveController.h
//  TTjianbao
//  Description:定制直播间<观众端
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePlayerViewController.h"
#import "JHMicWaitMode.h"
#import "NTESFiterStatusModel.h"
typedef void (^requsetSuccessBlock)(JHApplyMicRoomMode * mode);

typedef NS_ENUM(NSInteger, CurrentUserRole){
    CurrentUserRoleAudience=1,
    CurrentUserRoleApplication, //申请中。。。
    CurrentUserRoleLinker,//连麦中
};
typedef NS_ENUM(NSInteger, JHGestureChangeLiveRoomFromType){
    JHGestureChangeLiveRoomFromNomal=0,//默认
    JHGestureChangeLiveRoomFromAppraisalList,//鉴定列表
    JHGestureChangeLiveRoomFromMallGroupList,//卖场首页列表
    JHGestureChangeLiveRoomFromWatchTrackList, //足迹列表
    JHGestureChangeLiveRoomFromFollowList,//关注列表
    JHGestureChangeLiveRoomFromRecommendList,//推荐列表
    JHGestureChangeLiveRoomFromMallConditionList,//
    JHGestureChangeLiveRoomFromStoneResaleList,//
    JHGestureChangeLiveRoomFromMallRecommendCycle,//推荐轮播
};
@class ChannelMode;

@interface JHCustomizeAudienceLiveController : BaseViewController

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url;
- (instancetype)initWithChannelId:(NSString *)channelId;
@property (nonatomic, strong)  ChannelMode *channel;
@property (nonatomic, strong)  NSString *coverUrl;
@property (nonatomic, assign)  BOOL applyApprassal;
@property (nonatomic, assign) CurrentUserRole currentUserRole;
@property (nonatomic,assign)  BOOL needShutDown;

@property (strong, nonatomic)  NSMutableArray *channeArr;
@property (assign, nonatomic)  NSInteger currentSelectIndex;
@property (assign, nonatomic)   NSInteger PageNum;
@property (nonatomic, copy)NSString *groupId;

///一组标签
@property (nonatomic, copy)NSString *groupIds;

@property (nonatomic, copy) NSString *fromString;
@property (nonatomic, copy) NSString *third_tab_from; //只有“直播购物”普通分类有此参数

@property (nonatomic, assign) JHGestureChangeLiveRoomFromType listFromType;

/**
 0 鉴定观众 1 卖货观众 2卖货助理
 */
@property (nonatomic, assign) JHAudienceUserRoleType audienceUserRoleType;
//退出直播间去掉返回动画
@property (nonatomic, assign) BOOL isExitVc;
//直播间退出成功回调
@property (nonatomic, strong) JHFinishBlock closeBlock ;

- (void)onCloseRoom;

@end

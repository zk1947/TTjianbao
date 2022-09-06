//
//  NTESAudienceLiveViewController.h
//  TTjianbao
//  Description:观众直播间
//  Created by chris on 16/8/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLivePlayerViewController.h"
#import "JHMicWaitMode.h"
#import "JHLiveRoomHeader.h"
#import "JHLiveActivityManager.h"

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

@interface NTESAudienceLiveViewController : JHBaseViewController

- (instancetype)initWithChatroomId:(NSString *)chatroomId streamUrl:(NSString *)url;
- (instancetype)initWithChannelId:(NSString *)channelId;
@property (nonatomic, strong)  ChannelMode *channel;
@property (nonatomic, strong)  NSString *coverUrl;
@property (nonatomic, assign)  BOOL applyApprassal;
@property (nonatomic, assign) CurrentUserRole currentUserRole;

//从直播间进入下个页面 是否需要关闭当前播放器
@property (nonatomic,assign)  BOOL needShutDown;

@property (strong, nonatomic)  NSMutableArray *channeArr;
@property (assign, nonatomic)  NSInteger currentSelectIndex;
@property (assign, nonatomic)   NSInteger PageNum;
@property (nonatomic, copy) NSString *groupId;
//直播间列表接口类型 0-从分组列表进来 1-从大家都在关注 2-从原石直播列表进来  4-定制
@property (nonatomic, copy) NSString *entrance;

///一组标签
@property (nonatomic, copy)NSString *groupIds;

@property (nonatomic, copy) NSString *fromString;
@property (nonatomic, copy) NSString *third_tab_from; //只有“直播购物”普通分类有此参数

@property (nonatomic, assign) JHGestureChangeLiveRoomFromType listFromType;

/**
 0 鉴定观众 1 卖货观众 2卖货助理 ...  （不用从外面传进来，直播间内会判断）
 */
@property (nonatomic, assign) JHAudienceUserRoleType audienceUserRoleType;
//退出直播间去掉返回动画
@property (nonatomic, assign) BOOL isExitVc;
//直播间退出成功回调
@property (nonatomic, strong) JHFinishBlock closeBlock ;
/// 直播活动管理
@property (nonatomic, strong) JHLiveActivityManager *activityManager;
- (void)onCloseRoom;

@end

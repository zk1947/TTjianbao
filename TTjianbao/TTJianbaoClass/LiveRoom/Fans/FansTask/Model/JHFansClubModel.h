//
//  JHFansClubModel.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHFansTaskType) {
    /// 签到
    JHFansTaskSign = 1,
    /// 点赞
    JHFansTaskLike = 2,
    ///分享
    JHFansTaskShare = 3,
    /// 观看直播
    JHFansTaskLookLive = 4,
    /// 浏览橱窗
    JHFansTaskLookShowCase = 5,
    /// 发言
    JHFansTaskSendMsg = 6,
    ///成单金额
    JHFansTaskOrderMoney = 7,
    /// 成单次数
    JHFansTaskOrderCount = 8,
    ////关注直播间
    JHFansTaskFollow = 9,
    ///竞拍出价
    JHFansTaskPaiMai = 10,

};
NS_ASSUME_NONNULL_BEGIN


@class JHFansTaskModel;

@interface JHFansClubModel : NSObject
@property (nonatomic, strong) NSString *anchorIcon;
@property (nonatomic, strong) NSString *anchorId;
@property (nonatomic, strong) NSString *anchorName;
@property (nonatomic, strong) NSString *currentDate;
@property (nonatomic, strong) NSString *expToNextLevel;
@property (nonatomic, strong) NSString *fansClubId;
@property (nonatomic, strong) NSString *fansClubName;
@property (nonatomic, strong) NSString *fansCount;
@property (nonatomic, strong) NSString *totalExp;
@property (nonatomic, strong) NSString *userLevelName;
@property (nonatomic, strong) NSString *userLevelType;
@property (nonatomic, strong) NSString *totalfansCount;
@property (nonatomic, assign) CGFloat progressBar;


/// 冻结描述
@property (nonatomic, strong) NSString *freezeExpDesc;

/// 冻结经验值
@property (nonatomic, strong) NSString *freezeTotalExp;

///冻结描述高度
@property (nonatomic) CGFloat freezeUnfloderHeight;

/// 是否展开冻结描述 YES 展开  NO 闭合
@property (nonatomic) BOOL isUnFlod;

@property (nonatomic, strong) NSArray <JHFansTaskModel*>*taskVos;

@end

@interface JHFansTaskModel : NSObject
@property (nonatomic, strong) NSString *completedTimes;
@property (nonatomic, strong) NSString *taskBtnDesc;
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *taskImg;
@property (nonatomic, strong) NSString *taskName;
@property (nonatomic, strong) NSString *taskRemark;
@property (nonatomic, strong) NSString *totalExp;
@property (nonatomic, assign) NSInteger taskStatus;
@property (nonatomic, assign) JHFansTaskType taskType;
@property (nonatomic, copy) NSString *taskRewardDesc;
@end

NS_ASSUME_NONNULL_END

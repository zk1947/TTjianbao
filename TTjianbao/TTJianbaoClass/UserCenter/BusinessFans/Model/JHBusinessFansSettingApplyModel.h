//
//  JHBusinessFansSettingApplyModel.h
//  TTjianbao
//
//  Created by user on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHBusinessFansRewardConfigVoListApplyModel;
@class JHBusinessFansLevelMsgListApplyModel;
@class JHBusinessFansTaskCheckListApplyModel;

@interface JHBusinessFansSettingApplyModel : NSObject
/// 主播ID
@property (nonatomic, assign) NSInteger anchorId;
/// 直播间ID
@property (nonatomic, assign) NSInteger channelId;
/// 奖励信息
@property (nonatomic, strong) NSArray<JHBusinessFansRewardConfigVoListApplyModel *>*fansRewardConfigVoList;
/// 等级信息
@property (nonatomic, strong) NSArray<JHBusinessFansLevelMsgListApplyModel *>*levelMsgList;
/// 任务列表
@property (nonatomic, strong) NSArray<JHBusinessFansTaskCheckListApplyModel *>*taskCheckList;

@property (nonatomic, strong) NSString *levelTemplateId;

@end


@class JHBusinessFansRewardConfigListApplyModel;
@interface JHBusinessFansRewardConfigVoListApplyModel : NSObject
/// 奖励列表
@property (nonatomic, strong) NSArray<JHBusinessFansRewardConfigListApplyModel *>*fansRewardConfigList;
/// 等级
@property (nonatomic,   copy) NSString *levelType;
@end


@interface JHBusinessFansRewardConfigListApplyModel : NSObject
/// 奖励图片
@property (nonatomic,   copy) NSString *rewardImg;
/// 奖励名称
@property (nonatomic,   copy) NSString *rewardName;
/// 奖励类别，0代金券，1专属商品，2进场特效，3专属粉丝牌
@property (nonatomic,   copy) NSString *rewardType;
@end


/// 等级信息
@interface JHBusinessFansLevelMsgListApplyModel : NSObject
/// 等级经验
@property (nonatomic, assign) long levelExp;
/// 等级
@property (nonatomic,   copy) NSString *levelType;
@end


/// 任务列表
@interface JHBusinessFansTaskCheckListApplyModel : NSObject
/// 是否勾选
@property (nonatomic, assign) BOOL      check;
/// 任务备注
@property (nonatomic,   copy) NSString *taskDes;
/// 任务ID
@property (nonatomic, assign) NSInteger taskId;
@end



@interface JHFansCoupouModel : NSObject
/// 主播ID
@property (nonatomic, copy) NSString *couponId;
/// 直播间ID
@property (nonatomic, copy) NSString *sellerId;

@property (nonatomic, copy) NSString *couponName;

@property (nonatomic, copy) NSString *ruleType;

@property (nonatomic, copy) NSString *ruleFrCondition;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *effectiveTime;

@end

NS_ASSUME_NONNULL_END

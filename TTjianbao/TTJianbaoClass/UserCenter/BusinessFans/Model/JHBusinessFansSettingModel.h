//
//  JHBusinessFansSettingModel.h
//  TTjianbao
//
//  Created by user on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@class JHBusinessFansSettingLevelMsgListModel;
@class JHBusinessFansSettinglevelRewardDTOListModel;
@class JHBusinessFansSettingTaskCheckListModel;
@class JHBusinessFansLevelTemplateVosModel;

@interface JHBusinessFansSettingModel : NSObject
/// 审核状态 -1未申请，0 审核中，1审核通过，2审核拒绝
@property (nonatomic, assign) NSInteger examineStatus;
/// 粉丝团ID
@property (nonatomic,   copy) NSString  *fansId;
/// 拒绝原因
@property (nonatomic,   copy) NSString  *rejectReason;
/// 等级信息
@property (nonatomic, strong) NSArray<JHBusinessFansSettingLevelMsgListModel *>*levelMsgList;
/// 奖励信息
@property (nonatomic, strong) NSArray<JHBusinessFansSettinglevelRewardDTOListModel *>*levelRewardDTOList;
/// 任务列表
@property (nonatomic, strong) NSArray<JHBusinessFansSettingTaskCheckListModel *>*taskCheckList;




/// 等级信息
@property (nonatomic, strong) NSArray<JHBusinessFansLevelTemplateVosModel *>*levelTemplateVos;

/// 等级信息
@property (nonatomic) BOOL  useLevelTemplate;


@end


@interface JHBusinessFansSettingLevelMsgListModel : NSObject
/// 等级经验
@property (nonatomic, copy) NSString*       levelExp;
/// 等级
@property (nonatomic,   copy) NSString  *levelType;
@end

@interface JHBusinessFansLevelTemplateVosModel : NSObject
/// 等级信息
@property (nonatomic, strong) NSArray<JHBusinessFansSettingLevelMsgListModel*>*levelMsgList;

/// 等级经验
@property (nonatomic, copy) NSString*       temID;
/// 等级
@property (nonatomic,   copy) NSString  *templateName;


@property (nonatomic,   copy) NSString  *recommendDesc;
/**
 * 推荐文案标识，0否，1是
 */
@property (nonatomic,   copy) NSString  *recommendFlag;

@property(nonatomic) BOOL  check;

@end

@class JHBusinessFansSettinglevelRewardVosModel;
@interface JHBusinessFansSettinglevelRewardDTOListModel : NSObject
/// 等级名称
@property (nonatomic,   copy) NSString  *levelName;
/// 等级类型，LV1，LV2，LV3，LV4，LV5，LV6，LV7，LV8，LV9，LV10
@property (nonatomic,   copy) NSString  *levelType;
/// 等级对应权益
@property (nonatomic, strong) NSArray<JHBusinessFansSettinglevelRewardVosModel *>*rewardVos;
@end


@interface JHBusinessFansSettinglevelRewardVosModel : NSObject
//@property (nonatomic,   copy) NSString  *couponDes;
//@property (nonatomic,   copy) NSString  *couponType;
//@property (nonatomic,   copy) NSString  *remark;
///// 奖励图片
//@property (nonatomic,   copy) NSString  *rewardImg;
/// 奖励名称
@property (nonatomic,   copy) NSString  *rewardName;
/// 奖励类别，0代金券，1专属商品，2进场特效，3专属粉丝牌
@property (nonatomic,   copy) NSString  *rewardType;
@end

@interface JHBusinessFansSettingTaskCheckListModel : NSObject
/// 是否勾选
@property (nonatomic, assign) BOOL      check;
/// 任务备注
@property (nonatomic,   copy) NSString *taskDes;
/// 任务ID
@property (nonatomic,   copy) NSString *taskId;

/// 0  1
@property (nonatomic,   copy) NSString *defaultFlag;

@end


NS_ASSUME_NONNULL_END

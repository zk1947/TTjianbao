//
//  JHBusinessFansSettingBusiness.h
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBusinessFansSettingModel.h"
#import "JHBusinessFansSettingApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHFansExamineStatus) {
    /// -1未申请
    JHFansExamineStatus_noApply = -1,
    /// 0 审核中
    JHFansExamineStatus_applying,
    /// 1审核通过
    JHFansExamineStatus_applyPass,
    /// 2审核拒绝
    JHFansExamineStatus_applyReject,
};

typedef void(^JHBusinessFansSettingDBQueryBlock)(BOOL success);
typedef void(^JHBusinessFansSettingDBCheckInfoBlock)(BOOL success, JHBusinessFansSettingApplyModel * _Nullable infoModel);


@interface JHBusinessFansSettingBusiness : NSObject
/**
 * 配置粉丝团
 */
+ (void)businessConfigurateFans:(NSInteger)anchorId
                      channelId:(NSInteger)channelId
                             re:(NSString*)re
                     Completion:(void(^)(NSError *_Nullable error, JHBusinessFansSettingModel * _Nullable model))completion;


/**
查询粉丝团是否挂起
 */

+ (void)businessFansAnchorId:(NSString*)anchorId StatusCompletion:(void(^)(NSError *_Nullable error, BOOL isGuaQi))completion;

/**
 * 上传
 */
+ (void)businessUploadFans:(JHBusinessFansSettingApplyModel *)applyModel
                Completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion;


/**
 初始化粉丝数据库：如果数据库不存在则按照anchorId创建
 @parameter: uid: 主播的 anchorId
 *
 */
- (void)setupUid:(NSString *)uid;

#pragma mark - add
/**
 * 新增内容
 */
- (void)addFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                completion:(_Nullable JHBusinessFansSettingDBQueryBlock)completion;

#pragma mark - delete
/**
 * 移除内容
 */
- (void)removeFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                   completion:(_Nullable JHBusinessFansSettingDBQueryBlock)completion;

#pragma mark - update
/**
 * 更新
 */
- (void)updateFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                   completion:(_Nullable JHBusinessFansSettingDBQueryBlock)completion;

#pragma mark - check
/**
 查询内容
 - count: 查询内容数量，0标示查询全部
 */
- (void)checkFansSettingInfoWithCountWithCompletion:(_Nullable JHBusinessFansSettingDBCheckInfoBlock)completion;


/**
查询粉丝团模板
 */
+ (void)requestFanslevelTempListCompletion:(void (^)(NSError * _Nullable error, id  _Nullable model))completion;

@end

NS_ASSUME_NONNULL_END

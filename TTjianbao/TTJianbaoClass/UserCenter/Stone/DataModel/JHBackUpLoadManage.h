//
//  JHBackUpLoadManage.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPutShelveModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBackUpLoadManage : NSObject
+ (JHBackUpLoadManage *)shareInstance;
@property (nonatomic, strong) NSMutableArray<JHPutShelveModel *> *dataArray;
@property (nonatomic, strong, nullable) JHPutShelveModel *currentModel;

/// 后台上传
- (void)startUpLoadWithModel:(JHPutShelveModel *)model;

- (void)startUpLoad;

/// 查询显示状态
/// @param stoneRestoreId 回血石头id
- (JHShelvShowStatus)checkShowStatusStoneId:(NSString *)stoneRestoreId;

/// 点击重试操作
/// @param stoneRestoreId 回血石头id
- (void)startUpLoadWithStoneId:(NSString *)stoneRestoreId;

@end

NS_ASSUME_NONNULL_END

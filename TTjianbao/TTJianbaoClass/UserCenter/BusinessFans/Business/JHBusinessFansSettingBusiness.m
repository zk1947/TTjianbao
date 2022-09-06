//
//  JHBusinessFansSettingBusiness.m
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingBusiness.h"
#import "LKDBHelper.h"
#import "JHPath.h"

@interface  JHBusinessFansSettingBusiness ()
@property (nonatomic, strong) LKDBHelper      *dbHelper;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSString        *uid;
@end

@implementation JHBusinessFansSettingBusiness
/*
 * 配置粉丝团
 */
+ (void)businessConfigurateFans:(NSInteger)anchorId
                      channelId:(NSInteger)channelId
                      re:(NSString*)re
                     Completion:(nonnull void (^)(NSError * _Nullable, JHBusinessFansSettingModel *_Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/configurate");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"anchorId":@(anchorId),
        @"channelId":@(channelId),
        @"reApplyFlag":re,
    }];
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHBusinessFansSettingModel *model = [JHBusinessFansSettingModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

+ (void)businessFansAnchorId:(NSString*)anchorId StatusCompletion:(void(^)(NSError *_Nullable error, BOOL isGuaQi))completion{
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/queryFansClubStatus");
//    在data中返回 0 和 1（粉丝团状态，0正常，1挂起）
    [HttpRequestTool getWithURL:url Parameters:@{@"anchorId" : anchorId} successBlock:^(RequestModel * _Nullable respondObject) {
        NSNumber *aa = respondObject.data;
        BOOL guaqi = aa.integerValue == 0 ? NO : YES;
        completion(nil,guaqi);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(error,NO);
           }
    }];
}





/**
 * 上传
 */
+ (void)businessUploadFans:(JHBusinessFansSettingApplyModel *)applyModel
                Completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion {
    NSString *url = FILE_BASE_STRING(@"/app/fans/fans-club/apply");
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[applyModel mj_keyValues]];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(nil,YES);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,NO);
       }
    }];
}

+ (void)requestFanslevelTempListCompletion:(void (^)(NSError * _Nullable, id _Nullable))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/admin/fans/fans-level-temp/list") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil, @"");
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error, nil);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error, nil);
        }
    }];
}



- (dispatch_queue_t)queue {
    if (!_queue) {
        _queue = dispatch_queue_create("com.tianmou.fanssettingqueue", NULL);
    }
    return _queue;
}

- (void)setupUid:(NSString *)uid {
    dispatch_async(self.queue, ^{
        if (isEmpty(uid) || [uid isEqualToString:self.uid]) {
            return;
        }
        if (self.dbHelper) {
            [self.dbHelper closeDB];
        }
        NSString *dbPath = [self getDBFilePathWithUid:uid];
        self.dbHelper = [[LKDBHelper alloc] initWithDBPath:dbPath];
        self.uid = uid;
        [JHDispatch ui:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ddddddddd" object:nil userInfo:@{}];
        }];
    });
}

- (NSString *)getDBFilePathWithUid:(NSString *)uid {
    return [NSString stringWithFormat:@"%@/%@/fansSetting/fansSetting.db", [JHPath document], uid];
}


#pragma mark - add
/**
 * 新增内容
 */
- (void)addFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                completion:(JHBusinessFansSettingDBQueryBlock)completion {
    dispatch_async(self.queue, ^{
        [self addFansSettingModel:infoModel compltion:^(BOOL result) {
            [JHDispatch ui:^{
                if (completion) {
                    completion(result);
                }
            }];
        }];
    });
}

#pragma mark - delete
/**
 * 移除内容
 */
- (void)removeFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                   completion:(JHBusinessFansSettingDBQueryBlock)completion {
    dispatch_async(self.queue, ^{
        [self deleteSettingModel:infoModel compltion:^(BOOL result) {
            [JHDispatch ui:^{
                if (completion) {
                    completion(result);
                }
            }];
        }];
    });
}

#pragma mark - update
/**
 * 更新
 */
- (void)updateFansSettingInfo:(JHBusinessFansSettingApplyModel *)infoModel
                   completion:(_Nullable JHBusinessFansSettingDBQueryBlock)completion {
    dispatch_async(self.queue, ^{
        [self updateSettingModel:infoModel compltion:^(BOOL result) {
            [JHDispatch ui:^{
                if (completion) {
                    completion(result);
                }
            }];
        }];
    });
}

#pragma mark - query
/**
 查询内容
 @parameter:
 - count: 查询内容数量，0标示查询全部
 */
- (void)checkFansSettingInfoWithCountWithCompletion:(_Nullable JHBusinessFansSettingDBCheckInfoBlock)completion {
    dispatch_async(self.queue, ^{
        if (![self isTableCreated]) {
            if (completion) {
                completion(NO, nil);
            }
            return;
        }
//        NSString *sql = [NSString stringWithFormat:@"select * from %@", [JHBusinessFansSettingApplyModel getTableName]];
        JHBusinessFansSettingApplyModel *settingModel = [self searchSettingModel:self.uid Compltion:nil];
        if (settingModel) {
            if (completion) {
                completion(YES, settingModel);
            }
        } else {
            if (completion) {
                completion(NO, nil);
            }
        }
    });
}


#pragma mark - private
- (void)addFansSettingModel:(JHBusinessFansSettingApplyModel *)model
                  compltion:(void (^)(BOOL result))compltion {
    [self.dbHelper insertToDB:model callback:^(BOOL result) {
        if (compltion) {
            compltion(result);
        }
    }];
}

- (void)deleteSettingModel:(JHBusinessFansSettingApplyModel *)model
                 compltion:(void (^)(BOOL result))compltion {
    [self.dbHelper deleteToDB:model callback:^(BOOL result) {
        if (compltion) {
            compltion(result);
        }
    }];
}

- (void)updateSettingModel:(JHBusinessFansSettingApplyModel *)model
                 compltion:(void (^)(BOOL result))compltion {
    [self.dbHelper updateToDB:model where:nil callback:^(BOOL result) {
        if (compltion) {
            compltion(result);
        }
    }];
}

- (JHBusinessFansSettingApplyModel *)searchSettingModel:(NSString *)uid
                                              Compltion:(void (^)(BOOL result))compltion {
    return [self.dbHelper searchSingle:JHBusinessFansSettingApplyModel.class where:JHBusinessFansSettingApplyModel.class orderBy:nil];
}

- (BOOL)isTableCreated {
    return [self.dbHelper getTableCreatedWithClass:JHBusinessFansSettingApplyModel.class];
}


@end

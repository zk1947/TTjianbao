//
//  JHBackUpLoadManage.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

/*
 上传逻辑
 1.同时只上传一个商品的图片和视频
 2.上架页面过来的上线信息 add 数组最后
 3.点击重新上传的insert数组第一个
 4.按顺序遍历数组，待上传和点击重新上传状态的 继续上传 如果都是失败状态不继续上传
 */
#import "JHBackUpLoadManage.h"
#import "JHAiyunOSSManager.h"
#import "SVProgressHUD.h"
#import "JHResaleStoneReeditModel.h"
@interface JHBackUpLoadManage ()
@property (nonatomic, assign) BOOL isUploading;
@end

@implementation JHBackUpLoadManage

+ (JHBackUpLoadManage *)shareInstance {
    static dispatch_once_t onceToken;
    static JHBackUpLoadManage *shareInstance = nil;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JHBackUpLoadManage alloc]init];
    });
    return shareInstance;
}

#pragma mark - get

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark -


- (void)upLoadVideoAndCoverWithIndex:(NSInteger)index {
    

    if (index<self.currentModel.allVideos.count && index<self.currentModel.allVideoPaths.count) {
        for (NSString *path in self.currentModel.allVideoPaths) {
            if (![self fileExistsWithPath:path]) {
                [self notificationStatus:JHUploadStatusUploadFileError isEndCurrent:YES];
                return;
            }
        }
        [[JHAiyunOSSManager shareInstance] uploadVideoByPath:self.currentModel.allVideoPaths[index] returnPath:kJHAiyunStonePath finishBlock:^(BOOL isFinished, NSString * _Nonnull videoKey) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isFinished) {
                    JHPhotoItemModel *model = self.currentModel.allVideos[index];
                    [self.currentModel.videoKeys addObject:videoKey];
                    
                    [[JHAiyunOSSManager shareInstance] uopladImage:@[model.image] returnPath:kJHAiyunStonePath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
                        if (isFinished) {
                            dispatch_async(dispatch_get_main_queue(),  ^{
                                [self.currentModel.coverKeys addObjectsFromArray:imgKeys];
                                [self upLoadVideoAndCoverWithIndex:index+1];
                                
                            });
                        }else {
                            [SVProgressHUD showErrorWithStatus:@"上传视频封面失败"];
                            [self notificationStatus:JHUploadStatusUploadFail isEndCurrent:YES];
                        }
                    }];
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"视频上传失败，稍后再试！"];
                    [self notificationStatus:JHUploadStatusUploadFail isEndCurrent:YES];

                }
                
            });
            
        }];
        
    } else {
        [self uploadAllPicture];
    }
}

- (void)uploadAllPicture {
    
    if (self.currentModel.allPhotos.count) {
        //图片
        NSMutableArray *array = [NSMutableArray array];
        for (JHPhotoItemModel *model in self.currentModel.allPhotos) {
            [array addObject:model.image];
        }
        [[JHAiyunOSSManager shareInstance] uopladImage:array returnPath:kJHAiyunStonePath finishBlock:^(BOOL isFinished, NSArray<NSString *> * _Nonnull imgKeys) {
            
            dispatch_async(dispatch_get_main_queue(),  ^{
                if (isFinished && imgKeys.count) {
                    self.currentModel.imageKeys = imgKeys;
                    [self postData];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"上传图片失败"];
                    [self notificationStatus:JHUploadStatusUploadFail isEndCurrent:YES];
                }
                
            });
            
            
        }];
    }else {
        [self postData];

    }
    
}

- (void)postData {
    JHPutawayModel *model = [[JHPutawayModel alloc] init];
    model.goodsTitle = self.currentModel.goodsTitle;
    model.goodsDesc = self.currentModel.goodsDesc;
    model.stoneRestoreId = self.currentModel.stoneRestoreId;
    model.depositoryLocationCode = self.currentModel.depositoryLocationCode;
    for (int i = 0; i<self.currentModel.allVideoPaths.count; i++) {
        JHMediaModel *type = [JHMediaModel new];
        type.type = 2;
        type.url = self.currentModel.videoKeys[i];
        type.coverUrl = self.currentModel.coverKeys[i];
        
        [model.urlList addObject:type];
    }
    int m = 0;
    for (NSString *obj in self.currentModel.videoUrls) {
        JHMediaModel *type = [JHMediaModel new];
        type.type = 2;
        type.url = obj;
        type.coverUrl = self.currentModel.coverUrls[m];
        [model.urlList addObject:type];
        m++;
    }
    
    for (int i = 0; i<self.currentModel.imageKeys.count; i++) {
        JHMediaModel *type = [JHMediaModel new];
        type.type = 1;
        type.url = self.currentModel.imageKeys[i];
        [model.urlList addObject:type];
    }
    
    for (NSString *obj in self.currentModel.imageUrls) {
        JHMediaModel *type = [JHMediaModel new];
        type.type = 1;
        type.url = obj;
        [model.urlList addObject:type];
    }
    
    if(self.currentModel.isEdit) {
        JHResaleStoneReeditModel* reeditUpload = [JHResaleStoneReeditModel new];
        JHResaleStoneReeditReqModel* sendModel = [JHResaleStoneReeditReqModel new];
        sendModel.goodsTitle = model.goodsTitle;
        sendModel.goodsDesc = model.goodsDesc;
        sendModel.stoneRestoreId = model.stoneRestoreId;
        sendModel.urlList = model.urlList;
        [reeditUpload requestReeditModel:sendModel response:^(id respData, NSString *errorMsg) {
            if(errorMsg)
            {
                self.currentModel.failCount = self.currentModel.failCount + 1;
                if (self.currentModel.failCount>5) {
                    [self notificationStatus:JHUploadStatusUploadFileError isEndCurrent:YES];
                }else {
                    [self notificationStatus:JHUploadStatusShelveFail isEndCurrent:YES];

                }
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }
            else{
                [self notificationStatus:JHUploadStatusUploadSuccess isEndCurrent:YES];
            }
        }];
    }
    else{
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-restore/shelve") Parameters:[model mj_keyValues] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
            [self notificationStatus:JHUploadStatusUploadSuccess isEndCurrent:YES];
            
            [SVProgressHUD showSuccessWithStatus:@"上架成功"];
            
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            self.currentModel.failCount = self.currentModel.failCount + 1;
            if (self.currentModel.failCount>5) {
                [self notificationStatus:JHUploadStatusUploadFileError isEndCurrent:YES];
            }else {
                [self notificationStatus:JHUploadStatusShelveFail isEndCurrent:YES];

            }
            [SVProgressHUD showErrorWithStatus:respondObject.message];
        }];

    }
}

- (void)notificationStatus:(JHUploadStatus)status isEndCurrent:(BOOL)isEnd {
    self.currentModel.uploadStatus = status;
    self.currentModel.showStatus = [self convertStatus:status];
    [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationShelveStatusChange object:self.currentModel];
    
    if (isEnd) {
        [self endCurrentUploading];
    }
}

- (void)endCurrentUploading {
    
    self.isUploading = NO;
    if (self.currentModel.uploadStatus == JHUploadStatusUploadSuccess || self.currentModel.uploadStatus == JHUploadStatusUploadFileError) {
        
    } else {
        [self.dataArray addObject:self.currentModel];
    }
    self.currentModel = nil;
    [self startUpLoad];
}

- (JHUploadStatus)checkStatusStoneId:(NSString *)stoneId {
    for (JHPutShelveModel *model in self.dataArray) {
        if ([model.stoneRestoreId isEqualToString:stoneId]) {
            return model.uploadStatus;
        }
    }
    return JHUploadStatusNoShelve;
}



- (JHShelvShowStatus)convertStatus:(JHUploadStatus)uploadStatus {
    if (uploadStatus == JHUploadStatusShelveFail || uploadStatus == JHUploadStatusUploadFail) {
        return JHShelvShowStatusShelveFail;
    } else if (uploadStatus == JHUploadStatusWaiting || uploadStatus == JHUploadStatusUploading) {
        return JHShelvShowStatusShelveing;
    } else if (uploadStatus == JHUploadStatusUploadSuccess) {
        return JHShelvShowStatusSuccess;
    } else {
        return JHShelvShowStatusShelveButton;
    }
}

- (JHPutShelveModel *)checkModelStoneId:(NSString *)stoneRestoreId {
    for (JHPutShelveModel *model in self.dataArray) {
        if ([model.stoneRestoreId isEqualToString:stoneRestoreId]) {
            return model;
        }
    }
    return nil;
}

- (BOOL)fileExistsWithPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

#pragma mark - public

- (void)startUpLoadWithStoneId:(NSString *)stoneRestoreId {
    JHPutShelveModel *model = [self checkModelStoneId:stoneRestoreId];
    [self.dataArray removeObject:model];
    if (model) {
        if (model.uploadStatus == JHUploadStatusShelveFail) {//上传资源成功 上架接口失败的 只需要重新提交上架接口
            model.uploadStatus = JHUploadStatusShelveFailReset;

        } else {
            model.uploadStatus = JHUploadStatusWaiting;
        }
        [self.dataArray insertObject:model atIndex:0];
        [self startUpLoad];
    }


}

- (void)startUpLoadWithModel:(JHPutShelveModel *)model {
    model.uploadStatus = JHUploadStatusWaiting;
    model.showStatus = [self convertStatus:model.uploadStatus];
    if (!self.isUploading) {
        [self.dataArray addObject:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationShelveStatusChange object:model];

        [self startUpLoad];

    } else {
        [self.dataArray insertObject:model atIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationShelveStatusChange object:model];

    }

}

- (void)startUpLoad {
    
    if (!self.isUploading && self.dataArray.count>0) {
        BOOL hasWillUp = NO;
        //判断数组中是否还有等待上传的 有继续 没有直接退出
        for (JHPutShelveModel *model in self.dataArray) {
            if (model.uploadStatus == JHUploadStatusWaiting || model.uploadStatus == JHUploadStatusShelveFailReset) {
                hasWillUp = YES;
                break;
            }
        }
        if (!hasWillUp) {
            return;
        }
        JHPutShelveModel *model = self.dataArray.firstObject;
        if (model.uploadStatus == JHUploadStatusWaiting) {
            self.isUploading = YES;
            model.uploadStatus = JHUploadStatusUploading;
            self.currentModel = model;
            [self.dataArray removeObjectAtIndex:0];
            
            self.currentModel.videoKeys = [NSMutableArray array];
            self.currentModel.coverKeys = [NSMutableArray array];
            self.currentModel.imageKeys = [NSMutableArray array];
            [self upLoadVideoAndCoverWithIndex:0];

        } else if (model.uploadStatus == JHUploadStatusShelveFailReset) {
            self.isUploading = YES;
            model.uploadStatus = JHUploadStatusUploading;
            self.currentModel = model;
            [self.dataArray removeObjectAtIndex:0];
            [self postData];
        } else if (model.uploadStatus == JHUploadStatusUploadSuccess) {
           
            [self.dataArray removeObjectAtIndex:0];
            [self startUpLoad];
        } else {
            [self.dataArray addObject:model];
            [self.dataArray removeObjectAtIndex:0];
            [self startUpLoad];
        }
        
        [self notificationStatus:self.currentModel.uploadStatus isEndCurrent:NO];

    }
//    else {
//        self.isUploading = NO;
//        [self startUpLoad];
//    }
}

- (JHShelvShowStatus)checkShowStatusStoneId:(NSString *)stoneId {
    if ([self.currentModel.stoneRestoreId isEqualToString:stoneId]) {
        return self.currentModel.showStatus;
    }
    for (JHPutShelveModel *model in self.dataArray) {
        if ([model.stoneRestoreId isEqualToString:stoneId]) {
            return model.showStatus;
        }
    }
    
    return JHShelvShowStatusShelveButton;
}

@end

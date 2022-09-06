//
//  JHPutShelveModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPhotoCollectionView.h"
#import "JHPublishSourceItemModel.h"

#define kJHAiyunStonePath @"client_publish/blood"

UIKIT_EXTERN NSString * _Nullable const JHNotificationShelveStatusChange;

typedef NS_ENUM(NSInteger, JHShelvShowStatus) {
    JHShelvShowStatusShelveButton, //上架按钮
    JHShelvShowStatusShelveing, //上架中
    JHShelvShowStatusShelveFail, //上架失败
    JHShelvShowStatusSuccess, //成功 删除
};

typedef NS_ENUM(NSInteger, JHUploadStatus) {
    JHUploadStatusWaiting, //已经提交上传 显示上架中
    JHUploadStatusUploading, //正在上传 显示上架中
    JHUploadStatusUploadFail, //上传失败
    JHUploadStatusShelveFail, //上架接口失败
    JHUploadStatusUploadSuccess, //成功后就从数组删除了
    JHUploadStatusNoShelve, //未提交过 显示上架
    JHUploadStatusUploadFileError, //上传文件有问题删除 显示上架
    JHUploadStatusShelveFailReset, //上架接口失败 点重试 直接请求上架接口 我自己用不需要显示

};

NS_ASSUME_NONNULL_BEGIN


@interface JHMediaModel : NSObject
///如果是图片，url和coverUrl相同；如果是视频，coverUrl是封面地址
@property (nonatomic, copy) NSString *coverUrl;
///1-图片，2-视频
@property (nonatomic, assign) NSInteger type;
///图片或视频地址
@property (nonatomic, copy) NSString *url;

@end

@interface JHPutawayModel : NSObject
@property (nonatomic, copy) NSString *goodsDesc;
@property (nonatomic, copy) NSString *goodsTitle;
@property (nonatomic, copy) NSString *stoneRestoreId;
@property (nonatomic, strong) NSMutableArray<JHMediaModel *> *urlList; // 附件列表
@property (nonatomic, strong) NSString *depositoryLocationCode;
@end


@interface JHPutShelveModel : JHPutawayModel

@property (strong, nonatomic) NSMutableArray<JHPublishSourceItemModel *> *allPhotos;

@property (strong, nonatomic) NSMutableArray<JHPublishSourceItemModel *> *allVideos;

@property (strong, nonatomic) NSMutableArray *allVideoPaths;

@property (strong, nonatomic) NSMutableArray *imageKeys;
@property (strong, nonatomic) NSMutableArray *videoKeys;
@property (strong, nonatomic) NSMutableArray *coverKeys;

///网络
@property (nonatomic, copy) NSArray *imageUrls;
///网络
@property (nonatomic, copy) NSArray *videoUrls;
///网络
@property (nonatomic, copy) NSArray *coverUrls;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) JHUploadStatus uploadStatus;

@property (nonatomic, assign) JHShelvShowStatus showStatus;

/// 接口失败次数
@property (nonatomic, assign) NSInteger failCount;


@end

NS_ASSUME_NONNULL_END

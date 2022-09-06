//
//  JHRecyclePhotoInfoModel.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "JHRecycleTemplateImageModel.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * JHNotificationRecycleUploadImageInfoChanged = @"JHNotificationRecycleUploadImageInfoChanged";

@interface JHRecyclePhotoInfoModel : NSObject

/// media类型
@property(nonatomic, assign) PHAssetMediaType  mediaType;

/// UIImagePickerControllerOriginalImage
@property(nonatomic, strong) UIImage * originalImage;

///相片信息
@property(nonatomic, strong) PHAsset * asset;

///上传到阿里oss的图片地址
@property(nonatomic, copy) NSString * aliossUrl;

///本地视频路径
@property(nonatomic, copy) NSString * videoLocalUrl;

///系统info初始化
+ (instancetype)photoInfoModelWithImage:(nullable UIImage*)image andAsset:(PHAsset*)asset;


+ (instancetype)photoInfoModelWithTempModel:(JHRecycleTemplateImageModel *)model;

@end

NS_ASSUME_NONNULL_END

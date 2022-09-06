//
//  PHPhotoLibrary+Save.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ _Nullable JHPhotosSaveCompletion)(BOOL success, NSError * _Nullable error);

typedef NS_ENUM(NSInteger, SCImageType) {
    SCImageTypeJPEG,
    SCImageTypePNG
};

@interface PHPhotoLibrary (Save)
/// 图片数据保存
+ (void)saveImageDataToCameraRool:(NSData *)imageData
                       completion:(JHPhotosSaveCompletion)completion;
/// 图片数据保存
+ (void)saveImageToCameraRool:(UIImage *)image
                       completion:(JHPhotosSaveCompletion)completion;
/// 图片保存
+ (void)saveImageToCameraRool:(UIImage *)image
                    imageType:(SCImageType)type
           compressionQuality:(CGFloat)quality
                   completion:(JHPhotosSaveCompletion)completion;

/// 动态图片保存
+ (void)saveLivePhotoToCameraRool:(NSData *)imageData
                        shortFilm:(NSURL *)filmURL
                       completion:(JHPhotosSaveCompletion)completion;


/// 视频保存
+ (void)saveMovieFileToCameraRoll:(NSURL *)fileURL
                       completion:(JHPhotosSaveCompletion)completion;

/// 自定义保存
+ (void)customSaveWithChangeBlock:(dispatch_block_t)changeBlock
                        completion:(JHPhotosSaveCompletion)completion;

@end

NS_ASSUME_NONNULL_END

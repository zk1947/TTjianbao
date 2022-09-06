//
//  JHCameraModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PHPhotoLibrary+Save.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, JHAssetType){
    JHAssetTypeVideo,
    JHAssetTypeImage,
};


@interface JHAssetModel : NSObject

@property (nonatomic, assign) JHAssetType assetType;

/// 缩略图
@property (nonatomic, strong) UIImage *thumbnailImage;
/// 原图
@property (nonatomic, strong) UIImage *originalImage;
///
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, copy) NSString *localIdentifier;

/// 视频地址
@property (nonatomic, strong) NSURL *videoPath;

- (instancetype)initWithImage : (UIImage *)image;
- (instancetype)initWithImageData : (NSData *)imageData;
- (instancetype)initWithVideoPath : (NSURL *)path;

/// 保存图片-相册 - 直接把原图保存
- (void)saveImageWithCompletion:(JHPhotosSaveCompletion)completion;
/// 保存图片-相册
- (void)saveImageWithImageData : (NSData *)imageData completion:(JHPhotosSaveCompletion)completion;
/// 保存图片-相册
- (void)saveImageWithImage : (UIImage *)image completion:(JHPhotosSaveCompletion)completion;

/// 保存视频-相册
- (void)saveVideoWithURL : (NSURL *)url completion:(JHPhotosSaveCompletion)completion;
/// 保存视频-相册
- (void)saveVideoWithCompletion:(JHPhotosSaveCompletion)completion;
/// 根据asset 获取缩略图
- (void)setupThumbnailImage;
@end




NS_ASSUME_NONNULL_END

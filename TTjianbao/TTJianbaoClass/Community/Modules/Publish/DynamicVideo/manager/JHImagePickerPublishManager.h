//
//  JHImagePickerPublishManager.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAlbumPickerModel : NSObject

@property (nonatomic, copy) NSString *sourceUrl;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, assign) BOOL isNetwork;

@property (nonatomic, strong) id image;

///default is NO
@property (nonatomic, assign) BOOL isVideo;
//视频时长
@property (nonatomic, assign) int videoDuration;

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) AVAsset *avasset;

@property (nonatomic, assign) float height;

@property (nonatomic, assign) float width;

@end

@interface JHImagePickerPublishManager : NSObject

//图片专用（1个图片）
+ (void)showImagePickerWithViewController:(nonnull UIViewController *)viewController photoSelectedBlock:(void (^ _Nullable)(NSArray<JHAlbumPickerModel *> * _Nonnull))photoSelectedBlock;

/// @param type 0全部  1图片    2视频
/// @param maxImagesCount 图片最大数量
/// @param assetArray 反选数组
/// @param viewController 当前控制器
/// @param photoSelectedBlock 选图片回调
/// @param videoSelectedBlock 选视频回调
+ (void)showImagePickerViewWithType:(NSInteger)type
      maxImagesCount:(NSInteger)maxImagesCount
          assetArray:(nonnull NSArray *)assetArray
      viewController:(UIViewController *)viewController
  photoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))photoSelectedBlock
  videoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))videoSelectedBlock;

/// @param type 0全部  1图片    2视频
/// @param maxImagesCount 图片最大数量
/// @param assetArray 反选数组
/// @param viewController 当前控制器
/// @param photoSelectedBlock 选图片回调
/// @param videoSelectedBlock 选视频回调
/// @param allowTake 是否可以拍照
/// @param photoWidth 最大宽度（828 默认）
/// @param videoMaximumDuration 最大视频时长
+ (void)showImagePickerViewWithType:(NSInteger)type
                     maxImagesCount:(NSInteger)maxImagesCount
                         assetArray:(nonnull NSArray *)assetArray
                     viewController:(UIViewController *)viewController
                 photoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))photoSelectedBlock
                 videoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))videoSelectedBlock
                          allowTake:(BOOL)allowTake
                         photoWidth:(CGFloat)photoWidth
               videoMaximumDuration:(NSTimeInterval)videoMaximumDuration;

+ (void)getOutPutPath:(PHAsset *)asset block:(void(^)(NSString * outPath))block;

@end

NS_ASSUME_NONNULL_END

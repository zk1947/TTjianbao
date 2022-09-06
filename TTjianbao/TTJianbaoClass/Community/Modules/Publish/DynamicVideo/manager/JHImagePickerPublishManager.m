//
//  JHImagePickerPublishManager.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHImagePickerPublishManager.h"
#import "TZImagePickerController.h"
#import <SVProgressHUD.h>

@implementation JHAlbumPickerModel

@end

@interface JHImagePickerPublishManager ()<TZImagePickerControllerDelegate>

@end

@implementation JHImagePickerPublishManager

+ (void)showImagePickerWithViewController:(nonnull UIViewController *)viewController photoSelectedBlock:(void (^ _Nullable)(NSArray<JHAlbumPickerModel *> * _Nonnull))photoSelectedBlock
{
    [self showImagePickerViewWithType:1 maxImagesCount:1 assetArray:@[] viewController:viewController photoSelectedBlock:photoSelectedBlock videoSelectedBlock:nil];
}

+ (void)showImagePickerViewWithType:(NSInteger)type
      maxImagesCount:(NSInteger)maxImagesCount
          assetArray:(nonnull NSArray *)assetArray
      viewController:(UIViewController *)viewController
  photoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))photoSelectedBlock
  videoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))videoSelectedBlock
{
    [self showImagePickerViewWithType:type maxImagesCount:maxImagesCount assetArray:assetArray viewController:viewController photoSelectedBlock:photoSelectedBlock videoSelectedBlock:videoSelectedBlock allowTake:YES photoWidth:828 videoMaximumDuration:10 * 60];
}


+ (void)showImagePickerViewWithType:(NSInteger)type
      maxImagesCount:(NSInteger)maxImagesCount
          assetArray:(nonnull NSArray *)assetArray
      viewController:(UIViewController *)viewController
  photoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))photoSelectedBlock
  videoSelectedBlock:(void (^ __nullable)(NSArray <JHAlbumPickerModel *> *dataArray))videoSelectedBlock
           allowTake:(BOOL)allowTake
          photoWidth:(CGFloat)photoWidth
videoMaximumDuration:(NSTimeInterval)videoMaximumDuration;
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxImagesCount delegate:(id<TZImagePickerControllerDelegate>)viewController];
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.alwaysEnableDoneBtn = NO;
    imagePickerVc.sortAscendingByModificationDate = NO;
    imagePickerVc.photoWidth = photoWidth;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.videoMaximumDuration = videoMaximumDuration;
    
    if(type == 1)
    {
        imagePickerVc.allowTakePicture = allowTake;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowTakeVideo = NO;
        imagePickerVc.allowPickingVideo = NO;
    }
    else if(type == 2)
    {
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.allowPickingImage = NO;
        imagePickerVc.allowTakeVideo = allowTake;
        imagePickerVc.allowPickingVideo = YES;
    }
    else
    {
        imagePickerVc.allowTakePicture = allowTake;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowTakeVideo = allowTake;
        imagePickerVc.allowPickingVideo = YES;
    }
    if(assetArray && IS_ARRAY(assetArray))
    {
        imagePickerVc.selectedAssets = [NSMutableArray arrayWithArray:assetArray];
    }

    imagePickerVc.didFinishPickingVideoHandle = ^(UIImage *coverImage, PHAsset *asset) {
        if(type == 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:@"请选择图片"];
            });
            return;
        }
        JHAlbumPickerModel *model = [JHAlbumPickerModel new];
        model.image = coverImage;
        model.asset = asset;
        model.isVideo = YES;
        if(videoSelectedBlock && model){
            dispatch_async(dispatch_get_main_queue(), ^{
                videoSelectedBlock(@[model]);
            });
        }
    };
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        if(type == 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showInfoWithStatus:@"请选择视频"];
            });
            return;
        }
        
        if (IS_ARRAY(photos) && photoSelectedBlock) {
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:9];
            for(int i = 0; i < photos.count; i++){
                JHAlbumPickerModel *model = [JHAlbumPickerModel new];
                model.image = photos[i];
                model.asset = assets[i];
                model.isVideo = NO;
                [array addObject:model];
            }
            if(array.count > 0){
                dispatch_async(dispatch_get_main_queue(), ^{
                    photoSelectedBlock(array);
                });
            }
        }
    }];
    
    [viewController presentViewController:imagePickerVc animated:YES completion:nil];
}

+ (void)changeAssetWithAsset:(PHAsset *)asset block:(void(^)(AVAsset * avasset))block {
    PHVideoRequestOptions *optionForCache = [[PHVideoRequestOptions alloc]init];
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:optionForCache resultHandler:^(AVAsset * avasset, AVAudioMix * audioMix, NSDictionary * info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block && avasset) {
                block(avasset);
            }
        });
    }];
}

+ (void)getOutPutPath:(PHAsset *)asset block:(void(^)(NSString * outPath))block {
    [SVProgressHUD showWithStatus:@"正在导出视频"];
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        if(block)
        {
            block(outputPath);
        }
        [SVProgressHUD dismiss];
    } failure:^(NSString *errorMessage, NSError *error) {
          dispatch_async(dispatch_get_main_queue(),  ^{
              [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
          });
    }];
}

@end


/*
 
 + (void)changeAssetWithAsset:(PHAsset *)asset block:(void(^)(AVAsset * avasset))block {
     [SVProgressHUD showWithStatus:@"正在导出视频"];
     [[TZImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
         if(block)
         {
             block([AVAsset assetWithURL:[NSURL fileURLWithPath:outputPath]]);
         }
         [SVProgressHUD dismiss];
     } failure:^(NSString *errorMessage, NSError *error) {
           dispatch_async(dispatch_get_main_queue(),  ^{
               [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
           });
     }];
 }

 
 */

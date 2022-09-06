//
//  PHPhotoLibrary+Save.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "PHPhotoLibrary+Save.h"

@implementation PHPhotoLibrary (Save)
#pragma mark - still photo
+ (void)saveImageToCameraRool:(UIImage *)image
                    imageType:(SCImageType)type
             compressionQuality:(CGFloat)quality
                   completion:(JHPhotosSaveCompletion)completion {
    NSData *data;
    switch (type) {
        case SCImageTypeJPEG:
            data = UIImageJPEGRepresentation(image, quality);
            break;
        case SCImageTypePNG:
            data = UIImagePNGRepresentation(image);
            break;
    }
    [self saveImageDataToCameraRool:data completion:completion];
}

+ (void)saveImageDataToCameraRool:(NSData *)imageData
                   completion:(JHPhotosSaveCompletion)completion {
    [self customSaveWithChangeBlock:^{
        PHAssetCreationRequest *imageRequest = [PHAssetCreationRequest creationRequestForAsset];
        [imageRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
    }completion:completion];
}

#pragma mark - live photo
+ (void)saveLivePhotoToCameraRool:(NSData *)imageData
                        shortFilm:(NSURL *)filmURL
                       completion:(JHPhotosSaveCompletion)completion {
    [self customSaveWithChangeBlock:^{
        PHAssetCreationRequest* creationRequest = [PHAssetCreationRequest creationRequestForAsset];
        [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
        PHAssetResourceCreationOptions* resourceOptions = [[PHAssetResourceCreationOptions alloc] init];
        resourceOptions.shouldMoveFile = YES;
        [creationRequest addResourceWithType:PHAssetResourceTypePairedVideo fileURL:filmURL options:resourceOptions];
    } completion:completion];
}


#pragma mark - movie
+ (void)saveMovieFileToCameraRoll:(NSURL *)fileURL
                   completion:(JHPhotosSaveCompletion)completion {
    [self customSaveWithChangeBlock:^{
        PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
        PHAssetResourceCreationOptions* resourceOptions = [[PHAssetResourceCreationOptions alloc] init];
        resourceOptions.shouldMoveFile = YES;
        [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:fileURL options:resourceOptions];
    } completion:completion];
}


#pragma mark - private
+ (void)customSaveWithChangeBlock:(dispatch_block_t)changeBlock
                       completion:(JHPhotosSaveCompletion)completion {
    [[PHPhotoLibrary sharedPhotoLibrary]
     performChanges: changeBlock
     completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
                completion(success, error);
        });
    }];
  
}
@end

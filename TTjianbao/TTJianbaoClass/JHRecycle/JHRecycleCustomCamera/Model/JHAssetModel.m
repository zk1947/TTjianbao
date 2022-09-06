//
//  JHCameraModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAssetModel.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface JHAssetModel()

@end

@implementation JHAssetModel

- (instancetype)initWithImage : (UIImage *)image{
    self = [super init];
    if (self) {
        self.assetType = JHAssetTypeImage;
        [self setupImage:image];
    }
    return self;
}
- (instancetype)initWithImageData : (NSData *)imageData {
    self = [super init];
    if (self) {
        self.assetType = JHAssetTypeImage;
        [self setupImageWithData:imageData];
    }
    return self;
}
- (instancetype)initWithVideoPath : (NSURL *)path {
    self = [super init];
    if (self) {
        self.assetType = JHAssetTypeVideo;
        [self setupVideoWithPath : path ];
    }
    return self;
}

- (void)setupImage : (UIImage *)image {
    self.originalImage = image;
}
- (void)setupImageWithData : (NSData *)imageData {
    UIImage *image = [UIImage imageWithData:imageData];
    self.originalImage = image;
}
- (void)setupVideoWithPath : (NSURL *)path {
    self.videoPath = path;
    UIImage *image = [self getVideoFirstViewImage:path];
    self.originalImage = image;
}
/// 根据asset 获取缩略图
- (void)setupThumbnailImage {
    if (self.asset == nil) return;
    self.localIdentifier = self.asset.localIdentifier;
    
    [PHImageManager.defaultManager requestImageForAsset:self.asset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage = result;
        });
    }];
}

- (void)saveImageWithCompletion:(JHPhotosSaveCompletion)completion {
    self.assetType = JHAssetTypeImage;
    
    NSData *imageData = UIImageJPEGRepresentation(self.originalImage, 1);
    
    [[PHPhotoLibrary sharedPhotoLibrary]
     performChanges:^{
        PHAssetCreationRequest *imageRequest = [PHAssetCreationRequest creationRequestForAsset];
        [imageRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
        self.localIdentifier = imageRequest.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageCompletion:success error: error completion:completion];
        });
    }];
}
- (void)saveImageWithImage : (UIImage *)image completion:(JHPhotosSaveCompletion)completion {
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    [[PHPhotoLibrary sharedPhotoLibrary]
     performChanges:^{
        PHAssetCreationRequest *imageRequest = [PHAssetCreationRequest creationRequestForAsset];
        [imageRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
        self.localIdentifier = imageRequest.placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            PHFetchResult * result =  [PHAsset fetchAssetsWithLocalIdentifiers:@[self.localIdentifier] options:nil];
            
            self.asset = result.lastObject;
            completion(success, error);
            
        });
    }];
}
- (void)saveImageWithImageData : (NSData *)imageData completion:(JHPhotosSaveCompletion)completion {
    self.assetType = JHAssetTypeImage;
    @weakify(self)
    [[PHPhotoLibrary sharedPhotoLibrary]
     performChanges:^{
        @strongify(self)
        PHAssetCreationRequest *imageRequest = [PHAssetCreationRequest creationRequestForAsset];
        [imageRequest addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
        self.localIdentifier = imageRequest.placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageCompletion:success error: error completion:completion];
        });
        
    }];
}
/// 保存视频-相册
- (void)saveVideoWithCompletion:(JHPhotosSaveCompletion)completion {
    [self saveVideoWithURL:self.videoPath completion:completion];
}
/// 保存视频-相册
- (void)saveVideoWithURL : (NSURL *)url completion:(JHPhotosSaveCompletion)completion {
    self.assetType = JHAssetTypeVideo;
    self.videoPath = url;
    @weakify(self)
    [[PHPhotoLibrary sharedPhotoLibrary]
     performChanges:^{
        @strongify(self)
        PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
        PHAssetResourceCreationOptions* resourceOptions = [[PHAssetResourceCreationOptions alloc] init];
        resourceOptions.shouldMoveFile = true;
        [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:url options:resourceOptions];
        self.localIdentifier = videoRequest.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        @strongify(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveVideoCompletion:success error: error completion:completion];
        });
    }];
}
- (void)saveImageCompletion : (BOOL) success error :(NSError *)error completion:(JHPhotosSaveCompletion)completion{
    if (success == false) {
        completion(success, error);
        return;
    }
    PHFetchResult * result =  [PHAsset fetchAssetsWithLocalIdentifiers:@[self.localIdentifier] options:nil];
    if (result.lastObject == nil) {
        completion(success, error);
        return;
    }

    self.asset = result.lastObject;
    [PHImageManager.defaultManager requestImageForAsset:self.asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.thumbnailImage = result;
            completion(success, error);
        });
    }];
}
- (void)saveVideoCompletion : (BOOL) success error :(NSError *)error completion:(JHPhotosSaveCompletion)completion {
    if (success == false) {
        completion(success, error);
        return;
    }
    PHFetchResult * result =  [PHAsset fetchAssetsWithLocalIdentifiers:@[self.localIdentifier] options:nil];
    
    self.asset = result.lastObject;
    
    [PHImageManager.defaultManager requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
            NSString * sandboxExtensionTokenKey = info[@"PHImageFileSandboxExtensionTokenKey"];
            
            NSArray * arr = [sandboxExtensionTokenKey componentsSeparatedByString:@";"];
            
            NSURL* filePath = arr[arr.count - 1];
            self.videoPath = filePath;
            completion(success, error);
        });
    }];
    
}
// 获取视频第一帧
- (UIImage*)getVideoFirstViewImage:(NSURL *)path {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
    
}

- (UIImage *)resizeImage : (UIImage *)image size : (CGSize )size {
    if (image == nil) return nil;
    
    UIImage *newimage;
    CGSize oldsize = image.size;
    CGRect rect;
    if (size.width/size.height > oldsize.width/oldsize.height) {
        rect.size.width = size.height*oldsize.width/oldsize.height;
        rect.size.height = size.height;
        rect.origin.x = (size.width - rect.size.width)/2;
        rect.origin.y = 0;
    }
    else{
        rect.size.width = size.width;
        rect.size.height = size.width*oldsize.height/oldsize.width;
        rect.origin.x = 0;
        rect.origin.y = (size.height - rect.size.height)/2;
    }
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));//clear background
    [image drawInRect:rect];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage;
}
@end

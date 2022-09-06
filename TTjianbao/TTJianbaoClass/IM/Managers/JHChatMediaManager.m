//
//  JHChatMediaManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMediaManager.h"
@interface JHChatMediaManager()

@end

@implementation JHChatMediaManager

+ (void)convertAsset : (PHAsset *)asset handler : (AssetHandler)handler{
    if (asset.mediaType == PHAssetMediaTypeImage) {
        [JHChatMediaManager fetchImageWithAsset:asset imageBlock:^(UIImage *image) {
            [JHChatMediaManager convertImage:image handler:^(UIImage * _Nonnull image, UIImage * _Nonnull thumbImage) {
                if (handler == nil) return;
                handler(nil, image, thumbImage);
            }];
        }];
    }else if (asset.mediaType == PHAssetMediaTypeVideo) {
        [JHChatMediaManager fetchVideoWithAsset:asset urlBlock:^(NSURL *url) {
            [JHChatMediaManager convertVideo:url handler:^(NSString *localUrl, UIImage *thumbImage) {
                if (handler == nil) return;
                handler(localUrl, nil, thumbImage);
            }];
        }];
    }
}

+ (void)convertImage : (UIImage *)image handler : (ImageHandler)handler {
    UIImage *thumbImage = [JHChatMediaManager resizeImage:image size:CGSizeMake(800, 800)];
    if (handler == nil) return;
    handler(image, thumbImage);
}
+ (void)convertVideo : (NSURL *)url handler : (VideoHandler)handler {
    
    UIImage *image = [JHChatMediaManager getVideoFirstViewImage:url];
    
    NSString *outputFileName = [JHChatFileLocationHelper genFilenameWithExt:@"mp4"];
    NSString *outputPath = [JHChatFileLocationHelper filepathForVideo:outputFileName];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset
                                                                     presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    session.outputFileType = AVFileTypeMPEG4;   // 支持安卓某些机器的视频播放
    session.shouldOptimizeForNetworkUse = YES;
    session.videoComposition = [asset nim_videoComposition];  //修正某些播放器不识别视频Rotation的问题
    
    [session exportAsynchronouslyWithCompletionHandler:^(void) {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             switch ([session status]) {
                 case AVAssetExportSessionStatusCompleted:
                     if (handler == nil) return;
                     handler(outputPath, image);
                     break;
                 case AVAssetExportSessionStatusFailed:
                     NSLog(@"转码失败 %@，，，，%@",[[session error] localizedDescription],[session error]);
                     break;
                 default:
                     break;
             }
         });
     }];
}

// 获取视频第一帧
+ (UIImage*)getVideoFirstViewImage:(NSURL *)path {
    
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

+ (UIImage *)resizeImage : (UIImage *)image size : (CGSize )size {
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

/// 获取相册内 图片数据
+ (void)fetchImageWithAsset:(PHAsset*)asset imageBlock:(void(^)(UIImage *image))imageBlock {
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.synchronous = true;//主要是这个设为YES这样才会只走一次
    option.networkAccessAllowed = true;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (imageBlock == nil || result == nil) return;
        imageBlock(result);
    }];
}
/// 获取相册内视频数据
+ (void)fetchVideoWithAsset:(PHAsset*)asset urlBlock:(void(^)(NSURL *url))urlBlock {
    PHVideoRequestOptions *option = [[PHVideoRequestOptions alloc] init];
    
    option.networkAccessAllowed = true;
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:option resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        if (urlBlock == nil) return;
        urlBlock(url);
    }];
}
@end

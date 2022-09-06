//
//  JHVideoCropManager.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVideoCropManager.h"
#import <SVProgressHUD.h>
#import "JHImagePickerPublishManager.h"
// 视频尺寸
#define JHVideoSize (CGSizeMake(1080, 1920))

@implementation JHVideoCropManager

#pragma mark - 接口方法
+ (AVPlayerItem *)mergeMediaPlayerItemActionWithAssetArray:(NSArray <AVAsset *>*)assetArray
                                                 timeRange:(CMTimeRange)timeRange
                                              bgAudioAsset:(AVAsset *)bgAudioAsset
                                            originalVolume:(float)originalVolume
                                             bgAudioVolume:(float)bgAudioVolume {
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithPropertiesOfAsset:composition];
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];

    [self loadMeidaCompostion:composition videoComposition:videoComposition audioMix:audioMix assetArray:assetArray selectTimeRange:timeRange bgAudioAsset:bgAudioAsset originalVolume:originalVolume bgAudioVolume:bgAudioVolume];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:composition];
    playerItem.videoComposition = videoComposition;
    playerItem.audioMix = audioMix;
    return playerItem;
}

#pragma mark - 私有方法

// 生成视频轨
+ (void)loadMeidaCompostion:(AVMutableComposition *)composition
           videoComposition:(AVMutableVideoComposition *)videoComposition
                   audioMix:(AVMutableAudioMix *)audioMix
                 assetArray:(NSArray <AVAsset *>*)assetArray
            selectTimeRange:(CMTimeRange)selectTimeRange
               bgAudioAsset:(AVAsset *)bgAudioAsset
             originalVolume:(float)originalVolume
              bgAudioVolume:(float)bgAudioVolume {
    
    
    // 初始化视频轨和音频轨,伴奏音频轨
    videoComposition.frameDuration = CMTimeMake(1, 30);
    videoComposition.renderSize = JHVideoSize;
    // 创建两条视频轨,处理不同尺寸视频合成问题
    AVMutableCompositionTrack *firstVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *secondVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    NSArray *videoTrackArray = @[firstVideoTrack,secondVideoTrack];

    AVMutableCompositionTrack *audioTrack = nil;
    if (originalVolume > 0) {
        audioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    AVMutableCompositionTrack *bgAudioTrack = nil;
    if (bgAudioVolume > 0) {
        bgAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    }
    
    CMTime startTime = kCMTimeZero;
    CMTimeRange passThroughTimeRanges[assetArray.count];
    
    // 确定开始与结束的下标以及开始与结束的时间点,用于截取时间
    CMTime firstAssetStartTime = kCMTimeZero;
    CMTime endAssetDuration = assetArray.lastObject.duration;
    NSInteger startIndex = 0;
    NSInteger endIndex = assetArray.count - 1;
    
    // 如果是没有设置时间区间,那么直接认定全部选中
    if (!CMTimeRangeEqual(selectTimeRange, kCMTimeRangeZero)) {
        startIndex = -1;
        endIndex = -1;
        CMTime assetTotalTime = kCMTimeZero;
        CMTime videoTotalTime = CMTimeAdd(selectTimeRange.start, selectTimeRange.duration);
        for (int i = 0; i < assetArray.count; i++) {
            AVAsset *asset = assetArray[i];
            assetTotalTime = CMTimeAdd(assetTotalTime, asset.duration);
            if (CMTIME_COMPARE_INLINE(CMTimeSubtract(assetTotalTime,selectTimeRange.start), >, selectTimeRange.start) && startIndex == -1) {
                startIndex = i;
                firstAssetStartTime = CMTimeSubtract(asset.duration, CMTimeSubtract(assetTotalTime,selectTimeRange.start));
            }
            if (CMTIME_COMPARE_INLINE(assetTotalTime, >=, videoTotalTime) && startIndex != -1 && endIndex == -1) {
                endIndex = i;
                endAssetDuration = CMTimeSubtract(asset.duration, CMTimeSubtract(assetTotalTime,videoTotalTime));
            }
        }
    }
    
    NSMutableArray *audioMixArray = [NSMutableArray arrayWithCapacity:16];
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        AVAsset *asset = assetArray[i];
        AVMutableCompositionTrack *videoTrack = videoTrackArray[i % 2];
        AVAssetTrack *videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        if (videoAssetTrack == nil) {
            continue;
        }
        CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
        
        if (i == startIndex) {
            timeRange = CMTimeRangeMake(firstAssetStartTime, CMTimeSubtract(asset.duration, firstAssetStartTime));
        }
        if (i == endIndex) {
            timeRange = CMTimeRangeMake(kCMTimeZero, endAssetDuration);
        }

        [videoTrack insertTimeRange:timeRange ofTrack:videoAssetTrack atTime:startTime error:nil];
        passThroughTimeRanges[i] = CMTimeRangeMake(startTime, timeRange.duration);
        
        if (originalVolume > 0) {
            [audioTrack insertTimeRange:timeRange ofTrack:[asset tracksWithMediaType:AVMediaTypeAudio][0] atTime:startTime error:nil];
            AVMutableAudioMixInputParameters *audioTrackParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:audioTrack];
            [audioTrackParameters setVolume:originalVolume atTime:timeRange.duration];
            [audioMixArray addObject:audioTrackParameters];
        }
        startTime = CMTimeAdd(startTime,timeRange.duration);
    }
    
    NSMutableArray *instructions = [NSMutableArray arrayWithCapacity:16];
    
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        
        AVMutableCompositionTrack *videoTrack = videoTrackArray[i % 2];
        AVMutableVideoCompositionInstruction * passThroughInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        passThroughInstruction.timeRange = passThroughTimeRanges[i];
        AVMutableVideoCompositionLayerInstruction * passThroughLayer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        [JHVideoCropManager changeVideoSizeWithAsset:assetArray[i] passThroughLayer:passThroughLayer];
        passThroughInstruction.layerInstructions = @[passThroughLayer];
        [instructions addObject:passThroughInstruction];
    }
    videoComposition.instructions = instructions;
        
    // 插入伴奏
    if (bgAudioAsset != nil && bgAudioVolume > 0) {
        AVAssetTrack *assetAudioTrack = [[bgAudioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
        [bgAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, startTime) ofTrack:assetAudioTrack atTime:kCMTimeZero error:nil];
        AVMutableAudioMixInputParameters *bgAudioTrackParameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:bgAudioTrack];
        [bgAudioTrackParameters setVolume:bgAudioVolume atTime:startTime];
        [audioMixArray addObject:bgAudioTrackParameters];
    }
    audioMix.inputParameters = audioMixArray;
}

// 处理视频尺寸大小
+ (void)changeVideoSizeWithAsset:(AVAsset *)asset passThroughLayer:(AVMutableVideoCompositionLayerInstruction *)passThroughLayer {
    
    AVAssetTrack *videoAssetTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (videoAssetTrack == nil) {
        return;
    }
    CGSize naturalSize = videoAssetTrack.naturalSize;
    
    if ([JHVideoCropManager videoDegressWithVideoAsset:asset] == 90) {
        naturalSize = CGSizeMake(naturalSize.height, naturalSize.width);
    }
    
    if ((int)naturalSize.width % 2 != 0) {
        naturalSize = CGSizeMake(naturalSize.width + 1.0, naturalSize.height);
    }
    
    CGSize videoSize = JHVideoSize;
    
    if ([JHVideoCropManager videoDegressWithVideoAsset:asset] == 90) {
        CGFloat height = videoSize.width * naturalSize.height / naturalSize.width;
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(videoSize.width, videoSize.height/2.0 - height/2.0);
        CGAffineTransform scaleTransform = CGAffineTransformScale(translateToCenter, videoSize.width/naturalSize.width, height/naturalSize.height);
        CGAffineTransform mixedTransform = CGAffineTransformRotate(scaleTransform, M_PI_2);
        [passThroughLayer setTransform:mixedTransform atTime:kCMTimeZero];
    } else {
        CGFloat height = videoSize.width * naturalSize.height / naturalSize.width;
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation(0, videoSize.height/2.0 - height/2.0);
        CGAffineTransform scaleTransform = CGAffineTransformScale(translateToCenter, videoSize.width/naturalSize.width, height/naturalSize.height);
        [passThroughLayer setTransform:scaleTransform atTime:kCMTimeZero];
    }
}

// 计算视频角度
+ (NSInteger)videoDegressWithVideoAsset:(AVAsset *)videoAsset {
    
    NSInteger videoDegress = 0;
    NSArray *assetVideoTracks = [videoAsset tracksWithMediaType:AVMediaTypeVideo];
    if (assetVideoTracks.count > 0) {
        AVAssetTrack *videoTrack = assetVideoTracks.firstObject;
        CGAffineTransform affineTransform = videoTrack.preferredTransform;
        if(affineTransform.a == 0 && affineTransform.b == 1.0 && affineTransform.c == -1.0 && affineTransform.d == 0){
            videoDegress = 90;
        }else if(affineTransform.a == 0 && affineTransform.b == -1.0 && affineTransform.c == 1.0 && affineTransform.d == 0){
            videoDegress = 270;
        }else if(affineTransform.a == 1.0 && affineTransform.b == 0 && affineTransform.c == 0 && affineTransform.d == 1.0){
            videoDegress = 0;
        }else if(affineTransform.a == -1.0 && affineTransform.b == 0 && affineTransform.c == 0 && affineTransform.d == -1.0){
            videoDegress = 180;
        }
    }
    return videoDegress;
}

#pragma mark -------- 裁剪截取 --------
+ (void)exportVideoWithAVAsset:(AVURLAsset *)asset timeRange:(CMTimeRange)timeRange selectedBlock:(void(^)(NSArray <JHAlbumPickerModel *> *dataArray))selectedBlock {
    [SVProgressHUD showWithStatus:@"正在导出视频"];
    [self startExportVideoWithVideoAsset:asset timeRange:timeRange presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {

        NSLog(@"%@",outputPath);
        UIImage *image = [self getCoverImage:outputPath];
        JHAlbumPickerModel *model = [JHAlbumPickerModel new];
        model.videoPath = outputPath;
        model.image = image;
        model.isVideo = YES;
        model.avasset = asset;
        dispatch_async(dispatch_get_main_queue(),  ^{
            if(selectedBlock){
                selectedBlock(@[model]);
            }
            [SVProgressHUD dismiss];
        });
    } failure:^(NSString *errorMessage, NSError *error) {
          dispatch_async(dispatch_get_main_queue(),  ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
            [SVProgressHUD showErrorWithStatus:@"视频导出错误，稍后重试"];
          });
    }];
}


+ (void)startExportVideoWithVideoAsset:(AVURLAsset *)videoAsset timeRange:(CMTimeRange)timeRange presetName:(NSString *)presetName success:(void (^)(NSString *outputPath))success failure:(void (^)(NSString *errorMessage, NSError *error))failure {
    // Find compatible presets by video asset.
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:videoAsset];
    
    // Begin to compress video
    // Now we just compress to low resolution if it supports
    // If you need to upload to the server, but server does't support to upload by streaming,
    // You can compress the resolution to lower. Or you can support more higher resolution.
    if ([presets containsObject:presetName]) {
        AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:videoAsset presetName:presetName];
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss-SSS"];
        NSString *outputPath = [NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches/video-%@.mp4", [formater stringFromDate:[NSDate date]]];
        // Optimize for network use.
        session.shouldOptimizeForNetworkUse = true;
        
        NSArray *supportedTypeArray = session.supportedFileTypes;
        if ([supportedTypeArray containsObject:AVFileTypeMPEG4]) {
            session.outputFileType = AVFileTypeMPEG4;
        } else if (supportedTypeArray.count == 0) {
            if (failure) {
                failure(@"该视频类型暂不支持导出", nil);
            }
            NSLog(@"No supported file types 视频类型暂不支持导出");
            return;
        } else {
            session.outputFileType = [supportedTypeArray objectAtIndex:0];
            if (videoAsset.URL && videoAsset.URL.lastPathComponent) {
                outputPath = [outputPath stringByReplacingOccurrencesOfString:@".mp4" withString:[NSString stringWithFormat:@"-%@", videoAsset.URL.lastPathComponent]];
            }
        }
        // NSLog(@"video outputPath = %@",outputPath);
        session.outputURL = [NSURL fileURLWithPath:outputPath];
        if(!CMTimeRangeEqual(timeRange, kCMTimeRangeZero))
        {
            session.timeRange = timeRange;
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches"]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Library/Caches"] withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
//        if ([TZImagePickerConfig sharedInstance].needFixComposition) {
//            AVMutableVideoComposition *videoComposition = [self fixedCompositionWithAsset:videoAsset];
//            if (videoComposition.renderSize.width) {
//                // 修正视频转向
//                session.videoComposition = videoComposition;
//            }
//        }

        // Begin to export video to the output path asynchronously.
        [session exportAsynchronouslyWithCompletionHandler:^(void) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (session.status) {
                    case AVAssetExportSessionStatusUnknown: {
                        NSLog(@"AVAssetExportSessionStatusUnknown");
                    }  break;
                    case AVAssetExportSessionStatusWaiting: {
                        NSLog(@"AVAssetExportSessionStatusWaiting");
                    }  break;
                    case AVAssetExportSessionStatusExporting: {
                        NSLog(@"AVAssetExportSessionStatusExporting");
                    }  break;
                    case AVAssetExportSessionStatusCompleted: {
                        NSLog(@"AVAssetExportSessionStatusCompleted");
                        if (success) {
                            success(outputPath);
                        }
                    }  break;
                    case AVAssetExportSessionStatusFailed: {
                        NSLog(@"AVAssetExportSessionStatusFailed");
                        if (failure) {
                            failure(@"视频导出失败", session.error);
                        }
                    }  break;
                    case AVAssetExportSessionStatusCancelled: {
                        NSLog(@"AVAssetExportSessionStatusCancelled");
                        if (failure) {
                            failure(@"导出任务已被取消", nil);
                        }
                    }  break;
                    default: break;
                }
            });
        }];
    } else {
        if (failure) {
            NSString *errorMessage = [NSString stringWithFormat:@"当前设备不支持该预设:%@", presetName];
            failure(errorMessage, nil);
        }
    }
}

+ (UIImage *)getCoverImage:(NSString *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:url] options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 1000);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}
@end

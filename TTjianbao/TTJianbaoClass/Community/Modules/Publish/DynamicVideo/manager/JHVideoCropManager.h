//
//  JHVideoCropManager.h
//  TTjianbao
//
//  Created by wangjianios on 2020/6/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "JHImagePickerPublishManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHVideoCropManager : NSObject

/// 合成录制视频,返回播放单体.(主要用于播放,合成时间短)
/// @param assetArray 媒体数组
/// @param timeRange 选择时间区间,如果想选择全部,请使用 kCMTimeRangeZero
/// @param bgAudioAsset 伴奏音乐
/// @param originalVolume 视频音量(0 ~ 1)
/// @param bgAudioVolume 背景音频音量(0 ~ 1)
+ (AVPlayerItem *)mergeMediaPlayerItemActionWithAssetArray:(NSArray <AVAsset *>*)assetArray
                                                 timeRange:(CMTimeRange)timeRange
                                              bgAudioAsset:(AVAsset *)bgAudioAsset
                                            originalVolume:(float)originalVolume
                                             bgAudioVolume:(float)bgAudioVolume;


+ (void)exportVideoWithAVAsset:(AVURLAsset *)asset
                     timeRange:(CMTimeRange)timeRange
                 selectedBlock:(void(^)(NSArray <JHAlbumPickerModel *> *dataArray))selectedBlock;

+ (UIImage *)getCoverImage:(NSString *)url;

@end

NS_ASSUME_NONNULL_END

//
//  NTESMixAudioSettingView.h
//  TTjianbao
//
//  Created by chris on 2016/12/15.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NTESMixAudioSettingViewDelegate <NSObject>

- (void)didSelectMixAuido:(NSURL *)url
               sendVolume:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume;

- (void)didPauseMixAudio;

- (void)didResumeMixAudio;

- (void)didUpdateMixAuido:(CGFloat)sendVolume
           playbackVolume:(CGFloat)playbackVolume;

@end

@interface NTESMixAudioSettingView : UIControl

@property (nonatomic, weak) id<NTESMixAudioSettingViewDelegate> delegate;

- (void)show;

- (void)dismiss;

@end

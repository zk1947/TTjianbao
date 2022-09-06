//
//  JHPlayerControlView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPlayerControlView.h"
#import "ZFSliderView.h"
#import "TTjianbaoHeader.h"

@interface JHPlayerControlView ()<ZFSliderViewDelegate>

@end
@implementation JHPlayerControlView
//@synthesize player;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setMyStyle];

        self.seekToPlay = YES;
        MJWeakSelf
        self.sliderValueChanged = ^(CGFloat value) {
            if (weakSelf.sliderValueChange) {
                weakSelf.sliderValueChanged(value);
            }
            
        };

        self.sliderValueChanging = ^(CGFloat value, BOOL forward) {
            if (weakSelf.sliderValueChange) {
                weakSelf.sliderValueChanged(value);
            }
        };
        

    }
    return self;
}

- (void)setPlayer:(ZFPlayerController *)player {
    super.player = player;
    /// 解决播放时候黑屏闪一下问题
    [player.currentPlayerManager.view insertSubview:self.coverImageView atIndex:1];
//    self.coverImageView.frame = player.currentPlayerManager.view.bounds;
//    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.coverImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    [super videoPlayer:videoPlayer currentTime:currentTime totalTime:totalTime];
    if (self.sliderValueChanged) {
        self.sliderValueChanged(videoPlayer.progress);
    }


}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {

    if (self.bottomToolView.alpha>0.0) {
        [self hideControlView];
        if (self.singleTapBack) {
            self.singleTapBack(NO);
        }

    }else {
        [self showControlView];
        if (self.singleTapBack) {
            self.singleTapBack(YES);
        }

    }

}


- (void)gestureDoubleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.doubleTapBack) {
        self.doubleTapBack();
    }
}


- (void)showCoverViewWithUrl:(NSString *)coverUrl {
    [self.coverImageView jhSetImageWithURL:[NSURL URLWithString:coverUrl] placeholder:nil];

}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {

    if (state == ZFPlayerLoadStatePrepare) {
        self.coverImageView.hidden = NO;
    } else if (state == ZFPlayerLoadStatePlaythroughOK || state == ZFPlayerLoadStatePlayable) {
        self.coverImageView.hidden = YES;
    }
//    if (self.hiddenCover) {
//        self.hiddenCover(self.coverImageView.hidden);
//    }
}

/// 播放状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer playStateChanged:(ZFPlayerPlaybackState)state {
    if (state == ZFPlayerPlayStatePlaying) {
        [self playBtnSelectedState:YES];
    } else if (state == ZFPlayerPlayStatePaused) {
        [self playBtnSelectedState:NO];
    } else if (state == ZFPlayerPlayStatePlayFailed) {
        
    }
}




- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
//        _coverImageView.backgroundColor = [UIColor redColor];
    }
    return _coverImageView;
}


@end

//
//  JHOnlineAppraiseControlView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseControlView.h"
#import <ZFPlayer/ZFPlayerController.h>
#import "ZFSliderView.h"

#define bottomMargin     (UI.bottomSafeAreaHeight + 46)


@interface JHOnlineAppraiseControlView ()
@property (nonatomic, strong) ZFSliderView *sliderView;
@end

@implementation JHOnlineAppraiseControlView
@synthesize player = _player;

- (void)setPlayer:(ZFPlayerController *)player {
    _player = player;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.playButton];
        [self resetControlView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playButton.frame = CGRectMake(0, 0, 40, 40);
    self.playButton.center = CGPointMake(ScreenW/2, ScreenH/2);
    self.sliderView.frame = CGRectMake(0, ScreenH - bottomMargin - 2, ScreenW, 2.);
}

- (void)resetControlView {
    self.playButton.selected = NO;
}

/// 加载状态改变
- (void)videoPlayer:(ZFPlayerController *)videoPlayer loadStateChanged:(ZFPlayerLoadState)state {
    if ((state == ZFPlayerLoadStateStalled || state == ZFPlayerLoadStatePrepare) && videoPlayer.currentPlayerManager.isPlaying) {
        [self.sliderView startAnimating];
    } else {
        [self.sliderView stopAnimating];
    }
}

/// 播放进度改变回调
- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    self.sliderView.value = videoPlayer.progress;
}

- (void)gestureSingleTapped:(ZFPlayerGestureControl *)gestureControl {
    if (self.player.currentPlayerManager.isPlaying) {
        [self.player.currentPlayerManager pause];
        self.playButton.selected = YES;
        self.playButton.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        [UIView animateWithDuration:0.2f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.playButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    } else {
        [self.player.currentPlayerManager play];
        self.playButton.selected = NO;
    }
}

- (void)showCoverViewWithUrl:(NSString *)coverUrl {
//    [self.player.currentPlayerManager.view.coverImageView setImageWithURLString:coverUrl placeholder:[UIImage imageNamed:@"img_video_loading"]];
}

#pragma mark - getter

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.userInteractionEnabled = NO;
        [_playButton setImage:[UIImage imageNamed:@"icon_play_cirle"] forState:UIControlStateSelected];
    }
    return _playButton;
}

- (ZFSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[ZFSliderView alloc] init];
        _sliderView.maximumTrackTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
        _sliderView.minimumTrackTintColor = [UIColor whiteColor];
        _sliderView.bufferTrackTintColor  = [UIColor clearColor];
        _sliderView.sliderHeight = 1;
        _sliderView.isHideSliderBlock = NO;
    }
    return _sliderView;
}

@end

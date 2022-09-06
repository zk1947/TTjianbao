//
//  JHVideoPlayControlView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHVideoPlayControlView.h"
#import "UIView+NEPlayer.h"
#import "JHVideoPlayControlBottomView.h"
#import "MJRefresh.h"

@interface JHVideoPlayControlView ()<JHVideoPlayControlBottomViewDelegate>
{
     BOOL _isDraggingInternal;
     UIImageView  *circle2;
     UIImageView  *circle1;
     UIImageView  *liveBack;
}
@property (nonatomic, strong) JHVideoPlayControlBottomView *bottomView;
@property (nonatomic, strong) UIView *topControlView; //顶部控制条
@property (nonatomic, strong) UIView *bottomControlView; //底部控制条
@property (nonatomic, strong) UIControl *mediaControl; //媒体覆盖层
@property (nonatomic, strong) UIControl *overlayControl; //控制层
@property (nonatomic, strong) UIImageView *headImage; 
@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮
@property (nonatomic, strong) UIButton *playQuitBtn;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UILabel *totalDuration; //文件时长
@property (nonatomic, strong) UISlider *videoProgress;//播放进度
@property (nonatomic, strong) UIActivityIndicatorView *bufferingIndicate; //缓冲动画
@property (nonatomic, strong) UILabel *bufferingReminder; //缓冲提示
@property(nonatomic,strong) NSMutableArray* liveRoomModes;
@end


@implementation JHVideoPlayControlView
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.clipsToBounds=YES;
        [self addSubview:self.mediaControl];
        [self addSubview:self.overlayControl];
        self.playControlHidden=NO;
     
        [_mediaControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
          
        }];
        [_overlayControl mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self);
            
        }];
        
        [self addSubview:self.bufferingIndicate];
        [self addSubview:self.bufferingReminder];
        _bufferingIndicate.center = CGPointMake(ScreenW/2, (ScreenH - 32)/2);
        _bufferingReminder.top = _bufferingIndicate.bottom + 32.0;
        _bufferingReminder.centerX = _bufferingIndicate.centerX;
    
        _bottomView=[[JHVideoPlayControlBottomView alloc]init];
        _bottomView.delegate=self;
        [_overlayControl addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            
              make.left.right.equalTo(self);
              make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight);
              make.height.offset(50);
        }];
      
         [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:8];
    }
       return self;
}

- (UIActivityIndicatorView *)bufferingIndicate {
    if (!_bufferingIndicate) {
        _bufferingIndicate = [[UIActivityIndicatorView alloc] init];
        [_bufferingIndicate setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        _bufferingIndicate.hidden = YES;
    }
    return _bufferingIndicate;
}

- (UILabel *)bufferingReminder {
    if (!_bufferingReminder) {
        _bufferingReminder = [[UILabel alloc] init];
        _bufferingReminder.text = @"";
        _bufferingReminder.textAlignment = NSTextAlignmentCenter; //文字居中
        _bufferingReminder.textColor = [UIColor whiteColor];
        _bufferingReminder.hidden = YES;
        [_bufferingReminder sizeToFit];
    }
    return _bufferingReminder;
}
#pragma mark - 控件属性
- (UIControl *)mediaControl {
    if (!_mediaControl) {
        _mediaControl = [[UIControl alloc] init];
        [_mediaControl addTarget:self action:@selector(onClickMediaControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mediaControl;
}
- (UIControl *)overlayControl {
    if (!_overlayControl) {
        _overlayControl = [[UIControl alloc] init];
        [_overlayControl addTarget:self action:@selector(onClickOverlayControlAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _overlayControl;
}
#pragma mark - Action
- (void)onClickMediaControlAction:(UIControl *)control {
    
    _overlayControl.hidden = NO;
    CGRect rect = _overlayControl.frame;
    rect.origin.y = self.mj_y;
    [UIView animateWithDuration:0.25f animations:^{
        _overlayControl.frame = rect;
        
    }];
    
    self.playControlHidden=NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self performSelector:@selector(controlOverlayHide) withObject:nil afterDelay:5];
    [self.superview touchesBegan:[NSSet set] withEvent:nil];
}

- (void)onClickOverlayControlAction:(UIControl *)control {

    CGRect rect = _overlayControl.frame;
    rect.origin.y = self.mj_h;
    [UIView animateWithDuration:0.25f animations:^{
        
         _overlayControl.frame = rect;
    } completion:^(BOOL finished) {
        
         _overlayControl.hidden = YES;
    }];
    
     self.playControlHidden=YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(controlOverlayHide) object:nil];
    [self.superview touchesBegan:[NSSet set] withEvent:nil];
}

- (void)controlOverlayHide {
    
    CGRect rect = _overlayControl.frame;
    rect.origin.y = self.mj_h;
    [UIView animateWithDuration:0.25f animations:^{
        
        _overlayControl.frame = rect;
    } completion:^(BOOL finished) {
        
        _overlayControl.hidden = YES;
    }];
    self.playControlHidden=YES;
}

//- (BOOL)isDragging {
//    
//    return _isDraggingInternal;
//}
#pragma mark =============== setter ===============
- (void)setIsPlaying:(BOOL)isPlaying {
//    _isPlaying = isPlaying;
//    _playBtn.selected = isPlaying;
    [self.bottomView setIsPlaying:isPlaying];
}
- (void)setIsBuffing:(BOOL)isBuffing {
    _isBuffing = isBuffing;
    
    if (isBuffing) {
        _bufferingIndicate.hidden = NO;
        [_bufferingIndicate startAnimating];
        _bufferingReminder.hidden = NO;

    } else {
        _bufferingIndicate.hidden = YES;
        [_bufferingIndicate stopAnimating];
        _bufferingReminder.hidden = YES;
    }
}

- (void)setCurrentPos:(NSTimeInterval)currentPos {
//    _currentPos = currentPos;
//    NSInteger currPos  = round(currentPos);
//    _videoProgress.value = currPos;
    
     [self.bottomView setCurrentPos:currentPos];
}

- (void)setDuration:(NSTimeInterval)duration {
//    _duration = duration;
//
//    if (duration > 0) {
//        NSInteger mDuration = round(duration);
//        _totalDuration.text=[CommHelp getHMSWithSecond:mDuration];
//        _videoProgress.maximumValue = duration;
//    }
//    else {
//        _videoProgress.value = 0.0;
//        _totalDuration.text = @"--:--:--";
//    }
    
      [self.bottomView setDuration:duration];
    
 }

//- (void)onClickBtnAction:(UIButton *)btn {
////    if (btn == _playBtn) {
////        _playBtn.selected = !_playBtn.isSelected;
//        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickPlay:isPlay:)]) {
//            [_delegate controlViewOnClickPlay:self isPlay:btn.isSelected];
//        }
////    }
//}

- (void)controlViewOnClickPlay:(JHVideoPlayControlBottomView *)controlView isPlay:(BOOL)isPlay{

    if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickPlay:isPlay:)]) {

                    [_delegate controlViewOnClickPlay:self isPlay:isPlay];
                }

}

- (void)controlViewOnClickSeek:(JHVideoPlayControlBottomView *)controlView dstTime:(NSTimeInterval)dstTime{
    
    if (_isAllowSeek) {
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSeek:dstTime:)]) {
            [_delegate controlViewOnClickSeek:self dstTime:dstTime];
        }
    }
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//
//
//}
@end

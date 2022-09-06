//
//  JHVideoPlayControlBottomView.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHVideoPlayControlBottomView.h"
#import "TTjianbaoHeader.h"

@interface JHVideoPlayControlBottomView ()
{
      BOOL _isDraggingInternal;
}
@property (nonatomic, strong) UIView *bottomControlView; //底部控制条

@property (nonatomic, strong) UIButton *playBtn;  //播放/暂停按钮
@property (nonatomic, strong) UILabel *totalDuration; //文件时长
@property (nonatomic, strong) UISlider *videoProgress;//播放进度
@end

@implementation JHVideoPlayControlBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.clipsToBounds = YES;
        [self initBottomView];
    }
    return self;
}
-(void)initBottomView{
    
    [self addSubview:self.bottomControlView];
    [_bottomControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [_bottomControlView addSubview:self.playBtn];
    [_bottomControlView addSubview:self.totalDuration];
    [_bottomControlView addSubview:self.videoProgress];
    
    
    [_playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomControlView);
        make.size.mas_equalTo(CGSizeMake(30, 34));
        make.left.equalTo(_bottomControlView.mas_left).offset(10);
    }];
    
    [_totalDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomControlView);
        make.right.equalTo(_bottomControlView.mas_right).offset(-10);
    }];
    
    [_videoProgress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomControlView);
        make.left.equalTo(_playBtn.mas_right).offset(10);
        make.right.equalTo(_totalDuration.mas_left).offset(-10);
        make.height.equalTo(@30);
    }];
    
}

- (UIView *)bottomControlView {
    if (!_bottomControlView) {
        _bottomControlView = [[UIView alloc] init];
    }
    return _bottomControlView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"appraisal_video_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"appraisal_video_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UISlider *)videoProgress {
    if (!_videoProgress) {
        _videoProgress = [[UISlider alloc] init];
        //        _videoProgress. continuous=NO;
        [_videoProgress setThumbImage:[UIImage imageNamed:@"appraisal_top_dian"] forState:UIControlStateNormal];
        [_videoProgress setMaximumTrackImage:[UIImage imageNamed:@"appraisal_top_line"] forState:UIControlStateNormal];
        [_videoProgress setMinimumTrackImage:[UIImage imageNamed:@"appraisal_yellow_line"] forState:UIControlStateNormal];
        [_videoProgress addTarget:self action:@selector(onClickSeekAction:) forControlEvents:UIControlEventValueChanged];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [_videoProgress addTarget:self action:@selector(onClickSeekTouchDownside:) forControlEvents:UIControlEventTouchDown];
    }
    return _videoProgress;
}
- (UILabel *)totalDuration {
    if (!_totalDuration) {
        _totalDuration = [[UILabel alloc] init];
        _totalDuration.text = @"--:--:--";
        _totalDuration.textColor = [UIColor whiteColor];
        _totalDuration.font = [UIFont systemFontOfSize:10.0];
        //        _totalDuration.backgroundColor=[UIColor redColor];
        _totalDuration.numberOfLines = 1;
        _totalDuration.textAlignment = UIControlContentHorizontalAlignmentRight;
        _totalDuration.lineBreakMode = NSLineBreakByWordWrapping;
        [_totalDuration setContentHuggingPriority: UILayoutPriorityRequired forAxis: UILayoutConstraintAxisHorizontal];
    }
    return _totalDuration;
}

- (BOOL)isDragging {
    
    return _isDraggingInternal;
}
#pragma mark =============== setter ===============
- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    _playBtn.selected = isPlaying;
}


- (void)setCurrentPos:(NSTimeInterval)currentPos {
    _currentPos = currentPos;
    
    if (!self.isDragging) {
        
        NSInteger currPos  = round(currentPos);
        _videoProgress.value = currPos;
        
    }
   
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
    
    if (duration > 0) {
        NSInteger mDuration = round(duration);
        _totalDuration.text=[CommHelp getHMSWithSecond:mDuration];
        _videoProgress.maximumValue = duration;
    }
    else {
        _videoProgress.value = 0.0;
        _totalDuration.text = @"--:--:--";
    }
}

- (void)onClickBtnAction:(UIButton *)btn {
  
       if (btn == _playBtn) {
            _playBtn.selected = !_playBtn.isSelected;
            if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickPlay:isPlay:)]) {
                [_delegate controlViewOnClickPlay:self isPlay:btn.isSelected];
            }
        }
    
}
- (void)onClickSeekAction:(UISlider *)slider {
    
    _isDraggingInternal = YES;
}

- (void)onClickSeekTouchDownside:(UISlider *)slider {
    
    NSLog(@"kaishi");
    if (_isAllowSeek) {
        _isDraggingInternal = YES;
    }
}

- (void)onClickSeekTouchUpInside:(UISlider *)slider {
    
    NSLog(@"jieshu");
        if (_delegate && [_delegate respondsToSelector:@selector(controlViewOnClickSeek:dstTime:)]) {
            [_delegate controlViewOnClickSeek:self dstTime:slider.value];
      
        _isDraggingInternal = NO;
    }
}

@end

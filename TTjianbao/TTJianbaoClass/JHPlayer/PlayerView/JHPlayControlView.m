//
//  JHPlayControlView.m
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import "JHPlayControlView.h"

@implementation JHPlayControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setTitleInfo:(NSString *)titleInfo {
    _titleInfo = titleInfo;
}

- (void)setFullScreen:(BOOL)fullScreen {
    _fullScreen = fullScreen;
}

- (void)setVerticalScreen:(BOOL)verticalScreen {
    _verticalScreen = verticalScreen;
}

- (void)setPlay:(BOOL)play {
    _play = play;
}

- (void)startLoading {
    
}

- (void)stopLoading {
    
}

- (void)showRetry {
    
}

- (void)setCompleteView:(UIView *)completeView{
    
}

- (void)setCurrentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime prePlayTime:(NSTimeInterval)prePlayTime {
    
}

@end

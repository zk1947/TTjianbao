//
//  JHPlayerFullScreenControlView.h
//  TTjianbao
//
//  Created by lihui on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@protocol JHPlayerFullScreenControlViewDelegate <NSObject>

- (void)gesturePanChanged:(CGFloat)panProgress;

@end

@interface JHPlayerFullScreenControlView : UIView <ZFPlayerMediaControl>

/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, weak) id<JHPlayerFullScreenControlViewDelegate> delegate;

@property (nonatomic, strong) JHPostDetailModel *postInfo;

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

@property (nonatomic, copy) void(^actionBlock)(JHFullScreenControlActionType actionType);
@property (nonatomic, copy) void(^playBlock)(BOOL isPlay);

- (void)resetControlView;
- (void)prepareToRePlay;




@end

NS_ASSUME_NONNULL_END

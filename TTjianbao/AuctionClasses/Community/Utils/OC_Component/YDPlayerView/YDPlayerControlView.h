//
//  YDPlayerControlView.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  播放器工具栏
//

#import <UIKit/UIKit.h>
#import "ZFPlayerMediaControl.h"
#import "ZFSpeedLoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDPlayerControlView : UIView <ZFPlayerMediaControl>

/// 控制层自动隐藏的时间，默认4秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(nullable NSString *)title coverURLString:(nullable NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

@end

NS_ASSUME_NONNULL_END

//
//  JHVideoPlayControlBottomView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHVideoPlayControlBottomView;

@protocol JHVideoPlayControlBottomViewDelegate <NSObject>

@optional
- (void)controlViewOnClickPlay:(JHVideoPlayControlBottomView *)controlView isPlay:(BOOL)isPlay;
- (void)controlViewOnClickSeek:(JHVideoPlayControlBottomView *)controlView dstTime:(NSTimeInterval)dstTime;

@end

#import "BaseView.h"

@interface JHVideoPlayControlBottomView : BaseView
@property (nonatomic, weak) id<JHVideoPlayControlBottomViewDelegate> delegate;
@property (nonatomic, assign, readonly) BOOL isDragging; //正在拖拽

@property (nonatomic, assign) NSTimeInterval currentPos; //当前播放时间

@property (nonatomic, assign) NSTimeInterval duration; //视频时长

@property (nonatomic, copy) NSString *fileTitle; //视频标题

@property (nonatomic, assign) BOOL isPlaying; //正在播放

@property (nonatomic, assign) BOOL isBuffing; //正在缓冲

@property (nonatomic, assign) BOOL isAllowSeek; //是否允许seek

@end



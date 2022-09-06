//
//  JHBaseListPlayerViewController.h
//  TTjianbao
//  有视频的列表 需要自动播放视频的基类 目前只适配社区关注页视频播放
//  Created by yaoyao on 2020/4/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDBaseViewController.h"
#import "ZFPlayerController.h"
#import "JHBaseControlView.h"

extern NSInteger const JHContainerVideoViewTag;

NS_ASSUME_NONNULL_BEGIN

@protocol ZFPlayerMediaControl;

@interface JHBaseListPlayerViewController : YDBaseViewController

- (void)initPlayerWithListView:(UIScrollView *)listView controlView:(UIView <ZFPlayerMediaControl> *)controlView;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) JHBaseControlView<ZFPlayerMediaControl> *controlView;

///只能是UITableView 或者 UICollectionView
@property (nonatomic, strong) UIScrollView *videoListView;

/// 要播放的视频url数组（NSURL *） 如果不是视频需要传@""占位
@property (nonatomic, copy) NSArray<NSURL *> *playVideoUrls;

/// 某个section下面的需要自动播放
@property (nonatomic, assign) NSInteger section;

/// 获取某个indexPath的视频播放进度
- (NSTimeInterval)currentTimeWithIndexPath:(NSIndexPath *)indexPath;

/// 双击事件
@property (nonatomic, copy) void(^doubleTapBack)(NSIndexPath *indexPath);

/// 单击事件
@property (nonatomic, copy) void(^singleTapBack)(NSIndexPath *indexPath);

/// 获取封面图 返回 UIImage
@property (nonatomic, copy) UIImage *(^getCoverImage)(NSIndexPath *indexPath);

/// 是否静音
@property (nonatomic, assign) BOOL isVideoMute;

- (void)checkCanPlay;

@end

NS_ASSUME_NONNULL_END

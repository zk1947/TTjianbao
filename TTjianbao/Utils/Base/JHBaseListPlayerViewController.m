//
//  JHBaseListPlayerViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2020/4/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListPlayerViewController.h"
#import "ZFAVPlayerManager.h"
#import "JHLikeAnimation.h"
#import "JHSQManager.h"
#import "JHSettingAutoPlayController.h"

@interface JHBaseListPlayerViewController ()<UIScrollViewDelegate>

//解决加载黑屏问题
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, assign) BOOL isAppear;

@end

@implementation JHBaseListPlayerViewController

NSInteger const JHContainerVideoViewTag = 100;

- (void)dealloc {
    NSLog(@"🔥");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    @weakify(self);
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        @strongify(self);
        JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //移动蜂窝
                if(type == JHAutoPlayStatusWIFI)
                {
                    [self stopPlayer];
                }
            }
                break;
            default:
                break;
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self checkCanPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self stopPlayer];
}

-(void)stopPlayer
{
    if (self.player.playingIndexPath) {
        [self.player stopCurrentPlayingCell];
    }
}

#pragma mark - get

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}




#pragma mark - private method

- (void)checkCanPlay {
    
    /// 可以播放状态
    JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
    
    ///关闭
    if(type == JHAutoPlayStatusClose)
    {
        return;
    }
    //wifi环境下蜂窝
    if (type == JHAutoPlayStatusWIFI)
    {
        if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            return;
        }
    }
    
    NSArray *array;
    //1是tablview 2是collectionView 默认0
    int listViewType = 0;
    if ([self.videoListView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.videoListView;
        array = [tableView indexPathsForVisibleRows];
        listViewType = 1;
    }
    
    if ([self.videoListView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.videoListView;
        array = [collectionView indexPathsForVisibleItems];
        listViewType = 2;
    }
    
    [self checkWithArray:array type:listViewType];
    
}

- (void)checkWithArray:(NSArray *)array type:(NSInteger)listViewType {
    BOOL hasPlay = NO;
    for (int i = 0; i < array.count; i++) {
        NSIndexPath *indexPath = array[i];
        if (indexPath.section != self.section) {
            continue;
        }
        
        UIView *cell = nil;
        if (listViewType == 1) {
            cell = [((UITableView *)self.videoListView) cellForRowAtIndexPath:indexPath];
        } else if (listViewType == 2) {
            cell = [((UICollectionView *)self.videoListView) cellForItemAtIndexPath:indexPath];
        }
        if (self.playVideoUrls.count > indexPath.row) {
            
            NSURL *url = self.player.assetURLs[indexPath.row];
            if ([url isKindOfClass:[NSURL class]] && [url.absoluteString isNotBlank]) {
                UIView *containerView = [cell viewWithTag:JHContainerVideoViewTag];
                self.coverImageView.frame = containerView.bounds;
                self.coverImageView.image = kDefaultCoverImage;
                
                NSLog(@"containerView.frame=%@", NSStringFromCGRect(containerView.frame));
                CGRect rect = [containerView.superview convertRect:containerView.frame toView:JHKeyWindow];
                if (CGRectContainsRect(JHKeyWindow.bounds, rect)) {
                    hasPlay = YES;
                    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
                    break;
                }
            }
        }
    }
    if (!hasPlay) {
        if (self.player.currentPlayerManager.isPlaying) {
            [self.player stopCurrentPlayingCell];
        }
    }
}

- (void)initPlayerWithListView:(UIScrollView *)listView controlView:(JHBaseControlView <ZFPlayerMediaControl> *)controlView {
    self.videoListView = listView;
    self.controlView = controlView;
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.player = [ZFPlayerController playerWithScrollView:self.videoListView playerManager:playerManager containerViewTag:JHContainerVideoViewTag];
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    self.player.playerDisapperaPercent = 0.4;
    self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
    self.player.stopWhileNotVisible = YES;
    self.player.assetURLs = self.playVideoUrls;
    self.player.currentPlayerManager.muted = [JHSQManager isMute]; //[[NSUserDefaults standardUserDefaults] boolForKey:@"isVideoMute"];
    [self playerBlock];
    
}

- (void)playerBlock {
    @weakify(self)
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
        
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
//        @strongify(self)
    };
    self.player.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {
        @strongify(self);
        if (loadState == ZFPlayerLoadStatePrepare) {
            self.coverImageView.hidden = NO;
        } else if (loadState == ZFPlayerLoadStatePlaythroughOK || loadState == ZFPlayerLoadStatePlayable) {
            self.coverImageView.hidden = YES;
        }
        
    };
    
    self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        self.currentTime = currentTime;
    };
    
    self.videoListView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        [self checkCanPlay];
    };
    
    self.controlView.doubleTapBack = ^{
        @strongify(self)
        [JHLikeAnimation praiseAnimationWithSuperView:self.view praiseBlock:^{
        }];
        if (self.doubleTapBack) {
            self.doubleTapBack(self.player.playingIndexPath);
        }
    };
    
    self.controlView.singleTapBack = ^{
        @strongify(self)
        if (self.singleTapBack) {
            self.singleTapBack(self.player.playingIndexPath);
        }
    };
    
    [self.controlView insertSubview:self.coverImageView atIndex:0];
    self.coverImageView.frame = self.controlView.bounds;
    
}

- (void)setPlayVideoUrls:(NSArray *)playVideoUrls {
    _playVideoUrls = playVideoUrls;
    self.player.assetURLs = playVideoUrls;
}

- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)isScrollToTop {
    
    UIImage *image = kDefaultCoverImage;
    if (self.getCoverImage) {
        image = self.getCoverImage(indexPath);
    }
    self.coverImageView.image = image;
    [self.player playTheIndexPath:indexPath scrollToTop:isScrollToTop];
    
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
//    if (self.player.playingIndexPath) {
//        [self.player stopCurrentPlayingCell];
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}


#pragma mark - public method

- (NSTimeInterval)currentTimeWithIndexPath:(NSIndexPath *)indexPath {
    if (([indexPath compare:self.player.playingIndexPath] == NSOrderedSame)) {
        return self.currentTime;
    }
    return 0;
}

- (BOOL)isVideoMute {
    return self.player.currentPlayerManager.isMuted;
}

- (void)setIsVideoMute:(BOOL)isVideoMute {
    self.player.currentPlayerManager.muted = isVideoMute;
}

@end

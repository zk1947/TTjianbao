//
//  JHBuyAppraiseVideoController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseVideoController.h"
#import "PanNavigationController.h"
#import "JHBuyAppraiseModel.h"
#import "JHBuyAppraiseCell.h"
#import "JHGrowingIO.h"

#import "JHPlaySliderView.h"
#import "JHVideoPlayerLoadingView.h"
#import "JHPlayerViewController.h"
#import "JHGuideAnimalImage.h"

#import "JHBuyAppraiseVideoTableViewCell.h"
#import "JHRefreshGifHeader.h"
#import "CommHelp.h"
#import "JHLivePlayer.h"
#import <MJRefresh/MJRefresh.h>
#import "CommHelp.h"
#import "UserInfoRequestManager.h"
@interface JHBuyAppraiseVideoController () <JHPlaySliderViewDelegate, UITableViewDelegate, UITableViewDataSource, PanPushToNextViewControllerDelegate>
{
    NSTimeInterval liveIntime;
}
/** 加载框*/
@property (nonatomic, strong) JHVideoPlayerLoadingView *loadingView;
/** 是否正在播放中*/
@property (nonatomic, assign) BOOL isPlaying;
///** 播放器*/
@property (nonatomic, strong) JHPlayerViewController *playerController;
///372新增
@property (nonatomic, strong) UITableView *tableView;
///需要展示的视频数组
@property (strong, nonatomic) NSMutableArray <JHBuyAppraiseModel *>*videoArray;
/**第一次进入的新手引导*/
@property (nonatomic, strong) JHGuideAnimalImage *guideAnimalImage;
@property (nonatomic, strong) JHBuyAppraiseVideoTableViewCell *currentCell;
@property (nonatomic, strong) JHBuyAppraiseModel *currentPlayDetail;
@end

@implementation JHBuyAppraiseVideoController

- (NSMutableArray<JHBuyAppraiseModel *> *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentPlayDetail = self.videoArray[self.currentIndex];
    [self initTableView];
    [self configNav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:self];
    [[JHLivePlayer sharedInstance] setMute:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self playTheIndex:self.currentIndex];
    liveIntime = time(NULL);
}
#pragma mark -
#pragma mark - UI

- (void)configNav {
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self initLeftButtonWithImageName:@"icon_video_left_back" action:@selector(backActionButton:)];

    [self jhBringSubviewToFront];
    if ([CommHelp isFirstForName:@"isFirstInAppraiseVideo"]) {
        [self.guideAnimalImage animalImageWithSuperView:self.view];
    }
}

- (void)initTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    table.pagingEnabled = YES;
    table.backgroundColor = [UIColor blackColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate = self;
    table.dataSource = self;
    table.scrollsToTop = NO;
    table.estimatedRowHeight = 0;
    table.estimatedSectionFooterHeight = 0;
    table.estimatedSectionHeaderHeight = 0;
    table.alwaysBounceVertical = YES;
    table.scrollEnabled = YES;
    table.rowHeight = ScreenH;
    [self.view addSubview:table];
    _tableView = table;
    [_tableView registerClass:[JHBuyAppraiseVideoTableViewCell class] forCellReuseIdentifier:kbuyAppraiseVideoDetailIdentifer];
//    JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    _tableView.mj_header = header;
}

#pragma mark -
#pragma mark - UITableviewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHBuyAppraiseVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kbuyAppraiseVideoDetailIdentifer];
    cell.indexPath = indexPath;
    cell.videoModel = self.videoArray[indexPath.row];
    @weakify(self);
    cell.seekToTimeIntervalBlock = ^(NSTimeInterval timeInterval) {
        @strongify(self);
        [self.playerController seekToTime:timeInterval];
    };
    cell.playerStatusChangedBlock = ^(BOOL isPlay) {
        isPlay ? [self.playerController play] : [self.playerController pause];
    };
    return  cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 如果是最后一行，去请求新数据
    if (indexPath.row == self.videoArray.count - 1) {
        /// 加载下一页数据
        [self requestData:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenH;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - load data

- (void)requestData:(BOOL)isRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestMoreAppraiseData:)]) {
        @weakify(self);
        [self.delegate requestMoreAppraiseData:^(NSArray<JHBuyAppraiseModel *> * _Nullable videoArray) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
            
            [self.videoArray addObjectsFromArray:videoArray];
            ///将请求的数据存储在全局的数组中 并且将数据传送给前一个列表页
            if (videoArray.count > 0) {
                [self.tableView.mj_footer endRefreshing];
            }else{
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.tableView reloadData];
        }];
    }
}

- (void)setAppraiseArray:(NSArray<JHBuyAppraiseModel *> *)appraiseArray {
    if (!appraiseArray) {
        return;
    }
    _appraiseArray = appraiseArray;
    [self.videoArray addObjectsFromArray:appraiseArray];
}

#pragma mark -
#pragma mark - lazy loading

- (JHGuideAnimalImage *)guideAnimalImage {
    if(!_guideAnimalImage) {
        _guideAnimalImage = [JHGuideAnimalImage new];
    }
    return _guideAnimalImage;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScrollToPlayVideo];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self endScrollToPlayVideo];
}

- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.tableView visibleCells];
    if (visiableCells.count == 0) {
        return;
    }
    JHBuyAppraiseVideoTableViewCell *cell = visiableCells[0];
    if (self.currentCell == cell) {
        return;
    }
    self.currentCell = cell;
    self.currentIndex = cell.indexPath.row;
    self.currentPlayDetail = self.videoArray[cell.indexPath.row];
    /** 添加视频*/
    self.playerController.view.frame = self.currentCell.coverImageView.bounds;
    [self.playerController setSubviewsFrame];
    [self.currentCell.coverImageView addSubview:self.playerController.view];
    self.playerController.urlString = self.currentCell.videoModel.videoUrl;
    
    ///369神策埋点:鉴定视频开始播放
//    _startTime = [YDHelper get13TimeStamp].longLongValue;
//    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:cell.indexPath.row];
//    [JHTracking trackEvent:@"identifyVedioPlayStart" property:params.copy];
}

////播放器交互事件
- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    self.currentCell.centrPlayButton.hidden = isPlaying;
}

- (void)startLoading {
    [self.loadingView startLoading];
}

- (void)stopLoading {
    [self.loadingView stopLoading];
}

- (void)showRetry {
    [self.loadingView showRetry];
}

- (JHVideoPlayerLoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[JHVideoPlayerLoadingView alloc] initWithFrame:CGRectMake((self.view.width - 140) / 2, (self.view.height - 140) / 2, 140, 140)];
        @weakify(self);
        [_loadingView setRetryCall:^{
            @strongify(self);
            [self.playerController play];
        }];
    }
    return _loadingView;
}

//初始化播放器页面
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = YES;
        _playerController.alwaysPlay = YES; //无论4G还是 WIFI总是播放
        [_playerController setSubviewsFrame];
        @weakify(self);
        _playerController.playTimeChangeBlock = ^(NSTimeInterval currentPlaybackTime, NSTimeInterval duration, NSTimeInterval playableDuration) {
            @strongify(self);
            [self.currentCell setCurrentTime:currentPlaybackTime totalTime:duration prePlayTime:playableDuration];
        };
        _playerController.loadStateDidChangedBlock = ^(TTVideoEngineLoadState loadState) {
            @strongify(self);
            switch (loadState) {
                case TTVideoEngineLoadStatePlayable:
                    [self.currentCell stopLoading];
                    break;
                case TTVideoEngineLoadStateStalled:
                    [self.currentCell startLoading];
                    break;
                case TTVideoEngineLoadStateError:
                    [self.currentCell showRetry];
                    break;
                default:
                    break;
            }
        };
        _playerController.playbackStateDidChangedBlock = ^(TTVideoEnginePlaybackState playbackState) {
            @strongify(self);
            self.currentCell.isPlaying = (playbackState == TTVideoEnginePlaybackStatePlaying);
        };
        [self addChildViewController:_playerController];
    }
    return _playerController;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[JHLivePlayer sharedInstance] setMute:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///当返回时 需要将当先选中的视频下标返回到上一个页面
    if (self.backBlock) {
        self.backBlock(self.currentCell.videoModel.listIndex);
    }
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:nil];
    if (liveIntime>0) {
        liveIntime = (time(NULL)-liveIntime)*1000;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_video_duration" params:@{@"duration":@(liveIntime)} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
}

- (void)playTheIndex:(NSInteger)index {
    /// 指定到某一行播放
    self.currentPlayDetail = self.videoArray[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endScrollToPlayVideo];
    });
}



@end


//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHVideoCropViewController.h"
#import "JHSQPublishViewController.h"
#import "JHVideoCropDataManager.h"
#import "JHVideoCropBottomView.h"
#import "UIView+Extension.h"
#import "JHVideoCropManager.h"
#import "PanNavigationController.h"

@interface JHVideoCropViewController ()<SDVideoCropVideoDragDelegate>

@property (nonatomic, strong) UIImageView *mainVideoView;

@property (nonatomic, strong) JHVideoCropBottomView *bottomView;

@property (nonatomic, strong) AVPlayerLayer *videoLayer;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) JHVideoCropDataManager *dataManager;

@property (nonatomic, assign) BOOL isReloadPlay;

@property (nonatomic, assign) BOOL isLeveViewController;

@end

@implementation JHVideoCropViewController

- (instancetype)initWithVideoWithOutPutPath:(NSString *)outPutPath {

    if (self = [super init]) {
        self.dataManager = [[JHVideoCropDataManager alloc] init];
        [self addDataObserverAction];
        [self.dataManager reloadPlayItemActionPath:outPutPath];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view addSubview:self.mainVideoView];
    
    ///时间小于最小值不显示截取的视图
    if(CMTimeGetSeconds(self.dataManager.playTotalTimeRange.duration) > self.dataManager.minDuration)
    {
        [self.view addSubview:self.bottomView];
    }
    
    [self initLeftButton];
    self.jhNavView.backgroundColor = UIColor.clearColor;
    [self initRightButtonWithName:@"下一步" action:@selector(rightActionButton:)];
    [self.jhRightButton setBackgroundImage:JHImageNamed(@"publish_button") forState:UIControlStateNormal];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 26));
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    
    self.jhLeftButton.jh_imageName(@"icon_video_left_back");
    [self jhBringSubviewToFront];
    
    if ([self.navigationController isKindOfClass:[PanNavigationController class]]) {
        PanNavigationController *nav = (PanNavigationController *)self.navigationController;
        nav.isForbidDragBack = YES;
        [nav setShouldReceiveTouchViewController:nil];
    }
}

- (void)backActionButton:(UIButton *)sender
{
    NSArray *array = self.navigationController.viewControllers;
    if (IS_ARRAY(array) && array.count > 1)
    {
        [super backActionButton:sender];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightActionButton:(UIButton *)sender
{
    [self.player pause];
    AVURLAsset *asset = (AVURLAsset *)self.dataManager.playItem.asset;
    CMTimeRange range = self.dataManager.playTimeRange;
    if(_selectVideoBlock)
    {
        _selectVideoBlock(asset,range);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        JHSQPublishViewController *vc = [JHSQPublishViewController new];
        vc.topic = _topic;
        vc.plate = _plate;
        vc.type = 2;
        vc.asset = asset;
        vc.timeRange = range;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.isLeveViewController = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self playVideoAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.isLeveViewController = YES;
}

#pragma mark - 懒加载
- (UIImageView *)mainVideoView {
    
    if (_mainVideoView == nil) {
        _mainVideoView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _mainVideoView.backgroundColor = [UIColor blackColor];
        [_mainVideoView.layer addSublayer:self.videoLayer];
    }
    return _mainVideoView;
}

- (JHVideoCropBottomView *)bottomView {
    
    if (_bottomView == nil) {
        _bottomView = [[JHVideoCropBottomView alloc] initWithFrame:CGRectMake(0, self.mainVideoView.bottom - 175.0f - UI.bottomSafeAreaHeight, self.view.width, 100) dataManager:self.dataManager];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (AVPlayerLayer *)videoLayer {
    
    if (_videoLayer == nil) {
        _videoLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _videoLayer.frame = self.mainVideoView.bounds;
    }
    return _videoLayer;
}

- (AVPlayer *)player {
    
    if (_player == nil) {
        _player = [[AVPlayer alloc] initWithPlayerItem:self.dataManager.playItem];
        __weak typeof(self) weakSelf = self;
        [_player addPeriodicTimeObserverForInterval:self.dataManager.observerTimeSpace queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            weakSelf.dataManager.currentPlayTime = weakSelf.player.currentTime;
        }];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoItemPlayFinishAction) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return _player;
}

- (void)playVideoAction {

    [self.player pause];
    [self.dataManager.playItem seekToTime:self.dataManager.playTimeRange.start toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player play];
}

#pragma mark - 通知回调事件

- (void)videoItemPlayFinishAction {
    
    // 因为没有队列 所以直接重新播放即可
    if (!self.isLeveViewController) {
        [self playVideoAction];
    }
}

#pragma mark - 拖拽代理方法

- (void)userStartChangeVideoTimeRangeAction {
    
    [self.player pause];
}

- (void)userChangeVideoTimeRangeAction {
    
    [self.player seekToTime:self.dataManager.currentPlayTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)userEndChangeVideoTimeRangeAction {
    
    [self.player play];
}

#pragma mark - 数据监听观察

- (void)addDataObserverAction {
    
    [self.dataManager addObserver:self forKeyPath:@"playTimeRange" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"playTimeRange"]) {
        self.player.currentItem.forwardPlaybackEndTime = CMTimeAdd(self.dataManager.playTimeRange.start, self.dataManager.playTimeRange.duration);
    }
}

#pragma mark - 系统方法

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.dataManager removeObserver:self forKeyPath:@"playTimeRange"];
}

@end

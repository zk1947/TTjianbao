//
//  JHIdentificationDetailsVC.m
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsVC.h"
#import "JHIdentificationDetailsMainView.h"
#import "JHPlayerViewController.h"
#import "JHJHIdentificationDetailsDelegate.h"
#import "JHIdentificationDetailsCell.h"
#import "JHNormalControlView.h"
#import "UIView+Tool.h"

@interface JHIdentificationDetailsVC ()<
JHJHIdentificationDetailsDelegate>

/// 主视图
@property (nonatomic, weak) JHIdentificationDetailsMainView *mainView;

/// 播放器
@property (nonatomic, strong) JHPlayerViewController *playerController;

///  播放视频的进度条
@property (nonatomic, strong) JHNormalControlView *normalPlayerControlView;

/// 当前播放的cell
@property (nonatomic, strong) JHIdentificationDetailsCell *currentlyPlayingCell;

@property (nonatomic, assign) NSInteger recordInfoId;

@end

@implementation JHIdentificationDetailsVC

- (instancetype)initWithRecordInfoId:(NSInteger)recordInfoId {
    
    if (self = [super init]) {
        _recordInfoId = recordInfoId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.jhTitleLabel.text = @"详情";
    self.jhNavBottomLine.hidden = YES;
    
    [self p_drawMainView];
    [self p_makeLayout];
    
}

#pragma mark - Private Methods
- (void)p_drawMainView {
    JHIdentificationDetailsMainView *identificationMainView = [[JHIdentificationDetailsMainView alloc]initWithRecordInfoId:_recordInfoId];
    [identificationMainView setDelegate:self];
    [self.view addSubview:identificationMainView];
    self.mainView = identificationMainView;
}

- (void)p_makeLayout {
    
    @weakify(self);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
            
    }];
    
}

#pragma mark - JHJHIdentificationDetailsDelegate

- (void)playdentDetailsVideo:(JHIdentificationDetailsCell *)cell {
    if (cell == self.currentlyPlayingCell) {
        return;
    }
    self.currentlyPlayingCell = cell;
    self.playerController.view.frame = cell.videoView.bounds;
    [self.playerController setSubviewsFrame];
    [self.playerController setControlView:self.normalPlayerControlView];
    [cell.videoView addSubview:self.playerController.view];
    self.playerController.urlString = cell.videoUrl;
    [self.playerController play];
    
}

- (void)p_stopPlayerdentificationDetailVideo {
    [self.playerController stop];
    self.currentlyPlayingCell = nil;
    [self.playerController.view removeFromSuperview];
}

- (void)endScrollToStopVideo:(UITableView *)tableView {
    
    CGFloat currentPlayingCellHalfHeight = self.currentlyPlayingCell.height / 2.0;
    CGFloat topOffsetY = tableView.contentOffset.y;//顶部边界
    CGFloat bottomValue = topOffsetY + tableView.height; //底部边界
    // cell 上边界超出一半以上
    if (self.currentlyPlayingCell.maxY > topOffsetY && self.currentlyPlayingCell.minY < topOffsetY) {
            BOOL condition1 = topOffsetY - self.currentlyPlayingCell.minY > currentPlayingCellHalfHeight;
            if (condition1) {
                [self p_stopPlayerdentificationDetailVideo];
            }
        
    }
    
    // cell下边界移出去超过一半以上
       if (self.currentlyPlayingCell.maxY > bottomValue && self.currentlyPlayingCell.minY < bottomValue) {
           BOOL condition2 = bottomValue - self.currentlyPlayingCell.minY < currentPlayingCellHalfHeight;
           if (condition2) {
               [self p_stopPlayerdentificationDetailVideo];
           }
       }

}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.hidePlayButton = YES;
        @weakify(self);
        _playerController.playbackStateDidChangedBlock = ^(TTVideoEnginePlaybackState playbackState) {
            if (playbackState == TTVideoEnginePlaybackStateStopped) { //播放完成后显示分享页面
                @strongify(self);
                [self p_stopPlayerdentificationDetailVideo];
            }
            
        };
        [self addChildViewController:_playerController];

    }
    return _playerController;
}

- (JHNormalControlView *)normalPlayerControlView {
    if (_normalPlayerControlView == nil) {
        _normalPlayerControlView = [[JHNormalControlView alloc] initWithFrame:self.playerController.view.bounds];
        _normalPlayerControlView.playImage = JHImageNamed(@"recycle_video_icon");
    }
    return _normalPlayerControlView;
}

@end

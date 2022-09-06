//
//  JHBuyAppraiseTVBoxHeader.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseTVBoxHeader.h"
#import "JHGradientView.h"
#import "JHBuyAppraiseTVBoxModel.h"
#import "JHLivePlayerManager.h"
#import "JHSettingAutoPlayController.h"
#import "JHLivePopView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "JHBuyAppraiseTVBoxView.h"
#import "JHPlayerViewController.h"

@interface JHBuyAppraiseTVBoxHeader ()
{
    NSTimeInterval liveIntime;
}
/// 数据模型
@property (nonatomic, strong) JHBuyAppraiseTVBoxModel *sourceData;

/// 头部提示标签
@property (nonatomic, weak) UILabel *tipLabel;

@property (nonatomic, weak) JHBuyAppraiseTVBoxView *tvView;

@property (nonatomic, weak) UIView *tvViewContent;

@property (nonatomic, weak) JHGradientView *topBgView;

@property (nonatomic, weak) JHGradientView *bottomBgView;

///直播中
@property (nonatomic, weak) UIView *livingTipView;

/// 回放中
@property (nonatomic, weak) UIView *playVideoTipView;

///当前仓库名字
@property (nonatomic, weak) UILabel *titleLabel;

///描述
@property (nonatomic, weak) UILabel *descLabel;

//@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频索引*/
@property (nonatomic, assign) NSInteger playUrlIndex;
///手动开关播放
@property (nonatomic, assign) BOOL isClose;

///全屏
@property (nonatomic, assign) BOOL isFullScreen;

// 播放器准备好了后需要快进一下
@property (nonatomic, assign) BOOL isNeedSeek;

@end

@implementation JHBuyAppraiseTVBoxHeader

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSelfSubViews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageMethod:) name:NOTIFICATION_APPRAISE_STORE_SYSTEM_MESSAGE object:nil];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        @weakify(self);
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self);
            JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
            if(self.isClose) {
                return;
            }
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    /// WIFI
                    if(type != JHAutoPlayStatusClose)
                    {
                        [self start];
                    }
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    //移动蜂窝
                    if(type == JHAutoPlayStatusWIFI) {
                        [self stop];
                    }
                }
                    break;
                default: {
                }
                    break;
            }
        }];
        
    }
    return self;
}

- (void)addSelfSubViews {
    
    UIImageView *livingTipImage = [UIImageView jh_imageViewWithImage:@"appraise_home_living_tip" addToSuperview:self];
    [livingTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(11);
        make.left.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    _tipLabel = [UILabel jh_labelWithBoldFont:15 textColor:RGB(34, 34, 34) addToSuperView:self];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(livingTipImage);
        make.left.equalTo(livingTipImage.mas_right).offset(1.5);
    }];
    
    UIView *tmp = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [tmp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(40, 12, 10, 12));
        make.height.mas_equalTo((198.f / 351.f) * (ScreenW - 24.f));
    }];
    _tvViewContent = tmp;
    
    @weakify(self);
    JHBuyAppraiseTVBoxView *tvView = [JHBuyAppraiseTVBoxView shareInstance];
    [self addSubview:tvView];
    tvView.switchPlayBlock = ^{
        @strongify(self);
        self.playerController.alwaysPlay = YES;
        [self switchPlayMethod];
    };
    [tvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tvViewContent);
    }];
    _tvView = tvView;

    self.playerController.view.frame = CGRectMake(0, 0, ScreenW,(198.f / 351.f) * (ScreenW - 24.f));
    [self.playerController setSubviewsFrame];
    [self.tvView.coverImageView addSubview:self.playerController.view];
    
    JHGradientView *topBgView = [JHGradientView new];
    [topBgView setGradientColor:@[(__bridge id)RGBA(0,0,0,0.5).CGColor,(__bridge id)RGBA(0,0,0,0).CGColor] orientation:JHGradientOrientationVertical];
    [self.tvView addSubview:topBgView];
    [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.tvView);
        make.height.mas_equalTo(50);
    }];
    _topBgView = topBgView;
    
    UIImageView *timeTipImage = [UIImageView jh_imageViewWithImage:@"appraise_home_time_tip" addToSuperview:topBgView];
    [timeTipImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topBgView).offset(9);
        make.right.equalTo(topBgView).offset(-9);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [timeTipImage jh_addTapGesture:^{
        [self livingTimeAlertMethod];
    }];
    
    UILabel *timeTipLabel = [UILabel jh_labelWithText:@"直播时间" font:13 textColor:UIColor.whiteColor textAlignment:2 addToSuperView:topBgView];
    [timeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeTipImage.mas_left).offset(-3);
        make.centerY.equalTo(timeTipImage);
        make.height.mas_equalTo(30);
    }];
    [timeTipLabel jh_addTapGesture:^{
        [self livingTimeAlertMethod];
    }];
    
    _livingTipView = [UIView jh_viewWithColor:HEXCOLOR(0xffd70f) addToSuperview:topBgView];
    [_livingTipView jh_cornerRadius:3];
    [_livingTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 16));
        make.left.equalTo(topBgView).offset(9);
        make.top.equalTo(topBgView).offset(10);
    }];
    
    YYAnimatedImageView *playingImage=[[YYAnimatedImageView alloc]init];
    playingImage.contentMode=UIViewContentModeScaleAspectFit;
    playingImage.image = [YYImage imageNamed:@"mall_home_list_living.webp"];
    [_livingTipView addSubview:playingImage];
    [playingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.livingTipView.mas_centerY);
        make.left.equalTo(self.livingTipView.mas_left).offset(3);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    
    UILabel *status = [UILabel jh_labelWithText:@"直播中" font:10 textColor:RGB515151 textAlignment:0 addToSuperView:_livingTipView];
    [status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.livingTipView.mas_centerY);
        make.left.equalTo(playingImage.mas_right).offset(3);
    }];
    
    JHGradientView *bottomBgView = [JHGradientView new];
    [bottomBgView setGradientColor:@[(__bridge id)RGBA(0,0,0,0).CGColor,(__bridge id)RGBA(0,0,0,0.5).CGColor] orientation:JHGradientOrientationVertical];
    [self.tvView addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.tvView);
        make.height.mas_equalTo(70);
    }];
    _bottomBgView = bottomBgView;
    
    _titleLabel = [UILabel jh_labelWithFont:13 textColor:UIColor.whiteColor addToSuperView:bottomBgView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomBgView).offset(9);
        make.top.equalTo(bottomBgView).offset(30);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:11 textColor:UIColor.whiteColor textAlignment:0 addToSuperView:bottomBgView];
    _descLabel.adjustsFontSizeToFitWidth = YES;
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(bottomBgView).offset(-7);
    }];
    
    _playVideoTipView = [UIView jh_viewWithColor:RGBA(110, 110, 110, 0.75) addToSuperview:bottomBgView];
    [_playVideoTipView jh_cornerRadius:3];
    [_playVideoTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topBgView).offset(9);
        make.top.equalTo(topBgView).offset(10.5);
        make.size.mas_equalTo(CGSizeMake(136, 16));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playVideoTipView addSubview:button];
    button.jh_fontNum(10).jh_title(@"回放").jh_titleColor(UIColor.whiteColor).jh_backgroundColor(RGB(148, 154, 168)).jh_imageName(@"appraise_home_video_tip");
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.playVideoTipView);
        make.width.mas_equalTo(40);
    }];
    
    UILabel *label = [UILabel jh_labelWithText:@"品控鉴定师休息时间" font:10 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:_playVideoTipView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right);
        make.centerY.right.equalTo(self.playVideoTipView);
    }];
    
    UIButton *detailButton = [UIButton jh_buttonWithImage:@"appraise_home_full_screen" target:self action:@selector(gotoFullScreen) addToSuperView:bottomBgView];
    [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.tvView);
        make.size.mas_equalTo(CGSizeMake(34, 30));
    }];
}

-(void)setSourceData:(JHBuyAppraiseTVBoxModel *)sourceData {
    
    ///是否第一次赋值
    if(_sourceData) {
        [self stop];
    }
    ///是否继续
    BOOL isGo = NO;
    if(_sourceData && !_isClose) {
        isGo = YES;
    }
    
    _sourceData = sourceData;
    if(!_sourceData) {
        return;
    }
    _tipLabel.text = _sourceData.isLiving ? @"品控中心直播视频" : @"品控中心回放视频";
    [self.tvView.coverImageView jh_setImageWithUrl:_sourceData.coverUrl];
    _livingTipView.hidden = !_sourceData.isLiving;
    _playVideoTipView.hidden = _sourceData.isLiving;
    _descLabel.text = _sourceData.desc;
    
    if(_sourceData.isLiving) {
        _titleLabel.text = [NSString stringWithFormat:@"%@%@",_sourceData.liveInfo.showingDepository,_sourceData.liveInfo.showingPipeline];
    }
    else {
        JHBuyAppraiseTVBoxplayVideoModel *video = self.sourceData.playbackInfos[self.playUrlIndex];
        _titleLabel.text = [NSString stringWithFormat:@"%@%@",video.showingDepository,video.showingPipeline];
    }
    
    if(!_sourceData.isLiving) {
        self.playUrlIndex = 0;
        [self playUrlWithIndex];
    }
    if(isGo) {
        [self forcePlay];
    }
    else {
        [self start];
    }
}

- (void)messageMethod:(NSNotification *)sender {
    NSDictionary *dic = sender.object;
    if(IS_DICTIONARY(dic) && [dic valueForKey:@"dlInfo"]) {
        JHBuyAppraiseTVBoxModel *m = [JHBuyAppraiseTVBoxModel mj_objectWithKeyValues:[dic valueForKey:@"dlInfo"]];
        self.sourceData = m;
    }
}

- (void)requestData {
    [JHBuyAppraiseTVBoxModel requestDataModelBlock:^(BOOL success, JHBuyAppraiseTVBoxModel * _Nonnull model) {
        self.sourceData = model;
    }];
}

- (void)refreshData {
    [self requestData];
}

/// 直播时间弹框
- (void)livingTimeAlertMethod {
    [self requestLivingTime];
}

- (void)requestLivingTime {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    NSString *url = FILE_BASE_STRING(@"/dl/app/time-description");
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel * _Nullable respondObject) {
        [self showLivePopView:respondObject.data];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}


- (void)showLivePopView:(NSDictionary *)data {
    if ([self isDictionary:data]) {
        JHLivePopView *liveView = [[JHLivePopView alloc] initWithLiveInfo:data];
        [liveView show];
    }
}

- (BOOL)isDictionary:(NSDictionary *)dic {
   if (dic != nil && ![dic isKindOfClass:[NSNull class]] && ![dic isEqual:[NSNull null]]) {
       return YES;
   }
   else {
       return NO;
   }
}

///跳转详情页面
- (void)gotoFullScreen {
    UIView *window = JHKeyWindow;
    [window addSubview:_tvView];
    UIButton *closeButton = [UIButton jh_buttonWithImage:kNavBackWhiteImg target:self action:@selector(gotoSmallScreen:) addToSuperView:self.tvView];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.tvView);
        make.size.mas_equalTo(CGSizeMake(120, 60));
    }];
    
    _bottomBgView.hidden = YES;
    _topBgView.hidden = YES;
    [self changeStatus:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [_tvView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(window);
            make.size.mas_equalTo(CGSizeMake(ScreenH, ScreenW));
        }];
        self.playerController.view.frame = CGRectMake(0, 0, ScreenH, ScreenW);
        [self.playerController setSubviewsFrame];
        _tvView.transform = CGAffineTransformMakeRotation (M_PI_2);
        [window layoutIfNeeded];
    }];
    
    liveIntime = time(NULL);
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_fullscreen" params:@{} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

///跳转详情页面
- (void)gotoSmallScreen:(UIButton *)sender {

    [sender removeFromSuperview];
    
    _tvView.transform = CGAffineTransformMakeRotation (0);
    
    [self.tvViewContent addSubview:self.tvView];
    [self.tvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tvViewContent);
    }];
    self.playerController.view.frame = CGRectMake(0, 0, ScreenW,(198.f / 351.f) * (ScreenW - 24.f));
    [self.playerController setSubviewsFrame];
    _bottomBgView.hidden = NO;
    _topBgView.hidden = NO;
    [self changeStatus:NO];
    
    if (liveIntime>0) {
        liveIntime = (time(NULL)-liveIntime)*1000;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_live_fullscreen_duration" params:@{@"duration":@(liveIntime).stringValue} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
    
}

- (void)changeStatus:(BOOL)hidden {
    UIViewController *vc = [JHRouterManager jh_getViewController];
    if([vc isKindOfClass:[JHBaseViewController class]]) {
        JHBaseViewController *viewController = (JHBaseViewController *)vc;
        viewController.jhStatusHidden = hidden;
    }
}

- (void)start {
    if([self isAutoPlay]) {
        [self forcePlay];
    }
}

- (void)forcePlay {
    self.isClose = NO;
    if(self.sourceData.isLiving) {
        if ([self.tvView.coverImageView.subviews containsObject:self.playerController.view]) {
            [self.playerController.view removeFromSuperview];
        }
        [[JHLivePlayerManager sharedInstance] startPlayIgnoreNetwork:self.sourceData.liveInfo.pullRtmpUrl inView:self.tvView.livingContentView andPlayFailBlock:^{
            self.isClose = YES;
        }];
    }
    else {
        [self playUrlWithIndex];
    }
}

- (void)stop {
    self.isClose = YES;
    if(self.sourceData.isLiving) {
        [[JHLivePlayerManager sharedInstance] shutdown];
    }
    else {
//        [self.player stop];
        [self.playerController stop];
    }
}

- (BOOL)isAutoPlay {
    BOOL isWiFi = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi;
    JHAutoPlayStatus type = [JHSettingAutoPlayController getAutoPlayStatus];
    
    switch (type) {
        case JHAutoPlayStatusWIFIAnd4G:
            return YES;
            break;
            
        case JHAutoPlayStatusWIFI:
            return isWiFi;
            break;
            
        default:
            return NO;
            break;
    }
}

//- (ZFPlayerController *)player {
//    if(!_player) {
//        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//        _player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.tvView.livingContentView];
//        _player.pauseWhenAppResignActive = YES;
//        _player.allowOrentitaionRotation = NO;
//        _player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
//        @weakify(self);
//        self.player.playerPlayStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
//            @strongify(self);
//            if(playState == ZFPlayerPlayStatePlaying) {
//                self.tvView.coverImageView.hidden = YES;
//                self.tvView.playStatusView.hidden = YES;
//            }
//            else {
//                self.tvView.coverImageView.hidden = NO;
//                self.tvView.playStatusView.hidden = NO;
//            }
//        };
//        /// 播放完成
//        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
//
//        };
//
//        self.player.playerPlayTimeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
//            @strongify(self);
//            JHBuyAppraiseTVBoxplayVideoModel *video = self.sourceData.playbackInfos[self.sourceData.videoIndex];
//            if(currentTime >= (video.startSeconds + video.playSeconds)) {
//                [self.player.currentPlayerManager setSeekTime:video.startSeconds];
//                self.sourceData.videoIndex += 1;
//                if(self.sourceData.videoIndex == self.sourceData.playbackInfos.count) {
//                    [self stop];
//                    [self refreshData];
//                    self.sourceData.videoIndex = 0;
//                }
//                [self start];
//            }
//        };
//    }
//    return _player;
//}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
//        _playerController.alwaysPlay = YES;
        _playerController.hidePlayButton = YES;
//        _playerController.muted = YES;
        @weakify(self);
        _playerController.playbackStateDidChangedBlock = ^(TTVideoEnginePlaybackState playbackState) {
            @strongify(self);
            if(playbackState == TTVideoEnginePlaybackStatePlaying) {
                self.tvView.playStatusView.hidden = YES;
                if (self.isNeedSeek) {
                    self.isNeedSeek = NO;
                    JHBuyAppraiseTVBoxplayVideoModel *video = self.sourceData.playbackInfos[self.playUrlIndex];
                    [self.playerController seekToTime:video.startSeconds];
                }
            }
            else {
                self.tvView.playStatusView.hidden = NO;
            }
        };
        _playerController.playTimeChangeBlock = ^(NSTimeInterval currentPlaybackTime, NSTimeInterval duration, NSTimeInterval playableDuration) {
            @strongify(self);
            if (self.sourceData.playbackInfos.count == 0) {
                return;
            }
            JHBuyAppraiseTVBoxplayVideoModel *video = self.sourceData.playbackInfos[self.playUrlIndex];
            if(currentPlaybackTime >= (video.startSeconds + video.playSeconds)) {
                self.playUrlIndex += 1;
                NSInteger indexUrl = self.playUrlIndex % self.sourceData.playbackInfos.count;
                self.playUrlIndex = indexUrl;
                [self playUrlWithIndex];
            }
        };
    }
    return _playerController;
}

/** 控制播放第几个视频*/
- (void)playUrlWithIndex{
    if (self.sourceData.playbackInfos.count <= 0) {
        return;
    }
    if (![self.tvView.coverImageView.subviews containsObject:self.playerController.view]) {
        [self.tvView.coverImageView addSubview:self.playerController.view];
    }
    JHBuyAppraiseTVBoxplayVideoModel *video = self.sourceData.playbackInfos[self.playUrlIndex];
    self.isNeedSeek = YES;
    self.playerController.urlString = video.videoUrl;
    [self.tvView.coverImageView jh_setImageWithUrl:video.coverImg];
    _titleLabel.text = [NSString stringWithFormat:@"%@%@",video.showingDepository,video.showingPipeline];
}

- (void)switchPlayMethod {
    self.isClose = !_isClose;
    if(self.sourceData.isLiving) {
        if(_isClose) {
            self.tvView.coverImageView.image = [[JHLivePlayerManager sharedInstance].player getSnapshot];
            [[JHLivePlayerManager sharedInstance] shutdown];
        }
        else {
            [self forcePlay];
        }
    }
    else {
        if(_isClose) {
//            [self.player.currentPlayerManager pause];
            [self.playerController pause];
        }
        else {
//            if(self.player.currentPlayerManager.playState == ZFPlayerPlayStatePlaying || self.player.currentPlayerManager.playState == ZFPlayerPlayStatePaused)
//            {
//                [self.player.currentPlayerManager play];
//            }
//            else {
//                [self forcePlay];
//            }
            if (self.playerController.engine.playbackState == TTVideoEnginePlaybackStatePlaying || self.playerController.engine.playbackState == TTVideoEnginePlaybackStatePaused) {
                [self.playerController play];
            }else {
                [self forcePlay];
            }
        }
    }
}

- (void)setIsClose:(BOOL)isClose {
    _isClose = isClose;
    self.tvView.playStatusView.hidden = !_isClose;
}
+ (CGSize)viewSize {
    return CGSizeMake(ScreenW, (198.f / 351.f) * (ScreenW - 24.f) + 10.f + 41.f);
}
@end

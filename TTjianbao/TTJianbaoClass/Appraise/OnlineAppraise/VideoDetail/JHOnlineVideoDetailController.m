//
//  JHOnlineVideoDetailController.m
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineVideoDetailController.h"
#import "PanNavigationController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "JHGemmologistViewController.h"
#import "JHVideoReportCard.h"
#import "NTESLiveManager.h"
#import "NTESAudienceLiveViewController.h"
#import "JHLikeImageView.h"
#import "JHGoodAppraisalCommentView.h"
#import <IQKeyboardManager.h>
#import "ChannelMode.h"
#import "JHLivePlaySMallView.h"
#import "JHGuideAnimalImage.h"
#import "JHLivePlayer.h"

#import "JHOnlineAppraiseModel.h"
#import "JHOnlineAppraiseVideoDetailCell.h"
#import "JHOnlineAppraiseManager.h"
#import "JHPostDetailModel.h"
#import "JHOnlineAppraiseControlView.h"
#import "ZFPlayerController.h"
#import "JHSQManager.h"
#import "JHBaseOperationView.h"
#import "JHUserInfoApiManager.h"
#import "JHEasyInputTextView.h"
#import "JHSQApiManager.h"
#import "JHUserInfoViewController.h"
#import "JHOnlineAppraiseCommentView.h"
#import "JHPlayerViewController.h"

@interface JHOnlineVideoDetailController () <UITableViewDelegate, UITableViewDataSource, PanPushToNextViewControllerDelegate>

@property (nonatomic, strong) JHPlayerViewController *playerController; //播放器
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <JHPostDetailModel *>*dataSource;
@property (nonatomic, strong) JHGuideAnimalImage* guideAnimalImage;
@property (nonatomic, strong) JHOnlineAppraiseControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) JHPostDetailModel *currentPlayDetail;
//commentId不为空时，弹出评论视图
@property (nonatomic, assign) BOOL commentsHaveBeenDisplayed;
@property (nonatomic, copy) NSString *lastDate;
@property (nonatomic, strong) JHOnlineAppraiseVideoDetailCell *currentCell;
///视频播放开始时间
@property (nonatomic, assign) NSTimeInterval startTime;
///视频播放结束时间
@property (nonatomic, assign) NSTimeInterval endTime;

@end

@implementation JHOnlineVideoDetailController

- (NSMutableArray<JHPostDetailModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setPostArray:(NSArray<JHPostDetailModel *> *)postArray {
    if (!postArray) {
        return;
    }
    
    _postArray = postArray;
    [self.dataSource addObjectsFromArray:postArray];

    for (JHPostDetailModel *model in postArray) {
        NSString *url = [model.videoInfo.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        if ([url isNotBlank]) {
            [self.urls addObject:[NSURL URLWithString:url]];
        }
    }
}

- (void)backActionButton:(UIButton *)sender {
    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_back_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lastDate = @"";
    [self.view addSubview:self.tableView];
    [self configNav];
}

#pragma mark -
#pragma mark - UI

- (void)configNav {
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self initLeftButtonWithImageName:@"icon_video_left_back" action:@selector(backActionButton:)];
    [self initRightButtonWithImageName:@"customize_desc_more_white" action:@selector(shareAction:)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self jhBringSubviewToFront];
    if ([CommHelp isFirstForName:@"isFirstInAppraiseVideo"]) {
        [self.guideAnimalImage animalImageWithSuperView:self.view];
    }
}

//- (void)refresh {
//    _lastDate = @"";
//    _page = 1;
//    [self.tableView.mj_footer resetNoMoreData];
//    [self requestData:YES];
//}

- (void)loadMoreData {
//    _page ++;
//    _lastDate = [[[self.dataSource lastObject] last_date] isNotBlank] ? [[self.dataSource lastObject] last_date] : @"0";
    [self requestData:NO];
}

- (void)requestData:(BOOL)isRefresh {
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestMorePostData:)]) {
        @weakify(self);
        [self.delegate requestMorePostData:^(NSArray<JHPostDetailModel *> * _Nullable postArray) {
            @strongify(self);
            if (isRefresh) {
                self.dataSource = postArray.mutableCopy;
            }
            else {
                [self.dataSource addObjectsFromArray:postArray];
            }
            ///将请求的数据存储在全局的数组中 并且将数据传送给前一个列表页
            [self.tableView reloadData];
        }];
    }
}
- (void)pressCommentWithShowBar:(BOOL)isShow{
    
}

- (JHGuideAnimalImage *)guideAnimalImage {
    if(!_guideAnimalImage) {
        _guideAnimalImage = [JHGuideAnimalImage new];
    }
    return _guideAnimalImage;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.currentCell) {
        _startTime = [YDHelper get13TimeStamp].longLongValue;
        NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
        [JHTracking trackEvent:@"identifyVedioPlayStart" property:params.copy];
//        NSLog(@"+++ === 起播1");
    }
    
    self.isFollow = [JHUserDefaults boolForKey:@"kOperateFollowStatusKey"];
    if (self.currentPlayDetail) {
        self.currentPlayDetail.publisher.is_follow = self.isFollow;
    }
    [self.tableView reloadData];
    [self playTheIndex:self.currentIndex];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHOnlineAppraiseVideoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kVideoDetailIdentifer];
    cell.postDetail = self.dataSource[indexPath.row];
    cell.indexPath = indexPath;
    cell.showFollowBtn = self.isFollow;
    @weakify(self);
    cell.actionBlock = ^(NSInteger selectIndex, JHFullScreenControlActionType actionType) {
        @strongify(self);
        [self handleFullScreenControlAction:actionType selectIndex:selectIndex];
    };
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
//    if (self.dataSource.count > 2 && indexPath.row == self.dataSource.count - 1) {
    if (indexPath.row == self.dataSource.count - 1) {
        /// 加载下一页数据
        [self loadMoreData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenH;
}

#pragma mark -- PanSwiper Delegate --
- (UIViewController *)swiperBeginPanPushToNextController:(PanSwiper *)swiper {
    if (![self.currentPlayDetail.publisher.user_id isNotBlank]) {
        return nil;
    }
    JHUserInfoViewController *vc = [[JHUserInfoViewController alloc] init];
    vc.userId = self.currentPlayDetail.publisher.user_id;
    return vc;
}
#pragma mark - get
- (JHOnlineAppraiseControlView *)controlView {
    if (!_controlView) {
        _controlView = [JHOnlineAppraiseControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}

- (void)shareAction:(UIButton *)sender {
    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
    [self presentOptionWindow];
}

///弹出弹窗
- (void)presentOptionWindow {
    if (self.currentPlayDetail.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    ///传字段为页面来源
    @weakify(self);
    self.currentPlayDetail.share_info.pageFrom = JHPageFromTypeOnlineAppraiseVideoDetailMore;
    [JHBaseOperationView creatSQPostDetailOperationView:self.currentPlayDetail Block:^(JHOperationType operationType) {
        //埋点
        @strongify(self);
        [self buryingPoint:operationType];
        [JHBaseOperationAction operationAction:operationType operationMode:(JHPostData *)self.currentPlayDetail bolck:^{
             //成功
            [self operationComplete:operationType];
        }];
    }];
}
//埋点
- (void)buryingPoint:(JHOperationType )operationType {
    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
    switch (operationType) {
        case JHOperationTypeWechatSession: //微信
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_wechat_click"  params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        case JHOperationTypeWechatTimeLine:  //朋友圈
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_monments_click" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        case JHOperationTypeCopyUrl:  //复制
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_copy_click"  params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        case JHOperationTypeReport:  //举报
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_report_click"  params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        case JHOperationTypeColloct:   //收藏
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_collect_click"  params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        case JHOperationTypeBack:   //返回首页
            [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_topright_back_click"  params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            break;
        default:
            break;
    }
}


#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType {
    
    if (operationType == JHOperationTypeColloct||
        operationType == JHOperationTypeCancleColloct) {
        self.currentPlayDetail.is_collect =!self.currentPlayDetail.is_collect;
    }
    if (operationType == JHOperationTypeSetGood||
        operationType == JHOperationTypeCancleSetGood) {
        self.currentPlayDetail.content_level = self.currentPlayDetail.content_level == 1?0:1;
    }
    if (operationType == JHOperationTypeSetTop||
        operationType == JHOperationTypeCancleSetTop) {
        self.currentPlayDetail.content_style = self.currentPlayDetail.content_style == 2?0:2;
    }
    if (operationType == JHOperationTypeNoice||
        operationType == JHOperationTypeCancleNotice) {
        self.currentPlayDetail.content_style = self.currentPlayDetail.content_style == 3?0:3;
    }
    if (operationType == JHOperationTypeDelete) {
//        [self.postArray removeObject:data];
//        [self.contentTableView reloadData];
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:self];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[JHLivePlayer sharedInstance] setMute:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[JHLivePlayer sharedInstance] setMute:YES];
    [self sa_trackVideoEndPlay];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///当返回时 需要将当先选中的视频下标返回到上一个页面
    if (self.backBlock) {
        self.backBlock(self.currentCell.postDetail.listIndex);
    }
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:nil];
}

- (void)playTheIndex:(NSInteger)index {
    /// 指定到某一行播放
    self.currentPlayDetail = self.dataSource[index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endScrollToPlayVideoWithClick:YES];
    });
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

///小视频全屏状态下的各种点击事件
- (void)handleFullScreenControlAction:(JHFullScreenControlActionType)actionType selectIndex:(NSInteger)selectIndex {
    JHPostDetailModel *model = self.dataSource[selectIndex];
    switch (actionType) {
        case JHFullScreenControlActionTypeIcon: ///进入个人主页
        {
            [JHSQManager enterUserInfoVCWithPublisher:model.publisher];
        }
            break;
        case JHFullScreenControlActionTypeFollow: ///关注用户
        {
            [self toFollow];
        }
            break;
        case JHFullScreenControlActionTypeLike: ///点赞
        {
            [self toLikePost:model];
        }
            break;
        case JHFullScreenControlActionTypeShare: ///分享
        {
            [self toShare:model index:selectIndex];
        }
            break;
        case JHFullScreenControlActionTypeFastComment: ///快速评论
        {
            ///弹出评论弹框
            [self inputComment:model];
        }
            break;
        case JHFullScreenControlActionTypeComment:
        {
            ///跳转视频详情页
            [self presentCommentView:model];
        }
            break;
        case JHFullScreenControlActionTypeAllInfo:
        {
            ///跳转视频详情页
            [self enterVideoDetail:model];
        }
            break;
        default:
            break;
    }
}

- (void)presentCommentView:(JHPostDetailModel *)model {
    JHOnlineAppraiseCommentView *view = [[JHOnlineAppraiseCommentView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    view.postDetail = model;
    [view refreshData];
    [self.view addSubview:view];
    [view show];
    view.timstampString = [YDHelper get13TimeStamp];
    view.hideComplete = ^{
      // 结束弹窗 加时长埋点
        NSString *nowTimeString = [YDHelper get13TimeStamp];
        NSString *duration = [NSString stringWithFormat:@"%lld", (nowTimeString.longLongValue - view.timstampString.longLongValue)];
        NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
        params[@"duration"] = duration;
        [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_duration" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
    };
}

- (void)enterVideoDetail:(JHPostDetailModel *)model {
    [JHRouterManager pushPostDetailWithItemType:model.item_type itemId:model.item_id pageFrom:@"online_appraise_detail" scrollComment:1];
}

///关注用户
- (void)toFollow {
    if (IS_LOGIN) {
        if (!self.currentPlayDetail.publisher.is_follow) {
            @weakify(self);
            [JHUserInfoApiManager followUserAction:self.currentPlayDetail.publisher.user_id fansCount:0 completeBlock:^(id  _Nullable respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"已关注"];
                    self.currentPlayDetail.publisher.is_follow = YES;
                    [self.currentCell updateFollowStatus:YES];
                    [JHUserDefaults setBool:self.currentPlayDetail.publisher.is_follow forKey:@"kOperateFollowStatusKey"];
                    [JHUserDefaults synchronize];
                    self.isFollow = self.currentPlayDetail.publisher.is_follow;
                    [self.tableView reloadData];
                }
            }];
        }
    }
}

///对帖子点赞
- (void)toLikePost:(JHPostDetailModel *)model {
    if (model.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    if (IS_LOGIN) {
        @weakify(self);
        if (model.is_like) {
            ///当前状态是已赞状态 需要取消点赞
            [JHUserInfoApiManager sendCommentUnLikeRequest:model.item_type itemId:model.item_id likeNum:[model.like_num integerValue] block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"取消点赞成功"];
                    [self __updateContentViewData:!model.is_like];
                }
            }];
        }
        else {
            [JHUserInfoApiManager sendCommentLikeRequest:model.item_type itemId:model.item_id likeNum:[model.like_num integerValue] block:^(RequestModel *respObj, BOOL hasError) {
                @strongify(self);
                if (!hasError) {
                    [UITipView showTipStr:@"点赞成功"];
                    [self __updateContentViewData:!model.is_like];
                }
            }];
        }
    }
}


- (void)__updateContentViewData:(BOOL)isLike {
    self.currentPlayDetail.like_num = @([self.currentPlayDetail.like_num integerValue] + (isLike ? 1 : (-1))).stringValue;
    self.currentPlayDetail.like_num_int += isLike ? 1 : (-1);
    self.currentPlayDetail.is_like = @(isLike).integerValue;
    [self.currentCell updateLikeInfo:[self.currentPlayDetail.like_num integerValue] isLike:self.currentPlayDetail.is_like];
}

- (void)toShare:(JHPostDetailModel *)model index:(NSInteger)index {
    if (model.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }
    model.shareInfo.pageFrom = JHPageFromTypeOnlineAppraiseVideoDetailOperate;
    model.shareInfo.extenseData = [self sa_getParamsWithModel:model index:index];
    model.shareInfo.eventId = @"appraisal_video_detail_share_cancel_click";
    [JHBaseOperationView creatShareOperationView:model.shareInfo object_flag:model.item_id];
}

- (NSMutableDictionary *)sa_getParamsWithModel:(JHPostDetailModel *)model index:(NSInteger)index {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:model.item_id forKey:@"vedio_id"];
    [params setValue:model.content forKey:@"vedio_name"];
    [params setValue:@"onlineAppraise" forKey:@"from"];
    
    if([JHRootController isLogin]) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        [params setValue:user.name forKey:@"user_name"];
    }
    
    return params;
}

- (NSMutableDictionary *)sa_getParams {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.currentPlayDetail.item_id forKey:@"vedio_id"];
    [params setValue:self.currentPlayDetail.content forKey:@"vedio_name"];
    [params setValue:self.currentPlayDetail.publisher.user_name forKey:@"user_name"];
    return params;
}

- (void)inputComment:(JHPostDetailModel *)model {
    if (model.show_status == JHPostDataShowStatusChecking) {
        [UITipView showTipStr:JHLocalizedString(@"checkingPostToast")];
        return;
    }

    if(IS_LOGIN){
        JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:200 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
        easyView.showLimitNum = YES;
        [self.view addSubview:easyView];
        [easyView show];
        @weakify(self);
        easyView.actionClickBlock = ^(ActionClickType type) {
            NSMutableDictionary *params = [self sa_getParams];
            if (type == ActionClickEmoji) {
                //发送评论 表情
                [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_emoji"params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            }else if (type == ActionClickPicture) {
                //发送评论 图片
                [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_commentpage_picture" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
            }
        };
        [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
            @strongify(self);
            [easyView endEditing:YES];
            [self toPublishPostComment:inputInfos];
        }];
    }
}

///评论帖子
- (void)toPublishPostComment:(NSDictionary *)inputInfos {
    if (!inputInfos) {
        [UITipView showTipStr:@"请输入评论内容"];
        return;
    }
    @weakify(self);
    [JHSQApiManager submitCommentWithCommentInfos:inputInfos itemId:self.currentPlayDetail.item_id itemType:self.currentPlayDetail.item_type completeBlock:^(RequestModel *respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:@"评论成功"];
            self.currentPlayDetail.comment_num += 1;
            [self.currentCell updateCommentInfo:self.currentPlayDetail.comment_num];
        }
        else {
            [UITipView showTipStr:[respObj.message isNotBlank] ? respObj.message : @"评论失败"];
        }
    }];
}

#pragma mark -
#pragma mark - lazy loading

- (UITableView *)tableView {
    if (!_tableView) {
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
        _tableView = table;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_tableView registerClass:[JHOnlineAppraiseVideoDetailCell class] forCellReuseIdentifier:kVideoDetailIdentifer];
//        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//        _tableView.mj_header = header;
    }
   
    return _tableView;
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.looping = YES;
        _playerController.alwaysPlay = YES;
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

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScrollToPlayVideoWithClick:NO];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [self endScrollToPlayVideoWithClick:NO];
//}

/// isClick 用来判断是点击还是滚动
- (void)endScrollToPlayVideoWithClick:(BOOL)isClick {
    ///369神策埋点:鉴定视频结束播放
    NSArray *visiableCells = [self.tableView visibleCells];
    if (visiableCells.count == 0) {
        return;
    }
    
    JHOnlineAppraiseVideoDetailCell *cell = visiableCells[0];
    if (self.currentCell == cell) {
        return;
    }
    if (!isClick) {
        [self sa_trackVideoEndPlay];
    }
    self.currentCell = cell;
    self.currentIndex = cell.indexPath.row;
    self.currentPlayDetail = self.dataSource[cell.indexPath.row];
    /** 添加视频*/
    self.playerController.view.frame = self.currentCell.coverImageView.bounds;
    [self.playerController setSubviewsFrame];
    [self.currentCell.coverImageView addSubview:self.playerController.view];
    self.playerController.urlString = self.currentCell.postDetail.videoInfo.url;
    
    
    ///369神策埋点:鉴定视频开始播放
    _startTime = [YDHelper get13TimeStamp].longLongValue;
    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:cell.indexPath.row];
    [JHTracking trackEvent:@"identifyVedioPlayStart" property:params.copy];
    
    //切换埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_slither_number" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}

///神策埋点:鉴定视频结束播放
- (void)sa_trackVideoEndPlay {
    _endTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_startTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:_endTime];
    NSTimeInterval
    duration = [outDate timeIntervalSinceDate:enterDate];
    
//    NSLog(@"+++ ===结束 = %f",duration);
    NSMutableDictionary *params = [self sa_getParamsWithModel:self.currentPlayDetail index:self.currentCell.indexPath.row];
    [params setValue:@(duration).stringValue forKey:@"watch_duration"];
    [params setValue:@(duration).stringValue forKey:@"duration"];
    [JHTracking trackEvent:@"identifyVedioPlayEnd" property:params];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_video_detail_duration" params:params type:JHStatisticsTypeSensors | JHStatisticsTypeGrowing];
}



@end

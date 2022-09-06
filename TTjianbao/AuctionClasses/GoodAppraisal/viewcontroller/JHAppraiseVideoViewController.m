//
//  JHAppraiseVideoViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAppraiseVideoViewController.h"
#import "JHVideoTableViewCell.h"
#import "JHPlayerControlView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "JHGemmologistViewController.h"
#import "JHVideoReportCard.h"
#import "NTESLiveManager.h"
#import "NTESAudienceLiveViewController.h"
#import "JHLikeImageView.h"
#import "JHGoodAppraisalCommentView.h"
#import <IQKeyboardManager.h>
#import "PanNavigationController.h"
#import "ChannelMode.h"
#import "JHLivePlaySMallView.h"
#import "JHBaseOperationView.h"
#import "JHGuideAnimalImage.h"
#import "JHLivePlayer.h"

@interface JHAppraiseVideoViewController ()<UITableViewDelegate, UITableViewDataSource, PanPushToNextViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray<AppraisalDetailMode *> *dataSource;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) JHPlayerControlView *controlView;
@property (nonatomic, strong) JHVideoReportCard *reporterCard;
@property (nonatomic, strong) JHGemmologistViewController *homePageVC;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) JHLikeImageView *likeGif;
@property (nonatomic, assign) BOOL isToLiveRoom;
@property (nonatomic, strong) AppraisalDetailMode *lastModel;
@property (nonatomic, assign) NSTimeInterval beginTime;
@property (nonatomic, assign) NSTimeInterval videoAllDuration;
@property (nonatomic, strong) JHGuideAnimalImage* guideAnimalImage;

//commentId不为空时，弹出评论视图
@property (nonatomic, assign) BOOL commentsHaveBeenDisplayed;
@end

@implementation JHAppraiseVideoViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        _commentId = @"0";
        _from = @"2"; //默认2
    }
    return self;
}
- (void)dealloc
{
    [self buryEnd];
    NSLog(@"%@*************被释放",[self class])

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = -1;
    self.pageSize = 20;
    [self makeUI];
    [self initPlayer];
    [self requestDetail];
    if ([CommHelp isFirstForName:@"isFirstInAppraiseVideo"])
    {
        [self.guideAnimalImage animalImageWithSuperView:self.view];
    }

}

- (BOOL)prefersStatusBarHidden {
    
    if (UI.bottomSafeAreaHeight>0.0) {
        return NO;
    }
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
        if (self.player.playingIndexPath) {
            [self.player.currentPlayerManager play];
            JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.player.playingIndexPath];
            [cell refreshAnimation];
        }
        else {
            NSArray *array = [self.tableView indexPathsForVisibleRows];
            if (array.count) {
                [self playTheVideoAtIndexPath:array.firstObject scrollToTop:NO];
            }
        }

    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:self];

    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [[JHLivePlayer sharedInstance] setMute:YES];
    //用户画像浏览时长:begin
      [JHUserStatistics noteEventType:kUPEventTypeIdentifyVideoDetailBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"group_id" : self.cateId ? : @""}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[JHLivePlayer sharedInstance] setMute:NO];
    if (!self.isToLiveRoom) {
        [self.player.currentPlayerManager pause];
    }
    //用户画像浏览时长:end
    [JHUserStatistics noteEventType:kUPEventTypeIdentifyVideoDetailBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"group_id" : self.cateId ? : @""}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    [nav setNextViewControllerDelegate:nil];
}



- (void)makeUI {
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alwaysBounceVertical=YES;
    _tableView.scrollEnabled = YES;
    _tableView.estimatedRowHeight = 100;
    _tableView.pagingEnabled = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.frame = self.view.bounds;
    _tableView.rowHeight = _tableView.frame.size.height;
    _tableView.backgroundColor = [UIColor blackColor];

//    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//    _tableView.mj_footer = footer;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JHVideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"JHVideoTableViewCell"];
    /// 停止的时候找出最合适的播放
    @weakify(self)
    _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @strongify(self)
        if (indexPath.row == self.dataSource.count-1) {
            /// 加载下一页数据
            [self requestData];
        }
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    };
    
    self.jhNavView.backgroundColor = [UIColor clearColor];
    self.jhLeftButton.titleLabel.textColor = HEXCOLOR(0x222222);
    [self initRightButtonWithImageName:@"icon_video_right_share" action:@selector(shareAction:)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    if (UI.bottomSafeAreaHeight == 0.0) {
        self.jhLeftButton.mj_y = 10;
        self.jhRightButton.mj_y = 10;
    }
}

- (void)initPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];

    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch; //ZFPlayerDisableGestureTypesDoubleTap
    self.player.controlView = self.controlView;
    self.player.controlView.frame = self.view.bounds;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.playerReadyToPlay = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSURL * _Nonnull assetURL) {
        @strongify(self)
        self.videoAllDuration = self.player.currentPlayerManager.totalTime;
    };
    self.player.playerLoadStateChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerLoadState loadState) {
        @strongify(self);
        JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.player.playingIndexPath];
        if (loadState == ZFPlayerLoadStatePrepare) {
            [cell.loadingView beginAnimation];

        }else if (loadState == ZFPlayerLoadStatePlayable) {
            [cell.loadingView endAnimation];
        }
        
        if (!self.commentsHaveBeenDisplayed && self.commentId.integerValue > 0) {
            self.commentsHaveBeenDisplayed=YES;
            [self pressCommentWithShowBar:NO];
        }
    };
}

- (JHGuideAnimalImage *)guideAnimalImage {
    if(!_guideAnimalImage) {
        _guideAnimalImage = [JHGuideAnimalImage new];
    }
    return _guideAnimalImage;
}

#pragma mark tableviewDatesource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urls.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"JHVideoTableViewCell";
    JHVideoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sliderView.value = 0;
    cell.model = self.dataSource[indexPath.row];
    MJWeakSelf
    cell.clickblock = ^(UIButton *sender) {
    
        switch (sender.tag) {
            case JHVideoTableViewCellClickTypeFollow:
                [weakSelf pressCare:sender];
                break;
            case JHVideoTableViewCellClickTypeCommentList:
                [weakSelf pressCommentWithShowBar:NO];
                break;
            case JHVideoTableViewCellClickTypeSayWhat:
                  [weakSelf pressCommentWithShowBar:YES];
                break;
            case JHVideoTableViewCellClickTypeReporter:{

                [weakSelf showReport];
            }
                break;
            case JHVideoTableViewCellClickTypeLike:
                [weakSelf controlViewOnClickLike:sender];

                break;

            case JHVideoTableViewCellClickTypeHeader:
                [weakSelf controlViewOnClickHeadImage:(NIMAvatarImageView *)sender];
                
                break;
                
            case JHVideoTableViewCellClickTypeBackView:
                [weakSelf.controlView showControlView];
                
                break;

            default:
                break;
        }
    };

    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark -- PanSwiper Delegate --
- (UIViewController *)swiperBeginPanPushToNextController:(PanSwiper *)swiper {
    JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
    vc.pageFrom = JHPageFromAppraiseVideo;
    MJWeakSelf
    vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
        [weakSelf updateFollowStatusWithAnchorId:anchorId isFollow:isFollow];
        if ([anchorId isEqualToString:[weakSelf appraisalDetail].appraiser.viewId]) {
            JHVideoTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.player.playingIndexPath];
            cell.followBtn.hidden = isFollow;
        }
        
    };
    vc.anchorId = [self appraisalDetail].appraiser.viewId?:@"";
    return vc;
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
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}


#pragma mark - get
- (JHPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [JHPlayerControlView new];
        MJWeakSelf
        _controlView.singleTapBack = ^(BOOL isAppear){
            
            JHVideoTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.player.playingIndexPath];
            cell.cellControlView.hidden = isAppear;
            weakSelf.jhNavView.hidden = isAppear;
            
        };
        _controlView.sliderValueChanged = ^(CGFloat value) {
            JHVideoTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:weakSelf.player.playingIndexPath];
            cell.sliderView.value = value;
            
        };
        
        _controlView.doubleTapBack = ^{
            
            [weakSelf controlViewOnClickLike:nil];
        };
        
        
    }
    return _controlView;
}

- (NSMutableArray<AppraisalDetailMode *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = [NSMutableArray array];
    }
    return _urls;
}


- (JHVideoReportCard *)reporterCard {
    if (!_reporterCard) {
        _reporterCard = [[NSBundle mainBundle] loadNibNamed:@"JHVideoReportCard" owner:nil options:nil].firstObject;
        CGRect rect = self.view.bounds;
        rect.origin.y = ScreenH;
        _reporterCard.frame = rect;
        
    }
    return _reporterCard;
}

#pragma mark - private method

- (void)updateFollowStatusWithAnchorId:(NSString *)anchorId isFollow:(BOOL)isf {
    if ([anchorId isEqualToString:[self appraisalDetail].appraiser.viewId]) {
        JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.player.playingIndexPath];
        cell.followBtn.hidden = isf;
    }
    for (AppraisalDetailMode *model  in self.dataSource) {
        if ([model.appraiser.viewId isEqualToString:anchorId]) {
            model.isFollow = isf;
        }
    }
}

// play the video


- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {

    NSLog(@"111111======== %@", [self appraisalDetail].recordId);
    if (self.lastModel) {
        [self buryEnd];
    }
    
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
   
    if (self.seekTime>0) {
        [self.player.currentPlayerManager setSeekTime:self.seekTime];
        self.seekTime = 0;

    }
    NSLog(@"%@",NSStringFromCGRect(self.player.currentPlayerManager.view.frame));

    AppraisalDetailMode *data = self.dataSource[indexPath.row];
    self.controlView.coverImageView.frame = self.view.bounds;
    [self.controlView showCoverViewWithUrl:data.coverImg];
    [self requestVideo:data.recordId];
    JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.cellControlView.hidden = NO;
    self.jhNavView.hidden = NO;

    NSLog(@"2222222======== %@", [self appraisalDetail].recordId);

    if ([self appraisalDetail]) {
        [self buryBegin];
    }

    
}

- (void)showReport {
    
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor clearColor];
//    [self requestReportData];
//    [vc.view addSubview:self.reporterCard];
//
//    TLSwipeAnimator *animator = [TLSwipeAnimator animatorWithSwipeType:TLSwipeTypeInAndOut pushDirection:TLDirectionToTop popDirection:TLDirectionToBottom];
//    animator.transitionDuration = 0.25f;
//    animator.isPushOrPop = NO;
//    animator.interactiveDirectionOfPush = TLDirectionToTop;
//    [self presentViewController:vc animator:animator completion:nil];
//    [vc registerInteractiveTransitionToViewController:vc animator:animator];
    
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
    [JHGrowingIO trackEventId:JHTrackvideo_detail2_baogaodianji variables:[model mj_keyValues]];

    if (![self appraisalDetail].appraiseId) {
        [self.view makeToast:@"暂无鉴定报告"];
        return;
    }
    [self.view addSubview:self.reporterCard];
    [self requestReportData];
    [self.reporterCard showAlert];

    [JHGrowingIO trackEventId:JHEventAppraisalreport];
    
}

- (void)shareAction:(UIButton *)btn {
    [self controlViewOnClickShare];
}


- (void)pressCare:(UIButton*)button{
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
    [JHGrowingIO trackEventId:JHTrackvideo_detail2_guanzhudianji variables:[model mj_keyValues]];

    if ([self isLgoin]) {
        if ((![self appraisalDetail]) || (![self appraisalDetail].appraiser.viewId)) {
            return;
        }
        
        [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/authoptional/appraise/follow") Parameters:@{@"followCustomerId":self.appraisalDetail.appraiser.viewId,@"status":@(1)} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"关注成功"];
            button.hidden = YES;
            self.dataSource[self.player.playingIndexPath.row].isFollow = YES;
            [self updateFollowStatusWithAnchorId:self.appraisalDetail.appraiser.viewId isFollow:YES];
            

        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self.view makeToast:respondObject.message];
        }];

        [SVProgressHUD show];
        
    }
}
- (void)pressCommentWithShowBar:(BOOL)isShow{
    
    if (isShow) {
        VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
         [JHGrowingIO trackEventId:JHTrackvideo_detail2_left_comment_dianji variables:[model mj_keyValues]];
    }else {
        VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
         [JHGrowingIO trackEventId:JHTrackvideo_detail2_bottom_comment_dianji variables:[model mj_keyValues]];
    }
 

    JHGoodAppraisalCommentView * view=[[JHGoodAppraisalCommentView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.view addSubview:view];
    [view show];
    [view loadData:self.appraisalDetail andShowCommentbar:isShow];
    JH_WEAK(self)
    view.hideCompleteBlock = ^(AppraisalDetailMode *mode) {
        JH_STRONG(self)
        JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.player.playingIndexPath];
        [cell.commentBtn setTitle:[NSString stringWithFormat:@" %@",[CommHelp changeAsset:mode.comments]] forState:UIControlStateNormal];
        };
}
- (void)controlViewOnClickShare{
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
            [JHGrowingIO trackEventId:JHTrackvideo_detail2_shareclick variables:[model mj_keyValues]];

    if ([self isLgoin] && self.appraisalDetail) {
        
        AppraisalDetailMode *model = [self appraisalDetail];
        NSString *stringURL = [[UMengManager shareInstance].shareVideoUrl stringByAppendingString:OBJ_TO_STRING(model.appraiseId)];
        //@"来看大神的鉴定一对一鉴定视频，珠宝，翡翠，玉石"
        stringURL = [stringURL stringByAppendingString:[NSString stringWithFormat:@"&type=1"]];
        NSString *string = model.title;
        
//        [UMengManager shareInstance].appraisalDetailMode = [self appraisalDetail];
//        [[UMengManager shareInstance] showShareWithTarget:nil title:string text:model.assessmentReport thumbUrl:nil webURL:stringURL type:ShareObjectTypeAppraiseVideo object:self.appraisalDetail.recordId];
        JHShareInfo* info = [JHShareInfo new];
        info.title = string;
        info.desc = model.assessmentReport;
        info.shareType = ShareObjectTypeAppraiseVideo;
        info.url = stringURL;
        info.extenseData = [self appraisalDetail];
        [JHBaseOperationView showShareView:info objectFlag:self.appraisalDetail.recordId];
    }
}

- (void)controlViewOnClickLike:(UIButton *)btn{
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
            [JHGrowingIO trackEventId:JHTrackvideo_detail2_landclick variables:[model mj_keyValues]];
    if ([self isLgoin]) {

        AppraisalDetailMode *model = [self appraisalDetail];
        if (!model) {
            return;
        }
        
        BOOL isDouble = NO;
        if (!btn) {
            isDouble = YES;
            JHVideoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.player.playingIndexPath];
            btn = cell.likeBtn;
     
            if ([self appraisalDetail].isLaud){
                JHLikeImageView *image = [[JHLikeImageView alloc] initWithFrame:CGRectZero];
                image.frame = CGRectMake(0, 0, 100, 100);
                image.center = self.view.center;
                [self.view addSubview:image];
                [image beginAnimation];

                return;
            }

        }
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),model.recordId,model.isLaud?@"0":@"1"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lauds"] = model.lauds;
        [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
//            [SVProgressHUD dismiss];
            btn.selected = !btn.selected;
            self.dataSource[self.player.playingIndexPath.row].isLaud = btn.selected;
            self.dataSource[self.player.playingIndexPath.row].lauds = respondObject.data[@"like_num"];
            [btn setTitle:[NSString stringWithFormat:@" %@", respondObject.data[@"like_num"]] forState:UIControlStateNormal];
            if (self.likeChangedBlock) {
                self.likeChangedBlock(respondObject.data[@"like_num"]);
            }
            
            if (self.likeChangedStatusBlock) {
                self.likeChangedStatusBlock(respondObject.data[@"like_num"],model.isLaud);
            }
            if (isDouble) {
                JHLikeImageView *image = [[JHLikeImageView alloc] initWithFrame:CGRectZero];
                image.frame = CGRectMake(0, 0, 100, 100);
                image.center = self.view.center;
                [self.view addSubview:image];
                [image beginAnimation];

            }
        } failureBlock:^(RequestModel *respondObject) {
//            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
//        [SVProgressHUD show];
    }
}
- (void)controlViewOnClickHeadImage:(NIMAvatarImageView *)controlView{
    VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
    [JHGrowingIO trackEventId:JHTrackvideo_detail2_touxiangdianji variables:[model mj_keyValues]];
    if (!self.appraisalDetail.appraiser.channel) {
        return;
    }
    
    [JHRootController EnterLiveRoom:self.appraisalDetail.appraiser.channel fromString:JHLiveFromvideoDetail2];
    
    return;
    
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(self.appraisalDetail.appraiser.channel)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        [NTESLiveManager sharedInstance].orientation = NIMVideoOrientationDefault;
        [NTESLiveManager sharedInstance].type = NIMNetCallMediaTypeVideo;
        [NTESLiveManager sharedInstance].role = NTESLiveRoleAudience;
        
        if ([channel.status integerValue]==2)
        {
            self.isToLiveRoom = YES;
            if (self.player.currentPlayerManager.isPlaying) {
                [self.player.currentPlayerManager stop];
            }

            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            vc.coverUrl = channel.coverImg;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
            MJWeakSelf
            vc.finishFollow = ^(NSString * _Nonnull anchorId, BOOL isFollow) {
                [weakSelf updateFollowStatusWithAnchorId:anchorId isFollow:isFollow];
                
                
            };
            vc.anchorId = [self appraisalDetail].appraiser.viewId?:@"";
            [self.navigationController pushViewController:vc animated:YES];

//            return ;
//            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:nil];
//            vc.channel = channel;
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    [SVProgressHUD show];
    
}

- (BOOL)isLgoin {
    
    if (![JHRootController isLogin]) {
        MJWeakSelf
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                [weakSelf fetchFollowStatus];
            }
        }];
        
        return NO;
    }
    
    return YES;
}


- (AppraisalDetailMode *)appraisalDetail {
    if (self.player.playingIndexPath) {
        return self.dataSource[self.player.playingIndexPath.row];
    } else {
        
    }
    return nil;
}

#pragma mark request

- (void)requestReportData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/authoptional/reportDetail") Parameters:@{@"appraiseRecordId":[self appraisalDetail].appraiseId} successBlock:^(RequestModel *respondObject) {
        self.reporterCard.model = [JHRecorderModel mj_objectWithKeyValues:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
}

- (void)requestData {
    self.pageIndex ++;
    if (!self.dataSource || self.dataSource.count == 0) {
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"cateId"] = self.cateId;
    dic[@"pageSize"] = @(self.pageSize);
    dic[@"appraiseId"] = self.dataSource.lastObject.appraiseId;
    dic[@"anchorId"] = self.anchorId;
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraiseRecord/details/authoptional") Parameters:dic successBlock:^(RequestModel *respondObject) {
        NSArray *array =  [AppraisalDetailMode mj_objectArrayWithKeyValuesArray:respondObject.data];

        
        [self.dataSource addObjectsFromArray:array];
        
        for (AppraisalDetailMode *model in array) {
            NSString *url = [model.pullUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [self.urls addObject:[NSURL URLWithString:url]];
        }
        self.player.assetURLs = self.urls;

        [self.tableView reloadData];
        if (!array || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failureBlock:^(RequestModel *respondObject) {
        
    }];

}


- (void)requestDetail {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraiseRecord/detail/authoptional") Parameters:@{@"appraiseId":self.appraiseId} successBlock:^(RequestModel *respondObject) {

        AppraisalDetailMode *model = [AppraisalDetailMode mj_objectWithKeyValues:respondObject.data];
        self.dataSource = [NSMutableArray array];
        [self.dataSource addObject:model];

        NSString *url = [model.pullUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self.urls addObject:[NSURL URLWithString:url]];
        self.player.assetURLs = self.urls;
        [self.tableView reloadData];
        [self requestData];
//
//        @weakify(self)
//        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
//            @strongify(self)
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
//        }];
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)requestVideo:(NSString *)recordId {
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/appraiseRecord/watch") Parameters:@{@"recordId":recordId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];

}

- (void)fetchFollowStatus {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/authoptional/appraise/isFollow") Parameters:@{@"followCustomerId":[self appraisalDetail].appraiser.viewId} successBlock:^(RequestModel *respondObject) {
        NSInteger isFollow = [respondObject.data[@"isFollow"] integerValue];
        [self updateFollowStatusWithAnchorId:[self appraisalDetail].appraiser.viewId isFollow:isFollow];

    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}


- (void)buryBegin {
    
    JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
    model.video_id = self.appraisalDetail.recordId;
    model.live_id = self.appraisalDetail.originRecordId;
    model.video_type = 3;
 
    model.from = _from?:@"";
    model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] videoInBuryWithModel:model];
    {
        VideoExtendModel *model = [JHGrowingIO videoExtendModel:[self appraisalDetail]];
               model.from = self.from;
               [JHGrowingIO trackEventId:JHTrackvidoe_detail2_in variables:[model mj_keyValues]];
               self.beginTime = time(NULL);
               self.lastModel = [self appraisalDetail];
    }
}

- (void)buryEnd {
    JHBuryPointVideoInfoModel *model = [[JHBuryPointVideoInfoModel alloc] init];
    model.video_id = self.lastModel.recordId;
    model.live_id = self.lastModel.originRecordId;
    model.video_type = 3;
//    model.from = _from.integerValue;
    model.time =  [[CommHelp getNowTimeTimestampMS] integerValue];
    [[JHBuryPointOperator shareInstance] videoOutBuryWithModel:model];
    

    {
        [JHGrowingIO trackEventId:JHEventAuthoptionalvideoplay];
        VideoExtendModel *model = [JHGrowingIO videoExtendModel:self.lastModel];
        NSInteger dur = 0;
        if (self.beginTime > 0) {
            dur = time(NULL)-self.beginTime;
        }
        model.duration = @(dur).stringValue;
        model.playOver = dur>=self.videoAllDuration;
        [JHGrowingIO trackEventId:JHTrackvideo_detail2_duration variables:[model mj_keyValues]];
    }
}
@end

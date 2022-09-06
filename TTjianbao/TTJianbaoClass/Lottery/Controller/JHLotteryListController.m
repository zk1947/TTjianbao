//
//  JHLotteryListController.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryListController.h"
#import "JHSQHelper.h"
#import "JHLotteryDataManager.h"
#import "YDMediaCarousel.h"
#import "JHLotteryStateHeader.h"
#import "JHLotteryRuleCell.h"
#import "JHLotteryCodeCell.h"
#import "JHLotteryDetailInfoView.h"

#import "ZHProgressHud.h"
#import "JHLotterShareAlert.h"
#import "JHLotterAddAddressAlert.h"

#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"

//播放器头文件
#import "YDPlayerControlView.h"
#import "ZFPlayer.h"
#import "ZFUtilities.h"
#import "ZFAVPlayerManager.h"
#import "AdressManagerViewController.h"

#import "GrowingManager+Lottery.h"
#import "AdressMode.h"
@interface JHLotteryListController ()

@property (nonatomic, assign) BOOL isVideoIndex; //记录当前媒体资源页是否是视频
@property (nonatomic, strong) YDMediaCarousel *mediaCarousel; //媒体资源展示header

@property (nonatomic, strong) JHLotteryActivityDetailModel *activityData; //活动内容
@property (nonatomic, strong) NSMutableArray<YDMediaData *> *mediaSource; //媒体资源
@property (nonatomic, strong) NSArray <JHLotteryMyCodeModel *>*myCodeArray; //我的抽奖码

//---------------------------- 视频播放部分 ----------------------------
@property (nonatomic, assign) BOOL preVideoPlaying; //记录滑出视频区域时的播放状态
@property (nonatomic, strong) YDMediaData *videoData; //记录视频数据
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) YDPlayerControlView *playerControl;
@property (nonatomic, strong) UITapImageView *videoContainer;

@property (nonatomic, assign) BOOL isReload;

//记录进入时间
@property (nonatomic, assign) NSTimeInterval enterTime;

@end

@implementation JHLotteryListController

- (void)dealloc {
    NSLog(@"JHLotteryListController::dealloc");
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _myCodeArray = [NSMutableArray new];
    [self configTableView];
    
    if(_isHistory) {
        [self showNaviBarForHistory];
        [self requestWithCode:self.codeStr];
    } else {
        [self loadMyCodeData];
    }
    
    if (_needAddAddress) {
        [self addAddress];
    }
}

- (void)listWillAppear {
    //记录进入时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
}

- (void)listDidAppear {
    if (self.preVideoPlaying && _isVideoIndex) {
        [self.player.currentPlayerManager play];
    }
}

- (void)listDidDisappear {
    if (self.player.currentPlayerManager.isPlaying) {
        self.preVideoPlaying = self.player.currentPlayerManager.isPlaying;
        [self.player.currentPlayerManager pause];
    }
    //埋点-页面浏览时长
    [self gioBrowseDuration];
}

- (void)showNaviBarForHistory {
    [self showNaviBar];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.title = @"0元抽奖";
    self.naviBar.bottomLine.hidden = NO;
}

- (void)configTableView {
    NSArray *cellNames = @[NSStringFromClass([JHLotteryRuleCell class]),
                           NSStringFromClass([JHLotteryCodeCell class])];
    [JHSQHelper configTableView:self.tableView cells:cellNames];
    _mediaCarousel = [self customMediaCarousel];
    _mediaCarousel.mediaList = _mediaSource;
    self.tableView.tableHeaderView = _mediaCarousel;
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(_isHistory ? UI.statusAndNavBarHeight : 0, 0, 0, 0));
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, UI.bottomSafeAreaHeight+20)];
}


#pragma mark -
#pragma mark - 视频播放相关
- (YDMediaCarousel *)customMediaCarousel {
    YDMediaCarousel *carousel = [[YDMediaCarousel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, YDMediaCarouselHeight)];
    
    @weakify(self);
    carousel.startPlayBlock = ^{
        @strongify(self);
        [self startPlaying];
    };
    
    carousel.hasVideoBlock = ^(YDMediaData * _Nonnull data, UITapImageView * _Nonnull videoContainer) {
        @strongify(self);
        self.isVideoIndex = YES;
        self.videoData = data;
        self.videoContainer = videoContainer;
        [self configPlayer];
    };
    
    carousel.didEndScrollBlock = ^(BOOL isVideoIndex) {
        @strongify(self);
        self.isVideoIndex = isVideoIndex;
        if (isVideoIndex && self.preVideoPlaying) {
            [self.player.currentPlayerManager play];
            
        } else {
            if (self.player.currentPlayerManager.isPlaying) {
                self.preVideoPlaying = self.player.currentPlayerManager.isPlaying;
                [self.player.currentPlayerManager pause];
            }
        }
    };
    
    return carousel;
}

- (void)configPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
    //player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerView:self.videoContainer];
    self.player.playerDisapperaPercent = 1.0;
    self.player.playerApperaPercent = 0.0;
    self.player.controlView = self.playerControl;
    self.player.stopWhileNotVisible = NO; //离开屏幕时停止播放
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stop];
        [self.mediaCarousel endPlay];
    };
}

//开始播放
- (void)startPlaying {
    //在这里判断能否播放。。。
    if (self.player.currentPlayerManager.isPlaying) {
        return;
    }
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:_videoData.videoUrl];
    [self.playerControl showTitle:nil coverURLString:_videoData.imageUrl fullScreenMode:ZFFullScreenModePortrait];
    
    if (self.tableView.contentOffset.y > _mediaCarousel.height) {
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.videoContainer];
    }
}

- (YDPlayerControlView *)playerControl {
    if (!_playerControl) {
        _playerControl = [YDPlayerControlView new];
    }
    return _playerControl;
}


#pragma mark -
#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}


#pragma mark -
#pragma mark - 数据处理
- (void)setCurData:(JHLotteryData *)curData {
    _curData = curData;
    self.activityData = (JHLotteryActivityDetailModel *)curData.activityList.firstObject;
    self.activityData.timeTotalNum = self.activityData.endTimestamp - self.activityData.currentTimestamp;
    _mediaSource = [JHLotteryDataManager mediaSourceFromMediaList:_activityData.mediaList];
}

#pragma mark -
#pragma mark - 网络请求
- (void)refresh {
    if (_isHistory) {
        [self requestWithCode:self.codeStr];
    } else {
        if (self.refreshBlock) {
            self.refreshBlock(self);
        }
    }
}

- (void)updateListData {
    [self.tableView reloadData];
    [self loadMyCodeData];
}

//获取详情信息
- (void)requestWithCode:(NSString *)code {
    @weakify(self);
    [JHLotteryDataManager getLotteryListDetailWithActivityCode:code inviter:@"" unionId:@"" resp:^(id obj, id data) {
        @strongify(self);
        [self endRefresh];
        if (data) {
            if (_isHistory) {
                self.activityData = data;
                self.mediaSource = [JHLotteryDataManager mediaSourceFromMediaList:self.activityData.mediaList];
                self.mediaCarousel = [self customMediaCarousel];
                self.mediaCarousel.mediaList = self.mediaSource;
                self.tableView.tableHeaderView = _mediaCarousel;
                [self loadMyCodeData];
                
            } else {
                _mediaCarousel = [self customMediaCarousel];
                _mediaCarousel.mediaList = _mediaSource;
                self.tableView.tableHeaderView = _mediaCarousel;
                self.tableView.estimatedSectionHeaderHeight = 204.f;
                [self.tableView reloadData];
            }
        }
    }];
}

//获取我的抽奖码
- (void)loadMyCodeData {
    @weakify(self);
    [JHLotteryMyCodeModel asynRequestActivityCode:self.activityData.activityCode unionId:@"" resp:^(NSString *msg, NSArray* arr) {
        NSLog(@"MyCode~ok");
        @strongify(self);
        self.myCodeArray = arr;
        [self.tableView reloadData];
    }];
}

#pragma mark - 点击按钮进行活动状态事件处理： 0-未参与  1-参与未分享  2-分享未助力 3-分享满
- (void)handleActivityStateEventWithType:(NSInteger)type {
    switch (type) {
        case 0:{
            [self sendJoinRequest];
            break;
        }
        case 1:
        case 2:{
            [self toShare]; //type=1或2 执行分享
            //埋点-点击页面的立即分享按钮
            [GrowingManager lotteryClickShare:[self gioBasicParams]];
            break;
        }
        case 4:{//remind
            [self lotteryRemind];
            //埋点-
            break;
        }
        default:
            break;
    }
}

//type=0 执行参加活动请求
- (void)sendJoinRequest {
    if ([JHSQManager needLogin]) {
        return;
    }
    [ZHProgressHud showLoading:@"正在请求" inView:self.view];
    @weakify(self);
    [JHLotteryDataManager sendJoinRequestWithActivityCode:_activityData.activityCode block:^(JHLotteryJoinModel * _Nullable respObj, BOOL hasError) {
        [ZHProgressHud hide];
        @strongify(self);
        if (respObj) {
            self.activityData.buttonTxt = respObj.buttonTxt;
            [self.tableView reloadData];
            [self showAlertTitle:respObj.dialog.title subTitle:respObj.dialog.subtitle btnTitle:respObj.dialog.buttonTxt];
            //刷新抽奖码
            [self refresh];
            [self loadMyCodeData];
        }
    }];
    
    //埋点-点击0元参与抽奖按钮
    [GrowingManager lotteryClickJoin:[self gioBasicParams]];
}

//参加活动成功后的提示弹框，
- (void)showAlertTitle:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle {
    @weakify(self);
    [JHLotterShareAlert showAlertTitle:title subTitle:subTitle btnTitle:btnTitle clickBlock:^{
        @strongify(self);
        [self toShare];
        //埋点-点击页面的立即分享按钮
        [GrowingManager lotteryClickDialogShare:[self gioBasicParams]];
    }];
}

//执行分享
- (void)toShare {
    _activityData.shareInfo.pageFrom = JHPageFromTypeUnKnown;
    [JHBaseOperationView creatShareOperationView:_activityData.shareInfo object_flag:_activityData.activityCode];
}
//分享成功后-发送分享成功请求
- (void)sendShareCompleteRequest {
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    
    @weakify(self);
    [JHLotteryShareModel asynRequestActivityCode:_activityData.activityCode resp:^(id obj, JHLotteryShareModel* data) {
        @strongify(self);
        if (data && [data.buttonTxt isNotBlank]) {
            self.activityData.buttonTxt = data.buttonTxt ?: @"分享再得一张抽奖码";
            self.activityData.subtitle = data.subtitle ?: @"新人助力抽奖码+3，普通用户助力+1";
            [self.tableView reloadData];
            
            if (data.dialog) {
                [self showAlertTitle:data.dialog.title subTitle:data.dialog.subtitle btnTitle:data.dialog.buttonTxt];
            }
        }
        //刷新抽奖码
        [self loadMyCodeData];
    }];
}

- (void)lotteryRemind
{
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    
    //埋点-点击提醒
    [self gioClickRemind];
    
    @weakify(self);
    [JHLotteryRemindModel asynRequestActivityCode:self.activityData.activityCode resp:^(NSString *msg, JHLotteryRemindModel* data) {
        NSLog(@"Remind~ok");
        @strongify(self);
        self.activityData.buttonTxt = data.buttonTxt;
        [self.tableView reloadData];
        [UITipView showTipStr:data.toast];
    }];
}

- (void)addAddress
{
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    
    //判断填写地址是否过期
    @weakify(self);
    [JHLotteryEditAddressModel asynRequestActivityCode:self.codeStr ? : self.activityData.activityCode addressId:@"" resp:^(NSString *msg, JHLotteryEditAddressModel* data) {
        @strongify(self);
        if (msg) {
            [UITipView showTipStr:msg];
        } else {
            if (data.isExpired) {
                [UITipView showTipStr:data.expiredTxt ? : @"领奖已过期"];
            } else {
                [self enterAddressVCAnimated:!self.needAddAddress];
            }
        }
    }];
}

- (void)addAddressWithId:(NSString *)addressId
{
    if (![JHRootController isLogin]){
        [JHRootController presentLoginVC];
        return;
    }
    @weakify(self);
    [JHLotteryEditAddressModel asynRequestActivityCode:self.activityData.activityCode addressId:addressId resp:^(NSString *msg, JHLotteryEditAddressModel* data) {
        @strongify(self);
        if (data) {
            if(data.isExpired) {
                [UITipView showTipStr:data.expiredTxt ? : @"领奖已过期"];
            } else {
                [self requestWithCode:self.activityData.activityCode];
            }
        } else {
            [UITipView showTipStr:msg];
        }
    }];
}

- (void)enterAddressVCAnimated:(BOOL)animated {
    AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
    @weakify(self);
//    vc.selectedBlock = ^(NSString *selected) {
//        @strongify(self);
//        [self addAddressWithId:selected];
//    };
    vc.selectedBlock = ^(AdressMode *model) {
         @strongify(self);
        [self addAddressWithId:model.ID];
    };
    [self.navigationController pushViewController:vc animated:animated];
}

#pragma mark -
#pragma mark - UITableView Delegate & dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //state：活动状态（1:进行中、2:已开奖、3:未开始）
    //hit：中奖状态(0:未参与、1:中奖、2:未中奖)
    NSInteger count = 7;
    if (_isHistory) { //往期
        count = self.myCodeArray.count + 1;
        if (_activityData.hit == 0) { //未参与-不显示规则+抽奖码
            count = 0;
        }
        
    } else {
        if (_activityData.state == 2) { //已开奖(结束)状态显示实际抽奖码个数
            count = self.myCodeArray.count + 1;
        } else if (_activityData.state == 3) { //未开始-啥都不显示
            count = 0;
        }
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_isHistory)
    {
//        JHLotteryDetailInfoView *header = [[JHLotteryDetailInfoView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [self.activityData statusViewHeight])];
        JHLotteryDetailInfoView *header = [[JHLotteryDetailInfoView alloc] initWithFrame:CGRectZero];
        header.model = self.activityData;
        JH_WEAK(self)
        header.addAddressBlock = ^{
            JH_STRONG(self)
            [self addAddress];
            //埋点-点击填写地址
            [GrowingManager lotteryClickAddAddress:[self gioBasicParams]];
        };
        return header;
    }
    else
    {
        JHLotteryStateHeader *header = [[JHLotteryStateHeader alloc] initWithFrame:CGRectZero];
        @weakify(self);
        header.reloadBlock = ^{
            @strongify(self);
            [self refresh];
        };
        [header setActivityData:self.activityData codeCount:self.myCodeArray.count];
        header.activityStateEventBlock = ^(NSInteger type) {
            @strongify(self);
            [self handleActivityStateEventWithType:type];
        };
        return header;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [JHLotteryRuleCell cellHeight];
    } else {
        CGFloat cellHeight = (ScreenW - 33)*71/342;
        return cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
         JHLotteryRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLotteryRuleCell class]) forIndexPath:indexPath];
        
        [cell setActivityData:self.activityData];
        [cell setCodeCount:self.myCodeArray.count];
       //  self.myCodeArray
         return cell;
        
    } else {
        JHLotteryMyCodeModel *model = self.myCodeArray[indexPath.row-1];
         JHLotteryCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHLotteryCodeCell class]) forIndexPath:indexPath];
        cell.codeModel = model;
         return cell;
    }
}


#pragma mark -
#pragma mark - 埋点

//基础参数
- (NSMutableDictionary *)gioBasicParams {
    JHLotteryActivityData *data = _curData.activityList.firstObject;
    return @{@"activityDate" : data.activityDate}.mutableCopy;
}

//埋点-浏览时长统计
- (void)gioBrowseDuration {
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    
    NSMutableDictionary *params = [self gioBasicParams];
    [params setValue:@(duration) forKey:@"duration"];
    //[params addEntriesFromDictionary:@{@"duration" : @(duration)}];
    
    [GrowingManager lotteryBrowseDuration:params];
}

//埋点-点击提醒
- (void)gioClickRemind {
    NSMutableDictionary *params = [self gioBasicParams];
    [params setValue:@(self.activityData.remindSwitch) forKey:@"is_remind"];
    [GrowingManager lotteryClickRemind:params];
}

@end

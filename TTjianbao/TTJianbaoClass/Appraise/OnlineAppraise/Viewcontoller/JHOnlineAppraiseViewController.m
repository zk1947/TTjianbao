//
//  JHOnlineAppraiseViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/12/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHGemmologistViewController.h"
#import "JHAnchorStyleViewController.h"
#import "JHCustomerInfoController.h"
#import "JHOnlineVideoDetailController.h"

#import "JHWaterfallFlowAlyout.h"
#import "JHDefaultCollectionViewCell.h"
#import "JHOnlineListCollectionCell.h"
#import "JHOnlineAppraiseHeader.h"
#import "JHOnlineTopicHeader.h"
#import "JHAnniversaryBagView.h"
#import "JHOnlineAppraiseTopicView.h"
#import "JHHomeHeaderView.h"

#import "JHSQModel.h"
#import "ChannelMode.h"
#import "JHLiveRoomMode.h"
#import "JHPostDetailModel.h"
#import "JHCollectionItemModel.h"

#import "JHMaskPopWindow.h"
#import "JHMaskingManager.h"
#import "JHAppAlertViewManger.h"
#import "JHOnlineAppraiseManager.h"
#import "JHNimNotificationManager.h"
#import "NSString+Common.h"
#import "UIView+JHGradient.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"

@interface JHOnlineAppraiseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, JHWaterfallFlowLayoutDelegate, JHOnlineVideoDetailControllerDelegate>
{
    NSInteger _page;
    NSString *_lastDate;
    NSInteger headerHeight;
    CGFloat allHeaderHeight;
    BOOL isLoadCacheDataComplete;
    JHHomeHeaderMainAnchorView * lastAnchourView;
    BOOL  showDefaultImage;
    BOOL isActiveTheme;
    BOOL _isFollow; ///固定用户的关注状态
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHHomeHeaderView *headerView;
@property (nonatomic, strong) JHOnlineTopicHeader *topicHeader;

@property (nonatomic, strong) UIView *gradient;

@property (nonatomic, strong) JHChannelData *channelData;
@property (nonatomic, strong) NSMutableArray *bannerModes;
@property (nonatomic, copy) NSArray <JHOnlineAppraiseModel *>*topicInfo;
@property (nonatomic, strong) NSMutableArray <JHPostDetailModel *>*postListData;
@property (nonatomic, assign) NSInteger currentSelectIndex;
///在线鉴定固定用户的用户id
@property (nonatomic, copy) NSString *operationUserId;
@property (nonatomic, assign) BOOL disableClick;
@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, assign) BOOL hasRecycleInfo;

@end

static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation JHOnlineAppraiseViewController

- (NSMutableArray<JHPostDetailModel *> *)postListData {
    if (!_postListData) {
        _postListData = [NSMutableArray array];
    }
    return  _postListData;
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self growingWithTrackEventId:@"online_appraisal_duration" dict:@{}];
}
- (instancetype)init{
    if (self = [super init]) {
        _operationUserId = nil;
        _lastDate = nil;
        _isFollow = [JHUserDefaults boolForKey:@"kOperateFollowStatusKey"];
        headerHeight = kDefaultHeaderHeight;
        allHeaderHeight = kDefaultHeaderHeight;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshThemeView:) name:kCelebrateRunningOrNotNotification object:nil];
    }
    return self;
}

- (void)refreshThemeView:(NSNotification*)notify
{
    NSNumber* isActivityTheme =(NSNumber*)notify.object;
    isActiveTheme = [isActivityTheme boolValue];
//    [self drawCelebrateTag];
    [self.headerView refreshThemeView:isActiveTheme];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhNavView.hidden = YES;
    self.hasRecycleInfo = NO;
    self.view.backgroundColor = kColorF5F5F8;
    [self.view addSubview:self.gradient];
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.headerView];
    [self.view addSubview:self.topicHeader];
    [self.topicHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(headerSegmentHeight);
    }];
    
    //用户画像浏览时长:begin
    if(![JHUserStatistics hasResumeBrowseEvent]) {
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
}

-(UICollectionView*)collectionView {
    if (!_collectionView) {
        JHWaterfallFlowAlyout *flowLayout = [[JHWaterfallFlowAlyout alloc] init];
        flowLayout.sectionHeadersPinToVisibleBounds = YES;
        flowLayout.dataSource = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, ScreenW, ScreenH-UI.statusAndNavBarHeight) collectionViewLayout:flowLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0,UI.bottomSafeAreaHeight+49, 0);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[JHOnlineListCollectionCell class] forCellWithReuseIdentifier:cellId];
        
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        
        [_collectionView registerClass:[JHOnlineTopicHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHOnlineTopicHeader class])];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
        
        @weakify(self);
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refresh];
        }];
        _collectionView.contentOffset = CGPointZero;
         _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _collectionView;
}

- (JHOnlineTopicHeader *)topicHeader {
    if (!_topicHeader) {
        _topicHeader = [[JHOnlineTopicHeader alloc] init];
        _topicHeader.backgroundColor = kColorFFF;
        _topicHeader.hidden = YES;
    }
    return _topicHeader;
}

- (UIView *)gradient {
    if (!_gradient) {
        UIView *gradient = [[UIView alloc] initWithFrame:CGRectMake(0, allHeaderHeight, ScreenW, kGradientHeight)];
        [gradient jh_setGradientBackgroundWithColors:@[kColorFFF, HEXCOLOR(0xF5F5F5)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
        _gradient = gradient;
    }
    return _gradient;
}

- (void)trackUserProfilePage:(BOOL)isBegin {
    if(isBegin) {
        //用户画像浏览时长:begin
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    else {
        //用户画像浏览时长:end
        [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd} resumeBrowse:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHGrowingIO trackEventId:@"online_appraisal"];
   // [self  pullStream];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    ///更新当前申请鉴定排麦位次
    [self getApplyMicInfo];
    
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250 - UI.statusAndNavBarHeight];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"在线鉴定首页"} type:JHStatisticsTypeSensors];
}



- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self shutdown];
    lastAnchourView = nil;
    if ([JHMaskPopWindow defaultWindow].isPop) {
        [JHMaskPopWindow dismiss];
    }
}

-(void)getApplyMicInfo {
    [[UserInfoRequestManager sharedInstance] getApplyMicInfoComplete:^{
        [self.headerView updateAppraise];
    }];
}

#pragma mark -
#pragma mark - load Data
- (void)getOperationUserConfig:(dispatch_block_t)block {
    @weakify(self);
    [JHOnlineAppraiseManager getOperationUserConfig:^(NSString *userId, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            self.operationUserId = userId;
            [self getTopicListData:block];
            [self getPostData:^(NSArray<JHPostDetailModel *>*postArray) {
                _isFollow = [postArray firstObject].publisher.is_follow;
                [JHUserDefaults setBool:_isFollow forKey:@"kOperateFollowStatusKey"];
                [self handleDataWithArr:postArray];
            }];
        }
    }];
}

- (void)getTopicListData:(dispatch_block_t)block {
    @weakify(self);
    [JHOnlineAppraiseManager getOnlineTopicListInfo:self.operationUserId completeBlock:^(NSArray <JHOnlineAppraiseModel *>*topicInfo, BOOL hasError) {
        if (!hasError) {
            @strongify(self);
            self.topicInfo = topicInfo;
            self.topicHeader.topicInfo = topicInfo;
        }
        if (block) {
            block();
        }
    }];
}

- (void)refresh {
    [self.collectionView.mj_footer resetNoMoreData];
    _lastDate = @"";
    _page = 1;
    dispatch_group_t  group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    [self requestRecycle:^{
        dispatch_group_leave(group);
    }];
    [self getOperationUserConfig:^{
        dispatch_group_leave(group);
    }];
    [self requestChannels:^{
        dispatch_group_leave(group);
    }];
    [self requestBanners:^{
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self endRefresh];
        headerHeight = (kDefaultHeaderHeight + (self.bannerModes.count > 0 ? bannerHeight : -12));
        if (!self.hasRecycleInfo) {
            headerHeight = headerHeight - recycleHeight - 10.f;
        }
        allHeaderHeight = headerHeight + headerSegmentHeight;
        self.headerView.mj_h = headerHeight;
        self.gradient.y = allHeaderHeight;
        [self.collectionView reloadData];
         NSLog(@"完成!");
         [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
             if (self.player) {
                [self shutdown] ;
                 dispatch_async(dispatch_get_main_queue(), ^{
                     lastAnchourView = nil;
                     [self.headerView setChanneData:self.channelData isCacheData:NO];
                     [self pullStream];
                     self.shutdownHandler = nil;
                 });
             }
             else{
                 [self.headerView setChanneData:self.channelData isCacheData:NO];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     dispatch_async(dispatch_get_main_queue(), ^{
                       [self pullStream];
                     });
                 });
             }
         }];
    });
    
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeIdentifyHomeEntrance params:nil];
}

- (void)loadMoreData {
    _lastDate =  [[self.postListData lastObject] last_date];
    @weakify(self);
    [self getPostData:^(NSArray<JHPostDetailModel *>*postArray) {
        @strongify(self);
        [self handleDataWithArr:postArray];
    }];
}

- (void)getPostData:(void(^)(NSArray <JHPostDetailModel *>*postArray))complete {
    [JHOnlineAppraiseManager getOnlinePostInfo:self.operationUserId page:_page lastDate:_lastDate completeBlock:^(NSArray *postArray, BOOL hasError) {
        if(IS_ARRAY(postArray) && postArray.count > 0) {
            _page += 1;
        }
        if (complete) {
            complete(postArray);
        }
//        [self endRefresh];
    }];
}

-(void)loadCacheData {
    __block NSDictionary *dic;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *data = [FileUtils readDataFromFile:AppraisalLivesData];
        if (data) {
          dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dic isKindOfClass: [NSDictionary class]]) {
                self.channelData = [JHChannelData mj_objectWithKeyValues:dic];
                [self.headerView setChanneData:self.channelData isCacheData:YES];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView.mj_header beginRefreshing];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableBarSelect:) name:TableBarSelectNotifaction object:nil];
                });
            });
        });
    });
}

- (void)requestBanners:(dispatch_block_t)block {
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/ad/3") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.bannerModes = [NSMutableArray arrayWithCapacity:10];
        self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.headerView setBanners:self.bannerModes];
        if (block) {
            block();
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
///获取鉴定师列表数据
-(void)requestChannels:(JHFinishBlock)complete {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/channel/all/appraise/authoptional") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.channelData = [JHChannelData mj_objectWithKeyValues: respondObject.data];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:AppraisalLivesData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"写入成功");
            }
        });
        complete();
        
    } failureBlock:^(RequestModel *respondObject) {
          complete();
    }];
}
/// 获取回收数据
- (void)requestRecycle:(JHFinishBlock)complete {
    NSString *url = FILE_BASE_STRING(@"/recycle/capi/auth/opt/getRecyclePlate");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        JHRecycleHomeGetRecyclePlateModel *dataModel = [JHRecycleHomeGetRecyclePlateModel mj_objectWithKeyValues:respondObject.data];
        if (!isEmpty(dataModel.title) && !isEmpty(dataModel.statisticsTip) &&
            !isEmpty(dataModel.channelDesc) && !isEmpty(dataModel.channelTitle) &&
            !isEmpty(dataModel.imageTextDesc) && !isEmpty(dataModel.imageTextTitle)) {
            self.hasRecycleInfo = YES;
            [self.headerView bindRecycleData:dataModel];
        } else {
            self.hasRecycleInfo = NO;
        }
        complete();
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        self.hasRecycleInfo = NO;
        [self.headerView bindRecycleData:nil];
        complete();
    }];
}
- (void)handleDataWithArr:(NSArray <JHPostDetailModel *>*)arr {
    if (arr.count > 0) {
        [self.collectionView.mj_footer endRefreshing];
        if (_page == 1) {
            self.postListData = [NSMutableArray arrayWithArray:arr];
        }else {
            [self.postListData addObjectsFromArray:arr];
        }
    }
    else {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }
    for (int i = 0; i < arr.count; i ++) {
        JHPostDetailModel *model = arr[i];
        model.listIndex = self.postListData.count-arr.count + i;
    }
//    if (self.postListData.count == 0) {
//        [self showDefaultImageWithView:self.collectionView];
//    }
//    else {
//        [self hiddenDefaultImage];
//    }
    [self.collectionView reloadData];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

///进入选择鉴定师界面
- (void)enterArchorStylePage {
    [JHGrowingIO trackEventId:@"appraisal_in"];
    JHMicWaitMode *model = [JHNimNotificationManager sharedManager].micWaitMode;
    if (model && model.isWait) {
        if(0)
        {
            ///正在申请连麦中 点击跳转到对应直播间
            [JHRootController EnterLiveRoom:model.waitChannelLocalId fromString:JHEventOnlineauthenticate];
        }
        else
        {
            [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(model.waitChannelLocalId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
                ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
                ///369神策埋点:鉴定直播入口
                [JHTracking trackEvent:@"identifyLiveEntranceClick" property:@{@"entrance_type":@"免费申请鉴定"}];
                NSString* httpPullUrl = channel.httpPullUrl;
                if([channel.status integerValue] != 2)
                {
                    httpPullUrl = nil;
                }
                NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:httpPullUrl];
                vc.channel=channel;
                vc.applyApprassal=NO;
                vc.coverUrl = channel.coverImg;
                vc.fromString = JHEventOnlineauthenticate;
                [self.tabBarController.navigationController pushViewController:vc animated:YES];
            } failureBlock:^(RequestModel *respondObject) {
            }];
        }
    }
    else {
        JHAnchorStyleViewController *vc = [[JHAnchorStyleViewController alloc] init];
        vc.fromSource = @"appraisePage";
        self.currentSelectIndex = 0;
        [self.navigationController pushViewController:vc animated:YES];
        [JHGrowingIO trackEventId:JHClickFreeAppraiseBtn];
    }
}

-(JHHomeHeaderView*)headerView {
    if (!_headerView) {
        _headerView = [[JHHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, kDefaultHeaderHeight)];
        _headerView.backgroundColor = HEXCOLOR(0xf5f5f8);
        @weakify(self);
        _headerView.selectedCell = ^(id obj){
            @strongify(self);
            NSInteger index = [obj integerValue];
            self.currentSelectIndex = index;
            //做判断
            JHLiveRoomMode *model = [self.channelData.channels objectAtIndex:index];
            self.sortIndex = index;
            //埋点
            [JHGrowingIO trackEventId:@"appraisal_tv_banner_in" variables:@{@"appraisal_tv_banner_in":model.anchorId}];
            if([model.canCustomize isEqualToString:@"1"]){
                //定制直播间跳定制主页
                JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                vc.roomId = model.roomId;
                vc.anchorId = model.anchorId;
                vc.channelLocalId = model.channelLocalId;
                vc.fromSource = JHLiveFromLiveRoom;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [self getLiveRoomDetail:model.ID isAppraisal:NO];
            }
            
            NSMutableDictionary *params2 = [NSMutableDictionary new];
            [params2 setValue:@"在线鉴定" forKey:@"page_position"];
            [params2 setValue:@(index) forKey:@"position_sort"];
            [params2 setValue:model.anchorId forKey:@"content_url"];
            [JHAllStatistics jh_allStatisticsWithEventId:@"bannerClick" params:params2 type:JHStatisticsTypeSensors];
        };
        _headerView.selectLiveBlock = ^{
            @strongify(self);
            [self enterArchorStylePage];
        };
        
        [_headerView.recycleView.reloadSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self requestRecycle:^{

            }];
        }];
        
    }
    return _headerView;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (showDefaultImage) {
         return  1;
    }
    return  self.postListData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHOnlineListCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (showDefaultImage) {
      JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        return defaultcell;
    }
    cell.postData = self.postListData[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
            return view;
        }
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
        return view;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 1) {
            JHOnlineTopicHeader *view = [_collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHOnlineTopicHeader class]) forIndexPath:indexPath];
            view.topicInfo = self.topicInfo;
            return view;
        }
        else {
            UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
            return view;
        }
    }
    return nil;
}

#pragma mark - WaterLayout
/// 返回`计算后的高`
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JHWaterfallFlowAlyout *)layout itemWidth:(CGFloat)width heightForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHPostDetailModel *model = self.postListData[indexPath.item];
    return [JHOnlineListCollectionCell heightCellWithModel:model];
}

/// 动态`块偏移`
- (UIEdgeInsets)collectionView:(JHWaterfallFlowAlyout *)collectionView
                        layout:(JHWaterfallFlowAlyout*)layout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

/// 动态`块头部高度`
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JHWaterfallFlowAlyout*)layout referenceHeightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return  headerSegmentHeight;
    }
    return CGFLOAT_MIN;
}

/// 动态`块尾部高度`
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(JHWaterfallFlowAlyout *)layout referenceHeightForFooterInSection:(NSInteger)section {
    if (section == 0) {
       return headerHeight;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 9.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 9.f;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
  //  [JHGrowingIO trackEventId:@"appraisal_video_in"];
    
    if (showDefaultImage) {
        return;
    }
    self.currentSelectIndex = indexPath.item;
    JHOnlineVideoDetailController *vc = [[JHOnlineVideoDetailController alloc] init];
    vc.delegate = self;
    vc.currentIndex = indexPath.item;
    vc.operationUserId = self.operationUserId;
    vc.postArray = self.postListData.copy;
    vc.isFollow = _isFollow;
    @weakify(self);
    vc.backBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        if (self.currentSelectIndex != currentIndex) {
            self.currentSelectIndex = currentIndex;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentSelectIndex inSection:1] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    };
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    JHPostDetailModel * model = self.postListData[indexPath.item];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_videos_click" params:@{@"video_id":model.item_id,@"appraisal_name":model.publisher.user_name,@"appraisal_id":model.publisher.user_id,@"from":@"appraisal"} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
}

- (void)requestMorePostData:(void (^)(NSArray<JHPostDetailModel *> * _Nullable))completateBlock {
    _lastDate = [[[self.postListData lastObject] last_date] isNotBlank] ? [[self.postListData lastObject] last_date] : @"0";
    [self getPostData:^(NSArray<JHPostDetailModel *> *postArray) {
        [self handleDataWithArr:postArray];
        if (completateBlock) {
            completateBlock(postArray);
        }
    }];
}

//MARK:UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![self isRefreshing]) {
        if (lastAnchourView) {
            CGRect rect = [lastAnchourView convertRect:lastAnchourView.bounds toView:self.view];
            if (rect.origin.y<UI.statusBarHeight||rect.origin.y+rect.size.height>ScreenH-UI.bottomSafeAreaHeight-49) {
                [self shutdown];
                lastAnchourView = nil;
            }
        }
    }
    
    ///移动渐变色view的位置
    CGFloat offsetY = scrollView.contentOffset.y;
    NSLog(@"offsetY:------ %f", offsetY);
    CGRect rect = self.gradient.frame;
    rect.origin.y = allHeaderHeight-offsetY;
    self.gradient.frame = rect;
    self.topicHeader.hidden = (offsetY <= allHeaderHeight);
    [JHHomeTabController changeStatusWithMainScrollView:self.collectionView index:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  pullStream];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![self isRefreshing]) {
        [self  pullStream];
    }
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }

}

-(BOOL)isRefreshing {
    if ([self.collectionView.mj_header isRefreshing]||self.collectionView.mj_header.state== MJRefreshStatePulling||[self.collectionView.mj_footer isRefreshing]||self.collectionView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}
-(void)pullStream {
    if (lastAnchourView) {
        CGRect rect = [lastAnchourView convertRect:lastAnchourView.bounds toView:self.view];
        if (rect.origin.y>=UI.statusBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
    JHHomeHeaderMainAnchorView * anchorView = [self.headerView getNearlyAnchorView];
    if (anchorView) {
        if (anchorView.liveRoomMode.ID!=lastAnchourView.liveRoomMode.ID&&
            [anchorView.liveRoomMode.status integerValue]==2&&!self.viewDisAppear) {
            JH_WEAK(self)
            [self startPlay:anchorView.liveRoomMode.rtmpPullUrl inView:anchorView.content andTimeEndBlock:^{
                JH_STRONG(self)
                [self shutdown];
                lastAnchourView=nil;
            }];
            lastAnchourView=anchorView;
        }
    }
}

-(void)getLiveRoomDetail:(NSString *)selectLiveRoomId isAppraisal:(BOOL)isAppraisal {
    if (self.disableClick) {
        return;
    }
    _disableClick = YES;
    [self shutdown];
    [self getDetail:selectLiveRoomId isAppraisal:isAppraisal];
}

-(void)getDetail:(NSString *)selectLiveRoomId isAppraisal:(BOOL)isAppraisal {
    //crash判空处理,目前逻辑,如果异常可以return
    if([NSString isEmpty:selectLiveRoomId])
        return;
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoomId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        channel.first_channel = @"appraise";
        //369神策埋点:鉴定直播入口点击
        [JHTracking trackEvent:@"identifyLiveEntranceClick" property:@{@"entrance_type":@"在线鉴定顶部列表", @"position_sort":@(self.sortIndex)}];
        ///369神策埋点:直播间入口点击
//        [JHTracking sa_clickLiveRoomList:channel pagePosition:@"在线鉴定顶部列表" currentIndex:@(self.sortIndex).stringValue];
        
        NSDictionary *dict2 = @{
            @"page_position":@"在线鉴定顶部列表",
            @"model_type":@"在线鉴定顶部列表",
            @"channel_status":[channel.status isEqualToString:@"2"]?@"是":@"否",
            @"channel_name":NONNULL_STR(channel.title),
            @"channel_label":@"无",
            @"anchor_id":NONNULL_STR(channel.anchorId),
            @"anchor_nick_name":NONNULL_STR(channel.anchorName),
            @"channel_local_id":NONNULL_STR(channel.channelLocalId)
        };
        [JHTracking trackEvent:@"channelClick" property:dict2];

        
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            vc.applyApprassal=isAppraisal;
            vc.coverUrl = channel.coverImg;
            self.currentSelectIndex=0;
            //TODO jiang
            vc.audienceUserRoleType = JHAudienceUserRoleTypeAppraise;
            vc.fromString = JHLiveFromhomeIdentify;

            NSMutableArray * channelArr=[self.channelData.channels mutableCopy];
            for (JHLiveRoomMode * mode in self.channelData.channels) {
                if ([mode.status integerValue]!=2) {
                    [channelArr removeObject:mode];
                }
            }
            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.ID isEqual:channel.channelLocalId]) {
                    self.currentSelectIndex=idx;
                    * stop=YES;
                }
            }];
            vc.currentSelectIndex=self.currentSelectIndex;
            vc.channeArr=channelArr;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  {
            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
            vc.pageFrom = JHPageFromAppraiseRoom;
            vc.anchorId=channel.anchorId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
            [MBProgressHUD  hideHUDForView:self.view animated:YES];
           _disableClick=NO;
        
    } failureBlock:^(RequestModel *respondObject) {
      
        _disableClick=NO;
        [MBProgressHUD  hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)tableBarSelect:(NSNotification*)note {
    
    BaseTabBarController * tablebar=(BaseTabBarController*)note.object;
    if ([self isRefreshing]){
        return;
    }
    if (tablebar.selectedIndex==3) {
        
            [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.collectionView.mj_header beginRefreshing];
                });
            });
    }
    else{
        [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}
#pragma mark -
#pragma mark - 打赏礼物相关 -

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!isLoadCacheDataComplete) {
        [self loadCacheData];
        isLoadCacheDataComplete = YES;
    }
    
    [self judgeWetherNeedShowGift];
    
    [JHAnniversaryBagView show];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.collectionView index:3];
}

- (void)judgeWetherNeedShowGift {
    ///显示礼物
    if (![JHRootController isLogin] &&
        [UserInfoRequestManager sharedInstance].anniversaryType == 1) {
        [JHUserDefaults setBool:NO forKey:kWetherGrantGiftKey];
        [JHUserDefaults synchronize];
        ///未登录
        if ([CommHelp isFirstTodayForName:kNewUserFirstGiftKey]) {
            ///第一次显示
            [self showGiftView];
        }
        return;
    }
    ///已登录 并且是今天第一次显示礼物
    if ([JHRootController isLogin] &&
        ![JHUserDefaults boolForKey:kWetherGrantGiftKey] &&
        ([CommHelp isFirstTodayForName:kNewUserFirstGiftKey] || ![JHUserDefaults boolForKey:kLoginedFirstGiftKey])) {
        [self judgeUserGift];
    }
}

///判断用户是否领取过红包
- (void)judgeUserGift {
    [[JHMaskingManager shareApiManager] getUserGiftInfo:^(BOOL isNeedGrant, NSString *message) {
        if (isNeedGrant) {
            [self showGiftView];
        }
    }];
}

///展示新人礼物弹窗
- (void)showGiftView {
    [JHMaskingManager showPopWindowWithType:JHMaskPopWindowTypeGift];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark -
#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}
- (UIScrollView *)listScrollView {
    return self.collectionView;
}
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)dealloc {
    NSLog(@"%s dealloc---- 🔥🔥🔥🔥🔥🔥.....", __func__);
}

@end

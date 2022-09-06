//
//  JHSQRcmdListController.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQRcmdListController.h"
#import "JHSQHelper.h"
#import "JHSQApiManager.h"
#import "JHSQRcmdPlateCell.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "JHSQPostADCell.h"
#import "JHSQPostTopicCell.h"
#import "JHSQPostLiveRoomCell.h"
#import "JHRecommendPlateTableCell.h"
#import "JHRecommendTopicTableCell.h"
#import "JHLivePlayerManager.h"
#import "JHRcmdNoticeTableCell.h"
#import "NTESGrowingInternalTextView.h"
#import "SourceMallApiManager.h"
#import "JHEasyInputTextView.h"

static NSInteger const kHeaderSection = 0;
static NSInteger const kPlateSection = 1;
static NSInteger const kNoticeSection = 2;
static NSInteger const kListSection = 3;

static NSString *const kOneSecondKey = @"刚刚";

#define SECTION_COUNT  4

#define WITHIN_ONESECOND  ([JHSQUploadManager shareInstance].isWithSecond)

@interface JHSQRcmdListController (){
     JHSQPostLiveRoomCell *lastCell;
}
//feed流<帖子>数据模型
@property (nonatomic, strong) JHSQModel *curModel;
//banner
@property (nonatomic, strong) JHSQBannerView *bannerView;
//banner数据
@property (nonatomic, strong) NSMutableArray<BannerCustomerModel *> *bannerList;
//版块数据
@property (nonatomic, strong) NSMutableArray<JHPlateListData *> *plateList;
///随机版块集合
@property (nonatomic, strong) NSArray <JHPlateListData *>*recommendPlateList;
///随机话题集合
@property (nonatomic, strong) NSArray <JHTopicInfo *>*recommendTopicList;

//帖子上传
@property (nonatomic, strong) JHSQUploadView *uploadView;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;
///公告数据
@property (nonatomic, copy) NSArray *noticeInfos;
///为宝友把关数量
@property(nonatomic,strong)NSString *orderCount;
///是否在当前页面发布的帖子
@property (nonatomic, assign) BOOL publishInCurrent;
///标记是否处理过添加话题逻辑
@property (nonatomic, assign) BOOL needConfirmTopic;

/// 更新了多少条数据
@property (nonatomic, weak) UILabel *updateTipsLabel;

/// 当前头部状态
@property (nonatomic, assign) BOOL upOnce;
@end

@implementation JHSQRcmdListController

#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _publishInCurrent = YES;
    _needConfirmTopic = YES;
    _curModel = [[JHSQModel alloc] init];
    _bannerList = [NSMutableArray array];
    _plateList = [NSMutableArray array];
    
    [self configTableView];
        
    [self refresh];
    
    [self registerPlayer];
    
    [self addObserver];
    
    [self addTableViewScrollObserver]
    ;
    //用户画像浏览时长:begin
    if(![JHUserStatistics hasResumeBrowseEvent])
    {
        [JHUserStatistics noteEventType:kUPEventTypeCommunityRecommendBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
    }
    
    _updateTipsLabel = [UILabel jh_labelWithFont:12 textColor:RGB(255, 106, 0) textAlignment:1 addToSuperView:self.view];
    _updateTipsLabel.backgroundColor = RGB(255, 244, 217);
    [_updateTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(27);
        make.top.equalTo(self.view).offset(-27);
    }];
}

- (void)addTableViewScrollObserver{
    @weakify(self);
    [RACObserve(self.tableView, contentOffset) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGPoint offset = [x CGPointValue];
        CGFloat scrollY = offset.y;
        //向上临界一次
        if (!self.upOnce && scrollY>30) {
            self.upOnce = YES;
            if (self.headScrollBlock) {
                self.headScrollBlock(YES);
            }
        }
        //向下临界一次
        if (self.upOnce && scrollY<=0) {
            self.upOnce = NO;
            if (self.headScrollBlock) {
                self.headScrollBlock(NO);
            }
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.upOnce = [[NSUserDefaults standardUserDefaults] boolForKey:@"HeadSearchStatus"];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    ///获取新发布的帖子内容
//    if ([JHSQUploadManager shareInstance].localPostInfo) {
//        [self resolvePostInfo];
//    }
    //页面出现在拉流
     [self beginPullStream];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:0];
}

///处理本地帖子展示的逻辑
- (void)resolvePostInfo {
    _publishInCurrent = NO;
    [JHSQUploadManager updatePostInfoPublishedByNow:^{
        JHPostData *data = [JHSQUploadManager shareInstance].localPostInfo;
        if (data) {
            BOOL isWithSecond = [data.publish_time isEqualToString:kOneSecondKey];
            [JHSQUploadManager shareInstance].isWithSecond = isWithSecond;
            
            BOOL needAdd = YES;
            for (int i = 0; i < _curModel.list.count; i ++) {
                JHPostData *model = _curModel.list[i];
                if ([data.item_id isEqualToString:model.item_id]) {
                    [_curModel.list replaceObjectAtIndex:i withObject:data];
                    needAdd = NO;
                }
            }
            if (needAdd) {
                if (isWithSecond) {
                    ///在一分钟内
                    if (_curModel.list.count > 0) {
                        [_curModel.list insertObject:data atIndex:0];
                    }
                    else {
                        [_curModel.list addObject:data];
                    }
                }
                else {
                    ///不在一分钟内
                    if (needAdd) {
                        [_curModel.list addObject:data];
                    }
                }
            }
            
            [self.tableView reloadData];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    NSString *IDS = @"";
    for (NSString *ids in self.idsDic.allKeys) {
        if(IDS.length > 0)
        {
            IDS = [NSString stringWithFormat:@"%@,%@",IDS,ids];
        }
        else
        {
            IDS = ids;
        }
    }
    if(IDS.length > 0)
    {
        [[JHBuryPointOperator shareInstance] buryWithEtype:@"communityRecommendBrowse" param:@{@"browse_id" : IDS}];
    }
    
    [self.idsDic removeAllObjects];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //页面消失  销毁拉流
    [self shutdownPlayStream];
}

#pragma mark -
#pragma mark - Observer
- (void)addObserver {
    @weakify(self);
    //静音开关通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kMuteStateChangedNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self setIsVideoMute:[JHSQManager isMute]];
    }];
    
    [[[JHNotificationCenter rac_addObserverForName:kUpdateSQRecommendDataNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        ///这个因为是在推荐页面发布帖子的通知 所以是刚刚发布的帖子
        self.publishInCurrent = YES;
        [self resolvePostInfo];
        [self.tableView reloadData];
    }];
}

#pragma mark - player
- (void)registerPlayer {
    
    @weakify(self);
    [self initPlayerWithListView:self.tableView controlView:[JHBaseControlView new]];
    ///让视频自适应
    self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
    self.section = kListSection; ///这块如果设置不对的话 会导致视频不会自动播放
    
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.curModel.list[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromSQHomeFeedList
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];

        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromSQHomeFeedList scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self);
        JHPostData *data = self.curModel.list[indexPath.row];
        return data.video_info.coverImage;
    };
}

#pragma mark
#pragma mark - UI Methods

- (void)configTableView {
    NSArray *cellNames = @[NSStringFromClass([JHSQRcmdPlateCell class]),
                           NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([JHSQPostADCell class]),
                           NSStringFromClass([JHSQPostTopicCell class]),
                           NSStringFromClass([JHSQPostLiveRoomCell class]),
                           NSStringFromClass([YDBaseTableViewCell class]),
                           NSStringFromClass([JHRcmdNoticeTableCell class]),
                           NSStringFromClass([JHRecommendPlateTableCell class]),
                           NSStringFromClass([JHRecommendTopicTableCell class])];
    [JHSQHelper configTableView:self.tableView cells:cellNames];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
}

#pragma mark -
#pragma mark - 显示上传帖子进度

- (void)showUploadProgress {
    if([JHSQUploadView show] && !_uploadView)
    {
        JHSQUploadView *view = [JHSQUploadView new];
        [self.view addSubview: view];
        _uploadView = view;
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(140);
            make.top.equalTo(self.view).offset(5);
        }];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.sd_resetLayout
            .topSpaceToView(self.uploadView, 0)
            .leftEqualToView(self.view)
            .rightEqualToView(self.view)
            .bottomSpaceToView(self.view, 0);
        }];
        
        @weakify(self);
        view.deleteViewBlock = ^{
            @strongify(self);
            [self.uploadView removeFromSuperview];
            self.uploadView = nil;
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.sd_resetLayout.spaceToSuperView(UIEdgeInsetsZero);
            }];
        };
    }
    if(_uploadView)
    {
        [JHSQUploadManager reload];
    }
}

#pragma mark -
#pragma mark - 网络请求
///更新刚刚发布的帖子的数据
- (void)updatePostDataPublishJustNow:(dispatch_block_t)block {
    [JHSQUploadManager updatePostInfoPublishedByNow:^{
        if (block) {
            block();
        }
    }];
}

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    self.needConfirmTopic = YES;
    _curModel.willLoadMore = NO;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    ///更新刚才发布的帖子的数据
    if ([JHSQUploadManager shareInstance].localPostInfo) {
        dispatch_group_enter(group);
        [self updatePostDataPublishJustNow:^{
            dispatch_group_leave(group);
        }];
    }
    ///获取banner数据
    [self getBannerList:^{
        dispatch_group_leave(group);
    }];
    ///获取板块数据
    [self getPlateList:^{
        dispatch_group_leave(group);
    }];
    ///获取公告栏数据
    [self getNoticeList:^{
        dispatch_group_leave(group);
    }];
    ///获取为宝友把关数量
    [self requestOrderCount:^{
        dispatch_group_leave(group);
    }];
    ///获取帖子列表数据
    [self getPostList:^{
        dispatch_group_leave(group);
    }];
    ///获取推荐版块数据
    [self getRecommendPlateList:^{
        dispatch_group_leave(group);
    }];
    ///获取随机话题列表数据
    [self getRecommendTopicList:^{
        dispatch_group_leave(group);
    }];
        
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        ///添加随机版块
        [self addRandomPlateData];
        ///添加随机话题
        [self addRandomTopicData];
        
        ///本地刚发布的帖子
        if ([JHSQUploadManager shareInstance].localPostInfo) {
            ///如果刚发布的帖子不为空
            self.publishInCurrent = NO;
            [JHSQUploadManager shareInstance].isWithSecond = NO;
            [_curModel.list addObject:[JHSQUploadManager shareInstance].localPostInfo];
        }
        [self.tableView reloadData];
    });
    
    ///用户画像埋点- 社区首页进入事件
    [JHUserStatistics noteEventType:kUPEventTypeCommunityHomeEntrance params:nil];
}

/// 改为接口控制
- (void)getRecommendPlateList:(dispatch_block_t)block {
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/v1/channel/recommend") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if(IS_ARRAY(respondObject.data)) {
            self.recommendPlateList = [JHPlateListData mj_objectArrayWithKeyValuesArray:respondObject.data];
        }
        if (block) {
            block();
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block();
        }
    }];
}

///获取热门话题列表
- (void)getRecommendTopicList:(dispatch_block_t)block {
    @weakify(self);
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/topic/recommend") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        if(IS_ARRAY(respondObject.data)) {
            self.recommendTopicList = [JHTopicInfo mj_objectArrayWithKeyValuesArray:respondObject.data];
        }
        if (block) {
            block();
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block();
        }
    }];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    @weakify(self);
    [self getPostList:^{
        @strongify(self);
        ///判断是否需要添加话题模块
        if (self.needConfirmTopic) {
            [self addRandomTopicData];
        }
        self.playVideoUrls = self.curModel.videoUrls;
        [self.tableView reloadData];
    }];
}

//获取广告数据
- (void)getBannerList:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getBannerList:^(NSArray<BannerCustomerModel *> * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        self.bannerList = respObj.mutableCopy;
        if (block) {
            block();
        }
    }];
}

//获取版块数据
- (void)getPlateList:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getPlateList:^(NSArray<JHPlateListData *> * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            self.plateList = respObj.mutableCopy;
        }
        if (block) {
            block();
        }
    }];
}

- (void)getNoticeList:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getNoticeList:^(NSArray<BannerCustomerModel *> * _Nullable noticeArray, BOOL hasError) {
        @strongify(self);
        self.noticeInfos = noticeArray;
        if (block) {
            block();
        }
    }];
}

/// 获取为宝友把关数量
- (void)requestOrderCount:(dispatch_block_t)block {
    [SourceMallApiManager requestOrderCountBlock:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.orderCount = respondObject.data;
        }
        if (block) {
            block();
        }
    }];
}

//获取主列表数据
- (void)getPostList:(dispatch_block_t)block {
    @weakify(self);
    [JHSQApiManager getPostList:_curModel block:^(JHSQModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        if (respObj) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
                [self.curModel configModel:respObj];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.playVideoUrls = self.curModel.videoUrls;
                    if(_curModel.page == 1) {
                        [self showUpdateCountAnimalWithCount:self.curModel.list.count];
                    }
                    if (block) {
                        block();
                    }
                });
            });
        }
        else {
            if (block) {
                block();
            }
        }
    }];
}

- (void)showUpdateCountAnimalWithCount:(NSInteger)count {
    static BOOL show = NO;
    if(show) {
        self.updateTipsLabel.text = [NSString stringWithFormat:@"为您推荐了%@条新内容",@(count)];
        [UIView animateWithDuration:0.3 animations:^{
            [self.updateTipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(-0);
            }];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.updateTipsLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).offset(-27);
                }];
                [self.view layoutIfNeeded];
            } completion:nil];
        }];
    }
    show = YES;
}

#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kPlateSection) {
        return (_plateList.count > 0 ? 1 : 0);
    }
    if (section == kNoticeSection) {///公告
        return self.noticeInfos.count;
    }
    if (section == kListSection) {
        return _curModel.list.count;
    }
//    if (section == kHeaderSection && (self.publishInCurrent || WITHIN_ONESECOND)) {
//        return 1;
//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, .1)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    ///主要是为了显示banner位置
    if (section == kHeaderSection) {
        return self.bannerList.count > 0
        ? [JHSQBannerView bannerHeight]
        : .1f;
    }
    if (section == kPlateSection) {
        return (_plateList.count > 0 ? 10 : .1f);
    }
    if (section == kNoticeSection) {
        return self.noticeInfos.count > 0 ? 10.f : .1f;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == kHeaderSection) {
        self.bannerView.bannerList = self.bannerList;
        return self.bannerView;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    footer.backgroundColor = kColorF5F6FA;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kPlateSection) {
        return [JHSQRcmdPlateCell cellHeight];
    }
    if (indexPath.section == kNoticeSection) {
        return 40.f;
    }
    else {
//        JHPostData *data = (indexPath.section == kHeaderSection && (self.publishInCurrent || WITHIN_ONESECOND))
//        ? [JHSQUploadManager shareInstance].localPostInfo
//        : _curModel.list[indexPath.row];
        
        JHPostData *data = _curModel.list[indexPath.row];
        if (data.item_type == JHPostItemTypeRandomPlate) {///随机版块集合
            return [JHRecommendPlateTableCell cellHeight];
        }
        if (data.item_type == JHPostItemTypeRandomTopic) {///随机话题集合
            return [JHRecommendTopicTableCell cellHeight];
        }
        
        Class curClass = [JHSQHelper cellClassWithItemType:data.item_type];
        if (curClass) {
            return [self.tableView cellHeightForIndexPath:indexPath
                                                    model:data
                                                  keyPath:@"postData"
                                                cellClass:curClass
                                         contentViewWidth:kScreenWidth];
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kPlateSection) {
        JHSQRcmdPlateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQRcmdPlateCell class]) forIndexPath:indexPath];
        cell.pageType = self.pageType;
        cell.plateList = _plateList;
        return cell;
        
    }
    if (indexPath.section == kNoticeSection) {
        ///公告栏
        BannerCustomerModel *notice = self.noticeInfos[indexPath.row];
        JHRcmdNoticeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRcmdNoticeTableCell class]) forIndexPath:indexPath];
        cell.noticeInfo = notice;
        cell.showLine = !(indexPath.row == self.noticeInfos.count-1) ? YES : NO;
        return cell;
    }
    else {
//        JHPostData *data = (indexPath.section == kHeaderSection && (self.publishInCurrent || WITHIN_ONESECOND))
//        ? [JHSQUploadManager shareInstance].localPostInfo
//        : _curModel.list[indexPath.row];
        JHPostData *data = _curModel.list[indexPath.row];
        switch (data.item_type) {
            case JHPostItemTypePost: { //帖子
                JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
                cell.pageType = JHPageTypeSQHome;
                cell.postData = data;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                @weakify(self);
                cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                    @strongify(self);
                    JHOperationType operationType = [obj intValue];
                    [self operationComplete:operationType withData:data];
                };
                return cell;
            }
            case JHPostItemTypeDynamic: { //动态
                JHSQPostDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostDynamicCell class]) forIndexPath:indexPath];
                cell.pageType = JHPageTypeSQHome;
                cell.indexPath = indexPath;
                cell.postData = data;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                
                @weakify(self);
                cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                    @strongify(self);
                    JHOperationType operationType = [obj intValue];
                    [self operationComplete:operationType withData:data];
                };
                
                cell.inputBarClickedBlock = ^(NSIndexPath * _Nonnull indexPath, JHPostData * _Nonnull data) {
                    @strongify(self);
                    self.toCommentIndexPath = indexPath;
                    [self showInputTextView];
                };
                return cell;
            }
            case JHPostItemTypeAppraisalVideo:
            case JHPostItemTypeVideo: { //短视频
                JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
                cell.pageType = JHPageTypeSQHome;
                cell.indexPath = indexPath;
                cell.postData = data;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                @weakify(self);
                cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                    @strongify(self);
                    JHOperationType operationType = [obj intValue];
                    [self operationComplete:operationType withData:data];
                };
                return cell;
            }
            case JHPostItemTypeAD: { //广告
                JHSQPostADCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostADCell class]) forIndexPath:indexPath];
                cell.postData = data;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                return cell;
            }
            case JHPostItemTypeTopic: { //话题
                JHSQPostTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostTopicCell class]) forIndexPath:indexPath];
                cell.postData = data;
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                return cell;
            }
            case JHPostItemTypeLiveRoom: { //直播间
                JHSQPostLiveRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostLiveRoomCell class]) forIndexPath:indexPath];
                cell.orderCount = self.orderCount;
                cell.indexPath = indexPath;
                cell.postData = data;
                @weakify(self);
                cell.operationAction = ^(NSNumber *obj, JHPostData *data) {
                    @strongify(self);
                    JHOperationType operationType = [obj intValue];
                    [self operationComplete:operationType withData:data];
                };
                [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
                return cell;
            }
            case JHPostItemTypeRandomPlate: {///随机版块集合
                JHRecommendPlateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecommendPlateTableCell class]) forIndexPath:indexPath];
                cell.plateInfos = self.recommendPlateList;
                return cell;
            }
            case JHPostItemTypeRandomTopic: {///随机话题集合
                JHRecommendTopicTableCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHRecommendTopicTableCell class]) forIndexPath:indexPath];
                cell.topicArray = self.recommendTopicList;
                @weakify(self);
                cell.changeBlock = ^{
                    @strongify(self);
                    [self changeRecommendData];
                };
                return cell;
            }
            default: {
                YDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDBaseTableViewCell class]) forIndexPath:indexPath];
                return cell;
            }
        }
    }
}

- (void)changeRecommendData {
    @weakify(self);
    [self getRecommendTopicList:^{
        @strongify(self);
        [self.tableView reloadData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kNoticeSection) {
        [JHGrowingIO trackEventId:@"recommend_Notice_enter"];
        ///公告栏点击事件
        BannerCustomerModel *model = self.noticeInfos[indexPath.row];
        [JHRootController toNativeVC:model.target.componentName withParam:model.target.params from:JHFromSQHomeFeedList];
    }
}

#pragma mark -
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType withData:(JHPostData*)data {
    
    if (operationType==JHOperationTypeColloct||
        operationType==JHOperationTypeCancleColloct) {
        data.is_collect=!data.is_collect;
    }
    if (operationType==JHOperationTypeSetGood||
        operationType==JHOperationTypeCancleSetGood) {
        data.content_level=data.content_level==1?0:1;
    }
    if (operationType==JHOperationTypeSetTop||
        operationType==JHOperationTypeCancleSetTop) {
        data.content_style=data.content_style==2?0:2;
    }
    if (operationType==JHOperationTypeNoice||
        operationType==JHOperationTypeCancleNotice) {
        data.content_style=data.content_style==3?0:3;
    }
    if (operationType==JHOperationTypeDelete) {
        [self.curModel.list removeObject:data];
        [self.tableView reloadData];
    }
}

#pragma mark -
#pragma mark - 评论输入框相关
- (void)showInputTextView {
    JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:200 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
    easyView.showLimitNum = YES;
    [JHKeyWindow addSubview:easyView];
    [easyView show];
    @weakify(easyView);
    [easyView toPublish:^(NSDictionary * _Nonnull inputInfos) {
        @strongify(easyView);
        [easyView endEditing:YES];
        [self didSendText:inputInfos];
    }];
}

- (void)didSendText:(NSDictionary *)commentInfos {
    if ([JHSQManager needLogin]) {
        return;
    }
    JHPostData *data = _curModel.list[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            data.comment_num++;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - pull stream
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  beginPullStream];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [super scrollViewDidEndDecelerating:scrollView];
    if (![self isRefreshing]) {
        [self  beginPullStream];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self isBeyondArea:scrollView];
    
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:0];
}
- (void)isBeyondArea:(UIScrollView *)scrollView {
    if (![self isRefreshing]&&lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight||rect.origin.y+rect.size.height>ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell=nil;
        }
    }
}
- (void)shutdownPlayStream {
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell=nil;
}
- (void)beginPullStream {
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
//    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
//        return;
//    }
      NSArray* cellArr = [self.tableView visibleCells];
      for(id obj in cellArr)
      {
        if([obj isKindOfClass:[JHSQPostLiveRoomCell class]])
        {
            JHSQPostLiveRoomCell *cell = (JHSQPostLiveRoomCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            if (rect.origin.y >= UI.statusAndNavBarHeight &&
                rect.origin.y + rect.size.height <= ScreenH - UI.bottomSafeAreaHeight-49)
            {
                JHPostData *model = cell.postData;
                if([model.rtmp_pull_url length] > 0)
                {
                    @weakify(self);
                [[JHLivePlayerManager sharedInstance] startPlay:model.rtmp_pull_url inView:cell.stearmView andTimeEndBlock:^{
                    @strongify(self);
                  [self shutdownPlayStream];
                }];
                lastCell=cell;
            break;
           }
        }
     }
  }
}

#pragma mark -
#pragma mark - lazy loading

- (JHSQBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [JHSQHelper bannerView];
        _bannerView.backgroundColor = kColorF5F6FA;
        _bannerView.type = JHBannerAdTypeCommunity;
        _bannerView.growingClickBlock = ^{
            [JHGrowingIO trackEventId:@"community_banner_enter"];
        };
    }
    return _bannerView;
}

/// 曝光帖子ID集合
-(NSMutableDictionary *)idsDic {
    if(!_idsDic)
    {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(indexPath.section == kListSection)
    {
        JHPostData *data = _curModel.list[indexPath.row];
        if(data.item_type == JHPostItemTypeAppraisalVideo || data.item_type == JHPostItemTypeTopic || data.item_type == JHPostItemTypeDynamic || data.item_type == JHPostItemTypePost || data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeLocalPost)
        {
            if(data.item_id)
            {
                [self.idsDic setObject:data.item_id forKey:data.item_id];
            }
        }
    }
}

#pragma mark -
#pragma mark - 单独将版块和话题的数据处理拎出来
- (void)addRandomPlateData {
    ///添加版块
    ///第一次可能小于 5
    NSInteger plateIndex = self.curModel.list.count > 5 ? 5 : self.curModel.list.count;
    BOOL hasPlate = [self hasRandomData:JHPostItemTypeRandomPlate];
    if (!hasPlate) {
        ///在第五个帖子下需要显示随机板块
        JHPostData *data = [[JHPostData alloc] init];
        data.item_type = JHPostItemTypeRandomPlate;
        if (plateIndex < 5) {
            [self.curModel.list addObject:data];
            [self.curModel.videoUrls addObject:[NSURL URLWithString:@""]];
        }
        else {
            [self.curModel.list insertObject:data atIndex:plateIndex];
            [self.curModel.videoUrls insertObject:[NSURL URLWithString:@""] atIndex:plateIndex];
        }
        self.playVideoUrls = self.curModel.videoUrls.copy;
    }
}

- (void)addRandomTopicData {
    if (self.recommendTopicList.count == 0) {
        return;
    }
    ///添加话题
    ///第一次可能小于 10
    if (self.curModel.list.count > 10) {
        NSInteger topicIndex = 11;
        BOOL hasTopic = [self hasRandomData:JHPostItemTypeRandomTopic];
        if (!hasTopic) {
            self.needConfirmTopic = NO;
            ///在第五个帖子下需要显示随机板块
            JHPostData *data = [[JHPostData alloc] init];
            data.item_type = JHPostItemTypeRandomTopic;
            if (self.curModel.list.count > 11) {
                [self.curModel.list insertObject:data atIndex:topicIndex];
                [self.curModel.videoUrls insertObject:[NSURL URLWithString:@""] atIndex:topicIndex];
            }
            else {
                [self.curModel.list addObject:data];
                [self.curModel.videoUrls addObject:[NSURL URLWithString:@""]];
            }
            self.playVideoUrls = self.curModel.videoUrls.copy;
        }
    }
}

- (BOOL)hasRandomData:(JHPostItemType)type {
    BOOL hasRandom = NO;
    for (JHPostData *data in self.curModel.list) {
        if (data.item_type == type) {
            hasRandom = YES;
            break;
        }
    }
    return hasRandom;
}

@end

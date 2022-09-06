//
//  JHUserInfoPostController.m
//  TTjianbao
//
//  Created by lihui on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoPostController.h"
#import "JHCommentListTableViewCell.h"
#import "JHBlankPostTableViewCell.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "UIView+Blank.h"
#import "CommAlertView.h"
#import "JHCollectionView.h"
#import "JHCollectionItemModel.h"
#import "JHPubTopicViewController.h"
#import "NTESGrowingInternalTextView.h"
#import "JHEasyInputTextView.h"
#import "JHMyUserInfoDraftHeader.h"

@interface JHUserInfoPostController () <UITableViewDelegate, UITableViewDataSource, JHDetailCollectionDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray<JHPostData *> *postArray;
@property (nonatomic, strong) NSMutableArray<NSURL *> *videoUrlArray; //所有视频url
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger lastId;
///是否是第一次请求
@property (nonatomic, assign) BOOL isFirstRequst, isLoading;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论
/** 顶部菜单栏*/
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) JHCollectionView *collectionView;
@property (nonatomic, strong) NSArray *collectionArray;

/// 草稿View
@property (nonatomic, strong) JHMyUserInfoDraftHeader *draftView;

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

@end

@implementation JHUserInfoPostController

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstRequst = YES;
        _isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    _lastId = 0;
    [self createTableView];
    [self refreshData];
    [self registerPlayer];
    [self addObserver];
    if (self.infoType == JHPersonalInfoTypePublish) {
        [self loadUserPubTopicData];
    }
}

/** 请求个人发布的标签列表*/
- (void)loadUserPubTopicData {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/pubTopic/%@"), self.userId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        self.collectionArray = [JHCollectionItemModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        [self.collectionView updateData:self.collectionArray];
        [self updateTableHeader];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self updateTableHeader];
    }];
}

- (void)updateTableHeader {
    CGFloat height = 0.f;
    self.draftView.hidden = YES;
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *userId = user.customerId;
    NSString *otherUserId = OBJ_TO_STRING(self.userId);
    
    if([JHMyUserInfoDraftHeader isShowDraft] && [userId isEqualToString:otherUserId]) {
        height += 105;
        self.draftView.hidden = NO;
    }
    if (self.collectionArray.count > 0){
        height += 40;
    }
    [self.draftView refresh];
    self.contentTableView.tableHeaderView.height = height;
    [self reloadMethod];
}

#pragma mark -
- (void)clickCollectionItem:(id)item {
    JHCollectionItemModel *itemModel = (JHCollectionItemModel *)item;
    JHPubTopicViewController *pubTopicVc = [[JHPubTopicViewController alloc] init];
    pubTopicVc.itemId = itemModel.itemId;
    pubTopicVc.titleString = itemModel.title;
    pubTopicVc.userId = self.userId;
    [self.navigationController pushViewController:pubTopicVc animated:YES];
}
#pragma mark - Observer
- (void)addObserver {
    @weakify(self);
    //静音开关通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kMuteStateChangedNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self setIsVideoMute:[JHSQManager isMute]];
    }];
    //点赞通知
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:kUpdateUserCenterInfoNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        [self updateLikeListData:notification];
    }];
}

#pragma mark - player
- (void)registerPlayer {
    @weakify(self);
    [self initPlayerWithListView:self.contentTableView controlView:[JHBaseControlView new]];
    self.section = 0;
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.postArray[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromUserInfo
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromUserInfo scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        return self.postArray[indexPath.row].video_info.coverImage;
    };
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.backgroundColor = kColorF5F6FA;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [UIView new];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentTableView = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([YDBaseTableViewCell class]),
                           NSStringFromClass([JHBlankPostTableViewCell class])];
    [JHSQHelper configTableView:_contentTableView cells:cellNames];
    table.backgroundColor = kColorF5F6FA;

    @weakify(self);    
    table.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    
    if (self.infoType == JHPersonalInfoTypePublish) {
        table.tableHeaderView = self.headerView;
    }
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _headerView.clipsToBounds = YES;
        _headerView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:self.collectionView];
        if(self.infoType == JHPersonalInfoTypePublish) {
            [_headerView addSubview:self.draftView];
            [self.draftView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
                make.bottom.left.right.equalTo(self.headerView);
            }];
        }
    }
    return _headerView;
}

- (JHCollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[JHCollectionView alloc] initWithFrame:CGRectMake(15, 0, self.headerView.width - 30, 40) type:JHDetailCollectionCellTypeImageTextScroll];
        _collectionView.delegate = self;
        [_collectionView makeLayout:CGSizeMake(67, 24) lineSpace:10 itemSpace:10];
    }
    return _collectionView;
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (void)deleteArticle:(NSInteger)index {
    JHPostData *data = self.postArray[index];
    [JHSQApiManager deleteRequestAsAuthor:data reasonId:nil block:^(id  _Nullable respObj, BOOL hasError) {
        [UITipView showTipStr:@"帖子删除成功"];
    }];
}

- (void)cancelLike:(NSInteger)index {
    JHPostData *data = self.postArray[index];
    [JHSQApiManager sendUnLikeRequest:data block:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            [self.postArray removeObject:data];
            [self reloadMethod];
            [JHNotificationCenter postNotificationName:kUpdateUserCenterInfoNotification object:@{@"likeNum":@(-1)}];
        }
        else {
            [UITipView showTipStr:respObj.message?:@"删除失败"];
        }
    }];
}

- (void)toDeletePost:(NSInteger)index {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"确认要删除吗？" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        if (self.infoType == JHPersonalInfoTypePublish) {
            ///发过 点击删除应该调用删除帖子的接口
            [self deleteArticle:index];
        }
        else if (self.infoType == JHPersonalInfoTypeLike) {
            [self cancelLike:index];
        }
    };
    
    alert.cancleHandle = ^{

    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.postArray[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        JHBlankPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBlankPostTableViewCell class]) forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.postData = data;
        @weakify(self);
        cell.deleteBlock = ^(NSInteger index) {
            @strongify(self);
            [self toDeletePost:index];
        };
        return cell;
    }
    
    switch (data.item_type) {
        case JHPostItemTypePost: {
            JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
            cell.pageType = (_infoType == JHPersonalInfoTypeLike ? JHPageTypeUserInfoLikeTab : JHPageTypeUserInfoPublishTab);
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
        case JHPostItemTypeDynamic: {
            JHSQPostDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostDynamicCell class]) forIndexPath:indexPath];
            cell.pageType = (_infoType == JHPersonalInfoTypeLike ? JHPageTypeUserInfoLikeTab : JHPageTypeUserInfoPublishTab);
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
        case JHPostItemTypeVideo:
        {
            JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
            cell.pageType = (_infoType == JHPersonalInfoTypeLike ? JHPageTypeUserInfoLikeTab : JHPageTypeUserInfoPublishTab);
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
        default: {
            YDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YDBaseTableViewCell class]) forIndexPath:indexPath];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.postArray[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        CGFloat height = data.is_self ?  137.f : 104.f;
        return height;
    }
    
    Class curClass = [JHSQHelper cellClassWithItemType:data.item_type];
    if (curClass) {
        return [self.contentTableView cellHeightForIndexPath:indexPath
                                                model:data
                                              keyPath:@"postData"
                                            cellClass:curClass
                                     contentViewWidth:kScreenWidth];
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


///刷新数据  主播id
- (void)refreshData:(NSString *)archorId {
    self.userId = archorId;
    _isFirstRequst = NO;
    self.page = 1;
    [self loadData:YES];
}

#pragma mark -
#pragma mark - Data

- (void)refreshData {
    if (!_isFirstRequst) {
        return;
    }
    _isFirstRequst = NO;
    _isLoading = YES;
    self.page = 1;
    [self loadData:YES];
}

- (void)loadMoreData {
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    self.page ++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {
    @weakify(self);
    [JHUserInfoApiManager getUserHistory:self.infoType UserId:self.userId Page:self.page LastId:@(self.lastId).stringValue CompleteBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                RequestModel *respondObject = respObj;
                NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respondObject.data[@"content_list"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.isLoading = NO;
                    self.lastId = [respondObject.data[@"last_id"] integerValue];
                    if (list.count > 0) {
                        [self.contentTableView.mj_footer endRefreshing];
                        [self configDataList:list]; //配置数据
                        [self reloadMethod];
                    }
                    else {
                        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    ///展示暂无数据的page
                    [self showBlankView:self.postArray.count];
                });
            });
        }
        else {
            ///展示暂无数据的pagez
            [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
            [self showBlankView:self.postArray.count];
        }
    }];
}

- (void)configDataList:(NSArray<JHPostData *> *)dataList {
    if (dataList.count <= 0) {
        return;
    }
    NSMutableArray<JHPostData *> *postList = [NSMutableArray new];
    NSMutableArray<NSURL *> *urlList = [NSMutableArray new];
    
    for (JHPostData *data in dataList) {
        if (!(self.infoType == JHPersonalInfoTypePublish &&
             data.show_status == JHPostDataShowStatusDelete)) {
            //配置帖子内容
            BOOL isNormal = data.item_type == JHPostItemTypePost;
            //动态&短视频内容为空时，赋默认值
            if (data.item_type == JHPostItemTypeDynamic ||
                data.item_type == JHPostItemTypeVideo ||
                data.item_type == JHPostItemTypeAppraisalVideo) {
                if (![data.content isNotBlank]) {
                    data.content = @"分享内容";
                }
            }
            [data configPostContent:data.content isNormal:isNormal];
            
            [postList addObject:data];
            
            //配置视频url
            if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
                [urlList addObject:[NSURL URLWithString:data.video_info.url]];
            } else {
                [urlList addObject:[NSURL URLWithString:@""]];
            }
        }
    }
    
    [self.postArray addObjectsFromArray:postList];
    [self.videoUrlArray addObjectsFromArray:urlList];
    self.playVideoUrls = self.videoUrlArray;
}

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self.view];
    }
}

#pragma mark -
#pragma mark - 分页逻辑

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate

- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.contentTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

#pragma mark -
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType withData:(JHPostData*)data{
    
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
        [self.postArray removeObject:data];
        [self reloadMethod];
    }
}

- (void)updateLikeListData:(NSNotification *)notification {
    if (![JHSQManager isAccount:self.userId] ||
        self.infoType != JHPersonalInfoTypeLike) {
        return;
    }
    
    NSDictionary *info = notification.object;
    JHPostData *data = info[@"postInfo"];
    if (!data) {
        return;
    }
    
    [self.postArray removeObject:data];
    [self reloadMethod];
}

- (void)reloadMethod {
    if(self.infoType == JHPersonalInfoTypePublish) {
        if(self.postArray && self.postArray.count > 0) {
            self.draftView.backgroundColor = UIColor.whiteColor;
        }
        else {
            self.draftView.backgroundColor = kColorF5F6FA;;
        }
    }
    [self.contentTableView reloadData];
}

#pragma mark -
#pragma mark - 评论输入框相关

- (void)showInputTextView {
    JHEasyInputTextView *easyView = [[JHEasyInputTextView alloc] initInputTextViewWithFontSize:[UIFont fontWithName:kFontNormal size:13.f] limitNum:10000 inputBackgroundColor:kColorF5F6FA maxNumbersOfLine:3 currentViewController:NSStringFromClass([JHRootController.currentViewController class])];
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
    JHPostData *data = self.postArray[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            data.comment_num++;
            [self reloadMethod];
        }
    }];
}

///有时候传进来的不是字符串 导致 isEqualToString  crash
- (void)setUserId:(NSString *)userId
{
    if(!IS_STRING(userId))
    {
        userId = [NSString stringWithFormat:@"%@",userId];
    }
    _userId = userId;
}

- (NSMutableArray<JHPostData *> *)postArray {
    if (!_postArray) {
        _postArray = [NSMutableArray new];
    }
    return _postArray;
}

- (NSMutableArray<NSURL *> *)videoUrlArray {
    if (!_videoUrlArray) {
        _videoUrlArray = [NSMutableArray new];
    }
    return _videoUrlArray;
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
    JHPostData *data = self.postArray[indexPath.row];
    if(data && data.item_id)
    {
        [self.idsDic setObject:data.item_id forKey:data.item_id];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
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
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:self.userId forKey:@"userId"];
        [params setValue:IDS forKey:@"browse_id"];
        [JHAllStatistics jh_allStatisticsWithEventId:@"profile_exposure" params:params  type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
    }
    [self.idsDic removeAllObjects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(self.infoType == JHPersonalInfoTypePublish) {
        if(!self.draftView.isHidden) {
            [self refresh];
        }
    }
}

- (JHMyUserInfoDraftHeader *)draftView {
    if(!_draftView) {
        _draftView = [JHMyUserInfoDraftHeader new];
    }
    return _draftView;
}

@end

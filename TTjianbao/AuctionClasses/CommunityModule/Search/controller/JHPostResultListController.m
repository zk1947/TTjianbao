//
//  JHPostResultListController.m
//  TTjianbao
//
//  Created by lihui on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPostResultListController.h"
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
#import "JHEasyInputTextView.h"
#import "JHDiscoverStatisticsModel.h"
#import "JHSearchRespModel.h"
#import "NSTimer+Help.h"
#import "JHGrowingIO.h"

#define kStatiscGapTime 1000

@interface JHPostResultListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath; //将要对这条帖子进行评论

@property (nonatomic, strong) JHSearchRespModel *respModel;
//feed流<帖子>数据模型
@property (nonatomic, strong) JHSQModel *curModel;

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

@end

@implementation JHPostResultListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _curModel = [[JHSQModel alloc] init];
    
    self.respModel = [[JHSearchRespModel alloc] init];
    self.respModel.section_id = 0;
    self.respModel.user_id = 0;
    self.respModel.page = 1;
    self.respModel.topic_id = 0;
    self.respModel.q = self.q;

    [self createTableView];
    [self refreshSearchResult:self.q];

    [self registerPlayer];
    [self addObserver];
    
    //搜索结果落地页埋点
    if(self.q){
        [JHGrowingIO trackEventId:JHSearch_click variables:@{@"type":@"2"}];
    }
}

- (void)reloadData {
    [self refresh];
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
}

#pragma mark - player
- (void)registerPlayer {
    @weakify(self);
    [self initPlayerWithListView:self.contentTableView controlView:[JHBaseControlView new]];
    self.section = 0;
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.curModel.list[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromSQSearchResult
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromSQSearchResult scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        return self.curModel.list[indexPath.row].video_info.coverImage;
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
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(1, 0, 0, 0));
    }];
    
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([YDBaseTableViewCell class]),
                           NSStringFromClass([JHBlankPostTableViewCell class])];
    [JHSQHelper configTableView:_contentTableView cells:cellNames];
    
    @weakify(self);
    table.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self refresh];
    }];
    
    table.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self refreshMore];
    }];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.curModel.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.curModel.list[indexPath.row];
    switch (data.item_type) {
        case JHPostItemTypePost: {
            JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeSQHomePostSearch;
            cell.postData = data;
            cell.indexPath = indexPath;
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
            cell.pageType = JHPageTypeSQHomePostSearch;
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
        case JHPostItemTypeVideo: {
            JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeSQHomePostSearch;
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
    JHPostData *data = _curModel.list[indexPath.row];
    Class curClass = Nil;
    
    if (data.item_type == JHPostItemTypePost) {
        curClass = [JHSQPostNormalCell class];
    } else if (data.item_type == JHPostItemTypeDynamic) {
        curClass = [JHSQPostDynamicCell class];
    } else if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
        curClass = [JHSQPostVideoCell class];
    }
    
    if (curClass) {
        return [self.contentTableView cellHeightForIndexPath:indexPath
                                                model:_curModel.list[indexPath.row]
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

#pragma mark -
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType withData:(JHPostData*)data{
    
    if (operationType == JHOperationTypeColloct||
        operationType == JHOperationTypeCancleColloct) {
        data.is_collect =! data.is_collect;
    }
    if (operationType == JHOperationTypeSetGood||
        operationType == JHOperationTypeCancleSetGood) {
        data.content_level=data.content_level==1?0:1;
    }
    if (operationType == JHOperationTypeSetTop||
        operationType == JHOperationTypeCancleSetTop) {
        data.content_style=data.content_style==2?0:2;
    }
    if (operationType == JHOperationTypeNoice||
        operationType == JHOperationTypeCancleNotice) {
        data.content_style=data.content_style==3?0:3;
    }
    if (operationType == JHOperationTypeDelete) {
        [self.curModel.list removeObject:data];
        [self.contentTableView reloadData];
    }
}

#pragma mark -
#pragma mark - Data

- (void)refreshSearchResult:(NSString *)q{
    self.q = q;
    [self refresh];
}

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = NO;
    _curModel.isLoading = YES;
    self.respModel.page = 1;
    self.respModel.q = self.q;
    
    [self.curModel.list removeAllObjects];
    [self loadData:YES];
}
- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.isLoading = YES;
    _curModel.willLoadMore = YES;
    self.respModel.q = self.q;
    self.respModel.page ++;
    [self loadData:NO];
}
//获取主列表数据
- (void)loadData:(BOOL)isRefresh {
    if (![self.respModel.q isNotBlank]) {
        return;
    }
    
    @weakify(self);
    [JHSQApiManager getSearchPostList:self.respModel block:^(JHSQModel * _Nullable respObj, BOOL hasError)
     {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        self.curModel.isLoading = NO;
        
        if (respObj) {
            [self.curModel configModel:respObj QueryWord:self.q];
            self.playVideoUrls = self.curModel.videoUrls;
            NSLog(@"curModel.list:----- %@", self.curModel.list);
            [self.contentTableView reloadData];
            if (isRefresh) {
                if (self.curModel.list.count > 0) {
                    [self.contentTableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
                }
            }
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        BOOL hasData = self.curModel.list.count == 0 ? NO :YES;
        [self.view configBlankType:0 hasData:hasData hasError:hasError reloadBlock:nil];
        ///369神策埋点:发送搜索请求
        [self sendSearchRequest:hasData];

    }];
}

- (void)sendSearchRequest:(BOOL)hasResult {
    ///369神策埋点:发送搜索请求
    [JHTracking trackEvent:@"sendSearchRequest" property:@{@"has_result":@(hasResult), @"key_word":self.q, @"key_word_source":self.keywordSource}];
}

- (void)endRefresh {
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
}


#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

#pragma mark -
#pragma mark - 分页逻辑

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

- (UIScrollView *)listScrollView {
    return self.contentTableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
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
    
    JHPostData *data = _curModel.list[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            data.comment_num++;
            [self.contentTableView reloadData];
        }
    }];
}

/// 曝光帖子ID集合
- (NSMutableDictionary *)idsDic {
    if(!_idsDic)
    {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
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
        [[JHBuryPointOperator shareInstance] buryWithEtype:@"search_exposure" param:@{@"browse_id" : IDS , @"query_word" : self.q ? : @""}];
    }
    
    [self.idsDic removeAllObjects];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    JHPostData *data = _curModel.list[indexPath.row];
    
    if(data.item_type == JHPostItemTypeDynamic || data.item_type == JHPostItemTypePost || data.item_type == JHPostItemTypeVideo)
    {
        if(data.item_id)
        {
            [self.idsDic setValue:data.item_id forKey:data.item_id];
        }
    }
    NSLog(@"ResultFuzzyViewController dealloc......");
}

@end

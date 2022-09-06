//
//  JHPlateDetailListController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailListController.h"
#import "JHCommentListTableViewCell.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "JHSQHelper.h"
#import "JHSQModel.h"
#import "JHSQManager.h"
#import "JHSQApiManager.h"
#import "UIView+Blank.h"
#import "UIScrollView+JHEmpty.h"
#import "JHEasyInputTextView.h"
#import "JHSQUploadManager.h"
#import "UIScrollView+JHEmpty.h"

@interface JHPlateDetailListController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) UITableView *contentTableView;
///将要对这条帖子进行评论
@property (nonatomic, strong) NSIndexPath *toCommentIndexPath;
@property (nonatomic, copy) dispatch_block_t finshLoadMoreData;
@property (nonatomic, weak) UIView *inputMaskView;

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

@end

@implementation JHPlateDetailListController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init {
    self = [super init];
    if(self) {
        //静音开关通知
        [JHNotificationCenter addObserver:self selector:@selector(switchVideoMute) name:kMuteStateChangedNotication object:self];
        [JHNotificationCenter addObserver:self selector:@selector(updatePublishDataJustNow) name:kUpdateSQPlateDetailDataNotification object:nil];
    }
    return self;
}

///发布完帖子到列表页 显示数据
- (void)updatePublishDataJustNow {
    if (self.viewModel.pageIndex == 0 &&
        [JHSQUploadManager shareInstance].localPostInfo) {
        ///发布帖子
        JHPostData *data = [JHSQUploadManager shareInstance].localPostInfo;
        if(data.plate_info && [data.plate_info.ID isEqualToString:self.viewModel.reqModel.channel_id])
        {
            [self.viewModel.dataArray insertObject:[JHSQUploadManager shareInstance].localPostInfo atIndex:0];
            [self.contentTableView jh_reloadDataWithEmputyView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    [self createTableView];
        
    [self registerPlayer];
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
    if(IDS.length > 0) {
        [[JHBuryPointOperator shareInstance] buryWithEtype:@"channel_exposure" param:@{@"browse_id" : IDS}];
    }
    [self.idsDic removeAllObjects];
}

-(void)switchVideoMute {
    [self setIsVideoMute:[JHSQManager isMute]];
}

#pragma mark - player
- (void)registerPlayer {
    
    @weakify(self);
    [self initPlayerWithListView:self.contentTableView controlView:[JHBaseControlView new]];
    self.section = 0;
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.viewModel.dataArray[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromSQPlateDetail
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
        
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromSQPlateDetail scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        JHPostData *data = self.viewModel.dataArray[indexPath.row];
        return data.video_info.coverImage;
    };
}

- (void)createTableView {
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.tableFooterView = [UIView new];
    table.showsVerticalScrollIndicator = NO;
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentTableView = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([YDBaseTableViewCell class])];
    [JHSQHelper configTableView:_contentTableView cells:cellNames];
    table.backgroundColor = kColorF5F6FA;
    @weakify(self);
    table.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.requestCommand execute:@YES];
    }];

}

-(void)loadMoreDataBlock:(dispatch_block_t)block
{
    _finshLoadMoreData = block;
    [self.viewModel.requestCommand execute:@YES];
}
#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.viewModel.dataArray[indexPath.row];
    switch (data.item_type) {
        case JHPostItemTypePost: {
            JHSQPostNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostNormalCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeSQPlateList;
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
            cell.pageType = JHPageTypeSQPlateList;
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
            cell.pageType = JHPageTypeSQPlateList;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    JHPostData *data = self.viewModel.dataArray[indexPath.row];
    if(data.item_id)
    {
        [self.idsDic setObject:data.item_id forKey:data.item_id];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = self.viewModel.dataArray[indexPath.row];
    Class curClass = Nil;
    
    if (data.item_type == JHPostItemTypePost) {
        curClass = [JHSQPostNormalCell class];
    } else if (data.item_type == JHPostItemTypeDynamic) {
        curClass = [JHSQPostDynamicCell class];
    } else if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
        curClass = [JHSQPostVideoCell class];
    }
    if (curClass) {
        return [_contentTableView cellHeightForIndexPath:indexPath
                                                model:self.viewModel.dataArray[indexPath.row]
                                              keyPath:@"postData"
                                            cellClass:curClass
                                     contentViewWidth:kScreenWidth];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
}


///刷新数据  主播id
- (void)refreshDataBlock:(dispatch_block_t)block
{
    _finshLoadMoreData = block;
    
    self.viewModel.reqModel.page = 1;
    self.viewModel.reqModel.last_date = @"";
    [self.viewModel.requestCommand execute:@YES];
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
        [self.viewModel.dataArray removeObject:data];
        [self.contentTableView jh_reloadDataWithEmputyView];
    }
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
    JHPostData *data = self.viewModel.dataArray[_toCommentIndexPath.row];
    @weakify(self);
    [JHSQApiManager sendComment:commentInfos postData:data block:^(JHCommentData * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            data.comment_num++;
            [self.contentTableView jh_reloadDataWithEmputyView];
        }
    }];
}

-(JHPlateDetailListViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [JHPlateDetailListViewModel new];
        _viewModel.reqModel.page = 1;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if(self.finshLoadMoreData && self.viewModel.reqModel.page <= 2)
             {
                 self.finshLoadMoreData();
             }
            self.playVideoUrls = [NSMutableArray arrayWithArray:self.viewModel.playVideoUrls];
            [self.contentTableView jh_reloadDataWithEmputyView];
            [self.contentTableView.mj_footer endRefreshing];
        }];
    }
    return _viewModel;
}

/// 曝光帖子ID集合
-(NSMutableDictionary *)idsDic {
    if(!_idsDic) {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
}

@end

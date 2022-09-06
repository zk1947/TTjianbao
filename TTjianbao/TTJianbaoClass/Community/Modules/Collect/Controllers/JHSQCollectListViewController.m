//
//  JHSQCollectListViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHSQCollectListViewController.h"
#import "JHSQHelper.h"
#import "JHSQApiManager.h"
#import "JHSQPostNormalCell.h"
#import "JHSQPostDynamicCell.h"
#import "JHSQPostVideoCell.h"
#import "CommAlertView.h"
#import "JHBlankPostTableViewCell.h"

@interface JHSQCollectListViewController ()

//feed流<帖子>数据模型
@property (nonatomic, strong) JHSQModel *curModel;

@end

@implementation JHSQCollectListViewController

#pragma mark -
#pragma mark - Life Cycle
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"我的收藏内容页"
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _curModel = [[JHSQModel alloc] init];
    
    [self configTableView];
    
    [self refresh];
    
    [self registerPlayer];
    
    [self addObserver];
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
    [self initPlayerWithListView:self.tableView controlView:[JHBaseControlView new]];
    self.section = 0;
    
    self.singleTapBack = ^(NSIndexPath * _Nonnull indexPath) {
        //单击进详情
        @strongify(self);
        JHPostData *data = self.curModel.list[indexPath.row];
        NSDictionary *params = @{@"plate_id":data.plate_info.ID,
                                 @"page_from":JHFromCollectList
        };
        [JHGrowingIO trackEventId:JHTrackSQPlateVideoEnter variables:params];
       
        [JHRouterManager pushPostDetailWithItemType:data.item_type itemId:data.item_id pageFrom:JHFromCollectList scrollComment:0];
    };
    
    self.getCoverImage = ^UIImage * _Nonnull(NSIndexPath * _Nonnull indexPath) {
        //获取封面图
        @strongify(self)
        return self.curModel.list[indexPath.row].video_info.coverImage;
    };
}

#pragma mark
#pragma mark - UI Methods

- (void)configTableView {
    NSArray *cellNames = @[NSStringFromClass([JHSQPostNormalCell class]),
                           NSStringFromClass([JHSQPostDynamicCell class]),
                           NSStringFromClass([JHSQPostVideoCell class]),
                           NSStringFromClass([JHBlankPostTableViewCell class]),
                           NSStringFromClass([YDBaseTableViewCell class])];
    [JHSQHelper configTableView:self.tableView cells:cellNames];
    
    self.tableView.backgroundColor = kColorF5F6FA;
    //self.refreshFooter.showNoMoreString = YES;
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
}


#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = NO;
    
    [self getPostList];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self getPostList];
}

//获取主列表数据
- (void)getPostList {
    @weakify(self);
    [JHSQApiManager getCollectPostList:_curModel block:^(JHSQModel * _Nullable respObj, BOOL hasError)
    {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj hideComment:YES];
            self.playVideoUrls = self.curModel.videoUrls;
//            [self.tableView reloadData];
            
            
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
             
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        [self.tableView jh_reloadDataWithEmputyView];
//        BOOL hasData = self.curModel.list.count == 0 ? NO :YES;
//        [self.view configBlankType:0 hasData:hasData hasError:NO reloadBlock:nil];
    }];
}

#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
      return _curModel.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHPostData *data = _curModel.list[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        return 137.f;
    }
    
    Class curClass = Nil;
    
    if (data.item_type == JHPostItemTypePost) {
        curClass = [JHSQPostNormalCell class];
    } else if (data.item_type == JHPostItemTypeDynamic) {
        curClass = [JHSQPostDynamicCell class];
    } else if (data.item_type == JHPostItemTypeVideo || data.item_type == JHPostItemTypeAppraisalVideo) {
        curClass = [JHSQPostVideoCell class];
    }
    
    if (curClass) {
        return [self.tableView cellHeightForIndexPath:indexPath
                                                model:_curModel.list[indexPath.row]
                                              keyPath:@"postData"
                                            cellClass:curClass
                                     contentViewWidth:kScreenWidth];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHPostData *data = _curModel.list[indexPath.row];
    if (data.show_status == JHPostDataShowStatusDelete) {
        JHBlankPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBlankPostTableViewCell class]) forIndexPath:indexPath];
        cell.indexPath = indexPath;
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
            cell.pageType = JHPageTypeCollect;
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
            cell.pageType = JHPageTypeCollect;
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
        case JHPostItemTypeAppraisalVideo:
        case JHPostItemTypeVideo:
        {
            JHSQPostVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHSQPostVideoCell class]) forIndexPath:indexPath];
            cell.pageType = JHPageTypeCollect;
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

#pragma mark -
#pragma mark - 操作交互弹框后 刷新cell数据
-(void)operationComplete:(JHOperationType)operationType withData:(JHPostData*)data{
    
    if (operationType==JHOperationTypeColloct) {
        data.is_collect=!data.is_collect;
    }
    if (operationType==JHOperationTypeCancleColloct) {
           data.is_collect=!data.is_collect;
           [self.curModel.list removeObject:data];
           [self.tableView reloadData];
        if (self.refreshCountBlock) {
            self.refreshCountBlock();
        }
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
    
    BOOL hasData = self.curModel.list.count == 0 ? NO :YES;
    [self.view configBlankType:0 hasData:hasData hasError:NO reloadBlock:nil];
}

- (void)cancelFavorite:(NSInteger)index {
    JHPostData *data = self.curModel.list[index];
    [JHSQApiManager collectRequest:data block:^(RequestModel *respObj, BOOL hasError) {
        if (!hasError) {
            [UITipView showTipStr:@"删除成功"];
            [self.curModel.list removeObject:data];
            [self.tableView reloadData];
            
            if (self.refreshCountBlock) {
                self.refreshCountBlock();
            }
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
        [self cancelFavorite:index];
    };
    
    alert.cancleHandle = ^{

    };
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}


- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}
@end

//
//  JHBuyAppraiseViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseViewController.h"
#import "JHBuyAppraiseHeaderView.h"
#import "JHBuyAppraiseCell.h"
#import "JHBuyAppraiseModel.h"
#import "JHBuyAppraiseTVBoxHeader.h"
#import "MJExtension.h"
#import "JHEmptyTableViewCell.h"
#import "JHGrowingIO.h"
#import "JHBuyAppraiseTVBoxView.h"
#import "JHAppAlertViewManger.h"
#import "JHPlayerViewController.h"
#import "JHBuyAppraiseVideoController.h"

@interface JHBuyAppraiseViewController ()<UITableViewDelegate, UITableViewDataSource, JHBuyAppraiseVideoControllerDelegate>
{
    NSTimeInterval liveIntime;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) JHBuyAppraiseHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL headerAppear;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHBuyAppraiseCell *currentCell;
@end

@implementation JHBuyAppraiseViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if(![JHBuyAppraiseTVBoxView shareInstance].ignoreChange) {
        [self.headerView stop];
    }
    if (liveIntime>0) {
        liveIntime = (time(NULL)-liveIntime)*1000;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_duration" params:@{@"duration":@(liveIntime).stringValue} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250 - UI.statusAndNavBarHeight];
    
    liveIntime = time(NULL);
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"购物鉴定首页"} type:JHStatisticsTypeSensors];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [JHGrowingIO trackEventId:@"shopping_appraisal"];
    if(![JHBuyAppraiseTVBoxView shareInstance].ignoreChange) {
        [self.headerView start];
    }
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:3];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self growingWithTrackEventId:@"shopping_appraisal_duration" dict:@{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    [self jhSetLightStatusBarStyle];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.equalTo(self.tableView);
    }];
    [self.tableView layoutIfNeeded];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)refreshData{
    self.pageIndex =1;
    [self.tableView.mj_footer resetNoMoreData];
    [self.headerView refreshData];
    [self getReportsData:nil];
}

- (void)getReportsData:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageIndex"] = @(self.pageIndex);
    params[@"pageSize"] = @(20);
    [params setValuesForKeysWithDictionary:self.params];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/appraisal/shop/appraisal-reports") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
        
        NSArray *array = [JHBuyAppraiseModel mj_objectArrayWithKeyValuesArray:respondObject.data];

        if (self.pageIndex == 1) {
            self.listArray = [NSMutableArray arrayWithArray:array];
        }else{
            [self.listArray addObjectsFromArray:array];
        }
        for (int i = 0; i < array.count; i ++) {
            JHBuyAppraiseModel *model = array[i];
            model.listIndex = self.listArray.count-array.count + i;
        }
        if (array.count > 0) {
            self.pageIndex += 1;
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        if (block) {
            block(array, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (block) {
            block(nil, YES);
        }
    }];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count > 0 ? self.listArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        return self.tableView.height;
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count == 0) {
        JHEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHEmptyTableViewCell class])];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    JHBuyAppraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBuyAppraiseCell class])];
    cell.indexPath = indexPath;
    JHBuyAppraiseModel *model = self.listArray[indexPath.row];
    model.listIndex = indexPath.row;
    cell.model = model;
    @weakify(self);
    cell.enterDetailBlock = ^(NSInteger selectIndex) {
        @strongify(self);
        [self enterVideoDetailPage:selectIndex];
    };
    return cell;
}
- (void)enterVideoDetailPage:(NSInteger)index {
    JHBuyAppraiseModel *model = self.listArray[index];
    [JHGrowingIO trackEventId:@"shopping_video" variables:@{@"appraisal_id":model.appraiser.appraiserId,@"shopping_id":model.shoppingId}];
    JHBuyAppraiseVideoController *vc = [[JHBuyAppraiseVideoController alloc] init];
    vc.delegate = self;
    NSMutableArray *videoModels = [NSMutableArray array];
    for (int i = 0; i < self.listArray.count; i ++) {
        JHBuyAppraiseModel *buyModel = self.listArray[i];
        if ([buyModel.videoUrl isNotBlank]) {
            [videoModels addObject:buyModel];
            if ([buyModel.videoUrl isEqualToString:model.videoUrl]) {
                vc.currentIndex = videoModels.count - 1;
            }
        }
    }
    vc.appraiseArray = videoModels.copy;
    @weakify(self);
    vc.backBlock = ^(NSInteger currentIndex) {
        @strongify(self);
        [self.tableView scrollToRow:currentIndex inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
    };
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
    NSString *quality = [model.appraiseType integerValue] == 1 ? @"问题件" :  @"优质件";
    [JHAllStatistics jh_allStatisticsWithEventId:@"appraisal_shopping_video_click" params:@{@"quality":quality, @"appraisal_name":model.appraiser.appraiserName,@"appraisal_id":model.appraiser.appraiserId} type:JHStatisticsTypeGrowing|JHStatisticsTypeSensors];
}

- (void)requestMoreAppraiseData:(void (^)(NSArray<JHBuyAppraiseModel *> * _Nullable))completateBlock {
    [self getReportsData:^(NSArray <JHBuyAppraiseModel *>*appraiseArray, BOOL hasError) {
        if (!hasError) {
            if (completateBlock) {
                for (int i = 0; i < appraiseArray.count; i ++) {
                    JHBuyAppraiseModel *model = appraiseArray[i];
                    model.listIndex = self.listArray.count-appraiseArray.count + i;
                }
                completateBlock(appraiseArray);
            }
        }
    }];
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - UI.statusAndNavBarHeight - UI.tabBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 1000;
        [_tableView registerClass:[JHBuyAppraiseCell class] forCellReuseIdentifier:NSStringFromClass([JHBuyAppraiseCell class])];
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHEmptyTableViewCell class])];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self getReportsData:nil];
        }];
    }
    return _tableView;
}

- (JHBuyAppraiseHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [[JHBuyAppraiseHeaderView alloc] init];
        MJWeakSelf;
        _headerView.selectBlock = ^(NSDictionary * _Nonnull params) {
            weakSelf.params = params;
            [weakSelf refreshData];
        };
    }
    return _headerView;
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.looping = YES;
        _playerController.hidePlayButton = YES;
        [self addChildViewController:_playerController];
    }
    return _playerController;
}

/// 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    if(y > [JHBuyAppraiseTVBoxHeader viewSize].height - 20) {
        if(_headerAppear) {
            [self.headerView stop];
        }
        _headerAppear = NO;
    }
    else {
        if(!_headerAppear) {
            [self.headerView start];
        }
        _headerAppear = YES;
    }
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}


- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
    [self endScrollToPlayVideo];
}

// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.tableView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHBuyAppraiseCell class]]) {
            JHBuyAppraiseCell *cell = (JHBuyAppraiseCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y - UI.statusAndNavBarHeight + rect.size.height / 2 > 0 &&
                rect.origin.y + rect.size.height / 2 < ScreenH - UI.tabBarHeight && [cell.model.showType isEqualToString:@"0"] && cell.model.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.videoImageView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.videoImageView addSubview:self.playerController.view];
                self.playerController.urlString = cell.model.videoUrl;
                return;
            }
        }
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
}
@end

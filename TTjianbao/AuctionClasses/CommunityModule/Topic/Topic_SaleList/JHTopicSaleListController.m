//
//  JHTopicSaleListController.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSaleListController.h"
#import "YDBaseNavigationBar.h"
#import "CSaleListModel.h"
#import "TopicApiManager.h"
#import "YDRefreshFooter.h"
#import "JHTopicSaleListHeader.h"
#import "HJCollectionViewWaterfallLayout.h"
#import "JHDiscoverHomeFlowCollectionCell.h"
#import "JHDiscoverDetailsVC.h"
#import "JHAppraiseVideoViewController.h"
#import "JHDiscoverVideoDetailViewController.h"
#import "JHTopicDetailController.h"

#import "JHBuryPointOperator.h"
#import "ZQSearchConst.h"
#import "NSString+LNExtension.h"


#import "JHAnchorHomepageTopView.h"
#import "JHDiscoverChannelCateModel.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHDiscoverStatisticsModel.h"
#import "JHGrowingIO.h"


#define kStatiscGapTime 1000


static NSString *const kDefaultCCellID = @"DefaultCCellId"; //空页面
static NSString *const kFlowCCellID = @"FlowCCellId"; //瀑布流


@interface JHTopicSaleListController ()
<UICollectionViewDelegate, UICollectionViewDataSource, HJCollectionViewWaterfallLayoutDelegate>

@property (nonatomic, strong) YDBaseNavigationBar *naviBar;
@property (nonatomic, strong) CSaleListModel *curModel;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHTopicSaleListHeader *headerView;

@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

@property (nonatomic, assign) BOOL showDefaultImage;

@property (nonatomic, assign) NSInteger page;//collectionView的页数

@property (nonatomic, strong) NSMutableArray *pubuZaningArr;

@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *originArr;//原始数组，随时插入
@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *waitUploadArr;//等待上传的数据
@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *canUploadArr;//所有满足条件的数据

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation JHTopicSaleListController

- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configNaviBar {
    _naviBar = [YDBaseNavigationBar naviBar];
    _naviBar.title = @"特卖";
    _naviBar.leftImage = kNavBackBlackImg;
    [_naviBar.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _naviBar.bottomLine.hidden = NO;
    [self.view addSubview:_naviBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _curModel = [[CSaleListModel alloc] init];
    _curModel.item_id = _item_id;
    
    [self configNaviBar];
    [self configHeaderView];
    [self configCollectionView];
    
    //[self setupScrollView:_collectionView target:self refreshData:@selector(refresh) loadMoreData:@selector(refreshMore)];
    
    [self sendRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addTimer];
    //防止webp不播放
    [_collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self refreshStatics:YES];
}

- (void)configHeaderView {
    if (!_headerView) {
        _headerView = [[JHTopicSaleListHeader alloc] initWithFrame:CGRectMake(0, JHNaviBarHeight, ScreenWidth, [JHTopicSaleListHeader headerHeight])];
        [self.view addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(JHNaviBarHeight);
            make.height.mas_equalTo([JHTopicSaleListHeader headerHeight]);
        }];
    }
}

- (void)configCollectionView {
    if (!_collectionView) {
        HJCollectionViewWaterfallLayout *layout = [[HJCollectionViewWaterfallLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#f5f5f5"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[JHDiscoverHomeFlowCollectionCell class] forCellWithReuseIdentifier:kFlowCCellID];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:kDefaultCCellID];
        [self.view addSubview:_collectionView];
        
        _collectionView.mj_header = self.refreshHeader;
        _collectionView.mj_footer = self.refreshFooter;
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(_headerView.mas_bottom);
            make.bottom.equalTo(self.view).offset(JHSafeAreaBottomHeight);
        }];
    }
}

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = YES;
    }
    return _refreshHeader;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES;
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    [self refreshStatics:NO];
    if (_curModel.isLoading) return;
    _curModel.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    @weakify(self);
    [TopicApiManager request_saleList:_curModel completeBlock:^(CSaleListModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        
        [self.curModel configModel:respObj];
        
        if (self.curModel.contentList.count == 0) {
            self.showDefaultImage = YES;
        } else {
            self.showDefaultImage = NO;
        }
        
        if ((self.curModel.page > 1 && respObj.contentList.count == 0) || self.curModel.contentList.count == 0) {
            self.collectionView.mj_footer.hidden = YES;
        } else {
            self.collectionView.mj_footer.hidden = NO;
        }
        
        [self.headerView setServerTime:self.curModel.server_time endTime:self.curModel.end_time];
        [self.collectionView reloadData];
    }];
}

#pragma mark -
#pragma mark   ==============UICollectionViewDataSource==============
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showDefaultImage) {
        return  1;
    }
    return _curModel.contentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHDiscoverHomeFlowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFlowCCellID forIndexPath:indexPath];
    if (self.showDefaultImage) {
        JHDefaultCollectionViewCell *defaultcell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCCellID forIndexPath:indexPath];
        return defaultcell;
    }
    cell.recordMode = _curModel.contentList[indexPath.item];
    cell.cellIndex = indexPath.row;
    WEAKSELF
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        [weakSelf clickIndex:index isLaud:isLaud];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *model = _curModel.contentList[indexPath.item];
    if (model.layout == JHSQLayoutTypeImageText) {//图片
        NSLog(@"跳转图文详情。。。。");
        JHDiscoverDetailsVC *vc = [JHDiscoverDetailsVC new];
        vc.cateModel = model;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.item_id = model.item_id;
        vc.entry_type = JHEntryType_All_Sale_List;
        vc.entry_id = @"0";
        vc.zanBlock = ^(JHDiscoverChannelCateModel * _Nonnull cateModel) {
            //更新当前collectionviewCell
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    } else if (model.layout == JHSQLayoutTypeVideo) {//视频
        NSLog(@"跳转视频详情。。。。");
        JHDiscoverVideoDetailViewController *vc = [JHDiscoverVideoDetailViewController new];
        vc.cateModel = model;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.item_id = model.item_id;
        vc.entry_type = JHEntryType_All_Sale_List;
        vc.entry_id = @"0";
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    } else if (model.layout == JHSQLayoutTypeAppraisalVideo) {//鉴定剪辑
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = model.cate_id;
        vc.appraiseId = model.item_id;
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            model.like_num_int = [likeNum integerValue];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        vc.from = JHFromSQTopicDetail;

        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    } else if (model.layout == JHSQLayoutTypeTopic) { //话题详情
        JHTopicDetailController *vc = [JHTopicDetailController new];
        [vc setTitle:model.title itemId:model.item_id];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        //埋点 - 进入话题详情埋点
        [self buryPointWithTopicId:model.item_id];
    }
    
    //埋点
    // [Growing track:@"searchresultclick" withVariable:@{@"value": @(model.item_type==2?1:0)}];
}

//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 0;
    pointModel.entry_id = @"0";
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
/**
 item size
 */
- (CGSize)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showDefaultImage) {
        return CGSizeMake(ScreenW, ScreenH - StatusBarAddNavigationBarH - 44);
    }
    JHDiscoverChannelCateModel *model = _curModel.contentList[indexPath.item];
    return CGSizeMake((ScreenW-25)/2, model.height);
}

//每组单行的排布个数
- (NSInteger)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columCountAtSection:(NSInteger)section {
    if (self.showDefaultImage) {
        return 1;
    }
    return 2;
}

//每组头部视图的高度
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderAtSection:(NSInteger)section {
    return 0;
}

//每组尾部视图的高度
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForFooterAtSection:(NSInteger)section{
    return 0;
}

//每组的UIEdgeInsets
- (UIEdgeInsets)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

//每组的minimumLineSpacing 行与行之间的距离
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSection:(NSInteger)section{
    return 5;
}

//每组的minimumInteritemSpacing 同一行item之间的距离
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSection:(NSInteger)section {
    return 5;
}

- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud {
    
    if ([self isLgoin]) {
        JHDiscoverChannelCateModel * model = [_curModel.contentList objectAtIndex:index];
        if ([self.pubuZaningArr containsObject:model.item_id]) {
            return;
        }
        [self.pubuZaningArr addObject:model.item_id];
        if (laud) {
            //瀑布流点赞
            [JHDiscoverChannelViewModel cancleLikeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
                model.like_num_int = [request.data[@"like_num_int"] integerValue];
                model.is_like = 0;
                
                JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell beginAnimation:model];
                
            } failure:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                [UITipView showTipStr:request.message];
            }];
        } else {
            //瀑布流点赞
            [JHDiscoverChannelViewModel likeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
                model.like_num_int = [request.data[@"like_num_int"] integerValue];
                model.is_like = 1;
                
                JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell beginAnimation:model];
                
            } failure:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                [UITipView showTipStr:request.message];
            }];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *cateModel = _curModel.contentList[indexPath.item];
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //    NSLog(@"startTimeSp = %f", timeSp);
    //判断originArr或者canUploadArr是否存在,存在则不进行任何操作
    for (JHDiscoverStatisticsModel *model in self.canUploadArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    for (JHDiscoverStatisticsModel *model in self.originArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    JHDiscoverStatisticsModel *model = [JHDiscoverStatisticsModel new];
    model.item_uniq_id = cateModel.item_uniq_id;
    model.startTime = timeSp;
    [self.originArr addObject:model];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    
    if (indexPath.item < _curModel.contentList.count) {
        JHDiscoverChannelCateModel *cateModel = _curModel.contentList[indexPath.item];
        
        for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
            if ([staticModel.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
                //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
                if (timeSp - staticModel.startTime >= kStatiscGapTime) {
                    [self.waitUploadArr addObject:staticModel];
                    [self.canUploadArr addObject:staticModel];
                }
                [removeOrignalArr addObject:staticModel];
                // NSLog(@"didEndDisplayingCell row = %ld, str = %@", indexPath.item, staticModel.item_id);
            }
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    // NSLog(@"didEndDisplayingCell row = %ld, cout = %ld", indexPath.item, self.originArr.count);
}

- (BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        return  NO;
    }
    return  YES;
}

- (NSMutableArray *)pubuZaningArr {
    if (!_pubuZaningArr) {
        _pubuZaningArr = [NSMutableArray array];
    }
    return _pubuZaningArr;
}

- (void)addTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(uploadStatics) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)destoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//下拉刷新
- (void)refreshStatics:(BOOL)isDisAppear {
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
        }
    }
    if (!isDisAppear) {
        [self.originArr removeAllObjects];
    }
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 3;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    NSLog(@"row =下拉刷新上报埋点搜索页appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
    //还要取消定时器，开启新定时器
    if (!isDisAppear) {
        [self addTimer];
    }else {
        [self destoryTimer];
    }
}

- (void)uploadStatics {
    // NSLog(@"定时器响应");
    
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
            [removeOrignalArr addObject:staticModel];
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 3;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    // NSLog(@"row = waitUploadArrCount = %ld", self.waitUploadArr.count);
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            appStr = [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    // NSLog(@"appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        NSLog(@"row =定时器上报埋点appstr = %@", appStr);
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
}

- (NSMutableArray *)originArr {
    if (!_originArr) {
        _originArr = [NSMutableArray array];
    }
    return _originArr;
}

- (NSMutableArray *)waitUploadArr {
    if (!_waitUploadArr) {
        _waitUploadArr = [NSMutableArray array];
    }
    return _waitUploadArr;
}

- (NSMutableArray *)canUploadArr {
    if (!_canUploadArr) {
        _canUploadArr = [NSMutableArray array];
    }
    return _canUploadArr;
}

- (void)dealloc {
    NSLog(@"JHTopicSaleListController dealloc......");
}


@end

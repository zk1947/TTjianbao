//
//  JHNewStoreGoodsSearchResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreGoodsSearchResultViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHUIFactory.h"
#import "JHNewStoreSearchResultViewModel.h"
#import "YDRefreshFooter.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHPlayerViewController.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHSearchResultOperationCollectionCell.h"
#import "JHLivePlayerManager.h"
#import "JHMallLittleCollectionViewCell.h"

static CGFloat const TagsViewHeight =44.f;
static CGFloat const RecommendTagsViewHeight =80.f;
static CGFloat const NullDataViewHeight =44.f;


@interface JHNewStoreGoodsSearchResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate, JHNewStoreSearchResultHeaderTagsViewDelegate, JHNewStoreRecommendTagsViewDelegate>
{
    JHMallLittleCollectionViewCell *lastCell;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewStoreSearchResultViewModel *searchResultViewModel;
@property (nonatomic, strong) JHNewStoreSearchResultHeaderTagsView *headerTagsView;
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, assign) int sortTypeNum;
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;//当前播放视频的cell
@property (nonatomic, strong) NSMutableArray * uploadData;
@property (nonatomic, assign) NSInteger filterService;//筛选服务 0平台鉴定
@property (nonatomic,   copy) NSString *minPrice;//最低价
@property (nonatomic,   copy) NSString *maxPrice;//最高价
@property (nonatomic, assign) BOOL isShowRecommendTagsView;//是否显示推荐标签
@property (nonatomic,   copy) NSString *isMallProduct;//是否有数据
@property (nonatomic,   copy) NSString *cursor;//后台传参
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isAbleClick;

@end

@implementation JHNewStoreGoodsSearchResultViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.uploadData.count > 0) {
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进入当前页面时之前页面的弹窗收起
    [self.headerTagsView viewControllerWillAppear];
    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(TagsViewHeight);
    }];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点

    
    //收藏等数据刷新
    [self.floatView loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortTypeNum = 0;
    self.cursor = @"";
    self.isMallProduct = @"1";

    [self setupUI];
    
    [self configData];
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - UI
- (void)setupUI{
    if (self.titleTagIndex == 1) { //直播
        //推荐标签
        [self.view addSubview:self.recommendTagsView];
        [self.recommendTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_top).offset(0);
            make.left.right.equalTo(self.view);
            make.height.mas_offset(RecommendTagsViewHeight);
        }];
    } else { //商品
        //排序筛选
        [self.view addSubview:self.headerTagsView];
        [self.headerTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_offset(TagsViewHeight);
        }];
        //推荐标签
        [self.view addSubview:self.recommendTagsView];
        [self.recommendTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_top).offset(TagsViewHeight);
            make.left.right.equalTo(self.view);
            make.height.mas_offset(RecommendTagsViewHeight);
        }];
        
        
        //筛选排序
        [self loadTagsViewData];

    }
    
    //无数据说明文案
    [self.view addSubview:self.nullDataLabel];
    [self.nullDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendTagsView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(NullDataViewHeight);
    }];
    
    //商品列表
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendTagsView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //把排序筛选View置顶
    [self.view bringSubviewToFront:self.headerTagsView];
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
}
///tagsView判断显示处理
- (void)loadTagsViewData{
    //0全部, 1直播, 2一口价, 3拍卖, 4店铺, 5集市
    NSArray *tagArray = @[@"综合排序",@"价格",@"马上开拍",@"即将截拍",@"筛选"];
    if (self.titleTagIndex == 2) {
        tagArray = @[@"综合排序",@"价格",@"筛选"];
    }
    self.headerTagsView.tagArray = tagArray;
    self.headerTagsView.defaultIndex = 0;

}


#pragma mark - LoadData
///重写父类方法
- (void)reloadSubViewData{
    [self.collectionView.mj_header beginRefreshing];
}
- (void)updateLoadData:(BOOL)isRefresh {
    self.isRefresh = isRefresh;
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"isRefresh"] = @(isRefresh);
    dicData[@"searchWord"] = self.keyword;
    dicData[@"customerId"] = [UserInfoRequestManager sharedInstance].user.customerId;
    dicData[@"isMallProduct"] = self.isMallProduct;
    dicData[@"searchType"] = self.titleTagIndex == 1 ? @"4" : [NSString stringWithFormat:@"%ld",labs(self.titleTagIndex-2)];//0:一口价 1: 拍卖 2: 全部 3: 店铺 4: 直播
    dicData[@"cateId"] = @(self.cateId);//关键词分类id
    dicData[@"tagWord"] = self.searchTextfield.recommendTagsArray.count > 0 ? self.self.searchTextfield.recommendTagsArray : @[];//关键词
    dicData[@"sortType"] = [NSString stringWithFormat:@"%d",self.sortTypeNum]; //排序类型 0:综合 1:价格升序 2:价格降序 3:马上开拍 4:最新上架 5:即将截拍
    dicData[@"service"] = self.filterService > 0 ? @"0" : @"";//服务 0:平台鉴定
    if (self.minPrice.length <= 0 && self.maxPrice.length <= 0) {
        dicData[@"priceRange"] = @"";
    }else {
        dicData[@"priceRange"] = [NSString stringWithFormat:@"%@-%@",(self.minPrice.length > 0 ? self.minPrice : @""), (self.maxPrice.length > 0 ? self.maxPrice : @"")];
    }
    dicData[@"cursor"] = self.cursor.length > 0 ? self.cursor :@"";

    [self.searchResultViewModel.searchResultCommand execute:dicData];

    //获取推荐标签
    if (isRefresh) {
        [self.searchResultViewModel.recommendTagsCommand execute:dicData];
    }
}

- (void)loadMoreData {
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    [self.searchResultViewModel.updateSearchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.isAbleClick = YES;
        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.searchResultViewModel.searchListDataArray.count > 4) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }

        self.cursor = self.searchResultViewModel.searchResultModel.cursor;
        //无数据文案
        self.isMallProduct = self.searchResultViewModel.searchResultModel.isMallProduct;
        if ([self.searchResultViewModel.searchResultModel.isMallProduct boolValue]) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.recommendTagsView.mas_bottom).offset(0);
            }];
        } else {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.recommendTagsView.mas_bottom).offset(NullDataViewHeight);
            }];
        }
        
        //刷新完成，其他操作
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self endScrollToPlayVideo];
            //直播拉流
            if (self.isRefresh) {
                [self beginPullSteam];
            }
             
        });

    }];
    
    //推荐标签数据
    [RACObserve(self.searchResultViewModel, recommendDataArray) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.searchResultViewModel.recommendDataArray.count > 0) {
            self.isShowRecommendTagsView = YES;
            self.recommendTagsView.tagsDataArray = self.searchResultViewModel.recommendDataArray;
            [self.recommendTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.titleTagIndex == 1) {//直播
                    make.bottom.equalTo(self.view.mas_top).offset(RecommendTagsViewHeight);
                }else {//商品
                    make.bottom.equalTo(self.view.mas_top).offset(TagsViewHeight+RecommendTagsViewHeight);
                }

            }];
        }else{
            self.isShowRecommendTagsView = NO;
            self.recommendTagsView.tagsDataArray = @[];
            [self.recommendTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                if (self.titleTagIndex == 1) {//直播
                    make.bottom.equalTo(self.view.mas_top).offset(0);
                }else {//商品
                    make.bottom.equalTo(self.view.mas_top).offset(TagsViewHeight);
                }
            }];
        }
    }];
    
    //更多数据
    [self.searchResultViewModel.moreSearchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        self.cursor = self.searchResultViewModel.searchResultModel.cursor;
        [self.collectionView reloadData];

    }];
    [self.searchResultViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.searchResultViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

    }];
   
}

#pragma mark  - Action
#pragma mark - 直播拉流相关
- (void)pullStream {
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y >= UI.statusAndNavBarHeight && rect.origin.y + rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
    NSArray* cellArr = [self.collectionView visibleCells];
    cellArr = [self sortbyCollectionArr:cellArr];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMallLittleCollectionViewCell class]])
        {
            JHMallLittleCollectionViewCell *cell = (JHMallLittleCollectionViewCell *)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            if (rect.origin.y >= UI.statusAndNavBarHeight && rect.origin.y+rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49 && self.currentCell == nil) {
                if (cell.liveRoomMode.ID != lastCell.liveRoomMode.ID &&
                    [cell.liveRoomMode.status integerValue] == 2) {
                    [[JHLivePlayerManager sharedInstance] startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{} isAnimal:YES isLikeImageView:YES];
                    lastCell = cell;
                    break;
                }
            }
        }
    }
}
///关闭播放流
- (void)shutdownPlayStream {
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell = nil;
}
///开始直播拉流
- (void)beginPullSteam {
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pullStream) object:nil];
     [self performSelector:@selector(pullStream) withObject:nil afterDelay:0.5];
}

//collection重新排序
- (NSArray *)sortbyCollectionArr:(NSArray *)array {
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHMallLittleCollectionViewCell *cell1 = (JHMallLittleCollectionViewCell *)obj1;
        JHMallLittleCollectionViewCell *cell2 = (JHMallLittleCollectionViewCell *)obj2;
        CGRect rect1 = [cell1 convertRect:cell1.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect rect2 = [cell2 convertRect:cell2.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect1.origin.y > rect2.origin.y) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (rect1.origin.y < rect2.origin.y){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sorteArray;
}

- (BOOL)isRefreshing {
    if (self.collectionView.mj_header.isRefreshing || [self.collectionView.mj_footer isRefreshing] || self.collectionView.mj_footer.state == MJRefreshStatePulling) {
        return YES;
    }
    return NO;
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}
- (void)isBeyondArea:(UIScrollView *)scrollView {
    if (![self isRefreshing] && lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight || rect.origin.y + rect.size.height > ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell = nil;
        }
    }
}


#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;
    
    //上滑、下滑回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:titleTagIndex:isShowRecommendTagsView:)]) {
        [self.delegate scrollViewDidScroll:scrollView titleTagIndex:self.titleTagIndex isShowRecommendTagsView:self.isShowRecommendTagsView];
    }
    
    //直播拉流相关
    [self isBeyondArea:scrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];

}


#pragma mark - JHNewStoreRecommendTagsViewDelegate
///推荐标签
- (void)didSelectItemOfIndex:(NSInteger)selectItem{
    if (self.isAbleClick) {
        self.isAbleClick = NO;
        JHNewSearchResultRecommendTagsListModel *tagsModel = self.searchResultViewModel.recommendDataArray[selectItem];
        NSMutableArray *tagsArray = [NSMutableArray array];
        [tagsArray addObject:tagsModel];
        self.searchTextfield.searchTagsArray = tagsArray;
        //埋点
        NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
        sensorsDic[@"label_name"] = tagsModel.tagWord;
        sensorsDic[@"key_word"] = self.keyword;
        if (self.fromSource == JHSearchFromStore) {
            sensorsDic[@"page_position"] = @"商城搜索结果页";
        } else if (self.fromSource == JHSearchFromLive) {
            sensorsDic[@"page_position"] = @"直播搜索结果页";
        }
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickLabel" params:sensorsDic type:JHStatisticsTypeSensors];
    }
    
}


#pragma mark - JHNewStoreSearchResultHeaderTagsViewDelegate
///综合排序事件点击
- (void)tagsViewSelectedOfSortMenuView:(BOOL)dismiss{
    if (dismiss) {
        [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(self.view.height);
        }];
    }else{
        [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(TagsViewHeight);
        }];
    }
}

///综合排序事件点击
- (void)sortViewSelectedOfIndex:(JHNewStorePriceSortType)sortType{
    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(TagsViewHeight);
    }];
    if (sortType >= 0) {
        self.sortTypeNum = (int)sortType;
        [self.collectionView.mj_header beginRefreshing];

        //埋点
        NSArray *sortTypeArray = @[@"综合排序", @"价格升序", @"价格降序", @"马上开拍", @"最新上架", @"即将截拍"];
        NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
        sensorsDic[@"sort_name"] = sortTypeArray[self.sortTypeNum];
        sensorsDic[@"position"] = self.titleArray[self.titleTagIndex];
        if (self.fromSource == JHSearchFromStore) {
            sensorsDic[@"page_position"] = @"商城搜索结果页";
        } else if (self.fromSource == JHSearchFromLive) {
            sensorsDic[@"page_position"] = @"直播搜索结果页";
        }
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickSort" params:sensorsDic type:JHStatisticsTypeSensors];
    }
    
}

///筛选弹窗事件点击
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice{
    //筛选服务
    self.filterService = serviceIndex;
    //最低价
    self.minPrice = lowPrice;
    //最高价
    self.maxPrice = highPrice;
    //切换标签请求数据
    [self.collectionView.mj_header beginRefreshing];
    
    
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"---willDisplayCell----%@",indexPath);
    if (self.titleTagIndex != 1) {
        JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.item];
        NSDictionary *dataDic = [dataModel mj_JSONObject];
        if ([dataDic objectForKey:@"productId"]) {
            NSString *store_from = self.keyword;
            NSString * strtemp = [NSString stringWithFormat:@"%@_%ld",store_from,dataModel.productId];
            if (![self.uploadData containsObject:strtemp]) {
                [self.uploadData addObject:strtemp];
                if (self.uploadData.count>=10) {
                    NSMutableArray * temp = [self.uploadData mutableCopy];
                    [self sa_uploadData:temp];
                    [self.uploadData removeAllObjects];
                }
            }
        }
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.titleTagIndex == 0 && self.searchResultViewModel.operationDataArray.count > 0) {//且有运营数据
        return self.searchResultViewModel.searchListDataArray.count+1;
    }else {
        return self.searchResultViewModel.searchListDataArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchResultViewModel.operationDataArray.count > 0 && indexPath.row == 0 && self.titleTagIndex == 0) {//运营位
        JHSearchResultOperationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHSearchResultOperationCollectionCell class]) forIndexPath:indexPath];
        [cell bindViewModel:self.searchResultViewModel.operationDataArray];
        return cell;
    }else{
        NSInteger indexRow = indexPath.row;
        if (self.titleTagIndex == 0 && self.searchResultViewModel.operationDataArray.count > 0) {
            indexRow = indexPath.row-1;
        }
        JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        NSDictionary *dataDic = [dataModel mj_JSONObject];
        if ([dataDic objectForKey:@"productId"]) { //商品
            JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
            cell.curData = self.searchResultViewModel.searchListDataArray[indexRow];
            
            @weakify(self)
            cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
                @strongify(self)
                NSString *store_from = self.cateId > 0 ? @"商品分类列表页" : @"商品搜索列表页";
                if (!isH5) {
                    JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
                    vc.showId = showId;
                    vc.fromPage = store_from;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick" params:@{@"store_from":store_from} type:JHStatisticsTypeSensors];
                }
            };
            return cell;
        }
        else { //直播
            JHMallLittleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
            cell.liveRoomMode = self.searchResultViewModel.searchListDataArray[indexRow];
            return cell;
        }
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    if (self.searchResultViewModel.operationDataArray.count > 0 && indexPath.row == 0 && self.titleTagIndex == 0) {
       //运营位
    }else{
        NSInteger indexRow = indexPath.row;
        if (self.titleTagIndex == 0 && self.searchResultViewModel.operationDataArray.count > 0) {
            indexRow = indexPath.row-1;
        }
        JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        NSDictionary *dataDic = [dataModel mj_JSONObject];
        //商品
        if ([dataDic objectForKey:@"productId"]) {
            JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
            detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
            detailVC.fromPage =self.cateId > 0 ? @"分类列表页" : @"搜索列表页";
            [self.navigationController pushViewController:detailVC animated:YES];
            
            @weakify(self)
            //判断刷新当前商品订单 是否 解除
            [[RACObserve(detailVC, sellStatusDesc) skip:2] subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                //先改变model值
                dataModel.productSellStatusDesc = x;
                //再更新指定cell
                [UIView performWithoutAnimation:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            }];
            
            //埋点
            NSArray *sortTypeArray = @[@"综合排序", @"价格升序", @"价格降序", @"马上开拍", @"最新上架", @"即将截拍"];
            NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
            sensorsDic[@"commodity_id"] = [NSString stringWithFormat:@"%ld",dataModel.productId];
            sensorsDic[@"commodity_name"] = dataModel.productName;
            sensorsDic[@"model_type"] = self.isMallProduct.integerValue > 0 ? @"搜索结果列表" : @"搜索无结果推荐列表";
            sensorsDic[@"sort_name"] = sortTypeArray[self.sortTypeNum];
            sensorsDic[@"tab_name"] = self.titleArray[self.titleTagIndex];
            if (self.fromSource == JHSearchFromStore) {
                sensorsDic[@"page_position"] = @"商城搜索结果页";
            } else if (self.fromSource == JHSearchFromLive) {
                sensorsDic[@"page_position"] = @"直播搜索结果页";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
            
        }
        
        //直播
        else {
            JHLiveRoomMode *model = self.searchResultViewModel.searchListDataArray[indexRow];
            //crash判空处理,目前逻辑,如果异常不进直播间
            if (model.channelLocalId.length> 0) {
                [JHRootController EnterLiveRoom:model.channelLocalId fromString:JHEventOnlineauthenticate];
            }
            
            //埋点
            NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
            sensorsDic[@"channel_local_id"] = model.channelLocalId;
            sensorsDic[@"anchor_nick_name"] = model.title;
            sensorsDic[@"tab_name"] = self.titleArray[self.titleTagIndex];
            if (self.fromSource == JHSearchFromStore) {
                sensorsDic[@"page_position"] = @"商城搜索结果页";
            } else if (self.fromSource == JHSearchFromLive) {
                sensorsDic[@"page_position"] = @"直播搜索结果页";
            }
            [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:sensorsDic type:JHStatisticsTypeSensors];
        }
        
    }
    
}


#pragma - LayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    if (self.searchResultViewModel.operationDataArray.count > 0 && indexPath.row == 0 && self.titleTagIndex == 0) {
        return itemWidth*254/171;
    }else{
        NSInteger indexRow = indexPath.row;
        if (self.titleTagIndex == 0 && self.searchResultViewModel.operationDataArray.count > 0) {
            indexRow = indexPath.row-1;
        }
        JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        NSDictionary *dataDic = [dataModel mj_JSONObject];
        if ([dataDic objectForKey:@"productId"]) { //商品
            return dataModel.itemHeight;
        } else {//直播
            return itemWidth*254/171;

        }
    }
    
}
- (NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 2;
}
- (CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVFlowLayout{
    return  UIEdgeInsetsMake(10, 12, 10, 12);
}


#pragma mark - WIFI下视频自动播放
///视频自动播放
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //视频播放
    [self endScrollToPlayVideo];
    //直播拉流
    if(!decelerate){
        if (![self isRefreshing]) {
            [self pullStream];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
    //直播拉流
    if (![self isRefreshing]) {
        [self  pullStream];
    }
    if (!scrollView.decelerating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.collectionView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHNewStoreHomeGoodsCollectionViewCell class]]) {
            JHNewStoreHomeGoodsCollectionViewCell *cell = (JHNewStoreHomeGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.curData.videoUrl.length > 0 && lastCell == nil) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.imgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.imgView addSubview:self.playerController.view];
                self.playerController.urlString = cell.curData.videoUrl;
                return;
            }
        }
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
}


#pragma mark - Lazy

- (JHNewStoreSearchResultViewModel *)searchResultViewModel{
    if (!_searchResultViewModel) {
        _searchResultViewModel = [[JHNewStoreSearchResultViewModel alloc] init];
        _searchResultViewModel.titleTagIndex = self.titleTagIndex;
    }
    return _searchResultViewModel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF8F8F8);
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        [_collectionView registerClass:[JHSearchResultOperationCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHSearchResultOperationCollectionCell class])];
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];

        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.cursor = @"";
            self.isMallProduct = @"1";
            [self updateLoadData:YES];
        }];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];


    }
    return _collectionView;
}

- (JHShopHotSellConllectionViewLayout *)hotSellLayout{
    if (!_hotSellLayout) {
        _hotSellLayout = [[JHShopHotSellConllectionViewLayout alloc]init];
        _hotSellLayout.shopLayoutDelegate = self;
    }
    return _hotSellLayout;;
}
- (JHNewStoreSearchResultHeaderTagsView *)headerTagsView{
    if (!_headerTagsView) {
        _headerTagsView = [[JHNewStoreSearchResultHeaderTagsView alloc] init];
        _headerTagsView.delegate = self;
    }
    return _headerTagsView;
}

- (JHNewStoreRecommendTagsView *)recommendTagsView{
    if (!_recommendTagsView) {
        _recommendTagsView = [[JHNewStoreRecommendTagsView alloc] init];
        _recommendTagsView.recommendDelegate = self;
    }
    return _recommendTagsView;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        NSString *store_from = @"";
        if (self.fromSource == JHSearchFromStore) {
            store_from = @"商城搜索结果页";
        } else if (self.fromSource == JHSearchFromLive) {
            store_from = @"直播搜索结果页";
        }
        //收藏
        _floatView.collectGoodsBlock = ^{
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{
                @"store_from":store_from,
                @"zc_name":@"",
                @"zc_id":@""
            } type:JHStatisticsTypeSensors];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":store_from} type:JHStatisticsTypeSensors];
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

        };
    }
    return _floatView;
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

- (NSMutableArray *)uploadData{
    if (!_uploadData) {
        _uploadData = [NSMutableArray array];
    }
    return _uploadData;
}
- (void)sa_uploadData:(NSMutableArray *)array{
    NSArray *sortTypeArray = @[@"综合排序", @"价格升序", @"价格降序", @"马上开拍", @"最新上架", @"即将截拍"];
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    if (self.fromSource == JHSearchFromStore) {
        sensorsDic[@"page_position"] = @"商城搜索结果页";
    } else if (self.fromSource == JHSearchFromLive) {
        sensorsDic[@"page_position"] = @"直播搜索结果页";
    }
    sensorsDic[@"model_name"] = self.isMallProduct.integerValue > 0 ? @"搜索结果列表" : @"搜索为空推荐列表";
    sensorsDic[@"sort_name"] = sortTypeArray[self.sortTypeNum];
    sensorsDic[@"tab_name"] = self.titleArray[self.titleTagIndex];
    sensorsDic[@"key_word"] = self.keyword;
    sensorsDic[@"res_type"] = @"商品feeds";
    sensorsDic[@"item_ids"] = array;
    
    [JHTracking trackEvent:@"ep" property:sensorsDic];
}

@end

//
//  JHNewStoreLiveSearchResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreLiveSearchResultViewController.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHMallLittleCollectionViewCell.h"
#import "JHLiveRoomMode.h"
#import "YDRefreshFooter.h"

#import "JHLivePlayerManager.h"
#import "JHNewStoreSearchResultViewModel.h"


static CGFloat const RecommendTagsViewHeight = 80.f;
static CGFloat const NullDataViewHeight = 44.f;
@interface JHNewStoreLiveSearchResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, JHNewStoreRecommendTagsViewDelegate>{
    JHMallLittleCollectionViewCell *lastCell;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isShowRecommendTagsView;//是否显示推荐标签
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, strong) JHNewStoreSearchResultViewModel *searchResultViewModel;
@property (nonatomic,   copy) NSString *isMallProduct;//是否有数据
@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation JHNewStoreLiveSearchResultViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //收藏等数据刷新
    [self.floatView loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMallProduct = @"1";
    //UI
    [self setupUI];
    //列表数据请求
    [self configData];

    [self.collectionView.mj_header beginRefreshing];

}

#pragma mark - UI
- (void)setupUI{
    //推荐标签UI
    [self.view addSubview:self.recommendTagsView];
    [self.recommendTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_top).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(RecommendTagsViewHeight);
    }];
    //无数据说明文案
    [self.view addSubview:self.nullDataLabel];
    [self.nullDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendTagsView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(NullDataViewHeight);
    }];
    //列表
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendTagsView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
}
#pragma mark - LoadData
///重写父类方法
- (void)reloadSubViewData{
    [self.collectionView.mj_header beginRefreshing];
}

- (void)updateLoadData:(BOOL)isRefresh{
    self.isRefresh = isRefresh;
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"isRefresh"] = @(isRefresh);
    dicData[@"searchWord"] = self.keyword;
    dicData[@"customerId"] = [UserInfoRequestManager sharedInstance].user.customerId;
    dicData[@"searchType"] = @"4";//搜索类型 4: 直播
    dicData[@"cateId"] = @(self.cateId);//关键词分类id
    dicData[@"tagWord"] = self.searchTextfield.recommendTagsArray.count > 0 ? self.self.searchTextfield.recommendTagsArray : @[];//关键词
    [self.searchResultViewModel.searchResultCommand execute:dicData];

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

        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.searchResultViewModel.searchListDataArray.count > 4) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }

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
            //拉流
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
                make.bottom.equalTo(self.view.mas_top).offset(RecommendTagsViewHeight);
            }];

        }else{
            self.isShowRecommendTagsView = NO;
            self.recommendTagsView.tagsDataArray = @[];
            [self.recommendTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_top).offset(0);
            }];
        }
    }];
    
    
    //更多数据
    [self.searchResultViewModel.moreSearchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
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
    
    //拉流相关
    [self isBeyondArea:scrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];

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


#pragma mark - JHNewStoreRecommendTagsViewDelegate
- (void)didSelectItemOfIndex:(NSInteger)selectItem{
    JHNewSearchResultRecommendTagsListModel *tagsModel = self.searchResultViewModel.recommendDataArray[selectItem];
    NSMutableArray *tagsArray = [NSMutableArray array];
    [tagsArray addObject:tagsModel];
    self.searchTextfield.searchTagsArray = tagsArray;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchResultViewModel.searchListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHMallLittleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = self.searchResultViewModel.searchListDataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  
    JHLiveRoomMode *model = self.searchResultViewModel.searchListDataArray[indexPath.item];
    //crash判空处理,目前逻辑,如果异常不进直播间
    if (model.channelLocalId.length> 0) {
        [JHRootController EnterLiveRoom:model.channelLocalId fromString:JHEventOnlineauthenticate];
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemW = (ScreenW - 33.f) / 2. ;
    return CGSizeMake(itemW, itemW * 249. / 171.);
}

#pragma mark - Action
#pragma mark - 拉流相关
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        if (![self isRefreshing]) {
            [self pullStream];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self isRefreshing]) {
        [self  pullStream];
    }
    if (!scrollView.decelerating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
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
            if (rect.origin.y >= UI.statusAndNavBarHeight && rect.origin.y+rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49) {
                NSLog(@"搜索列表status====%@",cell.liveRoomMode.status);
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
///开始拉流
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

#pragma mark - Lazy
- (JHNewStoreSearchResultViewModel *)searchResultViewModel{
    if (!_searchResultViewModel) {
        _searchResultViewModel = [[JHNewStoreSearchResultViewModel alloc] init];
        _searchResultViewModel.titleTagIndex = self.titleTagIndex;
    }
    return _searchResultViewModel;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 9;
        layout.minimumLineSpacing = 9;
        // 设置每个分区的 上左下右 的内边距
        layout.sectionInset = UIEdgeInsetsMake(12, 12 ,12, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorF5F6FA;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self updateLoadData:YES];
        }];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    }
    return _collectionView;

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
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

        };
    }
    return _floatView;
}

@end

//
//  JHNewStoreGoodsInfoViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreGoodsInfoViewController.h"
#import "JHNewStoreHomeBusiness.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreHomeViewModel.h"
#import "UIScrollView+JHEmpty.h"
#import "JHPlayerViewController.h"
#import "YDWaterFlowLayout.h"
#import "JHRefreshGifHeader.h"
#import "JHRefreshNormalFooter.h"
#import <MJRefresh.h>
#import "YDRefreshFooter.h"
#import "JHNewStoreHomeReport.h"
#import "JHNewStoreHomeSingelton.h"

@interface JHNewStoreGoodsInfoViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
YDWaterFlowLayoutDelegate
>
@property (nonatomic, strong) NSMutableArray                        *dataSourceArray;
@property (nonatomic, assign) BOOL                                   canScroll;
@property (nonatomic, strong) JHPlayerViewController                *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;
@property (nonatomic, strong) YDWaterFlowLayout                     *gridLayout;
@property (nonatomic, assign) NSInteger                              requestPageIndex;

@property (nonatomic, strong) NSMutableArray * uploadData;
@end

@implementation JHNewStoreGoodsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self removeNavView];
//    [self getGoodsInfo];
}
- (void)viewWillDisappear:(BOOL)animated{
    if (self.uploadData.count > 0) {
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
    [super viewWillDisappear:animated];
}
- (void)setupViews {
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.height.mas_equalTo([self bottomCellHeight]);
    }];
}

- (YDWaterFlowLayout *)gridLayout {
    if (!_gridLayout) {
        _gridLayout = [[YDWaterFlowLayout alloc] init];
        _gridLayout.delegate = self;
    }
    return _gridLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
    }
    return _collectionView;
}

- (CGFloat)bottomCellHeight {
    if ([JHNewStoreHomeSingelton shared].hasBoutiqueValue) {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 45.f - 49.f - 45.f;
    } else {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 45.f - 49.f - 45.f + 40.f;
    }
}

- (void)setHasBoutiqueValue:(BOOL)hasBoutiqueValue {
    _hasBoutiqueValue = hasBoutiqueValue;
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.height.mas_equalTo([self bottomCellHeight]);
    }];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

/// 获取商品
- (void)getGoodsInfo {
    self.requestPageIndex = 1;
    [self.dataSourceArray removeAllObjects];
    [self.collectionView reloadData];
    
    self.collectionView.jh_EmputyView.hidden = YES;
    [self.collectionView jh_footerStatusWithNoMoreData:NO];
    self.collectionView.mj_footer.hidden = NO;

    
    NSString *requestTabName = (self.indexVc == 0)?@"":self.tabName;
    [JHNewStoreHomeReport shared].tabName = self.tabName;
    @weakify(self);
    [JHNewStoreHomeBusiness getGoodsListAndTab:1 pageSize:20 productType:self.requestProductType recommendTabName:requestTabName Completion:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_GoodsViewModel * _Nullable viewModel) {
        @strongify(self);
        [self endRefresh];
        if (!viewModel.productList || viewModel.productList.count == 0) {
            NSLog(@"错误页面");
            [self.collectionView jh_reloadDataWithEmputyView];
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            self.collectionView.mj_footer.hidden = YES;
            return;
        }
        NSArray *goodsIdList = [viewModel.productList jh_map:^id _Nonnull(JHNewStoreHomeGoodsProductListModel * _Nonnull obj, NSUInteger idx) {
            return [NSString stringWithFormat:@"%ld",obj.productId];
        }];
        [JHNewStoreHomeReport jhNewStoreHomeGoodsShowListReportWithTag_name:self.tabName goodsIdArr:goodsIdList];
        
        [self.dataSourceArray addObjectsFromArray:viewModel.productList];
        self.requestPageIndex ++;
        if (viewModel.productList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
        } else {
            [self.collectionView jh_footerStatusWithNoMoreData:NO];
        }
        [self.collectionView reloadData];
    }];
}

- (void)loadMoreData {
    NSString *requestTabName = (self.indexVc == 0)?@"":self.tabName;
    @weakify(self);
    [JHNewStoreHomeBusiness getGoodsListAndTab:self.requestPageIndex pageSize:20 productType:self.requestProductType recommendTabName:requestTabName Completion:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_GoodsViewModel * _Nullable viewModel) {
        @strongify(self);
        [self endRefresh];
        if (!viewModel.productList || viewModel.productList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            return;
        }
        NSArray *goodsIdList = [viewModel.productList jh_map:^id _Nonnull(JHNewStoreHomeGoodsProductListModel * _Nonnull obj, NSUInteger idx) {
            return [NSString stringWithFormat:@"%ld",obj.productId];
        }];
        [JHNewStoreHomeReport jhNewStoreHomeGoodsShowListReportWithTag_name:self.tabName goodsIdArr:goodsIdList];
        [self.dataSourceArray addObjectsFromArray:viewModel.productList];
        self.requestPageIndex ++;
        if (viewModel.productList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
        } else {
            [self.collectionView jh_footerStatusWithNoMoreData:NO];
        }
        [self.collectionView reloadData];
    }];
}

- (void)endRefresh {
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - Delegate DataSource

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"---willDisplayCell----%@",indexPath);
    if (self.dataSourceArray.count == 0) {
        return;
    }
    JHNewStoreHomeGoodsProductListModel * model = self.dataSourceArray[indexPath.item];
    NSString * strtemp = [NSString stringWithFormat:@"%@_%ld",self.tabName,model.productId];
    if (![self.uploadData containsObject:strtemp]) {
        [self.uploadData addObject:strtemp];
        if (self.uploadData.count>=10) {
            NSMutableArray * temp = [self.uploadData mutableCopy];
            [self sa_uploadData:temp];
            [self.uploadData removeAllObjects];
        }
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"---didEndDisplayingCell----%@",indexPath);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    cell.curData = self.dataSourceArray[indexPath.item];
    @weakify(self);
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(isH5, showId, boutiqueName);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsClickBlock) {
        self.goodsClickBlock(self.dataSourceArray[indexPath.item], indexPath);
    }
}


#pragma mark - private
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (void)makeDeatilDescModuleScrollToTop {
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makeDeatilDescModuleScroll:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(JHNewStoreGoodsInfoViewControllerLeaveTop)]) {
                [self.delegate JHNewStoreGoodsInfoViewControllerLeaveTop];
            }
        }
    } else {
        [self makeDeatilDescModuleScroll:NO];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self endScrollToPlayVideo];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScrollToPlayVideo];
    
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
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.curData.videoUrl.length > 0) {
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


#pragma mark -
#pragma mark - YDWaterFlowLayoutDelegate
/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeGoodsProductListModel *data = self.dataSourceArray[indexPath.item];
    return CGSizeMake((ScreenW - 12.f*2 - 9.f)/2.f, data.itemHeight);
}

///** header Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

/** footer Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

/** 列数*/
- (NSInteger)yd_numberOfColumnsInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 2;
}

/** 行间距*/
- (CGFloat)yd_spacingForRowInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 9;
}
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 9;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return UIEdgeInsetsMake(0, 10, 10, 10);
}




#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    [self.dataSourceArray removeAllObjects];
    NSLog(@"%s🔥",__func__);
}

- (NSMutableArray *)uploadData{
    if (!_uploadData) {
        _uploadData = [NSMutableArray array];
    }
    return _uploadData;
}
- (void)sa_uploadData:(NSMutableArray *)array{
    NSString *tab_name = @"全部";
    if (self.requestProductType == JHGoodManagerListRequestProductType_All) {
        tab_name = @"全部";
    }else if (self.requestProductType == JHGoodManagerListRequestProductType_Auction){
        tab_name = @"拍卖";
    }else if (self.requestProductType == JHGoodManagerListRequestProductType_OnePrice){
        tab_name = @"一口价";
    }
    [JHTracking trackEvent:@"ep" property:@{@"page_position":@"商城首页",
                                            @"model_name":@"精选商品列表",
                                            @"res_type":@"商品feeds",
                                            @"tab_name":tab_name,
                                            @"item_ids":array
    }];
}
@end

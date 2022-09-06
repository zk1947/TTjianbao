//
//  JHUserInfoGoodsController.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoGoodsController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "YDRefreshFooter.h"
#import <MJRefresh.h>
#import "JHC2CGoodsListModel.h"
#import "JHUserInfoGoodsViewModel.h"
#import "JHC2CProductDetailController.h"
#import "JHPlayerViewController.h"


@interface JHUserInfoGoodsController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHUserInfoGoodsViewModel *goodsViewModel;

@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHC2CGoodsCollectionViewCell *currentCell;//当前播放视频的cell

@end

@implementation JHUserInfoGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    //加载数据
    [self updateLoadData:YES];
    [self configData];
}

#pragma mark - UI

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"imageType"] = @"s,m,b,o";
    dicData[@"isRefresh"] = @(isRefresh);
    dicData[@"userId"] = self.userId;
    [self.goodsViewModel.userInfoGoodsCommand execute:dicData];
}

- (void)loadMoreData{
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.goodsViewModel.updateGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.goodsViewModel.goodsListDataArray.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }
    }];
    //更多数据
    [self.goodsViewModel.moreGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
    //没有更多数据
    [self.goodsViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        [self.collectionView reloadData];
    }];
    //请求出错
    [self.goodsViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Action

#pragma mark - Delegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsViewModel.goodsListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHC2CGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHC2CProductBeanListModel *dataModel = self.goodsViewModel.goodsListDataArray[indexPath.row];
    [cell bindViewModel:dataModel params:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    JHC2CProductBeanListModel *dataModel = self.goodsViewModel.goodsListDataArray[indexPath.row];
    JHC2CProductDetailController *goodsDetailVC = [[JHC2CProductDetailController alloc] init];
    goodsDetailVC.productId = dataModel.productId;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
}

#pragma flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHC2CProductBeanListModel *dataModel = self.goodsViewModel.goodsListDataArray[indexPath.row];
    return dataModel.itemHeight;
}
- (NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 2;
}
- (CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 11;
}
- (CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 11;
}
- (UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVFlowLayout{
    return UIEdgeInsetsMake(10, 11, 10, 11);
}



#pragma mark - 分页逻辑
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}


#pragma mark - WIFI下视频自动播放
///视频自动播放
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.collectionView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHC2CGoodsCollectionViewCell class]]) {
            JHC2CGoodsCollectionViewCell *cell = (JHC2CGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.goodsListModel.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.goodsImgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.goodsImgView addSubview:self.playerController.view];
                self.playerController.urlString = cell.goodsListModel.videoUrl;
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

#pragma mark - Lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorF5F6FA;
        [_collectionView registerClass:[JHC2CGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class])];

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

- (JHUserInfoGoodsViewModel *)goodsViewModel{
    if (!_goodsViewModel) {
        _goodsViewModel = [[JHUserInfoGoodsViewModel alloc] init];
    }
    return _goodsViewModel;
}


@end

//
//  JHNewStoreCollectionController.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreCollectionController.h"

#import "JHShopHotSellConllectionViewLayout.h"
#import "JHNewShopHotSellViewModel.h"
#import <MJRefresh.h>
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHPlayerViewController.h"
#import "YDRefreshFooter.h"
#import "JHStoreDetailViewController.h"

#import "JHNewStoreHomeModel.h"
#import "JHNewStoreSpecialBussinew.h"
#import "JHStoreApiManager.h"
#import "JHNewStoreSpecialDetailViewController.h"

@interface JHNewStoreCollectionController()<UICollectionViewDelegate, UICollectionViewDataSource,JHShopHotSellConllectionViewLayoutDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewShopHotSellViewModel *hotSellViewModel;
@property (nonatomic, assign) int sortTypeNum;
@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;

@property (nonatomic, strong) NSMutableArray *hotSellDataArray;

@end

@implementation JHNewStoreCollectionController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"我的收藏商城商品页"
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self refresh];
    
}

#pragma mark - LoadData

///刷新数据
- (void)refresh{

    @weakify(self);
    [JHStoreApiManager getNewMyCollectionListBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [self endRefresh];
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
            self.hotSellDataArray = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"productFollows"]];
//            [self.collectionView reloadData];
            [self.collectionView jh_reloadDataWithEmputyView];
        }
    }];

}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
}
#pragma mark  - 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.hotSellDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    if (self.hotSellDataArray) {
        cell.curData = self.hotSellDataArray[indexPath.row];
    }
    
//    cell.contentView.layer.borderWidth = 0.5f;
//    cell.contentView.layer.borderColor = HEXCOLOR(0xEDEDED).CGColor;
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.fromPage = @"商品收藏列表";
            vc.showId = showId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellDataArray[indexPath.row];
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    //埋点
    NSDictionary *sensorsDic = @{
        @"commodity_id":[NSString stringWithFormat:@"%ld",dataModel.productId],
        @"original_price":dataModel.price,
        @"model_type":@"商城商品列表",
        @"page_position":@"我的收藏商城商品页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellDataArray[indexPath.row];
    return CGSizeMake((ScreenW-24-9)/2, dataModel.itemHeight);

}

#pragma flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellDataArray[indexPath.row];
    return dataModel.itemHeight;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    
    static CGFloat lastOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
   
    lastOffsetY = offsetY;
    
//    NSString *offsetYStr = [NSString stringWithFormat:@"%f",offsetY];
//    if (self.hotSellOffsetYBlock) {
//        self.hotSellOffsetYBlock(offsetYStr);
//    }
    
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


#pragma mark - Lazy
- (JHNewShopHotSellViewModel *)hotSellViewModel{
    if (!_hotSellViewModel) {
        _hotSellViewModel = [[JHNewShopHotSellViewModel alloc] init];
    }
    return _hotSellViewModel;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorF5F6FA;
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        _collectionView.mj_header = self.refreshHeader;

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

@end

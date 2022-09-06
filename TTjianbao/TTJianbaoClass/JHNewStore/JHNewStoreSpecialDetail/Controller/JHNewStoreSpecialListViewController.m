//
//  JHNewStoreSpecialListViewController.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSpecialListViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import <MJRefresh.h>
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHPlayerViewController.h"
#import "YDRefreshFooter.h"
#import "JHStoreDetailViewController.h"

#import "JHNewStoreHomeModel.h"
#import "JHNewStoreSpecialBussinew.h"
//#import <SVProgressHUD.h>
#import "MBProgressHUD.h"
#import "UIView+JHGradient.h"

@interface JHNewStoreSpecialListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,JHShopHotSellConllectionViewLayoutDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;

@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;

@property (nonatomic, strong) NSMutableArray *hotSellDataArray;
@property (nonatomic, assign) NSInteger sortTypeNum;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pagesize;

@end

@implementation JHNewStoreSpecialListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.pagesize = 20;
    self.pageNum = 1;
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self loadFirstData:0];
    
}

#pragma mark - LoadData
///刷新数据
- (void)loadFirstData:(int)sortType{

    /*
    "showId":"long //专场id【必须】",
     "sort":"int //专场商品排序方式。0 综合排序，1 价格升序，2 价格降序
        "pageNo":"int //页码（从1开始）【必须】",
        "pageSize":"int //每页数量【必须】",
        "tabId":"long //专场tab_id，如果值是null，则为全部。【必须】"
     */
//    [SVProgressHUD show];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.pageNum = 1;
    self.sortTypeNum = sortType;
    long showid = [self.showId longValue];
    NSDictionary * params = @{@"showId":@(showid),@"tabId":@(self.specialTabId),@"sort":@(sortType),@"pageNo":@(self.pageNum),@"pageSize":@(self.pagesize)};
    @weakify(self);
    [JHNewStoreSpecialBussinew requestSpecialProductListWithParams:params successBlock:^(RequestModel * _Nullable respondObject) {
//        [SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        @strongify(self);
        self.hotSellDataArray = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        for (JHNewStoreHomeGoodsProductListModel *temp in self.hotSellDataArray) {
            temp.showName = @"";
        }
        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        if (self.hotSellDataArray.count == 0) {
            self.collectionView.mj_footer.hidden = YES;
        }
        } failureBlock:^(RequestModel * _Nullable respondObject) {
//            [SVProgressHUD dismiss];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
}
///获取更多数据
- (void)loadMoreData{
    self.pageNum ++ ;
    long showid = [self.showId longValue];
    NSDictionary * params = @{@"showId":@(showid),@"tabId":@(self.specialTabId),@"sort":@(self.sortTypeNum),@"pageNo":@(self.pageNum),@"pageSize":@(self.pagesize)};
    @weakify(self);
    [JHNewStoreSpecialBussinew requestSpecialProductListWithParams:params successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        [self.collectionView .mj_footer endRefreshing];
        NSMutableArray *hotSellDataArrayNext = [JHNewStoreHomeGoodsProductListModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        for (JHNewStoreHomeGoodsProductListModel *temp in hotSellDataArrayNext) {
            temp.showName = @"";
        }
        if (hotSellDataArrayNext.count>0) {
            [self.hotSellDataArray addObjectsFromArray:hotSellDataArrayNext];
            [self.collectionView reloadData];
        }else{
            
            [self.collectionView .mj_footer endRefreshingWithNoMoreData];
        }

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.collectionView .mj_footer endRefreshing];
        self.pageNum -- ;
    }];
    
    
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
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellDataArray[indexPath.row];
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.fromPage = @"专场列表页";
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    [self.navigationController pushViewController:detailVC animated:YES];
    //判断刷新当前商品订单 是否 解除
    @weakify(self);
    [[RACObserve(detailVC, sellStatusDesc) skip:2] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //先改变model值
        dataModel.productSellStatusDesc = x;
        //再更新指定cell
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }];
    NSString *item_id = [NSString stringWithFormat:@"%ld",dataModel.productId];
    [JHAllStatistics jh_allStatisticsWithEventId:@"zcspClick" params:@{
        @"store_from":self.store_from,
        @"zc_id":self.showId,
        @"zc_name":self.showName,
        @"item_id":NONNULL_STR(item_id)
    } type:JHStatisticsTypeSensors];
    
    [JHTracking trackEvent:@"commodityClick" property:@{
        @"page_position":self.showName,
        @"model_type":@"专场列表页",
        @"commodity_label":self.specialTabName,
        @"commodity_name":NONNULL_STR(dataModel.productName),
        @"commodity_id":NONNULL_STR(item_id)
    }];
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
    return  UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    
    static CGFloat lastOffsetY = 0;
    CGFloat offsetY = scrollView.contentOffset.y;
   
    lastOffsetY = offsetY;
    
    NSString *offsetYStr = [NSString stringWithFormat:@"%f",offsetY];
    if (self.hotSellOffsetYBlock) {
        self.hotSellOffsetYBlock(offsetYStr);
    }
    
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
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        [_collectionView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFFFFF), HEXCOLOR(0xF5F5F8)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 0.1)];
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;

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

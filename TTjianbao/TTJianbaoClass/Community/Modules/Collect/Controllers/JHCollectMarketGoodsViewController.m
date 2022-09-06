//
//  JHCollectMarketGoodsViewController.m
//  TTjianbao
//
//  Created by hao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCollectMarketGoodsViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "YDRefreshFooter.h"
#import <MJRefresh.h>
#import "JHRefreshNormalFooter.h"
#import "JHPlayerViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreSpecialDetailViewController.h"

@interface JHCollectMarketGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) NSMutableArray<JHC2CProductBeanListModel *> *productList;
@property (nonatomic, assign) NSInteger currentPageNo;
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHC2CGoodsCollectionViewCell *currentCell;//当前播放视频的cell
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentShopCell;//当前播放视频的cell
@end

@implementation JHCollectMarketGoodsViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"我的收藏商品页"
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.currentPageNo = 1;
    [self getProductsRequest];
}

#pragma mark - UI

#pragma mark - LoadData
- (void)loadMoreData {
    self.currentPageNo += 1;
    [self getProductsRequest];
}
- (void)getProductsRequest {
//    NSString *url = FILE_BASE_STRING(@"/api/mall/product/getC2cCollectionProductList");
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/getCollectionProductList");
    NSMutableDictionary *parame = [NSMutableDictionary new];
    parame[@"imageType"] = @"s,m,b,o";
    parame[@"pageNo"] = @(self.currentPageNo);
    parame[@"pageSize"] = @"20";
    [HttpRequestTool postWithURL:url Parameters:parame requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [self.collectionView.mj_header endRefreshing];

        NSDictionary *dic = respondObject.data;
        NSArray *list = [JHC2CProductBeanListModel mj_objectArrayWithKeyValuesArray:dic];
        
        if ( self.currentPageNo == 1) {
            [self.productList removeAllObjects];
            dispatch_async(dispatch_get_main_queue(),^{
                [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                //刷新完成，其他操作
                [self endScrollToPlayVideo];
            });
        }
        
        [self.productList appendObjects:list];
        [self.collectionView jh_reloadDataWithEmputyView];
        
        if (list.count <= 0) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }else {
            [self.collectionView.mj_footer endRefreshing];
        }
        //当数据超过一屏后才显示“已经到底”文案
        if (list.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        JHTOAST(respondObject.message);
    }];
}
#pragma mark - Action

#pragma mark - Delegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.productList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHC2CProductBeanListModel *dataModel = self.productList[indexPath.row];
    if (dataModel.sellerType == 0) {  //商户
        JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
        cell.goodsListModel = dataModel;
        @weakify(self);
        cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
            @strongify(self);
            if (!isH5) {
                JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
                vc.fromPage = @"收藏商品列表";
                vc.showId = showId;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
//                [JHNewStoreHomeReport jhNewStoreHomeNewPeopleClickReport:@"商品推荐列表"];
            }
        };
        return cell;
    }else {  //个人
        JHC2CGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class]) forIndexPath:indexPath];
        [cell bindViewModel:dataModel params:nil];
        
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    JHC2CProductBeanListModel *dataModel = self.productList[indexPath.row];
    if (dataModel.sellerType == 0) { //商户
        JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
        detailVC.productId = [NSString stringWithFormat:@"%@",dataModel.productId];
        [self.navigationController pushViewController:detailVC animated:YES];
        //埋点
        NSDictionary *sensorsDic = @{
            @"commodity_id":[NSString stringWithFormat:@"%@",dataModel.productId],
            @"original_price":dataModel.price,
            @"model_type":@"收藏商品列表",
            @"page_position":@"我的收藏商品页"
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
        return;
    }
    JHC2CProductDetailController *goodsDetailVC = [[JHC2CProductDetailController alloc] init];
    goodsDetailVC.productId = dataModel.productId;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    
    //埋点
    NSDictionary *sensorsDic = @{
        @"commodity_id":dataModel.productId,
        @"original_price":dataModel.price,
        @"model_type":@"收藏商品列表",
        @"page_position":@"我的收藏商品页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
}



#pragma flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHC2CProductBeanListModel *model = self.productList[indexPath.item];
    if (model.sellerType == 0) {  //商户
        return model.sellerItemHeight;
    }else {
        return model.itemHeight;
    }
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
        } else if([obj isKindOfClass:[JHNewStoreHomeGoodsCollectionViewCell class]]){
            JHNewStoreHomeGoodsCollectionViewCell *cell = (JHNewStoreHomeGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.goodsListModel.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentShopCell == cell) {
                    return;
                }
                self.currentShopCell = cell;
                self.playerController.view.frame = cell.imgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.imgView addSubview:self.playerController.view];
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
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            self.currentPageNo = 1;
            [self getProductsRequest];
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
- (NSMutableArray<JHC2CProductBeanListModel *> *)productList {
    if (!_productList) {
        _productList = [NSMutableArray array];
    }
    return _productList;
}
@end

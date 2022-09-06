//
//  JHNewShopHotSellViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopHotSellViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHNewShopHotSellViewModel.h"
#import <MJRefresh.h>
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHPlayerViewController.h"
#import "YDRefreshFooter.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "UIView+JHGradient.h"
#import "JHC2CSortMenuView.h"

@interface JHNewShopHotSellViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate, JHC2CSortMenuViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewShopHotSellViewModel *hotSellViewModel;
@property (nonatomic, assign) NSInteger sortTypeNum;
@property (nonatomic, strong) JHPlayerViewController *playerController;
///当前播放视频的cell
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;
@property (nonatomic, strong) JHC2CSortMenuView *sortMenuView;//排序view
@property (nonatomic, strong) UIButton *stopSellBtn;
@property (nonatomic, assign) NSInteger auctionStatus;
@end

@implementation JHNewShopHotSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //排序
    [self.view addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth-24, 25));
    }];
    //即将截拍
    [self.sortMenuView addSubview:self.stopSellBtn];
    [self.stopSellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortMenuView.mas_left).offset(208);
        make.centerY.equalTo(self.sortMenuView);
    }];
    if (self.selectedTitleIndex == 2 || self.shopInfoModel.productTypeTag == 0) {//一口价
        [self.stopSellBtn removeFromSuperview];
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(35, 0, 0, 0));
    }];
    //请求数据
    self.sortTypeNum = 0;
    [self updateLoadData:YES];
    [self configData];
    
}

#pragma mark - LoadData
///刷新数据
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"shopId"] = @([self.shopInfoModel.shopId longValue]);
    dicData[@"sort"] = @(self.sortTypeNum);// 排序类型: 0综合排序 1升序 2降序 3马上开拍
    dicData[@"productType"] = [NSString stringWithFormat:@"%ld",2 - self.selectedTitleIndex];//商品类型  0一口价  1拍卖  2全部
    dicData[@"auctionStatus"] = [NSString stringWithFormat:@"%ld",(long)self.auctionStatus];//即将截拍
    dicData[@"isRefresh"] = @(isRefresh);
    [self.hotSellViewModel.shopHotSellGoodCommand execute:dicData];
    
}
///获取更多数据
- (void)loadMoreData{
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.hotSellViewModel.updateShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];

        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        
        //当数据超过一屏后才显示“已经到底”文案
        if (self.hotSellViewModel.hotSellDataArray.count > 2) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }
        if ([x boolValue]) {
            dispatch_async(dispatch_get_main_queue(),^{
                //刷新完成，其他操作
                [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                [self endScrollToPlayVideo];
            });
        }
        
    }];
    //加载更多数据
    [self.hotSellViewModel.moreShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];

        [self.collectionView reloadData];

    }];
    //没有更多数据
    [self.hotSellViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.hotSellViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
    }];

}


#pragma mark - Action
///即将截拍点击事件
- (void)clickStopSellBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.titleLabel.font = sender.selected ? JHMediumFont(12) : JHFont(12);
    //即将截拍
    self.auctionStatus = sender.selected ? 1 : 0;
    [self updateLoadData:YES];
}


#pragma mark - Delegate
#pragma mark - JHC2CSortMenuViewDelegate
///价格排序筛选
- (void)menuViewDidSelect:(JHC2CSortMenuType)sortType {
    self.sortTypeNum = sortType;
    [self updateLoadData:YES];

}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.hotSellViewModel.hotSellDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    @weakify(self)
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self)
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.showId = showId;
            vc.fromPage = @"店铺商品列表页";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick" params:@{@"store_from":@"店铺首页"} type:JHStatisticsTypeSensors];
        }
    };
    if (self.hotSellViewModel.hotSellDataArray) {
        cell.curData = self.hotSellViewModel.hotSellDataArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellViewModel.hotSellDataArray[indexPath.row];
    
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    detailVC.fromPage = @"店铺页";
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
    //商品详情页点击了关注/领取优惠券后，店铺信息刷新
    [detailVC.refreshUpper subscribeNext:^(id  _Nullable x) {
        [JHNotificationCenter postNotificationName:@"kNewShopLoginSuccess" object:nil];
    }];
    
    NSDictionary *pointDic = @{
        @"page_position":self.shopInfoModel.shopName,
        @"model_type":@"店铺列表页",
        @"commodity_label":@"无",
        @"commodity_id":[NSString stringWithFormat:@"%ld",dataModel.productId],
        @"commodity_name":dataModel.productName,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:pointDic type:JHStatisticsTypeSensors];

    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellViewModel.hotSellDataArray[indexPath.row];
    return CGSizeMake((ScreenW-24-9)/2, dataModel.itemHeight);

}

#pragma mark - flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellViewModel.hotSellDataArray[indexPath.row];
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

#pragma mark - UIScrollViewDelegate
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
        [_collectionView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFFFFF), HEXCOLOR(0xF8F8F8)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 0.1)];
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
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

- (JHC2CSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        JHC2CSortMenuMode *recMode = [[JHC2CSortMenuMode alloc] init];
        recMode.title = @"综合排序";
        recMode.isShowImg = NO;
        JHC2CSortMenuMode *priceMode = [[JHC2CSortMenuMode alloc] init];
        priceMode.title = @"价格";
        priceMode.isShowImg = YES;
        JHC2CSortMenuMode *newMode = [[JHC2CSortMenuMode alloc] init];
        newMode.title = @"马上开拍";
        newMode.isShowImg = NO;
        NSArray *menuArray = @[recMode, priceMode, newMode];
        if (self.selectedTitleIndex == 2 || self.shopInfoModel.productTypeTag == 0) {//一口价
            menuArray = @[recMode, priceMode];
        }
        _sortMenuView = [[JHC2CSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray titleFont:13.0];
        _sortMenuView.delegate = self;
        _sortMenuView.selectIndex = 0;
    }
    return _sortMenuView;
}

- (UIButton *)stopSellBtn{
    if (!_stopSellBtn) {
        _stopSellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopSellBtn setTitle:@"即将截拍" forState:UIControlStateNormal];
        [_stopSellBtn setTitleColor:HEXCOLOR(0x888888) forState:UIControlStateNormal];
        [_stopSellBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateSelected];
        _stopSellBtn.titleLabel.font = JHFont(12);
        [_stopSellBtn addTarget:self action:@selector(clickStopSellBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _stopSellBtn;
}

@end

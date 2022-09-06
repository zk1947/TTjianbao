//
//  JHNewShopClassResultSubViewController.m
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopClassResultSubViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHC2CSortMenuView.h"
#import "YDRefreshFooter.h"
#import "JHPlayerViewController.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHStoreDetailViewController.h"
#import "JHNewShopHotSellViewModel.h"


@interface JHNewShopClassResultSubViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate, JHC2CSortMenuViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewShopHotSellViewModel *classResultViewModel;
@property (nonatomic, assign) NSInteger sortTypeNum;
@property (nonatomic, strong) JHPlayerViewController *playerController;
///当前播放视频的cell
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;
@property (nonatomic, strong) JHC2CSortMenuView *sortMenuView;//排序view
@property (nonatomic, strong) UIButton *stopSellBtn;
@property (nonatomic, assign) NSInteger auctionStatus;

@end

@implementation JHNewShopClassResultSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeaderView];
    
    //请求数据
    self.sortTypeNum = 0;
    [self.collectionView.mj_header beginRefreshing];
    [self configData];
}

#pragma mark - UI
- (void)setupHeaderView{
    if (self.isShowTitleTag) {
        UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xF2F2F2) addToSuperview:self.view];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.right.equalTo(self.view);
            make.height.mas_offset(0.5);
        }];
    }
   
    //排序
    [self.view addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(0);
        make.size.mas_offset(CGSizeMake(kScreenWidth-24, 44));
    }];
    //即将截拍
    [self.sortMenuView addSubview:self.stopSellBtn];
    [self.stopSellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sortMenuView.mas_left).offset(220);
        make.centerY.equalTo(self.sortMenuView);
    }];
    if (self.titleTagIndex == 2) {//一口价
        [self.stopSellBtn removeFromSuperview];
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
}


#pragma mark - LoadData
///刷新数据
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"shopId"] = @([self.shopID longValue]);
    dicData[@"sort"] = @(self.sortTypeNum);// 排序类型: 0综合排序 1升序 2降序 3马上开拍
    dicData[@"productType"] = [NSString stringWithFormat:@"%ld",2 - self.titleTagIndex];//商品类型  0一口价  1拍卖  2全部
    dicData[@"auctionStatus"] = [NSString stringWithFormat:@"%ld",(long)self.auctionStatus];//即将截拍
    dicData[@"cateId"] = [NSString stringWithFormat:@"%ld",(long)self.cateId];
    dicData[@"isRefresh"] = @(isRefresh);
    [self.classResultViewModel.shopHotSellGoodCommand execute:dicData];
}
///获取更多数据
- (void)loadMoreData{
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.classResultViewModel.updateShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];

        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        
        //当数据超过一屏后才显示“已经到底”文案
        if (self.classResultViewModel.hotSellDataArray.count > 6) {
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
    [self.classResultViewModel.moreShopSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];

        [self.collectionView reloadData];

    }];
    //没有更多数据
    [self.classResultViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.classResultViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        
    }];

}


#pragma mark - Action
///即将截拍点击事件
- (void)clickStopSellBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    sender.titleLabel.font = sender.selected ? JHMediumFont(12) : JHFont(12);
    //即将截拍
    self.auctionStatus = sender.selected ? 1 : 0;
    [self.collectionView.mj_header beginRefreshing];
}


#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - JHC2CSortMenuViewDelegate
///价格排序筛选
- (void)menuViewDidSelect:(JHC2CSortMenuType)sortType {
    self.sortTypeNum = sortType;
    [self.collectionView.mj_header beginRefreshing];

}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.classResultViewModel.hotSellDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.showId = showId;
            vc.fromPage = @"店铺商品列表页";
            [JHRootController.navigationController pushViewController:vc animated:YES];
        }else{
            [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick" params:@{@"store_from":@"店铺首页"} type:JHStatisticsTypeSensors];
        }
    };
    if (self.classResultViewModel.hotSellDataArray) {
        cell.curData = self.classResultViewModel.hotSellDataArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.classResultViewModel.hotSellDataArray[indexPath.row];
    
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    detailVC.fromPage = @"店铺页";
    [JHRootController.navigationController pushViewController:detailVC animated:YES];
    
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
  

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.classResultViewModel.hotSellDataArray[indexPath.row];
    return CGSizeMake((ScreenW-24-9)/2, dataModel.itemHeight);

}

#pragma mark - flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.classResultViewModel.hotSellDataArray[indexPath.row];
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
- (JHNewShopHotSellViewModel *)classResultViewModel{
    if (!_classResultViewModel) {
        _classResultViewModel = [[JHNewShopHotSellViewModel alloc] init];
    }
    return _classResultViewModel;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
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
        if (self.titleTagIndex == 2) {//一口价
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
        _stopSellBtn.titleLabel.font = JHFont(13);
        [_stopSellBtn addTarget:self action:@selector(clickStopSellBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _stopSellBtn;
}

@end

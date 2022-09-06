//
//  JHZeroAuctionListViewController.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHZeroAuctionListViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreHomeModel.h"
#import "YDRefreshFooter.h"
#import "UIView+JHGradient.h"
#import "MBProgressHUD.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreSpecialBussinew.h"
#import "JHPlayerViewController.h"
#import "JHZeroAuctionBusiness.h"

@interface JHZeroAuctionListViewController ()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource,JHShopHotSellConllectionViewLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;

@property (nonatomic, strong) NSMutableArray *hotSellDataArray;

@property (nonatomic, assign) NSInteger sortTypeNum;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, assign) BOOL onlyOnce;

@property (nonatomic, strong) JHZeroAuctionRequestModel *requestModel;

@property (nonatomic, strong) JHPlayerViewController *playerController;

@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;/** 当前播放视频的cell*/

@end

@implementation JHZeroAuctionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupView];
    
    [self loadData:self.requestModel completion:nil];
}

- (void)loadData:(JHZeroAuctionRequestModel *)requestModel completion:(void (^ __nullable)(BOOL finished))completion{
    if (requestModel) {
        self.requestModel = requestModel;
    }
    
    if (!_onlyOnce) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    self.pageNum = 1;
    
    //入参处理
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.pageNum) forKey:@"pageNo"];
    [param setValue:@(20) forKey:@"pageSize"];
    [param setValue:@"s,m,b,o" forKey:@"imageType"];
    if (self.requestModel.priceSortFlag != -1) {
        if (!_onlyOnce) {
            [param setValue:@(0) forKey:@"priceSortFlag"];
            _onlyOnce = YES;
        }else{
            if (self.requestModel.priceSortFlag == 3) {
                [param setValue:@(1) forKey:@"prepareStartAuction"];
            }else if (self.requestModel.priceSortFlag == 0){
                [param setValue:@(1) forKey:@"closingEndAuction"];
            }else{
                [param setValue:@(self.requestModel.priceSortFlag-1) forKey:@"priceSortFlag"];
            }
        }
    }
    if (self.requestModel.frontFirstCategoryId && self.requestModel.frontFirstCategoryId != -1) {
        [param setValue:@(self.requestModel.frontFirstCategoryId) forKey:@"frontFirstCategoryId"];
    }
    if (self.requestModel.frontSecondCategoryId && self.requestModel.frontSecondCategoryId != -1) {
        [param setValue:@(self.requestModel.frontSecondCategoryId) forKey:@"frontSecondCategoryId"];
    }
    if (self.requestModel.frontThirdCategoryId && self.requestModel.frontThirdCategoryId != -1) {
        [param setValue:@(self.requestModel.frontThirdCategoryId) forKey:@"frontThirdCategoryId"];
    }
    if (self.requestModel.startPrice && self.requestModel.startPrice != -1) {
        [param setValue:@(self.requestModel.startPrice) forKey:@"startPrice"];
    }
    if (self.requestModel.endPrice && self.requestModel.endPrice != -1) {
        [param setValue:@(self.requestModel.endPrice) forKey:@"endPrice"];
    }
    
    @weakify(self);
    [JHZeroAuctionBusiness loadStealTowerListData:param completion:^(NSError * _Nullable error, JHZeroAuctionModel * _Nonnull model) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (completion) {
            completion(YES);
        }
        if (!model.zeroAuctionProductPageResult.resultList || model.zeroAuctionProductPageResult.resultList.count == 0) {
            [self.hotSellDataArray removeAllObjects];
            [self.collectionView reloadData];
            [self.collectionView jh_reloadDataWithEmputyView];
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            self.collectionView.mj_footer.hidden = YES;
            if (self.haveDataBlock) {
              self.haveDataBlock(YES,model);
            }
            return;
        }
        [self.hotSellDataArray removeAllObjects];
        [self.hotSellDataArray addObjectsFromArray:model.zeroAuctionProductPageResult.resultList];
        [self.collectionView jh_footerStatusWithNoMoreData:NO];
        self.collectionView.mj_footer.hidden = NO;
        [self.collectionView jh_reloadDataWithEmputyView];
//        [self.collectionView reloadData];
        if (self.haveDataBlock) {
            BOOL noData = self.hotSellDataArray.count > 2 ? NO : YES;
            self.haveDataBlock(noData,model);
        }
        [self performSelector:@selector(startPlayVideo) afterDelay:1.0];
    }];
}

- (void)startPlayVideo{
    [self endScrollToPlayVideo];
}

- (void)loadMoreData{
    self.pageNum++;
    //入参处理
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.pageNum) forKey:@"pageNo"];
    [param setValue:@(20) forKey:@"pageSize"];
    [param setValue:@"s,m,b,o" forKey:@"imageType"];
    if (self.requestModel.priceSortFlag && self.requestModel.priceSortFlag != -1) {
        if (self.requestModel.priceSortFlag == 3) {
            [param setValue:@(1) forKey:@"prepareStartAuction"];
        }else if (self.requestModel.priceSortFlag == 0){
            [param setValue:@(1) forKey:@"closingEndAuction"];
        }else{
            [param setValue:@(self.requestModel.priceSortFlag-1) forKey:@"priceSortFlag"];
        }
//        [param setValue:@(self.requestModel.priceSortFlag-1) forKey:@"priceSortFlag"];
    }
    if (self.requestModel.frontFirstCategoryId && self.requestModel.frontFirstCategoryId != -1) {
        [param setValue:@(self.requestModel.frontFirstCategoryId) forKey:@"frontFirstCategoryId"];
    }
    if (self.requestModel.frontSecondCategoryId && self.requestModel.frontSecondCategoryId != -1) {
        [param setValue:@(self.requestModel.frontSecondCategoryId) forKey:@"frontSecondCategoryId"];
    }
    if (self.requestModel.frontThirdCategoryId && self.requestModel.frontThirdCategoryId != -1) {
        [param setValue:@(self.requestModel.frontThirdCategoryId) forKey:@"frontThirdCategoryId"];
    }
    if (self.requestModel.startPrice && self.requestModel.startPrice != -1) {
        [param setValue:@(self.requestModel.startPrice) forKey:@"startPrice"];
    }
    if (self.requestModel.endPrice && self.requestModel.endPrice != -1) {
        [param setValue:@(self.requestModel.endPrice) forKey:@"endPrice"];
    }
    
    @weakify(self);
    [JHZeroAuctionBusiness loadStealTowerListData:param completion:^(NSError * _Nullable error, JHZeroAuctionModel * _Nonnull model) {
        @strongify(self);
        [self.collectionView.mj_footer endRefreshing];
        if (!model.zeroAuctionProductPageResult.resultList || model.zeroAuctionProductPageResult.resultList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
            return;
        }
        [self.hotSellDataArray addObjectsFromArray:model.zeroAuctionProductPageResult.resultList];
        [self.collectionView reloadData];
    }];
}

- (void)setupView{
    //列表
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}

#pragma mark  - 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makeDeatilDescModuleScroll:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(JHStealTowerListViewControllerLeaveTop)]) {
                [self.delegate JHStealTowerListViewControllerLeaveTop];
            }
        }
    } else {
        [self makeDeatilDescModuleScroll:NO];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotSellDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    if (self.hotSellDataArray) {
        cell.curData = self.hotSellDataArray[indexPath.row];
    }
    @weakify(self);
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if ([showId isEqualToString:@"-1"]) {//拍卖倒计时结束删除本地数据
            if (cell.curData.auctionStatus == 0) {
                JHNewStoreHomeGoodsProductListModel *model = self.hotSellDataArray[indexPath.row];
                __block JHNewStoreHomeGoodsCollectionViewCell *curentCell = cell;
                [self reloadCellData:model curCell:curentCell];
            }else{
                [self.hotSellDataArray removeObjectAtIndex:indexPath.row];
                [self.collectionView reloadData];
            }
        }else{
            if (self.goToBoutiqueDetailClickBlock) {
                self.goToBoutiqueDetailClickBlock(isH5,showId,boutiqueName);
            }
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHNewStoreHomeGoodsProductListModel *dataModel = self.hotSellDataArray[indexPath.row];
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.fromPage = @"专场列表页";
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    [[self navVc] pushViewController:detailVC animated:YES];
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
//    NSString *item_id = [NSString stringWithFormat:@"%ld",dataModel.productId];
//    [JHAllStatistics jh_allStatisticsWithEventId:@"zcspClick" params:@{
//        @"store_from":self.store_from,
//        @"zc_id":self.showId,
//        @"zc_name":self.showName,
//        @"item_id":NONNULL_STR(item_id)
//    } type:JHStatisticsTypeSensors];
//
//    [JHTracking trackEvent:@"commodityClick" property:@{
//        @"page_position":self.showName,
//        @"model_type":@"专场列表页",
//        @"commodity_label":self.specialTabName,
//        @"commodity_name":NONNULL_STR(dataModel.productName),
//        @"commodity_id":NONNULL_STR(item_id)
//    }];
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
    return  UIEdgeInsetsMake(0, 12, 12, 12);
}

- (UINavigationController *)navVc{
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isKindOfClass:[UINavigationController class]] && nextResponder != nil) {
        nextResponder = nextResponder.nextResponder;
    }
    return (UINavigationController *)nextResponder;
}

#pragma mark - Lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        _collectionView.tag = 2022;
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
    return _hotSellLayout;
}

- (NSMutableArray *)hotSellDataArray{
    if (!_hotSellDataArray) {
        _hotSellDataArray = [NSMutableArray array];
    }
    return _hotSellDataArray;
}

- (JHZeroAuctionRequestModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [JHZeroAuctionRequestModel new];
    }
    return _requestModel;
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

- (void)reloadCellData:(JHNewStoreHomeGoodsProductListModel *)model curCell:(JHNewStoreHomeGoodsCollectionViewCell *)cell {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@"s,m,b,o" forKey:@"imageType"];
    [param setObject:@(model.productId) forKey:@"productId"];
//    @weakify(self);
    [JHZeroAuctionBusiness loadCellData:param completion:^(NSError * _Nullable error, JHNewStoreHomeGoodsProductListModel * _Nonnull model) {
//        @strongify(self);
        //刷单条
        cell.curData = model;
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JHStoreCollectionController.m
//  TTjianbao
//
//  Created by wuyd on 2020/1/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreCollectionController.h"
#import "YDWaterFlowLayout.h" 
#import "JHStoreCollectionGridCCell.h"
#import "JHStoreCollectionListCCell.h"
#import "JHStoreApiManager.h"
#import "JHGoodsDetailViewController.h"
#import "JHShopHomeController.h"
#import "GrowingManager.h"

#import "JHGoodsBrowseManager.h"
#import "JHBuryPointOperator.h"


@interface JHStoreCollectionController () <UICollectionViewDelegate, UICollectionViewDataSource, YDWaterFlowLayoutDelegate>

@property (nonatomic, strong) CStoreCollectionModel *curModel;
@property (nonatomic, assign) BOOL isListLayout;
@property (nonatomic, strong) YDWaterFlowLayout *gridLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHGoodsBrowseManager *browseManager;

@end

@implementation JHStoreCollectionController

-(JHGoodsBrowseManager *)browseManager {
    if (!_browseManager) {
        _browseManager = [[JHGoodsBrowseManager alloc] init];
        _browseManager.entryType = JHFromStoreCollectionList;  ///收藏
    }
    return _browseManager;
}

#pragma mark -
#pragma mark - Life Cycle

- (void)dealloc {
    NSLog(@">>>> [%@] - dealloc", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    _isListLayout = NO;
    _curModel = [[CStoreCollectionModel alloc] init];
    
   // [self configNaviBar];
    [self configCollectionView];
    
    [self sendRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)rightBtnClicked {
    _isListLayout = !_isListLayout;
    self.view.backgroundColor = _isListLayout ? [UIColor whiteColor] : [UIColor colorWithHexString:@"F5F6FA"];
    NSString *rightImgName = _isListLayout ? @"navi_icon_layout_list" : @"navi_icon_layout_grid";
    self.naviBar.rightImage = [UIImage imageNamed:rightImgName];
    
    [_collectionView reloadData];
}


#pragma mark -
#pragma mark - UI Methods

- (void)configNaviBar {
    [self showNaviBar];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.title = @"我的收藏";
    self.naviBar.leftImage = kNavBackBlackImg;
    
    NSString *rightImgName = _isListLayout ? @"navi_icon_layout_list" : @"navi_icon_layout_grid";
    self.naviBar.rightImage = [UIImage imageNamed:rightImgName];
    self.naviBar.bottomLine.hidden = NO;
}

- (void)configCollectionView {
    _gridLayout = [[YDWaterFlowLayout alloc] init];
    _gridLayout.delegate = self;
    
    _collectionView = ({
        UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
        ccView.backgroundColor = [UIColor clearColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        ccView.alwaysBounceVertical = YES;
        ccView.showsVerticalScrollIndicator = YES;
        //ccView.alwaysBounceHorizontal = YES;
        //ccView.showsHorizontalScrollIndicator = NO;
        ccView.userInteractionEnabled = YES;
        [ccView registerClass:[JHStoreCollectionGridCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreCollectionGridCCell];
        [ccView registerClass:[JHStoreCollectionListCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreCollectionListCCell];
        [self.view addSubview:ccView];
        ccView.mj_header = self.refreshHeader;
        ccView.mj_footer = self.refreshFooter;
        ccView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        ccView;
    });
}

#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    ///刷新前上报
//    [self.browseManager uploadRecordBeforeRefresh];
    
    _curModel.willLoadMore = NO;
    
    [self sendRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)sendRequest {
    if (_curModel.isLoading) return;
    if (_curModel.isFirstReq && _curModel.list.count == 0) {
        [self.view beginLoading];
    }
    
    @weakify(self);
    [JHStoreApiManager getMyCollectionList:_curModel block:^(CStoreCollectionModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.view endLoading];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.collectionView reloadData];

            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        
        [self.view configBlankType:YDBlankTypeNoCollectionList hasData:_curModel.list.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {
            //[self refresh];
        }];
    }];
}


#pragma mark -
#pragma mark - 页面跳转
//进入商品详情
- (void)enterGoodsDetailVCWithGoodsId:(NSString *)goodsId originalGoodsId:(NSString *)originalGoodsId {
    JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
    vc.goods_id = goodsId;
    vc.entry_type = JHFromStoreCollectionList;///商品收藏
    vc.entry_id = @"0";
    [self.navigationController pushViewController:vc animated:YES];
}

//进入店铺主页
- (void)enterShopHomeVCWithSellerId:(NSInteger)sellerId {
    JHShopHomeController *vc = [JHShopHomeController new];
    vc.sellerId = sellerId;
    [self.navigationController pushViewController:vc animated:YES];
    
    //埋点
    [self GIOEnterShopPage:@(sellerId)];
}

//埋点：进入店铺
- (void)GIOEnterShopPage:(NSNumber *)sellerId {
    [GrowingManager enterShopHomePage:@{@"shopId" : sellerId,
                                        @"from" : JHFromStoreCollectionList
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _curModel.list.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(kScreenWidth, [JHStoreCollectionGridCCell cellHeight]);
//}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isListLayout) { //列表布局
        JHStoreCollectionListCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHStoreCollectionListCCell forIndexPath:indexPath];
        
        ccell.curData = _curModel.list[indexPath.item];
        @weakify(self);
        ccell.didSelectedBlock = ^(CStoreCollectionData * _Nonnull data) {
            @strongify(self);
            [self enterGoodsDetailVCWithGoodsId:data.goods_id originalGoodsId:data.original_goods_id];
        };
        ccell.didClickShopBlock = ^(CStoreCollectionData * _Nonnull data) {
            @strongify(self);
            [self enterShopHomeVCWithSellerId:data.seller_id];
        };
        return ccell;
        
    } else { //网格布局
        JHStoreCollectionGridCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHStoreCollectionGridCCell forIndexPath:indexPath];
        
        ccell.curData = _curModel.list[indexPath.item];
        @weakify(self);
        ccell.didSelectedBlock = ^(CStoreCollectionData * _Nonnull data) {
            @strongify(self);
            [self enterGoodsDetailVCWithGoodsId:data.goods_id originalGoodsId:data.original_goods_id];
        };
        return ccell;
    }
}

//返回头脚视图
/**
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected section：%ld，item：%ld", indexPath.section, indexPath.item);
}
*/

#pragma mark -
#pragma mark - YDWaterFlowLayoutDelegate

/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CStoreCollectionData *data = _curModel.list[indexPath.item];
    if (_isListLayout) {
        return CGSizeMake(kScreenWidth, [JHStoreCollectionListCCell cellHeight]);
    } else {
        return CGSizeMake((kScreenWidth-25)/2, data.imgHeight + 85);
    }
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
    return _isListLayout ? 1 : 2;
}

/** 行间距*/
- (CGFloat)yd_spacingForRowInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return _isListLayout ? 0 : 5;
}
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return _isListLayout ? 0 : 5;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return _isListLayout ? UIEdgeInsetsZero : UIEdgeInsetsMake(10, 10, 0, 10);
}


#pragma mark -
#pragma mark - 浏览商品埋点相关

///离开页面时上报
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///关闭页面前上报
    [self.browseManager uploadRecoredBeforeClose];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_curModel.list.count == 0) {
        return;
    }

    CStoreCollectionData *data = _curModel.list[indexPath.item];
    if (data.goods_id == 0) {
        return;
    }
    //[self.browseManager addGoodsItem:data.goods_id];
    [self.browseManager addGoodsItem:data.original_goods_id];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_curModel.list.count == 0) {
        return;
    }

    //比较该cell是否出现超过限制
    if (indexPath.item < _curModel.list.count) {
        CStoreCollectionData *goodInfo = _curModel.list[indexPath.item];
        //[self.browseManager removeGoodsItem:goodInfo.goods_id];
        [self.browseManager removeGoodsItem:goodInfo.original_goods_id];
    }
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end

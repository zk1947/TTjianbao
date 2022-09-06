//
//  JHShopWindowController.m
//  TTjianbao
//
//  Created by wuyd on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHShopWindowController.h"
#import "FJWaterfallFlowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHShopWindowReusableView.h"
#import "JHGoodsDetailViewController.h"

#import "JHShopWindowListModel.h"
#import "JHStoreApiManager.h"
#import "PanNavigationController.h"
#import "MJRefresh.h"
#import "UMengManager.h"
#import "YDCountDownManager.h"

#import "JHBuryPointOperator.h"
#import "JHGoodsBrowseManager.h"

#define kHeaderDefaultH UI.statusAndNavBarHeight + 80

@interface JHShopWindowController ()
<
UICollectionViewDelegate, UICollectionViewDataSource,
FJWaterfallFlowLayoutDelegate
>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) JHShopWindowListModel *curModel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHGoodsBrowseManager *browseManager;

@end

@implementation JHShopWindowController

- (void)dealloc {
    NSLog(@"JHShopWindowController::dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _curModel = [[JHShopWindowListModel alloc] init];
    _curModel.sc_id = _showcaseId;
    _curModel.tag_id = _tagId;
    _curModel.sort = _sortType; //默认0
    
    [self addCollectionView];
    
    [self sendRequest];
    
    //倒计时相关 - 启动倒计时管理器
    [kCountDownManager startTimer];
    
//    [JHGrowingIO trackEventId:JHTrackMarketSaleTopicListIn from:self.fromSource];
//    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//    if(self.fromSource)
//    {
//        [dic setObject:self.fromSource forKey:@"from"];
//    }
//    if(self.topicName)
//    {
//        [dic setObject:self.topicName forKey:@"title"];//TODO？？？topicName
//    }
//    if([dic allKeys] > 0)
//    {
//        [JHGrowingIO trackEventId:JHTrackMarketSaleTopicListIn variables:dic];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = YES; //禁止全屏侧滑
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //将要离开页面 上报满足条件的数据 关闭定时器
    [self.browseManager uploadRecoredBeforeClose];
    
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = NO; //开启右滑返回功能
}

#pragma mark - UI

- (void)addCollectionView {
    FJWaterfallFlowLayout *flowlayout = [[FJWaterfallFlowLayout alloc] init];
    flowlayout.itemSpacing = 5;
    flowlayout.lineSpacing = 5;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    flowlayout.colCount = 2;
    flowlayout.delegate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowlayout];
    _collectionView.backgroundColor = kColorF5F6FA;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:@"JHShopWindowCollectionCell"];
    
    [_collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader"];

    ///背景色为灰色 带白色下左右圆角的footer
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionFooter"];
    
    //_collectionView.mj_header = self.refreshHeader;
    _collectionView.mj_footer = self.refreshFooter;
    [self.view addSubview:_collectionView];
    
    _collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0));
}

- (void)refreshWithSort:(JHMenuSortType)sort {
    _curModel.sort = sort;
    [self refresh];
}

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    //刷新之前上报数据
    [self.browseManager uploadRecordBeforeRefresh];
    
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
    //[self.collectionView.mj_header endRefreshing];
    [self.refreshFooter endRefreshing];
}

- (void)sendRequest {
    if (_curModel.isLoading) return;
    
    @weakify(self);
    [JHStoreApiManager getWindowList:_curModel block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
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
        
        [self.view configBlankType:YDBlankTypeNoShopWindowList hasData:_curModel.goodsList.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {
            //[self refresh];
        }];
    }];
}

#pragma mark -
#pragma mark - collectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _curModel.layoutList.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    JHShopWindowLayout *layout = _curModel.layoutList[indexPath.item];
    return layout.cellHeight;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kScreenWidth, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeader" forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        return header;
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"collectionFooter" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHShopWindowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHShopWindowCollectionCell" forIndexPath:indexPath];
    cell.layout = _curModel.layoutList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHShopWindowLayout *layout = _curModel.layoutList[indexPath.item];
    JHGoodsInfoMode *data = layout.goodsInfo;
    JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
    vc.goods_id = data.goods_id;
    vc.entry_type = JHFromStoreShopWindowPage; ///商城专题页面
    vc.entry_id = @(_showcaseId).stringValue; //入口id传橱窗id
    vc.isFromShopWindow = YES;
    vc.shopWindowId = _showcaseId; //橱窗id
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark - 浏览商品埋点相关

- (JHGoodsBrowseManager *)browseManager {
    if (!_browseManager) {
        _browseManager = [[JHGoodsBrowseManager alloc] init];
        _browseManager.entryType = JHFromStoreShopWindowPage;  ///橱窗页面
    }
    return _browseManager;
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_curModel.layoutList.count == 0) {
        return;
    }
    ///item即将进入屏幕 需要统计进入屏幕的数据
    JHShopWindowLayout *layout = _curModel.layoutList[indexPath.item];
    JHGoodsInfoMode *data = layout.goodsInfo;
    if (data.goods_id == 0) {
        return;
    }
    //[self.browseManager addGoodsItem:data.goods_id];
    [self.browseManager addGoodsItem:data.original_goods_id];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_curModel.layoutList.count == 0) {
        return;
    }

    if (indexPath.item < _curModel.layoutList.count) {
        JHGoodsInfoMode *goodInfo = [_curModel.layoutList[indexPath.item] goodsInfo];
        //[self.browseManager removeGoodsItem:goodInfo.goods_id];
        [self.browseManager removeGoodsItem:goodInfo.original_goods_id];
    }
}


#pragma mark -
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

- (void)listWillAppear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
    
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = YES; //禁止全屏侧滑
}

//- (void)listDidAppear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
//}

- (void)listWillDisappear {
    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = YES; //禁止全屏侧滑
}

//- (void)listDidDisappear {
//    NSLog(@"%@:%@", self.title, NSStringFromSelector(_cmd));
//}

@end

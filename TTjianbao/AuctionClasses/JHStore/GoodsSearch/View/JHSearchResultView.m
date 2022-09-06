//
//  JHSearchResultView.m
//  TTjianbao
//
//  Created by LiHui on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSearchResultView.h"
#import "JHSortMenuView.h"
#import "YDWaterFlowLayout.h"
#import "JHStoreCollectionGridCCell.h"
#import "JHStoreCollectionListCCell.h"
#import "JHShopHomeController.h"
#import "JHGoodsDetailViewController.h"
#import "CStoreCollectionModel.h"
#import "JHStoreApiManager.h"
#import "CSearchKeyModel.h"
#import "GrowingManager.h"
#import "JHBuryPointOperator.h"

@interface JHSearchResultView ()<JHSortMenuViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, YDWaterFlowLayoutDelegate>

@property (nonatomic, strong) JHSortMenuView *sortMenuView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isListLayout;
@property (nonatomic, strong) CStoreCollectionModel *curModel;
@property (nonatomic, copy) NSArray *hotList;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, assign) JHMenuSortType sortType;
@property (nonatomic, assign) BOOL isEdit; ///记录在该页面搜索框是否有搜索行为
@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

@end

@implementation JHSearchResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorF5F6FA;
        _isListLayout = NO;
        _isEdit = NO;
        _sortType = JHMenuSortTypeRecommend;
        _curModel = [[CStoreCollectionModel alloc] init];
        [self addSortMenu];
        [self configCollectionView];
    }
    return self;
}

#pragma mark -
#pragma mark - UI
- (void)configCollectionView {
    _collectionView = ({
        YDWaterFlowLayout *flowLayout = [[YDWaterFlowLayout alloc] init];
        flowLayout.delegate = self;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, kScreenWidth, kScreenHeight-UI.statusAndNavBarHeight-UI.bottomSafeAreaHeight) collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.alwaysBounceVertical = YES;
        [collectionView registerClass:[JHStoreCollectionGridCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreCollectionGridCCell];
        [collectionView registerClass:[JHStoreCollectionListCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreCollectionListCCell];
        collectionView.mj_header = self.refreshHeader;
        collectionView.mj_footer = self.refreshFooter;
        collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        collectionView;
    });
    
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sortMenuView.mas_bottom).offset(1);
        make.left.right.equalTo(self);
        make.bottom.mas_equalTo(-UI.bottomSafeAreaHeight);
    }];
}
///添加排序按钮
- (void)addSortMenu {
    JHMenuMode *recMode = [[JHMenuMode alloc] init];
    recMode.title = @"全部";
    recMode.isShowImg = NO;
    
    JHMenuMode *timeMode = [[JHMenuMode alloc] init];
    timeMode.title = @"上新时间";
    timeMode.isShowImg = NO;
    
    JHMenuMode *priceMode = [[JHMenuMode alloc] init];
    priceMode.title = @"价格";
    priceMode.isShowImg = YES;
    
    NSArray *menuArray = @[recMode, timeMode, priceMode];
    _sortMenuView = [[JHSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray];
    _sortMenuView.delegate = self;
    _sortMenuView.selectIndex = 0;
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setImage:[UIImage imageNamed:@"navi_icon_layout_grid"] forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"navi_icon_layout_list"] forState:UIControlStateSelected];
    changeBtn.selected = _isListLayout;
    [changeBtn addTarget:self action:@selector(changeListStyle) forControlEvents:UIControlEventTouchUpInside];
    _changeButton = changeBtn;
    
    [self addSubview:_sortMenuView];
    [_sortMenuView addSubview:changeBtn];
    
    [_sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@44);
    }];
    
    [_changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sortMenuView).offset(-15);
        make.top.bottom.equalTo(self.sortMenuView);
        make.width.mas_equalTo(20);
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _curModel.list.count;
}

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
            [self clickGoodsTrack:data indexPath:indexPath];
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
            [self clickGoodsTrack:data indexPath:indexPath];
        };
        return ccell;
    }
}

- (void)clickGoodsTrack:(CStoreCollectionData *)data indexPath:(NSIndexPath *)indexPath {
    ///369神策埋点:点击搜索结果
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(indexPath.item) forKey:@"position_sort"];
    [params setValue:@"商品" forKey:@"resources_type"];
    [params setValue:data.goods_id forKey:@"resources_id"];
    [params setValue:data.name forKey:@"resources_name"];
    NSString *marketPrice = [data.market_price substringFromIndex:1];
    NSString *oriPrice = [data.orig_price substringFromIndex:1];
    [params setValue:[NSNumber numberWithString:marketPrice] forKey:@"resources_price"];
    [params setValue:[NSNumber numberWithString:oriPrice] forKey:@"resources_original_price"];
    [params setValue:self.keyword forKey:@"key_word"];
    [JHTracking trackEvent:@"searchResultClick" property:params];
}

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

///切换列表风格
- (void)changeListStyle {
    _isListLayout = !_isListLayout;
    _changeButton.selected = _isListLayout;
    [_collectionView reloadData];
}

#pragma mark -
#pragma mark - 页面跳转
//进入商品详情
- (void)enterGoodsDetailVCWithGoodsId:(NSString *)goodsId originalGoodsId:(NSString *)originalGoodsId {
    
    JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
    vc.goods_id = goodsId;
    vc.entry_type = _isFromSQ ? JHFromSQSearchResult : JHFromStoreSearchResult;  ///商城搜索结果页面
    vc.entry_id = @"0"; //入口id传0
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
    ///搜索结果页商品点击埋点
    [GrowingManager clickSearchResultGoods:@{@"goods_id":originalGoodsId,
                                             @"searchKey":self.keyword
    }];
    
    if(self.keyword)
    {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:originalGoodsId forKey:@"item_id"];
        [param setValue:self.keyword forKey:@"query_word"];
        [JHBuryPointOperator buryWithEventId:@"search_shop_click" param:param];
    }
}

//进入店铺主页
- (void)enterShopHomeVCWithSellerId:(NSInteger)sellerId {
    ///进入店铺事件埋点
    [GrowingManager enterShopHomePage:@{@"shopId" : @(sellerId),
                                        @"from" : JHFromStoreSearchResult
    }];
    
    JHShopHomeController *vc = [JHShopHomeController new];
    vc.sellerId = sellerId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

#pragma mark - menu delegate
- (void)menuViewDidSelect:(JHMenuSortType)sortType {
    _sortType = sortType;
    ///请求数据
    [self refresh];
}

#pragma mark -
#pragma mark - 网络请求
- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
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
        [self beginLoading];
    }
    @weakify(self);
    
    [JHStoreApiManager getSearchResult:_curModel Keyword:self.keyword searchKey:self.showKeyword sortType:_sortType block:^(id  _Nullable respObj, BOOL hasError) {
        [self endLoading];
        [self endRefresh];
        
        @strongify(self);
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.collectionView reloadData];
            
            BOOL hasData = NO;
            if (self.curModel.canLoadMore) {
                hasData = YES;
                [self.collectionView.mj_footer endRefreshing];
            } else {
                hasData = NO;
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            ///369神策埋点:发送搜索请求
            [self sendSearchRequest:hasData];

        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
        [self configBlankType:YDBlankTypeNoSearchResult hasData:self.curModel.list.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {
            [self refresh];
        }];
    }];
}

- (void)sendSearchRequest:(BOOL)hasResult {
    ///369神策埋点:发送搜索请求
    [JHTracking trackEvent:@"sendSearchRequest" property:@{@"has_result":@(hasResult), @"key_word":self.keyword, @"key_word_source":self.keywordSource}];
}

#pragma mark -
#pragma mark - TableView Refresh M

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = NO;
    }
    return _refreshHeader;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

#pragma mark -
#pragma mark - setting/getting method
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
}

- (void)setShowKeyword:(NSString *)showKeyword {
    _showKeyword = showKeyword;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.hideKeyBoardBlock) {
        self.hideKeyBoardBlock();
    }
}


#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_curModel.list.count == 0) {
        return;
    }

    CStoreCollectionData *data = _curModel.list[indexPath.item];
    if (data.goods_id == 0) {
        return;
    }
    if(self.disPlayDataIdBlock) {
        self.disPlayDataIdBlock(data.original_goods_id);
    }
}

@end

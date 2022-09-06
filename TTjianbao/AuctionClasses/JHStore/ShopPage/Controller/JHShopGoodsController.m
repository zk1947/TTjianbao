//
//  JHShopGoodsController.m
//  TTjianbao
//
//  Created by apple on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopGoodsController.h"
#import "FJWaterfallFlowLayout.h"
#import "JHShopWindowCollectionCell.h"
#import "JHGoodsInfoMode.h"
#import <MJExtension/MJExtension.h>
#import "JHGoodsDetailViewController.h"
#import "YYControl.h"
#import "YDCountDownManager.h"
#import "UIView+Blank.h"
#import "JHSortMenuView.h"
#import "JHBuryPointOperator.h"
#import "JHGoodsBrowseManager.h"

@interface JHShopGoodsController ()<UICollectionViewDelegate,UICollectionViewDataSource,FJWaterfallFlowLayoutDelegate, UIScrollViewDelegate,JHSortMenuViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic ,assign) NSInteger pageNumber;
@property (nonatomic, strong) NSMutableArray *layouts;
@property (nonatomic, strong) JHSortMenuView *sortMenuView;
@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, strong) JHGoodsBrowseManager *browseManager;

@end

@implementation JHShopGoodsController

-(JHGoodsBrowseManager *)browseManager {
    if (!_browseManager) {
        _browseManager = [[JHGoodsBrowseManager alloc] init];
        _browseManager.entryType = JHFromStoreShopHomePage;  ///店铺主页
    }
    return _browseManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sortType = 0;  ///默认0推荐 1时间  2价格
    _layouts = [NSMutableArray array];
        
    //倒计时相关 - 启动倒计时管理器
    [kCountDownManager startTimer];
    [self addSortMenu];
    [self addCollectionView];
    [self firstRequest];
}

- (void)firstRequest {
    self.pageNumber = 1;
    [self loadData:YES];
}

- (void)addCollectionView {
    FJWaterfallFlowLayout *flowlayout = [[FJWaterfallFlowLayout alloc] init];
    flowlayout.itemSpacing = 5;
    flowlayout.lineSpacing = 5;
    flowlayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowlayout.colCount = 2;
    flowlayout.delegate = self;
 
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:flowlayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = HEXCOLOR(0xF7F7F7);
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = NO;
    [_collectionView registerClass:[JHShopWindowCollectionCell class]  forCellWithReuseIdentifier:@"JHShopWindowCollectionCell"];
    _collectionView.contentOffset = CGPointZero;
    [self.view addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.sortMenuView.mas_bottom).offset(1);
    }];
    
    JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
     _collectionView.mj_header = header;

    JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    _collectionView.mj_footer = footer;
    
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
    [self.view addSubview:_sortMenuView];
    
    [_sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@44);
    }];
}

#pragma mark - menu delegate
- (void)menuViewDidSelect:(JHMenuSortType)sortType {
    NSLog(@"selectIndex:---- %ld", (long)sortType);
    _sortType = sortType;
    [self refreshData];
}

#pragma mark - UICollectionViewDatasource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"JHShopWindowCollectionCell";
    JHShopWindowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    cell.layout = _layouts[indexPath.item];
    JH_WEAK(self)
    cell.countDownEndBlock = ^(JHShopWindowLayout * _Nonnull layput) {
        JH_STRONG(self)
        ///删除对应的商品的倒计时source
        [kCountDownManager removeTimerSourceWithId:layput.goodsInfo.timerSourceIdentifier];
        [self.layouts removeObject:layput];
        [collectionView reloadData];
    };
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.layouts.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHShopWindowLayout *layout = self.layouts[indexPath.item];
    JHGoodsInfoMode *goodInfo = layout.goodsInfo;
    JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
    vc.goods_id = goodInfo.goods_id;
    vc.entry_type = JHFromStoreShopHomePage; ///商城店铺页面
    vc.entry_id = @(_sellerId).stringValue; //传商家(专题)id
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    JHShopWindowLayout *layout = _layouts[indexPath.item];
    return layout.cellHeight;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenW, 10);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//全局变量记录滑动前的contentOffset
   _lastContentOffset = scrollView.contentOffset.y;//判断上下滑动时
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > _lastContentOffset && scrollView.contentSize.height < self.view.height + 88){
        NSLog(@"上滑");
        return;
    }
    if (self.offsetBlock) {
        self.offsetBlock(scrollView.contentOffset.y);
    }
}

#pragma mark - load data
- (void)refreshData {
    ///刷新之前查询1列表中 是否有超过1秒的商品 加入2中提交一波数据
    [self.browseManager uploadRecordBeforeRefresh];
    
    _pageNumber = 1;
    [self loadData:YES];
}

- (void)loadMoreData {
    _pageNumber ++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {
    [SVProgressHUD show];
    JHShopWindowLayout *layout = [self.layouts lastObject];
    JHGoodsInfoMode *info = layout.goodsInfo;
    ///默认值为0
    NSInteger lastId = info ? [info.goods_id integerValue] : 0;
    NSString *formatStr = @"/v1/shop/search_ware?seller_id=%ld&last_id=%ld&page=%ld&sort=%ld";
    NSString *url = [NSString stringWithFormat: COMMUNITY_FILE_BASE_STRING(formatStr), (long)self.sellerId, (long)lastId, (long)_pageNumber, (long)_sortType];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        [self paraseResponseData:respondObject.data isRefresh:isRefresh];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self endRefresh];
        [self showBlankView:YES];
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)paraseResponseData:(NSArray *)data isRefresh:(BOOL)isRefresh {
    if (data.count == 0) {
         _collectionView.mj_footer.hidden = YES;
    }
    else {
         _collectionView.mj_footer.hidden = NO;
    }
    NSArray *tempArray = [JHGoodsInfoMode mj_objectArrayWithKeyValuesArray:data];
    @weakify(self);
    NSMutableArray *layoutArray = [NSMutableArray array];
    [tempArray enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        
        NSLog(@"限时购：%@ \n 现价:%@ \n 下标:%ld", obj.flash_sale_tag, obj.market_price, idx);
        
        obj.timerSourceIdentifier = [NSString stringWithFormat:@"%@_%ld", storeShopPageTimerSourceId, (long)self.pageNumber];
        
        JHShopWindowLayout *layout = [[JHShopWindowLayout alloc] initWithModel:obj];
        [layoutArray addObject:layout];
    }];
    [kCountDownManager addTimerSourceWithId:[NSString stringWithFormat:@"%@_%ld", storeShopPageTimerSourceId, (long)self.pageNumber]];
    if (isRefresh) {
        self.layouts = [NSMutableArray arrayWithArray:layoutArray];
    }
    else {
        [self.layouts addObjectsFromArray:layoutArray];
    }
    
    [self showBlankView:NO];
    
    [self.collectionView reloadData];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)showBlankView:(BOOL)hasError {
    [self.collectionView configBlankType:YDBlankTypeNoShopList hasData:self.layouts.count > 0 hasError:hasError offsetY:0 reloadBlock:^(id sender) {
        NSLog(@"点击刷新按钮");
        //[self refresh];
    }];
}

#pragma mark -
#pragma mark - 浏览商品埋点相关

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.browseManager uploadRecoredBeforeClose];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.layouts.count == 0) {
        return;
    }
    
    JHShopWindowLayout *layout = self.layouts[indexPath.item];
    JHGoodsInfoMode *data = layout.goodsInfo;
    if (data.goods_id == 0) {
        return;
    }
    //[self.browseManager addGoodsItem:data.goods_id];
    [self.browseManager addGoodsItem:data.original_goods_id];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.layouts.count == 0) {
        return;
    }
    
    //比较该cell是否出现超过限制
    if (indexPath.item < self.layouts.count) {
        JHGoodsInfoMode *goodInfo = [self.layouts[indexPath.item] goodsInfo];
        //[self.browseManager removeGoodsItem:goodInfo.goods_id];
        [self.browseManager removeGoodsItem:goodInfo.original_goods_id];
    }
}

- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}

@end

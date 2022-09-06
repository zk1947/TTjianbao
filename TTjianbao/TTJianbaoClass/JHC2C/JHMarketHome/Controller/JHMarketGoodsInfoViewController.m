//
//  JHMarketGoodsInfoViewController.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketGoodsInfoViewController.h"
//#import "JHMarketGoodsCollectionViewCell.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "JHMarketCommunityCollectionViewCell.h"
#import "JHNewStoreHomeSingelton.h"
#import "YDWaterFlowLayout.h"
#import "JHPlayerViewController.h"
#import "JHMarketHomeBusiness.h"
#import "JHRefreshNormalFooter.h"
#import <MJRefresh.h>
#import "YDRefreshFooter.h"
#import "JHC2CProductDetailController.h"
#import "JHMarketHomeDataReport.h"

@interface JHMarketGoodsInfoViewController ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate,
YDWaterFlowLayoutDelegate
>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) NSMutableArray *hotTokArray;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) YDWaterFlowLayout  *gridLayout;

@property (nonatomic, strong) JHPlayerViewController  *playerController;

/** 当前播放视频的cell*/
@property (nonatomic, strong) JHC2CGoodsCollectionViewCell *currentCell;

@property (nonatomic, assign) NSInteger requestPageIndex;

@property (nonatomic, assign) BOOL hasMore;

@end

@implementation JHMarketGoodsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self removeNavView];
    [self setupView];
    [self loadData];
}

- (void)loadData{
    self.requestPageIndex = 1;
    [self.hotTokArray removeAllObjects];
    [self.goodsArray removeAllObjects];
    @weakify(self);
    [JHMarketHomeBusiness getMarketGoodsListData:1 pageSize:20 productType:self.pageType Completion:^(NSError * _Nullable error, JHMarketHomeCellStyleGoodsViewModel * _Nullable viewModel) {
        @strongify(self);
        [self endRefresh];
        self.hasMore = viewModel.hasMore;
        if (!viewModel.productList || viewModel.productList.count == 0) {
            NSLog(@"错误页面");
            [self.collectionView jh_reloadDataWithEmputyView];
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            self.collectionView.mj_footer.hidden = YES;
            return;
        }
        //商品集合
        [self.goodsArray addObjectsFromArray:viewModel.productList];
        //社区集合
        if (viewModel.hotTopicResponses.count > 0) {
            [self.hotTokArray addObject:viewModel.hotTopicResponses];
        }
        self.requestPageIndex ++;
        //处理插入社区数据源
        [self dealDataSource];
        [self.collectionView reloadData];
    }];
}

- (void)loadMoreData{
    if (!self.hasMore) {
        [self.collectionView jh_footerStatusWithNoMoreData:YES];
        self.collectionView.mj_footer.hidden = YES;
        return;
    }
    @weakify(self);
    [JHMarketHomeBusiness getMarketGoodsListData:self.requestPageIndex pageSize:20 productType:self.pageType Completion:^(NSError * _Nullable error, JHMarketHomeCellStyleGoodsViewModel * _Nullable viewModel) {
        @strongify(self);
        [self endRefresh];
        self.hasMore = viewModel.hasMore;
        if (!viewModel.productList || viewModel.productList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
            self.collectionView.mj_footer.hidden = YES;
            return;
        }
        [self.goodsArray addObjectsFromArray:viewModel.productList];
        //社区讨论
        if (viewModel.hotTopicResponses.count > 0) {
            [self.hotTokArray addObject:viewModel.hotTopicResponses];
        }
        self.requestPageIndex ++;
        if (viewModel.productList.count == 0) {
            [self.collectionView jh_footerStatusWithNoMoreData:YES];
        } else {
            [self.collectionView jh_footerStatusWithNoMoreData:NO];
        }
        //处理插入社区数据源
        [self dealDataSource];
        [self.collectionView reloadData];
    }];
}

- (void)dealDataSource{
    //没有商品或讨论组情况下不需要处理
    if (self.goodsArray.count == 0) return;
    
    //商品数据源处理
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:self.goodsArray];
    
    //讨论组情况下处理
    if (self.hotTokArray.count == 0) return;
    /**
     第一个讨论组从索引1位置开始,之后间隔20个商品插入一个讨论组
     确认需要插入的讨论组数
     1.商品倍数大于等于讨论组将讨论组全部插入
     2.商品倍数小于讨论组则按商品倍数插入
     */
    NSInteger talkCount = (self.goodsArray.count/21 + 1 > self.hotTokArray.count) ? self.hotTokArray.count : self.goodsArray.count/21 + 1;
    for (int index = 0; index < talkCount; index++) {
        NSArray *talkArray = self.hotTokArray[index];
        [self.dataSourceArray insertObject:talkArray atIndex:index*21 + 1];
    }
}

- (void)endRefresh {
    [self.collectionView.mj_footer endRefreshing];
}

- (CGFloat)bottomCellHeight {
    if ([JHNewStoreHomeSingelton shared].hasBoutiqueValue) {
        return ScreenH - UI.statusBarHeight - UI.bottomSafeAreaHeight - 173;
    } else {
        return ScreenH - UI.statusBarHeight - UI.bottomSafeAreaHeight - 133;
    }
}

-(void)setupView{
    [self addGradualColor:self.view];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        ///尽量不要修改间距 ！！！！！ UI确认完之后的
        make.edges.equalTo(self.view);
        make.height.mas_equalTo([self bottomCellHeight]+10);
    }];
}

- (void)addGradualColor:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFFFFF).CGColor, (__bridge id)HEXCOLOR(0xF5F5F5).CGColor];
    gradientLayer.locations = @[@0.0, @0.2];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
}

#pragma mark - private
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (void)makeDeatilDescModuleScrollToTop {
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makeDeatilDescModuleScroll:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(JHMarketGoodsInfoViewControllerLeaveTop)]) {
                [self.delegate JHMarketGoodsInfoViewControllerLeaveTop];
            }
        }
    } else {
        [self makeDeatilDescModuleScroll:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self endScrollToPlayVideo];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
                [cell.contentView addSubview:self.playerController.view];
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

#pragma mark - Delegate DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id viewModel = self.dataSourceArray[indexPath.row];
    if ([JHC2CProductBeanListModel has:viewModel]) {
        JHC2CGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHC2CGoodsCollectionViewCell" forIndexPath:indexPath];
        [cell bindViewModel:viewModel params:nil];
        return cell;
    }
    if ([NSArray has:viewModel]) {
        JHMarketCommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHMarketCommunityCollectionViewCell" forIndexPath:indexPath];
        cell.hotListArray = viewModel;
        return cell;
    }
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id viewModel = self.dataSourceArray[indexPath.row];
    if ([JHC2CProductBeanListModel has:viewModel]) {
        JHC2CProductBeanListModel *goodsModel = (JHC2CProductBeanListModel *)viewModel;
        //上报
        [JHMarketHomeDataReport goodsTouchReport:goodsModel.productId goodsTag:[self getMyPageType] goodsPrice:goodsModel.price type:@"集市首页列表"];
        JHC2CProductDetailController *vc = [JHC2CProductDetailController new];
        vc.productId = goodsModel.productId;
        [[self navVc] pushViewController:vc animated:YES];
    }
}

- (NSString *)getMyPageType{
    //[@2,@1,@0] 0一口价 1拍卖 2全部
    NSString *typeStr = @"全部";
    switch (self.pageType) {
        case 0:typeStr = @"一口价";
            break;
        case 1:typeStr = @"拍卖";
            break;
        case 2:typeStr = @"全部";
            break;
        default:
            break;
    }
    return typeStr;
}

- (UINavigationController *)navVc{
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isKindOfClass:[UINavigationController class]] && nextResponder != nil) {
        nextResponder = nextResponder.nextResponder;
    }
    return (UINavigationController *)nextResponder;
}


#pragma mark - YDWaterFlowLayoutDelegate
/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    id viewModel = self.dataSourceArray[indexPath.row];
    if ([JHC2CProductBeanListModel has:viewModel]) {
        JHC2CProductBeanListModel *goodsModel = (JHC2CProductBeanListModel *)viewModel;
        return CGSizeMake((ScreenW - 33.f) / 2, goodsModel.itemHeight);
    }
    if ([NSArray has:viewModel]) {
        NSArray *talkArr = (NSArray *)viewModel;
        return CGSizeMake((ScreenW - 33.f) / 2, (talkArr.count * 50) + 58);
    }
    return CGSizeMake(0, 0);
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
    return 2;
}

/** 行间距*/
- (CGFloat)yd_spacingForRowInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 11;
}
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 11;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return UIEdgeInsetsMake(10, 11, 10, 11);
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - Lazy load Methods：

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];//HEXCOLOR(0xF5F5F8);[UIColor clearColor]
        [_collectionView registerClass:[JHC2CGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class])];
        [_collectionView registerClass:[JHMarketCommunityCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMarketCommunityCollectionViewCell class])];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
    }
    return _collectionView;
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

- (YDWaterFlowLayout *)gridLayout {
    if (!_gridLayout) {
        _gridLayout = [[YDWaterFlowLayout alloc] init];
        _gridLayout.delegate = self;
    }
    return _gridLayout;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        _goodsArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _goodsArray;
}

- (NSMutableArray *)hotTokArray {
    if (!_hotTokArray) {
        _hotTokArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _hotTokArray;
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

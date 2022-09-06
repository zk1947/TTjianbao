//
//  JHGoodsDetailViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsDetailViewController.h"
#import "JHShopHomeController.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHStoreCommentsListController.h"
#import "JHGoodsDetailBottomToolBar.h"
#import "JHGoodsDetailAttrCell.h"
#import "JHGoodsDetailImgCell.h"
#import "JHGoodsDetailCommentHeaderView.h"
#import "JHGoodsDetailCommentCell.h"
#import "JHBaseOperationView.h"
#import "PayMode.h"
#import "JHOrderViewModel.h"
#import "JHStoreApiManager.h"
#import "GrowingManager.h"
#import "JHZFPlayerController.h"
//播放器头文件
#import "YDPlayerControlView.h"
//ZFPlayer
#import "ZFPlayer.h"
#import "ZFUtilities.h"
#import "ZFAVPlayerManager.h"
#import "UIImageView+ZFCache.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>


///2.5特卖商城升级增加  ---- lh
#import "JCCollectionViewWaterfallLayout.h"
#import "JHGoodsDetailPriceCell.h"
#import "JHGoodsInfosCell.h"
#import "JHGoodsDetailRepertoryCell.h"
#import "JHGoodsInfoShopCell.h"
#import "JHLargeImageCollectionViewCell.h"
#import "JHGoodsDetailCommentFooter.h"
#import "JHShopWindowCollectionCell.h"
#import "JHRecommendHeader.h"
#import <JXCategoryView/JXCategoryView.h>

#import "JHGoodsDetailHeaderView.h"
#import "JHTrackingGoodsDetailModel.h"

typedef NS_ENUM(NSInteger,JHGoodsDetailSectionType) {
    JHGoodsDetailSectionTypeHeader,             ///头部
    JHGoodsDetailSectionTypePrice,              ///价格标签
    JHGoodsDetailSectionTypeInfo,               ///商品信息
    JHGoodsDetailSectionTypeRepertory,          ///库存
    JHGoodsDetailSectionTypeShop,               ///店铺入口
    JHGoodsDetailSectionTypeGanduatee,          ///保障图
    JHGoodsDetailSectionTypeAttr,               ///描述文字
    JHGoodsDetailSectionTypeImg,                ///描述图片
    JHGoodsDetailSectionTypeComment,            ///评论列表
    JHGoodsDetailSectionTypeSafeImg,            ///保障图 大
    JHGoodsDetailSectionTypeRecommend,          ///推荐
};

static NSInteger DescNumMax = 300;  //描述最大字数限制

@interface JHGoodsDetailSectionModel : NSObject
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) JHGoodsDetailSectionType sectionType;
@end
@implementation JHGoodsDetailSectionModel
@end

@interface JHGoodsDetailViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, JCCollectionViewWaterfallLayoutDelegate, JXCategoryViewDelegate>
{
    CGFloat _alphaValue;   ///导航栏透明度
    BOOL _bottomLineHidden;
}

///数据请求相关
@property (nonatomic, assign) BOOL isFirstRequest;
@property (nonatomic, strong) CGoodsDetailModel *curModel;
@property (nonatomic, strong) CGoodsInfo *curGoodsInfo;
@property (nonatomic, strong) CShopInfo *curShopInfo;
@property (nonatomic, assign) NSInteger totalCommentCount; //记录评论总数，用于判断是否显示查看全部评论
@property (nonatomic,   copy) NSString *totalCommentCountStr; //记录评论总数
@property (nonatomic,   copy) NSString *commentGradeStr; //评论好评度
@property (nonatomic, strong) NSMutableArray <JHAudienceCommentMode *> *commentList; //评论列表
@property (nonatomic,strong) NSMutableArray <JHShopWindowLayout *>*recommendArray;

@property (nonatomic, strong) JHGoodsDetailBottomToolBar *bottomToolBar;
//播放器属性
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) YDPlayerControlView *playerControl;
@property (nonatomic, strong) UITapImageView *playerContainerView;
@property (nonatomic, strong) CGoodsImgInfo *videoInfo;
@property (nonatomic, assign) BOOL preVideoPlaying; //记录滑出视频区域时的播放状态

@property (nonatomic, strong) JHBuryPointStoreGoodsDetailBrowseModel *browseModel;

@property (nonatomic, strong) JXCategoryIndicatorLineView *indicatorView;


///2.5特卖商城升级增加的代码
@property (nonatomic, strong) UICollectionView *mainCollectionView;
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JHGoodsDetailHeaderView *headerView;


@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray <JHGoodsDetailSectionModel *>*sectionArray;

@property (nonatomic, strong) JHGoodsDetailSectionModel *detailAttrModel;
@property (nonatomic, strong) JHGoodsDetailSectionModel *detailImgModel;

@property (nonatomic, assign) BOOL isClickSelect;   ///是否是点击选中
@property (nonatomic, assign) NSInteger titleSelectIndex;   ///导航栏选中的下标

@property (nonatomic, assign) BOOL isBuried; //是否已经埋点了
@property (nonatomic, assign) BOOL isTracking;  //请求完上报神策数据
@end

@implementation JHGoodsDetailViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.titleCategoryView removeObserver:self forKeyPath:@"selectedIndex"];
    NSLog(@"%@*************被释放",[self class])
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isFirstRequest = YES;
        _page = 1;
        _alphaValue = 0.f;
        _bottomLineHidden = YES;
        _isClickSelect = YES;
        _titleSelectIndex = 0;
        _curModel = [[CGoodsDetailModel alloc] init];
        _curGoodsInfo = [[CGoodsInfo alloc] init];
        _curShopInfo = [[CShopInfo alloc] init];
        _commentList = [NSMutableArray array];
        _recommendArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF7F7F7);
    
    [self configBottomToolBar];
    [self configCollectionView];
    [self configNaviBar];
    
    ///推荐数据
    [self refreshRecommendData];
    
    [self __addCountDownObserver];
    
    ///监听titleCategoryView下标的变化
    [self.titleCategoryView addObserver:self forKeyPath:@"selectedIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    ///用户画像埋点：商品详情页进入事件
    [JHUserStatistics noteEventType:kUPEventTypeMallCommodityDetailEntrance params:@{@"goods_id":self.goods_id}];
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.entry_id forKey:@"category1_id"];
    [params setValue:self.goods_id forKey:@"goods_id"];
    [params setValue:JHUPBrowseBegin forKey:JHUPBrowseKey];
    
    ///用户画像埋点：商品详情页浏览时长-开始
    [JHUserStatistics noteEventType:kUPEventTypeMallDetailCommidtityBrowse params:params];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self sendRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///用户画像埋点：商品详情页浏览时长-结束
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.entry_id forKey:@"category1_id"];
    [params setValue:self.goods_id forKey:@"goods_id"];
    [params setValue:JHUPBrowseEnd forKey:JHUPBrowseKey];
    [JHUserStatistics noteEventType:kUPEventTypeMallDetailCommidtityBrowse params:params];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self growingSetParamDict:@{@"goodsId":(self.curGoodsInfo.original_goods_id ? : (self.goods_id ? : @"")), @"from": self.entry_type ? : @"", @"topic_id" : self.entry_id ? : @""}];
    [super viewDidDisappear:animated];
    ///结束浏览商品详情统计
    [self endBrowseStoreGoodsDetail];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y+kCycleViewH;
    _alphaValue = offsetY / kCycleViewH;
    if (_alphaValue >= 1) {
        _alphaValue = 0.999;
    }
    _bottomLineHidden = (offsetY < kCycleViewH);
    [UIView animateWithDuration:0.25 animations:^{
        self.titleCategoryView.alpha = _alphaValue;
        self.naviBar.titleLabel.alpha = _alphaValue;
        self.naviBar.bottomLine.hidden = _bottomLineHidden;
        self.naviBar.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        self.naviBar.leftImage = _bottomLineHidden ? kNavBackWhiteShadowImg : kNavBackBlackImg;
        self.naviBar.rightImage = _bottomLineHidden ? kNavShareWhiteShadowImg : kNavShareBlackImg;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

//埋点：扩展创建页面（进入页面的参数）
- (NSMutableDictionary*)growingGetCreatePageParamDict
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:[super growingGetCreatePageParamDict]];
    [dic setObject:_curGoodsInfo.original_goods_id ?: (self.goods_id ? : @"") forKey:@"goods_id"];
    [dic setValue:self.entry_id ? : @"" forKey:@"topic_id"];
    [dic setValue:self.entry_type ? : @"" forKey:@"from"];
    return dic;
}

#pragma mark -
#pragma mark - UI Methods

- (void)configNaviBar {
    [self showNaviBar];
    self.naviBar.titleLabel.alpha = _alphaValue;
    self.naviBar.leftImage = kNavBackWhiteShadowImg;
    self.naviBar.rightImage = kNavShareWhiteShadowImg;
    self.naviBar.bottomLine.hidden = _bottomLineHidden;
    self.naviBar.backgroundView.userInteractionEnabled = YES;
    [self.naviBar.backgroundView addSubview:self.titleCategoryView];
    
    self.titleCategoryView.sd_layout
    .centerXEqualToView(self.naviBar.backgroundView)
    .bottomSpaceToView(self.naviBar.backgroundView, 2)
    .leftSpaceToView(self.naviBar.backgroundView, 50)
    .rightSpaceToView(self.naviBar.backgroundView, 50)
    .heightIs(46);
}

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc] init];
        _titleCategoryView.titles = @[@"详情",@"评价",@"保障"];
        //点击cell进行contentScrollView切换时是否需要动画。默认为YES
        _titleCategoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
        _titleCategoryView.titleColor = kColor333;
        _titleCategoryView.titleSelectedColor = kColor333;
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontNormal size:15];
        _titleCategoryView.delegate = self;
        _titleCategoryView.cellSpacing = 20;
        _titleCategoryView.titleColorGradientEnabled = NO;
        _titleCategoryView.indicators = @[self.indicatorView];
        _titleCategoryView.alpha = _alphaValue;
    }
    return _titleCategoryView;
}

- (JXCategoryIndicatorLineView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JXCategoryIndicatorLineView alloc] init];
        _indicatorView.indicatorWidth = JXCategoryViewAutomaticDimension; //LineView与Cell同宽
        _indicatorView.indicatorHeight = 3;
        _indicatorView.verticalMargin = 6;
        _indicatorView.indicatorColor = kColorMain;
    }
    return _indicatorView;
}

- (void)configBottomToolBar {
    _bottomToolBar = [[JHGoodsDetailBottomToolBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    [self.view addSubview:_bottomToolBar];
    
    _bottomToolBar.sd_layout
    .leftEqualToView(self.view).rightEqualToView(self.view)
    .bottomSpaceToView(self.view, UI.bottomSafeAreaHeight)
    .heightIs(44);

    @weakify(self);
    _bottomToolBar.clickServiceBlock = ^{
        @strongify(self);
        [self didClickServiceBtn];
    };
    
    _bottomToolBar.clickShopBlock = ^{
        @strongify(self);
        [self didClickShopBtn];
    };
    
    _bottomToolBar.clickBuyBlock = ^{
        @strongify(self);
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:self.entry_type forKey:@"from"];
        [params setValue:@(self.shopWindowId) forKey:@"shopWindowId"];
        [params setValue:self.goods_id forKey:@"goods_id"];
        [JHGrowingIO trackEventId:@"tm_sx_qg_click" variables:params];
        [self didClickBuyBtn];
    };
    
    _bottomToolBar.clickCollectBlock = ^(BOOL isCollected) {
      ///添加收藏 YES       取消收藏为 NO
        @strongify(self);
        [self trackDetailCollect:isCollected];
    };
}

- (void)trackDetailCollect:(BOOL)isCollected
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:_curGoodsInfo.original_goods_id ?: (self.goods_id ? : @"") forKey:@"goods_id"];
    [dic setValue:self.entry_id ? : @"" forKey:@"topic_id"];
    [dic setValue:self.entry_type ? : @"" forKey:@"from"];
    [dic setValue:isCollected ? @"1" : @"0" forKey:@"is_collect"];
    [JHGrowingIO trackEventId:JHTrackMarketSaleDetailCollect variables:dic];
    [JHBuryPointOperator buryWithEventId:@"shop_detail_collect" param:[self buryParams]];
}

- (void)trackDetailShareSuccess:(NSInteger)to_type
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
//    {"goods_id":"商品id","topic_id":专题id,"from":来源}
//    {"to_type":分享平台}
    //self.original_goods_id;  //商品id
    [dic setValue:_curGoodsInfo.original_goods_id ?: (self.goods_id ? : @"") forKey:@"goods_id"];
    [dic setValue:self.entry_id ? : @"" forKey:@"topic_id"];
    [dic setValue:self.entry_type ? : @"" forKey:@"from"];
    [dic setValue:@(to_type) forKey:@"to_type"];
    [JHGrowingIO trackEventId:JHTrackMarketSaleDetailShareSuccess variables:dic];
}

- (void)configCollectionView {
    _mainCollectionView = ({
        JCCollectionViewWaterfallLayout *flowLayout = [[JCCollectionViewWaterfallLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.backgroundColor = HEXCOLOR(0xF7F7F7);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.contentInset = UIEdgeInsetsMake(kCycleViewH, 0, 0, 0);
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self  refreshingAction:@selector(loadMoreRecommendData)];
        collectionView.mj_footer = footer;
        ///价格标签
        [collectionView registerClass:[JHGoodsDetailPriceCell class] forCellWithReuseIdentifier:kCellId_JHGoodsDetailPriceIdentifer];
        ///商品描述信息
        [collectionView registerClass:[JHGoodsInfosCell class] forCellWithReuseIdentifier:kCellId_JHGoodsInfosIdentifer];

        ///当前库存
        [collectionView registerClass:[JHGoodsDetailRepertoryCell class] forCellWithReuseIdentifier:kCellId_JHGoodsDetailRepertoryIdentifer];
        ///店铺入口
        [collectionView registerClass:[JHGoodsInfoShopCell class] forCellWithReuseIdentifier:kCellId_JHGoodsInfoShopIdentifer];
        
        [collectionView registerClass:[JHLargeImageCollectionViewCell class] forCellWithReuseIdentifier:kCellId_JHLargeImageIdentifer];

        ///文字信息
        [collectionView registerClass:[JHGoodsDetailAttrCell class] forCellWithReuseIdentifier:kCellId_GoodsDetailAttrCell];
        
        ///图片
        [collectionView registerClass:[JHGoodsDetailImgCell class] forCellWithReuseIdentifier:kCellId_GoodsDetailImgCell];

        ///底部保障图的cell
        [collectionView registerClass:[JHGoodsDetailImgCell class] forCellWithReuseIdentifier:kCellId_GoodsDetailBottomImgCell];
        ///为您推荐cell
        [collectionView registerClass:[JHShopWindowCollectionCell class] forCellWithReuseIdentifier:@"JHShopWindowCollectionCell"];
        
        ///评论列表
        [collectionView registerClass:[JHGoodsDetailCommentCell class] forCellWithReuseIdentifier:kCellId_GoodsDetailCommentListIdentifer];
        
        [collectionView registerClass:[JHGoodsDetailCommentHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellId_GoodsDetailCommentHeader];

        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"commonHeader"];
        ///为您推荐
        [collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHRecommendHeader"];

        ///查看全部footer
        [collectionView registerClass:[JHGoodsDetailCommentFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_CommentFooterIdentifer];
        
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"commonFooter"];
        
        collectionView;
    });
    [self.view addSubview:_mainCollectionView];
    [_mainCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.mas_equalTo(-_bottomToolBar.height-UI.bottomSafeAreaHeight);
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"selectedIndex"]) {
        if (self.titleCategoryView.selectedIndex != self.titleSelectIndex) {
            _isClickSelect = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isClickSelect = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isClickSelect = YES;
}

///JXCategoryBaseView delegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    if (!_isClickSelect) {  ///滑动选中 不执行下面的方法
        return;
    }
    
    _titleSelectIndex = index;
    JHGoodsDetailSectionType type = [self getSelectSectionType:index];
    @weakify(self);
    [self.sectionArray enumerateObjectsUsingBlock:^(JHGoodsDetailSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.sectionType == type) {
            @strongify(self);
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
            [self.mainCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
            *stop = YES;
        }
    }];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDatasource

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isClickSelect) {
        return;
    }
    
    JHGoodsDetailSectionModel *model = self.sectionArray[indexPath.section];
    NSInteger index = 0;
    if (model.sectionType == JHGoodsDetailSectionTypeAttr ||
        model.sectionType == JHGoodsDetailSectionTypeImg) {
        index = 0;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeComment) {
        index = 1;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeSafeImg) {
        index = 2;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        index = 3;
    }
    [self.titleCategoryView selectCellAtIndex:index selectedType:JXCategoryCellSelectedTypeScroll];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodsDetailSectionModel *model = self.sectionArray[indexPath.section];
    ///描述信息 动态的
    if (model.sectionType == JHGoodsDetailSectionTypeInfo) {
        CGFloat cellHeight = self.curGoodsInfo.cellHeight;
        return CGSizeMake(ScreenW, cellHeight);
    }
    if (model.sectionType == JHGoodsDetailSectionTypeAttr && self.curGoodsInfo.attrList.count > 0) {
        ///商品图片信息
        return CGSizeMake(ScreenW, [JHGoodsDetailAttrCell cellHeight]);
    }
    if (model.sectionType == JHGoodsDetailSectionTypeImg) {
        ///商品图片信息
        CGoodsImgInfo *imgInfo = self.curGoodsInfo.detailImgList[indexPath.item];
        return CGSizeMake(ScreenW, [imgInfo imageHeight]);
    }
    if (model.sectionType == JHGoodsDetailSectionTypeComment && _commentList.count > 0) {
        //评论列表
        return CGSizeMake(ScreenW, _commentList[indexPath.item].height);
    }
    if (model.sectionType == JHGoodsDetailSectionTypeSafeImg) {
        ///大保障图
        CGoodsImgInfo *imgInfo = _curGoodsInfo.safeBottomImgInfo;
        CGFloat cellHeight = imgInfo ? [imgInfo imageHeight] : 0.f;
        return CGSizeMake(ScreenW, cellHeight);
    }
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        ///为您推荐
        JHShopWindowLayout *layout = self.recommendArray[indexPath.item];
        return CGSizeMake((ScreenW - 25)/2, layout.cellHeight);
    }
    return model.cellSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    ///描述信息 文字
    if (model.sectionType == JHGoodsDetailSectionTypeAttr && _curGoodsInfo.attrList.count > 0) {
        return self.curGoodsInfo.attrList.count;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeImg) {
        return self.curGoodsInfo.detailImgList.count;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeComment && _commentList.count > 0) {
        return _commentList.count;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeSafeImg) {
        return self.curGoodsInfo.safeBottomImgInfo ? 1 : 0;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        return self.recommendArray.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger recCount = self.recommendArray.count;
    return self.sectionArray.count - (recCount==0 ? 1:0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodsDetailSectionModel *model = self.sectionArray[indexPath.section];
    if (model.sectionType == JHGoodsDetailSectionTypePrice) {
        ///价格
        JHGoodsDetailPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHGoodsDetailPriceIdentifer forIndexPath:indexPath];
        cell.goodsInfo = self.curGoodsInfo;
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeInfo) {
        ///信息 标题 + 描述
        JHGoodsInfosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHGoodsInfosIdentifer forIndexPath:indexPath];
        cell.goodsInfo = self.curGoodsInfo;
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeRepertory) {
        ///库存
        JHGoodsDetailRepertoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHGoodsDetailRepertoryIdentifer forIndexPath:indexPath];
        cell.goodsInfo = self.curGoodsInfo;
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeShop) {
        ///店铺
        JHGoodsInfoShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHGoodsInfoShopIdentifer forIndexPath:indexPath];
        cell.shopInfo = self.curShopInfo;
        @weakify(self);
        cell.enterShopBlock = ^(NSInteger sellerId) {
            @strongify(self);
            [self enterShopPage:sellerId];
        };
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeGanduatee) {
        ///保障图 小
        JHLargeImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHLargeImageIdentifer forIndexPath:indexPath];
        cell.goodsInfo = self.curGoodsInfo;
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeAttr) {
        ///描述信息 文字
        JHGoodsDetailAttrCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_GoodsDetailAttrCell forIndexPath:indexPath];
        if (_curGoodsInfo.attrList.count > 0) {
            CGoodsAttrData *attrData = _curGoodsInfo.attrList[indexPath.item];
            cell.attrData = attrData;
        }
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeImg) {
        ///描述信息 图片
        JHGoodsDetailImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_GoodsDetailImgCell forIndexPath:indexPath];
        CGoodsImgInfo * imgInfo = self.curGoodsInfo.detailImgList[indexPath.item];
        cell.imgInfo = imgInfo;
        @weakify(self);
        cell.didClickImgBlock = ^(CGoodsImgInfo * _Nonnull imgInfo) {
            @strongify(self);
            [self showPhotoWithCurIndex:[self.curGoodsInfo.detailImgList indexOfObject:imgInfo]];
        };
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeComment) {
        /// 评论列表
        JHGoodsDetailCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_GoodsDetailCommentListIdentifer forIndexPath:indexPath];
        if (_commentList.count > 0) {
            [cell setAudienceCommentMode:_commentList[indexPath.item]];
            [cell setCellIndex:indexPath.item];
        }
        return cell;

    }
    if (model.sectionType == JHGoodsDetailSectionTypeSafeImg) {
        ///保障图 大
        JHGoodsDetailImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_GoodsDetailBottomImgCell forIndexPath:indexPath];
        CGoodsImgInfo * imgInfo = self.curGoodsInfo.safeBottomImgInfo;
        cell.imgInfo = imgInfo;
        return cell;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        ///为您推荐
        JHShopWindowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHShopWindowCollectionCell" forIndexPath:indexPath];
        cell.layout = self.recommendArray[indexPath.item];
        return cell;
    }
    
    return [[UICollectionViewCell alloc] init];
}

//查看大图
- (void)showPhotoWithCurIndex:(NSInteger)index {
    NSMutableArray *photoList = [NSMutableArray new];
    [_curGoodsInfo.detailImgList enumerateObjectsUsingBlock:^(CGoodsImgInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKPhoto *photo = [GKPhoto new];
        NSString *imgUrl = [obj.orig_image isNotBlank] ? obj.orig_image : obj.url;
        photo.url = [NSURL URLWithString:imgUrl];
        //photo.sourceImageView = _photoViews[index]; //用同一个source
        [photoList addObject:photo];
    }];
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photoList currentIndex:index];
    browser.isStatusBarShow = YES; //开始时不隐藏状态栏，不然会有页面跳动问题
    browser.isScreenRotateDisabled = YES; //禁止横屏监测
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    browser.hideStyle = GKPhotoBrowserHideStyleZoomScale;
    [browser showFromVC:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout columnCountForSection:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    return model.columnCount;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    return model.headerHeight;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    if (model.sectionType == JHGoodsDetailSectionTypeSafeImg && self.recommendArray.count == 0) {
        return 20;
    }
    return model.footerHeight;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JHGoodsDetailSectionModel *model = self.sectionArray[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        if (model.sectionType == JHGoodsDetailSectionTypeComment) {
            JHGoodsDetailCommentHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCellId_GoodsDetailCommentHeader forIndexPath:indexPath];
            if ([_totalCommentCountStr isNotBlank] && [_commentGradeStr isNotBlank]) {
                NSString *titleStr = [NSString stringWithFormat:@"买家评价（%ld）", (long)_totalCommentCount];
                NSString *gradeStr = [NSString stringWithFormat:@"好评度%@", _commentGradeStr];
                [header setTitleStr:titleStr gradeStr:gradeStr];
            }
            return header;
        }
        if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
            ///为您推荐
            JHRecommendHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHRecommendHeader" forIndexPath:indexPath];
            return header;
        }
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"commonHeader" forIndexPath:indexPath];
        return header;
    }
    else {
        if (model.sectionType == JHGoodsDetailSectionTypeComment) {
            JHGoodsDetailCommentFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_CommentFooterIdentifer forIndexPath:indexPath];
            [footer setTotalCommentStr:_totalCommentCountStr ComentList:_commentList.copy totalCommentCount:_totalCommentCount];
            @weakify(self);
            footer.findAllBlock = ^{
                @strongify(self);
                [self findAllComents];
                
            };
            return footer;
        }
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"commonFooter" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodsDetailSectionModel *model = self.sectionArray[indexPath.section];
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        JHGoodsInfoMode *data = [self.recommendArray[indexPath.item] goodsInfo];
        ///埋点相关  recommendCommodities_goods_click
        [GrowingManager recommendCommoditiesGoodsClick:@{@"goodsId":data.original_goods_id, @"from":JHFromStoreFollowGoodsDetailRecommend}];
        
        JHGoodsDetailViewController *vc = [[JHGoodsDetailViewController alloc] init];
        vc.goods_id = data.goods_id;
        vc.entry_type = JHFromStoreFollowGoodsDetailRecommend; ///商品详情推荐
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        return UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        return 5;
    }
    if (model.sectionType == JHGoodsDetailSectionTypeComment) {
        return 10;
    }
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    JHGoodsDetailSectionModel *model = self.sectionArray[section];
    if (model.sectionType == JHGoodsDetailSectionTypeRecommend) {
        return 5;
    }
    return 0;
}

#pragma mark -
#pragma mark - Action Methods

- (void)enterShopPage:(NSInteger)sellerId {
    ///进入店铺埋点
    [self GIOEnterShopPageFromBottomToolBar:NO];

    JHShopHomeController *vc = [JHShopHomeController new];
    vc.sellerId = sellerId;
    [self.navigationController pushViewController:vc animated:YES];
}

//立即抢购
- (void)didClickBuyBtn {
    if ([self isLogin]) {
        [self sa_tracking:@"buyButtonClick"];
        [JHBuryPointOperator buryWithEventId:@"shop_detail_buy" param:[self buryParams]];
        if ([self.curGoodsInfo.act_sale_msg isNotBlank]) {
            ///不可购买
            [self showAlertView];
            return;
        }
        ///需要判断当前是否可以购买
        if (self.curGoodsInfo.status == JHGoodsStatusRemindMe) {
            ///提醒我
            [self commitGoodsRemindData:NO];
            return;
        }
        if (self.curGoodsInfo.status == JHGoodsStatusSetReminded) {  ///已设提醒
            [self commitGoodsRemindData:YES];
            return;
        }
        if (self.curGoodsInfo.status == JHGoodsStatusAlreadyGrounding) {
            ///如果不是已上架状态不可购买
            [self orderStatusRequest];
        }
    }
}

//联系平台客服
- (void)didClickServiceBtn {
    //跳转到客服聊天界面
    [[JHQYChatManage shareInstance] showStoreChatWithViewController:self goodsInfo:_curGoodsInfo];
    
    //埋点 - 进入客服页
    [GrowingManager goodsDetailClickedService:[self growingBaseParams]];
    [JHBuryPointOperator buryWithEventId:@"shop_detail_contact_platform" param:[self buryParams]];
}

//点击底部店铺按钮-进入店铺
- (void)didClickShopBtn {
    //NSLog(@"点击店铺");
    JHShopHomeController *vc = [JHShopHomeController new];
    vc.sellerId = _curShopInfo.seller_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    //埋点：进入店铺
    [self GIOEnterShopPageFromBottomToolBar:YES];
//    item_id, from
    
    [JHBuryPointOperator buryWithEventId:@"shop_detail_shopkeeper" param:[self buryParams]];
}

///查看全部评论点击事件
- (void)findAllComents {
    NSLog(@"查看全部评论");
    JHStoreCommentsListController * vc=[JHStoreCommentsListController new];
    vc.sellerCustomerId = @(self.curGoodsInfo.seller_id).stringValue;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightBtnClicked {
    NSLog(@"商品详情分享");
    
    NSString *objectStr = _curGoodsInfo.original_goods_id;
    JHShareInfo* info = _curGoodsInfo.shareInfo;
    info.shareType = ShareObjectTypeStoreGoodsDetail;
    [JHBaseOperationView showShareView:info objectFlag:objectStr]; //TODO:Umeng share
    [JHBuryPointOperator buryWithEventId:@"shop_detail_share" param:[self buryParams]];
}

///进入确认订单界面
- (void)enterConfirmOrderPage {
   
    JHOrderConfirmViewController * order = [[JHOrderConfirmViewController alloc]init];
    order.goodsId = _curGoodsInfo.order_goods_id;  ///2.5改的 以前是goods_id
    order.orderCategory = @"limitedTimeOrder";;
    order.orderType = JHOrderTypeMall;
    order.source = self.entry_type;
    order.activeConfirmOrder = YES;
    order.fromString = JHConfirmFromGoodsDetail;
    @weakify(self);
    order.payBlock = ^{
        @strongify(self);
        [self sendRequest];
    };
    [self.navigationController pushViewController:order animated:YES];
}

///进入订单详情e页面
-  (void)enterOrderDetailPage:(NSString *)orderId {
    JHOrderDetailViewController *vc = [[JHOrderDetailViewController alloc] init];
    vc.orderId = orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - 视频播放相关

- (void)configPlayer {
    if (!_player) {
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            playerManager.scalingMode = ZFPlayerScalingModeAspectFill;
            //player的tag值必须在cell里设置
            self.player = [ZFPlayerController playerWithScrollView:self.mainCollectionView playerManager:playerManager containerView:_playerContainerView];
            self.player.playerDisapperaPercent = 1.0;
            self.player.playerApperaPercent = 0.0;
            self.player.controlView = self.playerControl;
            self.player.stopWhileNotVisible = NO;
            
            @weakify(self)
            self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
                @strongify(self)
                [self setNeedsStatusBarAppearanceUpdate];
                [UIViewController attemptRotationToDeviceOrientation];
                self.mainCollectionView.scrollsToTop = !isFullScreen;
            };
            
            self.player.playerDidToEnd = ^(id  _Nonnull asset) {
                @strongify(self)
                [self.player stop];
                self.headerView.isPlayEnd = YES;
            };
    }
}

//开始播放
- (void)startPlaying {
    /// 在这里判断能否播放。。。
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:_videoInfo.video_url];
    [self.playerControl showTitle:@"" coverURLString:_videoInfo.url fullScreenMode:ZFFullScreenModePortrait];
    
    if (self.mainCollectionView.contentOffset.y > kCycleViewH) {
        ///如果viewh划出超过图片的高度时
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.playerContainerView];
    }
}

- (YDPlayerControlView *)playerControl {
    if (!_playerControl) {
        _playerControl = [YDPlayerControlView new];
    }
    return _playerControl;
}

#pragma mark -
#pragma mark - 网络请求

//分两步依次请求，先获取详情，再根据详情中的商家id获取评论列表
- (void)sendRequest {
    if (_isFirstRequest) {
        [self.view beginLoading];
        _isFirstRequest = NO;
    }
    
    @weakify(self);
    ///pagefrom：页面来源 参数与埋点的字段一致
    [JHStoreApiManager getGoodsDetailWithGoodsId:self.goods_id pageFrom:self.entry_type block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            self.curModel = respObj;
            self.curGoodsInfo = self.curModel.goodsInfo;
            self.curShopInfo = self.curModel.shopInfo;
            
            if (self.curModel.goodsInfo.desc.length>DescNumMax) {
                self.curModel.goodsInfo.desc = [self.curModel.goodsInfo.desc substringToIndex:300];
            }
            ///传值到bottomToolBar
            self.bottomToolBar.goodsInfo = self.curGoodsInfo;
            
            //获取评论列表数据
            [self requestCommentList];
            
            ///开始商品浏览统计
            [self beginBrowseStoreGoodsDetail];
            
            if (!self.isTracking) {
                [self sa_tracking:@"commodityPageView"];
                self.isTracking = YES;
            }
        }
        if (!respObj && hasError) {
            [self.view endLoading];
        }
    }];
}

//根据商品信息中的商家id 获取评论列表，只获取一页数据
- (void)requestCommentList {
    @weakify(self);
    [JHStoreApiManager getCommentListWithSellerId:_curModel.goodsInfo.seller_id completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [self.view endLoading];
        @strongify(self);
        RequestModel *respondObject = (RequestModel *)respObj;
        self.totalCommentCount = hasError ? 0 : [NSString stringWithFormat:@"%@", respondObject.data[@"count"]].integerValue;
        self.totalCommentCountStr = hasError ? @"0" : respondObject.data[@"countStr"];
        self.commentGradeStr = hasError ? @"100%" :  [NSString stringWithFormat:@"%@", respondObject.data[@"orderGrade"]];
        if (hasError) {
            ///获取本地section的数据：放在这里目的是为了获取到数据后 计算cell的高度
            [self loadSectionData];
            [self.mainCollectionView addSubview:self.headerView];
            [self.mainCollectionView reloadData];
        }
        else {
            [self handleCommentListWithArr:respondObject.data[@"datas"]];
        }
    }];
}

- (void)handleCommentListWithArr:(NSArray *)array {
    NSArray *arr = [JHAudienceCommentMode mj_objectArrayWithKeyValuesArray:array];
    if (arr) {
        _commentList = [NSMutableArray arrayWithArray:arr];
    }
    ///获取本地section的数据：放在这里目的是为了获取到数据后 计算cell的高度
    [self loadSectionData];

    if (self.curGoodsInfo.attrList.count == 0) {
        [self.sectionArray removeObject:_detailAttrModel];
    }
    if (self.curGoodsInfo.detailImgList.count == 0) {
        [self.sectionArray removeObject:_detailImgModel];
    }
    [self.mainCollectionView addSubview:self.headerView];
    [self.mainCollectionView reloadData];
    
}

///点击立即抢购按钮后的网络请求  ---
- (void)orderStatusRequest {
    JHGoodsOrderDetailReqModel * mode =[[JHGoodsOrderDetailReqModel alloc]init];
    mode.goodsId = _curGoodsInfo.order_goods_id;  ///商品订单id
    mode.orderType=@(JHOrderTypeMall).stringValue;
    mode.source = self.entry_type;
    mode.orderCategory=@"limitedTimeOrder";
    
    [JHOrderViewModel requestGoodsConfirmDetail:mode completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        @weakify(self);
        if (!error) {
            JHOrderDetailMode *detail=[JHOrderDetailMode mj_objectWithKeyValues:respondObject.data];
            if (detail.orderId&&[detail.orderId length]>0) {
                ///订单详情页面
                [self enterOrderDetailPage:detail.orderId];
            }
            else{
                ///进入订单确认界面
                [self enterConfirmOrderPage];
            }
        }
        else {
            if (respondObject.code == 40005) {
                ///宝贝已经被买走了
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
            else {
                @strongify(self);
                [self.view makeToast:respondObject.message duration:1.0f position:CSToastPositionCenter];
            }
            [self sendRequest];
        }
    }];
    [SVProgressHUD show];
}

///设置提醒 & 取消设置提醒
- (void)commitGoodsRemindData:(BOOL)isReminded {
    @weakify(self);
    if (isReminded) {
        ///已设提醒  需要取消提醒
        [JHStoreApiManager goodCancelRemind:self.ses_id GoodId:self.goods_id completion:^(RequestModel *respondObject, NSError *error) {
            @strongify(self);
            if (!error) {
                ///取消提醒成功 改变按钮状态
                self.curGoodsInfo.status = JHGoodsStatusRemindMe;
                [self.bottomToolBar.buyBtn setTitle:@"提醒我" forState:UIControlStateNormal];
                 [self.bottomToolBar.buyBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
            }
            [self.view toast:respondObject.message image:nil];
        }];
    }
    else {
        [JHStoreApiManager goodRemind:self.ses_id GoodId:self.goods_id completion:^(RequestModel *respondObject, NSError *error) {
            if (!error) {
                @strongify(self);
                ///取消提醒成功 改变按钮状态
                self.curGoodsInfo.status = JHGoodsStatusSetReminded;
                [self.bottomToolBar.buyBtn setTitle:@"已设提醒" forState:UIControlStateNormal];
                 [self.bottomToolBar.buyBtn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateNormal];
            }
            [self.view toast:respondObject.message image:nil];
        }];
    }
}

#pragma mark -
#pragma mark -  为您推荐数据相关

- (void)refreshRecommendData {
    self.page = 1;
    [self loadData:YES];
}

- (void)loadMoreRecommendData {
    self.page++;
    [self loadData:NO];
}

- (void)loadData:(BOOL)isRefresh {
    ///1订单列表 2订单详情 3个人中心 4商品详情
    @weakify(self);
    NSDictionary *dic = @{@"goods_id" : self.goods_id,
                          @"page" : @(_page),
                          @"from" : @4
    };
    [JHStoreApiManager getRecommendListWithParams:dic block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        if (!hasError) {
            RequestModel *responseModel = (RequestModel *)respObj;
            [self paraseResponseData:responseModel.data isRefresh:isRefresh];
        }
    }];
}

- (void)paraseResponseData:(NSArray *)goodInfo isRefresh:(BOOL)isRefresh {
    ///橱窗列表
    if (!goodInfo && goodInfo.count == 0) {
        self.mainCollectionView.mj_footer.hidden = YES;
    }
    else {
        self.mainCollectionView.mj_footer.hidden = NO;
    }
    NSArray *tempArray = [JHGoodsInfoMode mj_objectArrayWithKeyValuesArray:goodInfo];
    ///过滤过期/失效的数据
    NSMutableArray *layoutArr = [NSMutableArray new];
    [tempArray enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        JHShopWindowLayout *layout = [[JHShopWindowLayout alloc] initWithModel:goodsInfo];
            [layoutArr addObject:layout];
    }];
    if (isRefresh) { ///刷新数据
        self.recommendArray = [NSMutableArray arrayWithArray:layoutArr];
        if (self.recommendArray.count > 0) {
            self.titleCategoryView.titles = @[@"详情",@"评价",@"保障", @"推荐"];
        }
        else {
            self.titleCategoryView.titles = @[@"详情",@"评价",@"保障"];
        }
        [self.titleCategoryView reloadData];
    }
    else {  //加载更多
        [self.recommendArray addObjectsFromArray:layoutArr];
    }
    
    [self.mainCollectionView reloadData];
}

- (void)endRefresh {
    [self.mainCollectionView.mj_header endRefreshing];
    [self.mainCollectionView.mj_footer endRefreshing];
}

- (void)loadSectionData {
    ///价格
    JHGoodsDetailSectionModel *price = [[JHGoodsDetailSectionModel alloc] init];
    price.cellSize = CGSizeMake(ScreenW, [JHGoodsDetailPriceCell cellHeight]);
    price.headerHeight = 0.f;
    price.footerHeight = 0.f;
    price.columnCount = 1;
    price.sectionType = JHGoodsDetailSectionTypePrice;
    ///描述信息
    JHGoodsDetailSectionModel *info = [[JHGoodsDetailSectionModel alloc] init];
    info.cellSize = CGSizeMake(ScreenW, 80);
    info.headerHeight = 0.f;
    info.footerHeight = 0.f;
    info.columnCount = 1;
    info.sectionType = JHGoodsDetailSectionTypeInfo;
    ///库存
    JHGoodsDetailSectionModel *repertory = [[JHGoodsDetailSectionModel alloc] init];
    repertory.cellSize = CGSizeMake(ScreenW, [JHGoodsDetailRepertoryCell cellHeight]);
    repertory.headerHeight = 10.f;
    repertory.footerHeight = 10.f;
    repertory.columnCount = 1;
    repertory.sectionType = JHGoodsDetailSectionTypeRepertory;
    ///店铺入口
    JHGoodsDetailSectionModel *shop = [[JHGoodsDetailSectionModel alloc] init];
    shop.cellSize = CGSizeMake(ScreenW, [JHGoodsInfoShopCell cellHeight]);
    shop.headerHeight = 0.f;
    shop.footerHeight = 0.f;
    shop.columnCount = 1;
    shop.sectionType = JHGoodsDetailSectionTypeShop;
    ///保障图 xiao
    JHGoodsDetailSectionModel *ganduatee = [[JHGoodsDetailSectionModel alloc] init];
    ganduatee.cellSize = CGSizeMake(ScreenW, 62);
    ganduatee.headerHeight = 0.f;
    ganduatee.footerHeight = 0.f;
    ganduatee.columnCount = 1;
    ganduatee.sectionType = JHGoodsDetailSectionTypeGanduatee;
    ///描述信息 文字
    JHGoodsDetailSectionModel *attr = [[JHGoodsDetailSectionModel alloc] init];
    _detailAttrModel = attr;
    attr.cellSize = CGSizeMake(ScreenW, 0);
    attr.headerHeight = 0.f;
    attr.footerHeight = 0.f;
    attr.columnCount = 1;
    attr.sectionType = JHGoodsDetailSectionTypeAttr;
    ///描述信息 图片
    JHGoodsDetailSectionModel *img = [[JHGoodsDetailSectionModel alloc] init];
    _detailImgModel = img;
    img.cellSize = CGSizeMake(ScreenW, 0);
    img.headerHeight = 0.f;
    img.footerHeight = 10.f;
    img.columnCount = 1;
    img.sectionType = JHGoodsDetailSectionTypeImg;
    ///评论列表
    JHGoodsDetailSectionModel *comment = [[JHGoodsDetailSectionModel alloc] init];
    comment.cellSize = CGSizeMake(ScreenW, 0.1f);
    comment.headerHeight = 42.f;
    comment.footerHeight = 48.f;
    comment.columnCount = 1;
    comment.sectionType = JHGoodsDetailSectionTypeComment;
    ///保障图 大
    JHGoodsDetailSectionModel *safeImg = [[JHGoodsDetailSectionModel alloc] init];
    safeImg.cellSize = CGSizeMake(ScreenW, 0);
    safeImg.headerHeight = 0.f;
    safeImg.footerHeight = 0.f;
    safeImg.columnCount = 1;
    safeImg.sectionType = JHGoodsDetailSectionTypeSafeImg;
    ///为您推荐
    JHGoodsDetailSectionModel *recommend = [[JHGoodsDetailSectionModel alloc] init];
    recommend.cellSize = CGSizeMake(ScreenW, 0);
    recommend.headerHeight = 46.f;
    recommend.footerHeight = 30.f;
    recommend.columnCount = 2;
    recommend.sectionType = JHGoodsDetailSectionTypeRecommend;

    NSArray *arr = @[price, info, repertory, shop, ganduatee, attr, img, comment, safeImg, recommend];
    self.sectionArray = [NSMutableArray arrayWithArray:arr];
}

#pragma mark -
#pragma mark - lazy loading

- (JHGoodsDetailHeaderView *)headerView {
    if (!_headerView) {
        CGRect rect = CGRectMake(0, -kCycleViewH, ScreenWidth, kCycleViewH);
        ///[JHGoodsDetailHeaderView heightWithGoodsModel:_curModel isFill:NO]
        
        @weakify(self);
        _headerView = [[JHGoodsDetailHeaderView alloc] initWithFrame:rect goodsModel:_curModel hasVideoBlock:^(CGoodsImgInfo *videoInfo, UITapImageView *videoContainer) {
            @strongify(self);
            self.videoInfo = videoInfo;
            self.playerContainerView = videoContainer;
            [self configPlayer];
        }];
                
        _headerView.playClickBlock = ^{
            @strongify(self);
            //NSLog(@"开始播放");
            [self startPlaying];
        };
        
        _headerView.cycleScrollEndDeceleratingBlock = ^(BOOL isVideoIndex) {
            @strongify(self);
            
            if (isVideoIndex && self.preVideoPlaying) {
                [self.player.currentPlayerManager play];
                
            } else {
                if (self.player.currentPlayerManager.isPlaying) {
                    self.preVideoPlaying = self.player.currentPlayerManager.isPlaying;
                    [self.player.currentPlayerManager pause];
                }
            }
        };
    }
    return _headerView;
}

#pragma mark -
#pragma mark - Private Methods

- (NSInteger)getSelectSectionType:(NSInteger)index {
    JHGoodsDetailSectionType type = JHGoodsDetailSectionTypeHeader;
    if (index == 1) {
        ///评价
        type = JHGoodsDetailSectionTypeComment;
    }
    else if (index == 2) {
        ///保障
       type = JHGoodsDetailSectionTypeSafeImg;
    }
    else if (index == 3) {
        ///推荐
       type = JHGoodsDetailSectionTypeRecommend;
    }
    else {
        type = JHGoodsDetailSectionTypeGanduatee;
    }
    return type;
}

- (void)showAlertView {
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:self.curGoodsInfo.act_sale_msg cancleBtnTitle:@"确定"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
}

- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {}];
        return  NO;
    }
    return  YES;
}

#pragma mark -
#pragma mark - NSNotification

- (void)__addCountDownObserver {
    @weakify(self);
    [[[JHNotificationCenter rac_addObserverForName:GoodsDetailCountDownEndNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        self.curGoodsInfo.status = JHGoodsStatusSellEnd;
        self.bottomToolBar.buyBtn.enabled = NO;
        NSString *buyStr = (self.curGoodsInfo.sell_type == 1) ? @"已结束" : @"已下架";
        [self.bottomToolBar.buyBtn setTitle:buyStr forState:UIControlStateDisabled];
//        [self.bottomToolBar.buyBtn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateNormal];
    }];
    
    ///修改按钮状态
    [[[JHNotificationCenter rac_addObserverForName:GoodsDetailShouldBeginSeckillNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        //倒计时到期
        self.curGoodsInfo.status = JHGoodsStatusAlreadyGrounding;
        self.bottomToolBar.buyBtn.enabled = YES;
        NSString *buyStr = (self.curGoodsInfo.sell_type == 1) ? @"立即抢购" : @"立即购买";
        [self.bottomToolBar.buyBtn setTitle:buyStr forState:UIControlStateNormal];
        [self.bottomToolBar.buyBtn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateNormal];
    }];
}

//点击店铺信息进入店铺通知
- (void)__addEnterShopPageObserver {
//    @weakify(self);
//    [[[JHNotificationCenter rac_addObserverForName:GoodsDetailEnterShopPageNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
//        @strongify(self);
//        [self GIOEnterShopPageFromBottomToolBar:NO];
//    }];
}

#pragma mark -
#pragma mark - 埋点相关

///开始浏览商品详情埋点
- (void)beginBrowseStoreGoodsDetail {
    if (!_isBuried) {
        _isBuried = YES;
        self.browseModel.item_type = @(self.curGoodsInfo.item_type).stringValue;
        self.browseModel.resource_type = @(self.curGoodsInfo.layout).stringValue;
        [[JHBuryPointOperator shareInstance] beginBrowseStoreGoodsDetail:self.browseModel];
    }
}

///结束浏览商品详情埋点
- (void)endBrowseStoreGoodsDetail {
    _isBuried = NO;
    [[JHBuryPointOperator shareInstance] endBrowseStoreGoodsDetail:self.browseModel];
}

- (JHBuryPointStoreGoodsDetailBrowseModel *)browseModel {
    if (!_browseModel) {
        _browseModel = [[JHBuryPointStoreGoodsDetailBrowseModel alloc] init];
        _browseModel.entry_type = self.entry_type;
        _browseModel.entry_id = self.entry_id;
        _browseModel.item_id = _curGoodsInfo.original_goods_id ?: self.goods_id; //self.original_goods_id;  //商品id
        _browseModel.request_id = [NSUUID UUID].UUIDString;
    }
    return _browseModel;
}

//埋点：进入店铺（isFromToolBar是否是点击底部店铺按钮）
- (void)GIOEnterShopPageFromBottomToolBar:(BOOL)isFromToolBar {
    NSString *from = isFromToolBar ? JHFromStoreGoodsDetailBottomShopBtn : JHFromStoreGoodsDetail;
    [GrowingManager enterShopHomePage:@{@"shopId":@(_curShopInfo.seller_id),
                                        @"from":from
    }];
    if (_isFromShopWindow) {
        [GrowingManager enterShopHomeFromWindowList:@{@"shopId" : @(_curShopInfo.seller_id),
                                                      @"topicId" : @(_shopWindowId)
        }];
    }
}

//Growing埋点 基础参数
- (NSDictionary *)growingBaseParams {
    if (!_curGoodsInfo) {
        return @{};
    }
    NSString *name =  _curGoodsInfo.name;
    if (![name isNotBlank]) {
        name = _curGoodsInfo.desc;
    }
    if (name.length > 10) {
        name = [name substringToIndex:9];
    }
    NSDictionary *params = @{@"name" : name,
                             @"goods_id" : _curGoodsInfo.original_goods_id,
                             @"seller_id" : @(_curGoodsInfo.seller_id),
                             @"sell_type" : @(_curGoodsInfo.sell_type),
                             @"status" : @(_curGoodsInfo.status),
                             @"market_price" : _curGoodsInfo.market_price,
                             @"is_collected" : @(_curGoodsInfo.is_collected)
    };
    return params;
}

#pragma mark - 屏幕旋转

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen || _bottomLineHidden) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (NSDictionary *)buryParams {
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:self.goods_id forKey:@"item_id"];
    [param setValue:self.fromRecommendType forKey:@"from"];
    return param;
}

- (void)sa_tracking:(NSString *)event{
    JHTrackingGoodsDetailModel *model = [JHTrackingGoodsDetailModel new];
    model.event = event;
    if ([event isEqualToString:@"commodityPageView"]) {
        model.source_page = self.entry_type;
    }else{
        model.page_position = @"商品详情页";
        model.button_name = self.bottomToolBar.buyBtn.currentTitle;
    }
    
    model.commodity_id = self.curGoodsInfo.goods_id;
    model.commodity_name = self.curGoodsInfo.name;
    NSString *market_price = @"";
    if (self.curGoodsInfo.market_price.length>1) {
        market_price = [self.curGoodsInfo.market_price substringFromIndex:1];
    }
    NSString *orig_price = @"";
    if (self.curGoodsInfo.orig_price.length>1) {
        orig_price = [self.curGoodsInfo.orig_price substringFromIndex:1];
    }
    model.original_price = [NSNumber numberWithString:orig_price];
    model.present_price = [NSNumber numberWithString:market_price];
    model.store_seller_id = [NSString stringWithFormat:@"%ld",self.curShopInfo.seller_id];
    model.store_seller_name = self.curShopInfo.name;
    model.activity_name = [NSString stringWithFormat:@"%ld",self.curGoodsInfo.act_type];
    [JHTracking trackModel:model];
}
@end

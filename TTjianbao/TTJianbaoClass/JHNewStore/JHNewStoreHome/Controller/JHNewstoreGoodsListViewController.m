//
//  JHNewstoreGoodsListViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//


#import "JHNewstoreGoodsListViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHNewStoreHomeBusiness.h"
#import "JHNewStoreGoodsInfoViewController.h"
#import "JHNewStoreHomeModel.h"
#import "JHNewStoreHomeReport.h"
#import "JHNewStoreHomeSingelton.h"
#import "JHNewStoreHomeChooseCagetoryBackView.h"
#import "JHGoodManagerNormalModel.h"

@interface JHNewstoreGoodsListViewController ()<
JXCategoryListContainerViewDelegate,
JXCategoryViewDelegate,
JHNewStoreGoodsInfoViewControllerDelegate
>
@property (nonatomic, strong) JXCategoryListContainerView                         *listContainerView;
@property (nonatomic, strong) JXCategoryTitleView                                 *cagetoryTitleView;
@property (nonatomic, strong) NSMutableArray<JHNewStoreHomeGoodsTabInfoModel *>   *cateArr;
@property (nonatomic, strong) NSMutableArray<JHNewStoreGoodsInfoViewController *> *vcArr;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JHNewStoreHomeChooseCagetoryBackView                *categoryView;
@property (nonatomic, strong) JHEmptyView                                         *emptyView;
@property (nonatomic, assign) JHGoodManagerListRequestProductType                  requestProductType;
@end

@implementation JHNewstoreGoodsListViewController

- (void)dealloc {
    NSLog("JHNewstoreGoodsListViewController dealloc");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentIndex = 0;
    }
    return self;
}

- (NSMutableArray<JHNewStoreHomeGoodsTabInfoModel *> *)cateArr {
    if (!_cateArr) {
        _cateArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _cateArr;
}

- (NSMutableArray<JHNewStoreGoodsInfoViewController *> *)vcArr {
    if (!_vcArr) {
        _vcArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _vcArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorFFF; // HEXCOLOR(0xF5F5F8);
    self.requestProductType = JHGoodManagerListRequestProductType_All;
    self.currentCatTitle = @"全部";
    [self removeNavView];
    [self getGoodsInfo];
    [self initCagetoryTitleView];
    [self initCategoryView];
}

- (void)refresh {
    [self.cateArr removeAllObjects];
    [self.vcArr removeAllObjects];
    self.categoryView.titles = nil;
    [self.categoryView reloadData];
    [self removeUI];
    [self initCategoryView];
    [self getGoodsInfo];
}

- (void)removeUI {
    self.listContainerView = nil;
    self.categoryView = nil;
    [self.listContainerView removeFromSuperview];
    [self.categoryView removeFromSuperview];
    
    self.cagetoryTitleView.titles = nil;
    self.cagetoryTitleView = nil;
    [_cagetoryTitleView removeFromSuperview];
}

- (CGFloat)viewHeight {
    if ([JHNewStoreHomeSingelton shared].hasBoutiqueValue) {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 40.f - 49.f;
    } else {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 40.f - 49.f + 40.f;
    }
}

- (void)setHasBoutiqueValue:(BOOL)hasBoutiqueValue {
    _hasBoutiqueValue = hasBoutiqueValue;
    CGFloat categoryHeight = 40.f;
    
    _listContainerView.frame = CGRectMake(0, categoryHeight + 42.f, ScreenW, [self viewHeight]-categoryHeight - 42.f);
    _categoryView.frame = CGRectMake(0, 42.f, ScreenW, categoryHeight);
    

    for (JHNewStoreGoodsInfoViewController *vc in self.vcArr) {
        vc.hasBoutiqueValue = hasBoutiqueValue;
    }
}

- (void)initCagetoryTitleView {
    [self.view addSubview:self.cagetoryTitleView];
    [self.cagetoryTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(42.f);
    }];
}

- (void)initCategoryView {
    CGFloat categoryHeight = 40.f;
    //view
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, 42.f + categoryHeight, ScreenW, [self viewHeight]-categoryHeight - 42.f);

    //categoryview
    JHNewStoreHomeChooseCagetoryBackView *categoryView = [[JHNewStoreHomeChooseCagetoryBackView alloc] initWithFrame:CGRectMake(0, 42.f, ScreenW, categoryHeight)];
    categoryView.backgroundColor           = HEXCOLOR(0xF5F5F8);
    categoryView.titleFont                 = [UIFont fontWithName:kFontNormal size:14];
    categoryView.titleSelectedFont         = [UIFont fontWithName:kFontNormal size:14];
    categoryView.titleColor                = HEXCOLOR(0x999999);
    categoryView.titleSelectedColor        = HEXCOLOR(0x222222);
    categoryView.cellSpacing               = 8.f;
    categoryView.delegate                  = self;
    categoryView.listContainer             = self.listContainerView;
    categoryView.averageCellSpacingEnabled = NO;
    categoryView.contentEdgeInsetLeft      = 12.f;
    self.categoryView                      = categoryView;
    
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
}

- (JXCategoryTitleView *)cagetoryTitleView {
    if (_cagetoryTitleView == nil) {
        _cagetoryTitleView                    = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 42.f)];
        _cagetoryTitleView.backgroundColor    = HEXCOLOR(0xF5F5F8);
        _cagetoryTitleView.titleFont          = [UIFont fontWithName:kFontNormal size:16];
        _cagetoryTitleView.titleSelectedFont  = [UIFont fontWithName:kFontMedium size:16];
        _cagetoryTitleView.titleColor         = HEXCOLOR(0x666666);
        _cagetoryTitleView.titleSelectedColor = HEXCOLOR(0x222222);
        _cagetoryTitleView.cellSpacing        = 15;
        _cagetoryTitleView.delegate           = self;
    }
    return _cagetoryTitleView;
}

- (JHEmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[JHEmptyView alloc] init];
    }
    return _emptyView;
}


/// 获取商品
- (void)getGoodsInfo {
    @weakify(self);
    [JHNewStoreHomeBusiness getGoodsListAndTab:1 pageSize:20 productType:self.requestProductType recommendTabName:nil Completion:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_GoodsViewModel * _Nullable viewModel) {
        @strongify(self);
        if (!viewModel && error) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHNEWSTOREGOODSINFOSUCC" object:@(NO)];
            return;
        }
        [self.emptyView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JHNEWSTOREGOODSINFOSUCC" object:@(YES)];
        [self.cateArr removeAllObjects];
        
        JHNewStoreHomeGoodsTabInfoModel *defalutModel = [[JHNewStoreHomeGoodsTabInfoModel alloc] init];
        defalutModel.tabName = @"推荐";
        [self.cateArr addObject:defalutModel];
        [self.cateArr addObjectsFromArray:viewModel.recommendTabList];
        [self.vcArr removeAllObjects];
        NSInteger index = 0;
        for (JHNewStoreHomeGoodsTabInfoModel *mo in self.cateArr) {
            JHNewStoreGoodsInfoViewController *vc = [[JHNewStoreGoodsInfoViewController alloc] init];
            vc.tabId    = mo.tabId;
            vc.tabName  = mo.tabName;
            vc.delegate = self;
            vc.indexVc  = index;
            vc.requestProductType = self.requestProductType;
            vc.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
                @strongify(self);
                if (self.goToBoutiqueDetailClickBlock) {
                    self.goToBoutiqueDetailClickBlock(isH5,showId,boutiqueName);
                }
            };
            vc.goodsClickBlock = ^(JHNewStoreHomeGoodsProductListModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
                @strongify(self);
                if (self.goodsClickBlock) {
                    self.goodsClickBlock(model, indexPath);
                }
            };
            [self.vcArr addObject:vc];
            index ++;
        }
        self.categoryView.titles = [self.cateArr jh_map:^id _Nonnull(JHNewStoreHomeGoodsTabInfoModel * _Nonnull obj, NSUInteger idx) {
            return obj.tabName;
        }];
        self.categoryView.defaultSelectedIndex = 0;
        self.cagetoryTitleView.titles = @[@"全部",@"拍卖",@"一口价"];
        [self.cagetoryTitleView reloadData];
        
        JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
        [vc getGoodsInfo];
        
        [self.categoryView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GOODSINFOVIEWHASSUBSCRO" object:nil];
    }];
}

#pragma mark - private
- (UIScrollView *)getSubScrollViewFromSelf {
    if (self.vcArr.count >0) {
        JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
        return vc.collectionView;
    }
    return nil;
}

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
    [vc makeDeatilDescModuleScroll:canScroll];
}

- (void)makeDeatilDescModuleScrollToTop {
    JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
    [vc makeDeatilDescModuleScrollToTop];
}

- (void)reloadCategoryViewBackgroundColor:(BOOL)isFFF {
    if (isFFF && self.categoryView.titles.count >0) {
        self.categoryView.backgroundColor         = HEXCOLOR(0xFFFFFF);
        self.cagetoryTitleView.backgroundColor    = HEXCOLOR(0xFFFFFF);
        self.categoryView.selectedBackgroundColor = HEXCOLOR(0xFFFFFF);
        self.categoryView.selectedBorderColor     = HEXCOLOR(0xFFFFFF);
        self.categoryView.normalBackgroundColor   = [UIColor clearColor];
    } else {
        self.categoryView.backgroundColor         = HEXCOLOR(0xF5F5F8);
        self.cagetoryTitleView.backgroundColor    = HEXCOLOR(0xF5F5F8);
        self.categoryView.selectedBackgroundColor = HEXCOLOR(0xEDEDED);
        self.categoryView.selectedBorderColor     = HEXCOLOR(0xEDEDED);
        self.categoryView.normalBackgroundColor   = [UIColor clearColor];
    }
}

#pragma mark - JHNewStoreGoodsInfoViewControllerDelegate
- (void)JHNewStoreGoodsInfoViewControllerLeaveTop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JHNewstoreGoodsListViewControllerLeaveTop)]) {
        [self.delegate JHNewstoreGoodsListViewControllerLeaveTop];
    }
}


#pragma mark - JXCategoryListContainerViewDelegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateArr.count;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (categoryView == self.cagetoryTitleView) {
        if (index == 0) {
            self.requestProductType = JHGoodManagerListRequestProductType_All;
            self.currentCatTitle = @"全部";
        } else if (index == 1) {
            self.requestProductType = JHGoodManagerListRequestProductType_Auction;
            self.currentCatTitle = @"拍卖";
        } else {
            self.requestProductType = JHGoodManagerListRequestProductType_OnePrice;
            self.currentCatTitle = @"一口价";
        }
        if (self.vcArr.count >0) {
            for (int i = 0; i < self.vcArr.count; i++) {
                JHNewStoreGoodsInfoViewController *vc = self.vcArr[index];
                vc.requestProductType = self.requestProductType;
            }
            JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
            vc.requestProductType = self.requestProductType;
            [vc getGoodsInfo];
        }
    } else {
        NSString *tabName = [self.categoryView.titles objectAtIndex:index];
        [JHNewStoreHomeReport jhNewStoreHomeGoodsTabClickReport:tabName];
        
        if (self.vcArr.count >0) {
            for (int i = 0; i<self.vcArr.count; i++) {
                if (i != index) {
                    JHNewStoreGoodsInfoViewController *vc = self.vcArr[index];
                    vc.requestProductType = self.requestProductType;
                    [vc.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
                }
            }
        
            for (int i = 0; i < self.vcArr.count; i++) {
                JHNewStoreGoodsInfoViewController *vc = self.vcArr[index];
                vc.requestProductType = self.requestProductType;
            }
            JHNewStoreGoodsInfoViewController *vc = self.vcArr[self.categoryView.selectedIndex];
            vc.requestProductType = self.requestProductType;
            [vc getGoodsInfo];
        }
    }
}

@end

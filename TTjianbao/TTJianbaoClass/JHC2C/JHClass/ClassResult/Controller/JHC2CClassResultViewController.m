//
//  JHC2CClassResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassResultViewController.h"
#import "JHC2CSearchResultViewController.h"
#import "ZQSearchViewController.h"

#import "JHC2CSearchResultSubViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"

@interface JHC2CClassResultViewController ()<ZQSearchViewDelegate, JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, copy) NSArray *titleArray;

@property (nonatomic, copy) NSString *keywordStr;

@end

@implementation JHC2CClassResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.cateName;
    
    [self initRightButtonWithImageName:@"navi_icon_search" action:@selector(clickSearchAction:)];

    
    [self setupHeaderTitleView];

}

#pragma mark - UI
- (void)setupHeaderTitleView {
    self.titleArray = @[@"全部",@"拍卖",@"一口价"];
    [self.view addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.offset(42);
    }];

    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
    self.titleCategoryView.titles = self.titleArray;
    self.titleCategoryView.listContainer = self.listContainerView;
}

#pragma mark  - Action
- (void)clickSearchAction:(UIButton *)sender{
    JHC2CSearchResultViewController *resultVC = [[JHC2CSearchResultViewController alloc]init];
    ZQSearchFrom from = ZQSearchFromC2C;
    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultVC];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - LoadData
- (void)loadData{
    [self.titleCategoryView reloadData];

}


#pragma mark - Delegate
#pragma mark - ZQSearchViewDelegate
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHC2CSearchResultViewController *vc = (JHC2CSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
    
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JHC2CSearchResultSubViewController *subVC = [[JHC2CSearchResultSubViewController alloc]init];
    subVC.classID = self.cateId;
    subVC.titleTagIndex = index;
    subVC.classClickFrom = self.cateLevel;
    subVC.className = self.cateName;
    return subVC;
    
}
#pragma mark - JXCategoryViewDelegate
//滚动/点击 都会走该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

#pragma mark - Lazy

- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        _titleCategoryView.titleColor = HEXCOLOR(0x999999);
        _titleCategoryView.backgroundColor = UIColor.whiteColor;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _titleCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _titleCategoryView.delegate = self;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [CommHelp toUIColorByStr:@"#FFD70F"];
        lineView.indicatorWidth = 25;
        lineView.indicatorHeight = 3;
        lineView.verticalMargin = 5;
        _titleCategoryView.indicators = @[lineView];

    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _listContainerView.scrollView.scrollEnabled = NO;
    }
    return _listContainerView;
}


@end

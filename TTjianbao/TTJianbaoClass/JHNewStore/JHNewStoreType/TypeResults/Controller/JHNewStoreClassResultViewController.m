//
//  JHNewStoreClassResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/8/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassResultViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHSearchViewController_NEW.h"
#import "JHNewStoreClassListViewController.h"

@interface JHNewStoreClassResultViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation JHNewStoreClassResultViewController

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
        make.height.offset(44);
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
    JHSearchViewController_NEW *searchVC = [[JHSearchViewController_NEW alloc] init];
    searchVC.fromSource = JHSearchFromStore;
    searchVC.placeholder = self.cateName;
    [self.navigationController pushViewController:searchVC animated:NO];
}


#pragma mark - LoadData
- (void)loadData{
    [self.titleCategoryView reloadData];

}


#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JHNewStoreClassListViewController *subVC = [[JHNewStoreClassListViewController alloc]init];
    subVC.titleTagIndex = index;
    subVC.classID = self.cateId;
    subVC.className = self.cateName;
    subVC.classClickFrom = self.cateLevel;
    subVC.firstClassName = self.firstCateName;
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
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:15];
        _titleCategoryView.titleColor = HEXCOLOR(0x999999);
        _titleCategoryView.backgroundColor = UIColor.whiteColor;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _titleCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _titleCategoryView.delegate = self;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = HEXCOLOR(0xFFD70F);
        lineView.indicatorWidth = 16;
        lineView.indicatorHeight = 3;
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

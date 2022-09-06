//
//  JHC2CSearchResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSearchResultViewController.h"
#import "JHC2CSearchResultSubViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"


@interface JHC2CSearchResultViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSString *keywordStr;//关键词
@property (nonatomic, copy) NSString *keywordSource;//关键词来源

@end

@implementation JHC2CSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//***************
///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource {
    self.keywordStr = keyword;
    self.keywordSource = [NSString stringWithFormat:@"%@",keywordSource];
    [self setupHeaderTitleView];

}

#pragma mark - UI
- (void)setupHeaderTitleView {
    [self.view addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.offset(42);
    }];

    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
    [self loadData];
}

#pragma mark - LoadData
- (void)loadData{
    self.titleArray = @[@"全部",@"拍卖",@"一口价"];
    self.titleCategoryView.titles = self.titleArray;
    self.titleCategoryView.listContainer = self.listContainerView;
    self.titleCategoryView.defaultSelectedIndex = 0;
    [self.titleCategoryView reloadData];

}

#pragma mark  - Action


#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JHC2CSearchResultSubViewController *subVC =  [[JHC2CSearchResultSubViewController alloc]init];
    subVC.keyword = self.keywordStr;
    subVC.keywordSource = self.keywordSource;
    subVC.titleTagIndex = index;
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
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontBoldPingFang size:15];
        _titleCategoryView.titleColor = HEXCOLOR(0x999999);
        _titleCategoryView.backgroundColor = UIColor.whiteColor;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:15];
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

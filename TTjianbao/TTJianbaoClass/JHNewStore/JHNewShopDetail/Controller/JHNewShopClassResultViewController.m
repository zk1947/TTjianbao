//
//  JHNewShopClassResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopClassResultViewController.h"
#import "JHNewShopClassResultSubViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"

@interface JHNewShopClassResultViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, copy) NSArray *titleArray;

@end

@implementation JHNewShopClassResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.shopInfoModel.shopName;
    
    //只有拍卖商品或者一口价商品
    if (self.shopInfoModel.productTypeTag == 0 || self.shopInfoModel.productTypeTag == 1) {//0 一口价，1 拍卖
        JHNewShopClassResultSubViewController *subVC = [[JHNewShopClassResultSubViewController alloc]init];
        subVC.titleTagIndex = self.shopInfoModel.productTypeTag==0 ? 2 : 1;//1:只有拍卖  2:只有一口价
        subVC.shopID = self.shopInfoModel.shopId;
        subVC.isShowTitleTag = NO;
        subVC.cateId = self.cateId;
        [self.view addSubview:subVC.view];
        [subVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
        }];
    }else {
        [self setupHeaderTitleView];
    }
    
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


#pragma mark - LoadData


#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    JHNewShopClassResultSubViewController *subVC = [[JHNewShopClassResultSubViewController alloc]init];
    subVC.titleTagIndex = index;
    subVC.shopID = self.shopInfoModel.shopId;
    subVC.isShowTitleTag = YES;
    subVC.cateId = self.cateId;
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
        lineView.indicatorColor = [CommHelp toUIColorByStr:@"#FFD70F"];
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

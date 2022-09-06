//
//  JHLuckyBagAllViewController.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagAllViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"
#import "JHLuckyBagShowListVC.h"
#import "JHLuckyBagRewardVC.h"

@interface JHLuckyBagAllViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@property (nonatomic, strong) JXCategoryIndicatorImageView *indicatorView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (nonatomic, strong) JHLuckyBagShowListVC *showListVC;
@property (nonatomic, strong) JHLuckyBagRewardVC *rewardVC;

@end

@implementation JHLuckyBagAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.jhTitleLabel.text = @"福袋";
    
    [self configPageTitleView];
    
}

#pragma mark - UI Methods
- (void)configPageTitleView {
    
    self.jhNavBottomLine.hidden = NO;
    
    [self.view addSubview:self.categoryTitleView];
    self.categoryTitleView.indicators = @[self.indicatorView];
    [self.view addSubview:self.categoryListContainerView];
    self.categoryTitleView.listContainer = self.categoryListContainerView;
    
    self.categoryTitleView.sd_layout
    .topSpaceToView(self.view, UI.statusAndNavBarHeight)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(38);
    
    self.categoryListContainerView.sd_layout
    .topSpaceToView(self.categoryTitleView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
}

#pragma mark - JXCategoryViewDelegate

- (JXCategoryTitleView *)categoryTitleView {
    if (!_categoryTitleView) {
        _categoryTitleView = [[JXCategoryTitleView alloc]init];
        _categoryTitleView.titles = @[@"福袋一览", @"奖励列表"];
        _categoryTitleView.backgroundColor = [UIColor clearColor];
        _categoryTitleView.titleColor = kColor999;
        _categoryTitleView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _categoryTitleView.titleSelectedFont = [UIFont fontWithName:kFontBoldPingFang size:14];
        _categoryTitleView.titleSelectedColor = kColor333;
        _categoryTitleView.cellSpacing = 25;
        _categoryTitleView.contentEdgeInsetLeft = 15;
        _categoryTitleView.averageCellSpacingEnabled = NO;
        _categoryTitleView.delegate = self;
    }
    return _categoryTitleView;
}

- (JXCategoryIndicatorImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[JXCategoryIndicatorImageView alloc] init];
        _indicatorView.backgroundColor = HEXCOLOR(0xffd70f);
        _indicatorView.layer.cornerRadius = 2.f;
        _indicatorView.clipsToBounds = YES;
        _indicatorView.indicatorImageViewSize = CGSizeMake(13., 4.);
        _indicatorView.verticalMargin = 2.;
    }
    return _indicatorView;
}

- (JXCategoryListContainerView *)categoryListContainerView {
    if (!_categoryListContainerView) {
        _categoryListContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _categoryListContainerView;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return [[JXCategoryTitleView alloc] init];
}
//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}
//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}
//正在滚动中的回调 ratio 从左往右计算的百分比
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio{
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return 2;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.showListVC;
    } else {
        return self.rewardVC;
    }
}

- (JHLuckyBagShowListVC *)showListVC{
    if (!_showListVC) {
        _showListVC = [[JHLuckyBagShowListVC alloc]init];
    }
    return _showListVC;
}

- (JHLuckyBagRewardVC *)rewardVC{
    if (!_rewardVC) {
        _rewardVC = [[JHLuckyBagRewardVC alloc]init];
    }
    return _rewardVC;
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

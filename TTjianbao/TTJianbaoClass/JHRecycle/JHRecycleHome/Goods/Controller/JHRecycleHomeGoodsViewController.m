//
//  JHRecycleHomeGoodsViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeGoodsViewController.h"
#import "JHRecycleHomeSubGoodsViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHRecycleHomeModel.h"
#import "JHRecycleHomeGoodsCateViewModel.h"
#import "JHRecycleHomeGoodsCateModel.h"
#import "UserInfoRequestManager.h"
#import "JHRecycleSquareHomeViewController.h"

@interface JHRecycleHomeGoodsViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray <JHRecycleHomeSubGoodsViewController *> *subVCArray;
@property (nonatomic, strong) NSMutableArray *titleDataArray;
@property (nonatomic, strong) JHRecycleHomeGoodsCateViewModel *goodsCateViewModel;



@end

@implementation JHRecycleHomeGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"大家都在卖";
    
    [self setupHeaderTitleView];

    [self loadData];
    
    [self configData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"回收大家都在卖页"
    } type:JHStatisticsTypeSensors];
}

#pragma mark - UI
- (void)setupHeaderTitleView {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"成为回收商" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [rightBtn addTarget:self action:@selector(clickApplyActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView);
        make.right.equalTo(self.jhNavView).mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(65, UI.navBarHeight));
    }];
    [self.view addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view).offset(0);
        make.height.offset(45);
    }];

    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
}

#pragma mark - LoadData
- (void)loadData{
    ///商品分类
    [self.goodsCateViewModel.goodsCateCommand execute:nil];
}
- (void)configData{
    
    @weakify(self)
    //商品分类
    [[RACObserve(self.goodsCateViewModel, goodsCateDataArray) skip:1] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        self.subVCArray = [NSMutableArray array];
        for (int i = 0; i < self.goodsCateViewModel.goodsCateDataArray.count; ++i) {
            //标题
            JHRecycleHomeGoodsCateModel *goodsCateModel = self.goodsCateViewModel.goodsCateDataArray[i];
            [self.titleDataArray addObject:goodsCateModel.cateName];
            //子类VC
            JHRecycleHomeSubGoodsViewController *vc =  [[JHRecycleHomeSubGoodsViewController alloc]init];
            vc.productCateId = goodsCateModel.cateId;
            [self.subVCArray addObject:vc];
            
            if ([goodsCateModel.cateId isEqual:self.goodsCateId]) {
                self.titleCategoryView.defaultSelectedIndex = i;
            }

        }
        
        self.titleCategoryView.titles = self.titleDataArray;
        self.titleCategoryView.listContainer = self.listContainerView;
        
    
        [self.titleCategoryView reloadData];
    }];
    
   
}

#pragma mark - Action
///成为回收商
- (void)clickApplyActionButton:(UIButton *)sender{
    /// 已开通店铺的去回收广场
    User *user = [UserInfoRequestManager sharedInstance].user;
    if ([JHRootController isLogin] && user.blRole_recycleBusiness ) {
        JHRecycleSquareHomeViewController *vc = [[JHRecycleSquareHomeViewController alloc] init];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else {
        [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/applyOpenShop.html") title:@"" controller:JHRootController];
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickToBeRecycler" params:@{
        @"page_position":@"recycleAggregationGoods"
    } type:JHStatisticsTypeSensors];
}

#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleDataArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.subVCArray[index];
    
}
#pragma mark - JXCategoryViewDelegate
//滚动/点击 都会走该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    JHRecycleHomeGoodsCateModel *goodsCateModel = self.goodsCateViewModel.goodsCateDataArray[index];
    NSDictionary *dic =@{
        @"tag_name":goodsCateModel.cateName,
        @"tag_id":goodsCateModel.cateId,
        @"page_position":@"recycleAggregationGoods"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickTag" params:dic type:JHStatisticsTypeSensors];
}

#pragma mark - Lazy
- (JHRecycleHomeGoodsCateViewModel *)goodsCateViewModel{
    if (!_goodsCateViewModel) {
        _goodsCateViewModel = [[JHRecycleHomeGoodsCateViewModel alloc] init];
    }
    return _goodsCateViewModel;
}
- (NSMutableArray *)titleDataArray{
    if (!_titleDataArray) {
        _titleDataArray = [NSMutableArray array];
    }
    return _titleDataArray;
}
- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryView.titleColor = HEXCOLOR(0x999999);
        _titleCategoryView.backgroundColor = [UIColor whiteColor];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:14];
        _titleCategoryView.titleSelectedColor = HEXCOLOR(0x222222);
        _titleCategoryView.averageCellSpacingEnabled = NO;//将cell均分
        _titleCategoryView.cellSpacing = 25;
        _titleCategoryView.contentEdgeInsetLeft = 16;
        _titleCategoryView.contentEdgeInsetRight = 16;
        _titleCategoryView.delegate = self;
    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

@end

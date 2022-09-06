//
//  JHMarketPublishListViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPublishListViewController.h"
#import "JHMarketPublishViewController.h"

static const CGFloat JHheightForHeaderInSection = 44;
@interface JHMarketPublishListViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 容器*/
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/** 控制器*/
@property (nonatomic, strong) NSMutableArray *vcArr;
@end

@implementation JHMarketPublishListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary *dic = @{
        @"page_name":@"集市订单我发布的页"
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf5f5f8);
    self.jhNavView.hidden = YES;
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(JHheightForHeaderInSection);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.categoryView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];

    self.categoryView.titles = @[@"出售中", @"下架宝贝"];
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.defaultSelectedIndex = self.itemIndex.integerValue;
    [self.categoryView reloadData];
    
    
}

#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.vcArr.count;
    
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArr[index];
}
- (JXCategoryTitleView *)categoryView {
   if (_categoryView == nil) {
       _categoryView = [[JXCategoryTitleView alloc] init];
       _categoryView.backgroundColor = [UIColor whiteColor];
       _categoryView.titleColor = HEXCOLOR(0x999999);
       _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
       _categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:14];
       _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
       _categoryView.contentEdgeInsetLeft = 17.;
       _categoryView.averageCellSpacingEnabled = NO;
       _categoryView.cellSpacing = 20;
       _categoryView.delegate = self;
   }
   return _categoryView;
}

- (JXCategoryListContainerView *)listContainerView {
   if (!_listContainerView) {
       _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
   }
   return _listContainerView;
}

- (NSMutableArray *)vcArr {
    if (_vcArr == nil) {
        _vcArr = [NSMutableArray array];
        JHMarketPublishViewController *publish1 = [[JHMarketPublishViewController alloc] init];
        publish1.productStatus = 0;
        [_vcArr addObject:publish1];
        
        JHMarketPublishViewController *publish3 = [[JHMarketPublishViewController alloc] init];
        publish3.productStatus = 1;
        [_vcArr addObject:publish3];
    }
    return _vcArr;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return self.categoryView;
}


#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

@end

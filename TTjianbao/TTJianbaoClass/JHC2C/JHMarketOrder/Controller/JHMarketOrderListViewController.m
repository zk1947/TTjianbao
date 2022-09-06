//
//  JHMarketOrderListViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderListViewController.h"
#import "JHMarketPublishListViewController.h"
#import "JHMarketOrderViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JXCategoryIndicatorImageView.h"

static const CGFloat JHheightForHeaderInSection = 44;

@interface JHMarketOrderListViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
/** 菜单栏*/
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
/** 容器*/
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
/** 控制器*/
@property (nonatomic, strong) NSMutableArray *vcArr;

@end

@implementation JHMarketOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"";
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.listContainerView];
    
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(50);
        make.bottom.mas_equalTo(self.jhNavView.mas_bottom);
        make.width.mas_equalTo(ScreenW - 100);
        make.height.mas_equalTo(JHheightForHeaderInSection);
    }];
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];

    self.categoryView.titles = @[@"我发布的", @"我买到的", @"我卖出的"];
    self.categoryView.listContainer = self.listContainerView;
    self.categoryView.defaultSelectedIndex = self.outItemIndex.integerValue;
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
       _categoryView.titleColor = HEXCOLOR(0x222222);
       _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
       _categoryView.titleSelectedFont = [UIFont fontWithName:kFontBoldDIN size:17];
       _categoryView.titleSelectedColor = HEXCOLOR(0x222222);
       _categoryView.cellSpacing = 10;
       _categoryView.delegate = self;
       
       JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
       indicatorImgView.indicatorImageView.backgroundColor = HEXCOLOR(0xfee100);
       indicatorImgView.indicatorImageViewSize = CGSizeMake(21, 3);
       indicatorImgView.layer.cornerRadius = 1.5;
       indicatorImgView.clipsToBounds = YES;
       indicatorImgView.verticalMargin = 8;
       _categoryView.indicators = @[indicatorImgView];
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
        JHMarketPublishListViewController *publishVc = [[JHMarketPublishListViewController alloc] init];
        publishVc.itemIndex = self.innerItemIndex;
        [_vcArr addObject:publishVc];
        
        JHMarketOrderViewController *orderBuyVc = [[JHMarketOrderViewController alloc] init];
        orderBuyVc.isBuyer = YES;
        [_vcArr addObject:orderBuyVc];
        
        JHMarketOrderViewController *orderSoldVc = [[JHMarketOrderViewController alloc] init];
        orderSoldVc.isBuyer = NO;
        [_vcArr addObject:orderSoldVc];
    }
    return _vcArr;
}

- (JXCategoryBaseView *)preferredCategoryView {
    return self.categoryView;
}



@end

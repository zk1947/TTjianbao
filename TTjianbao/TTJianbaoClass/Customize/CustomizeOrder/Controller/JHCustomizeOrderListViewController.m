//
//  JHCustomizeOrderListViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderListViewController.h"
#import "JHUIFactory.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"
#import "JHCustomizeOrderSubListViewController.h"
#import "JHCustomizeOrderModel.h"
#import "TTjianbaoBussiness.h"
@interface JHCustomizeOrderListViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSMutableArray <JHOrderCateMode*>*cateArr;
@property (nonatomic, strong) NSMutableArray <JHCustomizeOrderSubListViewController*>*vcArr;

@end

@implementation JHCustomizeOrderListViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex=0;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    self.title = @"定制订单";
    self.cateArr = [[JHCustomizeOrderModel getCustomizeOrderListCateArry:self.isSeller] mutableCopy];
    
    if (!self.isSeller) {
        [JHGrowingIO trackEventId:@"dz_orderlist_in"];
    }
    [self setupTitleCategoryView];
}
#pragma mark -
#pragma mark - JXCategoryView Methods

- (void)setupTitleCategoryView {
    
    NSMutableArray * arr = [NSMutableArray array];
    for (JHOrderCateMode *mode in self.cateArr) {
        [arr  addObject:mode.title];
    }
    self.titleCategoryView.titles = arr;
    [self.view addSubview:self.titleCategoryView];
    
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.offset(44);
        
    }];
    JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
    indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
    indicatorImageView.indicatorImageViewSize= CGSizeMake(15, 4);
    indicatorImageView.verticalMargin = 8;
    
    self.titleCategoryView.indicators = @[indicatorImageView];
    
    self.vcArr = [NSMutableArray array];
    
    for (JHOrderCateMode *mode in self.cateArr) {
        JHCustomizeOrderSubListViewController *vc =  [[JHCustomizeOrderSubListViewController alloc]init];
        vc.status = mode.status;
        vc.isSeller = self.isSeller;
        [self.vcArr addObject:vc];
    }
    [self.view addSubview:self.listContainerView];
    self.titleCategoryView.listContainer = self.listContainerView;
    
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
        
    }];
    self.titleCategoryView.defaultSelectedIndex = self.currentIndex;
}
- (JXCategoryTitleView *)titleCategoryView {
    
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:15];
        //  self.titleCategoryView.cellSpacing = 20;
        _titleCategoryView.titleColor = kColor666;
        _titleCategoryView.titleLabelVerticalOffset = -4;
        _titleCategoryView.backgroundColor = [UIColor whiteColor];
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
        _titleCategoryView.titleSelectedColor = kColor333;
        _titleCategoryView.averageCellSpacingEnabled = YES; //将cell均分
        _titleCategoryView.contentEdgeInsetLeft = 10;
        _titleCategoryView.contentEdgeInsetRight = 10;
         _titleCategoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    }
    return _titleCategoryView;
}

- (JXCategoryListContainerView *)listContainerView {
    if (!_listContainerView) {
        _listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    }
    return _listContainerView;
}

#pragma mark -
#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.cateArr.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    return self.vcArr[index];
    
}
- (void)dealloc
{
    NSLog(@"customizedealloc")
}
@end

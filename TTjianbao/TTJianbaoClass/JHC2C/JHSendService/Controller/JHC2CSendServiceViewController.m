//
//  JHC2CSendServiceViewController.m
//  TTjianbao
//
//  Created by hao on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSendServiceViewController.h"
#import "JHC2CPickupViewController.h"
#import "JHC2CSelfMailingViewController.h"
#import "JXCategoryIndicatorLineView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryListContainerView.h"


@interface JHC2CSendServiceViewController ()<JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *titleCategoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, copy) NSArray *titleArray;


@end

@implementation JHC2CSendServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约发货";
    self.titleArray = @[@"上门取件",@"自助寄出"];
    
    [self setupHeaderTitleView];
}

#pragma mark - UI
- (void)setupHeaderTitleView {
    [self.view addSubview:self.titleCategoryView];
    [self.titleCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.offset(54);
    }];

    [self.view addSubview:self.listContainerView];
    [self.listContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleCategoryView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
    
    self.titleCategoryView.titles = self.titleArray;
    self.titleCategoryView.listContainer = self.listContainerView;
}

#pragma mark - LoadData
- (void)loadData{
    [self.titleCategoryView reloadData];

}

#pragma mark  - Action


#pragma mark - Delegate
#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        JHC2CPickupViewController *pickupVC =  [[JHC2CPickupViewController alloc]init];
        pickupVC.appointmentSource = self.appointmentSource;
        pickupVC.orderId = self.orderId;
        pickupVC.orderCode = self.orderCode;
        pickupVC.productId = self.productId;
        pickupVC.productName = self.productName;
        pickupVC.customerFlag = self.customerFlag;
        pickupVC.appointmentSuccessSubject  = self.requestSuccessSubject;
        return pickupVC;
    }else{
        JHC2CSelfMailingViewController *selfVC =  [[JHC2CSelfMailingViewController alloc]init];
        selfVC.appointmentSource = self.appointmentSource;
        selfVC.orderId = self.orderId;
        selfVC.orderCode = self.orderCode;
        selfVC.productId = self.productId;
        selfVC.productName = self.productName;
        selfVC.customerFlag = self.customerFlag;
        selfVC.selfMailingSuccessSubject = self.requestSuccessSubject;
        return selfVC;
    }
    
    
}

#pragma mark - JXCategoryViewDelegate
//滚动/点击 都会走该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if (index == 0) {
        self.title = @"预约发货";
    }else{
        self.title = @"我要发货";
    }
}


#pragma mark - Lazy
- (JXCategoryTitleView *)titleCategoryView {
    if (!_titleCategoryView) {
        _titleCategoryView = [[JXCategoryTitleView alloc]init];
        _titleCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:16];
        _titleCategoryView.titleColor = HEXCOLOR(0x666666);
        _titleCategoryView.backgroundColor = UIColor.whiteColor;
        _titleCategoryView.titleSelectedFont = [UIFont fontWithName:kFontNormal size:16];
        _titleCategoryView.titleSelectedColor = HEXCOLOR(0x000000);
        _titleCategoryView.delegate = self;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = [CommHelp toUIColorByStr:@"#FFD70F"];
        lineView.indicatorWidth = 28;
        lineView.indicatorHeight = 4;
        lineView.verticalMargin = 10;
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
- (RACSubject *)requestSuccessSubject{
    if (!_requestSuccessSubject) {
        _requestSuccessSubject = [[RACSubject alloc] init];
    }
    return _requestSuccessSubject;
}
@end

//
//  JHNewStoreHomeViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeViewController.h"
#import "JHNewStoreHomeNav.h"
#import "JHNewStoreHomeBannerView.h"
#import "JXCategoryTitleView.h"

#import "JHNewStoreBannerModel.h"

#import "JHNewStoreCategoryTableCellTableViewCell.h"

@interface JHNewStoreHomeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate>
@property (nonatomic, strong) JHNewStoreHomeNav        *navView;
@property (nonatomic, strong) JHNewStoreHomeBannerView *bannerView;
@property (nonatomic, strong) UITableView              *homeStoreTableView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@end

@implementation JHNewStoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupViews];
    [self loadData];
}

- (void)setupNav {
    self.navView = [[JHNewStoreHomeNav alloc] init];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(UI.statusBarHeight+110.f);
    }];
}

- (JHNewStoreHomeBannerView *)bannerView {
    if (!_bannerView) {
        _bannerView = [JHNewStoreHomeBannerView bannerWithClickBlock:^(JHNewStoreBannerModel * _Nonnull bannerData) {
            [JHRootController toNativeVC:bannerData.target.componentName withParam:bannerData.target.params from:JHTrackMarketSaleClickSaleBanner];
        }];
    }
    return _bannerView;
}

- (void)setupViews {
    [self.view addSubview:self.homeStoreTableView];
    [self.homeStoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.homeStoreTableView.tableHeaderView = self.bannerView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (UITableView *)homeStoreTableView {
    if (!_homeStoreTableView) {
        _homeStoreTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _homeStoreTableView.dataSource                     = self;
        _homeStoreTableView.delegate                       = self;
        _homeStoreTableView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _homeStoreTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _homeStoreTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _homeStoreTableView.estimatedSectionHeaderHeight   = 0.1f;
            _homeStoreTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_homeStoreTableView registerClass:[JHNewStoreCategoryTableCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreCategoryTableCellTableViewCell class])];

        if ([_homeStoreTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_homeStoreTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_homeStoreTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_homeStoreTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _homeStoreTableView;
}


#pragma mark - load Data
- (void)loadData {
    
}


//获取热搜热词列表
- (void)getSearchHotWordsList {
//    @weakify(self);
//    [JHStoreApiManager getHotKeywords:^(NSArray *respObj, BOOL hasError) {
//        @strongify(self);
//        if (respObj) {
//            self.searchModel.hotList = [NSMutableArray arrayWithArray:respObj];
//            self.searchBar.placeholderArray = self.searchModel.hotList.mutableCopy;
//        }
//    }];
}

/// 获取新人福利信息
- (void)getNewPeopleGiftInfo {
//    @weakify(self);
//    [JHNewUserRedPacketAlertView getNewUserRedPacketEntranceWithLocation:2 complete:^(JHNewUserRedPacketAlertViewModel * _Nullable model) {
//        @strongify(self);
//        self.anewPeopleBannerModel = model.banner;
//        [self cofigNewPeopleGiftModelAndReloadData];
//        [self.pageListView.mainTableView reloadData];
//    }];
}


#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return 0;
    }
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section ==0) {
        return nil;
    }
    JXCategoryTitleView *view = [[JXCategoryTitleView alloc] init];
    view.backgroundColor = HEXCOLOR(0xFFFFFF);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}


@end

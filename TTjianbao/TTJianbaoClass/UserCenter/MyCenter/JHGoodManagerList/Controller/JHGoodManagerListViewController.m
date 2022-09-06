//
//  JHGoodManagerListViewController.m
//  TTjianbao
//
//  Created by user on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListViewController.h"
#import "JHNOAllowTabelView.h"
#import "JHGoodManagerListTableViewCell.h"
#import "JHGoodManagerListNavView.h"
#import "JHGoodManagerListChannelViewController.h"
#import "JHGoodManagerListBusiness.h"
#import "JHGoodManagerSingleton.h"
#import "JHStoreDetailViewController.h"
#import "IQKeyboardManager.h"
#import "BaseNavViewController.h"

#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ScreenBounds [[UIScreen mainScreen] bounds]     //屏幕frame
#define ScreenFullWidth [[UIScreen mainScreen] bounds].size.width     //屏幕宽度

@interface JHGoodManagerListViewController ()<
UITableViewDelegate,
UITableViewDataSource
//UIGestureRecognizerDelegate
>
@property (nonatomic, strong) JHGoodManagerListNavView               *navView;
@property (nonatomic, strong) JHNOAllowTabelView                     *goodListTabelView;
@property (nonatomic, strong) NSMutableArray                         *dataSourceArray;
@property (nonatomic, strong) JHGoodManagerListChannelViewController *filterController;
@property (nonatomic, strong) JHGoodManagerListRequestModel          *requestModel;
@property (nonatomic,   copy) NSString                               *lastId;
@end

@implementation JHGoodManagerListViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = YES;
    }
    [self resetAllRequestFilter];
    [self setRequestModelInfo];
    [self removeNavView];
    [self setupNav];
    [self setupViews];
    [self loadData];
    [self addObserver];
}

- (void)resetAllRequestFilter {
    [JHGoodManagerSingleton shared].minPrice         = @"";
    [JHGoodManagerSingleton shared].maxPrice         = @"";
    [JHGoodManagerSingleton shared].publishStartTime = @"";
    [JHGoodManagerSingleton shared].publishEndTime   = @"";
    [JHGoodManagerSingleton shared].searchName       = @"";
    [JHGoodManagerSingleton shared].firstCategoryId  = @"";
    [JHGoodManagerSingleton shared].secondCategoryId = @"";
    [JHGoodManagerSingleton shared].thirdCategoryId  = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    UINavigationController *naV = self.navigationController;
    if ([naV isKindOfClass:BaseNavViewController.class]) {
        BaseNavViewController *baseNav = (BaseNavViewController *)naV;
        baseNav.isForbidDragBack = NO;
    }
}

- (void)addObserver {
    /// 请求所有
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(channelFilterRequest) name:@"JHGOODMANAGERLISTSHOULDREQUEST" object:nil];
    
    /// 只请求列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navItemClickRequest) name:@"JHGOODMANAGERLISTSHOULDREQUEST——NEWLIST" object:nil];
    
    /// 只请求导航条
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navRefreshRequest) name:@"JHGOODMANAGERLISTSHOULDREQUEST——ONLYNAV" object:nil];
    
    /// 删除下架移除cell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCell:) name:@"JHGOODMANAGERLISTSHOULDREQUEST——REMOVECELL" object:nil];
    
    /// 仅更新当前cell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCell:) name:@"JHGOODMANAGERLISTSHOULDREQUEST——CHANGEGOODCELL" object:nil];
}

- (void)removeCell:(NSNotification *)no {
    NSIndexPath *indexPath = no.object;
    [self.dataSourceArray removeObjectAtIndex:indexPath.section];
    [self.goodListTabelView deleteSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateCell:(NSNotification *)no {
    NSIndexPath *indexPath = no.object;
    JHGoodManagerListModel *itemModel = self.dataSourceArray[indexPath.section];
    @weakify(self);
    [JHGoodManagerListBusiness updateOnlyGoodManagerListItem:itemModel.goodId productType:self.productType imageType:@"m" Completion:^(NSError * _Nullable error, JHGoodManagerListModel * _Nullable itemModel) {
        @strongify(self);
        if (!error && itemModel) {
            [self.dataSourceArray replaceObjectAtIndex:indexPath.section withObject:itemModel];
            
            [self.goodListTabelView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)channelFilterRequest {
    
    self.requestModel.minPrice = isEmpty([JHGoodManagerSingleton shared].minPrice)?nil:[JHGoodManagerSingleton shared].minPrice;
    self.requestModel.maxPrice = isEmpty([JHGoodManagerSingleton shared].maxPrice)?nil:[JHGoodManagerSingleton shared].maxPrice;
    
    self.requestModel.publishStartTime = isEmpty([JHGoodManagerSingleton shared].publishStartTime)?nil:[JHGoodManagerSingleton shared].publishStartTime;
    self.requestModel.publishEndTime = isEmpty([JHGoodManagerSingleton shared].publishEndTime)?nil:[JHGoodManagerSingleton shared].publishEndTime;
    
    self.requestModel.firstCategoryId = isEmpty([JHGoodManagerSingleton shared].firstCategoryId)?nil:[JHGoodManagerSingleton shared].firstCategoryId;
    self.requestModel.secondCategoryId = isEmpty([JHGoodManagerSingleton shared].secondCategoryId)?nil:[JHGoodManagerSingleton shared].secondCategoryId;
    self.requestModel.thirdCategoryId = isEmpty([JHGoodManagerSingleton shared].thirdCategoryId)?nil:[JHGoodManagerSingleton shared].thirdCategoryId;
    
    self.requestModel.searchName = isEmpty([JHGoodManagerSingleton shared].searchName)?nil:[JHGoodManagerSingleton shared].searchName;
    
    [self loadData];
}

- (void)navItemClickRequest {
    self.requestModel.productStatus = isEmpty([JHGoodManagerSingleton shared].productStatus)?nil:[JHGoodManagerSingleton shared].productStatus;
    [self loadDataWithoutNav];
}

- (void)setRequestModelInfo {
    self.requestModel.productType = self.productType;
    self.requestModel.imageType   = @"m";
    self.requestModel.pageNo      = 1;
    self.requestModel.pageSize    = 20;
}

- (void)setupNav {
    self.navView = [[JHGoodManagerListNavView alloc] init];
    if (self.productType == JHGoodManagerListRequestProductType_OnePrice) {
        self.navView.isAuction = NO;
    } else {
        self.navView.isAuction = YES;
    }
    self.navView.backgroundColor = HEXCOLOR(0xFFFFFF);
    [self.view addSubview:self.navView];
    CGFloat statusBarHeight = UI.statusBarHeight;
    CGFloat navHeight = statusBarHeight + 44.f; //+ 51.f;
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(navHeight);
    }];
    @weakify(self);
    self.navView.backBlock = ^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    self.navView.channelBlock = ^{
        @strongify(self);
        [self.filterController show];
        [self.filterController reloadData];
    };
    self.filterController = [[JHGoodManagerListChannelViewController alloc] initWithSponsor:self resetBlock:^(NSArray * _Nonnull dataList) {} commitBlock:^(NSArray * _Nonnull dataList) {}];
    _filterController.animationDuration = .3f;
    _filterController.sideSlipLeading = 0.15*[UIScreen mainScreen].bounds.size.width;
}




- (void)setupViews {
    [self.view addSubview:self.goodListTabelView];
    [self.goodListTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.bottom.left.right.equalTo(self.view);
    }];
    @weakify(self);
    [self.goodListTabelView jh_headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadDataWithoutNav];
    } footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

#pragma mark - load data
- (void)loadData {
    [self setRequestModelInfo];
        
    [self.dataSourceArray removeAllObjects];
    self.goodListTabelView.jh_EmputyView.hidden = YES;
    [self.goodListTabelView jh_footerStatusWithNoMoreData:NO];
    self.goodListTabelView.mj_footer.hidden = NO;
    
    [SVProgressHUD show];
    
    if (isEmpty(self.requestModel.productStatus)) {
        [JHGoodManagerSingleton shared].navProductStatus = JHGoodManagerListRequestProductStatus_ALL;
    } else {
        [JHGoodManagerSingleton shared].navProductStatus = [self.requestModel.productStatus integerValue];
    }
    @weakify(self);
    [JHGoodManagerListBusiness getGoodManagerList:self.requestModel Completion:^(NSError * _Nullable error, JHGoodManagerListAllDataModel * _Nullable dataModel) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self endRefresh];
        for (int i = 0; i<dataModel.statistics.count; i++) {
            JHGoodManagerListTabChooseModel *model = dataModel.statistics[i];
            if (!self.requestModel.productStatus || [self.requestModel.productStatus integerValue] == JHGoodManagerListRequestProductStatus_ALL) {
                if (i == 0) {
                    model.isSelected = YES;
                } else {
                    model.isSelected = NO;
                }
            } else {
                if ([self.requestModel.productStatus integerValue] == model.productStatus) {
                    model.isSelected = YES;
                } else {
                    model.isSelected = NO;
                }
            }
        }
        if (dataModel.statistics.count >0) {
            [self.navView setViewModel:dataModel.statistics];
            CGFloat navHeight = UI.statusBarHeight + 44.f + 51.f;
            [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(navHeight);
            }];
        } else {
            [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(UI.statusBarHeight + 44.f);
            }];
        }
        if (!dataModel || dataModel.record.lists.count == 0 || error) {
            [self.goodListTabelView jh_reloadDataWithEmputyView];
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
            return;
        }
        if (dataModel.record.lists.count<20) {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
        } else {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:NO];
            self.goodListTabelView.mj_footer.hidden = NO;
            self.requestModel.pageNo ++;
        }
        [self.dataSourceArray addObjectsFromArray:dataModel.record.lists];
        self.lastId = dataModel.record.lastId;
        [self.goodListTabelView reloadData];
    }];
}

- (void)loadMoreData {
    @weakify(self);
    self.requestModel.lastId = self.lastId;
    [JHGoodManagerListBusiness getGoodManagerList:self.requestModel Completion:^(NSError * _Nullable error, JHGoodManagerListAllDataModel * _Nullable dataModel) {
        @strongify(self);
        [self endRefresh];
        if (!dataModel || dataModel.record.lists.count == 0 || error) {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
            return;
        }
        if (dataModel.record.lists.count<20) {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
        } else {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:NO];
            self.goodListTabelView.mj_footer.hidden = NO;
            self.requestModel.pageNo ++;
        }
        [self.dataSourceArray addObjectsFromArray:dataModel.record.lists];
        self.lastId = dataModel.record.lastId;
        [self.goodListTabelView reloadData];
    }];
}


- (void)loadDataWithoutNav {
    [self setRequestModelInfo];
    self.requestModel.lastId = nil;
    
    [self.dataSourceArray removeAllObjects];
    self.goodListTabelView.jh_EmputyView.hidden = YES;
    [self.goodListTabelView jh_footerStatusWithNoMoreData:NO];
    self.goodListTabelView.mj_footer.hidden = NO;
    [SVProgressHUD show];
    
    if (isEmpty(self.requestModel.productStatus)) {
        [JHGoodManagerSingleton shared].navProductStatus = JHGoodManagerListRequestProductStatus_ALL;
    } else {
        [JHGoodManagerSingleton shared].navProductStatus = [self.requestModel.productStatus integerValue];
    }
    
    @weakify(self);
    [JHGoodManagerListBusiness getGoodManagerList:self.requestModel Completion:^(NSError * _Nullable error, JHGoodManagerListAllDataModel * _Nullable dataModel) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self endRefresh];
        if (!dataModel || dataModel.record.lists.count == 0 || error) {
            [self.goodListTabelView jh_reloadDataWithEmputyView];
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
            return;
        }
        if (dataModel.record.lists.count<20) {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:YES];
            self.goodListTabelView.mj_footer.hidden = YES;
        } else {
            [self.goodListTabelView jh_footerStatusWithNoMoreData:NO];
            self.goodListTabelView.mj_footer.hidden = NO;
            self.requestModel.pageNo ++;
        }
        [self.dataSourceArray addObjectsFromArray:dataModel.record.lists];
        self.lastId = dataModel.record.lastId;
        [self.goodListTabelView reloadData];
    }];
}

- (void)navRefreshRequest {
    @weakify(self);
    [JHGoodManagerListBusiness getGoodManagerListTabOnly:self.requestModel Completion:^(NSError * _Nullable error, NSArray<JHGoodManagerListTabChooseModel *> * _Nullable array) {
        @strongify(self);
        if (array.count >0) {
            for (int i = 0; i<array.count; i++) {
                JHGoodManagerListTabChooseModel *model = array[i];
                if (!self.requestModel.productStatus || [self.requestModel.productStatus integerValue] == JHGoodManagerListRequestProductStatus_ALL) {
                    if (i == 0) {
                        model.isSelected = YES;
                    } else {
                        model.isSelected = NO;
                    }
                } else {
                    if ([self.requestModel.productStatus integerValue] == model.productStatus) {
                        model.isSelected = YES;
                    } else {
                        model.isSelected = NO;
                    }
                }
            }
            [self.navView setViewModel:array];
            CGFloat navHeight = UI.statusBarHeight + 44.f + 51.f;
            [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(navHeight);
            }];
        } else {
            [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(UI.statusBarHeight + 44.f);
            }];
        }
    }];
}


- (void)endRefresh {
    [self.goodListTabelView.mj_header endRefreshing];
    [self.goodListTabelView.mj_footer endRefreshing];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}


- (JHGoodManagerListRequestModel *)requestModel {
    if (!_requestModel) {
        _requestModel = [[JHGoodManagerListRequestModel alloc] init];
    }
    return _requestModel;
}

- (JHNOAllowTabelView *)goodListTabelView {
    if (!_goodListTabelView) {
        _goodListTabelView                                = [[JHNOAllowTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodListTabelView.dataSource                     = self;
        _goodListTabelView.delegate                       = self;
        _goodListTabelView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _goodListTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _goodListTabelView.estimatedRowHeight             = 10.f;
        
        _goodListTabelView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _goodListTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _goodListTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_goodListTabelView registerClass:[JHGoodManagerListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHGoodManagerListTableViewCell class])];

        if ([_goodListTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_goodListTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_goodListTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_goodListTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _goodListTabelView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodManagerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHGoodManagerListTableViewCell class])];
    if (!cell) {
        cell = [[JHGoodManagerListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHGoodManagerListTableViewCell class])];
    }
    [cell setViewModel:self.dataSourceArray[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHGoodManagerListModel *model   = self.dataSourceArray[indexPath.section];
    JHStoreDetailViewController *vc = [[JHStoreDetailViewController alloc] init];
    vc.productId                    = model.goodId;
    vc.shotScreen                   = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end

//
//  JHCustomizeChooseViewController.m
//  TTjianbao
//
//  Created by user on 2020/11/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseViewController.h"
#import "JHCustommizeChooseInfoTableViewCell.h"
#import "JHCustomizeChooseBusiness.h"
#import "JHCustomerInfoController.h"
#import "UIScrollView+JHEmpty.h"
#import "UIView+Toast.h"
#import "JHGrowingIO.h"
#import "JHNOAllowTabelView.h"

@interface JHCustomizeChooseViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHNOAllowTabelView    *customerTabelView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger       requestPageIndex;
@end

@implementation JHCustomizeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.requestPageIndex = 0;
    [self removeNavView];
    [self setupViews];
    [self firstLoadData];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)firstLoadData {
    [SVProgressHUD show];
    JHCustomizeChooseRequestModel *model = [JHCustomizeChooseRequestModel new];
    model.customizeFeeId = self.ID;
    model.pageIndex = 0;
    self.requestPageIndex = 0;
    model.pageSize = 20;
    @weakify(self);
    [JHCustomizeChooseBusiness getChooseCustomize:model Completion:^(NSError * _Nonnull error, NSArray<JHCustomizeChooseModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        @strongify(self);
        [self endRefresh];
        if (!array || array.count == 0) {
            NSLog(@"错误页面");
            [self.customerTabelView jh_reloadDataWithEmputyView];
            return;
        }
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:array];
        self.requestPageIndex ++;
        if (array.count<20) {
            [self.customerTabelView jh_footerStatusWithNoMoreData:YES];
            self.customerTabelView.mj_footer.hidden = YES;
        } else {
            [self.customerTabelView jh_footerStatusWithNoMoreData:NO];
            self.customerTabelView.mj_footer.hidden = NO;
        }
        [self.customerTabelView reloadData];
    }];
}

- (void)loadData {
    JHCustomizeChooseRequestModel *model = [JHCustomizeChooseRequestModel new];
    model.customizeFeeId = self.ID;
    model.pageIndex = 0;
    self.requestPageIndex = 0;
    model.pageSize = 20;
    @weakify(self);
    [JHCustomizeChooseBusiness getChooseCustomize:model Completion:^(NSError * _Nonnull error, NSArray<JHCustomizeChooseModel *> * _Nullable array) {
        @strongify(self);
        [self endRefresh];
        if (!array || array.count == 0) {
            NSLog(@"错误页面");
            [self.customerTabelView jh_reloadDataWithEmputyView];
            return;
        }
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:array];
        self.requestPageIndex ++;
        if (array.count<20) {
            [self.customerTabelView jh_footerStatusWithNoMoreData:YES];
            self.customerTabelView.mj_footer.hidden = YES;
        } else {
            [self.customerTabelView jh_footerStatusWithNoMoreData:NO];
            self.customerTabelView.mj_footer.hidden = NO;
        }
        [self.customerTabelView reloadData];
    }];
}

- (void)loadMoreData {
    JHCustomizeChooseRequestModel *model = [JHCustomizeChooseRequestModel new];
    model.customizeFeeId = self.ID;
    model.pageIndex = self.requestPageIndex;
    model.pageSize = 20;
    @weakify(self);
    [JHCustomizeChooseBusiness getChooseCustomize:model Completion:^(NSError * _Nonnull error, NSArray<JHCustomizeChooseModel *> * _Nullable array) {
        @strongify(self);
        [self endRefresh];
        if (!array || array.count == 0) {
            [self.view makeToast:@"加载失败，请稍后重试" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        [self.dataSourceArray addObjectsFromArray:array];
        self.requestPageIndex ++;
        if (array.count<20) {
            [self.customerTabelView jh_footerStatusWithNoMoreData:YES];
            self.customerTabelView.mj_footer.hidden = YES;
        } else {
            [self.customerTabelView jh_footerStatusWithNoMoreData:NO];
            self.customerTabelView.mj_footer.hidden = NO;
        }
        [self.customerTabelView reloadData];
    }];
}

- (void)endRefresh {
    [self.customerTabelView.mj_header endRefreshing];
    [self.customerTabelView.mj_footer endRefreshing];
}

- (void)setupViews {
    [self.view addSubview:self.customerTabelView];
    [self.customerTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f));
    }];
    @weakify(self);
    [self.customerTabelView jh_headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    } footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
}

- (JHNOAllowTabelView *)customerTabelView {
    if (!_customerTabelView) {
        _customerTabelView                                = [[JHNOAllowTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _customerTabelView.dataSource                     = self;
        _customerTabelView.delegate                       = self;
        _customerTabelView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _customerTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _customerTabelView.estimatedRowHeight             = 10.f;
        
        _customerTabelView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _customerTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _customerTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_customerTabelView registerClass:[JHCustommizeChooseInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHCustommizeChooseInfoTableViewCell class])];

        if ([_customerTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_customerTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_customerTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_customerTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _customerTabelView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 10;
    }
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
////    return 10.f;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HEXCOLOR(0xF5F6FA);
        return view;
    }
    return nil;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = HEXCOLOR(0xF5F6FA);
//    return view;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustommizeChooseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHCustommizeChooseInfoTableViewCell class])];
    if (!cell) {
        cell = [[JHCustommizeChooseInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHCustommizeChooseInfoTableViewCell class])];
    }
    [cell setViewModel:self.dataSourceArray[indexPath.section]];
    @weakify(self);
    cell.showAllAction = ^{
        @strongify(self);
        [self.customerTabelView reloadData];
    };
    cell.applyBtnAction = ^{
        /// 申请定制点击事件
        @strongify(self);
        JHCustomizeChooseModel *model = self.dataSourceArray[indexPath.section];
        if (!model) {
            [self.view makeToast:@"申请失败，请稍后重试" duration:2.0 position:CSToastPositionCenter];
            return;
        }
        [JHGrowingIO trackPublicEventId:@"dz_sqdz_click" paramDict:@{
            @"channelLocalId":@(model.customerId),/// 定制师ID
            @"tabname":NONNULL_STR(self.name)   /// tab定制名称
        }];
        
        if (model.status == 2) {
            if ([model.canCustomize isEqualToString:@"1"]) {
                [JHRootController EnterLiveRoom:[NSString stringWithFormat:@"%ld",(long)model.channelId] fromString:@"dz_sqdz_in" isStoneDetail:NO isApplyConnectMic:YES];
            } else {
                [JHRootController EnterLiveRoom:[NSString stringWithFormat:@"%ld",(long)model.channelId] fromString:@"dz_sqdz_in" isStoneDetail:NO isApplyConnectMic:NO];
            }
        } else {
            [JHRootController EnterLiveRoom:[NSString stringWithFormat:@"%ld",(long)model.channelId] fromString:@"dz_sqdz_in" isStoneDetail:NO isApplyConnectMic:NO];
        }
    };
    cell.iconClickAction = ^{
        /// 点击头像，跳定制师主页
        @strongify(self);
        JHCustomizeChooseModel *model = self.dataSourceArray[indexPath.section];
        if (!model) {
            return;
        }
        if (model.status == 2) {
            [JHRootController EnterLiveRoom:[NSString stringWithFormat:@"%ld",(long)model.channelId] fromString:@"dz_sqdz_in" isStoneDetail:NO isApplyConnectMic:NO];
        } else {
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
            vc.anchorId = [NSString stringWithFormat:@"%ld",(long)model.customerId];
            vc.channelLocalId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
            vc.fromSource = @"dz_sqdz_in";
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    cell.opusListClickAction = ^{
        /// 点击代表作
        @strongify(self);
        JHCustomizeChooseModel *model = self.dataSourceArray[indexPath.section];
        if (!model) {
            return;
        }
        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
        vc.roomId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
        vc.anchorId = [NSString stringWithFormat:@"%ld",(long)model.customerId];
        vc.channelLocalId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
        vc.fromSource = @"dz_sqdz_in";
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeChooseModel *model = self.dataSourceArray[indexPath.section];
    if (!model) {
        return;
    }
    JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
    vc.roomId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
    vc.anchorId = [NSString stringWithFormat:@"%ld",(long)model.customerId];
    vc.channelLocalId = [NSString stringWithFormat:@"%ld",(long)model.channelId];
    vc.fromSource = @"dz_sqdz_in";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    NSLog(@"%s🔥",__func__);
}

@end

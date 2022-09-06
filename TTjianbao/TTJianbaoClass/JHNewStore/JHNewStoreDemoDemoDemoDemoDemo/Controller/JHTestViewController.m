//
//  JHTestViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTestViewController.h"
#import "UIScrollView+JHEmpty.h"
#import "SVProgressHUD.h"

#import "JHNOAllowTabelView.h"
#import "JHTestTableViewCell.h"

#import "JHTestBusiness.h"
#import "JHTestTableViewCellViewModel.h"

@interface JHTestViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHNOAllowTabelView *loTabelView;
@property (nonatomic, strong) NSMutableArray     *dataSourceArray;
@end

@implementation JHTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物流信息";
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self setupViews];
    [self loadData];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CGFloat)navViewHeight {
    CGFloat navHeight = UI.statusBarHeight + 44.f;
    return navHeight;
}

- (void)setupViews {
    [self.view addSubview:self.loTabelView];
    [self.loTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake([self navViewHeight], 0.f, 0.f, 0.f));
    }];
}

- (UITableView *)loTabelView {
    if (!_loTabelView) {
        _loTabelView                                = [[JHNOAllowTabelView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _loTabelView.dataSource                     = self;
        _loTabelView.delegate                       = self;
        _loTabelView.backgroundColor                = HEXCOLOR(0xF5F6FA);
        _loTabelView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _loTabelView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _loTabelView.estimatedSectionHeaderHeight   = 0.1f;
            _loTabelView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        [_loTabelView registerClass:[JHTestTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHTestTableViewCell class])];
        

        if ([_loTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_loTabelView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_loTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_loTabelView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _loTabelView;
}

/// 物流请求接口
- (void)loadData {
    [SVProgressHUD show];
    @weakify(self);
    [JHTestBusiness requestCustomizeLogistics:self.orderId userType:self.userType Completion:^(NSError * _Nullable error, NSArray<JHTestTableViewCellViewModel *> * _Nullable models) {        
        [SVProgressHUD dismiss];
        @strongify(self);
        if (error || !models || models.count == 0) {
            [self.loTabelView jh_reloadDataWithEmputyView];
        }
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:models];
        [self.loTabelView reloadData];
    }];
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
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
    JHTestTableViewCellViewModel *model = self.dataSourceArray[section];
    return model.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHTestTableViewCell class])];
    if (!cell) {
        cell = [[JHTestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHTestTableViewCell class])];
    }
    JHTestTableViewCellViewModel *model = [JHTestTableViewCellViewModel cast:self.dataSourceArray[indexPath.section]];
    if (model) {
        [cell setViewModel:model.dataArr[0]];
    }
    return cell;
}


@end

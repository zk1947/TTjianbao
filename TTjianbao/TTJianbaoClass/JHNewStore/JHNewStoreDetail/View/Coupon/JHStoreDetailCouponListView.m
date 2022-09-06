//
//  JHStoreDetailCouponListView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponListView.h"
#import "JHStoreDetailCouponListCell.h"
#import "JHRefreshGifHeader.h"
#import "SVProgressHUD.h"
#import "MBProgressHUD.h"

static const CGFloat TitleTopSpace = 16.0f;

@interface JHStoreDetailCouponListView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JHStoreDetailCouponListView


#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self registerCells];
        [self bindData];
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void) didClickCloseButton : (UIButton *)sender {
    [self.dismissSubject sendNext:nil];
}
#pragma mark - Private Functions
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView jh_reloadDataWithEmputyView];
    }];
    [self.viewModel.showProgress subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self showProgressHUD];
    }];
    [self.viewModel.hideProgress subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self hideProgressHUD];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self hideProgressHUD];
    }];
    [RACObserve(self.viewModel, toastMsg) subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSString *str = [NSString stringWithFormat:@"%@", x];
        if (str.length <= 0) { return; }
        [self makeToast:str duration:1.0 position:CSToastPositionCenter];
    }];
    [RACObserve(self.viewModel, sellerId) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        [self setupMJRefresh];
        [self showProgressHUD];
        [self.viewModel getCouponList];
    }];
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self animated:true];
}
-(void)setupMJRefresh {
    @weakify(self);
    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel getCouponList];
    }];
//    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.titleLabel];
    [self addSubview:self.closeButton];
    [self addSubview:self.tableView];
}
- (void)layoutViews {
    [self jh_cornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight bounds: self.bounds];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(TitleTopSpace);
        make.centerX.equalTo(self);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(TitleTopSpace);
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight);
    }];
    
}
- (void) registerCells {
    [self.tableView registerClass:[JHStoreDetailCouponListCell class] forCellReuseIdentifier:@"JHStoreDetailCouponListCell"];
}
#pragma mark - Tableview Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cellList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCouponListCellViewModel *model = self.viewModel.cellList[indexPath.section];
    JHStoreDetailCouponListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailCouponListCell" forIndexPath:indexPath];
    cell.viewModel = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCouponListCellViewModel *model = self.viewModel.cellList[indexPath.row];
    return model.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.whiteColor;
    return view;
}
#pragma mark - Lazy
- (JHStoreDetailCouponListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHStoreDetailCouponListViewModel alloc] init];
    }
    return _viewModel;
}
- (RACSubject *)dismissSubject {
    if (!_dismissSubject) {
        _dismissSubject = [RACSubject subject];
    }
    return _dismissSubject;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.text = @"优惠券";
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = BLACK_COLOR;
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton
        .jh_imageName(@"newStore_coupon_close_icon")
        .jh_action(self,@selector(didClickCloseButton:));
    }
    return _closeButton;
}
- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
@end

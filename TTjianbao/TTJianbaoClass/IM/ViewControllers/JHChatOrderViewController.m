//
//  JHChatOrderViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderViewController.h"
#import "JHChatOrderViewModel.h"
#import "JHChatOrderViewCell.h"
#import "UIView+JHGradient.h"

@interface JHChatOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) JHChatOrderViewModel *viewModel;

@end

@implementation JHChatOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self registerCells];
    [self bindData];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutViews];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            [self dismissViewControllerAnimated:true completion:nil];
            return;
        }
    }
}
#pragma mark - Event
- (void)sendOrderMessage : (JHChatOrderInfoModel *)model {
    [self.sendOrderMessage sendNext:model];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)gotoDetailPageEvent : (JHChatOrderInfoModel *)model {
    [self.gotoDetailPage sendNext:model];
    [self dismissViewControllerAnimated:false completion:nil];
}

- (void)didClickClose : (UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (void)showToast : (NSString *)msg {
    [self.view makeToast:msg duration:1 position: CSToastPositionCenter];
}
- (void)bindData {
    @weakify(self)
    [self.viewModel.reloadData subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView jh_reloadDataWithEmputyView];
    }];
    
    [self.viewModel.toast subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x == nil) return ;
        [self showToast:x];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView jh_endRefreshing];
    }];
}
#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeButton];
    [self.containerView addSubview:self.tableView];
}
- (void)layoutViews {
    [self.containerView jh_cornerRadius:10 rectCorner:UIRectCornerTopLeft | UIRectCornerTopRight bounds:self.containerView.bounds];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ScreenH * 3 / 4);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}
- (void)registerCells {
    [self.tableView registerClass:[JHChatOrderViewCell class] forCellReuseIdentifier:@"JHChatOrderViewCell"];
}
#pragma mark - Tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHChatOrderInfoModel *model = self.viewModel.dataSource[indexPath.row];
    JHChatOrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHChatOrderViewCell" forIndexPath:indexPath];
    cell.model = model;
    @weakify(self)
    [cell.sendSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self sendOrderMessage: model];
    }];
    
    [cell.detailSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self gotoDetailPageEvent: model];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 128;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - LAZY
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.text = @"订单列表";
    }
    return _titleLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"IM_order_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = HEXCOLOR(0xf5f6fa);
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        @weakify(self)
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel loadNewData];
        }];
        _tableView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel loadNextPageData];
        }];
    }
    return _tableView;
}
- (JHChatOrderViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHChatOrderViewModel alloc] initWithAccount:self.account receiveAccount:self.receiveAccount];
    }
    return _viewModel;
}
- (RACSubject<JHChatOrderInfoModel *> *)sendOrderMessage {
    if (!_sendOrderMessage) {
        _sendOrderMessage = [RACSubject subject];
    }
    return _sendOrderMessage;
}
- (RACSubject<JHChatOrderInfoModel *> *)gotoDetailPage {
    if (!_gotoDetailPage) {
        _gotoDetailPage = [RACSubject subject];
    }
    return _gotoDetailPage;
}

@end

//
//  JHMerchantShopManageController.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMerchantShopManageController.h"
#import "JHShopServicePageController.h"
#import "JHShopInfoViewController.h"
#import "JHShopManageHeaderView.h"
#import "UserInfoRequestManager.h"

@interface JHMerchantShopManageController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHShopManageHeaderView *headerView;
@property (nonatomic, copy) NSArray *listArray;
@end

@implementation JHMerchantShopManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jhTitleLabel.text = @"店铺管理";
    ///认证信息: 这期不做认证信息模块 后面加 ---- TODO lihui
    _listArray = @[@"服务剩余时间", @"店铺信息"];
    [self configUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.headerView reloadData];
}

- (void)configUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = HEXCOLOR(0xF8F8F8);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    _tableView.tableHeaderView = self.headerView;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifer"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _listArray[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    cell.textLabel.textColor = kColor333;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            ///服务剩余时间
            JHShopServicePageController *vc = [[JHShopServicePageController alloc] init];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            ///服务剩余时间
            NSString *sellerId = [UserInfoRequestManager sharedInstance].user.customerId;
            JHShopInfoViewController *vc = [[JHShopInfoViewController alloc] init];
            vc.sellerId = sellerId;
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}

- (JHShopManageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHShopManageHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [JHShopManageHeaderView headerHeight])];
    }
    return _headerView;
}

@end

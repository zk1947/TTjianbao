//
//  JHRecycleOrderPursueViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderPursueViewController.h"
#import "JHRecycleOrderPursueModel.h"
#import "JHRecycleOrderPursueCell.h"
#import "JHRefreshGifHeader.h"
#import "JHRecycleOrderPurseViewModel.h"
#import "SVProgressHUD.h"
#import "JHRecycleOrderPursueModel.h"

@interface JHRecycleOrderPursueViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <JHRecycleOrderPursueModel *>*listArray;

@end

@implementation JHRecycleOrderPursueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xf5f6fa);
    self.title = @"订单追踪";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.jhNavView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = @(self.orderId.integerValue);
    [SVProgressHUD show];
    [JHRecycleOrderPurseViewModel getOrderPursueList:params Completion:^(NSError * _Nullable error, NSArray<JHRecycleOrderPursueModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            self.listArray = array;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleOrderPursueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHRecycleOrderPursueCell"];
    JHRecycleOrderPursueModel *model = self.listArray[indexPath.row];
    cell.model = model;
    if (indexPath.row == 0) {
        cell.statusLabel.textColor = HEXCOLOR(0x333333);
        cell.desLabel.textColor = HEXCOLOR(0x666666);
        cell.timeLabel.textColor = HEXCOLOR(0x333333);
        cell.lineTopView.hidden = YES;
        if (model.recycleNode == 11) {
            cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_finish"];
        } else {
            cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ing"];
        }
    } else {
        cell.statusLabel.textColor = HEXCOLOR(0x999999);
        cell.desLabel.textColor = HEXCOLOR(0x999999);
        cell.timeLabel.textColor = HEXCOLOR(0x999999);
        cell.tagImageView.image = [UIImage imageNamed:@"recycle_logistics_ed"];
        cell.lineTopView.hidden = NO;
    }
    if (indexPath.row == self.listArray.count - 1) {
        cell.lineBottomView.hidden = YES;
    } else {
        cell.lineBottomView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = HEXCOLOR(0xf5f5f8);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[JHRecycleOrderPursueCell class] forCellReuseIdentifier:@"JHRecycleOrderPursueCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
    }
    return _tableView;
}

@end

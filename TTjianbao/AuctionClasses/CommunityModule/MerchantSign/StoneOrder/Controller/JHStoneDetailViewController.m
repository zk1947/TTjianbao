//
//  JHStoneDetailViewController.m
//  TaodangpuAuction
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHStoneDetailViewController.h"
#import "JHStoneDetailViewController.h"
#import "JHOriginStoneModel.h"

@interface JHStoneDetailViewController () <UITableViewDataSource, UITableViewDelegate>



@end

@implementation JHStoneDetailViewController


- (void)configNavBar {
    [self  initToolsBar];
    [self.navbar setTitle:@"订单详情"];
    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"返回.png"] withHImage:[UIImage imageNamed:@"返回.png"] withFrame:CGRectMake(0,0,44,44)];
    [self.navbar.comBtn addTarget :self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    //注册cell
//    [self registCell];
    
    [self loadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (!indexPath.section) { ///地址
//
//    }
    
    static NSString *identifer = @"JHStoneInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    JHOriginStoneModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"订单编号：%@", model.buyOrderNumber];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoneDetailViewController *detailVC = [[JHStoneDetailViewController alloc]init];
    JHOriginStoneModel *model = self.dataArray[indexPath.row];
    detailVC.originStoneModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)registCell {
    ///原石信息
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"JHStoneInfoCell"];
    
    
}

- (void)loadData {
    for (int i = 0; i < 5; i ++) {
        JHOriginStoneModel *model = [[JHOriginStoneModel alloc] init];
        model.title = @"莫西沙原石 冰种 10KG";
        model.stoneDescription = @"无";
        model.price = @28880000;
        model.stoneStatus = JHOriginStoneStatusWaitSoldout;
        model.buyOrderNumber = @"x67465399766322";
        model.saleOrderNumber = @"x63297362334956";
        model.liveRoomId = @"23122";
        model.liveRoomName = @"四喜翡翠";
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}






@end

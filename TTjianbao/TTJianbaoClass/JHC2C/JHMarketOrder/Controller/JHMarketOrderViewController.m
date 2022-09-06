//
//  JHMarketOrderViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderViewController.h"
#import "JHMarketOrderCell.h"
#import "JHMarketOrderModel.h"
#import "JHEmptyTableViewCell.h"
#import "YDRefreshFooter.h"
#import "JHMarketOrderDetailViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHWebViewController.h"

@interface JHMarketOrderViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 提示文本框*/
@property (nonatomic, strong) YYLabel *alertLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <JHMarketOrderModel *>*listArray;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JHMarketOrderViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *str = self.isBuyer ? @"集市订单我买到的页" : @"集市订单我卖出的页";
    NSDictionary *dic = @{
        @"page_name":str
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSingleCell) name:@"REFRESH_AFTER_PAY" object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)refreshSingleCell {
    JHMarketOrderModel *model = self.listArray[self.indexPath.row];
    [self loadSingleDataWithOrderId:model.orderId indexPath:self.indexPath];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNo = 1;
    self.pageSize = 10;
    self.jhNavView.hidden = YES;
    self.view.backgroundColor = HEXCOLOR(0xf5f5f8);
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.tableView];
    
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.alertLabel.mas_bottom);
        make.bottom.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self refreshData];
}

- (void)refreshData {
    self.pageNo = 1;
    [self.tableView.mj_footer resetNoMoreData];
    [SVProgressHUD show];
    [self loadData];
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = @(self.pageNo);
    params[@"pageSize"] = @(self.pageSize);
    params[@"imageType"] = @"s";
    [JHMarketOrderViewModel getOrderList:params isBuyer:self.isBuyer Completion:^(NSError * _Nullable error, NSArray<JHMarketOrderModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!error) {
            if (self.pageNo == 1) {
                self.listArray = [NSMutableArray arrayWithArray:array];
            } else {
                [self.listArray addObjectsFromArray:array];
            }
            
            if (array.count < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                self.pageNo += 1;
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

/// 刷新单条数据
- (void)loadSingleDataWithOrderId:(NSString *)orderId indexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = orderId;
    params[@"imageType"] = @"s";
    [SVProgressHUD show];
    [JHMarketOrderViewModel getOrderList:params isBuyer:self.isBuyer Completion:^(NSError * _Nullable error, NSArray<JHMarketOrderModel *> * _Nullable array) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (array.count > 0) {
                JHMarketOrderModel *model = array.firstObject;
                JHMarketOrderCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.model = model;
                self.listArray[indexPath.row] = model;
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count ? self.listArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.listArray.count ? UITableViewAutomaticDimension : self.tableView.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        JHEmptyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHEmptyTableViewCell"];
        cell.backgroundColor = HEXCOLOR(0xf5f5f8);
        cell.emptyLabel.text = @"您还没有订单哦";
        [cell.emptyButton setTitle:@"去看看" forState:UIControlStateNormal];
        cell.emptyButton.hidden = NO;
        cell.buttonClickActionBlock = ^{
            [[JHRootController currentViewController].navigationController popToRootViewControllerAnimated:YES];
//            [JHRootController setTabBarSelectedIndex:0];
            //处理点击运营位跳转VC后tabBar不切换问题
            NSDictionary *dict = @{
                @"selectedIndex":@"0"
            };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"POST_JHHOMETABCONTROLLER" object:dict];
//            [JHNotificationCenter postNotificationName:kSQNeedSwitchToRcmdTabNotication object:nil];
        };
        return cell;
    }
    JHMarketOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketOrderCell"];
    JHMarketOrderModel *model = self.listArray[indexPath.row];
    cell.model = model;
    cell.isBuyer = self.isBuyer;
    @weakify(self);
    cell.reloadCellDataBlock = ^(BOOL iSdelete) {
        @strongify(self);
        if (iSdelete) {
            [self.listArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
            if (self.listArray.count > 0) {
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [self loadSingleDataWithOrderId:model.orderId indexPath:indexPath];
        }
    };
    
    cell.payButtonClick = ^{
        @strongify(self);
        self.indexPath = indexPath;
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listArray.count == 0) {
        return;
    }
    self.indexPath = indexPath;
    JHMarketOrderModel *model = self.listArray[indexPath.row];
    JHMarketOrderDetailViewController *orderView = [[JHMarketOrderDetailViewController alloc] init];
    orderView.orderId = model.orderId;
    orderView.isBuyer = self.isBuyer;
    @weakify(self);
    orderView.completeRefreshBlock = ^(BOOL isDelete) {
        @strongify(self);
        if (isDelete) {
            [self.listArray removeObjectAtIndex:indexPath.row];
            NSMutableArray *indexPathArray = [NSMutableArray arrayWithObject:indexPath];
            if (self.listArray.count > 0) {
                [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationNone];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            [self loadSingleDataWithOrderId:model.orderId indexPath:indexPath];
        }
        
    };
    [self.navigationController pushViewController:orderView animated:YES];
    
}

- (YYLabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[YYLabel alloc] init];
        _alertLabel.backgroundColor = HEXCOLOR(0xfffaf2);
        _alertLabel.numberOfLines = 2;
        _alertLabel.textContainerInset = UIEdgeInsetsMake(5, 15, 5, 15);
        _alertLabel.preferredMaxLayoutWidth = ScreenW;
        
        NSString *str = @"请卖家录制发货视频，如因品相或破损产生交易纠纷，卖家可依据拍摄视频进行举证，查看具体规则";
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: str];
            text.lineSpacing = 5;
        text.font = [UIFont fontWithName:kFontNormal size:12];
        text.color = HEXCOLOR(0xff6a00);
        @weakify(self);
        [text setTextHighlightRange:NSMakeRange(str.length - 4, 4) color:HEXCOLOR(0x408ffe) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            if (self.isBuyer) {
                webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/dealDisputeBuy.html");
            }else {
                webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/dealDispute.html");
            }
            
            [self.navigationController pushViewController:webView animated:YES];
        }];
        [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(str.length - 4, 4)];//下划线类型
        [text addAttribute:NSUnderlineColorAttributeName value:
         HEXCOLOR(0x408ffe) range:NSMakeRange(str.length - 4, 4)];//下划线颜色
        _alertLabel.attributedText = text;
    }
    return _alertLabel;
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
        [_tableView registerClass:[JHMarketOrderCell class] forCellReuseIdentifier:@"JHMarketOrderCell"];
        [_tableView registerClass:[JHEmptyTableViewCell class] forCellReuseIdentifier:@"JHEmptyTableViewCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        _tableView.mj_footer = [YDRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
        ((YDRefreshFooter *)_tableView.mj_footer).showNoMoreString = YES;
    }
    return _tableView;
}

- (NSMutableArray<JHMarketOrderModel *> *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end

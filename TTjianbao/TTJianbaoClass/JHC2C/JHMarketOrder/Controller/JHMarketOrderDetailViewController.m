//
//  JHMarketOrderDetailViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderDetailViewController.h"
#import "JHMarketStatusCell.h"
#import "JHMarketAddressCell.h"
#import "JHMarketDetailCell.h"
#import "JHMarketPriceCell.h"
#import "JHMarketInfoCell.h"
#import "JHMarketContactCell.h"
#import "JHMarketOrderButtonsView.h"
#import "JHMarketOrderModel.h"
#import "JHMarketOrderViewModel.h"
#import "JHC2CProductDetailController.h"

#define kHeaderH (140 + UI.topSafeAreaHeight)

@interface JHMarketOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
/** 数据*/
@property (nonatomic, strong) JHMarketOrderModel *orderModel;
/** 按钮逻辑*/
@property (nonatomic, strong) JHMarketOrderButtonsView *buttonsView;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 计时器*/
@property (nonatomic, strong) NSTimer *timer;
/** */
@property (nonatomic, strong) JHMarketStatusCell *statusCell;
@end

@implementation JHMarketOrderDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.orderModel.timeDuring > 0) {
        //开启倒计时
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        //    加入运行循环
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
    NSString *str = self.isBuyer ? @"集市订单订单详情买家页" : @"集市订单订单详情卖家页";
    NSDictionary *dic = @{
        @"page_name":str,
        @"order_id":self.orderId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:dic type:JHStatisticsTypeSensors];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"REFRESH_AFTER_PAY" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
// 计时器跳动 刷新cellUI
/** 订单状态code  1 待确认 2 待付款 3 支付中 4 待发货 5 已预约 6 待收货 7 已完成 8 退货退款中 9 已退款 10 已关闭 11 待鉴定 12 已鉴定*/
- (void)timeFireMethod {
    if (self.orderModel.timeDuring < 0) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    if (self.orderModel.timeDuring == 0) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self loadData];
        if (self.completeRefreshBlock) {
            self.completeRefreshBlock(NO);
        }
        return;
    }
//    self.orderModel.timeDuring --;
    switch (self.orderModel.orderStatus.integerValue) {
        case 1:
        case 2: //待付款
            self.statusCell.statusLabel.text = [NSString stringWithFormat:@"剩%@未支付,订单将自动关闭", [self getTimeFirmatWithString]];
            break;
        case 6: //待收货
            if (self.isBuyer) {
                self.statusCell.statusLabel.text = [NSString stringWithFormat:@"%@后，您仍未确认收货， 系统会自动确认收货，钱款将会打到卖家的账户， 您将无法再发起退款等售后申请", [self getTimeFirmatWithString]];
            } else {
                self.statusCell.statusLabel.text = [NSString stringWithFormat:@"%@后，买家未确认收货， 系统自动收货，交易金额将自动发放至我的零钱", [self getTimeFirmatWithString]];
            }
            break;
        default:
            self.statusCell.statusLabel.text = [NSString stringWithFormat:@"剩余时间: %@", [self getTimeFirmatWithString]];
            break;
    }
}

- (NSString *)getTimeFirmatWithString {
    NSString *day = [NSString stringWithFormat:@"%02ld", self.orderModel.timeDuring / (3600 * 24)];
    NSString *hour = [NSString stringWithFormat:@"%02ld", (self.orderModel.timeDuring % (3600 * 24)) / 3600];
    NSString *minute = [NSString stringWithFormat:@"%02ld", (self.orderModel.timeDuring % 3600) / 60];
    NSString *second = [NSString stringWithFormat:@"%02ld", self.orderModel.timeDuring % 60];
    NSString *str = @"";
    if (day.doubleValue > 1) {
        str = [str stringByAppendingFormat:@"%@天", day];
    } else if(day.integerValue == 1) {
        hour = [NSString stringWithFormat:@"%ld", hour.integerValue + 24];
    }
    if (hour.doubleValue > 0) {
        str = [str stringByAppendingFormat:@"%@时", hour];
    }
    if (minute.doubleValue > 0) {
        str = [str stringByAppendingFormat:@"%@分", minute];
//        str = [str stringByAppendingFormat:@"%@分%@秒", minute, second];
    }
    if (second.doubleValue > 0) {
        str = [str stringByAppendingFormat:@"%@秒", second];
    }
    return str;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self jhSetLightStatusBarStyle];
    self.jhTitleLabel.text = @"订单详情";
    self.jhTitleLabel.hidden = YES;
    
    [self.view addSubview:self.buttonsView];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tableView];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.view).offset(-UI.bottomSafeAreaHeight - 10);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonsView.mas_top).offset(-10);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.lineView.mas_top);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
    }];
    
    [self.view bringSubviewToFront:self.jhNavView];
    
    [self loadData];
}

/// 获取接口数据
- (void)loadData {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderId;
    [JHMarketOrderViewModel orderDetail:params isBuyer:self.isBuyer Completion:^(NSError * _Nullable error, JHMarketOrderModel * _Nullable orderModel) {
        [self.tableView.mj_header endRefreshing];
        [SVProgressHUD dismiss];
        if (!error) {
            self.orderModel = orderModel;
            [self.tableView reloadData];
            self.buttonsView.orderModel = self.orderModel;
            if (self.orderModel.timeDuring > 0) {
                //开启倒计时
                self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
                //    加入运行循环
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alphaValue = offsetY / kHeaderH;
    if (alphaValue >= 1) {
        alphaValue = 1;
    }
    self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:alphaValue];
    if (alphaValue > 0.5) {
        [self jhSetBlackStatusBarStyle];
        self.jhTitleLabel.hidden = NO;
        self.jhNavBottomLine.hidden = NO;
    } else {
        [self jhSetLightStatusBarStyle];
        self.jhTitleLabel.hidden = YES;
        self.jhNavBottomLine.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *person = NONNULL_STR(self.orderModel.shippingPerson);
    if (indexPath.row == 1 && person.length == 0) {
        return 0;
    }
    
    return UITableViewAutomaticDimension;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            JHMarketStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketStatusCell"];
            cell.model = self.orderModel;
            self.statusCell = cell;
            cell.isBuyer = self.isBuyer;
            return cell;
        }
            break;
        case 1:
        {
            JHMarketAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketAddressCell"];
            cell.model = self.orderModel;
            return cell;
        }
            break;
        case 2:
        {
            JHMarketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketDetailCell"];
            cell.model = self.orderModel;
            cell.isBuyer = self.isBuyer;
            return cell;
        }
            break;
        case 3:
        {
            JHMarketPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketPriceCell"];
            cell.model = self.orderModel;
            return cell;
        }
            break;
        case 4:
        {
            JHMarketInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketInfoCell"];
            cell.model = self.orderModel;
            return cell;
        }
            break;
        case 5:
        {
            JHMarketContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHMarketContactCell"];
            cell.model = self.orderModel;
            cell.isBuyer = self.isBuyer;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {  //订单详情页
        JHC2CProductDetailController *productVc = [[JHC2CProductDetailController alloc] init];
        productVc.productId = self.orderModel.goodsId;
        [self.navigationController pushViewController:productVc animated:YES];
    }
}

- (JHMarketOrderButtonsView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHMarketOrderButtonsView alloc] init];
        _buttonsView.isBuyer = self.isBuyer;
        @weakify(self);
        _buttonsView.reloadDataBlock = ^(BOOL iSdelete) {
            @strongify(self);
            if (iSdelete) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self loadData];
            }
            if (self.completeRefreshBlock) {
                self.completeRefreshBlock(iSdelete);
            }
        };
    }
    return _buttonsView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _lineView;
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
        [_tableView registerClass:[JHMarketStatusCell class] forCellReuseIdentifier:@"JHMarketStatusCell"];
        [_tableView registerClass:[JHMarketAddressCell class] forCellReuseIdentifier:@"JHMarketAddressCell"];
        [_tableView registerClass:[JHMarketDetailCell class] forCellReuseIdentifier:@"JHMarketDetailCell"];
        [_tableView registerClass:[JHMarketPriceCell class] forCellReuseIdentifier:@"JHMarketPriceCell"];
        [_tableView registerClass:[JHMarketInfoCell class] forCellReuseIdentifier:@"JHMarketInfoCell"];
        [_tableView registerClass:[JHMarketContactCell class] forCellReuseIdentifier:@"JHMarketContactCell"];
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
    }
    return _tableView;
}

@end

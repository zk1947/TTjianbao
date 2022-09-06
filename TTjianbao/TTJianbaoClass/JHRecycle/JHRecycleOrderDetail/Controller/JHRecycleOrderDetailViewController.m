//
//  JHRecycleOrderDetailViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailViewController.h"
#import "JHRecycleOrderDetailView.h"
#import "JHRecycleOrderBusinessViewController.h"
#import "JHRecycleOrderCancelViewController.h"
#import "JHQYChatManage.h"
#import "JHRecycleUploadArbitrationViewController.h"
#import "JHRecycleOrderPursueViewController.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHRecyclePickupViewController.h"
#import "JHWebViewController.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHC2CPickupViewController.h"

@interface JHRecycleOrderDetailViewController ()
@property (nonatomic, strong) JHRecycleOrderDetailView *homeView;
@end

@implementation JHRecycleOrderDetailViewController


#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self bindData];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.jhNavView];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情ViewController-%@ 释放", [self class]);
}

#pragma mark - PUSH - 商家验收说明
- (void)pushBusinessExplainWithPar : (NSDictionary *)par {
    JHRecycleOrderBusinessViewController *vc = [[JHRecycleOrderBusinessViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.orderId = par[@"orderId"];
    [self presentViewController:vc animated:true completion:nil];
}

#pragma mark - PUSH - 取消理由列表
- (void)pushCancelListWithPar : (NSDictionary *)par {
    JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.orderId = par[@"orderId"];
    [self presentViewController:vc animated:true completion:nil];
    
    RAC(self.homeView.viewModel,selectedCancelMsg) = RACObserve(vc, selectedMsg);
}

#pragma mark - PUSH - 预约上门取件
- (void)pushAppointmentWithPar : (NSDictionary *)par {
    JHC2CPickupViewController *vc = [[JHC2CPickupViewController alloc] init];
    vc.orderId = par[@"orderId"];
    vc.orderCode = par[@"orderCode"];
    vc.productId = par[@"productId"];
    vc.productName = par[@"productName"];
    vc.fromStatus = 1;

    [self.navigationController pushViewController:vc animated:true];
    
    @weakify(self)
    [vc.appointmentSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.homeView.viewModel getOrderDetailInfo];
        if (self.reloadData) {
            self.reloadData(true);
        }
    }];
}
#pragma mark - PUSH - 查看预约、填写订单号
- (void)pushCheckAppointmentWithPar : (NSDictionary *)par {
    JHC2CWriteOrderNumViewController *vc = [[JHC2CWriteOrderNumViewController alloc] init];
    vc.orderId = par[@"orderId"];
    vc.orderCode = par[@"orderCode"];
    vc.productId = par[@"productId"];
    [self.navigationController pushViewController:vc animated:true];
    
    @weakify(self)
    [vc.writeSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.homeView.viewModel getOrderDetailInfo];
        if (self.reloadData) {
            self.reloadData(true);
        }
    }];
}
#pragma mark - PUSH - 查看物流
- (void)pushCheckLogisticsWithPar : (NSDictionary *)par {
    JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
    vc.orderId = par[@"orderId"];
    NSNumber *status = par[@"recycleOrderStatus"];
    NSInteger recycleOrderStatus = [status integerValue];
    vc.type = (recycleOrderStatus == 9 || recycleOrderStatus == 10) ? 7 : 6;
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 订单追踪
- (void)pushOrderPursueWithPar : (NSDictionary *)par {
    JHRecycleOrderPursueViewController *vc = [[JHRecycleOrderPursueViewController alloc] init];
    vc.orderId = par[@"orderId"];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 申请仲裁
- (void)pushArbitrationWithPar : (NSDictionary *)par {
    JHRecycleUploadArbitrationViewController *vc = [[JHRecycleUploadArbitrationViewController alloc]init];
    vc.orderId = [par[@"orderId"] integerValue];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 查看仲裁
- (void)pushCheckArbitrationWithPar : (NSDictionary *)par {
    JHRecycleUploadArbitrationViewController *vc = [[JHRecycleUploadArbitrationViewController alloc]init];
    vc.orderId = [par[@"orderId"] integerValue];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 填写物流单号
- (void)pushFillLogistics {
    
}
#pragma mark - PUSH - 客服
- (void)pushService {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:self];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"电话客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - PUSH - WEB
- (void)pushWebViewWithPar : (NSDictionary *)par {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = par[@"url"];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 返回上层页面
- (void)pushBack {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    }else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}
#pragma mark - PUSH - 删除订单
- (void)pushDelete {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    }else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
    self.isDeleted = true;
    if (self.reloadData) {
        self.reloadData(true);
    }
}

#pragma mark - Private Functions
- (void)pushWithDic : (NSDictionary *)dic {
    NSString *type = dic[@"type"];
    NSDictionary *par = dic[@"parameter"];
    // 商家验收说明
    if ([type isEqualToString:@"BusinessExplain"]) { // 商家验收说明
        [self pushBusinessExplainWithPar:par];
    }else if ([type isEqualToString:@"CancelList"]) { // 取消理由列表
        [self pushCancelListWithPar:par];
    }else if ([type isEqualToString:@"Appointment"]) { // 预约上门取件
        [self pushAppointmentWithPar:par];
    }else if ([type isEqualToString:@"CheckAppointment"]) { // 查看取件预约
        [self pushCheckAppointmentWithPar:par];
    }else if ([type isEqualToString:@"CheckLogistics"]) { // 查看物流
        [self pushCheckLogisticsWithPar:par];
    }else if ([type isEqualToString:@"OrderPursue"]) { // 查看订单追踪
        [self pushOrderPursueWithPar:par];
    }else if ([type isEqualToString:@"Service"]) { // 客服
        [self pushService];
    }else if ([type isEqualToString:@"Arbitration"]) { // 申请仲裁
        [self pushArbitrationWithPar:par];
    }else if ([type isEqualToString:@"CheckArbitration"]) { // 查看仲裁
        [self pushCheckArbitrationWithPar:par];
    }else if ([type isEqualToString:@"WebView"]) { // Web
        [self pushWebViewWithPar:par];
    }else if ([type isEqualToString:@"Back"]) { // back
        [self pushBack];
    }else if ([type isEqualToString:@"Delete"]) { // 删除订单
        [self pushDelete];
    }else if ([type isEqualToString:@"FillLogistics"]) { // 填写物流单号
        [self pushFillLogistics];
    }
}

#pragma mark - Bind
- (void)bindData {
    // 跳转
    @weakify(self)
    [self.homeView.viewModel.pushvc subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        NSDictionary *dic = (NSDictionary *)x;
        [self pushWithDic:dic];
    }];
    [RACObserve(self.homeView.viewModel, toastMsg) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self.view makeToast:x duration:1.0 position:CSToastPositionCenter];
    }];
    [self.homeView.viewModel.reloadUPData subscribeNext:^(id  _Nullable x) {
        if (self.reloadData) {
            self.reloadData(false);
        }
    }];
}
#pragma mark - setupUI
- (void)setupUI {
    [self.view addSubview:self.homeView];
    self.jhTitleLabel.text = @"回收订单详情";
}
- (void)layoutViews {
    [self.homeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jhNavView.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}
#pragma mark - Lazy
- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
    self.homeView.orderId = orderId;
}
- (JHRecycleOrderDetailView *)homeView {
    if (!_homeView) {
        _homeView = [[JHRecycleOrderDetailView alloc] initWithFrame:CGRectZero];
    }
    return _homeView;
}
@end

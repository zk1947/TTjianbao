//
//  JHRefundDetailViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRefundDetailViewController.h"
#import "JHRefundDetailViewModel.h"
#import "JHRefundDetailItemViewModel.h"
#import "JHRefundBaseTableCell.h"
#import "UIButton+ImageTitleSpacing.h"
#import "YDCountDown.h"
#import "JHRefundRemindCell.h"
#import "JHRefundBuyerReturnedCell.h"
#import "JHRefundSellerProcessingCell.h"
#import "JHRefundSellerAgreesCell.h"
#import "JHRefundSellerRefuseCell.h"
#import "JHRefundBuyerApplyCell.h"
#import "CommAlertView.h"

#import "JHRefundDetailBottomBtnView.h"
#import "JHSessionViewController.h"
#import "JHRefundDetailBusiness.h"

#import "JHMarketOrderRefusedRefundViewController.h"
#import "JHPlatformResultsViewController.h"
#import "JHC2CSendServiceViewController.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHReportAddressManagerViewController.h"
#import "JHC2CSubmitVoucherController.h"
#import "JHC2CSelfMailingViewController.h"
#import "JHMarketOrderRefundViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHIMEntranceManager.h"


@interface JHRefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHRefundDetailViewModel *refundViewModel;
@property (nonatomic, strong) UIButton *refundNodeTitleBtn;//节点标题
@property (nonatomic, strong) YDCountDown *countDown;//倒计时
@property (nonatomic, strong) UILabel *timeLeftLabel;//剩余时间
@property (nonatomic, strong) UIButton *contactSellerBtn;//联系卖家
@property (nonatomic, assign) NSInteger countdownTime;// 倒计时时间
@property (nonatomic, strong) JHRefundDetailBottomBtnView *bottomBtnView;

@end

@implementation JHRefundDetailViewController

- (void)dealloc{
    [_countDown destoryTimer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    NSString *page_name = @"集市查看退款信息买家页";
    if (self.customerFlag == 2) {//卖家
        page_name = @"集市查看退款信息卖家页";
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":page_name,
        @"order_id":self.orderId
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看退款信息";
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = HEXCOLOR(0xFFFAF2);
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(46.f);
    }];

    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"温馨提示：请及时填写正确的物流单号，长期不更新视为放弃退货退款，款项将直接打至卖家账户";
    noticeLabel.font = [UIFont fontWithName:kFontNormal size:12];
    noticeLabel.textColor = HEXCOLOR(0xFF6A00);
    noticeLabel.numberOfLines = 0;
    [backView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(backView);
        make.left.equalTo(backView).offset(18.f);
        make.right.equalTo(backView).offset(-18.f);
    }];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44-UI.bottomSafeAreaHeight);
    }];
    
    [self loadData];
    
    [self configData];
    
    [self setupNavUI];
    
    [self setupHeaderUI];
    
    [self setupFooterUI];
    
    [self setupBottomButtonView];
}

#pragma mark - UI
- (void)setupNavUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [rightBtn setTitleColor:HEXCOLOR(0x007AFF) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
    [rightBtn addTarget:self action:@selector(clickServiceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.jhNavView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView);
        make.right.equalTo(self.jhNavView).mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(53, UI.navBarHeight));
    }];
}
///头部退款状态和时间
- (void)setupHeaderUI{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    self.tableView.tableHeaderView = headerView;
    UIImageView *headerBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, headerView.height)];
    headerBgImgView.image = JHImageNamed(@"c2c_header_bg");
    [headerView addSubview:headerBgImgView];
    
    [headerView addSubview:self.refundNodeTitleBtn];
    [self.refundNodeTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(40);
        make.centerX.equalTo(headerView);
    }];
    self.timeLeftLabel.hidden = YES;
    [headerView addSubview:self.timeLeftLabel];
    [self.timeLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.refundNodeTitleBtn.mas_bottom).offset(8);
        make.centerX.equalTo(self.refundNodeTitleBtn);
    }];
    
    
}
//倒计时
- (void)countDownInfo:(long)start end:(long)end {
    @weakify(self);
    [self.countDown startWithbeginTimeStamp:start
                            finishTimeStamp:end
                              completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @strongify(self);
        self.timeLeftLabel.text = [NSString stringWithFormat:@"剩余时间：%ld天%ld时%ld分%ld秒",(long)day, (long)hour, (long)minute, (long)second];
        //倒计时结束后操作
        if (day == 0 && hour==0 && minute == 0 && second == 0) {
            ///停止定时器
            [self.countDown destoryTimer];
            //刷新页面
            self.timeLeftLabel.text = @"";
            [self loadData];
        }
        
    }];
}

///底部联系卖家
- (void)setupFooterUI{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 43)];
    self.tableView.tableFooterView = footerView;
    UIView *contactSellerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 43)];
    contactSellerView.backgroundColor = UIColor.whiteColor;
    [contactSellerView jh_cornerRadius:8];
    [footerView addSubview:contactSellerView];
    
    [contactSellerView addSubview:self.contactSellerBtn];
    [self.contactSellerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contactSellerView);
    }];
}
///底部按钮
- (void)setupBottomButtonView{
    [self.view addSubview:self.bottomBtnView];
    [self.bottomBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom).offset(7);
        make.right.mas_equalTo(self.view).offset(-10);
        make.left.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"orderId"] = self.orderId;
    dicData[@"customerFlag"] = [NSString stringWithFormat:@"%ld",(long)self.customerFlag];
    [self.refundViewModel.refundCommand execute:dicData];
    
}
- (void)configData{
    @weakify(self)
    //数据请求
    [[RACObserve(self.refundViewModel, dataSourceArray) skip:1] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        //底部按钮显示
        self.bottomBtnView.refundButtonShowModel = self.refundViewModel.refundDetailModel.button;
        //IM
        if (self.customerFlag == 1) {
            [self.contactSellerBtn setTitle:@"联系卖家" forState:UIControlStateNormal];
        }else{
            [self.contactSellerBtn setTitle:@"联系买家" forState:UIControlStateNormal];
        }
        
        //头部信息
        [self.refundNodeTitleBtn setTitle:self.refundViewModel.refundDetailModel.workOrderStatusDesc forState:UIControlStateNormal];
        if (self.refundViewModel.refundDetailModel.workOrderTimeOut.length > 0 && [self.refundViewModel.refundDetailModel.workOrderTimeOut floatValue] > 0) {
            self.timeLeftLabel.hidden = NO;
            //倒计时
            self.countdownTime = [self.refundViewModel.refundDetailModel.workOrderTimeOut integerValue]/1000;
            [self countDownInfo:0 end:self.countdownTime];
            
        }else{
            self.timeLeftLabel.hidden = YES;
        }
        
        [self.tableView reloadData];
    }];
    
    //请求出错
    [self.refundViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - Action
///联系客服
- (void)clickServiceButtonAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"电话客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
///联系买/卖家--IM
- (void)clickContactSellerBtnAction{
    [JHIMEntranceManager pushSessionWithUserId:self.userId orderInfo:self.orderInfo];
}


#pragma mark - Delegate
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.refundViewModel.dataSourceArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHRefundDetailItemViewModel *itemViewModel = self.refundViewModel.dataSourceArray[indexPath.section][indexPath.row];
    JHRefundBaseTableCell *cell = [tableView dequeueReusableCellWithIdentifier:itemViewModel.cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderId = self.orderId;
    cell.orderStatusCode = self.orderStatusCode;
    cell.userIdentity = self.customerFlag;
    cell.userId = self.userId;
    cell.orderInfo = self.orderInfo;
    cell.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
    cell.workOrderStatus = self.refundViewModel.refundDetailModel.workOrderStatus;
    [cell bindViewModel:itemViewModel.dataModel];
    @weakify(self)
    cell.reloadDataBlock = ^{
        @strongify(self);
        //成功刷新页面
        [self loadData];
    };
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = UIColor.clearColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return 10;
    return CGFLOAT_MIN;
}

#pragma mark - Lazy
- (JHRefundDetailViewModel *)refundViewModel{
    if (!_refundViewModel) {
        _refundViewModel = [[JHRefundDetailViewModel alloc] init];
    }
    return _refundViewModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =  HEXCOLOR(0xF5F5F8);
        [self registerCell:_tableView];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,20,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }
        
    }
    return  _tableView;
}

- (void)registerCell:(UITableView *)tableView{
    [tableView registerClass:[JHRefundBaseTableCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundBaseTableCell class])];
    [tableView registerClass:[JHRefundRemindCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundRemindCell class])];
    [tableView registerClass:[JHRefundBuyerReturnedCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundBuyerReturnedCell class])];
    [tableView registerClass:[JHRefundSellerAgreesCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundSellerAgreesCell class])];
    [tableView registerClass:[JHRefundBuyerApplyCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundBuyerApplyCell class])];
    [tableView registerClass:[JHRefundSellerRefuseCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundSellerRefuseCell class])];
    [tableView registerClass:[JHRefundSellerProcessingCell class] forCellReuseIdentifier:NSStringFromClass([JHRefundSellerProcessingCell class])];
}

- (UIButton *)refundNodeTitleBtn{
    if (!_refundNodeTitleBtn) {
        _refundNodeTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refundNodeTitleBtn setTitle:@"" forState:UIControlStateNormal];
        [_refundNodeTitleBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        _refundNodeTitleBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:20];
        [_refundNodeTitleBtn setImage:[UIImage imageNamed:@"c2c_refund_money_icon"] forState:UIControlStateNormal];
        [_refundNodeTitleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    return _refundNodeTitleBtn;
}
- (YDCountDown *)countDown{
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    return _countDown;
}
- (UILabel *)timeLeftLabel{
    if (!_timeLeftLabel) {
        _timeLeftLabel = [[UILabel alloc] init];
        _timeLeftLabel.textColor = HEXCOLOR(0xFFFFFF);
        _timeLeftLabel.font = [UIFont fontWithName:kFontMedium size:13];
    }
    return _timeLeftLabel;
}
- (UIButton *)contactSellerBtn{
    if (!_contactSellerBtn) {
        _contactSellerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactSellerBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        _contactSellerBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_contactSellerBtn setImage:[UIImage imageNamed:@"c2c_contactSeller_icon"] forState:UIControlStateNormal];
        [_contactSellerBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [_contactSellerBtn addTarget:self action:@selector(clickContactSellerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactSellerBtn;
}
- (JHRefundDetailBottomBtnView *)bottomBtnView{
    if (!_bottomBtnView) {
        _bottomBtnView = [[JHRefundDetailBottomBtnView alloc] init];
        @weakify(self)
        _bottomBtnView.clickActionBlock = ^(RefundDetailBottomBtnTag btnTag) {
            @strongify(self);
            
            switch (btnTag) {
                case RefundDetailBottomBtnTagDelete://删除
                {
                    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您确定删除？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    @weakify(self);
                    alert.handle = ^{
                        @strongify(self);
                        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                        dicData[@"orderId"] = self.orderId;
                        dicData[@"flag"] = [NSString stringWithFormat:@"%ld",(long)self.customerFlag];
                        [JHRefundDetailBusiness requestRefundDeleteWorkOrderWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                            if (!error) {
                                JHTOAST(@"删除成功");
                                //删除成功监听
                                [self.needRefreshSubject sendNext:@{@"isDelete":@"YES"}];
                                //返回订单列表
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                JHTOAST(@"删除失败");
                            }
                        }];
                    };
                }
                    break;
                case RefundDetailBottomBtnTagApplyIntervention://仲裁申请介入
                {
                    JHC2CSubmitVoucherController *coucherVC = [[JHC2CSubmitVoucherController alloc] init];
                    coucherVC.orderId = self.orderId;
                    coucherVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                    [self.navigationController pushViewController:coucherVC animated:YES];
                    @weakify(self)
                    coucherVC.successBlock = ^{
                        @strongify(self)
                        [self loadData];
                    };
                    
                }
                    break;
                case RefundDetailBottomBtnTagInterventionResult://查看介入结果
                {
                    JHPlatformResultsViewController *resultsVC = [[JHPlatformResultsViewController alloc] init];
                    resultsVC.orderId = self.orderId;
                    [self.navigationController pushViewController:resultsVC animated:YES];
                    
                }
                    break;
                case RefundDetailBottomBtnTagModifyApply://修改申请 退款
                {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    params[@"orderId"] = self.orderId;
                    [JHMarketOrderViewModel orderDetail:params isBuyer:self.customerFlag==1 ? YES : NO Completion:^(NSError * _Nullable error, JHMarketOrderModel * _Nullable orderModel) {
                         [self.tableView.mj_header endRefreshing];
                         [SVProgressHUD dismiss];
                         if (!error) {
                             JHMarketOrderRefundViewController *refundVc = [[JHMarketOrderRefundViewController alloc] init];
                             refundVc.orderModel = orderModel;
                             refundVc.orderId = self.orderId;
                             refundVc.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                             refundVc.operationListModel  = self.refundViewModel.refundDetailModel.operationList.lastObject;
                             @weakify(self);
                             refundVc.completeBlock = ^{
                                 @strongify(self);
                                 //成功刷新页面
                                 [self loadData];
                             };
                             [self.navigationController pushViewController:refundVc animated:YES];
                         } else {
                             JHTOAST(error.localizedDescription);
                         }
                     }];
                }
                    break;
                case RefundDetailBottomBtnTagRevokApply://撤销申请 退款
                {
                    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:@"您确认撤销退款申请，交易将正常进行" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    @weakify(self);
                    alert.handle = ^{
                        @strongify(self);
                        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                        dicData[@"orderId"] = self.orderId;
                        dicData[@"flag"] = [NSString stringWithFormat:@"%ld",(long)self.customerFlag];
                        dicData[@"workOrderId"] = self.refundViewModel.refundDetailModel.workOrderId;
                        [JHRefundDetailBusiness requestRefundCancelWorkOrderWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                            if (!error) {
                                JHTOAST(@"撤销成功");
                                //撤销成功监听
                                [self.needRefreshSubject sendNext:@{@"isDelete":@"NO"}];
                                //返回订单列表
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                JHTOAST(@"撤销失败");
                            }
                        }];
                        
                    };
                }
                    break;
                case RefundDetailBottomBtnTagReturn://去退货
                {
                    JHC2CSendServiceViewController *sendVC = [[JHC2CSendServiceViewController alloc] init];
                    sendVC.orderId = self.orderId;
                    sendVC.orderCode = self.orderCode;
                    sendVC.productId = self.productId;
                    sendVC.productName = self.productName;
                    sendVC.appointmentSource = 2;//预约来源 0正向 2逆向
                    sendVC.customerFlag = self.customerFlag;
                    [self.navigationController pushViewController:sendVC animated:YES];
                    @weakify(self)
                    [sendVC.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
                        @strongify(self)
                        //成功刷新页面
                        [self loadData];
                    }];
                }
                    break;
                case RefundDetailBottomBtnTagAddOrderNum://填写物流单号
                {
                    JHC2CWriteOrderNumViewController *writeVC = [[JHC2CWriteOrderNumViewController alloc] init];
                    writeVC.orderId = self.orderId;
                    writeVC.orderCode = self.orderCode;
                    writeVC.productId = self.productId;
                    writeVC.appointmentSource = 2;//预约来源 0正向 2逆向
                    [self.navigationController pushViewController:writeVC animated:YES];
                    @weakify(self);
                    [writeVC.writeSuccessSubject subscribeNext:^(id  _Nullable x) {
                        @strongify(self);
                        //成功刷新页面
                        [self loadData];
                    }];
                    
                }
                    break;
                case RefundDetailBottomBtnTagRemindSeller://提醒卖家收货
                {
                    //当日内只能催货一次
                    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                    dicData[@"orderId"] = self.orderId;
                    dicData[@"workOrderId"] = self.refundViewModel.refundDetailModel.workOrderId;
                    [JHRefundDetailBusiness requestRefundWarnReceiveWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                        if (!error) {
                            JHTOAST(@"已为您催促卖家收货");
                        }else{
                            JHTOAST(error.localizedDescription);
                        }
                    }];
                    
                }
                    break;
                case RefundDetailBottomBtnTagAgreeRefund://同意退款
                {
                    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您同意退款？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    @weakify(self);
                    alert.handle = ^{
                        @strongify(self);
                        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                        dicData[@"orderId"] = self.orderId;
                        dicData[@"workOrderId"] = self.refundViewModel.refundDetailModel.workOrderId;
                        [JHRefundDetailBusiness requestAgreeRefundWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                            if (!error) {
                                JHTOAST(@"已同意");
                            }else{
                                JHTOAST(@"同意失败");
                            }
                            //刷新页面
                            [self loadData];
                        }];
                        
                    };
                    
                }
                    break;
                case RefundDetailBottomBtnTagRefuseRefund://拒绝退款
                {
                    JHMarketOrderRefusedRefundViewController *applyVC = [[JHMarketOrderRefusedRefundViewController alloc] init];
                    applyVC.orderId = self.orderId;
                    applyVC.workOrderStatus = self.refundViewModel.refundDetailModel.workOrderStatus;
                    applyVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                    [self.navigationController pushViewController:applyVC animated:YES];
                    @weakify(self);
                    [applyVC.reloadUPData subscribeNext:^(id  _Nullable x) {
                        @strongify(self);
                        //成功刷新页面
                        [self loadData];
                    }];
                    
                }
                    break;
                case RefundDetailBottomBtnTagShippedRefuseRefund://已发货拒绝退款
                {
                    //已发货拒绝退款：跳发货页，发货后，关闭工单，订单回滚到待买家收货
                    //已经预约跳填写物流单号页
                    if ([self.refundViewModel.refundDetailModel.pickupStatus integerValue] == 1) {
                        JHC2CWriteOrderNumViewController *writeVC = [[JHC2CWriteOrderNumViewController alloc] init];
                        writeVC.orderId = self.orderId;
                        writeVC.orderCode = self.orderCode;
                        writeVC.productId = self.productId;
                        writeVC.appointmentSource = 0;//预约来源 0正向 2逆向
                        writeVC.writeSuccessSubject = self.needRefreshSubject;
                        writeVC.cancelWorkOrder = 1;
                        writeVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                        writeVC.customerFlag = self.customerFlag;
                        [self.navigationController pushViewController:writeVC animated:YES];
                        @weakify(self);
                        [writeVC.writeSuccessSubject subscribeNext:^(id  _Nullable x) {
                            @strongify(self);
                            //成功刷新页面
                            [self loadData];
                        }];
                    }else{
                        JHC2CSelfMailingViewController *selfMailingVC = [[JHC2CSelfMailingViewController alloc] init];
                        selfMailingVC.orderId = self.orderId;
                        selfMailingVC.orderCode = self.orderCode;
                        selfMailingVC.productId = self.productId;
                        selfMailingVC.productName = self.productName;
                        selfMailingVC.appointmentSource = 0;//预约来源 0正向 2逆向
                        selfMailingVC.orderStatus = 1;//退款未预约，隐藏上门取件
                        selfMailingVC.selfMailingSuccessSubject = self.needRefreshSubject;
                        selfMailingVC.cancelWorkOrder = 1;
                        selfMailingVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                        selfMailingVC.customerFlag = self.customerFlag;
                        [self.navigationController pushViewController:selfMailingVC animated:YES];
                        @weakify(self);
                        [selfMailingVC.selfMailingSuccessSubject subscribeNext:^(id  _Nullable x) {
                            @strongify(self);
                            //成功刷新页面
                            [self loadData];
                        }];
                    }
                    
                }
                    break;
                case RefundDetailBottomBtnTagAgreeReturn://同意退货
                {
                    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您同意退货？" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    @weakify(self);
                    alert.handle = ^{
                        JHTOAST(@"已同意");
                        @strongify(self);
                        //跳填写退货地址页
                        JHReportAddressManagerViewController *addressVC = [[JHReportAddressManagerViewController alloc] init];
                        addressVC.orderId = self.orderId;
                        addressVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                        addressVC.workOrderStatus = self.refundViewModel.refundDetailModel.workOrderStatus;
                        [self.navigationController pushViewController:addressVC animated:YES];
                        @weakify(self);
                        [addressVC.reloadUPData subscribeNext:^(id  _Nullable x) {
                            @strongify(self);
                            //成功刷新页面
                            [self loadData];
                        }];
                        
                    };
                    alert.cancleHandle = ^{
                        JHTOAST(@"同意失败");
                    };
                    
                }
                    break;
                case RefundDetailBottomBtnTagRefuseReturn://拒绝退货
                {
                    JHMarketOrderRefusedRefundViewController *applyVC = [[JHMarketOrderRefusedRefundViewController alloc] init];
                    applyVC.orderId = self.orderId;
                    applyVC.workOrderStatus = self.refundViewModel.refundDetailModel.workOrderStatus;
                    applyVC.workOrderId = self.refundViewModel.refundDetailModel.workOrderId;
                    [self.navigationController pushViewController:applyVC animated:YES];
                    @weakify(self);
                    [applyVC.reloadUPData subscribeNext:^(id  _Nullable x) {
                        @strongify(self);
                        //成功刷新页面
                        [self loadData];
                    }];
                }
                    break;
                case RefundDetailBottomBtnTagRemindBuyer://提醒买家发货
                {
                    //当日内只能催货一次
                    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                    dicData[@"orderId"] = self.orderId;
                    dicData[@"workOrderId"] = self.refundViewModel.refundDetailModel.workOrderId;
                    [JHRefundDetailBusiness requestRefundRemindShipWorkerWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                        if (!error) {
                            JHTOAST(@"已为您催促买家发货");
                        }else{
                            JHTOAST(error.localizedDescription);
                        }
                    }];
                }
                    break;
                case RefundDetailBottomBtnTagReceiveAgreeRefund://收到货同意退款
                {
                    NSString *titleStr = [NSString stringWithFormat:@"请确保您已收到买家退回的商品，且已核对退款金额￥%@，同意退款后，钱款将直接退回给买家账号",self.refundViewModel.refundDetailModel.refundAmt];
                    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:titleStr cancleBtnTitle:@"取消" sureBtnTitle:@"同意退款"];
                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                    @weakify(self);
                    alert.handle = ^{
                        @strongify(self)
                        NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
                        dicData[@"orderId"] = self.orderId;
                        dicData[@"workOrderId"] = self.refundViewModel.refundDetailModel.workOrderId;
                        [JHRefundDetailBusiness requestAgreeRefundWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                            if (!error) {
                                JHTOAST(@"已同意");
                                //同意退款成功监听
                                [self.needRefreshSubject sendNext:@{@"isDelete":@"NO"}];
                                //返回订单列表
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                JHTOAST(@"同意失败");
                            }
                            
                        }];
                        
                    };
                }
                    break;
                    
                default:
                    break;
            }
            
        };
    }
    return _bottomBtnView;
}

- (RACSubject *)needRefreshSubject{
    if (!_needRefreshSubject) {
        _needRefreshSubject = [[RACSubject alloc] init];
    }
    return _needRefreshSubject;
}
@end

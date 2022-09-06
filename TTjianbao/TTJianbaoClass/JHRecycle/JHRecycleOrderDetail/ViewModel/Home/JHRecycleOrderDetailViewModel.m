//
//  JHRecycleOrderDetailViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailViewModel.h"
#import "JHRecycleOrderDetailServiceViewModel.h"
#import "JHRecycleOrderDetailStatusDescribeViewModel.h"
#import "JHRecycleOrderDetailCheckViewModel.h"
#import "JHRecycleOrderDetailArbitrationViewModel.h"
#import "JHRecycleOrderDetailAddressViewModel.h"
#import "JHRecycleOrderDetailProductViewModel.h"
#import "JHRecycleOrderDetailInfoViewModel.h"
#import "JHRecycleOrderDetailStatusTitleViewModel.h"
#import "JHRecycleOrderDetailModel.h"
#import "JHRecycleOrderDetailAlert.h"
#import "NSString+AttributedString.h"

@interface JHRecycleOrderDetailViewModel()
@property (nonatomic, strong) JHRecycleOrderDetailModel *model;
@end
@implementation JHRecycleOrderDetailViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - push - 上一页
- (void)pushBack {
    NSDictionary *dic = @{@"type" : @"Back"};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 删除
- (void)pushDelete {
    NSDictionary *dic = @{@"type" : @"Delete"};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - H5页面
- (void)pushWebWithUrl : (NSString *)url {
    if (url == nil) return;
    NSDictionary *par = @{@"url" : url};
    NSDictionary *dic = @{@"type" : @"WebView",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 商家说明
- (void)pushBusinessExplain {
    NSDictionary *par = @{@"orderId" : self.orderId};
    NSDictionary *dic = @{@"type" : @"BusinessExplain",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 取消列表
- (void)pushCancelList {
    NSDictionary *par = @{@"orderId" : self.orderId};
    NSDictionary *dic = @{@"type" : @"CancelList",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 预约上门取件
- (void)pushAppointment {
    [self reportAppointment];
    NSDictionary *par = @{
        @"orderId" : self.orderId,
        @"orderCode" : self.model.order.orderCode,
        @"productId" : self.model.order.onlyGoodsId,
        @"productName" : self.model.order.goodsTitle,
    };
    NSDictionary *dic = @{@"type" : @"Appointment",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 查看取件预约/填写订单号
- (void)pushCheckAppointment {
    NSDictionary *par = @{
        @"orderId" : self.orderId,
        @"orderCode" : self.model.order.orderCode,
        @"productId" : self.model.order.onlyGoodsId,
    };
    NSDictionary *dic = @{@"type" : @"CheckAppointment",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 查看物流
- (void)pushCheckLogistics {
    NSDictionary *par = @{@"orderId" : self.orderId,
                          @"recycleOrderStatus" : @(self.model.order.recycleOrderStatus)};
    NSDictionary *dic = @{@"type" : @"CheckLogistics",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 查看订单追踪
- (void)pushOrderPursue {
    [self reportOrderTracking];
    NSDictionary *par = @{@"orderId" : self.orderId};
    NSDictionary *dic = @{@"type" : @"OrderPursue",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 客服
- (void)pushService {
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Service",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 申请仲裁
- (void)pushArbitration {
    NSDictionary *par = @{@"orderId" : self.orderId};
    NSDictionary *dic = @{@"type" : @"Arbitration",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - push - 查看仲裁
- (void)pushCheckArbitration {
    NSString *url = [NSString stringWithFormat:@"%@?orderId=%@",H5_BASE_STRING(@"/jianhuo/app/recycle/order/arbitrationDteail.html"), self.orderId]; ;
    [self pushWebWithUrl:url];
}
//#pragma mark - push - 填写物流单号
//- (void)pushFillLogistics {
//    NSDictionary *par = @{@"orderId" : self.orderId};
//    NSDictionary *dic = @{@"type" : @"FillLogistics",
//                          @"parameter" : par};
//    [self.pushvc sendNext:dic];
//}
#pragma mark - 确认交易事件
- (void)orderConfirmEvent {
    @weakify(self)
    [self showAlertWithDesc:@"您确认交易后，平台将回收款发放至您的零钱" sureTitle:@"确认" handle:^{
        @strongify(self)
        [self orderAcceptRequest];
    } cancelHandle:^{
        
    }];
}
#pragma mark - 确认收货事件
- (void)orderReceivedEvent {
    @weakify(self)
    [self showAlertWithDesc:@"您确认收货后，平台将退款给商家" sureTitle:@"确认" handle:^{
        @strongify(self)
        [self orderReceivedRequest];
    } cancelHandle:^{
        
    }];
}
#pragma mark - 删除事件
- (void)orderDeleteEvent {
    @weakify(self)
    [self showAlertWithDesc:@"您确认要删除该订单?" sureTitle:@"确认" handle:^{
        @strongify(self)
        [self orderDeleteRequest];
    } cancelHandle:^{
        
    }];
}
#pragma mark - 关闭事件
- (void)orderCloseEvent {
    @weakify(self)
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":@"关闭交易后，平台将钱款打回买家账户，", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
    itemsArray[1] = @{@"string":@"如果实际发货后，请谨慎点击关闭交易！否则由您承当相关后果;", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontBoldDIN size:12]};
    NSMutableAttributedString *string = [NSString mergeStrings:itemsArray];
    
    [self showAlertWithTitle:@"未发货且确认关闭交易" attDesc:string sureTitle:@"确认" handle:^{
        @strongify(self)
        [self orderCloseRequest];
    } cancelHandle:^{
        
    }];
    
}
#pragma mark - 申请退回事件
- (void)orderReturnEvent {
    @weakify(self)
    [self showAlertWithDesc:@"您确定要将宝贝寄回\n并关闭回收订单?" sureTitle:@"确认" handle:^{
        @strongify(self)
        [self orderReturnRequest];
    } cancelHandle:^{
        
    }];
}
#pragma mark - 申请销毁事件
- (void)orderDestructionEvent {
    [self showAgreementAlert];
}
#pragma mark - 拷贝事件
- (void)orderCopyEventWithId : (NSString *)orderId {
    if (orderId == nil) return;
    [[UIPasteboard generalPasteboard] setString:orderId];
    self.toastMsg = @"复制成功";
}

#pragma mark - Action functions
- (void)toolbarEventWithType : (RecycleOrderButtonType)type {
    switch (type) {
        case RecycleOrderButtonTypeCancel: // 取消订单
            [self pushCancelList];
            break;
        case RecycleOrderButtonTypeDelete: // 删除订单
            [self orderDeleteEvent];
            break;
        case RecycleOrderButtonTypeArbitration: // 申请仲裁
            [self pushArbitration];
            break;
        case RecycleOrderButtonTypeCheckArbitration: // 查看仲裁
            [self pushCheckArbitration];
            break;
        case RecycleOrderButtonTypeReturn: // 申请退回
            [self orderReturnEvent];
            break;
        case RecycleOrderButtonTypeDestruction: // 申请销毁
            [self orderDestructionEvent];
            break;
        case RecycleOrderButtonTypeClose: // 关闭交易
            [self orderCloseEvent];
            break;
        case RecycleOrderButtonTypeAppointment: // 预约取件
            [self pushAppointment];
            break;
        case RecycleOrderButtonTypeCheckAppointment: // 查看取件预约
            [self pushCheckAppointment];
            break;
        case RecycleOrderButtonTypeLogistics: // 查看物流
            [self pushCheckLogistics];
            break;
        case RecycleOrderButtonTypePursue: // 订单追踪
            [self pushOrderPursue];
            break;
        case RecycleOrderButtonTypeEnsure: // 确认交易
            [self orderConfirmEvent];
            break;
        case RecycleOrderButtonTypeReceived: // 确认收货
            [self orderReceivedEvent];
            break;
        default:
            break;
    }
}
- (void)showAlertWithDesc : (NSString *)desc
                sureTitle : (NSString *)sureTitle
                   handle : (JHFinishBlock)handle
             cancelHandle : (JHFinishBlock) cancelHandle {
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:sureTitle];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = handle;
    alert.cancleHandle = cancelHandle;
}
- (void)showAlertWithTitle : (NSString *)title
                   attDesc : (NSMutableAttributedString *)desc
                 sureTitle : (NSString *)sureTitle
                    handle : (JHFinishBlock)handle
              cancelHandle : (JHFinishBlock) cancelHandle {
    
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:title andMutableDesc:desc cancleBtnTitle:@"取消" sureBtnTitle:sureTitle andIsLines:true];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = handle;
    alert.cancleHandle = cancelHandle;
}
- (void)showAgreementAlert {
    JHRecycleOrderDetailAlert *alert = [[JHRecycleOrderDetailAlert alloc]initWithFrame:CGRectZero];
    [alert showAlertWithDesc:@"您是否确认将宝贝销毁并关闭交易？确认前请阅读并勾选销毁协议。" in:JHRootController.currentViewController.view];
    @weakify(self)
    alert.handle = ^{
        @strongify(self)
        [self destructionRequest];
    };
    alert.cancelHandle = ^{
        
    };
    alert.agreementHandle = ^{
        @strongify(self)
        NSString *url = H5_BASE_STRING(@"/jianhuo/app/agreement/destructionAgreement.html");
        [self pushWebWithUrl: url];
    };
}
#pragma mark - Private Functions

- (void)setupData {
    if (self.model == nil){
        [self.refreshTableView sendNext:nil];
        return;
    }
    
    [self.cellViewModelList removeAllObjects];
    
    // header
    [self setupOrderHeaderViewModel];
    // toolbar
    [self setupOrderToolbarViewModel];
    
    // 订单状态区
    JHRecycleOrderDetailSectionViewModel *orderStatusSection = [[JHRecycleOrderDetailSectionViewModel alloc] init];
    // 地址区
    JHRecycleOrderDetailSectionViewModel *addressSection = [[JHRecycleOrderDetailSectionViewModel alloc] init];
    // 商品区
    JHRecycleOrderDetailSectionViewModel *productSection = [[JHRecycleOrderDetailSectionViewModel alloc] init];
    // 订单信息区
    JHRecycleOrderDetailSectionViewModel *orderInfoSection = [[JHRecycleOrderDetailSectionViewModel alloc] init];
    // 客服区
    JHRecycleOrderDetailSectionViewModel *serviceSection = [[JHRecycleOrderDetailSectionViewModel alloc] init];
    
    BOOL hasOrderStatusTitle = [self setupOrderStatusTitleWithSection:orderStatusSection];

    BOOL hasOrderStatus = [self setupOrderStatusDescribeWithSection:orderStatusSection];
    BOOL hasCheck = [self setupCheckWithSection:orderStatusSection];
    BOOL hasArbitration = [self setupArbitrationWithSection:orderStatusSection];
    
    BOOL hasAddress = [self setupAddressWithSection:addressSection];
    BOOL hasProduct = [self setupProductWithSection:productSection];
    BOOL hasOrderInfo = [self setupOrderInfoWithSection:orderInfoSection];
    BOOL hasService = [self setupServiceWithSection:serviceSection];

    if (hasOrderStatusTitle || hasOrderStatus || hasCheck || hasArbitration) {
        [self.cellViewModelList appendObject:orderStatusSection];
    }
    if (hasAddress == true) {
        [self.cellViewModelList appendObject:addressSection];
    }
    if (hasProduct == true) {
        [self.cellViewModelList appendObject:productSection];
    }
    if (hasOrderInfo == true) {
        [self.cellViewModelList appendObject:orderInfoSection];
    }
    if (hasService ==  true) {
        [self.cellViewModelList appendObject:serviceSection];
    }
    
    [self.refreshTableView sendNext:nil];
}
- (RecycleOrderStatus)getOrderStatus {
    
    if (self.model.order == nil) return RecycleOrderStatusEmpty;
    
    switch (self.model.order.recycleOrderStatus) {
        case 1: case 2: // 待付款、待支付
            return RecycleOrderStatusWaitPay;
        case 3: // 待发货
            return RecycleOrderStatusWaitSend;
        case 4: // 已预约上门取件
            return RecycleOrderStatusWaitTakeToSend;
        case 5: // 待收货
            return RecycleOrderStatusWaitReceive;
        case 6: // 待回收商确认价格
        case 7:
            switch (self.model.order.confirmStatus) {
                case 0: // 未确认出价
                    return RecycleOrderStatusWaitConfirmPrice;
                case 1: // 原价购买
                    return RecycleOrderStatusBuyOriginalPrice;
                case 2: // 降价购买
                    return RecycleOrderStatusBuyDiscountPrice;
                case 3: // 拒绝回收
                    switch (self.model.order.appealStatus) {
                        case 0: // 待处理
                            return RecycleOrderStatusArbitrationWaitTodo;
                        case 1: // 待沟通
                            return RecycleOrderStatusArbitrationWaitConnect;
                        case 2: // 仲裁为假
                            return RecycleOrderStatusArbitrationFalse;
                        case 3: // 仲裁为真
                            return RecycleOrderStatusArbitrationTrue;
                        case 4: // 达成交易
                            return RecycleOrderStatusArbitrationDeal;
                        case 1000:
                            return RecycleOrderStatusBuyRefused;
                        default:
                            return RecycleOrderStatusBuyRefused;
                    }
                default:
                    return RecycleOrderStatusWaitConfirmPrice;
            }
        case 8: // 交易完成
            return RecycleOrderStatusFinished;
        case 9: // 退款退货中- 关闭交易
            if (self.model.order.diffRefundType == 4 || self.model.order.diffRefundType == 6) {
                return RecycleOrderStatusClosed;
            }else {
                return RecycleOrderStatusClosedDeal;
            }
//            return RecycleOrderStatusCancelWaitRefund;
        case 10: // 已给商家退款
            return RecycleOrderStatusCancelRefund;
        case 11: // 订单取消
            return RecycleOrderStatusCancel;
        case 12: // 订单关闭
            return RecycleOrderStatusClosed;
            
        default:
            break;
    }
    
    return RecycleOrderStatusArbitrationFalse;
}
- (JHRecycleOrderButtonInfo *)getOrderButtonInfo {
    JHRecycleOrderInfo *orderInfo = self.model.order;
    if (orderInfo == nil) return nil;
    if (orderInfo.recycleOrderStatus != 6 && orderInfo.recycleOrderStatus != 7) return nil;
    JHRecycleOrderButtonInfo *model = [[JHRecycleOrderButtonInfo alloc] init];
    
    RecycleOrderStatus orderStatus = [self getOrderStatus];
   
    if (orderStatus == RecycleOrderStatusBuyDiscountPrice) {
        model.applyRefundBtnFlag = true; // 申请退回
        model.confirmDealBtnFlag = true; // 确认交易
    }else if (orderStatus == RecycleOrderStatusBuyRefused) {
        model.applyDestroyBtnFlag = true; // 申请销毁
        model.applyArbitrationBtnFlag = true; // 申请仲裁
        model.applyRefundBtnFlag = true; // 申请退回
    }else if (orderStatus == RecycleOrderStatusArbitrationFalse) {
        model.applyDestroyBtnFlag = true; // 申请销毁
        model.applyRefundBtnFlag = true; // 申请退回
    }else if (orderStatus == RecycleOrderStatusArbitrationTrue) {
        model.applyRefundBtnFlag = true; // 申请退回
    }else if (orderStatus == RecycleOrderStatusArbitrationDeal) {
        model.applyRefundBtnFlag = true; // 申请退回
        model.confirmDealBtnFlag = true; // 确认交易
    }
    return model;
}
#pragma mark - header
- (void)setupOrderHeaderViewModel {
    if (self.model.recycleNodeLine == nil) return;
    
    [self.headerViewModel setupDataWithNodeInfo: self.model.recycleNodeLine];
}
#pragma mark - 工具栏
- (void)setupOrderToolbarViewModel {
    if (self.model.buttonsVo == nil) return;
    
    [self.toolbarViewModel setupButtonListWithInfo:self.model.buttonsVo];
    
}
#pragma mark - 订单状态title
- (BOOL)setupOrderStatusTitleWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    JHRecycleOrderInfo *orderInfo = self.model.order;
    if (orderInfo == nil) return false;
    
    RecycleOrderStatus orderStatus = [self getOrderStatus];
    JHRecycleOrderDetailStatusTitleViewModel *viewModel = [[JHRecycleOrderDetailStatusTitleViewModel alloc] init];
    
    viewModel.orderStatus = orderStatus;
    if (orderStatus == RecycleOrderStatusBuyDiscountPrice) {
        [viewModel setupPrice:orderInfo.dealPrice originalPrice:orderInfo.offerPrice];
    }

    [section.cellViewModelList appendObject:viewModel];
    return true;
}
#pragma mark - 订单状态-描述
- (BOOL)setupOrderStatusDescribeWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    
    JHRecycleOrderInfo *orderInfo = self.model.order;
    if (orderInfo == nil) return false;
    RecycleOrderStatus orderStatus =  [self getOrderStatus];
    
    if (orderStatus == RecycleOrderStatusBuyDiscountPrice ||
        orderStatus == RecycleOrderStatusBuyRefused ||
        orderStatus == RecycleOrderStatusArbitrationFalse ||
        orderStatus == RecycleOrderStatusArbitrationTrue ||
        orderStatus == RecycleOrderStatusArbitrationDeal ){
        return false;
    }
    if (orderInfo.recycleOrderStatusText == nil) return false;
    
    JHRecycleOrderDetailStatusDescribeViewModel *viewModel = [[JHRecycleOrderDetailStatusDescribeViewModel alloc] init];
    
    NSInteger expireTime = 0;
    
    if (orderInfo.payExpireTimeStr > 0) {
        NSInteger currentTime = [[CommHelp getNowTimeTimestampMS] integerValue];
        expireTime = (orderInfo.payExpireTimeStr - currentTime) / 1000;
    }
    NSString *statusText = orderInfo.recycleOrderStatusText;
    if (orderStatus == RecycleOrderStatusCancel) {
        statusText = orderInfo.cancelReason;
    }else if (orderStatus == RecycleOrderStatusWaitPay) {
        statusText = @"后未付款，视为商家放弃交易，系统将关闭回收单";
    }else if (orderStatus == RecycleOrderStatusWaitSend) {
        statusText = @"后未预约取件，视为放弃交易，系统将关闭回收单";
    }
    
    [viewModel setupDataWithDesc:statusText time:expireTime];
    @weakify(self)
    [viewModel.reloadData subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self getOrderDetailInfo];
    }];
    
    [section.cellViewModelList appendObject:viewModel];
    return true;
}
#pragma mark - 商家验证
- (BOOL)setupCheckWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    JHRecycleOrderInfo *orderInfo = self.model.order;
    if (orderInfo == nil) return false;
    
    RecycleOrderStatus orderStatus =  [self getOrderStatus];
    if (orderStatus != RecycleOrderStatusBuyDiscountPrice && orderStatus != RecycleOrderStatusBuyRefused) {
        return false;
    }

    JHRecycleOrderDetailCheckViewModel *viewModel = [[JHRecycleOrderDetailCheckViewModel alloc] init];
    
    JHRecycleOrderButtonInfo *buttonModel = [self getOrderButtonInfo];
   
    [viewModel.toolbarViewModel setupButtonListWithInfo:buttonModel];
    
    viewModel.describeText = [self getNotEmptyString: orderInfo.signRemark];
    
    [section.cellViewModelList appendObject:viewModel];
    
    @weakify(self)
    [viewModel.clickEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger type = [x integerValue];
        if (type == 0) {
            [self pushBusinessExplain];
        }else {
            [self toolbarEventWithType : type];
        }
    }];
    return true;
}
#pragma mark - 申请仲裁
- (BOOL)setupArbitrationWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    JHRecycleOrderInfo *orderInfo = self.model.order;
    if (orderInfo == nil) return false;
    
    RecycleOrderStatus orderStatus =  [self getOrderStatus];
    if (orderStatus != RecycleOrderStatusArbitrationFalse &&
        orderStatus != RecycleOrderStatusArbitrationTrue &&
        orderStatus != RecycleOrderStatusArbitrationDeal) {
        return false;
    }
    JHRecycleOrderDetailArbitrationViewModel *viewModel = [[JHRecycleOrderDetailArbitrationViewModel alloc] init];
    
    JHRecycleOrderButtonInfo *buttonModel = [self getOrderButtonInfo];
 
    [viewModel.toolbarViewModel setupButtonListWithInfo:buttonModel];
    
    viewModel.describeText = [self getNotEmptyString: orderInfo.remark];
    
    if (orderStatus == RecycleOrderStatusArbitrationDeal) {
        viewModel.price = [self getNotEmptyString: orderInfo.finalPrice];
    }
    
    [section.cellViewModelList appendObject:viewModel];
    
    @weakify(self)
    [viewModel.clickEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSInteger type = [x integerValue];
        [self toolbarEventWithType : type];
    }];
    return false;
}
#pragma mark - 地址
- (BOOL)setupAddressWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    if (self.model.order.shippingAddress == nil) return false;
    
    JHRecycleOrderInfo *orderInfo = self.model.order;
    NSString *country = [self getNotEmptyString:orderInfo.shippingCountry];
    NSString *province = [self getNotEmptyString:orderInfo.shippingProvince];
    NSString *city = [self getNotEmptyString:orderInfo.shippingCity];
    NSString *county = [self getNotEmptyString:orderInfo.shippingCounty];
    NSString *address = [self getNotEmptyString:orderInfo.shippingAddress];
    
    NSString *addressText = [NSString stringWithFormat:@"%@%@%@%@%@",
                         country,
                         province,
                         city,
                         county,
                         address];
    
    
    JHRecycleOrderDetailAddressViewModel *viewModel = [[JHRecycleOrderDetailAddressViewModel alloc] init];
    
    viewModel.addressText = addressText;
    [viewModel setupWithUserName:orderInfo.shippingPerson phone:orderInfo.shippingMobile];
    
    [section.cellViewModelList appendObject:viewModel];
    return true;
}
- (NSString *)getNotEmptyString : (NSString *)string {
    return string != nil ? string : @"";
}
#pragma mark - 商品信息
- (BOOL)setupProductWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    if (self.model.order.onlyGoodsId == nil) return false;
    JHRecycleOrderInfo *orderInfo = self.model.order;
    
    JHRecycleOrderDetailProductViewModel *viewModel = [[JHRecycleOrderDetailProductViewModel alloc] init];
    viewModel.titleText = [self getNotEmptyString: orderInfo.sellerCustomerName];
    viewModel.productUrl = [self getNotEmptyString: orderInfo.goodsUrl];
    viewModel.detailText = [self getNotEmptyString: orderInfo.orderDesc];
    viewModel.sortText = [self getNotEmptyString: orderInfo.goodsCateName];
    [viewModel setupPrice: orderInfo.offerPrice];

    [section.cellViewModelList appendObject:viewModel];
    
    return true;
}
#pragma mark - 订单信息
- (BOOL)setupOrderInfoWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
//    if (self.model.order.orderCode == nil) return false;
    
    JHRecycleOrderDetailInfoViewModel *viewModel = [[JHRecycleOrderDetailInfoViewModel alloc] init];
    viewModel.titleText = @"订单号";
    viewModel.detailText = self.model.order.orderCode;
    viewModel.isShowCopy = true;
    viewModel.isTopCell = true;
    @weakify(self)
    [viewModel.clickEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self orderCopyEventWithId : viewModel.detailText];
    }];
    
    JHRecycleOrderDetailInfoViewModel *viewModel1 = [[JHRecycleOrderDetailInfoViewModel alloc] init];
    viewModel1.titleText = @"下单时间";
    viewModel1.detailText = self.model.order.orderCreateTime;
    viewModel1.isShowCopy = false;
    viewModel1.isBottomCell = true;
    
    [section.cellViewModelList appendObject:viewModel];
    [section.cellViewModelList appendObject:viewModel1];
    return true;
}
#pragma mark - 客服
- (BOOL)setupServiceWithSection : (JHRecycleOrderDetailSectionViewModel *)section {
    
    JHRecycleOrderDetailServiceViewModel *viewModel = [[JHRecycleOrderDetailServiceViewModel alloc] init];
    
    [section.cellViewModelList appendObject:viewModel];
    
    @weakify(self)
    [viewModel.clickEvent subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushService];
    }];
    return true;
}
#pragma mark - 网络请求
- (void)reloadOrderDetails {
    [self.reloadUPData sendNext:nil];
    [self getOrderDetailInfo];
}
- (void)getOrderDetailInfo {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness getOrderInfoWithOrderId:self.orderId successBlock:^(JHRecycleOrderDetailModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.model = respondObject;
        [self setupData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self.refreshTableView sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 取消订单
- (void)orderCancelRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderCancelWithOrderId:self.orderId msg:self.selectedCancelMsg successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 删除订单
- (void)orderDeleteRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderDeleteWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self pushDelete];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 关闭交易
- (void)orderCloseRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderCloseWithOrderId:self.orderId msg:@"" successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
        self.toastMsg = @"订单已关闭";
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 申请寄回
- (void)orderReturnRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderReturnWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 申请销毁
- (void)destructionRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderDestoryWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 确认收货
- (void)orderReceivedRequest {
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderReceivedWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
// 确认交易
- (void)orderAcceptRequest {
    [self reportConfirmTransaction];
    [self.startRefreshing sendNext:nil];
    @weakify(self)
    [JHRecycleOrderDetailBusiness orderAcceptWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        [self reloadOrderDetails];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        self.toastMsg = respondObject.message;
    }];
}
#pragma mark - Lazy
- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
}
- (void)setSelectedCancelMsg:(NSString *)selectedCancelMsg {
    _selectedCancelMsg = selectedCancelMsg;
    if (selectedCancelMsg == nil || [selectedCancelMsg  isEqual: @""]) return;
    [self orderCancelRequest];
}
- (RACSubject<NSDictionary *> *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
- (RACSubject *)startRefreshing {
    if (!_startRefreshing) {
        _startRefreshing = [RACSubject subject];
    }
    return _startRefreshing;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
- (RACSubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACSubject subject];
    }
    return _refreshTableView;
}
- (JHRecycleOrderDetailHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[JHRecycleOrderDetailHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}
- (JHRecycleOrderDetailToolbarViewModel *)toolbarViewModel {
    if (!_toolbarViewModel) {
        _toolbarViewModel = [[JHRecycleOrderDetailToolbarViewModel alloc] init];
        @weakify(self)
        [_toolbarViewModel.clickEvent subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            NSInteger type = [x integerValue];
            [self toolbarEventWithType : type];
        }];
    }
    return _toolbarViewModel;
}
- (NSMutableArray<JHRecycleOrderDetailSectionViewModel *> *)cellViewModelList {
    if (!_cellViewModelList) {
        _cellViewModelList = [[NSMutableArray alloc] init];
    }
    return _cellViewModelList;
}
- (RACSubject *)reloadUPData {
    if (!_reloadUPData) {
        _reloadUPData = [RACSubject subject];
    }
    return _reloadUPData;
}
#pragma mark - 埋点
/// 订单追踪
- (void)reportOrderTracking {
    NSDictionary *par = @{
        @"order_id" : self.orderId,
        @"page_position" : @"recyclingOrderDetails",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickOrderTracking"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 预约上门取件
- (void)reportAppointment {
    NSDictionary *par = @{
        @"order_id" : self.orderId,
        @"page_position" : @"recyclingOrderDetails",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickBookingPickUp"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 确认交易
- (void)reportConfirmTransaction {
    NSNumber *price = [NSNumber numberWithString: self.model.order.finalPrice];
    NSInteger currentTime = [[CommHelp getNowTimeTimestampMS] integerValue];
    NSInteger remaingTime = (self.model.order.remaingTime - currentTime) / 1000;
    remaingTime = remaingTime >= 0 ? remaingTime : 0;
    
    NSDictionary *par = @{
        @"order_id" : self.orderId,
        @"remaining_time" : @(remaingTime),
        @"recovery_transaction_price" : price,
        @"page_position" : @"recyclingOrderDetails",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickConfirmTransaction"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}

@end

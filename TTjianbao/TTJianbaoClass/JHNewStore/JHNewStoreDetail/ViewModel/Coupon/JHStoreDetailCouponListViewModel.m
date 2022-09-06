//
//  JHStoreDetailCouponListViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponListViewModel.h"
#import "JHStoreDetailBusiness.h"


@interface JHStoreDetailCouponListViewModel()
@property (nonatomic, strong) NSArray<JHStoreDetailCouponModel *> *dataList;
@end

@implementation JHStoreDetailCouponListViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
/// 登录
- (void)pushLogin {
    NSLog(@"新人福利");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Login",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
#pragma mark - 数据
// 获取优惠券列表
- (void)getCouponList {
    @weakify(self)
    NSString *sellerId = self.sellerId;
    if (sellerId == nil) { return; }
    [JHStoreDetailBusiness couponlistWithSellerId:sellerId successBlock:^(NSArray<JHStoreDetailCouponModel *> * _Nullable respondObject) {
        @strongify(self)
        self.dataList = respondObject;
        [self setupData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.endRefreshing sendNext:nil];
        if (respondObject.message) {
            self.toastMsg = respondObject.message;
        }
    }];
}
// 领取优惠券
- (void)receiveCouponWithViewModel : (JHStoreDetailCouponListCellViewModel*)viewModel
                          couponId : (NSString*)couponId {
    
    if (viewModel.couponStatus != CouponStatusNormal &&
        viewModel.couponStatus != CouponStatusContinueReceive) { return; }
    if (![self isLogin]) { return; }
    @weakify(self)
    [self.showProgress sendNext:nil];
    [JHStoreDetailBusiness receiveCouponWithID:couponId successBlock:^(JHStoreDetailReceiveCouponModel * _Nullable respondObject) {
        @strongify(self)
        [self.hideProgress sendNext:nil];
        [self setReceiveWithViewModel:viewModel receiveModel:respondObject];
        [self.refreshUpper sendNext:nil];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self)
        [self.hideProgress sendNext:nil];
        if (respondObject.message) {
            self.toastMsg = respondObject.message;
        }
    }];
}
- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [self pushLogin];
        return false;
    }
    return true;
}
- (void)setupData {
    [self.cellList removeAllObjects];
    
    if (self.dataList == nil) { return; }
    
    for (JHStoreDetailCouponModel *model in self.dataList) {
        JHStoreDetailCouponListCellViewModel *viewModel = [[JHStoreDetailCouponListCellViewModel alloc]init];
        
        viewModel.titleText = model.name;
        viewModel.moneyRuleText = [self getRuleTextWithModel:model];
        
        [self setDateWithViewModel:viewModel model:model];
        [self setMoneyWithViewModel:viewModel model:model];
        [self setCouponStatusWithViewModel:viewModel model:model];
        
        @weakify(self)
        [viewModel.receiveAction subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self receiveCouponWithViewModel:viewModel couponId:model.couponId];
            [self reportReceiveCouponEventWithCouponId:model.couponId name:model.name];
        }];
        
        [self.cellList appendObject:viewModel];
    }
    [self.refreshTableView sendNext:nil];
    [self.endRefreshing sendNext:nil];
}
#pragma mark - 满减条件
- (NSString *)getRuleTextWithModel : (JHStoreDetailCouponModel *)model {
    NSString *ruleText = @"";
    if (model.ruleType == nil || model.ruleType.length <= 0) { return @""; }
    if (model.ruleFrCondition == nil || model.ruleFrCondition.length <= 0) { return @""; }
    if ([model.ruleType isEqualToString:@"FR"]) { // 满减
        ruleText = [NSString stringWithFormat:@"满%@元可用", model.ruleFrCondition];
    }else if ([model.ruleType isEqualToString:@"EFR"]) { // 每满减
        ruleText = [NSString stringWithFormat:@"每满%@元可用", model.ruleFrCondition];
    }else if ([model.ruleType isEqualToString:@"OD"]) { // 折扣
        ruleText = [NSString stringWithFormat:@"满%@元可用", model.ruleFrCondition];
    }
    return ruleText;
}
#pragma mark - 满减金额
- (void)setMoneyWithViewModel : (JHStoreDetailCouponListCellViewModel*)viewModel
                        model : (JHStoreDetailCouponModel*)model {
    if ([model.ruleType isEqualToString:@"OD"]) {
        [viewModel setSaleMoney:model.price];
    }else {
        [viewModel setMoney:model.price];
    }
}
#pragma mark - 有效日期
- (void)setDateWithViewModel : (JHStoreDetailCouponListCellViewModel*)viewModel
                       model : (JHStoreDetailCouponModel*)model {
    if (model.timeType == nil ) { return; }
    if ([model.timeType isEqualToString:@"R"] && model.isReceive == false) {//使用时间类型:R相对时间,A:绝对时间"
        NSString *day = model.timeTypeRDay != nil ? model.timeTypeRDay : @"";
        [viewModel setDateWithDay:day];
        viewModel.timeType = CouponStatusTimeDay;
    }else {
        viewModel.timeType = CouponStatusTimeDate;
        [viewModel setDate:model.timeTypeAStartTime
                   endDate:model.timeTypeAEndTime];
    }
}
#pragma mark - 优惠券 状态
- (void)setCouponStatusWithViewModel : (JHStoreDetailCouponListCellViewModel*)viewModel
                               model : (JHStoreDetailCouponModel*)model {
    
    if (model.isReceive == true) {
        viewModel.couponStatus = CouponStatusReceive;
    }else {
        viewModel.couponStatus = CouponStatusNormal;
    }
}
#pragma mark - 领取优惠券 后的状态显示
- (void)setReceiveWithViewModel : (JHStoreDetailCouponListCellViewModel*)viewModel
                   receiveModel : (JHStoreDetailReceiveCouponModel *)receiveModel{
    
    NSInteger status = receiveModel.status;
    
    switch (status) {
        case 2: // 已失效
            self.toastMsg = @"已失效~";
            viewModel.couponStatus = CouponStatusInvalid;
            break;
        case 3: // 已抢光
            self.toastMsg = @"已抢光~";
            viewModel.couponStatus = CouponStatusSellout;
            break;
        case 1: // 已领取
            self.toastMsg = @"领取成功~";
            viewModel.couponStatus = CouponStatusReceive;
            if (viewModel.timeType == CouponStatusTimeDay) {
                viewModel.timeType = CouponStatusTimeDate;
                
                [viewModel setDate:receiveModel.startUseTime
                           endDate:receiveModel.endUseTime];
            }
            break;
        default:
            viewModel.couponStatus = CouponStatusReceive;
            break;
    }
}


#pragma mark - Action functions

#pragma mark - Bind
- (void)bindData {
    
}

#pragma mark - Lazy
- (void)setSellerId:(NSString *)sellerId {
    _sellerId = sellerId;
}
- (NSMutableArray<JHStoreDetailCouponListCellViewModel *> *)cellList {
    if (!_cellList) {
        _cellList = [[NSMutableArray alloc]init];
    }
    return _cellList;
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}
- (RACSubject *)showProgress {
    if (!_showProgress) {
        _showProgress = [RACSubject subject];
    }
    return _showProgress;
}
- (RACSubject *)hideProgress {
    if (!_hideProgress) {
        _hideProgress = [RACSubject subject];
    }
    return _hideProgress;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
- (RACSubject<NSDictionary *> *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
- (RACSubject *)refreshUpper {
    if (!_refreshUpper) {
        _refreshUpper = [RACSubject subject];
    }
    return _refreshUpper;
}
#pragma mark - 埋点
- (void)reportReceiveCouponEventWithCouponId : (NSString *)couponId name : (NSString *)name {
    NSDictionary *par = @{
        @"coupon_id" : couponId,
        @"coupon_name" : name,
        @"store_from" : @"商品详情页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"couponClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end

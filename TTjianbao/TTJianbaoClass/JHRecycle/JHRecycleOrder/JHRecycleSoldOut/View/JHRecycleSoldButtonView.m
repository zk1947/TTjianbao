//
//  JHRecycleSoldButtonView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSoldButtonView.h"
#import "CommAlertView.h"
#import "JHRecycleCameraViewController.h"
#import "JHRecycleTemplateCameraViewController.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHRecycleOrderPursueViewController.h"
#import "JHRecycleUploadArbitrationViewController.h"
#import "JHRecycleOrderDetailAlert.h"
#import "JHRecycleOrderDetailBusiness.h"
#import "MBProgressHUD.h"
#import "JHRecyclePickupViewController.h"
#import "JHRecycleOrderCancelViewController.h"
#import "JHWebViewController.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHC2CPickupViewController.h"
#import "NSString+AttributedString.h"
@interface JHRecycleSoldButtonView()
/** 关闭订单*/
@property (nonatomic, strong) UIButton *closeButton;
/** 取消订单*/
@property (nonatomic, strong) UIButton *cancelButton;
/** 订单追踪*/
@property (nonatomic, strong) UIButton *pursueButton;
/** 预约上门取件*/
@property (nonatomic, strong) UIButton *appointmentButton;
/** 查看物流*/
@property (nonatomic, strong) UIButton *logisticsButton;
/** 查看取件预约*/
@property (nonatomic, strong) UIButton *checkAppointmentButton;
/** 申请仲裁*/
@property (nonatomic, strong) UIButton *arbitrationButton;
/** 申请仲裁*/
@property (nonatomic, strong) UIButton *checkArbitrationButton;
/** 申请销毁*/
@property (nonatomic, strong) UIButton *destroyButton;
/** 确认交易*/
@property (nonatomic, strong) UIButton *ensureButton;
/** 删除*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 申请退回 */
@property (nonatomic, strong) UIButton *returnButton;
/** 确认收货*/
@property (nonatomic, strong) UIButton *receivedButton;
/** 填写物流订单*/
@property (nonatomic, strong) UIButton *fillLogisticsButton;
@end
@implementation JHRecycleSoldButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

//按钮添加顺序如下:删除,关闭订单,取消订单,申请仲裁,查看仲裁,申请销毁,申请退回,订单追踪,预约上门取件,查看取件预约,查看物流,确认交易,确认收货
- (void)setButtonModel:(JHRecycleButtonsModel *)buttonModel {
    _buttonModel = buttonModel;
    [self initializeConstraints];  //先初始化一下约束
    NSMutableArray *array = [NSMutableArray array];
    if (buttonModel.deleteOrderBtnFlag) {
        [array addObject:self.deleteButton];
    }
    if (buttonModel.closeOrderBtnFlag) {
        [array addObject:self.closeButton];
    }
    if (buttonModel.cancelOrderBtnFlag) {
        [array addObject:self.cancelButton];
    }
    if (buttonModel.applyArbitrationBtnFlag) {
        [array addObject:self.arbitrationButton];
    }
    if (buttonModel.seeArbitrationBtnFlag) {
        [array addObject:self.checkArbitrationButton];
    }
    if (buttonModel.applyDestroyBtnFlag) {
        [array addObject:self.destroyButton];
    }
    if (buttonModel.applyRefundBtnFlag) {
        [array addObject:self.returnButton];
    }
    if (buttonModel.traceOrderBtnFlag) {
        [array addObject:self.pursueButton];
    }
    if (buttonModel.callDoorBtnFlag) {
        [array addObject:self.appointmentButton];
    }
    if (buttonModel.seeCallDoorBtnFlag) {
        [array addObject:self.checkAppointmentButton];
    }
    if (buttonModel.seeExpressBtnFlag) {
        [array addObject:self.logisticsButton];
    }
    if (buttonModel.confirmDealBtnFlag) {
        [array addObject:self.ensureButton];
    }
    if (buttonModel.confirmRecieptBtnFlag) {
        [array addObject:self.receivedButton];
    }
    [self remakeConstraintsWithArray:array];
    
}

// 重新定义button的约束,使该显示的显示 该隐藏的隐藏
- (void)remakeConstraintsWithArray:(NSArray <UIButton *>*)buttonsArray {
    //数组逆序
    buttonsArray = [[buttonsArray reverseObjectEnumerator] allObjects];
    UIButton *lastButton;
    for (int i = 0; i < buttonsArray.count; i++) {
        UIButton *button = buttonsArray[i];
        if (buttonsArray.count > 3) { //按钮超出3个 用小字号
            button.titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
        } else {
            button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        }
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (buttonsArray.count > 3) {  //按钮超出3个 约束用窄的
                if ([button isEqual:self.checkAppointmentButton] || [button isEqual:self.appointmentButton] || [button isEqual:self.fillLogisticsButton]) {
                    make.width.mas_equalTo(86);
                } else {
                    make.width.mas_equalTo(64);
                }
            } else{
                if ([button isEqual:self.checkAppointmentButton] || [button isEqual:self.appointmentButton] || [button isEqual:self.fillLogisticsButton]) {
                    make.width.mas_equalTo(98);
                } else {
                    make.width.mas_equalTo(84);
                }
            }
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            if (i == 0) {
                make.right.mas_equalTo(self);
            }else {
                make.right.mas_equalTo(lastButton.mas_left).offset(-6);
            }
        }];
        lastButton = button;
    }
}
// 按钮点击事件
- (void)buttonClickAction:(UIButton *)sender {
    if (self.clickActionBlock) {
        self.clickActionBlock(sender.tag);
    }
    switch (sender.tag) {
        case RecycleOrderButtonTypeCancel: //取消
        {
            @weakify(self);
            JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
            vc.jhNavView.hidden = YES;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.orderId = self.orderId;
            vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString * _Nonnull code) {
                @strongify(self);
                [self cancelOrderRequest:message];
            };
            [self.viewController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case RecycleOrderButtonTypePursue: //订单追踪
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"order_id"] = self.orderId;
            params[@"page_position"] = @"mySelled";
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickOrderTracking" params:params type:JHStatisticsTypeSensors];
            [self pushOrderPursue];
        }
            break;
        case RecycleOrderButtonTypeAppointment: //上门取件
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"order_id"] = self.orderId;
            params[@"page_position"] = @"mySelled";
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickBookingPickUp" params:params type:JHStatisticsTypeSensors];
            [self pushAppointment];
        }
            break;
        case RecycleOrderButtonTypeCheckAppointment: //查看上门取件
        {
            [self pushCheckAppointment];
        }
            break;
        case RecycleOrderButtonTypeLogistics: //查看物流
        {
            [self pushCheckLogistics];
        }
            break;
        case RecycleOrderButtonTypeArbitration: //申请仲裁
        {
            [self pushArbitration];
        }
            break;
        case RecycleOrderButtonTypeEnsure: //确认交易
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"order_id"] = self.soldModel.orderId;
            params[@"remaining_time"] = @(self.soldModel.timeDuring);
            params[@"recovery_transaction_price"] = @(self.soldModel.dealPrice.doubleValue);
            params[@"page_position"] = @"mySelled";
            [JHAllStatistics jh_allStatisticsWithEventId:@"clickConfirmTransaction" params:params type:JHStatisticsTypeSensors];
            
            @weakify(self)
            [self showAlertWithDesc:@"您确定交易后,平台将回收款发放至您的零钱" sureTitle:@"确定" handle:^{
                @strongify(self)
                [self ensureOrderRequest];
            } cancelHandle:^{
                
            }];
        }
            break;
        case RecycleOrderButtonTypeDelete: //删除
        {
            @weakify(self)
            [self showAlertWithDesc:@"确认要删除么?" sureTitle:@"确认" handle:^{
                @strongify(self)
                [self deleteOrderRequest];
            } cancelHandle:^{
                
            }];
        }
            break;
        case RecycleOrderButtonTypeReturn: //申请退回
        {
            @weakify(self)
            [self showAlertWithDesc:@"您确定要将宝贝寄回\n并关闭回收订单?" sureTitle:@"确认" handle:^{
                @strongify(self)
                [self returnOrderRequest];
            } cancelHandle:^{
                
            }];
        }
            break;
        case RecycleOrderButtonTypeReceived: //确认收货
        {
            @weakify(self)
            [self showAlertWithDesc:@"确认已收到货?" sureTitle:@"确认" handle:^{
                @strongify(self)
                [self receivedOrderRequest];
            } cancelHandle:^{
                
            }];
        }
            break;
        case RecycleOrderButtonTypeCheckArbitration: //查看仲裁
        {
            [self pushCheckArbitration];
        }
            break;
        case RecycleOrderButtonTypeDestruction: //申请销毁
        {
            JHRecycleOrderDetailAlert *alert = [[JHRecycleOrderDetailAlert alloc]initWithFrame:CGRectZero];
            [alert showAlertWithDesc:@"您是否确认将宝贝销毁并关闭交易？确认前请阅读并勾选销毁协议。" in:JHRootController.currentViewController.view];
            @weakify(self)
            alert.handle = ^{
                @strongify(self)
                [self destroyOrderRequest];
            };
            alert.agreementHandle = ^{
                @strongify(self)
                JHWebViewController *webView = [[JHWebViewController alloc] init];
                webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/destructionAgreement.html");
                [self.viewController.navigationController pushViewController:webView animated:YES];
            };
            alert.cancelHandle = ^{
                
            };
        }
            break;
        case RecycleOrderButtonTypeClose: //关闭交易
        {
            @weakify(self);
            NSMutableArray *itemsArray = [NSMutableArray array];
            itemsArray[0] = @{@"string":@"关闭交易后，平台将钱款打到回收商账户，", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
            itemsArray[1] = @{@"string":@"如果实际发货后，请谨慎点击关闭交易！否则由您承当相关后果；", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:12]};
            NSMutableAttributedString *string = [NSString mergeStrings:itemsArray];
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"未发货且确认关闭交易" andMutableDesc:string cancleBtnTitle:@"取消" sureBtnTitle:@"确定" andIsLines:NO];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            alert.handle = ^{
                @strongify(self);
                [self orderCloseRequest];
            };
        }
            break;
        case RecycleOrderButtonTypeFillLogistics: //填写物流订单
        {
            JHTOAST(@"填写物流单号");
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - PUSH - 关闭交易
// 关闭交易
- (void)orderCloseRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderCloseWithOrderId:self.orderId msg:@"" successBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        JHTOAST(@"交易已关闭");
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        JHTOAST(respondObject.message);
    }];
}
#pragma mark - PUSH - 取消订单
- (void)cancelOrderRequest:(NSString *)string {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderCancelWithOrderId:self.orderId msg:string successBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        JHTOAST(@"取消成功");
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        JHTOAST(respondObject.message);
    }];
}

#pragma mark - PUSH - 删除订单
- (void)deleteOrderRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderDeleteWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (self.reloadDataBlock) {
            self.reloadDataBlock(YES);
        }
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            JHTOAST(respondObject.message);
            [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        }];
}
#pragma mark - PUSH - 确认收货
- (void)receivedOrderRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderReceivedWithOrderId:self.orderId  successBlock:^(RequestModel * _Nullable respondObject) {
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    }];
}
#pragma mark - PUSH - 确认交易
- (void)ensureOrderRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderAcceptWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    }];
}
#pragma mark - PUSH - 申请销毁
- (void)destroyOrderRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderDestoryWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    }];
}
#pragma mark - PUSH - 申请退回
- (void)returnOrderRequest {
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [JHRecycleOrderDetailBusiness orderReturnWithOrderId:self.orderId successBlock:^(RequestModel * _Nullable respondObject) {
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
    }];
}
#pragma mark - PUSH - 预约上门取件
- (void)pushAppointment {
    JHC2CPickupViewController *vc = [[JHC2CPickupViewController alloc] init];
    vc.fromStatus = 1;
    vc.appointmentSource = 0;
    vc.orderId = self.soldModel.orderId;
    vc.orderCode = self.soldModel.orderCode;
    vc.productId = self.soldModel.goodsId;
    vc.productName = self.soldModel.goodsName;
    @weakify(self);
    [vc.appointmentSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
    }];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - PUSH - 查看预约
- (void)pushCheckAppointment {
    JHC2CWriteOrderNumViewController *vc = [[JHC2CWriteOrderNumViewController alloc] init];
    vc.orderId = self.orderId;
    vc.orderCode = self.soldModel.orderCode;
    vc.productId = self.soldModel.goodsId;
    @weakify(self);
    [vc.writeSuccessSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //成功刷新页面
        if (self.reloadDataBlock) {
            self.reloadDataBlock(NO);
        }
    }];
    [self.viewController.navigationController pushViewController:vc animated:true];
}
#pragma mark - PUSH - 查看物流
- (void)pushCheckLogistics {
    JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
    vc.orderId = self.orderId;
    vc.type = ([self.soldModel.orderStatusCode isEqualToString:@"9"] || [self.soldModel.orderStatusCode isEqualToString:@"10"]) ? 7 : 6;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - PUSH - 订单追踪
- (void)pushOrderPursue {
    JHRecycleOrderPursueViewController *vc = [[JHRecycleOrderPursueViewController alloc] init];
    vc.orderId  = self.orderId;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PUSH - 申请仲裁
- (void)pushArbitration {
    JHRecycleUploadArbitrationViewController *vc = [[JHRecycleUploadArbitrationViewController alloc]init];
    vc.orderId = self.orderId.integerValue;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
#pragma mark - PUSH - 查看仲裁
- (void)pushCheckArbitration {
    JHRecycleUploadArbitrationViewController *vc = [[JHRecycleUploadArbitrationViewController alloc]init];
    vc.orderId = self.orderId.integerValue;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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

- (void)configUI {
    [self addSubview:self.cancelButton];
    [self addSubview:self.closeButton];
    [self addSubview:self.pursueButton];
    [self addSubview:self.appointmentButton];
    [self addSubview:self.logisticsButton];
    [self addSubview:self.checkAppointmentButton];
    [self addSubview:self.arbitrationButton];
    [self addSubview:self.ensureButton];
    [self addSubview:self.deleteButton];
    [self addSubview:self.returnButton];
    [self addSubview:self.receivedButton];
    [self addSubview:self.checkArbitrationButton];
    [self addSubview:self.destroyButton];
    [self addSubview:self.fillLogisticsButton];
    
    for (UIButton *button in @[self.cancelButton, self.closeButton,self.pursueButton, self.appointmentButton, self.checkAppointmentButton, self.logisticsButton, self.arbitrationButton, self.ensureButton, self.deleteButton, self.returnButton, self.receivedButton, self.checkArbitrationButton, self.destroyButton, self.fillLogisticsButton]) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(30);
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(self);
        }];
    }
}

//初始化约束,设置宽度为0,按钮全部隐藏
- (void)initializeConstraints {
    
    for (UIButton *button in @[self.cancelButton, self.closeButton, self.pursueButton, self.appointmentButton, self.checkAppointmentButton, self.logisticsButton, self.arbitrationButton, self.ensureButton, self.deleteButton, self.returnButton, self.receivedButton,self.checkArbitrationButton, self.destroyButton, self.fillLogisticsButton]) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [self getButtonWithColor:NO name:@"取消订单" tag:RecycleOrderButtonTypeCancel];
    }
    return _cancelButton;
}
- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [self getButtonWithColor:NO name:@"关闭交易" tag:RecycleOrderButtonTypeClose];
    }
    return _closeButton;
}
- (UIButton *)pursueButton {
    if (_pursueButton == nil) {
        _pursueButton = [self getButtonWithColor:NO name:@"订单追踪" tag:RecycleOrderButtonTypePursue];
    }
    return _pursueButton;
}
- (UIButton *)appointmentButton {
    if (_appointmentButton == nil) {
        _appointmentButton = [self getButtonWithColor:YES name:@"预约上门取件" tag:RecycleOrderButtonTypeAppointment];
    }
    return _appointmentButton;
}
- (UIButton *)checkAppointmentButton {
    if (_checkAppointmentButton == nil) {
        _checkAppointmentButton = [self getButtonWithColor:YES name:@"填写物流单号" tag:RecycleOrderButtonTypeCheckAppointment];
    }
    return _checkAppointmentButton;
}
- (UIButton *)logisticsButton {
    if (_logisticsButton == nil) {
        _logisticsButton = [self getButtonWithColor:YES name:@"查看物流" tag:RecycleOrderButtonTypeLogistics];
    }
    return _logisticsButton;
}
- (UIButton *)arbitrationButton {
    if (_arbitrationButton == nil) {
        _arbitrationButton = [self getButtonWithColor:NO name:@"申请仲裁" tag:RecycleOrderButtonTypeArbitration];
    }
    return _arbitrationButton;
}
- (UIButton *)ensureButton {
    if (_ensureButton == nil) {
        _ensureButton = [self getButtonWithColor:YES name:@"确认交易" tag:RecycleOrderButtonTypeEnsure];
    }
    return _ensureButton;
}
- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [self getButtonWithColor:NO name:@"删除" tag:RecycleOrderButtonTypeDelete];
    }
    return _deleteButton;
}

- (UIButton *)returnButton {
    if (_returnButton == nil) {
        _returnButton = [self getButtonWithColor:NO name:@"申请寄回" tag:RecycleOrderButtonTypeReturn];
    }
    return _returnButton;
}

- (UIButton *)receivedButton {
    if (_receivedButton == nil) {
        _receivedButton = [self getButtonWithColor:YES name:@"确认收货" tag:RecycleOrderButtonTypeReceived];
    }
    return _receivedButton;
}

- (UIButton *)checkArbitrationButton {
    if (_checkArbitrationButton == nil) {
        _checkArbitrationButton = [self getButtonWithColor:YES name:@"查看仲裁" tag:RecycleOrderButtonTypeCheckArbitration];
    }
    return _checkArbitrationButton;
}

- (UIButton *)destroyButton {
    if (_destroyButton == nil) {
        _destroyButton = [self getButtonWithColor:NO name:@"申请销毁" tag:RecycleOrderButtonTypeDestruction];
    }
    return _destroyButton;
}

- (UIButton *)fillLogisticsButton {
    if (_fillLogisticsButton == nil) {
        _fillLogisticsButton = [self getButtonWithColor:YES name:@"填写物流单号" tag:RecycleOrderButtonTypeFillLogistics];
    }
    return _fillLogisticsButton;
}

// 初始化按钮
- (UIButton *)getButtonWithColor:(BOOL )backColor name:(NSString *)name tag:(RecycleOrderButtonType )tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:name forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
    [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    if (backColor) { //需要填充按钮颜色
        button.backgroundColor = HEXCOLOR(0xffd70f);
    }else {
        button.layer.borderColor = HEXCOLOR(0xbdbfc2).CGColor;
        button.layer.borderWidth = 0.5;
    }
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

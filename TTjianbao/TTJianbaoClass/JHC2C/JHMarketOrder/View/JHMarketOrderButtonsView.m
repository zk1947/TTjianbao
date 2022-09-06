//
//  JHMarketOrderButtonsView.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderButtonsView.h"
#import "CommAlertView.h"
#import "MBProgressHUD.h"
#import "JHMarketOrderCommentViewController.h"
#import "JHRecycleOrderCancelViewController.h"
#import "NSString+AttributedString.h"
#import "JHMarketPriceAlert.h"
#import "JHMarketOrderRefundViewController.h"
#import "JHSessionViewController.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHRefundDetailViewController.h"
#import "JHMarketOrderViewModel.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHC2CSendServiceViewController.h"
#import "JHPlatformResultsViewController.h"
#import "JHChatOrderInfoModel.h"
#import "JHAppraisePayView.h"
#import "JHOrderPayViewController.h"
#import "JHIMEntranceManager.h"
#import "JHAuctionOrderDetailViewController.h"
#import "JHMarketOrderConfirmViewController.h"

@interface JHMarketOrderButtonsView()
/** 删除*/
@property (nonatomic, strong) UIButton *deleteButton;
/** 联系买家*/
@property (nonatomic, strong) UIButton *contactBuyerButton;
/** 联系卖家*/
@property (nonatomic, strong) UIButton *contactSellerButton;
/** 关闭订单*/
@property (nonatomic, strong) UIButton *closeButton;
/** 取消订单*/
@property (nonatomic, strong) UIButton *cancelButton;
/** 申请退款 */
@property (nonatomic, strong) UIButton *refundButton;
/** 修改价格 */
@property (nonatomic, strong) UIButton *changePriceButton;
/** 立即支付*/
@property (nonatomic, strong) UIButton *payButton;
/** 查看退款详情*/
@property (nonatomic, strong) UIButton *refundDetailButton;
/** 去发货*/
@property (nonatomic, strong) UIButton *dispatchButton;
/** 查看物流*/
@property (nonatomic, strong) UIButton *logisticsButton;
/** 提醒发货*/
@property (nonatomic, strong) UIButton *remindDispatchButton;
/** 提醒收货*/
@property (nonatomic, strong) UIButton *remindRecieveButton;
/** 确认收货*/
@property (nonatomic, strong) UIButton *receivedButton;
/** 我要评价*/
@property (nonatomic, strong) UIButton *commentButton;
/** 填写物流单号*/
@property (nonatomic, strong) UIButton *addExpressNoButton;
/** 平台接入结果*/
@property (nonatomic, strong) UIButton *platformInButton;
@end
@implementation JHMarketOrderButtonsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

//按钮添加顺序如下:删除 关闭交易 取消订单 联系卖家 联系卖家  申请退款  修改价格 立即支付 查看退款详情 去发货 查看物流  提醒收货 提醒发货 确认收货 我要评价
- (void)setOrderModel:(JHMarketOrderModel *)orderModel {
    _orderModel = orderModel;
    [self initializeConstraints];  //先初始化一下约束
    NSMutableArray *array = [NSMutableArray array];
    if (orderModel.buttonsVo.contactSellerBtnFlag) {
        [array addObject:self.contactSellerButton];
    }
    if (orderModel.buttonsVo.contactBuyerBtnFlag) {
        [array addObject:self.contactBuyerButton];
    }
    if (orderModel.buttonsVo.cancelOrderBtnFlag) {
        [array addObject:self.cancelButton];
    }
    if (orderModel.buttonsVo.closeOrderBtnFlag) {
        [array addObject:self.closeButton];
    }
    if (orderModel.buttonsVo.applyRefundBtnFlag) {
        [array addObject:self.refundButton];
    }
    if (orderModel.buttonsVo.modifyPriceBtnFlag) {
        [array addObject:self.changePriceButton];
    }
    if (orderModel.buttonsVo.reserveShipBtnFlag) {
        [array addObject:self.dispatchButton];
    }
    if (orderModel.buttonsVo.platformInBtnFlag) {
        [array addObject:self.platformInButton];
    }
    if (orderModel.buttonsVo.seeExpressBtnFlag) {
        [array addObject:self.logisticsButton];
    }
    if (orderModel.buttonsVo.deleteBtnFlag) {
        [array addObject:self.deleteButton];
    }
    if (orderModel.buttonsVo.seeRefundBtnFlag) {
        [array addObject:self.refundDetailButton];
    }
    if (orderModel.buttonsVo.remindShipBtnFlag) {
        [array addObject:self.remindDispatchButton];
    }
    if (orderModel.buttonsVo.remindReceiptBtnFlag) {
        [array addObject:self.remindRecieveButton];
    }
    if (orderModel.buttonsVo.payBtnFlag) {
        [array addObject:self.payButton];
    }
    if (orderModel.buttonsVo.confirmDealBtnFlag) {
        [array addObject:self.receivedButton];
    }
    if (orderModel.buttonsVo.commentBtnFlag) {
        [array addObject:self.commentButton];
    }
    if (orderModel.buttonsVo.addExpressNoBtnFlag) {
        [array addObject:self.addExpressNoButton];
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
                if ([button isEqual:self.refundDetailButton] || [button isEqual:self.addExpressNoButton] || [button isEqual:self.platformInButton]) {
                    make.width.mas_equalTo(86);
                } else {
                    make.width.mas_equalTo(64);
                }
            } else{
                if ([button isEqual:self.refundDetailButton] || [button isEqual:self.addExpressNoButton] || [button isEqual:self.platformInButton]) {
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
    switch (sender.tag) {
        case MarketOrderButtonTagDelete:
        {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:@"您确认删除?" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self deleteOrder];
            };
        }
            break;
        case MarketOrderButtonTagContactBuyer:
        {
            JHChatOrderInfoModel *model = [[JHChatOrderInfoModel alloc] init];
            model.marketOrderType = self.isBuyer ? 1 : 2;
            model.iconUrl = self.orderModel.goodsUrl.small;
            model.title = self.orderModel.goodsName;
            model.price = self.orderModel.orderPrice;
            model.orderState = self.orderModel.orderStatusText;
            model.orderDate = self.orderModel.orderCreateTime;
            model.orderId = self.orderModel.orderId;
            model.orderCode = self.orderModel.orderCode;
            model.orderLoadingCategory = @"market";
            [JHIMEntranceManager pushSessionWithUserId:self.orderModel.customerId orderInfo:model];
        }
            break;
        case MarketOrderButtonTagContactSeller:
        {
            JHChatOrderInfoModel *model = [[JHChatOrderInfoModel alloc] init];
            model.marketOrderType = self.isBuyer ? 1 : 2;
            model.iconUrl = self.orderModel.goodsUrl.small;
            model.title = self.orderModel.goodsName;
            model.price = self.orderModel.orderPrice;
            model.orderState = self.orderModel.orderStatusText;
            model.orderDate = self.orderModel.orderCreateTime;
            model.orderId = self.orderModel.orderId;
            model.orderCode = self.orderModel.orderCode;
            model.orderLoadingCategory = @"market";
            [JHIMEntranceManager pushSessionWithUserId:self.orderModel.customerId orderInfo:model];
        }
            break;
        case MarketOrderButtonTagClose:
        {
            NSMutableArray *itemsArray = [NSMutableArray array];
            itemsArray[0] = @{@"string":@"关闭交易后，平台将钱款打回买家账户，如果实际发货后，请谨慎点击关闭交易！否则由您承当相关后果;\n", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
            itemsArray[1] = @{@"string":@"注：为保障买卖双方利益，多次无理由关闭交易可能受到系统处罚", @"color":HEXCOLOR(0xFF1818), @"font":[UIFont fontWithName:kFontNormal size:12]};
            NSMutableAttributedString *string = [NSString mergeStrings:itemsArray];
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"未发货且确认关闭交易" andMutableDesc:string cancleBtnTitle:@"取消" sureBtnTitle:@"确定" andIsLines:NO];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self closeOrder];
            };
        }
            break;
        case MarketOrderButtonTagCancel:
        {
            JHRecycleOrderCancelViewController *vc = [[JHRecycleOrderCancelViewController alloc] init];
            vc.jhNavView.hidden = YES;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            vc.requestType = self.isBuyer ? 1 : 2;
            @weakify(self);
            vc.selectCompleteBlock = ^(NSString * _Nonnull message, NSString * _Nonnull code) {
                @strongify(self);
                [self cancelOrder:code];
            };
            [self.viewController presentViewController:vc animated:YES completion:nil];
        }
            break;
        case MarketOrderButtonTagRefund:
        {
            JHMarketOrderRefundViewController *refundVc = [[JHMarketOrderRefundViewController alloc] init];
            refundVc.orderModel = self.orderModel;
            refundVc.orderId = self.orderModel.orderId;
            @weakify(self);
            refundVc.completeBlock = ^{
                @strongify(self);
                //成功刷新页面
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(NO);
                }
            };
            [self.viewController.navigationController pushViewController:refundVc animated:YES];
        }
            break;
        case MarketOrderButtonTagChangePrice:
        {
            JHMarketPriceAlert *priceView = [[JHMarketPriceAlert alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
            priceView.oriPrice = self.orderModel.originOrderPrice;
            priceView.frePrice = self.orderModel.freight;
            priceView.orderId = self.orderModel.orderId;
            @weakify(self);
            priceView.successCompleteBlock = ^{
                @strongify(self);
                //成功刷新页面
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(NO);
                }
            };
            [[UIApplication sharedApplication].keyWindow addSubview:priceView];
        }
            break;
        case MarketOrderButtonTagPay:
        {
            if (self.payButtonClick) {
                self.payButtonClick();
            }
            if (self.orderModel.orderStatus.integerValue == 1) {  //竞拍单 先确认订单
                /// 这里是C2C
                JHMarketOrderConfirmViewController * order=[[JHMarketOrderConfirmViewController alloc]init];
                order.orderCategory = @"marketAuctionOrder";
                order.orderId= self.orderModel.orderId;
                @weakify(self);
                order.payBlock = ^{
                    @strongify(self);
                    //成功刷新页面
                    if (self.reloadDataBlock) {
                        self.reloadDataBlock(NO);
                    }
                };
                [self.viewController.navigationController pushViewController:order animated:YES];
            }  else {
                //下面是支付页面
                JHOrderPayViewController *order =[[JHOrderPayViewController alloc]init];
                order.orderId=self.orderModel.orderId;
                order.goodsId = self.orderModel.goodsId;
                order.isMarket = YES;
                [self.viewController.navigationController pushViewController:order animated:YES];
            }
        }
            break;
        case MarketOrderButtonTagRefundDetail:
        {
            JHRefundDetailViewController *detail = [[JHRefundDetailViewController alloc] init];
            detail.orderId = self.orderModel.orderId;
            detail.orderCode = self.orderModel.orderCode;
            detail.productId = self.orderModel.goodsId;
            detail.productName = self.orderModel.goodsName;
            detail.orderStatusCode = self.orderModel.orderStatus;
            detail.customerFlag = self.isBuyer ? 1 : 2;
            
            detail.userId = self.orderModel.customerId;
            JHChatOrderInfoModel *model = [[JHChatOrderInfoModel alloc] init];
            model.marketOrderType = self.isBuyer ? 1 : 2;
            model.iconUrl = self.orderModel.goodsUrl.small;
            model.title = self.orderModel.goodsName;
            model.price = self.orderModel.orderPrice;
            model.orderState = self.orderModel.orderStatusText;
            model.orderDate = self.orderModel.orderCreateTime;
            model.orderId = self.orderModel.orderId;
            detail.orderInfo = model;
            @weakify(self);
            [detail.needRefreshSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                //成功刷新页面
                if (self.reloadDataBlock) {
                    self.reloadDataBlock([x[@"isDelete"] boolValue]);
                }
            }];
            [self.viewController.navigationController pushViewController:detail animated:YES];
        }
            break;
        case MarketOrderButtonTagDispatch:
        {
            JHC2CSendServiceViewController *sendService = [[JHC2CSendServiceViewController alloc] init];
            sendService.orderId = self.orderModel.orderId;
            sendService.orderCode = self.orderModel.orderCode;
            sendService.productId = self.orderModel.goodsId;
            sendService.productName = self.orderModel.goodsName;
            sendService.appointmentSource = 0;
            sendService.customerFlag = self.isBuyer ? 1 : 2;
            @weakify(self);
            [sendService.requestSuccessSubject subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                //成功刷新页面
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(NO);
                }
            }];
            [self.viewController.navigationController pushViewController:sendService animated:YES];
        }
            break;
        case MarketOrderButtonTagLogistics:
        {
            JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
            vc.orderId = self.orderModel.orderId;
            vc.type = (self.orderModel.orderStatus.integerValue == 8) ? 7 : 6;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        case MarketOrderButtonTagRemindDispatch:
        {
            [self remindSend];
        }
            break;
        case MarketOrderButtonTagRemindRecieve:
        {
            [self remindRecieved];
        }
            break;
        case MarketOrderButtonTagReceived:
        {
            
            NSMutableArray *itemsArray = [NSMutableArray array];
            itemsArray[0] = @{@"string":@"确认收货后，交易结束，平台将钱款打入卖家账户，", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
            itemsArray[1] = @{@"string":@"您无法再发起退款等售后申请，", @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontBoldDIN size:12]};
            itemsArray[2] = @{@"string":@"请谨慎点击确认收货!", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:12]};
            NSMutableAttributedString *string = [NSString mergeStrings:itemsArray];
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"您是否已收到货并验收无误" andMutableDesc:string cancleBtnTitle:@"未收到货" sureBtnTitle:@"已收货,确认验收无误" andIsLines:YES];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            @weakify(self);
            alert.handle = ^{
                @strongify(self);
                [self recievedGoods];
            };
            
            alert.cancleHandle = ^{
//                @strongify(self);
//                JHTOAST(@"未收到货");
            };
        }
            break;
        case MarketOrderButtonTagComment:  //评价
        {
            JHMarketOrderCommentViewController *commentView = [[JHMarketOrderCommentViewController alloc] init];
            commentView.orderId = self.orderModel.orderId;
            @weakify(self);
            commentView.completeBlock = ^{
                @strongify(self);
                //成功刷新页面
                if (self.reloadDataBlock) {
                    self.reloadDataBlock(NO);
                }
            };
            [self.viewController.navigationController pushViewController:commentView animated:YES];
        }
            break;
        case MarketOrderButtonTagAddExp:  //填写物流
        {
            JHC2CWriteOrderNumViewController *vc = [[JHC2CWriteOrderNumViewController alloc] init];
            vc.orderId = self.orderModel.orderId;
            vc.orderCode = self.orderModel.orderCode;
            vc.productId = self.orderModel.goodsId;
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
            break;
        case MarketOrderButtonTagPlatform:  //平台接入
        {
            JHPlatformResultsViewController *platformVc = [[JHPlatformResultsViewController alloc] init];
            platformVc.orderId = self.orderModel.orderId;
            [self.viewController.navigationController pushViewController:platformVc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

// 确认收货
- (void)recievedGoods {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    [JHMarketOrderViewModel signOrder:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"已确认收货");
            if (self.reloadDataBlock) {
                self.reloadDataBlock(NO);
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

//删除订单
- (void)deleteOrder {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    params[@"delType"] = self.isBuyer ? @"1" : @"2";
    [JHMarketOrderViewModel deleteOrder:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"删除订单成功");
            if (self.reloadDataBlock) {
                self.reloadDataBlock(YES);
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

// 提醒发货
- (void)remindSend {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    [JHMarketOrderViewModel remindShip:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"已提醒卖家发货");
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

// 提醒收货
- (void)remindRecieved {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    [JHMarketOrderViewModel remindReceipt:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"已提醒买家收货");
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

// 关闭交易
- (void)closeOrder {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    [JHMarketOrderViewModel closeOrder:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            JHTOAST(@"订单已关闭");
            if (self.reloadDataBlock) {
                self.reloadDataBlock(NO);
            }
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

// 取消订单
- (void)cancelOrder:(NSString *)reasonCode {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderId"] = self.orderModel.orderId;
    params[@"cancelReason"] = reasonCode;
    params[@"cancelType"] = self.isBuyer ? @"1" : @"2";
    [JHMarketOrderViewModel cancelOrder:params Completion:^(NSError * _Nullable error, NSDictionary * _Nullable data) {
        [SVProgressHUD dismiss];
        if (!error) {
            if (self.reloadDataBlock) {
                self.reloadDataBlock(NO);
            }
            JHTOAST(@"订单已取消");
        } else {
            JHTOAST(error.localizedDescription);
        }
    }];
}

#pragma mark - PUSH - 关闭交易

- (void)configUI {
    [self addSubview:self.deleteButton];
    [self addSubview:self.contactBuyerButton];
    [self addSubview:self.contactSellerButton];
    [self addSubview:self.closeButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.refundButton];
    [self addSubview:self.changePriceButton];
    [self addSubview:self.payButton];
    [self addSubview:self.refundDetailButton];
    [self addSubview:self.dispatchButton];
    [self addSubview:self.logisticsButton];
    [self addSubview:self.remindDispatchButton];
    [self addSubview:self.remindRecieveButton];
    [self addSubview:self.receivedButton];
    [self addSubview:self.commentButton];
    [self addSubview:self.addExpressNoButton];
    [self addSubview:self.platformInButton];
    
    for (UIButton *button in @[self.deleteButton, self.contactBuyerButton,self.contactSellerButton, self.closeButton, self.cancelButton, self.refundButton, self.changePriceButton, self.payButton, self.refundDetailButton, self.dispatchButton, self.logisticsButton, self.remindDispatchButton, self.remindRecieveButton, self.receivedButton, self.commentButton, self.addExpressNoButton, self.platformInButton]) {
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
    
    for (UIButton *button in @[self.deleteButton, self.contactBuyerButton,self.contactSellerButton, self.closeButton, self.cancelButton, self.refundButton, self.changePriceButton, self.payButton, self.refundDetailButton, self.dispatchButton, self.logisticsButton, self.remindDispatchButton, self.remindRecieveButton, self.receivedButton, self.commentButton, self.addExpressNoButton, self.platformInButton]) {
        [button mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [self getButtonWithColor:NO name:@"删除" tag:MarketOrderButtonTagDelete];
    }
    return _deleteButton;
}
- (UIButton *)contactBuyerButton {
    if (_contactBuyerButton == nil) {
        _contactBuyerButton = [self getButtonWithColor:NO name:@"联系买家" tag:MarketOrderButtonTagContactBuyer];
    }
    return _contactBuyerButton;
}
- (UIButton *)contactSellerButton {
    if (_contactSellerButton == nil) {
        _contactSellerButton = [self getButtonWithColor:NO name:@"联系卖家" tag:MarketOrderButtonTagContactSeller];
    }
    return _contactSellerButton;
}

- (UIButton *)closeButton {
    if (_closeButton == nil) {
        _closeButton = [self getButtonWithColor:NO name:@"关闭交易" tag:MarketOrderButtonTagClose];
    }
    return _closeButton;
}
- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [self getButtonWithColor:NO name:@"取消订单" tag:MarketOrderButtonTagCancel];
    }
    return _cancelButton;
}
- (UIButton *)refundButton {
    if (_refundButton == nil) {
        _refundButton = [self getButtonWithColor:NO name:@"申请退款" tag:MarketOrderButtonTagRefund];
    }
    return _refundButton;
}
- (UIButton *)changePriceButton {
    if (_changePriceButton == nil) {
        _changePriceButton = [self getButtonWithColor:YES name:@"修改价格" tag:MarketOrderButtonTagChangePrice];
    }
    return _changePriceButton;
}
- (UIButton *)payButton {
    if (_payButton == nil) {
        _payButton = [self getButtonWithColor:YES name:@"立即支付" tag:MarketOrderButtonTagPay];
    }
    return _payButton;
}
- (UIButton *)refundDetailButton {
    if (_refundDetailButton == nil) {
        _refundDetailButton = [self getButtonWithColor:YES name:@"查看退款详情" tag:MarketOrderButtonTagRefundDetail];
    }
    return _refundDetailButton;
}
- (UIButton *)dispatchButton {
    if (_dispatchButton == nil) {
        _dispatchButton = [self getButtonWithColor: YES name:@"预约发货" tag:MarketOrderButtonTagDispatch];
    }
    return _dispatchButton;
}
- (UIButton *)logisticsButton {
    if (_logisticsButton == nil) {
        _logisticsButton = [self getButtonWithColor:NO name:@"查看物流" tag:MarketOrderButtonTagLogistics];
    }
    return _logisticsButton;
}
- (UIButton *)remindDispatchButton {
    if (_remindDispatchButton == nil) {
        _remindDispatchButton = [self getButtonWithColor:YES name:@"提醒发货" tag:MarketOrderButtonTagRemindDispatch];
    }
    return _remindDispatchButton;
}

- (UIButton *)remindRecieveButton {
    if (_remindRecieveButton == nil) {
        _remindRecieveButton = [self getButtonWithColor:YES name:@"提醒收货" tag:MarketOrderButtonTagRemindRecieve];
    }
    return _remindRecieveButton;
}

- (UIButton *)receivedButton {
    if (_receivedButton == nil) {
        _receivedButton = [self getButtonWithColor:YES name:@"确认收货" tag:MarketOrderButtonTagReceived];
    }
    return _receivedButton;
}

- (UIButton *)commentButton {
    if (_commentButton == nil) {
        _commentButton = [self getButtonWithColor:YES name:@"我要评价" tag:MarketOrderButtonTagComment];
    }
    return _commentButton;
}
- (UIButton *)addExpressNoButton {
    if (_addExpressNoButton == nil) {
        _addExpressNoButton = [self getButtonWithColor:YES name:@"填写物流单号" tag:MarketOrderButtonTagAddExp];
    }
    return _addExpressNoButton;
}
- (UIButton *)platformInButton {
    if (_platformInButton == nil) {
        _platformInButton = [self getButtonWithColor:NO name:@"平台介入结果" tag:MarketOrderButtonTagPlatform];
    }
    return _platformInButton;
}

// 初始化按钮
- (UIButton *)getButtonWithColor:(BOOL )backColor name:(NSString *)name tag:(NSInteger )tag {
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

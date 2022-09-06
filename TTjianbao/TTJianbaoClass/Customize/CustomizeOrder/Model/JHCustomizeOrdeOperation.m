//
//  JHCustomizeOrdeOperation.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrdeOperation.h"
#import "JHOrderPayViewController.h"
#import "JHPrinterManager.h"
#import "JHWebViewController.h"
#import "JHCustomizeSendGoodsViewController.h"
#import "JHQYChatManage.h"
#import "JHSellerSendOrderViewController.h"
#import "CommAlertView.h"
#import "JHGrowingIO.h"
#import "JHSendCommentViewController.h"
#import "JHOrderReturnViewController.h"
#import "JHCustomizeLogisticsViewController.h"
#import "JHCustomizeAddCompleteViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHContactAlertView.h"
#import "JHCustomizeHomePickupViewController.h"
#import "AdressManagerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHIMEntranceManager.h"
@implementation JHCustomizeOrdeOperation
+(void)customizeOrderButtonAction:(JHCustomizeOrderModel*)model
  buttonType:(JHCustomizeOrderButtonType)type isSeller:(BOOL)seller  isFromOrderDetail:(BOOL)fromDetail{

    switch (type) {
            
        case JHCustomizeOrderButtonGoPay:{
            
            [self toGoPay:model isSeller:seller];
            
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_orderlist_pay_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_order_pay_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
            
        case JHCustomizeOrderButtonAppraiseReport:{
            [self toAppraiseReport:model isSeller:seller];
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_jdxq_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_orderlist_jdxq_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            
            
        }
            break;
        case JHCustomizeOrderButtonCancelMade:{
            
            [self toCancelMade:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonCancelOrder:{
            
            [self toCancelOrder:model isSeller:seller];
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_qxorderlist_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_qxorder_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
        case JHCustomizeOrderButtonCompleteInfo:{
            
            [self toCompleteInfo:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonConfirmAccept:{
            
            [self toConfirmAccept:model isSeller:seller];
            
        }
            break;
            
        case JHCustomizeOrderButtonConfirmMade:{
            
            [self toConfirmMade:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonConfirmPay:{
            
            [self toConfirmPay:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonConfirmPlan:{
            
            [self toConfirmPlan:model isSeller:seller];
            
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_sure_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_orderlist_sure_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
        case JHCustomizeOrderButtonConfirmReceipt:{
            
            [self toConfirmReceipt:model isSeller:seller];
            if (fromDetail) {
                [JHGrowingIO trackEventId:@"dz_order_qrsh_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_orderlist_qrsh_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
           
        }
            break;
        case JHCustomizeOrderButtonConnectMic:{
            
            [self toConnectMic:model isSeller:seller isFromOrderDetail:fromDetail];
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_sqlm_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_orderlist_sqlm_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
        case JHCustomizeOrderButtonModifyInfo:{
            
            [self toModifyInfo:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonPrintCard:{
            [self toPrintCard:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonRefundDetail:{
            
            [self toRefundDetail:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonReturnGoods:{
            
            [self toReturnGoods:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonViewExpress:{
            
            [self toViewExpress:model isSeller:seller];
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_ckwl_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
            else{
                [JHGrowingIO trackEventId:@"dz_orderlist_ckwl_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
            
        case JHCustomizeOrderButtonCompleteGoods:{
            
            [self toCompleteGoods:model isSeller:seller];
            
        }
            break;
        case JHCustomizeOrderButtonContactPlatform:{
            
            [self toContactPlatform:model isSeller:seller];
            
        }
            break;
        case JHCustomizeOrderButtonContactService:{
            
            [self toContactService:model isSeller:seller];
            
            if (fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_lxkf_click" variables:@{@"orderId":model.orderId,@"orderType":model.status}];
            }
        }
            break;
        case JHCustomizeOrderButtonUpdateRemark:{
            
            [self toUpdateRemark:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonComment:{
            
            [self toComment:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonHasComment:{
            
            [self toHasComment:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonNewSettle:{
            
            [self toNewSettle:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonDelete:{
            
            [self toDelete:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonUpLoadPlan:{
            
            [self toUploadPlan:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderStatusConfirmOrder:{
            
            [self toConfirmOrder:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonConfirmSend:{
            
            [self toConfirmSend : model isSeller:seller isFromOrderDetail:fromDetail];

        }
            break;
            
        case JHCustomizeOrderButtonAlterAddress:{

            [self toAlterAddress: model isSeller:seller];

        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 鉴定报告
+ (void)toAppraiseReport:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 取消定制 没有
+ (void)toCancelMade:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    //cr test
    
    
}
#pragma mark - 用户取消订单
+ (void)toCancelOrder:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您确定要取消订单吗" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/cancel") Parameters:@{@"customizeOrderId":mode.customizeOrderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:@"取消订单成功" duration:1.0 position:CSToastPositionCenter];
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        [SVProgressHUD show];
    };
    
}
#pragma mark - 信息
+ (void)toCompleteInfo:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = CompleteOrderDetailURL(mode.orderId);
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 主播确认接单   没了
+ (void)toConfirmAccept:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    
    
}

#pragma mark - 用户确认订单
+ (void)toConfirmOrder:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderConfirmViewController  * order=[[JHOrderConfirmViewController alloc]init];
    order.orderId=mode.orderId;
    [[JHRootController currentViewController].navigationController pushViewController:order animated:YES];
    
}
#pragma mark - 主播确认定制
+ (void)toConfirmMade:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您确定要定制吗" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/confirmCustomized") Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:@"确认定制成功" duration:1.0 position:CSToastPositionCenter];
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            
        } failureBlock:^(RequestModel *respondObject) {
            
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        
        [SVProgressHUD show];
    };
    
}
#pragma mark - 确认收货
+ (void)toConfirmReceipt:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"您确定要收货吗" cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        NSString *url;
        if (seller) {
            url = FILE_BASE_STRING(@"/orderCustomize/auth/confirmReceived");
            [HttpRequestTool postWithURL:url Parameters:@{@"customizeOrderId":mode.customizeOrderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
                [SVProgressHUD dismiss];
                [JHKeyWindow makeToast:@"收货完成" duration:1.0 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
                
            } failureBlock:^(RequestModel *respondObject) {
                
                [SVProgressHUD dismiss];
                [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
                
            }];
            
            [SVProgressHUD show];
        }
        else{
            url = FILE_BASE_STRING(@"/orderCustomize/auth/buyerreceived");
            //TODO jiang 建议和后端协商改成传orderId
           [HttpRequestTool postWithURL:url Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
               [SVProgressHUD dismiss];
               [JHKeyWindow makeToast:@"收货完成" duration:1.0 position:CSToastPositionCenter];
               [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
               
           } failureBlock:^(RequestModel *respondObject) {
               
               [SVProgressHUD dismiss];
               [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
               
           }];
           
           [SVProgressHUD show];
        }
    };
    
}

#pragma mark - 确认发货
+ (void)toConfirmSend:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller isFromOrderDetail:(BOOL)fromDetail{
    
    if (seller) {
        JHCustomizeSendGoodsViewController *vc = [[JHCustomizeSendGoodsViewController alloc]init];
         vc.orderId = mode.orderId;
         vc.isSeller = seller;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        if(fromDetail) {
            [JHGrowingIO trackEventId:@"dz_order_fh_click" variables:@{@"orderId":mode.orderId,@"orderType":mode.status}];
        }else{
            [JHGrowingIO trackEventId:@"dz_orderlist_fh_click" variables:@{@"orderId":mode.orderId,@"orderType":mode.status}];
        }
    }else{//上门取件
        JHCustomizeHomePickupViewController *homePickupVC = [[JHCustomizeHomePickupViewController alloc]init];
        homePickupVC.orderId = mode.orderId;
        homePickupVC.isSeller = seller;
        if(fromDetail) {
            homePickupVC.fromString = JHLiveFromorderDetail;//订单详情
        }else{
            homePickupVC.fromString = JHLiveFromboughtFragment;//订单列表
        }
        [[JHRootController currentViewController].navigationController pushViewController:homePickupVC animated:YES];
        
    }
    
}

#pragma mark - 申请连麦
+ (void)toConnectMic:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller  isFromOrderDetail:(BOOL)fromDetail{
    
    NSString * from =fromDetail?@"dz_order_xq_in":@"dz_orderlist_in";
    BOOL sameRoomId=NO;
    
    for ( UIViewController *vc in [JHRootController currentViewController].navigationController.viewControllers) {
        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
    NTESAudienceLiveViewController * liveVC = (NTESAudienceLiveViewController*)vc;
    if ([liveVC.channel.channelLocalId isEqualToString:mode.channelLocalId]) {
    sameRoomId = YES;
  /// 连麦中直接返回，不连麦打开呼起连麦弹层
    if (liveVC.currentUserRole == CurrentUserRoleLinker) {
    [[JHRootController currentViewController].navigationController popToViewController:liveVC animated:YES];
        } else {
        [JHRootController EnterLiveRoom:mode.channelLocalId fromString:from isStoneDetail:NO isApplyConnectMic:YES];
        }
        break;
        }
            
      }
    }
    
    if (!sameRoomId) {
        [JHRootController EnterLiveRoom:mode.channelLocalId fromString:from isStoneDetail:NO isApplyConnectMic:YES];
    }
}

#pragma mark - 修改信息  **干掉了
+ (void)toModifyInfo:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{

    
}

#pragma mark - 打印保卡
+ (void)toPrintCard:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    [[JHPrinterManager sharedInstance] printOrderBarCode:mode.orderId andResult:nil];
    
}

#pragma mark - 退款详情
+ (void)toRefundDetail:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = ReturnDetailURL(mode.orderId, seller?1:0);
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - 退货到平台
+ (void)toReturnGoods:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
    vc.orderId = mode.orderId;
    vc.directDelivery = mode.directDelivery;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 查看物流
+ (void)toViewExpress:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (seller) {
        type=user.isAssistant?@"10":@"9";
    }
    else{
        type=@"0";
    }
    JHCustomizeLogisticsViewController * express = [[JHCustomizeLogisticsViewController alloc]init];
    express.orderId = mode.orderId;
    express.userType = type;
    [[JHRootController currentViewController].navigationController pushViewController:express animated:YES];
    
}
#pragma mark - 去支付
+ (void)toGoPay:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderPayViewController * vc = [[JHOrderPayViewController alloc]init];
    vc.orderId = mode.orderId;
    vc.directDelivery = mode.directDelivery;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}
#pragma mark - 确认支付
+ (void)toConfirmPay:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderPayViewController * vc = [[JHOrderPayViewController alloc]init];
    vc.orderId = mode.orderId;
    vc.directDelivery = mode.directDelivery;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 制作完成  去添加制作完成页面
+ (void)toCompleteGoods:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    if (!mode.customizeShowBtnVo.clickCompleteBtn) {
     [[JHRootController currentViewController].view makeToast:@"还有方案待确认，请稍后操作" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    JHCustomizeAddCompleteViewController * vc = [[JHCustomizeAddCompleteViewController alloc]init];
    vc.customizeOrderId = mode.customizeOrderId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 联系平台    **干掉了
+ (void)toContactPlatform:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
}
#pragma mark - 联系客服
+ (void)toContactService:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    if (seller) {
//        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
        @weakify(self);
        JHContactAlertView *alertView = [[JHContactAlertView alloc] initWithFrame:JHKeyWindow.bounds];
        [JHKeyWindow addSubview:alertView];
        alertView.clickBlock = ^{
            @strongify(self);
//            [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:mode];
        [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
        };

    }else {
        [JHQYChatManage checkChatTypeWithCustomerId:mode.sellerCustomerId  saleType:JHChatSaleTypeAfter completeResult:^(BOOL isShop, JHQYStaffInfo * _Nonnull staffInfo) {
            if(isShop)
            {
                [JHIMEntranceManager pushSessionOrderWithUserId:mode.sellerCustomerId orderInfo:mode];
//                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:mode];
            }
            else
            {
                @weakify(self);
                JHContactAlertView *alertView = [[JHContactAlertView alloc] initWithFrame:JHKeyWindow.bounds];
                [JHKeyWindow addSubview:alertView];
                alertView.clickBlock = ^{
                    @strongify(self);
                    [JHIMEntranceManager pushSessionOrderWithUserId:mode.sellerCustomerId orderInfo:mode];
//                    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:mode];
                };
            }
        }];
    }
}
#pragma mark -更新备注  **干掉了
+ (void)toUpdateRemark:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    
}

#pragma mark -评价
+ (void)toComment:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
    vc.orderId = mode.orderId;
    vc.imageUrl = mode.goodsUrl;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 修改地址
+ (void)toAlterAddress:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
    vc.orderId=mode.orderId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 已评价
+ (void)toHasComment:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
    vc.orderId = mode.orderId;
    vc.imageUrl = mode.goodsImg;
    vc.isShow = YES;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -新结算
+ (void)toNewSettle:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    NSString *url = [NSString stringWithFormat:@"/jianhuo/app/settlement/settlement.html?orderId=%@",mode.orderId];
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString  = H5_BASE_STRING(url);
    webVC.titleString = @"结算详情";
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
    
}
#pragma mark -删除
+ (void)toDelete:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"删除后此订单将不再展示，请确认操作？" cancleBtnTitle:@"取消" sureBtnTitle:@"删除"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [HttpRequestTool putWithURL:[FILE_BASE_STRING(@"/order/auth/buyer/delete/") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            
        } failureBlock:^(RequestModel *respondObject) {
            
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        
        [SVProgressHUD show];
    };
    
}
#pragma mark -主播提交方案
+ (void)toUploadPlan:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
//    NSString * url = [NSString stringWithFormat:FILE_BASE_STRING(@"/orderCustomizePlan/auth/commitCustomizePlan?customizeOrderId=%@"),mode.customizeOrderId];
    NSString * url = FILE_BASE_STRING(@"/orderCustomizePlan/auth/commitCustomizePlan");
    [HttpRequestTool postWithURL:url Parameters:@{@"customizeOrderId":mode.customizeOrderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:@"方案提交成功" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    [SVProgressHUD show];
    
    
}
#pragma mark - 用户确认方案
+ (void)toConfirmPlan:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"" andDesc:@"确认后，定制师会根据您要求进行定制" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
    [JHKeyWindow addSubview:alert];
    @weakify(self);
    alert.handle = ^{
        @strongify(self);
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/confirmPlan") Parameters:@{@"orderId":mode.orderId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
             [SVProgressHUD dismiss];
            
            if ([respondObject.data[@"needPay"] boolValue]) {
                JHOrderPayViewController * vc = [[JHOrderPayViewController alloc]init];
                vc.orderId = mode.orderId;
                
                vc.directDelivery = mode.directDelivery;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            }
            else{
                [JHKeyWindow makeToast:@"确认方案成功" duration:1.0 position:CSToastPositionCenter];
                [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
            }
            
        } failureBlock:^(RequestModel *respondObject) {
            
            [SVProgressHUD dismiss];
            [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        
        [SVProgressHUD show];
    };
    
}
@end

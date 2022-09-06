//
//  JHOrderOperation.m
//  TTjianbao
//
//  Created by jiangchao on 2021/1/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHOrderOperation.h"
#import "JHExpressViewController.h"
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
#import "JHOrderViewModel.h"
#import "JHSendOutViewController.h"
#import "AdressManagerViewController.h"
#import "JHOrderNoteView.h"
#import "JHUnionSignSalePopView.h"
#import "JHUnionSignView.h"
#import "JHOrderApplyReturnViewController.h"
#import "JHFansTaskView.h"
#import "JHFansListView.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHAuctionOrderDetailViewController.h"
#import "JHRefunfOrderModel.h"
@implementation JHOrderOperation
+(void)customizeOrderButtonAction:(JHCustomizeOrderModel*)model
  buttonType:(JHCustomizeOrderButtonType)type isSeller:(BOOL)seller  isFromOrderDetail:(BOOL)fromDetail{

    switch (type) {
            
        case JHCustomizeOrderStatusConfirmOrder:{
            
            [self toConfirmOrder:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonGoPay:{
            
            [self toGoPay:model isSeller:seller];
            
        }
            break;
            
        case JHCustomizeOrderButtonCancelOrder:{
            
            [self toCancelOrder:model isSeller:seller];
            
        }
            break;
            
        case JHCustomizeOrderButtonAppraiseReport:{
            [self toAppraiseReport:model isSeller:seller];
            
        }
            break;
        case JHCustomizeOrderButtonApplyCustomize:{
            
            [self toApplyCustomize:model isSeller:seller];
        }
            break;
       
        case JHCustomizeOrderButtonCompleteInfo:{
            
            [self toCompleteInfo:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonConfirmPay:{
            
            [self toConfirmPay:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonAppraiseIssue:{
            
            [self toAppraiseIssue:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonConfirmReceipt:{
            
            [self toConfirmReceipt:model isSeller:seller];
           
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
            
        case JHCustomizeOrderButtonApplyReturnGoods:{
            
            [self toApplyReturnGoods:model isSeller:seller];
        }
            break;
        case JHCustomizeOrderButtonReturnGoods:{
            
            [self toReturnGoods:model isSeller:seller];
        }
            break;
            
        case JHCustomizeOrderButtonViewExpress:{
            
            [self toViewExpress:model isSeller:seller];
          
        }
            break;
            
            //转售
        case JHCustomizeOrderButtonStoneResell:{
            
            [self toStoneResell:model isSeller:seller];
            
        }
            break;
       
        case JHCustomizeOrderButtonContactService:{
            
            [self toContactService:model isSeller:seller];
            
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
            
        }
            break;
            
        case JHCustomizeOrderButtonConfirmSend:{
            
            [self toConfirmSend : model isSeller:seller];
            
        }
            break;
            
        case JHCustomizeOrderButtonAlterAddress:{

            [self toAlterAddress: model isSeller:seller];

        }
            break;
            
        case JHCustomizeOrderButtonRemindSend:{

            [self toRemindSend: model isSeller:seller];

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




#pragma mark - 用户取消订单
+ (void)toCancelOrder:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (seller) {
        type=user.isAssistant?@"2":@"1";
    }
    else{
        type=@"0";
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/cancel?orderId=%@&cancelReason=%@&userType=%@"),mode.orderId,@"",type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:@"取消成功" duration:1.0 position:CSToastPositionCenter];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
   
    
}
#pragma mark - 完成信息
+ (void)toCompleteInfo:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString =CompleteOrderDetailURL(mode.orderId);
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 用户确认订单
+ (void)toConfirmOrder:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    if (![mode.orderCategory isEqualToString:@"marketAuctionOrder"]) {
        JHOrderConfirmViewController  * order=[[JHOrderConfirmViewController alloc]init];
        order.orderId=mode.orderId;
        order.orderCategory = mode.orderCategory;
        [[JHRootController currentViewController].navigationController pushViewController:order animated:YES];

    } else {
        JHAuctionOrderDetailViewController * order=[[JHAuctionOrderDetailViewController alloc]init];
        order.orderId= mode.orderId;
        order.orderCategory = mode.orderCategory;
        [[JHRootController currentViewController].navigationController pushViewController:order animated:YES];
    }
}
#pragma mark - 确认收货
+ (void)toConfirmReceipt:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/order/auth/receipt?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:@"收货完成" duration:1.0 position:CSToastPositionCenter];
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
    
}

#pragma mark - 确认发货
+ (void)toConfirmSend:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    JHSendOutViewController *sendOut = [[JHSendOutViewController alloc] init];
    sendOut.orderId                  = mode.orderId;
    sendOut.directDelivery           = mode.directDelivery;
//    sendOut.orderShowModel           =
    [[JHRootController currentViewController].navigationController pushViewController:sendOut animated:YES];
}

#pragma mark - 修改信息  **干掉了
+ (void)toModifyInfo:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{

    JHWebViewController *webVC = [JHWebViewController new];
   //            webVC.urlString =CompleteOrderDetailURL(mode.orderId);
   //            [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - 打印保卡
+ (void)toPrintCard:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    [[JHPrinterManager sharedInstance] printOrderBarCode:mode.orderId andResult:nil];
    
}
#pragma mark - 转售
+ (void)toStoneResell:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHUnionSignStatus status = [UserInfoRequestManager sharedInstance].unionSignStatus;
    if (status==JHUnionSignStatusComplete || status==JHUnionSignStatusReviewing) {
        [JHRouterManager pushPersonReSellPublishWithSourceOrderId:mode.orderId sourceOrderCode:mode.orderCode flag:1 editSuccessBlock:^{}];
    }
    else
    {
        [JHUnionSignSalePopView showResellSignView].activeBlock = ^(id obj) {
            [JHUnionSignView signMethod];
        };
    }
}
#pragma mark - 申请定制
+ (void)toApplyCustomize:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
   
    [JHRootController EnterLiveRoom:mode.channelLocalId fromString:@"" isStoneDetail:NO isApplyConnectMic:YES];
}
#pragma mark - 退款详情
+ (void)toRefundDetail:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString = ReturnDetailURL(mode.orderId, seller?1:0);
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - 申请退货退款
+ (void)toApplyReturnGoods:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    [SVProgressHUD show];
    NSDictionary * dic = @{@"orderId":mode.orderId};
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/getPartialWorkOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHRefunfOrderModel *model = [JHRefunfOrderModel mj_objectWithKeyValues:respondObject.data];
        if (model.flag) {
            JHTOAST(model.refundTag);
        }else{
            JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
            vc.orderMode=mode;
            vc.orderId=mode.orderId;
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
        vc.orderMode=mode;
        vc.orderId=mode.orderId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }];
    
    

    
}
#pragma mark - 退货到平台
+ (void)toReturnGoods:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
    vc.orderId = mode.orderId;
    vc.refundExpireTime=mode.refundExpireTime;
    vc.directDelivery = mode.directDelivery;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 查看物流
+ (void)toViewExpress:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    if (mode.directDelivery) {
        JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
        vc.orderId              = mode.orderId;
        if ([mode.orderStatus isEqualToString:@"refunding"]) { /// 退货
            vc.type = 7;
        } else {
            vc.type = 6;
        }
        vc.isBusinessZhiSend    = YES;
        vc.isZhifaSeller        = seller;
        if ([mode.orderStatus isEqualToString:@"portalsent"] || [mode.orderStatus isEqualToString:@"待收货"]) {
            vc.isZhifaOrderComplete = NO;
        } else {
            vc.isZhifaOrderComplete = YES;
        }
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:true];
    } else {
        JHExpressViewController * express=[[JHExpressViewController alloc]init];
         express.orderId = mode.orderId;
        [[JHRootController currentViewController].navigationController pushViewController:express animated:YES];

    }
        
    NSString *from = @"直播订单";
    if (mode.orderCategoryType == JHOrderCategoryMallOrder) {
        from = @"商城订单";
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"wlClick" params:@{@"order_id":mode.orderId,@"order_amount":mode.orderPrice,@"store_from":from} type:JHStatisticsTypeSensors];
    
}
#pragma mark - 提醒发货
+ (void)toRemindSend:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    [JHOrderViewModel remindOrderSend:mode.orderId completion:^(RequestModel *respondObject, NSError *error) {
        if ((!error)) {
            [JHKeyWindow makeToast:@"已提醒卖家发货" duration:1 position:CSToastPositionCenter];
        }
        else{
            [JHKeyWindow makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 去支付
+ (void)toGoPay:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JH_WEAK(self)
    [JHOrderViewModel  OrderPayCheckTest2WithOrderId:mode.orderId completion:^(RequestModel * _Nonnull respondObject, NSError * _Nonnull error) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if (!error ) {
            JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
            order.orderId=mode.orderId;
            order.directDelivery = mode.directDelivery;
            [[JHRootController currentViewController].navigationController pushViewController:order animated:YES];
        }
        else{
            if (respondObject.code == 40005) {
                CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
                [[UIApplication sharedApplication].keyWindow addSubview:alert];
            }
            else {
                [JHKeyWindow makeToast:respondObject.message duration:1.0f position:CSToastPositionCenter];
            }
            
            
            //                    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"温馨提示" andDesc:error.localizedDescription cancleBtnTitle:@"我知道了"];
            //                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
        }
    }];
    [SVProgressHUD show];
}
#pragma mark - 确认支付
+ (void)toConfirmPay:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderPayViewController * vc = [[JHOrderPayViewController alloc]init];
    vc.orderId = mode.orderId;
    vc.directDelivery = mode.directDelivery;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 修改地址
+ (void)toAlterAddress:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
    vc.orderId=mode.orderId;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 鉴定问题处理
+ (void)toAppraiseIssue:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHWebViewController *webVC = [JHWebViewController new];
    webVC.urlString =AppraiseIssueDetailURL(mode.orderId);
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
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
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:mode];
            }
            else
            {
                @weakify(self);
                JHContactAlertView *alertView = [[JHContactAlertView alloc] initWithFrame:JHKeyWindow.bounds];
                [JHKeyWindow addSubview:alertView];
                alertView.clickBlock = ^{
                    @strongify(self);
                    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:[JHRootController currentViewController] orderModel:mode];
                };
            }
        }];
    }
}
#pragma mark -添加备注
+ (void)toUpdateRemark:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHOrderNoteView * note=[[JHOrderNoteView alloc]init];
    note.orderMode=mode;
    [JHKeyWindow addSubview:note];
    
}

#pragma mark -评价
+ (void)toComment:(JHCustomizeOrderModel*)mode isSeller:(BOOL)seller{
    
    JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
    vc.orderId = mode.orderId;
    vc.imageUrl = mode.goodsUrl;
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
@end


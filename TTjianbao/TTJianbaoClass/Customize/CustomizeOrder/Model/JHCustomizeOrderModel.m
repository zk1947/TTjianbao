//
//  JHCustomizeOrderModel.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeOrderModel.h"
@implementation JHCustomizeOrderModel
- (void)setCustomizeFeeNames:(NSArray *)customizeFeeNames{
    NSString *feeName = @"";
    for (NSString *str in customizeFeeNames) {
        if (feeName.length > 0) {
            feeName = [feeName stringByAppendingString:[NSString stringWithFormat:@"、%@", str]];
        }else{
            feeName = [feeName stringByAppendingString:str];
        }
    }
    _customizedFeeName = feeName;
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"completions" : @"JHCustomizeOrderCompleteModel",
        @"orderStatusLogVos" : @"JHCustomizeOrderStatusLogVosModel",
        @"payRecordVos" : @"JHCustomizeOrderpayRecordVosModel",
        @"plans": @"JHCustomizeOrderPlanModel",
    };
}
- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{
    
    //非定制单 本地判断按钮显示
    if (self.orderCategoryType != JHOrderCategoryPersonalCustomizeOrder) {
        [self initOrderShowButtonVo];
    }
}
-(void)initOrderShowButtonVo{
    
    JHCustomizeOrderShowButtonVoModel * mode = [JHCustomizeOrderShowButtonVoModel new];
    if (self.isSeller) {
        if (self.orderCategoryType ==JHOrderCategoryResaleOrder||
            self.orderCategoryType ==JHOrderCategoryCustomizedIntentionOrder){
            return ;
        }
        if ([self.orderStatus isEqualToString:@"waitack"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]){
                mode.printCardInfoBtnFlag = YES;
                mode.completeInfoBtnFlag = YES;
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitpay"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]){
                mode.printCardInfoBtnFlag = YES;
                mode.completeInfoBtnFlag = YES;
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitsellersend"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]) {
                mode.confirmSendBtnFlag = YES;
                mode.completeInfoBtnFlag = YES;
                mode.printCardInfoBtnFlag = YES;
                mode.updateRemarkBtnFlag = YES;
            }
        }
        else  if ([self.orderStatus isEqualToString:@"sellersent"]) {
            mode.viewExpressBtnFlag= YES;
            mode.printCardInfoBtnFlag = YES;
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalappraise"]) {
            mode.viewExpressBtnFlag= YES;
            mode.printCardInfoBtnFlag = YES;
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalsend"]) {
            mode.viewExpressBtnFlag= YES;
            mode.printCardInfoBtnFlag = YES;
        }
        else  if ([self.orderStatus isEqualToString:@"portalsent"]) {
            mode.viewExpressBtnFlag= YES;
            mode.printCardInfoBtnFlag = YES;
        }
        else  if ([self.orderStatus isEqualToString:@"buyerreceived"]||
                  [self.orderStatus isEqualToString:@"completion"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]) {
                mode.viewExpressBtnFlag= YES;
            }
            if (self.commentStatus){
                mode.commentStatusShow= YES;
            }
            mode.viewExpressBtnFlag= YES;
        }
        else  if ([self.orderStatus isEqualToString:@"refunding"]) {
            
            mode.refundDetailBtnFlag= YES;
        }
        else  if ([self.orderStatus isEqualToString:@"refunded"]) {
            
            mode.refundDetailBtnFlag= YES;
        }
        
    }
    
    else{
        if ([self.orderStatus isEqualToString:@"waitack"]) {
            mode.userConfirmBtnFlag= YES;
            if (![self.orderCategory isEqualToString:@"mallAuctionOrder"]) {
                mode.cancelOrderBtnFlag= YES;
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitpay"]) {
            mode.goPayBtnFlag= YES;
            if (![self.orderCategory isEqualToString:@"mallAuctionOrder"]) {
                mode.cancelOrderBtnFlag= YES;
            }
//            /// 直发增加修改地址 --- 服务端控制
//            mode.changeCustomerAddressBtnFlag = YES;
        }
        else  if ([self.orderStatus isEqualToString:@"sellersent"]) {
            mode.viewExpressBtnFlag= YES;
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalappraise"]) {
            mode.viewExpressBtnFlag= YES;
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalsend"]) {
            if (self.haveReport) {
                mode.haveReport= YES;
            }
            mode.viewExpressBtnFlag= YES;
        }
        else  if ([self.orderStatus isEqualToString:@"portalsent"]) {
            mode.confirmReceiptBtnFlag= YES;
            mode.viewExpressBtnFlag= YES;
            if (self.haveReport){
                mode.haveReport= YES;
            }
            mode.viewExpressBtnFlag= YES;
        }
        
        else  if ([self.orderStatus isEqualToString:@"buyerreceived"]||
                  [self.orderStatus isEqualToString:@"completion"]) {
            
            mode.viewExpressBtnFlag= YES;
            
            if (self.haveReport){
                mode.haveReport= YES;
            }
            if (self.commentStatus){
                //已评价
                mode.commentStatusShow= YES;
            }
            else{
                if (self.commentStatusShow) {
                    //评价  //
                    mode.commentStatusShow= YES;
                }
            }
            
        }
        else  if ([self.orderStatus isEqualToString:@"refunding"]) {
            //个人转售 退货详情
            if (self.orderCategoryType !=JHOrderCategoryResaleOrder){
                // 退货详情
                mode.refundDetailBtnFlag= YES;
            }
            
            if (self.refundButtonShow ){
                // 退货至平台
                mode.returnGoodsBtnFlag= YES;
            }
        }
        else  if ([self.orderStatus isEqualToString:@"refunded"]) {
            if (self.orderCategoryType !=JHOrderCategoryResaleOrder){
                
                mode.refundDetailBtnFlag= YES;
            }
            
        }
        
        if (self.deleteFlag) {
            
            mode.deleteFlag= YES;
        }
        if (self.changeCustomerAddressShow) {
            
            mode.changeCustomerAddressBtnFlag= YES;
        }
    }
    self.customizeShowBtnVo = mode;
    
}
-(JHCustomizeOrderStatus)customizeOrderStatusType{
    
    if ([self.status isEqualToString:@"waitOrder"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitOrder;
    }
    else if ([self.status isEqualToString:@"waitCharge"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitCharge;
    }
    else if ([self.status isEqualToString:@"waitUserSend"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatReceive;
    }
    else if ([self.status isEqualToString:@"waitPlatReceive"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatReceive;
    }
    else if ([self.status isEqualToString:@"waitPlatAppraise"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatAppraise;
    }
    else if ([self.status isEqualToString:@"waitPlatSendToSeller"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatSendToSeller;
    }
    else if ([self.status isEqualToString:@"waitCustomizerReceive"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitCustomizerReceive;
    }
    else if ([self.status isEqualToString:@"waitCustomizerAck"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitCustomizerAck;
    }
    else if ([self.status isEqualToString:@"customizerPlanning"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusCustomizerPlanning;
    }
    else if ([self.status isEqualToString:@"waitCustomerAckPlan"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitCustomerAckPlan;
    }
    else if ([self.status isEqualToString:@"customizing"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusCustomizing;
    }
    else if ([self.status isEqualToString:@"waitCustomizerSend"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitCustomizerSend;
    }
    else if ([self.status isEqualToString:@"waitPlatReceiveGoods"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatReceiveGoods;
    }
    else if ([self.status isEqualToString:@"waitPlatAppraiseGoods"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusWaitPlatAppraiseGoods;
    }
    else if ([self.status isEqualToString:@"platSent"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusPlatSent;
    }
    else if ([self.status isEqualToString:@"buyerReceived"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusBuyerReceived;
    }
    else if ([self.status isEqualToString:@"cancel"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusCancel;
    }
    else if ([self.status isEqualToString:@"refunded"]) {
        _customizeOrderStatusType = JHCustomizeOrderStatusRefunded;
    }
    //容错处理
    else  {
        _customizeOrderStatusType = -1;
    }
    
    return _customizeOrderStatusType;
    
}

+(NSArray*)getNewOrderListCateArry:(BOOL)isSeller{
    
    NSMutableArray *array = [NSMutableArray array];
    if (isSeller) {
    }
    else{
        JHOrderCateMode * mode1 = [[JHOrderCateMode alloc]init];
        mode1.title = @"全部";
        mode1.status = @"all";
        [array addObject:mode1];
        
        JHOrderCateMode * mode2 = [[JHOrderCateMode alloc]init];
        mode2.title = @"待付款";
        mode2.status = @"waitpay";
        [array addObject:mode2];
        
        JHOrderCateMode * mode3 = [[JHOrderCateMode alloc]init];
        mode3.title = @"待收货";
        mode3.status = @"portalsent";
        [array addObject:mode3];
        
        JHOrderCateMode * mode4 = [[JHOrderCateMode alloc]init];
        mode4.title = @"待评价";
        mode4.status = @"waitEvaluate";
        [array addObject:mode4];
        
        JHOrderCateMode * mode5 = [[JHOrderCateMode alloc]init];
        mode5.title = @"退款退货";
        mode5.status = @"refund";
        [array addObject:mode5];
    }
    return array;
    
}

+(NSArray*)getCustomizeOrderListCateArry:(BOOL)isSeller{
    
    NSMutableArray *array = [NSMutableArray array];
    if (isSeller) {
        JHOrderCateMode * mode1 = [[JHOrderCateMode alloc]init];
        mode1.title = @"全部";
        mode1.status = @"";
        [array addObject:mode1];
        
        JHOrderCateMode * mode2 = [[JHOrderCateMode alloc]init];
        mode2.title = @"待付款";
        mode2.status = @"waitCharge";
        [array addObject:mode2];
        
        JHOrderCateMode * mode3 = [[JHOrderCateMode alloc]init];
        mode3.title = @"待收货";
        mode3.status = @"waitCustomizerReceive";
        [array addObject:mode3];
        
        JHOrderCateMode * mode4 = [[JHOrderCateMode alloc]init];
        mode4.title = @"方案中";
        mode4.status = @"planning";
        [array addObject:mode4];
        
        JHOrderCateMode * mode5 = [[JHOrderCateMode alloc]init];
        mode5.title = @"制作中";
        mode5.status = @"customizing";
        [array addObject:mode5];
        
        JHOrderCateMode * mode6 = [[JHOrderCateMode alloc]init];
        mode6.title = @"待发货";
        mode6.status = @"waitCustomizerSend";
        [array addObject:mode6];
    }
    else{
        JHOrderCateMode * mode1 = [[JHOrderCateMode alloc]init];
        mode1.title = @"全部";
        mode1.status = @"";
        [array addObject:mode1];
        
        JHOrderCateMode * mode2 = [[JHOrderCateMode alloc]init];
        mode2.title = @"待付款";
        mode2.status = @"waitCharge";
        [array addObject:mode2];
        
        JHOrderCateMode * mode3 = [[JHOrderCateMode alloc]init];
        mode3.title = @"进行中";
        mode3.status = @"onGoing";
        [array addObject:mode3];
        
        JHOrderCateMode * mode4 = [[JHOrderCateMode alloc]init];
        mode4.title = @"待收货";
        mode4.status = @"platSent";
        [array addObject:mode4];
        
        JHOrderCateMode * mode5 = [[JHOrderCateMode alloc]init];
        mode5.title = @"已完成";
        mode5.status = @"buyerReceived";
        [array addObject:mode5];
    }
    return array;
    
}
- (NSArray*)customizeButtons{
    
    if (!_customizeButtons) {
        _customizeButtons = [JHCustomizeOrderModel getBottomButtons:self];
    }
    return   _customizeButtons;
}
+(NSMutableArray*)getBottomButtons:(JHCustomizeOrderModel*)customizeOrderModel{
    
    JHCustomizeOrderShowButtonVoModel* mode = customizeOrderModel.customizeShowBtnVo;
    NSMutableArray * buttonArr=[NSMutableArray array];
    
    if (mode.userConfirmBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"去支付";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderStatusConfirmOrder;
        [buttonArr addObject:mode];
    }
    //TODO jiang
    if (mode.goPayBtnFlag){
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"去支付";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonGoPay;
        [buttonArr addObject:mode];
    }

    if (mode.toPayBtnFlag){
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"去支付";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonGoPay;
        [buttonArr addObject:mode];
    }
    
    if (mode.cancelAppraisalBtnFlag){
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"取消鉴定";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonGoPay;
        [buttonArr addObject:mode];
    }
    
    if (mode.seeReportBtnFlag){
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"查看报告";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonGoPay;
        [buttonArr addObject:mode];
    }
    
    if (mode.deleteOrderBtnFlag){
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"删除";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonGoPay;
        [buttonArr addObject:mode];
    }
    
    if (mode.confirmSendBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        
        if (customizeOrderModel.isSeller) {
            mode.title = @"确认发货";
        }
        else{
            mode.title = @"预约上门取件";
        }
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonConfirmSend;
        [buttonArr addObject:mode];
    }
    if (mode.haveReport) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"鉴定报告";
        mode.buttonType = JHCustomizeOrderButtonAppraiseReport;
        [buttonArr addObject:mode];
    }
    //    if (mode.cancelMadeBtnFlag) {
    //        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
    //        mode.title = @"取消定制";
    //        mode.buttonType = JHCustomizeOrderButtonCancelMade;
    //        [buttonArr addObject:mode];
    //    }
    if (mode.cancelOrderBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"取消订单";
        mode.buttonType = JHCustomizeOrderButtonCancelOrder;
        [buttonArr addObject:mode];
    }
    if (mode.completeGoodsBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"制作完成";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonCompleteGoods;
        [buttonArr addObject:mode];
    }
    if (mode.completeInfoBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"完善信息";
        mode.buttonType = JHCustomizeOrderButtonCompleteInfo ;
        [buttonArr addObject:mode];
    }
    if (mode.confirmAcceptOrderBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"确认接单";
        mode.buttonType = JHCustomizeOrderButtonConfirmAccept;
        [buttonArr addObject:mode];
    }
    if (mode.confirmMadeBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"确认定制";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonConfirmMade;
        [buttonArr addObject:mode];
    }
    if (mode.confirmPaymentBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"确认支付";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonConfirmPay;
        [buttonArr addObject:mode];
    }
    if (mode.confirmPlanBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"确认方案";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonConfirmPlan;
        [buttonArr addObject:mode];
    }
    if (mode.confirmReceiptBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"确认收货";
        mode.style = 1;
        mode.buttonType = JHCustomizeOrderButtonConfirmReceipt;
        [buttonArr addObject:mode];
    }
    if (mode.connectMicBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"申请连麦";
        mode.buttonType = JHCustomizeOrderButtonConnectMic;
        [buttonArr addObject:mode];
    }
    if (mode.contactPlatformBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"联系平台";
        mode.buttonType = JHCustomizeOrderButtonContactPlatform;
        [buttonArr addObject:mode];
    }
    if (mode.contactServiceBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"联系客服";
        mode.buttonType = JHCustomizeOrderButtonContactService;
        [buttonArr addObject:mode];
    }
    if (mode.commentStatusShow) {
        if (customizeOrderModel.commentStatus) {
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"已评价";
            mode.buttonType = JHCustomizeOrderButtonHasComment;
            [buttonArr addObject:mode];
        }
        else{
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"评价";
            mode.buttonType = JHCustomizeOrderButtonComment;
            [buttonArr addObject:mode];
        }
        
    }
    if (mode.modifyInfoBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"修改信息";
        mode.buttonType = JHCustomizeOrderButtonModifyInfo;
        [buttonArr addObject:mode];
    }
    if (mode.printCardInfoBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"打印宝卡";
        mode.buttonType = JHCustomizeOrderButtonPrintCard;
        [buttonArr addObject:mode];
    }
    if (mode.refundDetailBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"退货详情";
        mode.buttonType = JHCustomizeOrderButtonRefundDetail;
        [buttonArr addObject:mode];
    }
    if (mode.returnGoodsBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = (customizeOrderModel.directDelivery ? @"退货至商家" : @"退货至平台");
        mode.buttonType = JHCustomizeOrderButtonReturnGoods;
        [buttonArr addObject:mode];
    }
    if (mode.viewExpressBtnFlag) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"查看物流";
        mode.buttonType = JHCustomizeOrderButtonViewExpress;
        [buttonArr addObject:mode];
    }
    
    if (mode.isNewSettle) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"结算";
        mode.buttonType = JHCustomizeOrderButtonNewSettle;
        [buttonArr addObject:mode];
    }
    
    if (mode.deleteFlag) {
        
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"删除";
        mode.buttonType = JHCustomizeOrderButtonDelete;
        [buttonArr addObject:mode];
    }
    
    if (mode.uploadPlanBtnFlag) {
        
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"提交方案";
        mode.buttonType = JHCustomizeOrderButtonUpLoadPlan;
        [buttonArr addObject:mode];
    }
    
    if (mode.changeCustomerAddressBtnFlag&&!customizeOrderModel.isSeller) {
        // 修改地址
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"修改地址";
        mode.buttonType = JHCustomizeOrderButtonAlterAddress;
        [buttonArr addObject:mode];
    }
    
    if (customizeOrderModel.orderCategoryType != JHOrderCategoryPersonalCustomizeOrder) {
        if (mode.updateRemarkBtnFlag&&customizeOrderModel.isSeller) {
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"添加备注";
            mode.buttonType = JHCustomizeOrderButtonUpdateRemark;
            [buttonArr addObject:mode];
        }
        if (customizeOrderModel.couldRefundShow&&!customizeOrderModel.isSeller) {
            //  退货退款
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"退货退款";
              mode.buttonType = JHCustomizeOrderButtonApplyReturnGoods;
            [buttonArr addObject:mode];
        }
        if (customizeOrderModel.problemBtn&&!customizeOrderModel.isSeller) {
            //  鉴定问题处理
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"鉴定问题处理";
              mode.buttonType = JHCustomizeOrderButtonAppraiseIssue;
            [buttonArr addObject:mode];
        }
        if (customizeOrderModel.sendRemindButtonShow&&!customizeOrderModel.isSeller) {
            //  提醒发货
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"提醒发货";
              mode.buttonType = JHCustomizeOrderButtonRemindSend;
            [buttonArr addObject:mode];
        }
        
        if (customizeOrderModel.resaleSupportFlag&&!customizeOrderModel.isSeller) {
            if (customizeOrderModel.resaling) {
                //  转售中
                JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
                mode.title = @"转售中";
                  mode.buttonType = JHCustomizeOrderButtonStoneReselling;
                [buttonArr addObject:mode];
            }
            else{
                //  转售
                JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
                mode.title = @"转售";
                mode.buttonType = JHCustomizeOrderButtonStoneResell;
                [buttonArr addObject:mode];
            }
            
        }
        if (customizeOrderModel.customizedFlag&&!customizeOrderModel.isSeller) {
            //  申请定制
            JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
            mode.title = @"申请定制";
            mode.buttonType = JHCustomizeOrderButtonApplyCustomize;
            [buttonArr addObject:mode];
        }
    }
    
    if (buttonArr.count>buttonLimitCount) {
        JHCustomizeOrderButtonModel *mode = [[JHCustomizeOrderButtonModel alloc]init];
        mode.title = @"更多";
        mode.style = 2;
        mode.buttonType = JHCustomizeOrderButtonMore;
        [buttonArr insertObject:mode atIndex:buttonLimitCount-1];
    }
    
    return buttonArr;
    
}
-(CGFloat)cellHeight{
    return  [self calculateCellheight];
}
- (CGFloat)calculateCellheight
{
    CGFloat height=143;
    if (self.customizeButtons.count>0) {
        height=height+45;
    }
    return height;
}
@end

@implementation JHCustomizeOrderMediaAttachModel

@end

@implementation JHCustomizeOrderStatusLogVosModel

@end

@implementation JHCustomizeOrderMaterialModel

@end

@implementation JHCustomizeOrderpayRecordVosModel

@end

@implementation JHCustomizeOrderPlanModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"customizePlanId" : @"id"};
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"attachmentVOs" : @"JHCustomizeOrderMediaAttachModel"
    };
}
@end

@implementation JHCustomizeOrderPicInfoVoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"attachmentVOS" : @"JHCustomizeOrderMediaAttachModel"
    };
}
@end



@implementation JHCustomizeOrderButtonModel
@end

@implementation JHCustomizeOrderShowButtonVoModel

@end

@implementation JHCustomizeOrderCompleteModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"attachmentList" : @"JHCustomizeOrderMediaAttachModel"
    };
}
@end

@implementation JHCustomizeOrderImageModel

@end



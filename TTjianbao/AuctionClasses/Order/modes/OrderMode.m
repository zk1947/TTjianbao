//
//  OrderMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/26.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "OrderMode.h"
#import "UserInfoRequestManager.h"
#import "JHOrderFactory.h"
#import "JHOrderStatusInterface.h"

@implementation OrderMode

//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{
//        @"myCouponVoList": @"CoponMode",
//        @"mySellerCouponVoList": @"CoponMode",
//
//    };
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"OrderNoteMode" : @"complementVo",
    };
}
//- (NSString *)originOrderPrice {
//    if (_originOrderPrice) {
//        double d            = [_originOrderPrice doubleValue];
//        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
//        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//        _originOrderPrice         = [dn stringValue];
//    }
//    return _originOrderPrice;
//
//}

//- (NSString *)orderPrice {
//    if (_orderPrice) {
//        double d            = [_orderPrice doubleValue];
//        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
//        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
//        _orderPrice         = [dn stringValue];
//    }
//    return _orderPrice;
//}
- (NSString *)orderCategoryString {
    
     UserInfoRequestManager * manager=[UserInfoRequestManager sharedInstance];
     return [manager findValue:manager.dictConfigMode.orderCateType byKey:self.orderCategory];
//    if ([self.orderCategory isEqualToString:@"normal"]) {
//        _orderCategoryString = @"普通订单";
//    }
//    if ([self.orderCategory isEqualToString:@"processingOrder"]) {
//        _orderCategoryString = @"加工订单";
//    }
//    if ([self.orderCategory isEqualToString:@"processingGoods"]) {
//        _orderCategoryString = @"加工服务订单";
//    }
//    if ([self.orderCategory isEqualToString:@"roughOrder"]) {
//        _orderCategoryString = @"原石订单";
//    }
//    if ([self.orderCategory isEqualToString:@"giftOrder"]) {
//        _orderCategoryString = @"福利单";
//    }
//    if ([self.orderCategory isEqualToString:@"daiGouOrder"]) {
//        _orderCategoryString = @"代购订单";
//    }
}
- (JHOrderCategory)orderCategoryType {
    
    return [OrderMode orderCategoryTypeConvert:self.orderCategory];
}
+(JHOrderCategory)orderCategoryTypeConvert:(NSString*)orderCategory{
    
    JHOrderCategory categoryType=JHOrderCategoryNormal;
    if ([orderCategory isEqualToString:@"normal"]) {
        categoryType = JHOrderCategoryNormal;
    }
  else  if ([orderCategory isEqualToString:@"processingOrder"]) {
        categoryType = JHOrderCategoryProcessing;
    }
    else if ([orderCategory isEqualToString:@"processingGoods"]) {
        categoryType = JHOrderCategoryProcessingGoods;
    }
    else if ([orderCategory isEqualToString:@"roughOrder"]) {
        categoryType = JHOrderCategoryRough;
    }
    else if ([orderCategory isEqualToString:@"giftOrder"]) {
        categoryType = JHOrderCategoryGift;
    }
    else if ([orderCategory isEqualToString:@"daiGouOrder"]) {
        categoryType = JHOrderCategoryDaiGou;
    } if ([orderCategory isEqualToString:@"topicOrder"]) {
        categoryType = JHOrderCategoryTopic;
    }
   else  if ([orderCategory isEqualToString:@"limitedTimeOrder"]) {
        categoryType = JHOrderCategoryLimitedTime;
    }
    else if ([orderCategory isEqualToString:@"limitedShopOrder"]) {
        categoryType = JHOrderCategoryLimitedShop;
    }
    else if ([orderCategory isEqualToString:@"restoreOrder"]) {
        categoryType = JHOrderCategoryRestore;
    }
   else  if ([orderCategory isEqualToString:@"restoreIntentionOrder"]) {
        categoryType = JHOrderCategoryRestoreIntention;
    }
    else if ([orderCategory isEqualToString:@"restoreProcessingGoods"]) {
        categoryType = JHOrderCategoryRestoreProcessing;
    }
    else if ([orderCategory isEqualToString:@"resaleOrder"]) {
        categoryType = JHOrderCategoryResaleOrder;
    }
   else  if ([orderCategory isEqualToString:@"resaleIntentionOrder"]) {
        categoryType = JHOrderCategoryResaleIntentionOrder;
    }
    
    else if ([orderCategory isEqualToString:@"customizedOrder"]) {
        categoryType = JHOrderCategoryCustomizedOrder;
    }
    else if ([orderCategory isEqualToString:@"customizedIntentionOrder"]) {
        categoryType = JHOrderCategoryCustomizedIntentionOrder;
    }
    else if ([orderCategory isEqualToString:@"personalCustomizeOrder"]) {
           categoryType = JHOrderCategoryPersonalCustomizeOrder;
    } else if ([orderCategory isEqualToString:@"normalCustomizeGroup"]) {
        categoryType = JHOrderCategoryPersonalCustomizePackageOrder;
    }
    else if ([orderCategory isEqualToString:@"mallOrder"]) {
        categoryType = JHOrderCategoryMallOrder;
    } else if ([orderCategory isEqualToString:@"marketFixedOrder"]) {
        categoryType = JHOrderCategoryMarketsell;
    }else if ([orderCategory isEqualToString:@"marketAuctionOrder"]) {
        categoryType = JHOrderCategoryMarketsell;
    }
    
    return categoryType;
    
}

+(NSString*)orderStatusStrExt:(NSString*)orderStatus
{
    BOOL isBuyer = [[UserInfoRequestManager sharedInstance] commonUser];
    return [self orderStatusExt:orderStatus isBuyer:isBuyer];
}
+(NSString*)orderStatusExt:(NSString*)orderStatus isBuyer:(BOOL)isBuyer {
    
    return [[[OrderMode alloc] init] orderStatusExt:orderStatus isBuyer:isBuyer];
}
- (NSString*)orderStatusExt:(NSString*)orderStatus isBuyer:(BOOL)isBuyer
{
    JHCustomerOrderSide side = isBuyer ? JHCustomerOrderSide_Buyers : JHCustomerOrderSide_Merchants;
    // 获得商家/买家
    id<JHOrderStatusInterface> orderStatusModel = [JHOrderFactory getOrderStatusModel:side];
    // 获得订单状态
    JHVariousStatusOfOrders orderStatusType = [JHOrderFactory getVariousStatusOfOrders:orderStatus];
    // 获得最终文字
    if ([orderStatusModel respondsToSelector:@selector(setBusinessModel:)]) {
        JHBusinessModel bModel = _directDelivery ? JHBusinessModel_SH : JHBusinessModel_De;
        [orderStatusModel setBusinessModel:bModel];
    }
    NSString *statusText = @"";
    if ([orderStatusModel respondsToSelector:@selector(getOrderStatusString:isDirectDelivery:isBuyer:)]) {
        statusText = [orderStatusModel getOrderStatusString:orderStatusType isDirectDelivery:_directDelivery isBuyer:side];
    }
    return statusText;
}

-(NSString*)orderStatusStr{
    _orderStatusStr = [OrderMode orderStatusStrExt:self.orderStatus];
    return _orderStatusStr;
}

-(JHOrderStatus)orderStatusType{
    if ([self.orderStatus isEqualToString:@"waitack"]) {
        _orderStatusType = JHOrderStatusWaitack;
    }
    if ([self.orderStatus isEqualToString:@"waitpay"]) {
        _orderStatusType = JHOrderStatusWaitpay;
    }
    if ([self.orderStatus isEqualToString:@"waitsellersend"]) {
        _orderStatusType = JHOrderStatusWaitsellersend;
    }
    if ([self.orderStatus isEqualToString:@"sellersent"]) {
        _orderStatusType = JHOrderStatusSellersent;
    }
    if ([self.orderStatus isEqualToString:@"waitportalappraise"]) {
        _orderStatusType = JHOrderStatusWaitportalappraise;
    }
    if ([self.orderStatus isEqualToString:@"waitportalsend"]) {
        _orderStatusType = JHOrderStatusWaitportalsend;
    }
    if ([self.orderStatus isEqualToString:@"portalsent"]) {
        _orderStatusType = JHOrderStatusPortalsent;
    }
    if ([self.orderStatus isEqualToString:@"buyerreceived"]) {
        _orderStatusType = JHOrderStatusbuyerreceived;
    }
    if ([self.orderStatus isEqualToString:@"cancel"]) {
        _orderStatusType = JHOrderStatusCancel;
    }
    
    if ([self.orderStatus isEqualToString:@"customizing"]) {
        _orderStatusType = JHOrderStatusCustomize;
    }
    return _orderStatusType;
    
    
}
-(NSString*)orderStatusString{
    
    _orderStatusString = [self orderStatusExt:self.orderStatus isBuyer:!self.isSeller];
    return _orderStatusString;
    
}
- (NSArray*)buttons {
    
   // BOOL isBuyer = [[UserInfoRequestManager sharedInstance] commonUser];
    
      NSMutableArray * buttonArr=[NSMutableArray array];
        if (self.isSeller) {
            //个人转售  定制意向金 ,卖家 不显示功能按钮
        if (self.orderCategoryType ==JHOrderCategoryResaleOrder||
            self.orderCategoryType ==JHOrderCategoryCustomizedIntentionOrder) {
            return buttonArr;
        }
        if ([self.orderCategory isEqualToString:@"mallAuctionDepositOrder"]){
            return buttonArr;
        }
        if ([self.orderStatus isEqualToString:@"waitack"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]){
                [buttonArr addObject:@{@"buttonTitle":@"完善信息",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCompleteInfo]}];
                if (!self.directDelivery) {
                    [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
                }
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitpay"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]){
                [buttonArr addObject:@{@"buttonTitle":@"完善信息",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCompleteInfo]}];
                if (!self.directDelivery) {
                    [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
                }
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitsellersend"]) {
            if (![self.orderCategory isEqualToString:@"processingGoods"]) {
                [buttonArr addObject: @{@"buttonTitle":@"立即发货",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeSend]}];
                [buttonArr addObject:@{@"buttonTitle":@"添加备注",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeAddNote]}];
                [buttonArr addObject:@{@"buttonTitle":@"完善信息",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCompleteInfo]}];
                if (!self.directDelivery) {
                    [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
                }
            }
        }
        
        else  if ([self.orderStatus isEqualToString:@"sellersent"]) {
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            if (!self.directDelivery) {
                [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalappraise"]) {
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            if (!self.directDelivery) {
                [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalsend"]) {
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            if (!self.directDelivery) {
                [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
            }
        }
        else  if ([self.orderStatus isEqualToString:@"portalsent"]) {
            ///@"平台已发货(待收货)";
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            if (!self.directDelivery) {
                [buttonArr addObject:@{@"buttonTitle":@"打印宝卡",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePrintCard]}];
            }
        }
        else  if ([self.orderStatus isEqualToString:@"buyerreceived"]||
                  [self.orderStatus isEqualToString:@"completion"]) {
            ///@"已完成";
            /// 该逻辑不知道有啥用，下面已经有查看物流按钮了
//            if (![self.orderCategory isEqualToString:@"processingGoods"]) {
//                [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
//            }
            if (self.commentStatus){
                [buttonArr addObject:@{@"buttonTitle":@"已评价",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLookComment]}];
            }
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        else  if ([self.orderStatus isEqualToString:@"cancel"]) {
            ///@"订单已取消";
        }
        else  if ([self.orderStatus isEqualToString:@"refunding"]) {
            if (self.directDelivery && self.viewExpressBtnFlag) {
                [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            }
            [buttonArr addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
        }
        else  if ([self.orderStatus isEqualToString:@"refunded"]) {
            if (self.directDelivery && self.viewExpressBtnFlag) {
                [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
            }
            [buttonArr addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
        }
        else  if ([self.orderStatus isEqualToString:@"splited"]) {
            
        }
        else  if ([self.orderStatus isEqualToString:@"sale"]) {
            
        }
    }
    //买家
    else{
        if ([self.orderStatus isEqualToString:@"waitack"]) {
            [buttonArr addObject:@{@"buttonTitle":@"立即支付",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCommit]}];
            [buttonArr addObject:@{@"buttonTitle":@"取消订单",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCancle]}];
        }
        else  if ([self.orderStatus isEqualToString:@"waitpay"]) {
            [buttonArr addObject:@{@"buttonTitle":@"立即支付",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypePay]}];
            if (![self.orderCategory isEqualToString:@"mallAuctionOrder"]) {
                [buttonArr addObject:@{@"buttonTitle":@"取消订单",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeCancle]}];
            }
        }
        else  if ([self.orderStatus isEqualToString:@"waitsellersend"]) {
            
        }
        else  if ([self.orderStatus isEqualToString:@"sellersent"]) {
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalappraise"]) {
             [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        else  if ([self.orderStatus isEqualToString:@"waitportalsend"]) {
            
            if (self.haveReport) {
                [buttonArr addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
            }
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        else  if ([self.orderStatus isEqualToString:@"portalsent"]) {
            
            [buttonArr addObject:@{@"buttonTitle":@"确认收货",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReceive]}];
            if (self.haveReport){
                [buttonArr addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
            }
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        
        else  if ([self.orderStatus isEqualToString:@"buyerreceived"]||
                  [self.orderStatus isEqualToString:@"completion"]) {
            if (self.haveReport){
                [buttonArr addObject:@{@"buttonTitle":@"鉴定详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeDetail]}];
            }
            if (self.commentStatus){
                [buttonArr addObject:@{@"buttonTitle":@"已评价",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLookComment]}];
    
            }
            else{
                if (self.commentStatusShow) {
                    [buttonArr addObject:@{@"buttonTitle":@"评价领红包",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeComment]}];
                }
            }
            [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
        }
        else  if ([self.orderStatus isEqualToString:@"cancel"]) {
            
        }
        else  if ([self.orderStatus isEqualToString:@"refunding"]) {
            //个人转售 退货详情
            if (self.orderCategoryType !=JHOrderCategoryResaleOrder){
                [buttonArr addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
            }
            
            if (self.refundButtonShow ){
                [buttonArr addObject:@{@"buttonTitle":(self.directDelivery?@"退货至商家":@"退货至平台"),@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnGood]}];
            }
//            if (self.directDelivery) {
//                [buttonArr addObject:@{@"buttonTitle":@"查看物流",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeLogistics]}];
//            }
        }
        else  if ([self.orderStatus isEqualToString:@"refunded"]) {
            if (self.orderCategoryType !=JHOrderCategoryResaleOrder){
                [buttonArr addObject:@{@"buttonTitle":@"退货详情",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeReturnDetail]}];
            }
            
        }
        else  if ([self.orderStatus isEqualToString:@"splited"]) {
            
        }
        else  if ([self.orderStatus isEqualToString:@"sale"]) {
            
        }
        if (self.changeCustomerAddressShow) {
            [buttonArr addObject:@{@"buttonTitle":@"修改地址",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeAlterAddress]}];
        }
        if (self.couldRefundShow) {
            [buttonArr addObject:@{@"buttonTitle":@"退货退款",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeApplyReturn]}];
        }
        if (self.problemBtn) {
            [buttonArr addObject:@{@"buttonTitle":@"鉴定问题处理",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTypeAppraiseIssue]}];
        }
        if (self.sendRemindButtonShow) {
                   [buttonArr addObject:@{@"buttonTitle":@"提醒发货",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTyperRemindSend]}];
               }
        
        if (self.resaleSupportFlag) {
            if (self.resaling) {
                [buttonArr addObject:@{@"buttonTitle":@"转售中",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTyperStoneReselling]}];
                
            }
            else{
                [buttonArr addObject:@{@"buttonTitle":@"转售",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTyperStoneResell]}];
            }
            
        }
        if (self.deleteFlag) {
            [buttonArr addObject:@{@"buttonTitle":@"删除",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTyperDelete]}];
        }
        if (self.customizedFlag) {
            [buttonArr addObject:@{@"buttonTitle":@"申请定制",@"buttonTag":[NSNumber numberWithInt:JHOrderButtonTyperApplyCustomize]}];
        }
        
        
    }
    
    return buttonArr;
}
-(CGFloat)height{
    return  [self calculateCellheigh];
}
- (CGFloat)calculateCellheigh
{
    CGFloat height=250;
    if ([self.orderCategory isEqualToString:@"processingGoods"]) {
        height=height+70;
    }
    //有备注
    if(self.isSeller){
        if (self.complementVo.pics.count>0||self.complementVo.remark.length>0 ){
            if (self.complementVo.pics.count>0 ) {
                height=height+70;
            }
            NSString *title= [NSString stringWithFormat:@"备注 %@",self.complementVo.remark];
            if ([title length]>0) {
                NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:14]};
                CGFloat titleH = [title boundingRectWithSize:CGSizeMake((ScreenW-25), 25 * 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size.height;
                height=height+titleH+20;
            }
        }
    }
    if (self.buttons.count==0) {
        height=height-62;
    }
    
     return height;
}
@end

@implementation OrderNoteMode

@end

@implementation OrderPhotoMode

@end

@implementation OrderSearchParamMode

@end


@implementation OrderAgentPayShareMode

@end

@implementation OrderFriendAgentPayMode

@end

@implementation OrderParentModel


@end



@implementation JHCustomizePackageCustomizeOrder
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
    };
}
@end

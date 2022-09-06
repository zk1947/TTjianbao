//
//  JHPurchaseStoneModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseStoneModel.h"
#import "OrderMode.h"

@implementation JHPurchaseStoneListAttachmentModel

@end

@implementation JHPurchaseStoneListModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
       @"children" : [JHPurchaseStoneListModel class],
       @"attachmentList" : [JHPurchaseStoneListAttachmentModel class]
    };
}

- (NSString*)salePrice
{
    if (_salePrice) {
        double d = [_salePrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _salePrice = [dn stringValue];
    }
    return _salePrice;
}

@end

@implementation JHPurchaseStoneListReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageIndex = 0;
        self.pageSize = 10; //初始化默认值
    }
    
    return self;
}

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-order";
}

@end

@implementation JHStoneOrderListModel

@end

@implementation JHStoneOrderListReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-channel-order";
}

@end

@implementation JHSendOrderListModel

@end

@implementation JHSendOrderListReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-send-order";
}

@end

@implementation JHPurchaseStoneModel

- (void)requestWithType:(JHStonePageType)pageType pageIndex:(NSUInteger)pageIndex
{
    JHPurchaseStoneListReqModel* model;
    if(pageType == JHStonePageTypeStoneOrder)
        model = [JHStoneOrderListReqModel new];
    else if(pageType == JHStonePageTypeSendOrder)
        model = [JHSendOrderListReqModel new];
    else //if(pageType == JHStonePageTypePurchase)
        model = [JHPurchaseStoneListReqModel new];
    
    model.pageIndex = pageIndex;
    JH_WEAK(self)
    [JH_REQUEST asynPost:model success:^(id respData) {
        JH_STRONG(self)
        
        NSArray* dataArray;
        if(pageType == JHStonePageTypeStoneOrder)
            dataArray = [JHStoneOrderListModel convertData:respData];
        else if(pageType == JHStonePageTypeSendOrder)
            dataArray = [JHSendOrderListModel convertData:respData];
        else //if(pageType == JHStonePageTypePurchase)
            dataArray = [JHPurchaseStoneListModel convertData:respData];
        //调试数据,可以不注释掉,开关在调试器内部
        [JHDebuger dataArrayOfPurchaseStone:&dataArray];
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:dataArray error:[JHRespModel nullMessage]];
        }
    } failure:^(NSString *errorMsg) {
        JH_STRONG(self)
        if([self.delegate respondsToSelector:@selector(responseData:error:)])
        {
            [self.delegate responseData:[NSMutableArray array] error:errorMsg];
        }
    }];
}

#pragma mark - 类型转换
+ (NSString*)typeFromOrderStatus:(NSString*)status
{
   /* cancel 取消订单, buyerreceived 买家确认收货, portalsent 平台已发货（买家待收货）, waitportalsend 平台已鉴定（待发货） , waitportalappraise待鉴定（平台已收货） , sellersent卖家已发货（待平台收货）,waitsellersend 待卖家发货给平台（已支付）, paying 用户支付中（分次支付） , waitpay 待用户支付，waitack 待用户确认,refunding 退货退款中 refunded 退货完成，completion 订单完成，onsale 待寄售，sale 寄售*/
    return [OrderMode orderStatusStrExt:status];
}

+ (NSString*)typeFromTransitionState:(NSString*)state
{
    NSArray* typeArr = @[@"", @"寄回", @"寄售", @"加工", @"已拆单"];
    int idx = [state intValue];
    if(idx >= 0 && idx < [typeArr count])
        return typeArr[idx];
    return typeArr[0];
}
//拆单方式
+ (NSString*)typeFromSplitState:(NSString*)state
{
    NSArray* typeArr = @[@"", @"寄回", @"寄售", @"加工"];
    int idx = [state intValue];
    if(idx >= 0 && idx < [typeArr count])
        return typeArr[idx];
    return typeArr[0];
}

+ (JHPurchaseType)PurchaseTypeFromState:(NSString*)transitionState
{
    //@[@"", @"寄回", @"寄售", @"加工", @"已拆单"];
    int idx = [transitionState intValue];
    if(idx == 4)
        return JHPurchaseTypeSplit;
    else if(idx == 1 || idx == 2)
        return JHPurchaseTypeCut;
    else
        return JHPurchaseTypeDefault;
}

@end

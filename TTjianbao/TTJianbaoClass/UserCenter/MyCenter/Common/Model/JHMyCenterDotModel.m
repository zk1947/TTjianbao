//
//  JHMyCenterDotModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterDotModel.h"

@implementation JHMyCenterDotModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{ @"customRedPointAllCount": @"allCount",
             @"customRedPointWaitPayCount":@"waitCustomerPay",
             @"customRedPointInProcessCount":@"goingCustomerCount",
             @"customRedPointWaitReceiveCount":@"waitCustomerReceive",
             @"CustomRedPointFinishCount":@"completionCount",
             @"customNumPointwaitCustomizerReceive":@"waitCustomizerReceive",
             @"customNumPointcustomizing":@"customizing",
             @"customNumPointcustomizerPlaning":@"customizerPlaning",
             @"CustomNumPointweitSendCount":@"weitSendCount",
             };
}

+ (void)requestDataWithType:(NSNumber *)type block:(dispatch_block_t)block {
    [JHMyCenterDotModel requestDataWithType:type contentType:0 block:block];
}

+ (void)requestDataWithType:(NSNumber *)type contentType:(NSInteger)bussId block:(dispatch_block_t)block{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-restore/list-personal-center-info") Parameters:@{@"customerType" : type, @"bussId" : @(bussId).stringValue} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHMyCenterDotModel *model = [JHMyCenterDotModel mj_objectWithKeyValues:respondObject.data];
        
        [JHMyCenterDotModel shareInstance].shelveCount = model.shelveCount;
        [JHMyCenterDotModel shareInstance].waitPayCount = model.waitPayCount;
        [JHMyCenterDotModel shareInstance].buyerWaitPayCount = model.buyerWaitPayCount;
        [JHMyCenterDotModel shareInstance].waitSendCount = model.waitSendCount;
        [JHMyCenterDotModel shareInstance].serviceAfterRefundCount = model.serviceAfterRefundCount;
        [JHMyCenterDotModel shareInstance].waitAppraisalCount = model.waitAppraisalCount;
        [JHMyCenterDotModel shareInstance].waitReceivedCount = model.waitReceivedCount;
        [JHMyCenterDotModel shareInstance].waitEvaluateCount = model.waitEvaluateCount;
        [JHMyCenterDotModel shareInstance].myOfferCount = model.myOfferCount;
        [JHMyCenterDotModel shareInstance].offerCount = model.offerCount;
        ///回收相关的红点数
        ///回收池
        [JHMyCenterDotModel shareInstance].recyclePoolCount = model.recyclePoolCount;
        [JHMyCenterDotModel shareInstance].recycleRedPointWillPayCount = [model.recycleOrderCount[@"waitPay"] integerValue];
        [JHMyCenterDotModel shareInstance].recycleRedPointWillSendCount = [model.recycleOrderCount[@"waitSend"] integerValue];
        [JHMyCenterDotModel shareInstance].recycleRedPointDidSendCount = [model.recycleOrderCount[@"waitReceive"] integerValue];
        [JHMyCenterDotModel shareInstance].recycleRedPointWillConfirmPrice = [model.recycleOrderCount[@"waitConfirmPrice"] integerValue];
        [JHMyCenterDotModel shareInstance].recycleMyPublishCount = model.recycleMyPublishCount;
        [JHMyCenterDotModel shareInstance].recycleMySoldCount = model.recycleMySoldCount;
        [JHMyCenterDotModel shareInstance].imageTextAppraiserSwitch = model.imageTextAppraiserSwitch;
        [JHMyCenterDotModel shareInstance].waitAppraisalNum = model.waitAppraisalNum;
        [JHMyCenterDotModel shareInstance].fundWaitManageCount = model.fundWaitManageCount;

        if(block){
            block();
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if(block){
            block();
        }
    }];
}
+ (void)requestCustomizeDataWithType:(NSNumber *)type block:(dispatch_block_t)block{
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/noticeCount") Parameters:@{@"type":type} successBlock:^(RequestModel * _Nullable respondObject) {
        JHMyCenterDotModel *model = [JHMyCenterDotModel mj_objectWithKeyValues:respondObject.data];
        [JHMyCenterDotModel shareInstance].customRedPointAllCount = model.customRedPointAllCount;
        [JHMyCenterDotModel shareInstance].customRedPointWaitPayCount = model.customRedPointWaitPayCount;
        [JHMyCenterDotModel shareInstance].customRedPointInProcessCount = model.customRedPointInProcessCount;
        [JHMyCenterDotModel shareInstance].customRedPointWaitReceiveCount = model.customRedPointWaitReceiveCount;
        [JHMyCenterDotModel shareInstance].CustomRedPointFinishCount = model.CustomRedPointFinishCount;
        [JHMyCenterDotModel shareInstance].customNumPointwaitCustomizerReceive = model.customNumPointwaitCustomizerReceive;
        [JHMyCenterDotModel shareInstance].customNumPointcustomizing = model.customNumPointcustomizing;
        [JHMyCenterDotModel shareInstance].customNumPointcustomizerPlaning = model.customNumPointcustomizerPlaning;
        [JHMyCenterDotModel shareInstance].CustomNumPointweitSendCount = model.CustomNumPointweitSendCount;
        
        if(block){
            block();
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if(block){
            block();
        }
    }];
}

+ (void)changeOrderMessageCount:(NSDictionary *)sender{
    if(IS_DICTIONARY(sender)){
        if(IS_DICTIONARY(sender[@"body"]))
        {
            JHMyCenterOrderDotModel *msgCountModel = [JHMyCenterOrderDotModel mj_objectWithKeyValues:sender[@"body"]];
            [JHMyCenterDotModel shareInstance].waitPayCount += msgCountModel.sellerWaitCustomerPay;
            [JHMyCenterDotModel shareInstance].waitSendCount += msgCountModel.sellerWaitSent;
            [JHMyCenterDotModel shareInstance].serviceAfterRefundCount += msgCountModel.sellerRefunding;
            
            [JHMyCenterDotModel shareInstance].buyerWaitPayCount += msgCountModel.customerWaitPay;
            [JHMyCenterDotModel shareInstance].waitAppraisalCount += msgCountModel.customerWaitAppraise;
            [JHMyCenterDotModel shareInstance].waitReceivedCount += msgCountModel.customerWaitReceive;
            [JHMyCenterDotModel shareInstance].waitEvaluateCount += msgCountModel.customerWaitEval;
            
            ///380 回收相关的红点
            [JHMyCenterDotModel shareInstance].recycleRedPointWillPayCount += msgCountModel.sellerWaitCustomerPay;
            [JHMyCenterDotModel shareInstance].recycleRedPointWillSendCount += msgCountModel.sellerWaitSent;
            [JHMyCenterDotModel shareInstance].recycleRedPointDidSendCount += msgCountModel.customerWaitReceive;
            [JHMyCenterDotModel shareInstance].recycleRedPointWillConfirmPrice += msgCountModel.customerWaitEval;

            
            if ([JHMyCenterDotModel shareInstance].block) {
                [JHMyCenterDotModel shareInstance].block();
            }
        }
    }
}

/// 直播间出价 IM
+ (void)changeBidMessageCount:(NSDictionary *)sender type:(NTESLiveCustomNotificationType)type{
    if(IS_DICTIONARY(sender)){
        if(IS_DICTIONARY(sender[@"body"]))
        {
            JHMyCenterDotModel *model = [JHMyCenterDotModel mj_objectWithKeyValues:sender[@"body"]];
            if(type == JHSystemMsgTypeStoneHaveNewPrice){
                [JHMyCenterDotModel shareInstance].offerCount = model.offerCount;
                if([JHMyCenterDotModel shareInstance].block){
                    [JHMyCenterDotModel shareInstance].block();
                }
            }else if(type == JHSystemMsgTypeStoneOrderMyBidCount){
                [JHMyCenterDotModel shareInstance].myOfferCount = model.offerCount;
                if([JHMyCenterDotModel shareInstance].block){
                    [JHMyCenterDotModel shareInstance].block();
                }
            }
        }
    }
}

+ (void)shopDataRequest:(NSString *)sellerCustomerId
           businessType:(NSString *)businessType
         statisticsDays:(NSString *)statisticsDays
         statisticsType:(NSString *)statisticsType
                  block:(dispatch_block_t)block {
    NSDictionary *dict = @{
        @"sellerCustomerId" : @([sellerCustomerId integerValue]),
        @"businessType" : @([businessType integerValue]),
        @"statisticsDays" : @([statisticsDays integerValue]),
        @"statisticsType" : @([statisticsType integerValue])
    };
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/datacenter/orderStatisticsAll/auth/homePageYesterday") Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHMyCenterShopDataModel *model = [JHMyCenterShopDataModel mj_objectWithKeyValues:respondObject.data];
        if ([businessType isEqualToString:@"1"]) {
            /// 直播间的
            [JHMyCenterDotModel shareInstance].liveAllDeal = model.allDeal;
            [JHMyCenterDotModel shareInstance].liveAllDealStr = model.allDealStr;
            [JHMyCenterDotModel shareInstance].liveMonthAllDeal = model.monthAllDeal;
            [JHMyCenterDotModel shareInstance].liveComparedYesterdayRate = model.comparedYesterdayRate;
        } else if ([businessType isEqualToString:@"2"]) {
            /// 商城的
            [JHMyCenterDotModel shareInstance].shopAllDeal = model.allDeal;
            [JHMyCenterDotModel shareInstance].shopAllDealStr = model.allDealStr;
            [JHMyCenterDotModel shareInstance].shopMonthAllDeal = model.monthAllDeal;
            [JHMyCenterDotModel shareInstance].shopComparedYesterdayRate = model.comparedYesterdayRate;
        }
        if (block) {
            block();
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block();
        }
    }];
}

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static JHMyCenterDotModel *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JHMyCenterDotModel new];
    });
    if(![JHRootController isLogin]){
        instance.shelveCount = 0;
        instance.waitPayCount = 0;
        instance.buyerWaitPayCount = 0;
        instance.waitAppraisalCount = 0;
        instance.waitReceivedCount = 0;
        instance.waitEvaluateCount = 0;
        instance.waitSendCount = 0;
        instance.serviceAfterRefundCount = 0;
        instance.myOfferCount = 0;
        instance.offerCount = 0;
    }
    return instance;
}

@end


@implementation JHMyCenterOrderDotModel

@end


@implementation JHMyCenterShopDataModel

@end

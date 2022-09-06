//
//  JHNimNotificationManager.m
//  TTjianbao
//
//  Created by jiang on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHNimNotificationManager.h"
#import "NIMSDK/NIMSDK.h"
#import "YYKit.h"
#import "NSString+NTES.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveViewDefine.h"
#import "JHNimNotificationModel.h"
#import "JHStonePopViewHeader.h"

@interface JHNimNotificationManager () <NIMSystemNotificationManagerDelegate>
@end
@implementation JHNimNotificationManager
+ (instancetype)sharedManager {
    static JHNimNotificationManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[JHNimNotificationManager alloc] init];
    });
    return _sharedManager;
}
- (instancetype)init {
    if (self = [super init]) {
        NSLog(@"JHNIMNotificationManager - 开始监听任务通知");
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }
    return self;
}
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification{
    NSDictionary *jsonDic = [notification.content jsonValueDecoded];
    NSLog(@"onReceiveCustomSystemNotification === %@",jsonDic);
    
    JHNimNotificationModel *model = [JHNimNotificationModel modelWithJSON:jsonDic];
    
    if(IS_DICTIONARY(jsonDic)){
        NTESLiveCustomNotificationType type = [[jsonDic objectForKey:@"type"]  integerValue];
        if(type == JHSystemMsgTypeShopOrderMessageCount){
            /// 个人中心的 订单系列
            [JHMyCenterDotModel changeOrderMessageCount:jsonDic];
        }
        else if(type == JHSystemMsgTypeStoneOrderMyBidCount || type == JHSystemMsgTypeStoneHaveNewPrice){
            /// 个人中心的  我的出价
            [JHMyCenterDotModel changeBidMessageCount:jsonDic type:type];
        }
        else if (type == JHSystemMsgTypeMyCenterWaitShelveCount){
            /// 个人中心的待上架
            [JHMyCenterDotModel shareInstance].shelveCount = model.body.shelveCount;
            if([JHMyCenterDotModel shareInstance].block){
                [JHMyCenterDotModel shareInstance].block();
            }
        }
        else if(type == FlashSalesMsg || type == FlashDownMsg || type == FlashSalesSellOutMsg){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatShanGouInfoNotice" object:jsonDic];
            });
        }
    }
    
    [self handleNotificationModel:model];
    
    
    
    
}
-(void)handleNotificationModel:(JHNimNotificationModel*)model{
    if (model.type==NTESLiveCustomNotificationTypeAudiencedAppraisalCountChange){
        [self handleMicMessage:model];}
    else if (model.type==NTESLiveCustomNotificationTypeAnchourDestroyQueue||
             model.type==NTESLiveCustomNotificationTypeAudiencedRemoveQueue||
             model.type==JHSystemMsgTypeResaleStoneSignUpTips ||
             model.type==JHSystemMsgTypeStoneExplainMsg){
             [self sendRoomNotification:model];
    }
   else if (model.type==NTESLiveCustomNotificationTypeAudiencedCustomizeCountChange){
           [self handleCustomizeMessage:model];
       }
    else if (model.type==NTESLiveCustomNotificationTypeCustomizeAudiencedRemoveQueue||
        model.type==NTESLiveCustomNotificationTypeCustomizeAnchourDestroyQueue){
             [self sendRoomNotification:model];
    }
    
    else if (model.type==NTESLiveCustomNotificationTypeAudiencedRecycleCountChange){
            [self handleRecycleMessage:model];
        }
     else if (model.type==NTESLiveCustomNotificationTypeRecycleAudiencedRemoveQueue||
         model.type==NTESLiveCustomNotificationTypeRecycleAnchourDestroyQueue){
              [self sendRoomNotification:model];
     }
    
    else{
        [self handleStoneMessage:model];}
}
-(void)handleMicMessage:(JHNimNotificationModel*)model{
    JHMicWaitMode  * waitMode = [JHNimNotificationManager sharedManager].micWaitMode;
    waitMode.singleWaitSecond= [model.body.singleWaitSecond intValue];
    waitMode.waitCount--;
    [self sendRoomNotification:model];
}
-(void)handleCustomizeMessage:(JHNimNotificationModel*)model{
    JHMicWaitMode  * waitMode = [JHNimNotificationManager sharedManager].customizeWaitMode;
    waitMode.singleWaitSecond= [model.body.singleWaitSecond intValue];
    waitMode.waitCount--;
    [self sendRoomNotification:model];
}
-(void)handleRecycleMessage:(JHNimNotificationModel*)model{
    JHMicWaitMode  * waitMode = [JHNimNotificationManager sharedManager].recycleWaitMode;
    waitMode.singleWaitSecond= [model.body.singleWaitSecond intValue];
    waitMode.waitCount--;
    [self sendRoomNotification:model];
}
-(void)handleStoneMessage:(JHNimNotificationModel*)model{
    CGRect rect = [UIScreen mainScreen].bounds;
    switch (model.type) {
            
        case JHSystemMsgTypeStoneHaveNewPrice:
        case JHSystemMsgTypeStoneInSaleCount:
        case JHSystemMsgTypeStoneUserActionCount:
        case JHSystemMsgTypeStoneWaitShelveCount:
        case JHSystemMsgTypeStoneConfirmResaleAlert:
        case JHSystemMsgTypeStoneBuyerConfirmBreakAlert:
        case JHSystemMsgTypeStoneConfirmEditPrice:
        case JHSystemMsgTypeStoneOrderCount:

            [self sendRoomNotification:model];
            
            break;
            
        case JHSystemMsgTypeStoneUserBuyAlert: {
            JHBePushStoneSaledView *view = [[JHBePushStoneSaledView alloc] initWithFrame:rect];
            [view showAlert];
            view.model = model.body;
            [view anchorRecvSaled];
            
            
        }
            break;
            
        case JHSystemMsgTypeStoneUserHavePriceAlert:{
            JHBePushPriceView *view = [[JHBePushPriceView alloc] initWithFrame:rect];
            view.isAgree = NO;
            view.model = model.body;
            [view showAlert];
        }
            break;
            
        case JHSystemMsgTypeStoneAcceptPriceAlert:{
            JHBePushPriceView *view = [[JHBePushPriceView alloc] initWithFrame:rect];
            view.isAgree = YES;
            view.model = model.body;
            [view showAlert];
        }
            
            break;
        case JHSystemMsgTypeStoneRejectPriceAlert:{
            JHBePushStoneSaledView *view = [[JHBePushStoneSaledView alloc] initWithFrame:rect];
            [view showAlert];
            view.model = model.body;
            [view sellerRejectPrice];
        }
            
            break;
            
        case JHSystemMsgTypeStoneStoneSaledAlert:{
            JHBePushStoneSaledView *view = [[JHBePushStoneSaledView alloc] initWithFrame:rect];
            [view showAlert];
            view.model = model.body;
            [view sellerRecvSaled];
        }
            
            break;
            
        default:
            break;
    }
    


}
-(void)sendRoomNotification:(JHNimNotificationModel*)model{
    [[NSNotificationCenter defaultCenter] postNotificationName:JHNIMNotifaction object:model];//
}

-(JHMicWaitMode*)micWaitMode{
    
    if (!_micWaitMode) {
        _micWaitMode=[[JHMicWaitMode alloc]init];
    }
    return _micWaitMode;
}
-(JHMicWaitMode*)customizeWaitMode{
    
    if (!_customizeWaitMode) {
        _customizeWaitMode=[[JHMicWaitMode alloc]init];
    }
    return _customizeWaitMode;
}
-(JHMicWaitMode*)recycleWaitMode{
    
    if (!_recycleWaitMode) {
        _recycleWaitMode=[[JHMicWaitMode alloc]init];
    }
    return _recycleWaitMode;
}
@end


//
//  NTESAttachDecoder.m
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESAttachDecoder.h"
#import "NSDictionary+NTESJson.h"
#import "NTESCustomKeyDefine.h"
#import "NTESPresentAttachment.h"
#import "NTESLikeAttachment.h"
#import "NTESMicAttachment.h"
#import "JHSystemMsgAttachment.h"
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
#import "JHChatCouponInfoModel.h"
#import "JHChatCustomTipModel.h"
#import "JHChatCustomDateModel.h"
#import "JHStoneMessageModel.h"
#import "ChannelMode.h"

@implementation NTESAttachDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment = nil;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:@"type"];
            NSDictionary *data = [dict jsonDict:@"body"];
            NSLog(@"decode %@",dict);
            
            if(type == JHSystemMsgTypeShopwindowAddGoods || type == JHSystemMsgTypeShopwindowRefreash || type == JHSystemMsgTypeShopwindowCount || type == JHSystemMsgTypeShopwindowAudienceCount)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"shopwindowNotificationMessage" object:dict];
            }
                
            if ([JHSystemMsgAttachment mj_objectWithKeyValues:data]) {
                attachment = [JHSystemMsgAttachment mj_objectWithKeyValues:data];
            }else {
                attachment = [[JHSystemMsgAttachment alloc] init];
            }
            ((JHSystemMsgAttachment *)attachment).type = type;
            ((JHSystemMsgAttachment *)attachment).data = [dict mj_JSONString];
            if (type <= JHSystemMsgTypeSwitchAppraise || type == JHSystemMsgTypeNotification|| type == JHSystemMsgTypeOrderNotification || type == JHSystemMsgTypeRoomNotification  || type == JHSystemMsgTypeForbidLive|| type == JHSystemMsgTypeWarning) {
                ((JHSystemMsgAttachment *)attachment).avatar = [data jsonString:@"icon"];
                ((JHSystemMsgAttachment *)attachment).nick = [data jsonString:@"name"];
                ((JHSystemMsgAttachment *)attachment).second = [data jsonInteger:@"second"];
                ((JHSystemMsgAttachment *)attachment).content = [data jsonString:@"content"];
                ((JHSystemMsgAttachment *)attachment).chartlet = [data jsonString:@"chartlet"];
                ((JHSystemMsgAttachment *)attachment).showStyle = [data jsonInteger:@"showStyle"];

                ((JHSystemMsgAttachment *)attachment).yesOrNo = [data jsonInteger:@"yesOrNo"];

                
                ((JHSystemMsgAttachment *)attachment).type = type;
                
                ((JHSystemMsgAttachment *)attachment).giftInfo = data[@"giftInfo"];
                ((JHSystemMsgAttachment *)attachment).sender = data[@"sender"];
                ((JHSystemMsgAttachment *)attachment).receiver = data[@"receiver"];
                
                ((JHSystemMsgAttachment *)attachment).customerId = [NSString stringWithFormat:@"%@",data[@"id"]];
                ((JHSystemMsgAttachment *)attachment).accid = data[@"accid"];


                if (type<=JHSystemMsgTypeEndAppraisal) {
                    ((JHSystemMsgAttachment *)attachment).showStyle = 2;

                }

                return attachment;

            }else if (type == JHSystemMsgTypeStoneStartLive || type == JHSystemMsgTypeStoneEndLive) {
                attachment = [JHCustomChannelMessageModel mj_objectWithKeyValues:dict];
                return attachment;
               
            }else if (type <= JHSystemMsgTypeStoneRefreshList && type >= JHSystemMsgTypeStoneStartLive){
                attachment = [JHCustomAlertMessageModel mj_objectWithKeyValues:data];
                                                            
                return attachment;
            } else if (type <= JHSystemMsgTypeRedPacketShowNew && type >= JHSystemMsgTypeRedPacketRemove){
                attachment = [JHRedPacketMessageModel mj_objectWithKeyValues:dict];
                return attachment;
            }

            
            switch (type) {
                case JHSystemMsgTypePresent:
                {
                    attachment = [[NTESPresentAttachment alloc] init];
                    ((NTESPresentAttachment *)attachment).giftInfo = data[@"giftInfo"];
                    ((NTESPresentAttachment *)attachment).sender = data[@"sender"];
                    ((NTESPresentAttachment *)attachment).receiver = data[@"receiver"];

                }
                    break;
                case NTESCustomAttachTypeLike:
                {
                    attachment = [[NTESLikeAttachment alloc] init];
                }
                    break;
                case NTESCustomAttachTypeConnectedMic:
                {
                    attachment = [[NTESMicConnectedAttachment alloc] init];
                    ((NTESMicConnectedAttachment *)attachment).connectorId = [data jsonString:NTESCMConnectMicUid];
                    ((NTESMicConnectedAttachment *)attachment).type = [data jsonInteger:NTESCMCallStyle];
                    ((NTESMicConnectedAttachment *)attachment).nick = [data jsonString:NTESCMConnectMicNick];
                    ((NTESMicConnectedAttachment *)attachment).avatar = [data jsonString:NTESCMConnectMicAvatar];
                }
                    break;
                case NTESCustomAttachTypeDisconnectedMic:
                {
                    attachment = [[NTESDisConnectedAttachment alloc] init];
                    ((NTESDisConnectedAttachment *)attachment).connectorId = [data jsonString:NTESCMConnectMicUid];
                }
                    break;

                default:
                    break;
            }
            
            /// IM 1v1 聊天
            switch (type) {
                case JHChatCustomTypeGoods:
                    attachment = [JHChatCustomGoodsModel mj_objectWithKeyValues: dict];
                    break;
                case JHChatCustomTypeOrder:
                    attachment = [JHChatCustomOrderModel mj_objectWithKeyValues: dict];
                    break;
                case JHChatCustomTypeCoupon:
                    attachment = [JHChatCustomCouponModel mj_objectWithKeyValues: dict];
                    break;
                case JHChatCustomTypeDate:
                    attachment = [JHChatCustomDateModel mj_objectWithKeyValues: dict];
                    break;
                case JHChatCustomTypeTip:
                    attachment = [JHChatCustomTipModel mj_objectWithKeyValues:dict];
                    break;
                default:
                    break;
            }
            
            if(type == FlashSalesMsg || type == FlashDownMsg || type == FlashSalesSellOutMsg)
            {
                attachment = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatShanGouInfoNotice" object:dict];
            }
            
        }
    }
    return attachment;
}



@end

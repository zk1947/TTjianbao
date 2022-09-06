//
//  NTESMicConnector.m
//  TTjianbao
//
//  Created by chris on 16/7/22.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMicConnector.h"
#import "NSString+NTES.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveManager.h"

@implementation NTESMicConnector

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.uid  = [dict objectForKey:@"accid"];
         self.Id   = [dict objectForKey:@"id"];
         self.nick   = [dict objectForKey:@"name"];
        self.avatar = [dict objectForKey:@"icon"];
        self.imgList   = [dict objectForKey:@"picUrls"];
        self.bought   = [[dict objectForKey:@"bought"] boolValue];
        self.isBiggerThen   = [[dict objectForKey:@"isBiggerThen"] boolValue];
        self.appraiseRecordId =  [dict objectForKey:@"appraiseId"];
        self.customizeRecordId =  [dict objectForKey:@"customizeId"];
        self.applyId =  [dict objectForKey:@"applyId"];
        self.state  = NTESLiveMicStateWaiting;
        self.type   = NIMNetCallMediaTypeVideo;
        
        id orderId = [dict objectForKey:@"orderId"];
        if([orderId isKindOfClass:[NSString class]]){
            self.orderId = orderId;
        }else{
            if(orderId){
                self.orderId = [NSString stringWithFormat:@"%@",orderId];
            }
        }
        
         self.orderCode =  [dict objectForKey:@"orderCode"];
         self.goodsTitle =  [dict objectForKey:@"goodsTitle"];
         self.goodsUrl =  [dict objectForKey:@"goodsUrl"];
         self.statusDesc =  [dict objectForKey:@"statusDesc"];
        if ([ [dict objectForKey:@"status"] isEqualToString:@"in"]) {
            self.onlineState  = NTESLiveMicOnlineStateEnterRoom;
        }
        else if ([ [dict objectForKey:@"status"] isEqualToString:@"out"]){
            self.onlineState  = NTESLiveMicOnlineStateExitRoom;
        }
        
        id customizeFeeId = [dict objectForKey:@"customizeFeeId"];
        if([customizeFeeId isKindOfClass:[NSString class]]){
            self.customizeFeeId = customizeFeeId;
        }else{
            if(customizeFeeId){
                self.customizeFeeId = [NSString stringWithFormat:@"%@",customizeFeeId];
            }
        }
        self.customizeFeeName =  [dict objectForKey:@"customizeFeeName"];
        id goodsCateId =  [dict objectForKey:@"goodsCateId"];
        if([goodsCateId isKindOfClass:[NSString class]]){
            self.goodsCateId = goodsCateId;
        }else{
            if(goodsCateId){
                self.goodsCateId = [NSString stringWithFormat:@"%@",goodsCateId];
            }
        }
        self.goodsCateName =  [dict objectForKey:@"goodsCateName"];
        self.orderCategory = [dict objectForKey:@"orderCategory"];
    }
    return self;
}

+ (instancetype)me:(NSString *)roomId
{
    NTESMicConnector *instance = [[NTESMicConnector alloc] init];
    instance.uid   = [[NIMSDK sharedSDK].loginManager currentAccount];
    instance.type  = [NTESLiveManager sharedInstance].bypassType;
    NIMChatroomMember *member = [[NTESLiveManager sharedInstance] myInfo:roomId];
    instance.avatar = member.roomAvatar;
    instance.nick   = member.roomNickname;
    return instance;
}

@end

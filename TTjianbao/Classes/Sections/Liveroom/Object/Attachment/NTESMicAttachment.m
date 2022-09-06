//
//  NTESMicAttachment.m
//  TTjianbao
//
//  Created by chris on 16/7/25.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMicAttachment.h"
#import "NSDictionary+NTESJson.h"
#import "NTESCustomKeyDefine.h"

@implementation NTESMicConnectedAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *encode = @{
                             NTESCMType : @(NTESCustomAttachTypeConnectedMic),
                             NTESCMData : @{
                                     NTESCMConnectMicUid    : self.connectorId,
                                     NTESCMConnectMicNick   : self.nick.length? self.nick : @"",
                                     NTESCMConnectMicAvatar : self.avatar.length? self.avatar : @"",
                                     NTESCMCallStyle        : @(self.type)
                                     },
                             };
    return [encode jsonBody];
}

@end



@implementation NTESDisConnectedAttachment

- (NSString *)encodeAttachment
{
    NSMutableDictionary *encode = [@{
                             NTESCMType : @(NTESCustomAttachTypeDisconnectedMic)
                             } mutableCopy];
    if (self.connectorId) {
        [encode setObject : @{NTESCMConnectMicUid : self.connectorId} forKey:NTESCMData];
    }
    return [encode jsonBody];
}

@end

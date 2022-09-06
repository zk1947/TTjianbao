//
//  NTESDataManager.m
//  NIM
//
//  Created by amao on 8/13/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESDataManager.h"
#import "NTESLiveManager.h"


@interface NTESDataManager()

@end

@implementation NTESDataManager

+ (instancetype)sharedInstance{
    static NTESDataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESDataManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _defaultUserAvatar = [UIImage imageNamed:@"avatar_user"];
    }
    return self;
}

- (NTESDataUser *)infoByUser:(NSString *)userId
                 withMessage:(NIMMessage *)message
{
    NTESDataUser *info = [[NTESDataUser alloc] init];
    info.showName = userId; //默认值
    if ([userId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        NIMChatroomMember *member = [[NTESLiveManager sharedInstance] myInfo:message.session.sessionId];
        info.showName        = member.roomNickname;
        info.avatarUrlString = member.roomAvatar;
    }else{
        NIMMessageChatroomExtension *ext = [message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ?
        (NIMMessageChatroomExtension *)message.messageExt : nil;
        info.showName = ext.roomNickname;
        info.avatarUrlString = ext.roomAvatar;
    }
    info.avatarImage = self.defaultUserAvatar;
    return info;
}


@end


@implementation NTESDataUser

@end


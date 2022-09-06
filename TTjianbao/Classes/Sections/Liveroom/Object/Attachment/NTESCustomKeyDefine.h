//
//  NTESCustomKeyDefine.h
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#ifndef NTESCustomKeyDefine_h
#define NTESCustomKeyDefine_h

typedef NS_ENUM(NSInteger,NTESCustomAttachType)
{
//    JHCustomAttachTypeConnectedMic,
//    JHCustomAttachTypeDisconnectedMic,
//    JHCustomAttachTypeFollowAnchor,
    NTESCustomAttachTypePresent = 100,
    NTESCustomAttachTypeLike,
    NTESCustomAttachTypeConnectedMic,
    NTESCustomAttachTypeDisconnectedMic,
};


//key
#define NTESCMType             @"type"
#define NTESCMData             @"data"
#define NTESCMPresentType      @"present"
#define NTESCMPresentCount     @"count"
#define NTESCMConnectMicUid    @"uid"
#define NTESCMConnectMicNick   @"nick"
#define NTESCMConnectMicAvatar @"avatar"
#define NTESCMCallStyle        @"style"

#define NTESCMMeetingName      @"meetingName"

#define NTESCMOrientation      @"orientation"

#define JHLiveDuringSecond     @"duringSecond"

#endif /* NTESCustomKeyDefine_h */

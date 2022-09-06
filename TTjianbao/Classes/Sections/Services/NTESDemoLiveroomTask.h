//
//  NTESDemoLiveroomTask.h
//  TTjianbao
//
//  Created by chris on 16/3/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESDemoServiceTask.h"
#import "NTESLiveViewDefine.h"
#import "NIMSDK/NIMSDK.h"

typedef NS_ENUM(NSInteger,NTESDemoLiveStreamType){
    NTESDemoLiveStreamTypeRTMP,
    NTESDemoLiveStreamTypeHLS,
    NTESDemoLiveStreamTypeHTTP,
};

typedef void (^NTESChatroomStreamUrlHandler)(NSError *error, NIMChatroom *room);

@interface NTESDemoLiveroomTask : NSObject<NTESDemoServiceTask>

@property (nonatomic,assign) NTESDemoLiveStreamType streamType;

@property (nonatomic,copy) NSString *identity;

@property (nonatomic,copy) NTESChatroomStreamUrlHandler handler;

@end



typedef void (^NTESPlayStreamQueryHandler)(NSError *error, NSString *playStreamUrl, NTESLiveType liveType, NIMVideoOrientation orientation);

@interface NTESDemoPlayStreamQueryTask : NSObject<NTESDemoServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NTESPlayStreamQueryHandler handler;

@end



typedef void (^NTESDemoLiveMicQueuePushHandler)(NSError *error);

@interface NTESDemoLiveMicQueuePushTask : NSObject<NTESDemoServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *ext;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NTESDemoLiveMicQueuePushHandler handler;

@end


typedef void (^NTESDemoLiveMicQueuePopHandler)(NSError *error,NSString *ext);

@interface NTESDemoLiveMicQueuePopTask : NSObject<NTESDemoServiceTask>

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NTESDemoLiveMicQueuePopHandler handler;

@end


@interface NTESQueuePushData : NSObject

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *ext;

@property (nonatomic,copy) NSString *uid;

@end


@interface NTESQueuePopData : NSObject

@property (nonatomic,copy) NSString *roomId;

@property (nonatomic,copy) NSString *uid;

@end


//
//  NTESDemoService.h
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESDemoRegisterTask.h"
#import "NTESDemoLiveroomTask.h"


@interface NTESDemoService : NSObject
+ (instancetype)sharedService;

- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion;

- (void)requestLiveStream:(NSString *)identity
               completion:(NTESChatroomStreamUrlHandler)completion;

- (void)requestPlayStream:(NSString *)roomId
               completion:(NTESPlayStreamQueryHandler)completion;

- (void)requestMicQueuePush:(NTESQueuePushData *)data
                 completion:(NTESDemoLiveMicQueuePushHandler)completion;

- (void)requestMicQueuePop:(NTESQueuePopData *)data
                 completion:(NTESDemoLiveMicQueuePopHandler)completion;


@end

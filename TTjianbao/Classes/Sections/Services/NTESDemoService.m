//
//  NTESDemoService.m
//  NIM
//
//  Created by amao on 1/20/16.
//  Copyright © 2016 Netease. All rights reserved.
//

#import "NTESDemoService.h"

@implementation NTESDemoService
+ (instancetype)sharedService
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}


- (void)registerUser:(NTESRegisterData *)data
          completion:(NTESRegisterHandler)completion
{
    NTESDemoRegisterTask *task = [[NTESDemoRegisterTask alloc] init];
    task.data = data;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestLiveStream:(NSString *)identity
               completion:(NTESChatroomStreamUrlHandler)completion
{
    NTESDemoLiveroomTask *task = [[NTESDemoLiveroomTask alloc] init];
    task.identity = identity;
    task.handler = completion;
    [self runTask:task];
}


- (void)requestPlayStream:(NSString *)roomId
               completion:(NTESPlayStreamQueryHandler)completion
{
    NTESDemoPlayStreamQueryTask *task = [[NTESDemoPlayStreamQueryTask alloc] init];
    task.roomId  = roomId;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestMicQueuePush:(NTESQueuePushData *)data
                 completion:(NTESDemoLiveMicQueuePushHandler)completion
{
    NTESDemoLiveMicQueuePushTask *task = [[NTESDemoLiveMicQueuePushTask alloc] init];
    task.roomId = data.roomId;
    task.ext = data.ext;
    task.uid = data.uid;
    task.handler = completion;
    [self runTask:task];
}

- (void)requestMicQueuePop:(NTESQueuePopData *)data
                completion:(NTESDemoLiveMicQueuePopHandler)completion
{
    if (!data.uid) {
        return;
    }
    NTESDemoLiveMicQueuePopTask *task = [[NTESDemoLiveMicQueuePopTask alloc] init];
    task.roomId = data.roomId;
    task.uid = data.uid;
    task.handler = completion;
    [self runTask:task];
}


- (void)runTask:(id<NTESDemoServiceTask>)task
{
    NSURLRequest *request = [task taskRequest];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               id jsonObject = nil;
                               NSError *error = connectionError;
                               if (connectionError == nil &&
                                   [response isKindOfClass:[NSHTTPURLResponse class]] &&
                                   [(NSHTTPURLResponse *)response statusCode] == 200)
                               {
                                   if (data)
                                   {
                                       jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:0
                                                                                      error:&error];
                                   }
                                   else
                                   {
                                       error = [NSError errorWithDomain:@"ntes domain"
                                                                   code:-1
                                                               userInfo:@{@"description" : @"invalid data"}];
                                   }
                               }
                               [task onGetResponse:jsonObject
                                             error:error];
                               
                           }];
}
@end

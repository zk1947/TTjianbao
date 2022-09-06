//
//  NTESDemoLiveroomTask.m
//  TTjianbao
//
//  Created by chris on 16/3/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESDemoLiveroomTask.h"
#import "NTESDemoConfig.h"
#import "NSDictionary+NTESJson.h"
#import "NTESLiveUtil.h"
#import "NTESLiveManager.h"
#import "NTESCustomKeyDefine.h"

@implementation NTESDemoLiveroomTask

- (NSURLRequest *)taskRequest
{
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/chatroom/hostEntrance"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];

    
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    NSString *roomExt = [
                           @{
                             NTESCMType : @([NTESLiveManager sharedInstance].type),
                             NTESCMMeetingName : self.identity,
                           } jsonBody
                        ];
    NSString *avType = [NTESLiveUtil liveTypeToString:[NTESLiveManager sharedInstance].type];
    
    
    int orientation = ([NTESLiveManager sharedInstance].requestOrientation ==NIMVideoOrientationLandscapeRight) ? 2:1;
                                                                      
//    NSString *postData = [NSString stringWithFormat:@"uid=%@&type=%zd&ext=%@&avType=%@",currentUserId,self.streamType,roomExt,avType];
    
        NSString *postData = [NSString stringWithFormat:@"uid=%@&type=%zd&ext=%@&avType=%@&orientation=%d",currentUserId,self.streamType,roomExt,avType,orientation];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


- (void)onGetResponse:(id)jsonObject
                error:(NSError *)error
{
    NSError *resultError = error;
    NIMChatroom *chatroom;
    
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
        if (resultError == nil)
        {
            NSDictionary *msg  = [dict jsonDict:@"msg"];
            chatroom = [self makeChatroom:msg];
            NSDictionary *live = [msg jsonDict:@"live"];
            NSString *liveUrl = [live jsonString:@"pushUrl"];
            NSString *pullUrl = [live jsonString:@"rtmpPullUrl"];
            NSDictionary * liveDic = @{@"pushUrl" : liveUrl,
                                       @"pullUrl": pullUrl};
            chatroom.ext = [NTESLiveUtil dataTojsonString:liveDic];
            
            if (liveUrl.length) {
                chatroom.broadcastUrl = liveUrl;
            }
        }
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(resultError,chatroom);
        });
    }
}


- (NIMChatroom *)makeChatroom:(nonnull NSDictionary *)dict
{
    BOOL status = [dict jsonInteger:@"status"];
    if (status)
    {
        NIMChatroom *chatroom = [[NIMChatroom alloc] init];
        chatroom.roomId  = [dict jsonString:@"roomid"];
        chatroom.name    = [dict jsonString:@"name"];
        chatroom.creator = [dict jsonString:@"creator"];
        chatroom.announcement = [dict jsonString:@"announcement"];
        chatroom.onlineUserCount = [dict jsonInteger:@"onlineusercount"];
        return chatroom;
    }
    else
    {
        return nil;
    }
}

@end


@implementation NTESDemoPlayStreamQueryTask

- (NSURLRequest *)taskRequest
{
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/chatroom/requestAddress"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];
    
    NSString *currentUserId = [[NIMSDK sharedSDK].loginManager currentAccount];
    
    NSDictionary *post = @{@"roomid":self.roomId,@"uid":currentUserId};
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:post options:0 error:nil]];
    return request;
}

- (void)onGetResponse:(id)jsonObject
                error:(NSError *)error
{
    NSError *resultError = error;
    NSString *playStreamUrl;
    NIMVideoOrientation orientation = NIMVideoOrientationPortrait;
    NTESLiveType liveType = NTESLiveTypeInvalid;
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
        if (resultError == nil)
        {
            NSDictionary *msg  = [dict jsonDict:@"msg"];
            NSDictionary *live = [msg jsonDict:@"live"];
            playStreamUrl = [live jsonString:@"rtmpPullUrl"];
            liveType = [NTESLiveUtil stringToLiveType:[live jsonString:@"avType"]];
            orientation = [live jsonInteger:@"orientation"] == 1 ? NIMVideoOrientationPortrait  :NIMVideoOrientationLandscapeRight;
        }
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
           self.handler(resultError,playStreamUrl,liveType,orientation);
        });
        
    }
}


@end


@implementation NTESDemoLiveMicQueuePushTask

- (NSURLRequest *)taskRequest
{
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/chatroom/pushMicLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];
    
    NSString *postData = [NSString stringWithFormat:@"roomid=%@&uid=%@&ext=%@",self.roomId,self.uid,self.ext];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (void)onGetResponse:(id)jsonObject
                error:(NSError *)error
{
    NSError *resultError = error;
    
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(resultError);
        });
        
    }
}

@end

@implementation NTESDemoLiveMicQueuePopTask

- (NSURLRequest *)taskRequest
{
    NSString *urlString = [[[NTESDemoConfig sharedConfig] apiURL] stringByAppendingString:@"/chatroom/popMicLink"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30];
    [request setHTTPMethod:@"Post"];
    
    [request addValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[[NIMSDK sharedSDK] appKey] forHTTPHeaderField:@"appkey"];
    
    NSString *postData = [NSString stringWithFormat:@"roomid=%@&uid=%@",self.roomId,self.uid];
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

- (void)onGetResponse:(id)jsonObject
                error:(NSError *)error
{
    NSError *resultError = error;
    NSString *ext = nil;
    if (error == nil && [jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)jsonObject;
        NSInteger code = [dict jsonInteger:@"res"];
        resultError = code == 200 ? nil : [NSError errorWithDomain:@"ntes domain"
                                                              code:code
                                                          userInfo:nil];
        if (resultError == nil)
        {
            NSDictionary *msg  = [dict jsonDict:@"msg"];
            ext = [msg jsonString:@"ext"];
        }
    }
    
    if (self.handler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.handler(resultError,ext);
        });
        
    }
}

@end

@implementation NTESQueuePushData

@end

@implementation NTESQueuePopData

@end


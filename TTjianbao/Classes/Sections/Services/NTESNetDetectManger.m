//
//  NTESNetDetectManger.m
//  TTjianbao
//
//  Created by Simon Blue on 16/12/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESNetDetectManger.h"
#import <NIMAVChat/NIMAVChat.h>
#import "NTESTimerHolder.h"

#define DetectResultNotification @"detectResult"

@interface NTESNetDetectManger ()

@property(nonatomic,strong) NIMAVChatNetDetectResult *detectResult;

@property(nonatomic) BOOL detectCompleted;

@property(nonatomic,strong) NSDate * detectTime;


@end

@implementation NTESNetDetectManger

+(instancetype)sharedmanager
{
    static NTESNetDetectManger *detectManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        detectManager = [[self alloc]init];
    });
    return detectManager;
}

-(void)startNetDetect
{
    __weak typeof(self) weakself = self;
    self.detectCompleted = NO;

    //demo 只做针对480P的视频探测
    [[NIMAVChatSDK sharedSDK].avchatNetDetectManager startDetectTaskForDetectType:NIMAVChatNetDetectType480P                completion:^(NIMAVChatNetDetectResult * _Nonnull result) {
            weakself.detectResult = result;
            weakself.detectCompleted = YES;
            weakself.detectTime = [NSDate date];
        
            [[NSNotificationCenter defaultCenter] postNotificationName:DetectResultNotification
                                                                object:nil
                                                              userInfo:nil];
    }];

}


-(NIMAVChatNetDetectResult*)getResult
{
    return _detectResult;
}

-(BOOL)isDetectCompleted
{
    return _detectCompleted;
}

-(NSDate*)getLastDetectTime
{
    return _detectTime;
}
@end

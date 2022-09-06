//
//  NTESNetDetectManger.h
//  TTjianbao
//
//  Created by Simon Blue on 16/12/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMAVChat/NIMAVChat.h>

@interface NTESNetDetectManger : NSObject

+(instancetype)sharedmanager;

-(void)startNetDetect;

-(NIMAVChatNetDetectResult*)getResult;

-(BOOL)isDetectCompleted;

-(NSDate*)getLastDetectTime;

@end

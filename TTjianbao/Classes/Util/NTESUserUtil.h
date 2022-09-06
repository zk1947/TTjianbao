//
//  NTESUserUtil.h
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMAVChat/NIMAVChat.h>
#import "NIMSDK/NIMSDK.h"

@interface NTESUserUtil : NSObject

+ (NSString *)showName:(NSString *)userId
           withMessage:(NIMMessage *)message;

+ (NSString *)genderString:(NIMUserGender)gender;

+ (void)requestMediaCapturerAccess:(NIMNetCallMediaType)type handler:(void (^)(NSError *))handler;

+ (NSString *)meetingName:(NIMChatroom *)chatroom;

+ (NIMNetCallOption *)fillNetCallOption:(NIMNetCallMeeting *)meeting;

+ (NIMNetCallVideoCaptureParam *)videoCaptureParam;

+ (NIMNetCallVideoQuality)defaultVideoQuality;

@end

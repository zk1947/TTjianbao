//
//  JHMicWaitMode.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMicWaitMode : NSObject
@property (nonatomic, assign) int singleWaitSecond;
@property (nonatomic, assign) int waitCount;
@property (nonatomic, assign) BOOL isWait;//是否在申请连麦中
@property (nonatomic, copy)   NSString *customizeId;//定制id
@property (nonatomic, strong) NSString * applyId; //申请Id
@property (nonatomic, strong) NSString * waitAppraiseId; //申请鉴定Id
@property (nonatomic, strong) NSString * waitRoomId; //比较用跟channelLocalId其实是同样意义
@property (nonatomic, strong) NSString * waitChannelLocalId; //直播间Id,请求用
@end

@interface JHApplyMicRoomMode : NSObject
@property (nonatomic, strong) NSString * appraiseId;
@property (nonatomic, strong) NSString * roomId; //Server认为:聊天室Id Client:用作直播间Id
@property (nonatomic, strong) NSString * channelLocalId; //直播间Id
@property (nonatomic, assign) int singleWaitSecond;
@property (nonatomic, assign) int waitCount;
@property (nonatomic, assign) BOOL isWait;//是否申请连麦中
@property (nonatomic, copy)   NSString *customizeId;//定制id
@property (nonatomic, copy)   NSString *applyId;//回收
@end


NS_ASSUME_NONNULL_END

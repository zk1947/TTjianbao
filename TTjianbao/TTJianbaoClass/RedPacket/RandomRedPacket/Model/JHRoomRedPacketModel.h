//
//  JHRoomRedPacketModel.h
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRoomRedPacketModel : NSObject

@property (nonatomic, copy) NSString *redPacketId;

@property (nonatomic, copy) NSString *sendCustomerId;

@property (nonatomic, copy) NSString *sendCustomerImg;

@property (nonatomic, copy) NSString *sendCustomerName;

///小提示
@property (nonatomic, copy) NSString *tip;

///寄语
@property (nonatomic, copy) NSString *wishes;

/// 领取条件
@property (nonatomic, copy) NSString *takeConditionDesc;

/// 点击开（红包失效）
@property (nonatomic, assign) BOOL isOpen;

/// 直播间ID
@property (nonatomic, copy) NSString *channelId;

/// 直播间ID
@property (nonatomic, copy) NSString *roomId;


/// 红包领取条件类型，0无条件，1倒计时，2分享，3关注
@property (nonatomic, assign) NSInteger takeConditionType;

///观看Ns后可领红包
@property (nonatomic, assign) long continueViewTime;

///观看进度
@property (nonatomic, assign) long currentTime;

///观看进度  %
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) dispatch_block_t removeBlock;

/// 神测埋点用的 JHRoleType
@property (nonatomic, copy) NSString *sendCustomerType;

/// 神测埋点用的
@property (nonatomic, copy) NSDictionary *trackingParams;

@end

@interface JHGetRoomRedPacketReqModel : JHReqModel

@property (nonatomic, copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END

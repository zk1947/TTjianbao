//
//  JHRedPacketGuideModel.h
//  TTjianbao
//
//  Created by apple on 2020/2/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRedPacketGuideModel : NSObject

///用户头像(发红包人img)
@property (nonatomic, copy)NSString *sendCustomerImg;

/// 发红包人ID
@property (nonatomic, copy)NSString *sendCustomerId;

/// 发红包人名字
@property (nonatomic, copy)NSString *sendCustomerName;

///红包ID
@property (nonatomic, copy)NSString *redPacketId;

///直播间ID
@property (nonatomic, copy)NSString *channelLocalId;

/// 直播间名称
@property (nonatomic, copy)NSString *channelName;

/// 红包类型，0：大额，1：超级，2：超大额
/// (2是直播间内也显示     0，1只在直播间外显示)
@property (nonatomic, assign)NSInteger redPacketType;

@end

NS_ASSUME_NONNULL_END

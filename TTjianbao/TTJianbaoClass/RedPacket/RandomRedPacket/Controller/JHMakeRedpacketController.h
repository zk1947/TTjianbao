//
//  JHMakeRedpacketController.h
//  TTjianbao
//  Description:创建红包控制器
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMakeRedpacketController : JHBaseViewController

//直播间ID
@property (nonatomic, strong) NSString* liveRoomChannelId;

/// 下面三个为了埋点增加的
@property (nonatomic, strong) ChannelMode *channel;

///一级标签
@property (nonatomic, copy)NSString *groupId;

///二级标签
@property (nonatomic, copy) NSString *entrance;

@end

NS_ASSUME_NONNULL_END

//
//  JHPublishAnnouncementController.h
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishAnnouncementController : JHBaseViewExtController

@property (nonatomic, copy) NSString *channelId;


/// 下面三个为了埋点增加的
@property (nonatomic, strong) ChannelMode *channel;

///一级标签
@property (nonatomic, copy)NSString *groupId;

///二级标签
@property (nonatomic, copy) NSString *entrance;

@end

NS_ASSUME_NONNULL_END

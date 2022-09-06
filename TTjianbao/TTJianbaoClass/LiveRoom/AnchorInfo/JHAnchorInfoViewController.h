//
//  JHAnchorInfoViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 主播个人主页 --- 个人介绍页

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode;

@interface JHAnchorInfoViewController : YDBaseViewController

///直播间信息
@property (nonatomic, strong) ChannelMode *channel;
///页面来源
@property (nonatomic, copy) NSString *fromSource;

@property (nonatomic, copy) NSString *channelLocalId; //deeplink 跳转主播页

@end

NS_ASSUME_NONNULL_END

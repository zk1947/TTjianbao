//
//  JHCustomerInfoController.h
//  TTjianbao
//
//  Created by lihui on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///定制师主页 - 首页

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode;

@interface JHCustomerInfoController : JHBaseViewController

///主播id
@property (nonatomic, copy) NSString *anchorId;
///直播间id
@property (nonatomic, copy) NSString *roomId;
///页面来源
@property (nonatomic, copy) NSString *fromSource;

@property (nonatomic, copy) NSString *channelLocalId; //deeplink 跳转主播页

@end

NS_ASSUME_NONNULL_END

//
//  JHAnchorEditInfoController.h
//  TTjianbao
//  Description:主播及直播间介绍
//  Created by lihui on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHLiveRoomModel.h"

@class JHAnchorInfoSectionHeader;

NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorEditInfoController : JHBaseViewController

@property (nonatomic, strong) JHAnchorRoomInfo* anchorRoomInfo;

@property (nonatomic, copy) void(^doneBlock)(void);

@end

NS_ASSUME_NONNULL_END

//
//  JHCustomerIntroduceController.h
//  TTjianbao
//
//  Created by lihui on 2020/11/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 定制师主页- 定制师个人介绍页

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomModel;

@interface JHCustomerIntroduceController : JHBaseViewController
@property (nonatomic, assign) BOOL isRecycle;
///直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;

@property (nonatomic, copy) dispatch_block_t updateBlock;

@end

NS_ASSUME_NONNULL_END

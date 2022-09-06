//
//  JHStoneLiveView.h
//  TTjianbao
//  Description:回血直播间
//  Created by jiang on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "ChannelMode.h"
#import "JHLivePlayerManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoneLiveView : BaseView
@property (nonatomic, strong) StoneChannelMode *stoneChannel;
@end

NS_ASSUME_NONNULL_END

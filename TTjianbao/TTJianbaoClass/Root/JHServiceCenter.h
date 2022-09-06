//
//  JHServiceCenter.h
//  TTjianbao
//  Description:TTjianbao服务中心,专门处理全局场景(不想在各处引用头文件)
//  TA从属于JHRootController,是其内部对象
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChannelMode.h"

#define JHUSERDEFAULT_SWITCH_KEY [NSString stringWithFormat:@"jh_person_center_selected_common_ui_%@",[UserInfoRequestManager sharedInstance].user.customerId]

NS_ASSUME_NONNULL_BEGIN

@interface JHServiceCenter : NSObject

//仅仅是公共属性带值用。。。
@property(strong,nonatomic) ChannelMode *channelModel;
//如果需要回调调用 由于是单例 没有清空 用之前要重新赋值 慎用
@property (nonatomic, copy) void (^finishFollow)(NSString *anchorId, BOOL isFollow);

- (void)checkStartLiveButton; //直播按钮是否显示
- (void)willShowStartLiveButton:(BOOL)isShow; //将要显示直播按钮
@end

NS_ASSUME_NONNULL_END

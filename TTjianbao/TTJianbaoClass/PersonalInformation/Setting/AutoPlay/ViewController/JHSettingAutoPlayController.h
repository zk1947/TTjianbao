//
//  JHSettingAutoPlayController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

typedef NS_ENUM(NSInteger, JHAutoPlayStatus)
{
    /// WiFi + 4G自动播放
    JHAutoPlayStatusWIFIAnd4G = -1,
    
    /// wifi自动播放
    JHAutoPlayStatusWIFI = 0,
    
    /// 关闭自动播放
    JHAutoPlayStatusClose = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHSettingAutoPlayController : JHBaseViewController

+ (JHAutoPlayStatus)getAutoPlayStatus;

@end

NS_ASSUME_NONNULL_END

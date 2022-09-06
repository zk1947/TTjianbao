//
//  JHStoreHomePageController.h
//  TTjianbao
//  Description:源头直购
//  Created by wuyd on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//  商城首页
//

#import "YDBaseTitleBarController.h"

static const CGFloat ScrollHeadBarHeight = 50.0;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomePageController : YDBaseTitleBarController

UIKIT_EXTERN NSString *const JHStoreHomePageIndexChangedNotification;

- (void)trackUserProfilePage:(BOOL)isBegin;

@end

NS_ASSUME_NONNULL_END

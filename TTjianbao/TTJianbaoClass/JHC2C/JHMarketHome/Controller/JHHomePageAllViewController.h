//
//  JHHomePageAllViewController.h
//  TTjianbao
//
//  Created by zk on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "YDBaseTitleBarController.h"

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString *const JHHomePageAllViewControllerNotification;

@interface JHHomePageAllViewController : YDBaseTitleBarController

@property (nonatomic, assign) BOOL cannotScroll;

- (void)trackUserProfilePage:(BOOL)isBegin;

@end

NS_ASSUME_NONNULL_END

//
//  JHAppraiseViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeViewController : JHBaseViewExtController

UIKIT_EXTERN NSString *const JHHomePageIndexChangedNotification;

- (void)trackUserProfilePage:(BOOL)isBegin;

@end

NS_ASSUME_NONNULL_END

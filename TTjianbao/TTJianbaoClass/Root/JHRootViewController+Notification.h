//
//  JHRootViewController+Notification.h
//  TTjianbao
//  Description:处理消息跳转,考虑简化去掉
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRootViewController (Notification)

- (void)onReceivreNotify:(NSNotification*)notify;
- (void)gotoPagesFromMessageDeepLink:(id)keyValues from:(NSString *)from;
- (void)messageToPageModel:(JHMessageTargetModel*)model from:(NSString *)from;
- (void)webToPage:(NSString *)className withParam:(NSDictionary *)paraDic from:(NSString *)from;

@end

NS_ASSUME_NONNULL_END

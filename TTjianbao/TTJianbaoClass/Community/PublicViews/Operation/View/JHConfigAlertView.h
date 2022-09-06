//
//  JHConfigAlertView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHConfigAlertView : UIView

+ (void)jh_showConfigAlertViewWithBanned:(BOOL)isBanned
                              typeName:(NSString *)typeName
                                reason:(NSString *)reason
                              timeType:(NSInteger )timeType
                              complete:(dispatch_block_t)complete;

@end

NS_ASSUME_NONNULL_END

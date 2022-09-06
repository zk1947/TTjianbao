//
//  JHLotterShareAlert.h
//  TTjianbao
//
//  Created by wangjianios on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseWhiteViewAlert.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotterShareAlert : JHBaseWhiteViewAlert

/// 0元抽 分享弹框
/// @param needTip  需要底部描述
//+ (void)showLotterShareAlertWithneedTip:(BOOL)needTip clickBlock:(dispatch_block_t)clickBlock;

+ (void)showAlertTitle:(NSString *)title subTitle:(NSString *)subTitle btnTitle:(NSString *)btnTitle  clickBlock:(dispatch_block_t)clickBlock;

@end

NS_ASSUME_NONNULL_END

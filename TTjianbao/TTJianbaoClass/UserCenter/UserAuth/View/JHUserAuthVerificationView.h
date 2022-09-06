//
//  JHUserAuthVerificationView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthVerificationView : UIView

/// 验证码弹框
+ (void)showWithCompleteBlock:(dispatch_block_t)completeBlock;

@end

NS_ASSUME_NONNULL_END

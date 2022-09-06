//
//  UIButton+BackColor.h
//  TTjianbao
//
//  Created by yaoyao on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BackColor)
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END

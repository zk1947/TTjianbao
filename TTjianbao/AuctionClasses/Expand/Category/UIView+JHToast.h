//
//  UIView+JHToast.h
//  TTjianbao
//
//  Created by mac on 2019/6/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JHToast)
- (void)showAnimalToast:(NSString *)message;
- (void)showAnimalToast:(NSString *)message startY:(CGFloat)starty;
- (void)showProgressHUDWithProgress:(CGFloat)progress WithTitle:(NSString*)title;
- (void)hideProgressHUD;
@end

NS_ASSUME_NONNULL_END

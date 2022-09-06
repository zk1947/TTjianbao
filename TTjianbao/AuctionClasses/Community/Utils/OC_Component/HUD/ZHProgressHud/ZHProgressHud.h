//
//  ZHProgressHud.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface ZHProgressHud : NSObject

@property (nonatomic, strong) MBProgressHUD *hud;

/** 类内部调用 */
+ (instancetype)sharedInstance;

/*====================== 供外部调用的方法 ======================*/
/** 等待框（菊花） */
+ (void)showLoading:(NSString *)msg inView:(UIView *)view;

/** 成功提示 */
+ (void)showSuccess:(NSString *)msg inView:(UIView *)view;

/** 失败提示 */
+ (void)showError:(NSString *)msg inView:(UIView *)view;


/** 自定义加载动画（序列帧实现） */
+(void)showLoadingAnimation:(NSString *)msg imageArray:(NSArray *)images inView:(UIView *)view;

/** 隐藏HUD */
+ (void)hide;

@end

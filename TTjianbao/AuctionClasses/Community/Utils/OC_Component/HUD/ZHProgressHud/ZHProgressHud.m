//
//  ZHProgressHud.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "ZHProgressHud.h"

typedef NS_ENUM(NSInteger, ZHProgressHudMode) {
    ZHProgressHudModeLoading = 0,       //加载菊花
    ZHProgressHudModeSuccess,           //成功
    ZHProgressHudModeError,             //失败
    ZHProgressHudModeCustomAnimation    //自定义加载动画（序列帧实现）
};

@interface ZHProgressHud ()

@end

@implementation ZHProgressHud

/** 类内部调用 */
+ (instancetype)sharedInstance {
    static ZHProgressHud *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZHProgressHud alloc] init];
    });
    return instance;
}

/*====================== 提供外部调用的方法 ======================*/

+ (void)p_showHudMsg:(NSString *)msg inView:(UIView *)inView mode:(ZHProgressHudMode)mode customImageView:(UIImageView *)imageView {
    //先消失
    [ZHProgressHud hide];
    //[inView endEditing:YES];
    
    //[UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    [ZHProgressHud sharedInstance].hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
    [ZHProgressHud sharedInstance].hud.minSize = CGSizeMake(80.0, 80.0);
    [ZHProgressHud sharedInstance].hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    [ZHProgressHud sharedInstance].hud.contentColor = [UIColor whiteColor];
    [ZHProgressHud sharedInstance].hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    
    //下面两行注释(模糊效果)要配合一起作用
    //[ZHProgressHud sharedInstance].hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75];
    //[ZHProgressHud sharedInstance].hud.contentColor = [UIColor whiteColor];
    [ZHProgressHud sharedInstance].hud.label.text = (msg ? msg : @"");
    [ZHProgressHud sharedInstance].hud.label.textColor = [UIColor whiteColor];
    [ZHProgressHud sharedInstance].hud.label.font = [UIFont systemFontOfSize:14.0];
    [ZHProgressHud sharedInstance].hud.offset = CGPointMake(0, -40.0);
    [ZHProgressHud sharedInstance].hud.removeFromSuperViewOnHide = YES;
    [ZHProgressHud sharedInstance].hud.completionBlock = ^{
        [ZHProgressHud sharedInstance].hud = nil;
    };
    
    switch (mode) {
        case ZHProgressHudModeLoading: {
            [ZHProgressHud sharedInstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
        }
        case ZHProgressHudModeSuccess: {
            [ZHProgressHud sharedInstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHud sharedInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_icon_success"]];
            
            break;
        }
        case ZHProgressHudModeError: {
            [ZHProgressHud sharedInstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHud sharedInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_icon_error"]];
            
            break;
        }
        case ZHProgressHudModeCustomAnimation: {
            //[ZHProgressHud sharedInstance].hud.bezelView.color = [UIColor yellowColor];
            [ZHProgressHud sharedInstance].hud.mode = MBProgressHUDModeCustomView;
            [ZHProgressHud sharedInstance].hud.customView = imageView;
            
            break;
        }
        default:
            break;
    }
}

+ (void)p_showSuccessOrErrorHud:(NSString *)msg mode:(ZHProgressHudMode)mode inView:(UIView *)view {
    if ([ZHProgressHud sharedInstance].hud) {
        [ZHProgressHud sharedInstance].hud.label.text = msg;
        [ZHProgressHud sharedInstance].hud.mode = MBProgressHUDModeCustomView;
        NSString *hudImgStr = (mode == ZHProgressHudModeSuccess ? @"hud_icon_success" : @"hud_icon_error");
        [ZHProgressHud sharedInstance].hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hudImgStr]];
        [ZHProgressHud sharedInstance].hud.minSize = [ZHProgressHud sharedInstance].hud.bezelView.size;
    } else {
        [self p_showHudMsg:msg inView:view mode:mode customImageView:nil];
        [ZHProgressHud sharedInstance].hud.minSize = CGSizeMake(100.0, 100.0);
    }
    [ZHProgressHud sharedInstance].hud.userInteractionEnabled = NO;
    [[ZHProgressHud sharedInstance].hud hideAnimated:YES afterDelay:(mode == ZHProgressHudModeSuccess ? 1.5 : 1.5)];
}

+ (void)showLoading:(NSString *)msg inView:(UIView *)view {
    [self p_showHudMsg:msg inView:view mode:ZHProgressHudModeLoading customImageView:nil];
}

+ (void)showSuccess:(NSString *)msg inView:(UIView *)view {
    [self p_showSuccessOrErrorHud:msg mode:ZHProgressHudModeSuccess inView:view];
}

+ (void)showError:(NSString *)msg inView:(UIView *)view {
    [self p_showSuccessOrErrorHud:msg mode:ZHProgressHudModeError inView:view];
}

+(void)showLoadingAnimation:(NSString *)msg imageArray:(NSArray *)images inView:(UIView *)view {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.animationImages = images;
    [imageView setAnimationRepeatCount:0];
    [imageView setAnimationDuration:(images.count + 1) * 0.065];
    [imageView startAnimating];
    [self p_showHudMsg:msg inView:view mode:ZHProgressHudModeCustomAnimation customImageView:imageView];
}

+ (void)hide {
    if ([ZHProgressHud sharedInstance].hud) {
        [[ZHProgressHud sharedInstance].hud hideAnimated:YES];
        [ZHProgressHud sharedInstance].hud = nil;
    }
}

@end

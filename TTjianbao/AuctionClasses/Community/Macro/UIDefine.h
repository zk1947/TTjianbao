//
//  UIDefine.h
//  TaodangpuAuction
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#ifndef UIDefine_h
#define UIDefine_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//系统单例
#define kCurrentDevice          [UIDevice currentDevice]
#define kNotificationCenter     [NSNotificationCenter defaultCenter]
#define kFileManager            [NSFileManager defaultManager]
#define kUserDefaults           [NSUserDefaults standardUserDefaults]
#define kURLCache               [NSURLCache sharedURLCache]
#define kKeyWindow              [UIApplication sharedApplication].keyWindow
#define kUIApplication          (UIApplication *)[UIApplication sharedApplication]
#define kAppDelegate            (AppDelegate *)[UIApplication sharedApplication].delegate

#ifdef DEBUG
#define DebugLog(s, ...) NSLog(@"%s(%d): %@\n", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#else
#define DebugLog(...)
#endif


#define kTipAlert(Message, Controller) {\
UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];\
UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:Message preferredStyle:UIAlertControllerStyleAlert];\
[alertVC addAction:action];\
[Controller presentViewController:alertVC animated:YES completion:nil];}

//#define kTipAlert(_S_, ...)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_S_), ##__VA_ARGS__] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show]

//判断机型

//iPhone 6
#define kDevice_6      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone 6P
#define kDevice_6P  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone X
#define kDevice_X      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone XR
//#define kDevice_XR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_XR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1624), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhone XsMax
#define kDevice_XsMax  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//iPhone X以上
#define kDevice_XLater \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})


//===========================================
#define kNaviBarHeight          (kDevice_XLater ? 88.0 : 64.0)
#define kTabBarHeight           (kDevice_XLater ? 83.0 : 49.0)
#define kSafeAreaTopHeight      (kDevice_XLater ? 44.0 : 0)
#define kSafeAreaBottomHeight   (kDevice_XLater ? 34.0 : 0)
//44 : 20
#define kStatusBarHeight        ([[UIApplication sharedApplication] statusBarFrame].size.height)

#define kScaleWidth_iP6(_X_)    (_X_ * (kScreenWidth/375))
#define kScaleHeight_iP5(_H_)   (_H_ * (kScreenHeight/568))
#define kScaleHeight_iP6(_H_)   (_H_ * (kScreenHeight/667))
//===========================================

//常量

//Font
#define kFontNormal         @"PingFangSC-Regular"   //常规字体
#define kFontLight          @"PingFangSC-Light"     //细体
#define kFontMedium         @"PingFangSC-Medium"    //中黑体
#define kFontBoldPingFang   @"PingFangSC-Semibold"  //平方粗体
#define kFontBoldDIN        @"DINAlternate-Bold"    //DIN粗体

static const CGFloat kPaddingTop15              = 15.0;
static const CGFloat kPaddingTop20              = 20.0;
static const CGFloat kPaddingLeft15             = 15.0;
static const CGFloat kPaddingLeft20             = 20.0;
static const CGFloat kNaviTitleFontSize         = 18.0;
static const CGFloat kNaviBackButtonFontSize    = 15.0;

//Color

#define kColorMain                  [UIColor colorWithHexString:@"FEE100"]  //主字体黄色
#define kColorMainRed               [UIColor colorWithHexString:@"FF4000"]  //主字体红色

#define kColor222                   [UIColor colorWithHexString:@"222222"]
#define kColor333                   [UIColor colorWithHexString:@"333333"]
#define kColor666                   [UIColor colorWithHexString:@"666666"]
#define kColor999                   [UIColor colorWithHexString:@"999999"]
#define kColorCCC                   [UIColor colorWithHexString:@"CCCCCC"]
#define kColorDDD                   [UIColor colorWithHexString:@"DDDDDD"]
#define kColorEEE                   [UIColor colorWithHexString:@"EEEEEE"]
#define kColorCellLine              [UIColor colorWithHexString:@"EEEEEE"]  //列表分割线颜色
#define kColorCellHighlight         [UIColor colorWithHexString:@"E5E5E5"]  //列表高亮颜色

#define kColorHex(_S_, _A_)         [UIColor colorWithHexString:_S_ alpha:_A_]

//通知
static NSString *const JHNotification_ReceiveUserTask = @"JHNotification_ReceiveUserTask"; //接收到任务积分通知

//隐藏称号等级相关
static BOOL const kHideTitleLevel = NO;



///电子签约认证信息加/解密的key
#define SIGN_AES_KEY        @"#uDanplD#Zv9%wlM"
#define SIGN_AES_IV_KEY     @"0x8vIDvzBrZAF472"

///企业认证上传营业执照图片的文件路径
#define kJHAiyunCertificationPath  @"client_publish/certification"


#endif /* UIDefine_h */

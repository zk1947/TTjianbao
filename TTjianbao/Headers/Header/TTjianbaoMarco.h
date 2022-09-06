//
//  TTjianbaoMarco.h
//  TTjianbao
//  Description:必备宏定义及设备、屏幕、版本等 ~相关头文件,应该很少去改动！！！
//  Created by Jesse on 2019/11/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef TTjianbaoMarco_h
#define TTjianbaoMarco_h

#pragma mark - Feature switch
/*银联支付*/
//#define JH_UNION_PAY 1
//银联支付开关
#define JH_UNION_ENABLE [UserInfoRequestManager sharedInstance].enableUnion
//卖场页面切换开关
#define JH_VERSION_SWITCH [UserInfoRequestManager sharedInstance].versionSwitch

#pragma mark -- /**Log*/

#ifdef DEBUG
    #define NSLog(fmt,...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    static DDLogLevel ddLogLevel = DDLogLevelAll;
#else
    #define NSLog(...)
    static DDLogLevel ddLogLevel = DDLogLevelOff;
#endif

/**Scan:pod中引用,待确认是否有用？？？*/
#define LBXScan_Define_Native  //下载了native模块
#define LBXScan_Define_ZXing   //下载了ZXing模块
#define LBXScan_Define_ZBar   //下载了ZBar模块
#define LBXScan_Define_UI     //下载了界面模块

#pragma mark -- /**弱化引用:weak & strong 配对使用*/

#define JH_WEAK(...)        @weakify(__VA_ARGS__)
#define JH_STRONG(...)    @strongify(__VA_ARGS__)

#pragma mark -- /**通用block包括以下三个种,应用于网络以外的情况,尽量不要再扩展！！！*/
typedef void (^JHFinishBlock)(void);
typedef void (^JHActionBlock)(id obj);
typedef void (^JHActionBlocks)(id obj, id data);

#pragma mark -- /*****设备、屏幕、版本等 ~头文件*****/
//系统单例
#define JHApplication       (UIApplication *)[UIApplication sharedApplication]
#define JHAppDelegate       ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define JHRootController     kSingleInstance(JHRootViewController)
#define JHKeyWindow     ([UIApplication sharedApplication].keyWindow)
#define JHCurrentDevice     [UIDevice currentDevice]
#define JHNotificationCenter    [NSNotificationCenter defaultCenter]
#define JHFileManager       [NSFileManager defaultManager]
#define JHUserDefaults      [NSUserDefaults standardUserDefaults]

//获取当前版本号
#define JHBundleVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//获取当前biuld的版本号
#define JHAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//取当前app名字
#define JHAppDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define InstallChannelCode         @"InstallChannelCode"
#define JHAppChannel [[NSUserDefaults standardUserDefaults] objectForKey:InstallChannelCode]?:@"AppStore"

/**系统版本*/
#define iOS(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version ? YES : NO)

/**设备型号:数字~尺寸*/
#define iPhone3_5 ([UIScreen mainScreen].bounds.size.height == 480.0 ? YES : NO)
////iPhone5
#define iPhone4_0 ([UIScreen mainScreen].bounds.size.height == 568.0 ? YES : NO)
////iPhone6
//#define iPhone4_7 ([UIScreen mainScreen].bounds.size.height == 667.0 ? YES : NO)
////iPhone6p
//#define iPhone5_5 ([UIScreen mainScreen].bounds.size.height == 736.0 ? YES : NO)
////iPhone X / iPhone XS
//#define iPhone5_8 ([UIScreen mainScreen].bounds.size.height == 812.0 ? YES : NO)
////iPhone XR
//#define iPhone6_1 (([UIScreen mainScreen].bounds.size.height == 896.0 ? YES : NO) && ([UIScreen mainScreen].scale == 2.0))
////iPhone XS Max
//#define iPhone6_5 (([UIScreen mainScreen].bounds.size.height == 896.0 ? YES : NO) && ([UIScreen mainScreen].scale == 3.0))
//
////iphone12系列新增
////iPhone12 iPhone12pro
//#define iPhone6_1_3X (([UIScreen mainScreen].bounds.size.height == 844.0 ? YES : NO) && ([UIScreen mainScreen].scale == 3.0))
////iPhone12 proMax
//#define iPhone6_7 (([UIScreen mainScreen].bounds.size.height == 926.0 ? YES : NO) && ([UIScreen mainScreen].scale == 3.0))
////iPhone12mini
//#define iPhone5_4 (([UIScreen mainScreen].bounds.size.height == 780.0 ? YES : NO) && ([UIScreen mainScreen].scale == 3.0))
//
//// 包含12mini 5.4
//// >=5.8寸的屏幕 iPhone X / iPhone XS / iPhone XR / iPhone XS Max
//#define iPhoneX_moreThan (iPhone5_8 || iPhone6_1 || iPhone6_5 || iPhone6_1_3X || iPhone6_7 || iPhone5_4)
//
///**ipad*/
//#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

#define UI                              UIConstManager.shareManager

/**屏幕的宽高*/
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenHeight (ScreenH < ScreenW ? ScreenW : ScreenH)
#define ScreenWidth  (ScreenH < ScreenW ? ScreenH : ScreenW)

/**status bar*/
//#define StatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
//#define NavigationBarH 44.f
//#define StatusBarAddNavigationBarH ((StatusBarH)+(NavigationBarH))
//
//适配iPhone X的底部安全区域
//#define JHSafeAreaValid [JHSystem existSafeArea] //存在有效安全区
//#define JHTabBarHeight          (iPhoneX_moreThan ? 83.0 : 49.0)
//#define JHSafeAreaTopHeight     (iPhoneX_moreThan ? 44.0 : 0)
//#define JHSafeAreaBottomHeight  (iPhoneX_moreThan ? 34.0 : 0)

/**scale*/
#define JHScaleToiPhone6(length)  (([UIScreen mainScreen].bounds.size.width / 375.0)*length)
#define JHFit2Size(iPhone5, iPhone6)    ([UIScreen mainScreen].bounds.size.width <= 320.1 ? iPhone5 : iPhone6)

/**uuid及idfv*/
#define JH_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]
#define JH_IDFV [[UIDevice currentDevice].identifierForVendor UUIDString]

#pragma mark -- /**设计规范 : Font 及 color*/
/**Font:标准*/
#define kFontNormal         @"PingFangSC-Regular"   //常规字体
#define kFontLight          @"PingFangSC-Light"     //细体
#define kFontMedium         @"PingFangSC-Medium"    //中黑体
#define kFontBoldPingFang   @"PingFangSC-Semibold"  //平方粗体
#define kFontBoldDIN        @"DINAlternate-Bold"    //DIN粗体
#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? kFontNormal : @"PingFang SC"

/**Font:自定义：PingFangSC-Regular*/
#define JHFont(fontSize) [UIFont fontWithName:PFR size:fontSize]
#define JHLightFont(fontSize) [UIFont fontWithName:kFontLight size:fontSize]
#define JHMediumFont(fontSize) [UIFont fontWithName:kFontMedium size:fontSize]
#define JHBoldFont(fontSize)      [UIFont fontWithName:kFontBoldPingFang size:fontSize]
#define JHDINBoldFont(fontSize) [UIFont fontWithName:kFontBoldDIN size:fontSize]

/**Color:通用*/
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define HEXCOLORA(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

/** 安全校验*/
#define IS_ARRAY(obj) [obj isKindOfClass:[NSArray class]]
#define IS_STRING(obj) [obj isKindOfClass:[NSString class]]
#define IS_DICTIONARY(obj) [obj isKindOfClass:[NSDictionary class]]
#define IS_DATA(obj) [obj isKindOfClass:[NSData class]]
#define IS_IMAGE(obj) [obj isKindOfClass:[UIImage class]]
///未知对象变字符串
#define OBJ_TO_STRING(obj) [NSString stringWithFormat:@"%@",obj]
///数组安全取值
#define SAFE_OBJECTATINDEX(JH_ARRAY,JH_INDEX) (IS_ARRAY(JH_ARRAY) ? (JH_ARRAY.count > JH_INDEX ? JH_ARRAY[JH_INDEX] : nil) : (nil))

#define kGoodsStatiscGapTime 1000

///获取本地字符串用的宏定义  --- lh
#define JHLocalizedString(value)   NSLocalizedString(value, nil)

#pragma mark - Check Null or Empty
#define isEmpty(aItem) \
    ( \
     aItem == nil \
     ||[aItem isEmpty] \
    )


#define _S(value, fallback) \
    isEmpty(value)? (fallback):(value)
#define NONNULL_STR(_obj_) (_obj_)? (_obj_):@ ""
#define NONNULL_NUM(_obj_) (_obj_)? (_obj_):@ "0"

#endif /* TTjianbaoMarco_h */

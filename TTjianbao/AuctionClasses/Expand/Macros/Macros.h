//
//  Macros.h
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 Insect. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

/** 登录 */

#define LOGINSTATUS          @"Loginstatus"
#define ONLINE               @"online"
#define OFFLINE               @"offline"
#define IDTOKEN         @"idToken"

#define FirstNet         @"firstNet"
#define FirstNetNotifaction         @"FirstNetNotifaction"
#define InstallChannelCode         @"InstallChannelCode"

/** 微信登陆 */

#define WXAPPID         @"wx628c6134de0f964d"
#define WXSECRET        @"39a856e3b4492dcb2dc2728f7d8ef0bd"
/** 屏幕高度 */
#define SHOWFREEAPPRAISELASTTIME         @"showFreeAppraiseLastTime"
#define LASTDATE         @"lastDate"
#define LiveLASTDATE         @"LivelastDate"
#define AppraiseIssueLastDate         @"AppraiseIssueLastDate"
#define AlipayScheme       @"Ali.com.yiding.jianhuo"

#define ThumbSmallByOrginal(_FILE_)   [_FILE_ stringByAppendingString: [UserInfoRequestManager sharedInstance].iswyPhotoServe?@"?imageView&thumbnail=250x250":@""]
#define ThumbMiddleByOrginal(_FILE_)  [_FILE_ stringByAppendingString: [UserInfoRequestManager sharedInstance].iswyPhotoServe?@"?imageView&thumbnail=500x500":@""]
#define MallBannerData       @"MallBannerData"
#define MallLivesData       @"MallLivesData"
#define AppraisalLivesData      @"AppraisalLivesData"
#define AppraisalRecordData       @"AppraisalRecordData"
#define CateData       @"CateData"
#define MallCateData       @"MallCateData"
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self;

/*****************  屏幕适配  ******************/
#define iphoneXSM (ScreenH == 667)
#define iphoneXR (ScreenH == 568)
#define iphoneX (ScreenH == 480)
#define iphone6p (ScreenH == 763)
#define iphone6 (ScreenH == 667)
#define iphone5 (ScreenH == 568)
#define iphone4 (ScreenH == 480)

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)480 ) == 0)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) == 0)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)667 ) < DBL_EPSILON)
#define IS_IPHONE_6P (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)736 ) < DBL_EPSILON)

#define IDFV [[UIDevice currentDevice].identifierForVendor UUIDString]

#define APPDELEGATE (AppDelegate*)[UIApplication sharedApplication].delegate
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//色值
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]
#define HEXCOLORA(hex,a) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:a]

#define GlobleThemeColor HEXCOLOR(0xfee100)

#ifndef UIColorFromRGB
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue &0xFF00) >>8))/255.0 blue:((float)(rgbValue &0xFF))/255.0 alpha:1.0]
#endif
//全局背景色
#define YPBGColor [UIColor colorWithRed:0.98f green:0.98f blue:0.98f alpha:1.00f]

#define PFR [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"PingFang SC"

#define PFR20Font [UIFont fontWithName:PFR size:20];
#define PFR18Font [UIFont fontWithName:PFR size:18];
#define PFR16Font [UIFont fontWithName:PFR size:16];
#define PFR15Font [UIFont fontWithName:PFR size:15];
#define PFR14Font [UIFont fontWithName:PFR size:14];
#define PFR13Font [UIFont fontWithName:PFR size:13];
#define PFR12Font [UIFont fontWithName:PFR size:12];
#define PFR11Font [UIFont fontWithName:PFR size:11];
#define PFR10Font [UIFont fontWithName:PFR size:10];
#define PFR9Font [UIFont fontWithName:PFR size:9];

///发布帖子传递参数>>>
#define sendUploadDatasIdentifer        @"sendUploadDatasIdentifer"
#define cancelUploadArticleIdnetifer    @"cancelUploadArticleIdnetifer"

#define ADRESSALTERSUSSNotifaction @"AdressAlterSussNotifaction"
#define SELECTADRESSSUSSNotifaction @"SelectAdressSussNotifaction"
#define ComeBackAppraisalLiveRoomNotifaction @"ComeBackAppraisalLiveRoomNotifaction"

#define EnterLiveRoomNotifaction @"EnterLiveRoomNotifaction"

#define XGNotifaction @"XGNotifaction"

#define HomePageActivityABtnNotifaction @"HomePageActivityABtnNotifaction"

#define LiveSDK @"LiveSDK"

#define AudienceAppraisalWaitCountChangeNotifaction @"AudienceAppraisalWaitCountChangeNotifaction"
#define TableBarSelectNotifaction @"TableBarSelectNotifaction"
//订单状态变更
#define ORDERSTATUSCHANGENotifaction @"OrderStatusChangeNotifaction"

#define ForbidSuccessNotifaction @"ForbidSuccessNotifaction"

#define OrderPayInfoStatusChangeNotifaction @"OrderPayInfoStatusChangeNotifaction"

#define ShowHomeFollowPageNotifaction @"ShowHomeFollowPageNotifaction"

//上传照片最大数
#define MaxPhotos 6

#define KEYWINDOW  [UIApplication sharedApplication].keyWindow
//获取当前版本号
#define BUNDLE_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
//获取当前版本的biuld
#define BIULD_VERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

#define DIV_UUID [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//主域名
#define FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.fileBaseString stringByAppendingString:_FILE_]
//举报域名
#define REPORT_BASE_STRING(_FILE_)[JHEnvVariableDefine.reportBaseUrl stringByAppendingString:_FILE_]
//社区域名
#define COMMUNITY_FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.communityFileBaseString stringByAppendingString:_FILE_]
//im_key
#define IMAPPKEY         JHEnvVariableDefine.imAppKey
//埋点域名
#define BurySeverURL JHEnvVariableDefine.BurySever

///协议范本
#define PROTOCOL_FILE_BASE_STRING(_FILE_)[JHEnvVariableDefine.protocolServer stringByAppendingString:_FILE_]




//#define FILE_BASE_STRING(_FILE_)[@"https://api.ttjianbao.com" stringByAppendingString:_FILE_]
//#define IMAPPKEY         @"1760655eab7c17316f322cec8a686a62"
//#define BurySeverURL @"http://event.ttjianbao.com:8080/report"
////社区正式环境
//#define COMMUNITY_FILE_BASE_STRING(_FILE_)[@"https://sq-api.ttjianbao.com" stringByAppendingString:_FILE_]
//

////测试环境  域名和im key

//http://39.97.167.234:8088

//http://106.75.64.151 //http://39.97.167.234:8088
//#define FILE_BASE_STRING(_FILE_)[@"http://39.97.167.234:8088" stringByAppendingString:_FILE_]
//
//#define FILE_BASE_STRING(_FILE_)[@"http://106.75.64.151" stringByAppendingString:_FILE_]
//#define IMAPPKEY         @"b571ec9d6080f409d0480c79026df5a3"
//#define BurySeverURL @"http://39.105.59.68:8080/report"
//////测试环境  社区域名
//#define COMMUNITY_FILE_BASE_STRING(_FILE_)[@"http://39.106.227.2:8080" stringByAppendingString:_FILE_]


#define ActivityURL(isSell, isAnchor)[FILE_BASE_STRING(@"/jianhuo/gameEntrance.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d",isSell, isAnchor]]

#define FindWishPaperURL(buyerId)[FILE_BASE_STRING(@"/jianhuo/findGoodsC.html?") stringByAppendingString:[NSString stringWithFormat:@"buyerId=%@",buyerId]]

#define AuctionURL(isSell, isAnchor, isAssistant) [FILE_BASE_STRING(@"/jianhuo/auctionBottom.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define AuctionListURL(isSell, isAnchor, isAssistant) [FILE_BASE_STRING(@"/jianhuo/auctionList.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%zd&isBroad=%zd&isAssistant=%zd",isSell, isAnchor,isAssistant]]

#define SendWishPaperURL(isSell, isAnchor, isAssistant) [FILE_BASE_STRING(@"/jianhuo/auctionList.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ShowWishPaperURL(isSell, isAnchor, isAssistant) [FILE_BASE_STRING(@"/jianhuo/wishB.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ShowUserWishPaperURL(isSell, isAnchor, isAssistant) [FILE_BASE_STRING(@"/jianhuo/wishC.html?") stringByAppendingString:[NSString stringWithFormat:@"isSell=%d&isBroad=%d&isAssistant=%d",isSell, isAnchor,isAssistant]]

#define ReturnDetailURL(orderID, isAnchor) [FILE_BASE_STRING(@"/jianhuo/app/refundDetail.html?") stringByAppendingString:[NSString stringWithFormat:@"orderId=%@&isBroad=%d",orderID,isAnchor]]

#define AppraiseIssueDetailURL(orderID) [FILE_BASE_STRING(@"/jianhuo/app/checkDetails.html?") stringByAppendingString:[NSString stringWithFormat:@"orderId=%@",orderID]]
//
#define FIRSTLAUNCHCOMPLETE [@"FirstLaunchComplete" stringByAppendingString:AppVersion]
////yaoyao<<<<<<<<<<<<<<<<<<<<
#pragma mark - 系统UI
//#define ScreenW [[UIScreen mainScreen] bounds].size.width
//#define ScreenH [[UIScreen mainScreen] bounds].size.height
#define StatusBarH [UIApplication sharedApplication].statusBarFrame.size.height
#define NavigationBarH 44.f
#define StatusBarAddNavigationBarH ((StatusBarH)+(NavigationBarH))

#pragma mark - 设备型号
#define iPhone3_5 ([UIScreen mainScreen].bounds.size.height == 480.0 ? YES : NO)
#define iPhone4_0 ([UIScreen mainScreen].bounds.size.height == 568.0 ? YES : NO)
#define iPhone4_7 ([UIScreen mainScreen].bounds.size.height == 667.0 ? YES : NO)
#define iPhone5_5 ([UIScreen mainScreen].bounds.size.height == 736.0 ? YES : NO)
//#define iPhone5_8 ([UIScreen mainScreen].bounds.size.height == 812.0 ? YES : NO)
//iPhone X / iPhone XS
#define iPhone5_8 ([UIScreen mainScreen].bounds.size.height == 812.0 ? YES : NO)
//iPhone XR
#define iPhone6_1 (([UIScreen mainScreen].bounds.size.height == 896.0 ? YES : NO) && ([UIScreen mainScreen].scale == 2.0))
//iPhone XS Max
#define iPhone6_5 (([UIScreen mainScreen].bounds.size.height == 896.0 ? YES : NO) && ([UIScreen mainScreen].scale == 3.0))
// >=5.8寸的屏幕 iPhone X / iPhone XS / iPhone XR / iPhone XS Max
#define iPhoneX_moreThan (iPhone5_8 || iPhone6_1 || iPhone6_5)

#define iPad_Device UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

/** 适配iPhone X的底部安全区域 */
#define BottomSafeArea (iPhoneX_moreThan ? 34.f : 0.f)

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define NAVIGATION_BAR_HEIGHT ((IS_IPAD ? 50 : 44) + STATUS_BAR_HEIGHT)
#define IS_EXIST_FRINGE [HGDeviceHelper isExistFringe]
#define SAFE_AREA_INSERTS_BOTTOM [HGDeviceHelper safeAreaInsetsBottom]
#define SAFE_AREA_INSERTS_TOP [HGDeviceHelper safeAreaInsetsTop]
#define TOP_BAR_HEIGHT (SAFE_AREA_INSERTS_TOP + (IS_IPAD ? 50 : 44))

#pragma mark - 系统版本
#define iOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0 ? YES : NO)
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? YES : NO)
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define iOS7 ([[[UIDevice currentDe vice] systemVersion] floatValue] >= 7.0 ? YES : NO)

#define kDefaultAvatarImage [UIImage imageNamed:@"icon_live_default_avatar"]
#define kDefaultCoverImage [UIImage imageNamed:@"cover_default_image"]
/** 取当前版本号 */
#define AppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/** 取当前app名字 */
#define AppDisplayName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

#define AppChannel [[NSUserDefaults standardUserDefaults] objectForKey:InstallChannelCode]?:@"AppStore" //

#import "RequestModel.h"
@import TXLiteAVSDK_UGC;

#define kPicDetailWillShowKeyBoardNotification @"PicDetailWillShowKeyBoardNotification"
#define kChannelDataOfResponseNoticeName @"kChannelDataOfResponseNoticeName"
#define kRefreshFocucCateNoticeName @"kRefreshFocucCateNoticeName"
#define kAppearRedHotNoticeName @"kAppearRedHotNoticeName"
//刷新社区首页的频道信息
#define kDiscoverHomeRefreshChannelNoticeName @"kDiscoverHomeRefreshChannelNoticeName"

#define kAttentionStampTime @"kAttentionStampTime"
#define kAppearRedHotKey @"kAppearRedHotKey"

#define ChannelDeviceFileData @"ChannelFiledData"
#define ChannelUserFileData @"ChannelUserFileData"
#define kRefreshNumNoticeName @"kRefreshNumNoticeName"
#define kAddShareCountNoticeName @"kAddShareCountNoticeName"

#define kDiscoverHomeAppearNoticeName @"kDiscoverHomeAppearNoticeName"
#define kDiscoverHomeDisAppearNoticeName @"kDiscoverHomeDisAppearNoticeName"

//第一次切换到社区界面未选择频道时
#define kFirstEnterChannelCompeleteName @"kFirstEnterChannelCompeleteName"

//点击事件回调
typedef void (^clickAction)(id sender);
typedef void (^ActionBlock)(id object, id sender);

typedef void (^didSelectCell)(NSIndexPath *indexPath);
typedef void (^didClickAction)(NSInteger index);
typedef void (^complete)(void);
typedef void (^successBlock)(void);
typedef void (^JHApiRequestHandler)( RequestModel *respondObject ,  NSError *error);

#endif /* Macros_h */

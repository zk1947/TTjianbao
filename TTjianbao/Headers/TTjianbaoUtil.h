//
//  TTjianbaoUtil.h
//  TTjianbaoUtil
//  Description:三方库及工具类 ~相关头文件
//  Created by Jesse on 2019/11/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef TTjianbaoUtil_h
#define TTjianbaoUtil_h

/**Warning*/
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/**Thread safe*/
#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define NONNULL_STR(_obj_) (_obj_)? (_obj_):@ ""

//网易SDK ~Netease
#define NTES_USE_CLEAR_BAR - (BOOL)useClearBar{return YES;}
#define NTES_FORBID_INTERACTIVE_POP - (BOOL)forbidInteractivePop{return YES;}

/** 微信登陆 */
#define WXAPPID         @"wx628c6134de0f964d"
#define WXSECRET        @"39a856e3b4492dcb2dc2728f7d8ef0bd"
//信鸽push
#define XGAPPID          2200327953
#define XGAPPKEY        @"IU8N9L9G2K7V"

/**UI tools*/
#import "CommAlertView.h"
#import "MBProgressHUD.h"

/**Extension*/
#import "UIView+JHToast.h"
#import "UIView+Blank.h"

#import "UITextField+PlaceHolderColor.h"
#import "UIButton+ImageTitleSpacing.h"
#import "NSString+AttributedString.h"
#import "NSString+Extension.h"
#import "NSString+JHCoreOperation.h"
#import "UILabel+UILabel_ChangeLineSpaceAndWordSpace.h"
#import "EnlargedImage.h"

//3rd
#import "CommonTool.h"
#import "FileUtils.h"
#import "BYTimer.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NOSSDK.h"
#import "JHAuthorize.h"
#endif /* TTjianbaoUtil_h */

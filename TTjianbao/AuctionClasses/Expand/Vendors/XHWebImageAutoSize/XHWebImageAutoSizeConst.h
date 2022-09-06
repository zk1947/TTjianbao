//
//  XHWebImageAutoSizeConst.h


#import <UIKit/UIKit.h>

// 过期提醒
#define XHWebImageAutoSizeDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#ifdef DEBUG
#define XHDebugLog(...) NSLog(__VA_ARGS__)
#else
#define XHDebugLog(...)
#endif


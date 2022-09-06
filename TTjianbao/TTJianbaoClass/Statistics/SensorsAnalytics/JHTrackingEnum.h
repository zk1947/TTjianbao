//
//  JHTrackingEnum.h
//  TTjianbao
//
//  Created by apple on 2020/12/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHTrackingEnum_h
#define JHTrackingEnum_h

typedef NS_ENUM(NSInteger, JHTrackingPage) {
    
    XWJTrackPageDefault,           // 默认项，页面没传时，置为@""
    XWJTrackPageHome,              // 首页

};
typedef NS_ENUM(NSInteger, JHTrackEventType) {
    
    JHTrackEventTypeDisplay,
    JHTrackEventTypeClick,
    JHTrackEventTypeClose,
    JHTrackEventTypeResult,
    JHTrackEventTypeOther,
};

typedef NS_ENUM(NSInteger, JHTrackPlatformType) {
    
  
    XWJTrackPlatformTypeWEIXIN,        // 微信
    XWJTrackPlatformTypeWEIXIN_CIRCLE, // 朋友圈
    XWJTrackPlatformTypeSINA,          // 微博
};
#endif /* JHTrackingEnum_h */

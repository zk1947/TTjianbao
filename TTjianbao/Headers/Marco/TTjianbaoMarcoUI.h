//
//  TTjianbaoMarcoUI.h
//  TTjianbao
//  Description:font、color等 ~头文件
//  Created by Jesse on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef TTjianbaoMarcoUI_h
#define TTjianbaoMarcoUI_h

#import <YYKit/YYKit.h>

/**image*/

#define kDefaultAvatarImage [UIImage imageNamed:@"icon_live_default_avatar"]
#define kDefaultCoverImage [UIImage imageNamed:@"cover_default_image"]
#define kDefaultNewStoreCoverImage [UIImage imageNamed:@"newStore_default_placehold"]

///导航栏相关图片
///返回
#define kNavBackBlackImg [UIImage imageNamed:@"navi_icon_back_black"]
#define kNavBackWhiteImg [UIImage imageNamed:@"navi_icon_back_white"]
#define kNavBackWhiteShadowImg [UIImage imageNamed:@"navi_icon_back_white_shadow"]
///分享
#define kNavShareBlackImg [UIImage imageNamed:@"navi_icon_share_black"]
#define kNavShareWhiteImg [UIImage imageNamed:@"navi_icon_share_white"]
#define kNavShareWhiteShadowImg [UIImage imageNamed:@"navi_icon_share_white_shadow"]


#define JHImageNamed(nameString) [UIImage imageNamed:nameString]

/**Color:自定义*/
#define kGlobalThemeColor           HEXCOLOR(0xfee100)
#define kColorMain                  [UIColor colorWithHexString:@"FEE100"]  //主字体黄色
#define kColorMainRed               [UIColor colorWithHexString:@"FF4000"]  //主字体红色
#define kColor222                   [UIColor colorWithHexString:@"222222"]
#define kColor333                   [UIColor colorWithHexString:@"333333"]
#define kColor666                   [UIColor colorWithHexString:@"666666"]
#define kColor999                   [UIColor colorWithHexString:@"999999"]
#define kColorCCC                   [UIColor colorWithHexString:@"CCCCCC"]
#define kColorDDD                   [UIColor colorWithHexString:@"DDDDDD"]
#define kColorEEE                   [UIColor colorWithHexString:@"EEEEEE"]
#define kColorFFF                   [UIColor colorWithHexString:@"FFFFFF"]
#define kColorCellLine              [UIColor colorWithHexString:@"EEEEEE"]  //列表分割线颜色
#define kColorCellHighlight         [UIColor colorWithHexString:@"E4E5E6"]  //列表高亮颜色
#define kColorFF4200                [UIColor colorWithHexString:@"FF4200"]  //价格相关的颜色
#define kColorF5F6FA                [UIColor colorWithHexString:@"F5F6FA"]  //主界面的背景色
#define kColorF5F5F8                 [UIColor colorWithHexString:@"F5F5F8"]
#define RGB515151 RGB(51,51,51)

#define RGB102102102 RGB(102,102,102)
#define RGB153153153 RGB(153, 153, 153)
#pragma mark --------------- 系统颜色 ---------------
#define APP_BACKGROUND_COLOR        RGB(245, 246, 250)
#pragma mark --------------- 系统颜色 ---------------

/**话题标签颜色：3.1.6新增 */
#define kColorTopicTitle  [UIColor colorWithHexString:@"408FFE"]
#define kColorTopicBackground  [UIColor colorWithHexString:@"EEF3FA"]


#endif /* TTjianbaoMarcoUI_h */

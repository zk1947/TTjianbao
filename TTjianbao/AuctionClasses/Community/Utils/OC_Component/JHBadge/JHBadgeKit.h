//
//  JHBadgeKit.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  badge组件
//  支持UIView, UITabBarItem, UIBarButtonItem
//

#ifndef JHBadgeKit_h
#define JHBadgeKit_h

#import "JHBadgeControl.h"
#import "UIView+JHBadge.h"
#import "UITabBarItem+JHBadge.h"
#import "UIBarButtonItem+JHBadge.h"

#endif /* JHBadgeKit_h */


//使用：
/**
 //1. UIView添加默认小圆点
 [self.headerView jh_addDotBadge];
 
 //2、UIView显示数字Badge
 [self.headerView jh_addBadgeNumber:99];
 
 //3、UIView显示文本Badge
 [self.headerView jh_addBadgeText:@"LIVE"];
 
 //4、tabBarItem添加badge
 [vc.tabBarItem jh_addBadgeText:@"99+"];
 
 //5、导航栏按钮添加badge
 [self.navigationItem.rightBarButtonItem jh_addBadgeNumber:10];
 
 //6、设置Badge中心点偏移量
 [self.navigationItem.rightBarButtonItem jh_moveBadgeWithX:-10 Y:0];
 
 //7、设置Badge伸缩模式
 [self.navigationItem.rightBarButtonItem jh_setBadgeFlexMode:JHBadgeFlexModeLeft];
 
 ！！！添加小圆点方法（ jh_addDotBadge ）最好与添加数字和文本Badge方法区分开！！！
 */

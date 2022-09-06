//
//  JHBadgeDelegate.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBadgeControl.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHBadgeDelegate <NSObject>

@required

@property (nonatomic, strong, readonly) JHBadgeControl *badgeView;

/** 显示带文本内容的Badge，默认右上角、14pts */
- (void)jh_addBadgeText:(NSString * _Nullable)text;

/** 显示带数字的Badge，默认右上角、14pts */
- (void)jh_addBadgeNumber:(NSInteger)number;

/** 显示小圆点，默认右上角、红色、9pts */
- (void)jh_addDotBadge;

/** 显示带颜色的小圆点，默认右上角、9pts */
- (void)jh_addDotWithColor:(UIColor *)color;

/**
 设置Badge的高度，改变Badge高度，宽度也按比例变化
 (注意: 此方法需要将Badge添加到控件上后再调用!!!)
 */
- (void)jh_setBadgeHeight:(CGFloat)height;

/** 设置Badge伸缩的方向 */
- (void)jh_setBadgeFlexMode:(JHBadgeFlexMode)flexMode;

/** 设置Badge偏移量，Badge中心点默认为父视图右上角*/
- (void)jh_moveBadgeWithX:(CGFloat)x Y:(CGFloat)y;

/** 显示Badge */
- (void)jh_showBadge;

/** 隐藏Badge */
- (void)jh_hideBadge;

// 数字增加/减少, 以下方法只适用于Badge内容为纯数字的情况
- (void)jh_plusBadge;
- (void)jh_plusBadgeBy:(NSInteger)number;
- (void)jh_minusBadge;
- (void)jh_minusBadgeBy:(NSInteger)number;

@end

NS_ASSUME_NONNULL_END

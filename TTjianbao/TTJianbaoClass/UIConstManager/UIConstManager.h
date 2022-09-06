//
//  UIConstManager.h
//  TTjianbao
//
//  Created by wangyongchao on 2021/1/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取UI屏幕数据必须didfinish最早初始化
@interface UIConstManager : NSObject

+ (instancetype)shareManager;

/// 状态栏高度
@property(nonatomic, readonly) CGFloat statusBarHeight;

/// 导航条高度
@property(nonatomic, readonly) CGFloat navBarHeight;

/// 状态栏和导航条高度
@property(nonatomic, readonly) CGFloat statusAndNavBarHeight;

/// TopSafeRegion高度
@property(nonatomic, readonly) CGFloat topSafeAreaHeight;

/// TabBar高度
@property(nonatomic, readonly) CGFloat tabBarHeight;

/// BottomSafeRegion高度
@property(nonatomic, readonly) CGFloat bottomSafeAreaHeight;

/// BottomSafeRegion和TabBar高度
@property(nonatomic, readonly) CGFloat tabBarAndBottomSafeAreaHeight;

/// 是否是iPad
@property(nonatomic, readonly) BOOL isIPad;

/// 是否是iphone
@property(nonatomic, readonly) BOOL isIphone;

/// 是否是存在安全区域
@property(nonatomic, readonly) BOOL isExistSafeArea;

/// 存储查看过的回收订单id，重启重置
@property(nonatomic, strong) NSMutableSet * recycleOrderIdSet;


/// DINBoldFont
/// @param size size
- (UIFont*)getDINBoldFont:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END

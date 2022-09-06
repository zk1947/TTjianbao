//
//  UIConstManager.m
//  TTjianbao
//
//  Created by wangyongchao on 2021/1/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIConstManager.h"
#import "objc/runtime.h"

@interface UIConstManager()

@property(nonatomic) CGFloat statusBarHeight;
@property(nonatomic) CGFloat navBarHeight;
@property(nonatomic) CGFloat topSafeAreaHeight;
@property(nonatomic) CGFloat statusAndNavBarHeight;
@property(nonatomic) CGFloat tabBarHeight;
@property(nonatomic) CGFloat bottomSafeAreaHeight;
@property(nonatomic) CGFloat tabBarAndBottomSafeAreaHeight;

@end

@implementation UIConstManager


- (BOOL)isIPad{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

- (BOOL)isIphone{
    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

- (BOOL)isExistSafeArea{
    return self.topSafeAreaHeight > 0;
}

/// 初始化UI固定值信息
- (void)setConstValues{
    //状态栏
    @autoreleasepool {
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *manager = UIApplication.sharedApplication.windows.firstObject.windowScene.statusBarManager;
            if (manager) {
                self.statusBarHeight = CGRectGetHeight(manager.statusBarFrame);
            }else{
                self.statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
            }
        }else{
            self.statusBarHeight = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
        }
        //导航条
        self.navBarHeight = CGRectGetHeight([[UINavigationController alloc] init].navigationBar.frame);

        //上下安全区域
        if (@available(iOS 11.0, *)) {
            self.topSafeAreaHeight =  UIApplication.sharedApplication.keyWindow.safeAreaInsets.top;
            self.bottomSafeAreaHeight =  UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
        }else{
            self.topSafeAreaHeight = 0.f;
            self.bottomSafeAreaHeight = 0.f;
        }
        
        //tabBar高度
        self.tabBarHeight = CGRectGetHeight([[UITabBarController alloc] init].tabBar.frame);
        self.statusAndNavBarHeight = self.statusBarHeight + self.navBarHeight;
        self.tabBarAndBottomSafeAreaHeight = self.tabBarHeight + self.bottomSafeAreaHeight;
    }
}

//不包含计算属性
- (NSString *)description{
    unsigned int count;
    Ivar *ivarArr = class_copyIvarList(UIConstManager.class, &count);
    NSString *str = @"";
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivarArr[i];
        str = [str stringByAppendingFormat:@"\n%s------%@", ivar_getName(ivar), [self valueForKey:[NSString stringWithFormat:@"%s",ivar_getName(ivar)]]];
    }
    return str;
}

+ (instancetype)shareManager {
    static UIConstManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        [manager setConstValues];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [UIConstManager shareManager];
}

- (id)copyWithZone:(NSZone *)zone{
    return [UIConstManager shareManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    return [UIConstManager shareManager];
}

- (NSMutableSet *)recycleOrderIdSet{
    if (!_recycleOrderIdSet) {
        _recycleOrderIdSet = [NSMutableSet setWithCapacity:0];
    }
    return  _recycleOrderIdSet;
}


- (UIFont*)getDINBoldFont:(CGFloat)size{
    UIFont *font = [UIFont fontWithName:@"DIN Alternate Bold" size:size];
    return font ? font : JHBoldFont(size);
}


@end

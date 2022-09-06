//
//  JHHomeTabController.h
//  TTjianbao
//  Description:app主页tab（4+1）items
//  Created by jesee on 10/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseTabBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeTabController : BaseTabBarController

- (void)homeSetup;
- (void)setTableSelectIndex:(NSUInteger)tableSelectIndex;
- (void)setHideRedPoint;
- (BOOL)isShowRedPoint;
- (void)clickPublishButton;

/// 返回顶部 子 subScrollView
+ (void)setSubScrollView:(UIScrollView *)subScrollView;

/// 返回顶部
/// @param mainScrollView 主 scrollView
/// @param index 第几个 tabbar
/// @param hasSubScrollView 是否有子scrollView
+ (void)changeStatusWithMainScrollView:(UIScrollView * __nullable)mainScrollView
                             index:(NSInteger)index
                  hasSubScrollView:(BOOL)hasSubScrollView;


/// 返回顶部
/// @param mainScrollView 主 scrollView
/// @param index 第几个 tabbar
+ (void)changeStatusWithMainScrollView:(UIScrollView * __nullable)mainScrollView
                             index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END

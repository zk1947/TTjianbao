//
//  JHSQHelper.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区辅助类
//

#import <Foundation/Foundation.h>
#import <IQKeyboardManager.h>
#import "TTjianbao.h"
#import "JHSQManager.h"
#import "JHBadgeKit.h"
#import "JXPagerView.h"
#import "JXCategoryView.h"
#import "JHEasyPollSearchBar.h"
#import "JHSQBannerView.h"

#define kSearchBgHeight  (40.0)
#define kSearchBarHeight (30.0)

NS_ASSUME_NONNULL_BEGIN

@interface JHSQHelper : NSObject

#pragma mark - 首页相关
///首页导航标签
+ (void)configPageTitleView:(JXCategoryTitleView *)titleCategoryView indicator:(JXCategoryIndicatorLineView * _Nullable )indicator;

+ (UIButton *)messageButton;
+ (UIView *)searchBgView;
+ (JHEasyPollSearchBar *)searchBar;

#pragma mark - 首页推荐列表
+ (JHSQBannerView *)bannerView;
+ (void)setKeyBoardEnable:(BOOL)enable;
+ (void)configTableView:(UITableView *)table cells:(NSArray<NSString *> *)cells;
///根据item_type返回相应的cell
+ (Class)cellClassWithItemType:(JHPostItemType)itemType;

#pragma mark - 首页版块列表

@end

NS_ASSUME_NONNULL_END

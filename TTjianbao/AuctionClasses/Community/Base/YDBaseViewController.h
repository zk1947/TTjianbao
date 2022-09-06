//
//  YDBaseViewController.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbao.h"
#import "YDBaseNavigationBar.h"
#import "YDBaseTableView.h"
#import "JHRefreshGifHeader.h"
#import "YDRefreshFooter.h"
#import "JHBaseViewExtController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YDBaseViewController : JHBaseViewExtController <UITableViewDelegate, UITableViewDataSource>

#pragma mark -
#pragma mark - TableView Property / Methods

@property (nonatomic, strong) YDBaseNavigationBar *naviBar; ///默认隐藏
@property (nonatomic, strong) YDBaseTableView *tableView;
@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

- (void)showNaviBar;
- (void)hideNaviBar;

#pragma mark -
#pragma mark - 子类可重写方法
//导航栏方法
- (void)leftBtnClicked;
- (void)rightBtnClicked;

//下拉刷新/加载方法
- (void)refresh;
- (void)refreshMore;
- (void)endRefresh;
- (BOOL)isRefreshing;

//tabBar、titleCategory点击操作
///页面回到顶部，默认已实现tableView回到顶部
- (void)scrollToTop;
///点击tabBar事件，默认已实现tableView刷新逻辑
- (void)handleTabBarClick;


@end

NS_ASSUME_NONNULL_END

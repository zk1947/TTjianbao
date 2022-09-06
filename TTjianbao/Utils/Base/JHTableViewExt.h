//
//  JHTableViewExt.h
//  TTjianbao
//  Description:带下来刷新和加载更多tableview,注意与JHBaseTableView区分
//  Created by Jesse on 2019/12/8.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTableViewExt : UITableView

//添加刷新
- (void)addRefreshView;
//添加加载更多
- (void)addLoadMoreView;
//隐藏加载更多,且不许再上拉加载
- (void)noDataEndRefreshing;
- (void)hideLoadMoreWithNoData;
//刷新完成后,关闭
- (void)hideRefreshView;
//加载完成后,关闭
- (void)hideLoadMoreView;
//是否显示空数据页面
- (void)hiddenEmptyPage:(BOOL)isHidden;
@end

NS_ASSUME_NONNULL_END

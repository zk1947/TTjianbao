//
//  JXPageView.h
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//  不要随意修改这个文件！！！
//

#import <UIKit/UIKit.h>
#import "JXPageListMainTableView.h"
#import "JXPageListContainerView.h"
#import "JXCategoryView.h"
#import "JHStoreHomeListCategoryView.h"

@class JXPageListView;

static NSString *const kChangeRefreshStatusNotification = @"changeRefreshStatusNotification";

@protocol JXPageListViewListDelegate <NSObject>

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了顶部内容，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView;


/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback;

/**
 选中listView之后触发数据加载。会多次回调，所以listView内部要做个标志，第一次才触发数据加载。
 */
- (void)listViewLoadDataIfNeeded;

@end

@protocol JXPageListViewDelegate <NSObject>

/**
 返回listViews，数组的item需要是UIView的子类，且要遵循JXPageListViewListDelegate。
 数组item要求返回一个UIView而不是一个UIScrollView，因为列表的UIScrollView一般是被包装到一个view里面，里面会处理数据源和其他逻辑。

 @param pageListView pageListView description
 @return listViews
 */
- (NSArray <UIView <JXPageListViewListDelegate>*>*)listViewsInPageListView:(JXPageListView *)pageListView;

@optional

/**
 悬浮分类视图选中某个index的回调

 @param pinCategoryView 悬浮分类视图
 @param index index
 */
- (void)pinCategoryView:(JXCategoryBaseView *)pinCategoryView didSelectedItemAtIndex:(NSInteger)index;


/// 点击更多分类按钮的点击事件回调 如果showMoreButton值为YES且需要获取点击事件 则该代理方法需要实现
/// @param pageListView pageListView description
/// @param sender 更多分类按钮
- (void)pageListView:(JXPageListView *)pageListView didClickMore:(id)sender;

@end


/**
 按照demo工程PageViewController里面的tips使用，把最后一个section留给listContainerCell。其余的，你就把mainTableView当做普通的tableView来处理就行。上面想添加多少cell都随你。
 */
@interface JXPageListView : UIView

//@property (nonatomic, strong, readonly) JXCategoryTitleView *pinCategoryView;
//自定义标题数组
@property (nonatomic, strong) NSMutableArray <NSString *>*titles;

@property (nonatomic, strong, readonly) JHStoreHomeListCategoryView *pinCategoryView;
@property (nonatomic, strong, readonly) JXCategoryIndicatorBackgroundView *indicatorView;

@property (nonatomic, strong, readonly) UITableViewCell *listContainerCell;
@property (nonatomic, strong, readonly) UIButton *moreButton;
///是否显示更多分类按钮 默认不显示
@property (nonatomic, assign) BOOL showMoreButton;

//@property (nonatomic, strong) JHStoreHomeListCategoryView *pinCategoryView;
//@property (nonatomic, strong) JXCategoryIndicatorBackgroundView *indicatorView;

@property (nonatomic, strong, readonly) JXPageListMainTableView *mainTableView;

@property (nonatomic, assign, getter=isListViewScrollStateSaveEnabled) BOOL listViewScrollStateSaveEnabled;    //是否保存底部滚动列表视图的滚动状态，默认YES。设置为YES，表示A列表被滚动一定距离后，切换到B列表，当B列表往上滚动到最顶部的时候，再切换到A列表，A列表保存了它之前的滚动距离；设置为NO，表示A列表被滚动一定距离后，切换到B列表，当B列表往上滚动到最顶部的时候，再切换到A列表，A列表也同步被滚动到最顶部了；具体可以参考demo效果。

@property (nonatomic, assign) CGFloat pinCategoryViewHeight;    //顶部固定悬浮categoryView的高度

@property (nonatomic, assign) CGFloat pinCategoryViewVerticalOffset; //顶部固定sectionHeader的垂直偏移量。数值越大越往下沉。

- (instancetype)initWithDelegate:(id<JXPageListViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

/**
 通过服务器获取到数据之后，再调用reloadData方法刷新
 */
- (void)reloadData;

@property (nonatomic, assign) BOOL isRefresh;  ///是否是刷新

/**
 返回列表容器cell的高度
 */
- (CGFloat)listContainerCellHeight;

/**
 返回列表容器cell
 */
- (UITableViewCell *)listContainerCellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 mainTableView的代理方法`scrollViewDidScroll`回调时需要调用该方法
 */
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;

///获取listView的偏移量
- (CGFloat)mainTableViewMaxContentOffsetY;

@end

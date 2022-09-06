//  scrollView 缺省页面 + 上拉刷新下拉加载
//  不需要逻辑判断应该展示的列表页面 jh_reloadDataWithEmputyView 替换 reload
//  更新于 2020/12/31.


NS_ASSUME_NONNULL_BEGIN

@interface JHEmptyView : UIView

/// 缺省页面 描述文案
@property (nonatomic, strong) UILabel *textLabel;

/// 缺省页面 图片
@property (nonatomic, strong) UIImageView *imageView;

/// 缺省页面大小
+ (CGSize)viewSize;

@end


@interface UIScrollView (JHEmpty)

@property (nonatomic, strong) JHEmptyView *jh_EmputyView;

- (void)jh_headerWithRefreshingBlock:(nullable void (^)(void))headerBlock
          footerWithRefreshingBlock:(nullable void (^)(void))footerBlock;

- (void)jh_endRefreshing;

- (void)jh_footerStatusWithNoMoreData:(BOOL)noMoreData;

- (void)jh_noMoreDataStatus;

- (void)jh_resetNoMoreDataStatus;

@end

@interface UITableView (JHEmpty)

- (void)jh_reloadDataWithEmputyView;

@end


@interface UICollectionView (JHEmpty)

- (void)jh_reloadDataWithEmputyView;

@end


NS_ASSUME_NONNULL_END

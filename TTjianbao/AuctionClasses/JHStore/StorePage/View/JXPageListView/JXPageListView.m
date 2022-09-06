//
//  JXPageView.m
//
//  Created by jiaxin on 2018/9/13.
//  Copyright © 2018年 jiaxin. All rights reserved.
//  不要随意修改这个文件！！！
//

#import "JXPageListView.h"
#import "TTjianbao.h"
#import "JXPageListContainerView.h"
#import "JHStoreHelp.h"
#import "JHSKinManager.h"
#import "JHSkinSceneManager.h"

static NSString *const kListContainerCellIdentifier = @"jx_kListContainerCellIdentifier";

#define kMoreButtonW  55.f

@interface JXPageListView ()
<
JXCategoryViewDelegate,
JHStoreHomeListCategoryDataSource,
JXPageListContainerViewDelegate
>

//@property (nonatomic, strong) JXCategoryTitleView *pinCategoryView;//自定义标题数组
@property (nonatomic, strong) JHStoreHomeListCategoryView *pinCategoryView;
@property (nonatomic, strong) JXCategoryIndicatorBackgroundView *indicatorView;

@property (nonatomic,   weak) id<JXPageListViewDelegate> delegate;
@property (nonatomic, strong) JXPageListMainTableView *mainTableView;
@property (nonatomic, strong) JXPageListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) UITableViewCell *listContainerCell;
@property (nonatomic, strong) NSArray *originalListViews;
///361新增 更多分类按钮
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation JXPageListView

- (instancetype)initWithDelegate:(id<JXPageListViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _listViewScrollStateSaveEnabled = NO;
    _pinCategoryViewVerticalOffset = 0;
    _isRefresh = YES;
    _showMoreButton = NO;
    
    //self.pinCategoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectZero];
    _pinCategoryView = [[JHStoreHomeListCategoryView alloc] initWithFrame:CGRectZero];
    _pinCategoryView.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    _pinCategoryView.delegate = self;
    _pinCategoryView.categoryDataSource = self; //自定义代理
    _pinCategoryView.titleColorGradientEnabled = YES; //字体颜色渐变过渡
//    _pinCategoryView.titleLabelZoomEnabled = YES;
//    _pinCategoryView.titleLabelZoomScale = 1;
    //_pinCategoryView.titleLabelStrokeWidthEnabled = YES; //会使选中标签字体颜色加深
    _pinCategoryView.averageCellSpacingEnabled = NO; //是否按屏幕宽度每个居中显示每个cell
    //点击cell进行contentScrollView切换时是否需要动画。默认为YES
    _pinCategoryView.contentScrollViewClickTransitionAnimationEnabled = NO;
    
    _pinCategoryView.titleColor = kColor333;
    _pinCategoryView.titleSelectedColor = kColor333;
    _pinCategoryView.titleFont = [UIFont fontWithName:kFontNormal size:14];
    _pinCategoryView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:15];
    _pinCategoryView.cellSpacing = 33; //cell间距
    _pinCategoryView.contentEdgeInsetLeft = 23;
    _pinCategoryView.contentEdgeInsetRight = 23;
    _pinCategoryView.cellWidth = JXCategoryViewAutomaticDimension; //cell宽度，默认等于文本宽度
    //_pinCategoryView.cellWidthIncrement = 10; //cell宽度的额外宽度
    //_pinCategoryView.defaultSelectedIndex = 0;
    _pinCategoryView.collectionView.alwaysBounceHorizontal = YES; //始终可以划动
    __weak typeof(self) weakSelf = self;
    _pinCategoryView.didScrollCallBack = ^(UIScrollView * _Nonnull scrollView) {
        [weakSelf handleTitleScrollCallback:scrollView];
    };
    
    //cell指示器样式
    _indicatorView = [[JXCategoryIndicatorBackgroundView alloc] init];
    _indicatorView.indicatorWidthIncrement = 26; //背景色块的额外宽度
    _indicatorView.indicatorHeight = 26;
    _indicatorView.indicatorCornerRadius = 13;
    _indicatorView.indicatorColor = kColorMain;
    //_indicatorView.scrollEnabled = NO; //禁止指示器滚动
    _pinCategoryView.indicators = @[_indicatorView];
    
    ///更多分类按钮
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.backgroundColor = [UIColor clearColor];
    [moreButton setImage:[UIImage imageNamed:@"mall_home_category_more"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"mall_home_category_more"] forState:UIControlStateHighlighted];
    [moreButton addTarget:self action:@selector(__handleMoreButtonActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    _moreButton = moreButton;
    
    _mainTableView = [[JXPageListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [UIView new];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kListContainerCellIdentifier];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];

    _listContainerView = [[JXPageListContainerView alloc] initWithDelegate:self];
    self.listContainerView.mainTableView = self.mainTableView;

    _pinCategoryView.contentScrollView = self.listContainerView.collectionView;

    [self configListViewDidScrollCallback];
}

- (void)__handleMoreButtonActionEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageListView:didClickMore:)]) {
        [self.delegate pageListView:self didClickMore:sender];
    }
}

- (void)setTitles:(NSMutableArray<NSString *> *)titles {
    if (titles.count == 0) {
        return;
    }
    //原始标题数组
    _titles = titles.mutableCopy;
    
    _pinCategoryView.titles = _titles;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainTableView.frame = self.bounds;
    
    /* hutao--add */
    self.mainTableView.backgroundColor = [UIColor clearColor];
    
//    JHSkinModel *model = [JHSkinManager entiretyBody];
//    if (model.isChange)
//    {
//        if ([model.type intValue] == 1)
//        {
//            //背景颜色
//            self.mainTableView.backgroundColor = [UIColor colorWithHexStr:model.name];
//        }
//        else if ([model.type intValue] == 0)
//        {
//
//        }
//    }
    
}

//滑动整个标签栏
- (void)handleTitleScrollCallback:(UIScrollView *)scrollView {
    //NSLog(@"offsetX = %.2f", scrollView.contentOffset.x);
}

- (void)reloadData {
    //先移除以前的listView
    for (UIView *listView in self.originalListViews) {
        [listView removeFromSuperview];
    }
    [self configListViewDidScrollCallback];
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
    [self.pinCategoryView reloadData];
}

- (CGFloat)listContainerCellHeight {
    return self.bounds.size.height - self.pinCategoryViewVerticalOffset;
}

- (UITableViewCell *)listContainerCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //触发第一个列表的下拉刷新
        NSArray *listViews = [self.delegate listViewsInPageListView:self];
        if (listViews.count > 0) {
            [listViews[self.pinCategoryView.selectedIndex] listViewLoadDataIfNeeded];
        }
    });
    
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:kListContainerCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.listContainerCell = cell;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    if (self.showMoreButton) {///需要显示更多按钮
        self.pinCategoryView.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width - 20.f, self.pinCategoryViewHeight);
        self.moreButton.frame = CGRectMake(cell.contentView.bounds.size.width - kMoreButtonW, 0, kMoreButtonW, self.pinCategoryViewHeight);
    }
    else {
        self.pinCategoryView.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, self.pinCategoryViewHeight);
        self.moreButton.frame = CGRectZero;
    }
    self.moreButton.hidden = !self.showMoreButton;
    
    if (self.pinCategoryView.superview != cell.contentView) {
        //首次使用pinCategoryView的时候，把pinCategoryView添加到它上面。
        [cell.contentView addSubview:self.pinCategoryView];
        if (self.showMoreButton) {
            [cell.contentView addSubview:self.moreButton];
        }
    }

    self.listContainerView.frame = CGRectMake(0, self.pinCategoryViewHeight, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height - self.pinCategoryViewHeight);
    [cell.contentView addSubview:self.listContainerView];

    return cell;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    //处理当页面滚动在最底部pageView的时候，页面需要立即停住，没有回弹效果。给用户一种切换到pageView浏览模式了
    if (scrollView.contentOffset.y > 10) {
        scrollView.bounces = NO;
    } else {
        scrollView.bounces = YES;
    }

    CGFloat topContentY = [self mainTableViewMaxContentOffsetY];
    if (scrollView.contentOffset.y >= topContentY) {
        //当滚动的contentOffset.y大于了指定sectionHeader的y值，且还没有被添加到self.view上的时候，就需要切换superView
        if (self.pinCategoryView.superview != self) {
            //切换背景色
//            self.pinCategoryView.backgroundColor = [UIColor whiteColor];
            [self addSubview:self.pinCategoryView];

            CGRect frame = self.pinCategoryView.frame;
            frame.origin.y = self.pinCategoryViewVerticalOffset;
            self.pinCategoryView.frame = frame;
            self.moreButton.hidden = !self.showMoreButton;

            ///处理更多按钮的布局
            if (self.showMoreButton) {
                [self addSubview:self.moreButton];
                CGRect buttonRect = self.moreButton.frame;
                buttonRect.origin.y = frame.origin.y;
                self.moreButton.frame = buttonRect;
            }
        }
    }
    else if (self.pinCategoryView.superview != self.listContainerCell.contentView) {
        //切换背景色
//        self.pinCategoryView.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
        //当滚动的contentOffset.y小于了指定sectionHeader的y值，
        //且还没有被添加到sectionCategoryHeaderView上的时候，就需要切换superView
        CGRect frame = self.pinCategoryView.frame;
        frame.origin.y = 0;
        self.pinCategoryView.frame = frame;
        [self.listContainerCell.contentView addSubview:self.pinCategoryView];
        
        ///处理moreButton的布局
        if (self.showMoreButton) {
            [self.listContainerCell.contentView addSubview:self.moreButton];
            CGRect buttonRect = self.moreButton.frame;
            buttonRect.origin.y = frame.origin.y;
            self.moreButton.frame = buttonRect;
        }
    }

    if (scrollView.isTracking || scrollView.isDecelerating) {
        //用户滚动的才处理
        if (self.currentScrollingListView != nil && self.currentScrollingListView.contentOffset.y > 0) {
            //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
            self.mainTableView.contentOffset = CGPointMake(0, topContentY);
        }
    }

    if (_isRefresh) {
        return;
    }
    if (!self.isListViewScrollStateSaveEnabled) {
        if (scrollView.contentOffset.y < topContentY) {
            //mainTableView已经显示了header，listView的contentOffset需要重置
            NSArray *listViews = [self.delegate listViewsInPageListView:self];
            CGFloat insetTop = scrollView.contentInset.top;
            if (@available(iOS 11.0, *)) {
                insetTop = scrollView.adjustedContentInset.top;
            }
            
            for (UIView <JXPageListViewListDelegate>* listView in listViews) {
                [listView listScrollView].contentOffset = CGPointMake(0, -insetTop);
            }
        }
    }
}

#pragma mark - Private

- (void)configListViewDidScrollCallback {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    self.originalListViews = listViews;
    for (UIView <JXPageListViewListDelegate>* listView in listViews) {
        __weak typeof(self)weakSelf = self;
         [listView listViewDidScrollCallback:^(UIScrollView *scrollView) {
            [weakSelf listViewDidScroll:scrollView];
        }];
    }
}

- (void)listViewDidSelectedAtIndex:(NSInteger)index {
    UIView<JXPageListViewListDelegate> *listContainerView = [self.delegate listViewsInPageListView:self][index];
    if ([listContainerView listScrollView].contentOffset.y > 0) {
        //当前列表视图已经滚动显示了内容
        [self.mainTableView setContentOffset:CGPointMake(0, [self mainTableViewMaxContentOffsetY]) animated:YES];
    }
}

- (CGFloat)mainTableViewMaxContentOffsetY {
    return floor(self.mainTableView.contentSize.height) - self.bounds.size.height;
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;

    if (scrollView.isTracking == NO && scrollView.isDecelerating == NO) {
        return;
    }

    CGFloat topContentHeight = [self mainTableViewMaxContentOffsetY];
    if (self.mainTableView.contentOffset.y < topContentHeight) {
        //mainTableView的header还没有消失，让listScrollView固定
        CGFloat insetTop = scrollView.contentInset.top;
        if (@available(iOS 11.0, *)) {
            insetTop = scrollView.adjustedContentInset.top;
        }
        scrollView.contentOffset = CGPointMake(0, -insetTop);
    }else {
        //mainTableView的header刚好消失，固定mainTableView的位置，显示listScrollView的滚动条
        self.mainTableView.contentOffset = CGPointMake(0, topContentHeight);
    }
}

#pragma mark - JXPagingListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(JXPageListContainerView *)listContainerView {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews.count;
}

- (UIView *)listContainerView:(JXPageListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews[row];
}

- (void)listContainerView:(JXPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    self.currentScrollingListView = [listViews[row] listScrollView];
}


#pragma mark -
#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pinCategoryView:didSelectedItemAtIndex:)]) {
        [self.delegate pinCategoryView:categoryView didSelectedItemAtIndex:index];
    }
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    [listViews[index] listViewLoadDataIfNeeded];
}

//点击选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //点击选中，会立马回调该方法。但是page还在左右切换。所以延迟0.25秒等左右切换结束再处理。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self listViewDidSelectedAtIndex:index];
    });
}

//滚动选中
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self listViewDidSelectedAtIndex:index];
    
}

//正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    //NSLog(@"正在滚动");
}


#pragma mark -
#pragma mark - JHStoreHomeListCategoryDataSource
- (CGFloat)homeListCategory:(JHStoreHomeListCategoryView *)categoryView forIndex:(NSInteger)index {
    return ceilf([_titles[index]
                  boundingRectWithSize:CGSizeMake(MAXFLOAT, _pinCategoryView.height)
                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                  attributes:@{NSFontAttributeName:_pinCategoryView.titleFont}
                  context:nil].size.width);
}

- (void)setIsRefresh:(BOOL)isRefresh {
    _isRefresh = isRefresh;
}

/**
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //1.判断自己能否接收事件
    if (self.userInteractionEnabled == NO
        || self.hidden == YES
        || self.alpha <= 0.01) {
        return nil;
    }
    //2.点在不在自己身上
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    //3.从后往前遍历自己的子控件,把事件传递给子控件,调用子控件的hitTest,
    int count = (int)self.subviews.count;
    
    for (int i = count - 1; i >= 0; i--) {
        //获取子控件
        UIView *childView = self.subviews[i];
        //把当前点的坐标系转换成子控件的坐标系
        CGPoint childP = [self convertPoint:point toView:childView];
        
        UIView *fitView = [childView hitTest:childP withEvent:event];
        
        if (fitView) {
            return fitView;
        }
    }
    
    //4.如果子控件没有找到最适合的View,那么自己就是最适合的View.
    return self;
}
 */

@end

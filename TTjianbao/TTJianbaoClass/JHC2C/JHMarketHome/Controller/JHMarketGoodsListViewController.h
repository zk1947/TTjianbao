//
//  JHMarketGoodsListViewController.h
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"
#import "JXCategoryListContainerView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHMarketGoodsListViewControllerDelegate <NSObject>
- (void)JHMarketGoodsListViewControllerLeaveTop;
@end

@interface JHMarketGoodsListViewController : JHBaseViewController

@property (nonatomic,   weak) id<JHMarketGoodsListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryBaseView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, assign) CGFloat tabAlpha;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;
- (UIScrollView *)getSubScrollViewFromSelf;

@end

NS_ASSUME_NONNULL_END

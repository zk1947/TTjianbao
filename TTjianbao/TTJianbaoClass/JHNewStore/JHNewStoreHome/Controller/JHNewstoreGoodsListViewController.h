//
//  JHNewstoreGoodsListViewController.h
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewstoreGoodsListViewControllerDelegate <NSObject>
- (void)JHNewstoreGoodsListViewControllerLeaveTop;
@end

@class JHNewStoreHomeGoodsProductListModel;
@class JHNewStoreGoodsInfoViewController;
@interface JHNewstoreGoodsListViewController : JHBaseViewController
@property(nonatomic,  assign) int  currentIndex;
@property (nonatomic,   copy) void(^goodsClickBlock)(JHNewStoreHomeGoodsProductListModel *model, NSIndexPath *indexPath);
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5, NSString *showId, NSString *boutiqueName);
@property (nonatomic,   weak) id<JHNewstoreGoodsListViewControllerDelegate> delegate;
//@property (nonatomic, strong) JHNewStoreGoodsInfoViewController *_Nullable goodsInfoVc;
@property (nonatomic, assign) BOOL hasBoutiqueValue;

@property (nonatomic, copy) NSString * currentCatTitle;

- (void)refresh;
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;
- (UIScrollView *__nullable)getSubScrollViewFromSelf;
- (void)reloadCategoryViewBackgroundColor:(BOOL)isFFF;
@end

NS_ASSUME_NONNULL_END

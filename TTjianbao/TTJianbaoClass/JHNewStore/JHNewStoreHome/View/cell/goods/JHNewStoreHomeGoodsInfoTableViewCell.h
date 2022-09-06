//
//  JHNewStoreHomeGoodsInfoTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreHomeGoodsInfoTableViewCellDelegate <NSObject>
- (void)JHNewStoreHomeGoodsInfoTableViewCellLeaveTopd;
@end

@class JHNewStoreHomeGoodsProductListModel;
@class JHNewstoreGoodsListViewController;
@interface JHNewStoreHomeGoodsInfoTableViewCell : UITableViewCell
@property (nonatomic,   copy) void(^goodsClickBlock)(JHNewStoreHomeGoodsProductListModel *model, NSIndexPath *indexPath);
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5, NSString *showId,NSString *boutiqueName);
@property (nonatomic,   weak) id<JHNewStoreHomeGoodsInfoTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL hasBoutiqueValue;
@property (nonatomic, strong) JHNewstoreGoodsListViewController *goodListVc;
- (void)releaseGoodListVC;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;
- (void)refresh;
- (UIScrollView *__nullable)getSubScrollViewFromSelf;
- (void)reloadCategoryViewBackgroundColor:(BOOL)isFFF;
@end

NS_ASSUME_NONNULL_END

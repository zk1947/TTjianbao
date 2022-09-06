//
//  JHMarketGoodsInfoViewController.h
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHMarketGoodsInfoViewControllerDelegate <NSObject>
- (void)JHMarketGoodsInfoViewControllerLeaveTop;
@end

@interface JHMarketGoodsInfoViewController : JHBaseViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, assign) NSInteger pageType;
@property (nonatomic,   weak) id<JHMarketGoodsInfoViewControllerDelegate> delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;

@end

NS_ASSUME_NONNULL_END

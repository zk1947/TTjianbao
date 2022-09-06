//
//  JHMarketHomeViewController.h
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHBaseListPlayerViewController.h"
#import "JXCategoryView.h"
#import "JHMarketCategoryTableViewCell.h"
#import "JHMarketGoodsListTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketTableView : UITableView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) JHMarketCategoryTableViewCell *firstCell;

@end

@interface JHMarketHomeViewController : JHBaseViewController <JXCategoryListContentViewDelegate>

/** 列表 */
@property (nonatomic, strong) JHMarketTableView *marketTableView;

@property (nonatomic, strong) JHMarketGoodsListTableViewCell *lastCell;

@property (nonatomic, assign) BOOL cannotScroll;

- (void)subScrollViewDidScrollToTop;

- (CGFloat)mainTableViewMaxContentOffsetY;

@end

NS_ASSUME_NONNULL_END

//
//  JHMarketGoodsListTableViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHMarketGoodsListTableViewCellDelegate <NSObject>
- (void)JHMarketGoodsListTableViewCellLeaveTopd;
@end

@interface JHMarketGoodsListTableViewCell : UITableViewCell

@property (nonatomic,   weak) id<JHMarketGoodsListTableViewCellDelegate> delegate;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;
- (UIScrollView *)getSubScrollViewFromSelf;
- (void)releaseGoodListVC;
@property (nonatomic, assign) CGFloat tabAlpha;

@property (nonatomic, assign) CGFloat addH;

@end

NS_ASSUME_NONNULL_END

//
//  JHNewStoreGoodsInfoView.h
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreGoodsInfoViewLeaveTopdDelegate <NSObject>
- (void)JHNewStoreGoodsInfoViewLeaveTopd;
@end

@class JHNewStoreHomeGoodsProductListModel;
@interface JHNewStoreGoodsInfoView : UIView
@property (nonatomic,   weak) id<JHNewStoreGoodsInfoViewLeaveTopdDelegate> delegate;
@property (nonatomic,   copy) void(^goodsClickBlock)(JHNewStoreHomeGoodsProductListModel *model);
@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);
- (void)setViewModel:(id)viewModel;
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;
- (void)makeDeatilDescModuleScrollToTop;
@end

NS_ASSUME_NONNULL_END

//
//  JHPurchaseStoneView.h
//  TTjianbao
//  Description:买入原石
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHPurchaseSplitTableViewCell.h"
#import "JHPurchaseCutTableViewCell.h"
#import "JHTableViewExt.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHPurchaseStoneViewDelegate <NSObject>

- (void)reloadNewData:(BOOL)isNew;
- (void)gotoOrderDetailPage:(JHPurchaseStoneListModel*)model;
- (void)gotoStoneResellPage:(JHPurchaseStoneListModel*)model;

@end

@interface JHPurchaseStoneView : BaseView

@property (nonatomic, strong) JHTableViewExt* pTableView;

@property (nonatomic, weak) id <JHPurchaseStoneViewDelegate>delegate;

- (void)setupView;
- (void)updateData:(NSArray*)array pageType:(JHStonePageType)type;
- (void)hideRefreshMoreWithData:(BOOL)hasData;
@end

NS_ASSUME_NONNULL_END

//
//  JHPurchaseCutTableViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseTableViewCell.h"

#define kPurchaseTableCutCellHeight (245+kCellMargin)

NS_ASSUME_NONNULL_BEGIN

@interface JHPurchaseCutTableViewCell : JHPurchaseTableViewCell

- (void)updateCell:(JHPurchaseStoneListModel*)model pageType:(JHStonePageType)pageType;
@end

NS_ASSUME_NONNULL_END

//
//  JHPurchaseSplitTableViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPurchaseTableViewCell.h"

#define kPurchaseTableSplitCellHeight (123+kCellMargin) //默认有一个split,UI给的高度差20左右？？
#define kPurchaseTableSplitCellOffsetHeight (20+15)
#define kPurchaseTableSplitOneCellHeight (149) //增加一个split,高度增加149
#define kPurchaseTableSplitOneCellImageHeight (75+11) //图片占位高度

NS_ASSUME_NONNULL_BEGIN

@interface JHPurchaseSplitTableViewCell : JHPurchaseTableViewCell

- (void)updateCell:(JHPurchaseStoneListModel*)model pageType:(JHStonePageType)pageType;
@end

NS_ASSUME_NONNULL_END

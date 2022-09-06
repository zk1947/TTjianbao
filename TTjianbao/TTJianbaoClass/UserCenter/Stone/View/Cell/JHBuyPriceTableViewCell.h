//
//  JHBuyPriceTableViewCell.h
//  TTjianbao
//  Description:买家出价
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneCommonTableViewCell.h"

#define kBuyPriceTableCellHeight (164+10) //只有一个出价用户高度
#define kBuyerPriceViewHeight (40+10)  //每个用户出价高度为(40+10)

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyPriceTableViewCell : JHStoneCommonTableViewCell

- (void)setCellThemeType:(JHCellThemeType)type;
@end

NS_ASSUME_NONNULL_END

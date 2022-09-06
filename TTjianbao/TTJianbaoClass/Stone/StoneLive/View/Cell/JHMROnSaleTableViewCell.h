//
//  JHMROnSaleTableViewCell.h
//  TTjianbao
//  Description:MainRoom在售原石
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOnSaleTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHMROnSaleCellType)
{
    JHMROnSaleCellTypeDefault,
    JHMROnSaleCellTypeSale = JHMROnSaleCellTypeDefault, //主播寄售原石
    JHMROnSaleCellTypeSaleTab, //主播寄售原石Tab
    JHMROnSaleCellTypeToSee    //宝友求看
};
@interface JHMROnSaleTableViewCell : JHOnSaleTableViewCell

//根据type区分不同样式
- (void)setupSubviewsByType:(JHMROnSaleCellType)type;
- (void)updateCell:(JHUCOnSaleListModel*)model;
@end

NS_ASSUME_NONNULL_END

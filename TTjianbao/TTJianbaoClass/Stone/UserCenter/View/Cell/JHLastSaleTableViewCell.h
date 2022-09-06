//
//  JHLastSaleTableViewCell.h
//  TTjianbao
//  Description:最近售出cell
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHCornerTableViewCell.h"
#import "JHLastSaleGoodsModel.h"
#import "JHStoneBaseView.h"

#define kLastSaleCellButtonHeight (30+10) //按钮高度+间距

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHLastSaleCellType)
{
    JHLastSaleCellTypeDefault, //主播最近售出：卖家？？带编号
    JHLastSaleCellTypeWillSale, //主播待上架
    JHLastSaleCellTypeBuyer,    //主播最近售出原石：买家？？不带编号
    JHLastSaleCellTypeFromUserCenter,    //主播最近售出(个人中心进入)~独立页面：卖家？？带编号,不带按钮
    JHLastSaleCellTypeWillSaleFromUserCenter, //主播待上架
};

@interface JHLastSaleTableViewCell : JHCornerTableViewCell

//根据type区分不同样式
- (void)setupSubviewsByType:(JHLastSaleCellType)type;
- (void)updateCell:(JHLastSaleGoodsModel*)model;
@end

NS_ASSUME_NONNULL_END

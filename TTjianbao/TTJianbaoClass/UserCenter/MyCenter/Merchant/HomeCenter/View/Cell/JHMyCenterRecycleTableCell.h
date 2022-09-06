//
//  JHMyCenterRecycleTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/4/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
/// 个人中心 - 回收订单管理

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHMyCenterMerchantCellButtonModel;

@interface JHMyCenterRecycleTableCell : JHWBaseTableViewCell
@property (nonatomic, strong) NSMutableArray <JHMyCenterMerchantCellButtonModel *> *buttonArray;
///是否显示去广场看看 默认不显示
@property (nonatomic, assign) BOOL showRecycleSquare;

@end

NS_ASSUME_NONNULL_END

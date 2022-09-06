//
//  JHMyCenterMoneyTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMoneyTableCell : JHWBaseTableViewCell
@property (nonatomic, copy) NSString *money;
/// 昨日成交金额
@property (nonatomic, copy) NSString *lastDayMoney;
@end

NS_ASSUME_NONNULL_END

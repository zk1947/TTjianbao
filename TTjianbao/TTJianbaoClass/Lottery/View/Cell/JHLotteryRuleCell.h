//
//  JHLotteryRuleCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  0元抽奖 - 规则cell
//

#import "YDBaseTableViewCell.h"
#import "JHLotteryDataManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryRuleCell : YDBaseTableViewCell
@property (nonatomic, assign) NSInteger codeCount;
@property (nonatomic, strong) JHLotteryActivityData *activityData;
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END

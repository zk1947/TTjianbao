//
//  JHLotteryCodeCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  0元抽奖 - 抽奖码cell
//

#import "YDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JHLotteryMyCodeModel;

@interface JHLotteryCodeCell : YDBaseTableViewCell

+ (CGFloat)cellHeight;


@property (nonatomic, strong) JHLotteryMyCodeModel *codeModel;


@end

NS_ASSUME_NONNULL_END

//
//  JHLuckyBagRewardCell.h
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLuckyBagRewardModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagRewardCell : UITableViewCell

@property (nonatomic, strong) JHLuckyBagRewardModel *model;

@property (nonatomic, assign) BOOL isOnAlert;

@end

NS_ASSUME_NONNULL_END

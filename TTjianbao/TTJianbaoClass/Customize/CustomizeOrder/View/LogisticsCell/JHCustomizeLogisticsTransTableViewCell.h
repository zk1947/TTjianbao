//
//  JHCustomizeLogisticsTransTableViewCell.h
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCustomizeLogisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeLogisticsTransTableViewCell : UITableViewCell
- (void)setViewModel:(JHCustomizeLogisticsDataModel *)viewModel isLast:(BOOL)isLast;
@end

NS_ASSUME_NONNULL_END

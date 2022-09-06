//
//  JHGoodManagerListAlertDurationTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/8/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessPubishNomalModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListAlertDurationTableViewCell : UITableViewCell

@property (nonatomic, strong)JHBusinessPubishNomalModel *pubishModel;
- (void)setViewModel:(NSDictionary *)viewModel;

@end

NS_ASSUME_NONNULL_END

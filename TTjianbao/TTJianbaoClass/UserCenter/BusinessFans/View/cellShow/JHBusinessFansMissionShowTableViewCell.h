//
//  JHBusinessFansMissionShowTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessFansSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansMissionShowTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL isLastLine;
@property (nonatomic, strong) JHBusinessFansSettingTaskCheckListModel *showModel;
@end

NS_ASSUME_NONNULL_END

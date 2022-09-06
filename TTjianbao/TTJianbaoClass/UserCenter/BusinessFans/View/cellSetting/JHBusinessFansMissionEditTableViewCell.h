//
//  JHBusinessFansMissionEditTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBusinessFansSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansMissionEditTableViewCell : UITableViewCell
@property (nonatomic, assign) BOOL                                     isLastLine;
@property (nonatomic,   copy) dispatch_block_t                         changeBlock;
@property (nonatomic, strong) JHBusinessFansSettingTaskCheckListModel *model;
- (void)settingBtnClickAction;
@end

NS_ASSUME_NONNULL_END

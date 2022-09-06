//
//  JHBusinessFansSettingLevelViewController.h
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHBusinessFansSettingApplyModel.h"
#import "JHBusinessFansSettingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansSettingLevelViewController : JHBaseViewExtController
@property (nonatomic,   copy) dispatch_block_t                 clickBlock;
@property (nonatomic, strong) JHBusinessFansSettingApplyModel *applyModel;
@property (nonatomic, strong) JHBusinessFansSettingModel      *setModel;
@end

NS_ASSUME_NONNULL_END

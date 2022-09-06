//
//  JHBusinessFansSettingDetailViewController.h
//  TTjianbao
//
//  Created by user on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHBusinessFansSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansSettingDetailViewController : JHBaseViewExtController
@property (nonatomic,   copy) NSString                   *anchorId;
@property (nonatomic,   copy) NSString                   *channelId;
@property (nonatomic, strong) JHBusinessFansSettingModel *setModel;
@end

NS_ASSUME_NONNULL_END

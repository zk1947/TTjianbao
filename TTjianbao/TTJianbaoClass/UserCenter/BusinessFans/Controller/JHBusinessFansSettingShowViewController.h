//
//  JHBusinessFansSettingShowViewController.h
//  TTjianbao
//
//  Created by user on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHBusinessFansSettingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessFansSettingShowViewController : JHBaseViewExtController
@property (nonatomic, assign) BOOL isApplying;
@property (nonatomic,   copy) NSString                   *anchorId;
@property (nonatomic,   copy) NSString                   *channelId;
@property (nonatomic, strong) JHBusinessFansSettingModel *showModel;
@end

NS_ASSUME_NONNULL_END

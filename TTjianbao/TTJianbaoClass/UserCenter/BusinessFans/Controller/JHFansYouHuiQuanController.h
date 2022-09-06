//
//  JHFansYouHuiQuanController.h
//  TTjianbao
//
//  Created by Paros on 2021/11/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHBusinessFansSettingApplyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHFansYouHuiQuanController : JHBaseViewController

@property(nonatomic, copy) NSString * ansID;

@property(nonatomic) BOOL  formB2C;

@property(nonatomic, copy) dispatch_block_t  createCoup;

@property(nonatomic, copy) void (^seleBlock)(JHFansCoupouModel* model);

@end

NS_ASSUME_NONNULL_END

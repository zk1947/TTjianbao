//
//  JHUpdateAlertView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/5/24.
//  Copyright © 2019 Netease. All rights reserved.
//
///版本更新提示

#import <UIKit/UIKit.h>
#import "JHUpdateApp.h"
#import "JHConnectMicPopAlertView.h"

#import "JHAPPAlertBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUpdateAlertView : JHAPPAlertBaseView

+ (void)showUpdateAlertWithModel:(JHUpdateAppModel *)model;

@end

NS_ASSUME_NONNULL_END

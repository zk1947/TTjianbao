//
//  JHActivityAlertView.h
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAPPAlertBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHAppAlertBodyActivityModel;
@interface JHActivityAlertView : JHAPPAlertBaseView

+ (void)showAPPAlertViewWithModel:(JHAppAlertBodyActivityModel *)model;

/// location 弹窗位置   1：全局      2：列表页    3：直播间
+ (void)getActivityAlertViewWithLocation:(NSInteger)location;

@end

NS_ASSUME_NONNULL_END

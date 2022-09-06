//
//  JHTaskHUD.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/20.
//  Copyright © 2019 Netease. All rights reserved.
//  经验值、积分增长提示 + 称号升级提示
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTaskHUD : BaseView

@property (nonatomic, assign) NSInteger to; //to  == "1" 点击跳转到任务中心，其他值暂不处理

+ (void)showTitle:(NSString *)title desc:(NSString *)desc toNum:(NSInteger)toNum;

//正常称号升级提示
+ (void)showUserTitleUp:(NSString *)title desc:(NSString *)desc;

//老用户升级提示
+ (void)showOldUserTitleUp:(NSString *)title desc:(NSString *)desc levelIcon:(NSString *)levelIcon;

@end

NS_ASSUME_NONNULL_END

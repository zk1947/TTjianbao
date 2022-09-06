//
//  JHOldUserTitleUpHUD.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/25.
//  Copyright © 2019 Netease. All rights reserved.
//  老用户首次称号升级提示
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOldUserTitleUpHUD : BaseView

+ (void)showTitle:(NSString *)title desc:(NSString *)desc levelIcon:(NSString *)levelIcon;

@end

NS_ASSUME_NONNULL_END

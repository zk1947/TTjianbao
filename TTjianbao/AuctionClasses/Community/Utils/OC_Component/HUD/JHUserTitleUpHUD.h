//
//  JHUserTitleUpHUD.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/21.
//  Copyright © 2019 Netease. All rights reserved.
//  称号升级提示
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserTitleUpHUD : BaseView

+ (void)showTitle:(NSString *)title desc:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END

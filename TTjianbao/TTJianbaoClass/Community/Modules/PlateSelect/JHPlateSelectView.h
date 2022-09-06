//
//  JHPlateSelectView.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  版块选择
//

#import <UIKit/UIKit.h>
#import "JHPlateSelectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPlateSelectView : UIView

+ (void)showInView:(UIView *)view doneBlock:(void(^)(JHPlateSelectData *data))block;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

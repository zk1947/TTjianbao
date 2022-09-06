//
//  JHZanHUD.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//  点击获赞数量 弹框
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHZanHUD : BaseView

+ (void)showText:(NSString *)text;
///顶部显示的背景图片
@property (nonatomic, copy) NSString *bgImageName;

@end

NS_ASSUME_NONNULL_END

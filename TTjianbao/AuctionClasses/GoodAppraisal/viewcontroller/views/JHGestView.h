//
//  JHGestView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/18.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGestView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (strong, nonatomic) UIView *gestView;
@property(strong,nonatomic) JHFinishBlock  hideComplete;

@end

NS_ASSUME_NONNULL_END

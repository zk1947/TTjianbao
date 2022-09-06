//
//  JHPresentBoxView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPresentBoxView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property (copy, nonatomic) JHActionBlock sendPresnt;

@end



NS_ASSUME_NONNULL_END

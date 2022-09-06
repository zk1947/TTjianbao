//
//  JHFansBaseView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbao.h"
#import "JHUIFactory.h"
#import "BaseView.h"
#import "CommHelp.h"
#import "JHGestView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHFansBaseView : UIView<UIGestureRecognizerDelegate>
-(void)HideAlert;

@end

NS_ASSUME_NONNULL_END

//
//  BindingPhoneViewController.h
//  TTjianbao
//  Descripiton:登录后,绑定手机号
//  Created by jiangchao on 2018/12/17.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@class LoginMode;

@interface BindingPhoneViewController : JHBaseViewExtController
@property(strong,nonatomic)  void(^ loginResult)( BOOL result);
@property(strong,nonatomic) LoginMode * loginMode;
@end

NS_ASSUME_NONNULL_END

//
//  LoginViewController.h
//  TTjianbao
//  Descripiton:登录
//  Created by jiangchao on 2018/11/26.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginMode.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : JHBaseViewExtController

@property (nonatomic, strong) NSDictionary *params;
@property(strong,nonatomic)  void(^ loginResult)(BOOL result);

@end

NS_ASSUME_NONNULL_END

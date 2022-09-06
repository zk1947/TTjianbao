//
//  VerifyCodeViewController.h
//  TTjianbao
//  Descripiton:输入验证码(四位)
//  Created by jiangchao on 2019/3/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VerifyCodeViewController : JHBaseViewExtController
@property(strong,nonatomic)  void(^ loginResult)( BOOL result);
@property(strong,nonatomic)  NSString * phoneNumber;

@property (nonatomic, strong) NSDictionary *params;
@end

NS_ASSUME_NONNULL_END

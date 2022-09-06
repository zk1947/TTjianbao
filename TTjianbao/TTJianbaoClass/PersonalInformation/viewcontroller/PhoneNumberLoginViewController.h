//
//  PhoneNumberLoginViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

@interface PhoneNumberLoginViewController : JHBaseViewExtController
@property(strong,nonatomic)  void(^ loginResult)( BOOL result);
@property (nonatomic, strong) NSDictionary *params;
@end



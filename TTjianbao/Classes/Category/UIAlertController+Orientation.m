//
//  UIAlertController+Orientation.m
//  TTjianbao
//
//  Created by Simon Blue on 17/3/22.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "UIAlertController+Orientation.h"

@implementation UIAlertController (Orientation)

//解决横屏Alertview的崩溃 强制重写
- (BOOL)shouldAutorotate {
    return NO;
}

@end

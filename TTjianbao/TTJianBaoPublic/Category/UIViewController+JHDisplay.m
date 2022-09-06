//
//  UIViewController+JHDisplay.m
//  TTjianbao
//
//  Created by user on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIViewController+JHDisplay.h"

@implementation UIViewController (JHDisplay)
+ (UIEdgeInsets)safeArea {
    if (@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.keyWindow.safeAreaInsets;
    } else {
        return UIEdgeInsetsZero;
    }
}

@end

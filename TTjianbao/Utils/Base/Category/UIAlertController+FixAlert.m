//
//  UIAlertController+FixAlert.m
//  TTjianbao
//
//  Created by wangyongchao on 2021/1/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIAlertController+FixAlert.h"

@implementation UIAlertController (FixAlert)

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.preferredStyle == UIAlertControllerStyleAlert) {
        __weak UIAlertController *pSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            [pSelf.view setCenter:CGPointMake(screenWidth / 2.0, screenHeight / 2.0)];
            [pSelf.view setNeedsDisplay];
        });
    }
}

@end

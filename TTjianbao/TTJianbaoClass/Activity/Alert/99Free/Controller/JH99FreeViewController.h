//
//  JH99FreeViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JH99FreeModel;
@interface JH99FreeViewController : UIViewController

@property (nonatomic, strong) JH99FreeModel *freeModel;
+ (void)get99FreeInfo;

@end

NS_ASSUME_NONNULL_END

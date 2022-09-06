//
//  JHQRViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/13.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHQRViewController : JHBaseViewExtController
@property (nonatomic, copy) void(^scanFinish)( NSString * _Nullable scanString, JHQRViewController *obj);
@property (nonatomic, copy)NSString *titleString;
- (void)dismissHud;
- (void)showHud;

//启动扫描
- (void)reStartDevice;

@end

NS_ASSUME_NONNULL_END

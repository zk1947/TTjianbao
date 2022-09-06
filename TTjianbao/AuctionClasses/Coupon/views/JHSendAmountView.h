//
//  JHSendAmountView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/29.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class CoponPackageMode;

@interface JHSendAmountView : BaseView
- (void)showAlert;
@property (nonatomic, strong)NSString *viewerId;
@end

@interface JHRecvAmountView : BaseView
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *desStringLabel;
@property (strong, nonatomic) CoponPackageMode *model;

- (void)showAlert;

@end
NS_ASSUME_NONNULL_END

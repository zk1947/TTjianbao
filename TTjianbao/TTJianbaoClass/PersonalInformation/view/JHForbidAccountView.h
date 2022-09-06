//
//  JHOrderApplyReturnView.h
//  TTjianbao
//
//  Created by jiang on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHOrderReturnMode;

@interface JHForbidAccountView : BaseView
@property(strong,nonatomic) JHOrderReturnMode* orderReturnMode;
@property(strong,nonatomic) NSArray* reasonArr;
@property (nonatomic, copy)NSString *customerId;
@end

NS_ASSUME_NONNULL_END


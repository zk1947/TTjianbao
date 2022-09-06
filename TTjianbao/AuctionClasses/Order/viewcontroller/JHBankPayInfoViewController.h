//
//  JHBankPayInfoViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBankPayInfoViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(strong,nonatomic) NSString* orderCode;
@end

NS_ASSUME_NONNULL_END

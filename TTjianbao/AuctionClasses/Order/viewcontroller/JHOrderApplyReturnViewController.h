//
//  JHOrderApplyReturnViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderApplyReturnViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(strong,nonatomic) OrderMode* orderMode;

@end

NS_ASSUME_NONNULL_END

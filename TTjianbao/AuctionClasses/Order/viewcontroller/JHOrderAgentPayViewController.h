//
//  JHOrderAgentPayViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/11/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderAgentPayViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(assign,nonatomic) double money;
@property(strong,nonatomic) OrderMode * orderMode;
@property(assign,nonatomic) int  payId;
@end

NS_ASSUME_NONNULL_END

//
//  JHOrderDetailViewController.h
//  TTjianbao
//  Created by jiangchao on 2019/1/26.
//  Copyright © 2019 Netease. All rights reserved.

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"
#import "JHOrderDetailMode.h"
#import "JHChatBusiness.h"
@interface JHOrderDetailViewController : JHBaseViewExtController

@property(strong,nonatomic) NSString* orderId;
@property(assign,nonatomic) BOOL  isSeller;
@property(assign,nonatomic) BOOL  isProblem;
@property(assign,nonatomic) JHOrderCategory  orderCategoryType;//订单类型
@property(strong,nonatomic) JHOrderDetailMode* orderMode;
@property(strong,nonatomic) NSString *stoneId;
@property(strong,nonatomic) NSString *orderCategory;

@end



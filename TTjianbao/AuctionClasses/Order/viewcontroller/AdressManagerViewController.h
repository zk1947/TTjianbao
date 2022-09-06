//
//  AdressManagerViewController.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/19.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
#import "AdressMode.h"
@interface AdressManagerViewController : JHBaseViewExtController
@property (strong,nonatomic)  NSString *orderId;//修改订单收货地址用
@property (nonatomic, copy) void (^selectedBlock) (AdressMode *model);
@property (nonatomic, copy) void (^deleteBlock) (AdressMode *model);
@end

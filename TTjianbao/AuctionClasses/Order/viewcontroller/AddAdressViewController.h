//
//  AddAdressViewController.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2017/1/20.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdressMode.h"
#import "JHBaseViewExtController.h"

@interface AddAdressViewController : JHBaseViewExtController
@property(assign,nonatomic)   BOOL isUpdateAdress;
@property(strong,nonatomic) AdressMode * adress;
@property (strong,nonatomic)  NSString *orderId;
//0是其他  1是订单管理  2是从订单确认页
@property (assign,nonatomic) NSInteger fromType;
-(void)reloadTable;
@end

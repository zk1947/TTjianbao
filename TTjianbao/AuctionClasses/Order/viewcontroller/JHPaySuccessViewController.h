//
//  PaySuccessViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

@interface JHPaySuccessViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString * orderId;
@property(strong,nonatomic) NSString * paymoney;
@end


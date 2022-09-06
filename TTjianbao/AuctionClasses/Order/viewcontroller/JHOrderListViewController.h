//
//  JHOrderListViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

@interface JHOrderListViewController : JHBaseViewExtController
@property(assign,nonatomic) BOOL  isSeller;
@property(assign,nonatomic) int currentIndex;
@property(assign,nonatomic) NSInteger bussId;
@property(strong,nonatomic) NSString* fromSource;
@end



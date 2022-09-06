//
//  JHPaySuccessView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/25.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHCustomizeOrderListViewController.h"
@protocol JHPaySuccessViewDelegate <NSObject>

@optional
-(void)lookOrderDetail;
-(void)backAction;
@end

#import "BaseView.h"

@interface JHPaySuccessView : BaseView
@property(strong,nonatomic) OrderMode * mode;
@property(strong,nonatomic) NSString * payMoney;
@property(weak,nonatomic)id<JHPaySuccessViewDelegate>delegate;
@end


//
//  JHNewOrderListViewController.h
//  TTjianbao
//合并订单列表
//  Created by jiangchao on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHNewOrderListViewController : JHBaseViewExtController
@property(assign,nonatomic) BOOL  isSeller; //暂时不支持卖家端 不要传YES
@property(assign,nonatomic) int currentIndex;
@end

NS_ASSUME_NONNULL_END

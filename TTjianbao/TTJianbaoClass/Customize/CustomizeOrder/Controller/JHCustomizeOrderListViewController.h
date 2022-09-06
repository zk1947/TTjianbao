//
//  JHCustomizeOrderListViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeOrderListViewController : JHBaseViewExtController
@property(assign,nonatomic) BOOL  isSeller;
@property(assign,nonatomic) int currentIndex;
@end

NS_ASSUME_NONNULL_END

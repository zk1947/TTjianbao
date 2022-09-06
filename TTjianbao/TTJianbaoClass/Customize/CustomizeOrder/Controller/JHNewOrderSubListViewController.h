//
//  JHNewOrderSubListViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXCategoryView.h"
#import "JHBaseViewExtController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHNewOrderSubListViewController : UIViewController<JXCategoryListContentViewDelegate>
@property(strong,nonatomic) NSString *status;
@property(assign,nonatomic) BOOL  isSeller;
@property(assign,nonatomic) int currentIndex;
@end

NS_ASSUME_NONNULL_END

//
//  JHMyBeanView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/3.
//  Copyright © 2019 Netease. All rights reserved.
//
#import <UIKit/UIKit.h>

@class JHBeanMoneyMode;
@protocol JHMyBeanViewDelegate <NSObject>

@optional
-(void)Complete:(JHBeanMoneyMode*)beanMoneyMode;
-(void)agreeMent;
- (void)didBeanRecod;
@end
#import "BaseView.h"

@interface JHMyBeanView : BaseView
@property(weak,nonatomic)id<JHMyBeanViewDelegate>delegate;
@property (strong, nonatomic)  NSArray <JHBeanMoneyMode *> *beanMoneyModes;
-(void)reloadBeanCount;
@end


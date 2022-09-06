//
//  JHCustomizePayCashView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizePayCashView : JHOrderSubBaseView
-(void)initShouldPayCashSubViews:(JHCustomizeOrderModel*)mode;
-(void)initConfirmOrderShouldPayCashSubViews:(JHOrderDetailMode*)mode;
@end

NS_ASSUME_NONNULL_END

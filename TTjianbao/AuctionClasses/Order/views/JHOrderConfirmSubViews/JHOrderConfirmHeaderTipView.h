//
//  JHOrderConfirmHeaderTipView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
@class JHOrderDetailMode;
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmHeaderTipView : UIView
@property(assign,nonatomic) CGFloat leftSpace;//左右间距
//@property(assign,nonatomic) NSString *desc;//
///提交订单
@property (strong, nonatomic) JHOrderDetailMode *submitOrdersMode;
-(void)initSubviews;

-(void)displayMarket;
@end

NS_ASSUME_NONNULL_END

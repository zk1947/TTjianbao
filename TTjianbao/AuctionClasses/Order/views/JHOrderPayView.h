//
//  JHOrderPayView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "BaseView.h"
#import "JHOrderHeaderTitleView.h"
NS_ASSUME_NONNULL_BEGIN

@class PayWayMode;
@protocol JHOrderPayViewDelegate <NSObject>

@optional
-(void)Complete:(PayWayMode*)mode;
-(void)Complete:(PayWayMode*)mode andPayMoney:(double)money;
@end

@interface JHOrderPayView : BaseView
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(strong,nonatomic) JHOrderDetailMode* orderMode;
@property(weak,nonatomic)id<JHOrderPayViewDelegate>delegate;
@property(strong,nonatomic) NSArray* payWayArray;

@property (nonatomic, assign) BOOL isAuction;//Yes-拍卖订单

- (void)dealAuctionUI;

@property(assign,nonatomic) BOOL directDelivery;

- (void)displayMarket;

///处理保证金支付场景UI
- (void)dealEarnestMoneyUI;

@end

NS_ASSUME_NONNULL_END

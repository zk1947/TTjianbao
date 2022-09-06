//
//  JHOrderHeaderTitleView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN
#define kHeaderH    140 //背景高度
@interface JHOrderHeaderTitleView : JHOrderSubBaseView
@property(assign,nonatomic) Boolean isGra;
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
@property(strong,nonatomic)JHCustomizeOrderModel * customizeOrderMode;

@property(strong,nonatomic)JHOrderDetailMode * graOrderMode;

@property (nonatomic, assign) BOOL isAuction;//Yes-拍卖订单

- (void)stopMyTimer;

@end

NS_ASSUME_NONNULL_END

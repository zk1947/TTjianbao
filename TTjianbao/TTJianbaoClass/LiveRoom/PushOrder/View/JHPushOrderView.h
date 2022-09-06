//
//  JHPushOrderView.h
//  TTjianbao
//
//  Created by apple on 2020/1/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPushOrderView : BaseView

@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, strong) OrderMode *model;

@end

NS_ASSUME_NONNULL_END
/*
 测试数据
 OrderMode *model = [OrderMode new];
 model.originOrderPrice = @"100.00";
 model.goodsUrl = @"http://sq-image.ttjianbao.com/images/2aa333e7fd61a7f1a4fb99eae9a90441.jpg?x-oss-process=image/resize,w_100";
 model.goodsTitle = @"测试";
 model.subtractPrice = @"20";// 折扣价
 model.couponValueList = @[@"a-10",@"b-10"];
 model.channelCategory = @"roughOrder";//原石订单
 model.overAmountFlag = NO;
 model.orderPrice = @"80";
 
 JHPushOrderView *orderView = [[JHPushOrderView alloc] initWithFrame:self.view.bounds];
 [self.view addSubview:orderView];
 orderView.model = model;
 [orderView showAlert];
 
 */

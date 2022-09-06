//
//  JHMyCenterMerchantBottomView.h
//  TTjianbao
//
//  Created by lihui on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
///个人中心 - 商家个人中心

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantBottomView : UIView

@property (nonatomic, copy) void (^changeHeightBlock)(CGFloat height);
@property (nonatomic, copy) NSArray *livingData;
@property (nonatomic, copy) NSArray *storeData;
/// 可提现金额
@property (nonatomic, copy) NSString *withDrawMoney;
/// 昨日成交金额
@property (nonatomic, copy) NSString *lastDayCompleteMoney;

@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, assign) NSInteger currentIndex;

///是否开通新服务 默认没有开通 显示空白页面
@property (nonatomic, assign) BOOL haveOpenNewService;
- (void)updateOrderInfo:(NSInteger)index;
- (void)changeContentOffset:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
